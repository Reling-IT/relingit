param(
    [ValidateRange(0, 9999)]
    [int]$PageCount = 0,
    [string]$Suffix = "",
    # Git-Stand, gegen den Handout- und FTP-Änderungen verglichen werden.
    # Standard: letzter Commit, der die veröffentlichte Geschichte geändert hat.
    [string]$VergleichMit = "",
    # Nur für den Notfall ohne Poppler: überspringt den Vergleich der
    # PDF-Version mit dem Deckblatt der HTML-Quelle. Die PDF dann von Hand prüfen.
    [switch]$OhnePdfVersionspruefung,
    # Wird an build-upload.ps1 weitergegeben: Paket ohne Podcast-MP3, z. B. für
    # Textkorrekturen. Die Live-MP3 bleiben beim Upload unverändert.
    [switch]$OhneAudio
)

# Einziger vorgesehener Ablauf für eine neue Story-Version:
# source prüfen -> lokale Veröffentlichung aktualisieren -> FTP-Paket bauen
# -> Werte und Dateien für den Admin-Bereich ausgeben (Standardweg, q15).
$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot

$sourceHtml = "source/fahrt-zum-kunden.html"
$sourcePdf = "source/Die-Fahrt-zum-Kunden.pdf"
$storyHtml = "story/current/fahrt-zum-kunden.html"
$storyPdf = "story/current/geschichte.pdf"

foreach ($file in @($sourceHtml, $sourcePdf)) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "Neue Quelldatei fehlt: $file"
    }
}

$html = Get-Content -Raw -LiteralPath $sourceHtml
$meta = [regex]::Match($html, '<div\s+class="cover-meta">(?<content>[\s\S]*?)</div>')
$versionMatch = [regex]::Match($meta.Groups['content'].Value, '<span>\s*Version\s+(?<version>\d+\.\d+)\s*</span>')
$dateMatch = [regex]::Match($meta.Groups['content'].Value, '<span>\s*(?<date>\d{2}\.\d{2}\.\d{4})\s*</span>')
$historyRows = [regex]::Matches(
    $html,
    '<tr>\s*<td>(?<version>\d+\.\d+)</td>\s*<td>(?<date>\d{2}\.\d{2}\.\d{4})</td>',
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)
if (-not $meta.Success -or -not $versionMatch.Success -or -not $dateMatch.Success -or $historyRows.Count -eq 0) {
    throw "Version oder Datum der neuen HTML-Datei ist nicht eindeutig lesbar."
}

$version = $versionMatch.Groups['version'].Value
$numericVersion = [version]$version
$latestHistory = $historyRows[$historyRows.Count - 1]
$historyVersions = @($historyRows | ForEach-Object { [version]$_.Groups['version'].Value })
$highestVersion = $historyVersions | Sort-Object -Descending | Select-Object -First 1
if ($numericVersion -ne $highestVersion) {
    throw "Deckblatt-Version $version ist nicht die höchste Version der Historie ($highestVersion)."
}
if ($latestHistory.Groups['version'].Value -ne $version) {
    throw "Der letzte Historieneintrag gehört nicht zu Version $version."
}
if ($latestHistory.Groups['date'].Value -ne $dateMatch.Groups['date'].Value) {
    throw "Deckblatt-Datum und Datum des letzten Historieneintrags widersprechen sich."
}
if ($html -match 'fonts\.(?:googleapis|gstatic)\.com') {
    throw "Die neue HTML-Datei enthält einen externen Google-Fonts-Aufruf."
}

$pdfStream = [System.IO.File]::OpenRead((Resolve-Path $sourcePdf))
try {
    $header = New-Object byte[] 5
    [void]$pdfStream.Read($header, 0, 5)
    if ([System.Text.Encoding]::ASCII.GetString($header) -ne "%PDF-") {
        throw "Die neue PDF-Datei besitzt keine gültige PDF-Kennung."
    }
} finally { $pdfStream.Dispose() }

