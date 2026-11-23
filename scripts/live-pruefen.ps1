# Live-Prüfung nach einem Upload (R87, R09), nur lesend.
#
# Leitet die Sollwerte aus story/current, assets/js/app.js und index.html ab
# und vergleicht sie mit dem Live-Stand:
#   - Supabase-Tabelle story_release (id=current): Version, Datum, Seitenzahl
#   - Supabase-Speicher story/current: die vier Dateien (SHA-256)
#   - Webspace: index.html und assets/js/app.js gegen den lokalen Stand
#
# Gelesen wird mit dem öffentlichen Schlüssel aus assets/js/supabase-config.js,
# so wie die Live-Seite selbst. Das Skript schreibt nichts, weder lokal noch in
# Supabase oder auf den Webspace, und kennt keinen Schlüssel mit Schreibrecht.
#
# Textdateien (HTML, JS) werden nach Normalisierung der Zeilenenden (CRLF zu LF)
# verglichen, PDF-Dateien byteweise.
#
# Aufruf:
#   ./scripts/live-pruefen.ps1                # Abgleich, Ausgabe Soll/Ist/Ergebnis
#   ./scripts/live-pruefen.ps1 -NurSollwerte  # nur Sollwerte als Markdown, ohne Netz
#   ./scripts/publish-release.ps1 -NurPruefen # gleichwertig zum Abgleich
#
# Exit-Code: 0 alles gleich, 1 mindestens eine Abweichung, 2 Fehler (Sollwerte
# nicht ableitbar oder Live-Stand nicht abrufbar).
param(
    [switch]$NurSollwerte,
    [string]$SiteUrl = "https://berndmarnau.de/relingit",
    [string]$Projekt = ""
)

$script:StoryDateien = @(
    [pscustomobject]@{ Name = "geschichte.pdf";        Text = $false }
    [pscustomobject]@{ Name = "fahrt-zum-kunden.html"; Text = $true }
    [pscustomobject]@{ Name = "workshop-handout.pdf";  Text = $false }
    [pscustomobject]@{ Name = "workshop-handout.html"; Text = $true }
)
$script:WebspaceDateien = @("index.html", "assets/js/app.js")
$script:UserAgent = "relingit-live-pruefen/1.0"

# Bytes mit LF statt CRLF. ISO-8859-1 bildet jedes Byte 1:1 auf ein Zeichen ab,
# daher bleibt der übrige Inhalt (auch UTF-8) unverändert.
function ConvertTo-LfBytes([byte[]]$Bytes) {
    $latin1 = [System.Text.Encoding]::GetEncoding(28591)
    return $latin1.GetBytes($latin1.GetString($Bytes).Replace("`r`n", "`n"))
}

# Ersetzt die Rückfallwerte, die publish-release.ps1 bei jedem Release setzt,
# durch X (gleiche Regeln wie ConvertTo-ReleaseNeutralLine dort). Ändert sich
# nur die Buchfassung, ist ein FTP-Upload nicht nötig (q15); die Webspace-Dateien
# dürfen dann in genau diesen Werten vom lokalen Stand abweichen.
function ConvertTo-ReleaseNeutralBytes([byte[]]$Bytes) {
    $latin1 = [System.Text.Encoding]::GetEncoding(28591)
    $text = $latin1.GetString($Bytes)
    $text = $text -replace '(version:\s*")[^"]*(")', '${1}X${2}'
    $text = $text -replace '(date:\s*")[^"]*(")', '${1}X${2}'
    $text = $text -replace '(pageCount:\s*)\d+', '${1}X'
    $text = $text -replace '(data-page-count>)\d+(<)', '${1}X${2}'
    $text = $text -replace '(id="story-release">)Version\s+[^<]+(<)', '${1}X${2}'
    return $latin1.GetBytes($text)
}

