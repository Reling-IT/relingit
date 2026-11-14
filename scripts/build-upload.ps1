param(
    [string]$Suffix = "",
    # Baut ein Paket ohne die vier Podcast-MP3 (z. B. für Textkorrekturen).
    # Die MP3 werden dann weder verlangt noch in ZIP und Manifest aufgenommen;
    # beim Upload bleiben die Live-MP3 unverändert. Der Paketname erhält den
    # Zusatz "-ohne-audio".
    [switch]$OhneAudio
)

# Erstellt ein geprüftes FTP-Paket ausschließlich aus den öffentlichen Dateien.
$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot

# Ohne erfolgreiche Qualitäts- und Metadatenprüfung wird kein Paket gebaut.
& "$PSScriptRoot/ci-check.ps1"

$appText = Get-Content -Raw -LiteralPath "assets/js/app.js"
$release = [regex]::Match(
    $appText,
    'fallbackRelease\s*=\s*\{[\s\S]*?version:\s*"(?<version>[^"]+)"[\s\S]*?date:\s*"(?<date>[^"]+)"'
)
if (-not $release.Success) { throw "Version und Datum konnten nicht gelesen werden." }

$version = $release.Groups['version'].Value.Trim()
$culture = [System.Globalization.CultureInfo]::GetCultureInfo('de-DE')
$releaseDate = [datetime]::ParseExact(
    $release.Groups['date'].Value.Trim(),
    'd. MMMM yyyy',
    $culture
)
$dateStamp = $releaseDate.ToString('yyyy-MM-dd')
$suffixPart = if ([string]::IsNullOrWhiteSpace($Suffix)) { "" } else { "-$Suffix" }
if ($OhneAudio) { $suffixPart += "-ohne-audio" }
$packageName = "relingit-upload-v$version-$dateStamp$suffixPart"
$outputRoot = Join-Path $projectRoot "output/ftp"
$packageDirectory = Join-Path $outputRoot $packageName
$zipPath = "$packageDirectory.zip"

if ((Test-Path -LiteralPath $packageDirectory) -or (Test-Path -LiteralPath $zipPath)) {
    throw "Paket existiert bereits: $packageName. Bitte einen anderen -Suffix angeben."
}

$publicFiles = @(
    ".htaccess", "admin.html", "datenschutz.html", "handout-pdf.html",
    "handout.html", "impressum.html", "index.html", "lesen.html", "pdf.html",
    "assets/css/legal.css", "assets/css/styles.css",
    # Webschriften der Geschichte (R27); lesen.html und story/current laden sie von hier.
    "assets/fonts/Fraunces-Variable.woff2", "assets/fonts/WorkSans-Regular.woff2",
    "assets/fonts/WorkSans-Italic.woff2", "assets/fonts/WorkSans-Bold.woff2",
    "assets/fonts/IBMPlexMono-Regular.woff2", "assets/fonts/IBMPlexMono-Italic.woff2",
    "assets/fonts/IBMPlexMono-Medium.woff2",
    "assets/fonts/Fraunces-OFL.txt", "assets/fonts/WorkSans-OFL.txt",
    "assets/fonts/IBMPlexMono-OFL.txt", "assets/fonts/HERKUNFT.txt",
    "assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3",
    "assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3",
    "assets/audio/warum-ki-nicht-lenken-darf.mp3",
    "assets/audio/roman-als-ki-blaupause.mp3",
    "assets/img/favicon.png", "assets/img/reling-it-logo.svg",
    "assets/img/reling-it-podcast-cover.png",
    # Bildmarken von Navis und Lumen auf der Startseite (R11); Ancora bleibt draußen.
    "assets/img/avatare/navis.svg", "assets/img/avatare/lumen.svg",
    "assets/js/admin.js", "assets/js/app.js", "assets/js/handout-viewer.js",
    "assets/js/pdf-viewer.js", "assets/js/story-viewer.js",
    "assets/js/supabase-config.js",
    "story/current/fahrt-zum-kunden.html", "story/current/geschichte.pdf",
    "story/current/workshop-handout.html", "story/current/workshop-handout.pdf"
)

# Die MP3 liegen nicht im Repository (docs/PODCAST.md). Mit -OhneAudio werden sie
# aus der Paketliste genommen; alle weiteren Prüfungen gelten dann für die
# verkleinerte Liste.
$audioFiles = @($publicFiles | Where-Object { $_ -like "assets/audio/*.mp3" })
if ($OhneAudio) {
    $publicFiles = @($publicFiles | Where-Object { $_ -notin $audioFiles })
}

# Fehlt eine Datei, wird abgebrochen, bevor ein Paketordner entsteht. So kann
# ohne -OhneAudio kein Paket ohne Podcast entstehen, das den Abschnitt live
# beschädigen würde.
$missingPublicFiles = @($publicFiles | Where-Object { -not (Test-Path -LiteralPath (Join-Path $projectRoot $_) -PathType Leaf) })
if ($missingPublicFiles.Count -gt 0) {
    throw "Paket abgebrochen, Dateien fehlen: $($missingPublicFiles -join ', '). Podcast-Dateien aus der lokalen Ablage kopieren (siehe docs/PODCAST.md) oder mit -OhneAudio bauen."
}