# Wenn pdfinfo vorhanden ist, wird die Seitenzahl direkt aus der neuen PDF
# gelesen. Damit kann keine alte oder versehentlich geschätzte Zahl in die LP.
$pdfInfoCommand = Get-Command pdfinfo -ErrorAction SilentlyContinue
if ($pdfInfoCommand) {
    $pdfInfo = & $pdfInfoCommand.Source $sourcePdf
    $pageMatch = [regex]::Match(($pdfInfo -join "`n"), '(?m)^Pages:\s+(?<count>\d+)\s*$')
    if (-not $pageMatch.Success) { throw "PDF-Seitenzahl konnte nicht gelesen werden." }
    $detectedPageCount = [int]$pageMatch.Groups['count'].Value
    if ($PageCount -gt 0 -and $PageCount -ne $detectedPageCount) {
        throw "Angegebene Seitenzahl $PageCount widerspricht der PDF ($detectedPageCount)."
    }
    $PageCount = $detectedPageCount
} elseif ($PageCount -eq 0) {
    throw "pdfinfo fehlt. Bitte Seitenzahl ersatzweise mit -PageCount angeben."
}

# Die PDF muss zur HTML-Quelle passen: Die Version auf dem Deckblatt (erste
# Seite) wird per pdftotext gelesen und mit dem Deckblatt der HTML verglichen.
# So kann keine alte PDF neben einer neuen HTML veröffentlicht werden.
# Ohne pdftotext wird abgebrochen; nur der ausdrückliche Schalter
# -OhnePdfVersionspruefung lässt den Lauf mit sichtbarer Warnung weiter.
$pdfToTextCommand = Get-Command pdftotext -ErrorAction SilentlyContinue
if ($pdfToTextCommand) {
    $previousOutputEncoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    try {
        $coverText = (& $pdfToTextCommand.Source -f 1 -l 1 -enc UTF-8 $sourcePdf -) -join "`n"
        $pdfToTextExit = $LASTEXITCODE
    } finally { [Console]::OutputEncoding = $previousOutputEncoding }
    if ($pdfToTextExit -ne 0) {
        throw "pdftotext konnte die erste Seite von $sourcePdf nicht lesen (Exit-Code $pdfToTextExit)."
    }
    $pdfVersions = @([regex]::Matches($coverText, '\bVersion\s+(?<v>\d+\.\d+)\b') |
        ForEach-Object { $_.Groups['v'].Value } | Select-Object -Unique)
    if ($pdfVersions.Count -eq 0) {
        throw "Auf dem Deckblatt (Seite 1) von $sourcePdf steht keine lesbare Versionsangabe 'Version X.YY'."
    }
    if ($pdfVersions.Count -gt 1) {
        throw "Deckblatt von $sourcePdf nennt mehrere Versionen ($($pdfVersions -join ', ')); erwartet: $version."
    }
    if ($pdfVersions[0] -ne $version) {
        throw "PDF passt nicht zur HTML-Quelle: $sourcePdf trägt Version $($pdfVersions[0]), $sourceHtml Version $version. Bitte die PDF aus der aktuellen HTML neu erzeugen (docs/PDF-ERZEUGEN.md)."
    }
    Write-Host "OK: PDF-Deckblatt trägt Version $version wie die HTML-Quelle."
} elseif ($OhnePdfVersionspruefung) {
    Write-Warning "pdftotext fehlt; die PDF-Version wird auf ausdrücklichen Wunsch (-OhnePdfVersionspruefung) NICHT geprüft. Deckblatt von $sourcePdf bitte von Hand auf Version $version prüfen."
} else {
    throw "pdftotext fehlt (Poppler). Die PDF-Version kann nicht gegen das Deckblatt ($version) geprüft werden. Poppler installieren oder bewusst mit -OhnePdfVersionspruefung starten und die PDF von Hand prüfen."
}

$culture = [System.Globalization.CultureInfo]::GetCultureInfo('de-DE')
$releaseDate = [datetime]::ParseExact($dateMatch.Groups['date'].Value, 'dd.MM.yyyy', $culture)
$displayDate = $releaseDate.ToString('d. MMMM yyyy', $culture)

# Erst nach allen Eingangsprüfungen werden die öffentlichen Dateien ersetzt.
Copy-Item -LiteralPath $sourceHtml -Destination $storyHtml -Force
Copy-Item -LiteralPath $sourcePdf -Destination $storyPdf -Force

$appPath = "assets/js/app.js"
$app = Get-Content -Raw -LiteralPath $appPath
$app = [regex]::Replace($app, '(fallbackRelease\s*=\s*\{[\s\S]*?version:\s*")[^"]+("[\s\S]*?date:\s*")[^"]+("[\s\S]*?pageCount:\s*)\d+', "`${1}$version`${2}$displayDate`${3}$PageCount", 1)
Set-Content -LiteralPath $appPath -Value $app -Encoding utf8 -NoNewline