# SHA-256 (klein geschrieben) und Größe einer Datei; Textdateien normalisiert,
# mit -OhneRueckfallwerte zusätzlich ohne die Release-Rückfallwerte.
function Get-InhaltsHash {
    param([Parameter(Mandatory)][string]$Pfad, [switch]$Text, [switch]$OhneRueckfallwerte)
    $bytes = [System.IO.File]::ReadAllBytes($Pfad)
    if ($Text -or $OhneRueckfallwerte) { $bytes = ConvertTo-LfBytes $bytes }
    if ($OhneRueckfallwerte) { $bytes = ConvertTo-ReleaseNeutralBytes $bytes }
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $hash = ([System.BitConverter]::ToString($sha.ComputeHash($bytes)) -replace '-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
    return [pscustomobject]@{ Hash = $hash; Groesse = $bytes.Length }
}

# "16.11.2026" -> "16. November 2026" (wie publish-release.ps1).
function ConvertTo-Anzeigedatum([string]$Datum) {
    $culture = [System.Globalization.CultureInfo]::GetCultureInfo('de-DE')
    return [datetime]::ParseExact($Datum, 'dd.MM.yyyy', $culture).ToString('d. MMMM yyyy', $culture)
}

# Seitenzahl per pdfinfo; $null, wenn pdfinfo fehlt oder nichts liefert.
function Get-PdfSeitenzahl([string]$Pfad) {
    $pdfinfo = Get-Command pdfinfo -ErrorAction SilentlyContinue
    if (-not $pdfinfo) { return $null }
    $info = (& $pdfinfo.Source $Pfad 2>$null) -join "`n"
    $treffer = [regex]::Match($info, '(?m)^Pages:\s+(\d+)\s*$')
    if (-not $treffer.Success) { return $null }
    return [int]$treffer.Groups[1].Value
}

# Sollwerte aus dem lokalen Stand (normalerweise main). Wirft bei Widersprüchen.
function Get-ReleaseSoll {
    param([Parameter(Mandatory)][string]$Projekt)
    $storyHtml = Join-Path $Projekt "story/current/fahrt-zum-kunden.html"
    $html = [System.IO.File]::ReadAllText($storyHtml)
    $meta = [regex]::Match($html, '<div\s+class="cover-meta">(?<inhalt>[\s\S]*?)</div>')
    $version = [regex]::Match($meta.Groups['inhalt'].Value, '<span>\s*Version\s+(?<v>\d+\.\d+)\s*</span>')
    $datum = [regex]::Match($meta.Groups['inhalt'].Value, '<span>\s*(?<d>\d{2}\.\d{2}\.\d{4})\s*</span>')
    if (-not $meta.Success -or -not $version.Success -or -not $datum.Success) {
        throw "Version oder Datum im Deckblatt von story/current/fahrt-zum-kunden.html nicht lesbar."
    }

    $app = [System.IO.File]::ReadAllText((Join-Path $Projekt "assets/js/app.js"))
    $rueckfall = [regex]::Match($app, 'fallbackRelease\s*=\s*\{[\s\S]*?version:\s*"(?<v>[^"]+)"[\s\S]*?date:\s*"(?<d>[^"]+)"[\s\S]*?pageCount:\s*(?<p>\d+)')
    if (-not $rueckfall.Success) { throw "fallbackRelease in assets/js/app.js nicht lesbar." }
    $index = [System.IO.File]::ReadAllText((Join-Path $Projekt "index.html"))
    $statisch = [regex]::Matches($index, '<span\s+data-page-count>(\d+)</span>')
    if ($statisch.Count -ne 1) { throw "Seitenzahl in index.html nicht eindeutig lesbar (<span data-page-count>)." }

    $anzeigedatum = ConvertTo-Anzeigedatum $datum.Groups['d'].Value
    $pdfSeiten = Get-PdfSeitenzahl (Join-Path $Projekt "story/current/geschichte.pdf")
    $seiten = if ($null -ne $pdfSeiten) { $pdfSeiten } else { [int]$rueckfall.Groups['p'].Value }

    $widersprueche = @()
    if ($rueckfall.Groups['v'].Value -ne $version.Groups['v'].Value) { $widersprueche += "app.js version $($rueckfall.Groups['v'].Value) statt $($version.Groups['v'].Value)" }
    if ($rueckfall.Groups['d'].Value -ne $anzeigedatum) { $widersprueche += "app.js date '$($rueckfall.Groups['d'].Value)' statt '$anzeigedatum'" }
    if ([int]$rueckfall.Groups['p'].Value -ne $seiten) { $widersprueche += "app.js pageCount $($rueckfall.Groups['p'].Value) statt $seiten" }
    if ([int]$statisch[0].Groups[1].Value -ne $seiten) { $widersprueche += "index.html data-page-count $($statisch[0].Groups[1].Value) statt $seiten" }
    if ($widersprueche.Count -gt 0) {
        throw "Sollwerte widersprechen sich im lokalen Stand: $($widersprueche -join '; ')."
    }

    $dateien = foreach ($datei in $script:StoryDateien) {
        $h = Get-InhaltsHash -Pfad (Join-Path $Projekt "story/current/$($datei.Name)") -Text:$datei.Text
        [pscustomobject]@{ Name = $datei.Name; Text = $datei.Text; Hash = $h.Hash; Groesse = $h.Groesse }
    }
    $webspace = foreach ($pfad in $script:WebspaceDateien) {
        $h = Get-InhaltsHash -Pfad (Join-Path $Projekt $pfad) -OhneRueckfallwerte
        [pscustomobject]@{ Pfad = $pfad; Hash = $h.Hash; Groesse = $h.Groesse }
    }
    return [pscustomobject]@{
        Version          = $version.Groups['v'].Value
        Datum            = $anzeigedatum
        Seiten           = $seiten
        SeitenQuelle     = $(if ($null -ne $pdfSeiten) { "pdfinfo story/current/geschichte.pdf" } else { "assets/js/app.js (pdfinfo fehlt)" })
        Dateien          = @($dateien)
        Webspace         = @($webspace)
    }
}

# Abschnitt "Supabase und Speicher" für die Upload-Checkliste (Markdown).
function Format-SollwerteMarkdown {
    param([Parameter(Mandatory)]$Soll, [string]$Stand = "")
    $zeilen = @()
    $zeilen += "## Supabase und Speicher"
    $zeilen += ""
    if ($Stand) { $zeilen += "Sollwerte abgeleitet aus $Stand mit ``scripts/live-pruefen.ps1 -NurSollwerte``."; $zeilen += "" }
    $zeilen += "Reihenfolge: 1. FTP-Paket (falls nötig), 2. Admin-Bereich: Eintrag ``story_release``, 3. Admin-Bereich: Dateien in ``story/current``, 4. Live-Prüfung mit ``./scripts/publish-release.ps1 -NurPruefen`` (Exit 0)."
    $zeilen += ""
    $zeilen += "Ein FTP-Upload ändert die Startseitenzeile (Version, Seiten, Datum) und die Links zu PDF, Handout und Lesefassung nicht: Sie kommen aus Supabase. Zeigt die Seite Altes, zuerst privates Fenster oder hartes Neuladen, dann Supabase prüfen."
    $zeilen += ""
    $zeilen += "| Feld in ``story_release`` (id=current) | Sollwert |"
    $zeilen += "|---|---|"
    $zeilen += "| version | $($Soll.Version) |"
    $zeilen += "| display_date | $($Soll.Datum) |"
    $zeilen += "| page_count | $($Soll.Seiten) (Quelle: $($Soll.SeitenQuelle)) |"
    $zeilen += ""
    $zeilen += "| Datei in ``story/current`` | Größe (Byte) | SHA-256 |"
    $zeilen += "|---|---|---|"
    foreach ($datei in $Soll.Dateien) {
        $hinweis = if ($datei.Text) { " (Zeilenenden LF)" } else { "" }
        $zeilen += "| $($datei.Name) | $($datei.Groesse)$hinweis | ``$($datei.Hash)`` |"
    }
    return ($zeilen -join "`n")
}

# Vergleich Soll gegen Ist. Ist ist ein Objekt wie von Get-LiveIst; ein Feld
# mit $null gilt als nicht abrufbar. Liefert eine Zeile je Prüfpunkt.
function Compare-LiveStand {
    param([Parameter(Mandatory)]$Soll, [Parameter(Mandatory)]$Ist)
    $zeilen = [System.Collections.Generic.List[object]]::new()
    function Add-Zeile($Pruefpunkt, $SollWert, $IstWert) {
        $ergebnis = if ($null -eq $IstWert) { "NICHT ABRUFBAR" } elseif ("$SollWert" -ceq "$IstWert") { "OK" } else { "ABWEICHUNG" }
        $istText = if ($null -eq $IstWert) { "-" } else { "$IstWert" }
        $zeilen.Add([pscustomobject]@{ Pruefpunkt = $Pruefpunkt; Soll = "$SollWert"; Ist = $istText; Ergebnis = $ergebnis })
    }
    $release = $Ist.Release
    Add-Zeile "story_release version" $Soll.Version $(if ($release) { $release.version })
    Add-Zeile "story_release display_date" $Soll.Datum $(if ($release) { $release.display_date })
    Add-Zeile "story_release page_count" $Soll.Seiten $(if ($release) { $release.page_count })
    foreach ($datei in $Soll.Dateien) {
        $istHash = $null
        if ($Ist.Dateien -and $Ist.Dateien.ContainsKey($datei.Name)) { $istHash = $Ist.Dateien[$datei.Name] }
        Add-Zeile "Speicher story/current/$($datei.Name)" $datei.Hash $istHash
    }
    foreach ($datei in $Soll.Webspace) {
        $istHash = $null
        if ($Ist.Webspace -and $Ist.Webspace.ContainsKey($datei.Pfad)) { $istHash = $Ist.Webspace[$datei.Pfad] }
        Add-Zeile "Webspace $($datei.Pfad) (ohne Rückfallwerte)" $datei.Hash $istHash
    }
    return $zeilen.ToArray()
}

# Öffentliche Supabase-Konfiguration aus assets/js/supabase-config.js.
function Get-SupabaseOeffentlich([string]$Projekt) {
    $konfig = [System.IO.File]::ReadAllText((Join-Path $Projekt "assets/js/supabase-config.js"))
    $url = [regex]::Match($konfig, 'url:\s*"(?<u>https://[^"]+)"').Groups['u'].Value
    $schluessel = [regex]::Match($konfig, 'publishableKey:\s*"(?<k>[^"]+)"').Groups['k'].Value
    if (-not $url -or -not $schluessel) { throw "assets/js/supabase-config.js enthält keine öffentliche Konfiguration." }
    return [pscustomobject]@{ Url = $url.TrimEnd('/'); Schluessel = $schluessel }
}

# Lädt eine URL ohne Cache in eine Datei; $null bei Fehler.
function Get-OhneCache([string]$Url, [string]$Ziel, [hashtable]$Kopf = @{}) {
    $kopf = @{ "Cache-Control" = "no-cache"; Pragma = "no-cache" } + $Kopf
    try {
        # Eigener User-Agent: Supabase behandelt den Standard-User-Agent von PowerShell wie einen Browser.
        Invoke-WebRequest -Uri $Url -Headers $kopf -UserAgent $script:UserAgent -OutFile $Ziel -ErrorAction Stop | Out-Null
        return $Ziel
    } catch {
        Write-Warning "Nicht abrufbar: $Url ($($_.Exception.Message))"
        return $null
    }
}

# Live-Stand lesen (nur GET, öffentlicher Schlüssel, ohne Cache).
function Get-LiveIst {
    param([Parameter(Mandatory)]$Soll, [Parameter(Mandatory)]$Supabase, [Parameter(Mandatory)][string]$SiteUrl)
    $ordner = Join-Path ([System.IO.Path]::GetTempPath()) ("relingit-live-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $ordner -Force | Out-Null
    try {
        $nonce = [DateTime]::UtcNow.ToString("yyyyMMddHHmmssfff")
        $release = $null
        $datei = Get-OhneCache "$($Supabase.Url)/rest/v1/story_release?id=eq.current&select=version,display_date,page_count" (Join-Path $ordner "release.json") @{ apikey = $Supabase.Schluessel }
        if ($datei) {
            $zeilen = @([System.IO.File]::ReadAllText($datei) | ConvertFrom-Json)
            if ($zeilen.Count -eq 1) { $release = $zeilen[0] } else { Write-Warning "story_release id=current: $($zeilen.Count) Zeilen statt 1." }
        }
        $dateien = @{}
        # Schleifenvariablen bewusst nicht $soll: PowerShell unterscheidet keine
        # Groß- und Kleinschreibung, $soll würde den Parameter $Soll überschreiben.
        foreach ($sollDatei in $Soll.Dateien) {
            $ziel = Get-OhneCache "$($Supabase.Url)/storage/v1/object/public/story/current/$($sollDatei.Name)?nc=$nonce" (Join-Path $ordner "sb-$($sollDatei.Name)")
            if ($ziel) { $dateien[$sollDatei.Name] = (Get-InhaltsHash -Pfad $ziel -Text:$sollDatei.Text).Hash }
        }
        $webspace = @{}
        foreach ($sollWeb in $Soll.Webspace) {
            $ziel = Get-OhneCache "$($SiteUrl.TrimEnd('/'))/$($sollWeb.Pfad)?nc=$nonce" (Join-Path $ordner ("web-" + ($sollWeb.Pfad -replace '[/\\]', '_')))
            if ($ziel) { $webspace[$sollWeb.Pfad] = (Get-InhaltsHash -Pfad $ziel -OhneRueckfallwerte).Hash }
        }
        return [pscustomobject]@{ Release = $release; Dateien = $dateien; Webspace = $webspace }
    } finally {
        Remove-Item -LiteralPath $ordner -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Hauptablauf nur bei direktem Aufruf, nicht beim Dot-Sourcing (Tests).
if ($MyInvocation.InvocationName -ne '.') {
    $ErrorActionPreference = "Stop"
    if (-not $Projekt) { $Projekt = Split-Path -Parent $PSScriptRoot }
    try {
        $soll = Get-ReleaseSoll -Projekt $Projekt
    } catch {
        Write-Host "FEHLER: $($_.Exception.Message)"
        exit 2
    }
    $stand = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $stand = (& git -C $Projekt log -1 --format="%h (%ad)" --date=short 2>$null | Select-Object -First 1)
        $zweig = (& git -C $Projekt branch --show-current 2>$null | Select-Object -First 1)
        if ($zweig) { $stand = "$stand, Branch $zweig" }
        # Die Sollwerte gelten nur für den Stand von main ohne lokale Änderungen.
        $kopf = (& git -C $Projekt rev-parse HEAD 2>$null | Select-Object -First 1)
        $main = (& git -C $Projekt rev-parse --verify --quiet origin/main 2>$null | Select-Object -First 1)
        $geaendert = @(& git -C $Projekt status --porcelain --untracked-files=no 2>$null)
        if ($main -and $kopf -ne $main) { Write-Warning "Sollstand ist nicht origin/main ($stand). Für die Live-Prüfung main auschecken (nach git fetch)." }
        if ($geaendert.Count -gt 0) { Write-Warning "Lokale Änderungen im Arbeitsverzeichnis ($($geaendert.Count) Dateien); die Sollwerte stammen nicht aus einem Commit." }
    }
    if ($NurSollwerte) {
        Write-Output (Format-SollwerteMarkdown -Soll $soll -Stand $(if ($stand) { "Stand $stand" } else { "" }))
        exit 0
    }

    try {
        $supabase = Get-SupabaseOeffentlich $Projekt
    } catch {
        Write-Host "FEHLER: $($_.Exception.Message)"
        exit 2
    }
    Write-Host "Live-Prüfung (nur lesend), Abruf $([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')), Sollstand $stand"
    $ist = Get-LiveIst -Soll $soll -Supabase $supabase -SiteUrl $SiteUrl
    $ergebnis = Compare-LiveStand -Soll $soll -Ist $ist
    $ergebnis | Format-Table -AutoSize -Wrap Pruefpunkt, Soll, Ist, Ergebnis | Out-String -Width 220 | Write-Host

    $nichtAbrufbar = @($ergebnis | Where-Object Ergebnis -eq "NICHT ABRUFBAR").Count
    $abweichend = @($ergebnis | Where-Object Ergebnis -eq "ABWEICHUNG").Count
    if ($nichtAbrufbar -gt 0) {
        Write-Host "FEHLER: $nichtAbrufbar Prüfpunkt(e) nicht abrufbar."
        exit 2
    }
    if ($abweichend -gt 0) {
        Write-Host "ABWEICHUNG: $abweichend Prüfpunkt(e). Zuerst privates Fenster oder hartes Neuladen, dann Supabase (Admin-Bereich) und FTP prüfen."
        exit 1
    }
    Write-Host "OK: Live-Stand entspricht dem Sollstand."
    exit 0
}