# Die lokalen MP3 müssen bytegenau den versionierten Prüfsummen in
# assets/audio/SHA256SUMS.txt entsprechen. Sonst würde eine veraltete oder
# beschädigte Folge hochgeladen.
if (-not $OhneAudio) {
    $sumsPath = Join-Path $projectRoot "assets/audio/SHA256SUMS.txt"
    if (-not (Test-Path -LiteralPath $sumsPath -PathType Leaf)) {
        throw "Paket abgebrochen, assets/audio/SHA256SUMS.txt fehlt."
    }
    $expectedHashes = @{}
    foreach ($line in (Get-Content -LiteralPath $sumsPath -Encoding utf8)) {
        $sumMatch = [regex]::Match($line, '^(?<hash>[0-9a-fA-F]{64}) [ *](?<name>\S+)$')
        if ($sumMatch.Success) { $expectedHashes[$sumMatch.Groups['name'].Value] = $sumMatch.Groups['hash'].Value.ToUpperInvariant() }
    }
    $hashFailures = [System.Collections.Generic.List[string]]::new()
    foreach ($audioFile in $audioFiles) {
        $audioName = Split-Path -Leaf $audioFile
        if (-not $expectedHashes.ContainsKey($audioName)) {
            $hashFailures.Add("$audioFile (keine Prüfsumme in SHA256SUMS.txt)")
            continue
        }
        $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $projectRoot $audioFile)).Hash
        if ($actualHash -ne $expectedHashes[$audioName]) { $hashFailures.Add("$audioFile (Prüfsumme weicht ab)") }
    }
    if ($hashFailures.Count -gt 0) {
        throw "Paket abgebrochen, Podcast-Dateien passen nicht zu assets/audio/SHA256SUMS.txt: $($hashFailures -join '; ')"
    }
    Write-Host "OK: $($audioFiles.Count) Podcast-MP3 entsprechen assets/audio/SHA256SUMS.txt."
}

New-Item -ItemType Directory -Path $packageDirectory | Out-Null
foreach ($relativePath in $publicFiles) {
    $source = Join-Path $projectRoot $relativePath
    $destination = Join-Path $packageDirectory $relativePath
    $destinationDirectory = Split-Path -Parent $destination
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination
}

$manifestLines = @(
    "RelingIT FTP-Upload-Paket",
    "Version: $version",
    "Veröffentlichungsdatum: $($release.Groups['date'].Value.Trim())",
    "Erstellt: $([datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss zzz'))"
)
if ($OhneAudio) {
    $manifestLines += "Ohne Audio: Die Podcast-MP3 sind nicht enthalten, die Live-Dateien unter assets/audio bleiben unverändert."
}
$manifestLines += @("", "SHA-256-Prüfsummen:")
foreach ($relativePath in $publicFiles) {
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $packageDirectory $relativePath)).Hash
    $manifestLines += "$hash  $($relativePath.Replace('\', '/'))"
}
Set-Content -LiteralPath (Join-Path $packageDirectory "UPLOAD-MANIFEST.txt") -Value $manifestLines -Encoding utf8

Compress-Archive -Path (Join-Path $packageDirectory "*") -DestinationPath $zipPath -CompressionLevel Optimal

# Die Kontrolle liest das fertige ZIP erneut ein. Jede enthaltene Nutzdatei muss
# bytegenau ihrer aktuellen Quelle entsprechen; fehlende oder zusätzliche
# Dateien führen zum Abbruch.
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
    $expectedEntries = @($publicFiles | ForEach-Object { $_.Replace('\', '/') }) + "UPLOAD-MANIFEST.txt"
    $actualEntries = @($archive.Entries | Where-Object { -not $_.FullName.EndsWith('/') } | ForEach-Object FullName)
    $missingEntries = @($expectedEntries | Where-Object { $_ -notin $actualEntries })
    $extraEntries = @($actualEntries | Where-Object { $_ -notin $expectedEntries })
    if ($missingEntries.Count -gt 0 -or $extraEntries.Count -gt 0) {
        throw "ZIP-Inhalt weicht ab. Fehlend: $($missingEntries -join ', '); zusätzlich: $($extraEntries -join ', ')"
    }

    foreach ($relativePath in $publicFiles) {
        $entryName = $relativePath.Replace('\', '/')
        $entry = $archive.GetEntry($entryName)
        $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $projectRoot $relativePath)).Hash
        $stream = $entry.Open()
        try {
            $zipHash = (Get-FileHash -Algorithm SHA256 -InputStream $stream).Hash
        } finally {
            $stream.Dispose()
        }
        if ($sourceHash -ne $zipHash) {
            throw "ZIP-Datei ist nicht identisch mit der Quelle: $relativePath"
        }
    }
} finally {
    $archive.Dispose()
}

$zipHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath).Hash
Write-Host "OK: geprüftes Upload-Paket erstellt: $zipPath"
Write-Host "OK: $($publicFiles.Count) aktuelle Quelldateien bytegenau im ZIP bestätigt."
if ($OhneAudio) { Write-Host "Hinweis: Paket ohne Podcast-MP3 (-OhneAudio). Beim Upload die Live-MP3 nicht löschen." }
Write-Host "SHA-256 des ZIP: $zipHash"