# Leseansicht und Anhang-Seite (R07) tragen denselben Rückfallstand.
foreach ($readerPath in @("lesen.html", "anhang.html")) {
    $reader = Get-Content -Raw -LiteralPath $readerPath
    $reader = [regex]::Replace($reader, '(<strong\s+id="story-release">)Version\s+[^<]+(</strong>)', "`${1}Version $version · $displayDate`${2}", 1)
    Set-Content -LiteralPath $readerPath -Value $reader -Encoding utf8 -NoNewline
}

# Die statische Seitenzahl der LP gilt ohne JavaScript und bis Supabase antwortet.
# Sie muss deshalb denselben Wert wie fallbackRelease erhalten.
$landingPath = "index.html"
$landing = Get-Content -Raw -LiteralPath $landingPath
$pageCountPattern = '(<span\s+data-page-count>)\d+(</span>)'
if ([regex]::Matches($landing, $pageCountPattern).Count -ne 1) {
    throw "Seitenzahl in $landingPath ist nicht eindeutig lesbar (<span data-page-count>)."
}
$landing = [regex]::Replace($landing, $pageCountPattern, "`${1}$PageCount`${2}", 1)
Set-Content -LiteralPath $landingPath -Value $landing -Encoding utf8 -NoNewline

& "$PSScriptRoot/ci-check.ps1"

# Alte FTP-Pakete bleiben wiederherstellbar, werden aber aus dem Upload-Ordner
# entfernt. So kann nicht versehentlich eine frühere ZIP-Datei gewählt werden.
$ftpOutput = Join-Path $projectRoot "output/ftp"
$oldPackages = @(Get-ChildItem -LiteralPath $ftpOutput -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like 'relingit-upload-v*' })
if ($oldPackages.Count -gt 0) {
    $archiveStamp = [datetime]::Now.ToString('yyyyMMdd-HHmmss-fff')
    $packageArchive = Join-Path $projectRoot "archive/ftp-packages/$archiveStamp"
    New-Item -ItemType Directory -Path $packageArchive -Force | Out-Null
    foreach ($oldPackage in $oldPackages) {
        Move-Item -LiteralPath $oldPackage.FullName -Destination $packageArchive
    }
}

& "$PSScriptRoot/build-upload.ps1" -Suffix $Suffix -OhneAudio:$OhneAudio

Write-Host "OK: Version $version vom $displayDate mit $PageCount Seiten veröffentlicht und paketiert."

# Übergabe an den Admin-Bereich. Seit der Entscheidung q15 (06.11.2026) ist
# admin.html mit Supabase der Standardweg für neue Buchfassungen. FTP ist nur
# nötig, wenn sich Startseite, JavaScript, Impressum oder Datenschutz ändern.
# Es wird nichts hochgeladen; die Ausgabe ist nur eine Anleitung.

# Vergleicht Zeilen ohne die Werte, die dieses Skript bei jedem Release selbst
# setzt (Rückfallwerte in app.js, Seitenzahl in index.html, Stand in lesen.html).
function ConvertTo-ReleaseNeutralLine([string]$line) {
    $line = $line.TrimEnd("`r")
    $line = $line -replace '(version:\s*")[^"]*(")', '${1}X${2}'
    $line = $line -replace '(date:\s*")[^"]*(")', '${1}X${2}'
    $line = $line -replace '(pageCount:\s*)\d+', '${1}X'
    $line = $line -replace '(data-page-count>)\d+(<)', '${1}X${2}'
    $line = $line -replace '(id="story-release">)Version\s+[^<]+(<)', '${1}X${2}'
    return $line
}

# Wahr, wenn sich eine Datei gegenüber dem Vergleichsstand nur in diesen Werten unterscheidet.
function Test-OnlyReleaseValues([string]$baseline, [string]$path) {
    $removed = [System.Collections.Generic.List[string]]::new()
    $added = [System.Collections.Generic.List[string]]::new()
    foreach ($line in @(& git -c core.quotepath=false diff -U0 --no-color $baseline -- $path)) {
        if ($line -match '^(---|\+\+\+) ' -or $line -match '^\\') { continue }
        if ($line.StartsWith('-')) { $removed.Add((ConvertTo-ReleaseNeutralLine $line.Substring(1))) }
        elseif ($line.StartsWith('+')) { $added.Add((ConvertTo-ReleaseNeutralLine $line.Substring(1))) }
    }
    if ($removed.Count -eq 0 -and $added.Count -eq 0) { return $false }
    return ((@($removed | Sort-Object) -join "`n") -ceq (@($added | Sort-Object) -join "`n"))
}

# Geänderte und neue (noch nicht versionierte) Dateien gegenüber dem Vergleichsstand.
function Get-ChangedPublicFiles([string]$baseline, [string[]]$paths) {
    $changed = @(& git -c core.quotepath=false diff --name-only $baseline -- @paths)
    $changed += @(& git -c core.quotepath=false ls-files --others --exclude-standard -- @paths)
    return @($changed | Where-Object { $_ } | Sort-Object -Unique)
}

Write-Host ""
Write-Host "=== Übergabe an den Admin-Bereich (admin.html, Standardweg) ==="
Write-Host "Versionsnummer:    $version"
Write-Host "Angezeigtes Datum: $displayDate"
Write-Host "Seitenzahl:        $PageCount"
Write-Host "HTML-Lesefassung:  $(Join-Path $projectRoot $sourceHtml)"
Write-Host "PDF:               $(Join-Path $projectRoot $sourcePdf)"

$gitCommand = Get-Command git -ErrorAction SilentlyContinue
$baseline = $VergleichMit
if ($gitCommand -and -not $baseline) {
    $baseline = (& git log -1 --format=%H -- $storyHtml 2>$null | Select-Object -First 1)
}
if ($baseline -and $gitCommand) {
    $baselineLabel = (& git log -1 --format='%h %ad %s' --date=short $baseline 2>$null | Select-Object -First 1)
}
if (-not $gitCommand -or -not $baselineLabel) {
    Write-Host "Handout und FTP-Bedarf: nicht ermittelbar (kein Git-Vergleichsstand). Bitte von Hand prüfen."
} else {
    Write-Host "Vergleichsstand:   $baselineLabel"

    $handoutFiles = @("story/current/workshop-handout.html", "story/current/workshop-handout.pdf")
    if ((Get-ChangedPublicFiles $baseline $handoutFiles).Count -gt 0) {
        Write-Host "Handout geändert:  ja. Im Admin-Bereich beide Dateien als Paar auswählen:"
        foreach ($file in $handoutFiles) { Write-Host "                   $(Join-Path $projectRoot $file)" }
    } else {
        Write-Host "Handout geändert:  nein. Im Admin-Bereich kein Handout auswählen."
    }

    # FTP-relevant laut Entscheidung q15.
    $ftpPaths = @("index.html", "assets/js", "impressum.html", "datenschutz.html")
    # Weitere öffentliche Dateien, die ebenfalls nur per FTP auf den Webspace kommen.
    $otherPublicPaths = @(".htaccess", "lesen.html", "anhang.html", "pdf.html", "handout.html", "handout-pdf.html", "admin.html", "assets/css", "assets/img")

    $ftpReasons = @()
    $fallbackOnly = @()
    foreach ($file in (Get-ChangedPublicFiles $baseline $ftpPaths)) {
        if (Test-OnlyReleaseValues $baseline $file) { $fallbackOnly += $file } else { $ftpReasons += $file }
    }
    $otherChanged = @()
    foreach ($file in (Get-ChangedPublicFiles $baseline $otherPublicPaths)) {
        if (Test-OnlyReleaseValues $baseline $file) { $fallbackOnly += $file } else { $otherChanged += $file }
    }

    if ($ftpReasons.Count -gt 0) {
        Write-Host "FTP-Upload nötig:  ja, geändert: $($ftpReasons -join ', ')"
        Write-Host "                   Paket: output/ftp (siehe oben). Upload erfolgt von Hand."
    } else {
        Write-Host "FTP-Upload nötig:  nein"
    }
    if ($fallbackOnly.Count -gt 0) {
        Write-Host "Nur Rückfallwerte: $($fallbackOnly -join ', ') (Version, Datum, Seitenzahl)."
        Write-Host "                   Die Live-Seite liest diese Werte aus Supabase; ein FTP-Upload hält nur die Rückfallwerte aktuell."
    }
    if ($otherChanged.Count -gt 0) {
        Write-Host "Hinweis:           weitere öffentliche Dateien geändert: $($otherChanged -join ', '). Bitte prüfen, ob sie per FTP hochgeladen werden müssen."
    }
}
