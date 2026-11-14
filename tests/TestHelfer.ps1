# Gemeinsame Hilfsfunktionen für die Pester-Tests unter tests/.
# Die Tests laufen nie gegen das echte Projekt: ci-check.ps1 und
# publish-release.ps1 leiten das Projektverzeichnis aus $PSScriptRoot ab.
# Darum wird je Test ein Mini-Projekt in einem temporären Ordner aufgebaut,
# die Skripte werden hineinkopiert und dort in einem eigenen pwsh-Prozess
# gestartet.
#
# Fixture-Dateien tragen die Endung .fixture. So sieht ci-check.ps1 im echten
# Projekt keine *.html mit absichtlichen Fehlern. Beim Kopieren in das
# Mini-Projekt wird die Endung entfernt.
#
# Absichtlich ohne Should: Die Prüfungen werfen selbst. Dadurch laufen die
# Tests mit Pester 5 (Zielversion) und mit dem in Windows mitgelieferten
# Pester 3.4.

$script:RepoRoot = Split-Path -Parent $PSScriptRoot
$script:FixtureRoot = Join-Path $PSScriptRoot "fixtures"

# Pflichtdateien aus ci-check.ps1, deren Inhalt dort nicht geprüft wird.
$script:Platzhalter = @(
    ".htaccess", "pdf.html", "handout.html", "handout-pdf.html", "impressum.html", "datenschutz.html",
    "story/current/workshop-handout.html",
    "assets/img/reling-it-logo.svg", "assets/img/favicon.png",
    "assets/css/styles.css", "assets/css/legal.css",
    "assets/js/pdf-viewer.js", "assets/js/story-viewer.js", "assets/js/handout-viewer.js",
    "assets/js/supabase-config.js", "supabase/tests/security-checks.sql",
    # Lokale Schriften (seit v1.38 in $publicFiles von build-upload.ps1).
    "assets/fonts/Fraunces-Variable.woff2", "assets/fonts/WorkSans-Regular.woff2",
    "assets/fonts/WorkSans-Italic.woff2", "assets/fonts/WorkSans-Bold.woff2",
    "assets/fonts/IBMPlexMono-Regular.woff2", "assets/fonts/IBMPlexMono-Italic.woff2",
    "assets/fonts/IBMPlexMono-Medium.woff2",
    "assets/fonts/Fraunces-OFL.txt", "assets/fonts/WorkSans-OFL.txt",
    "assets/fonts/IBMPlexMono-OFL.txt", "assets/fonts/HERKUNFT.txt",
    # Bildmarken der Startseite (seit R11 in $publicFiles von build-upload.ps1).
    "assets/img/avatare/navis.svg", "assets/img/avatare/lumen.svg"
)

function Get-PwshPfad {
    $cmd = Get-Command pwsh -ErrorAction SilentlyContinue
    if (-not $cmd) { throw "pwsh (PowerShell 7) wird für die Tests benötigt." }
    return $cmd.Source
}

function Write-Utf8Datei([string]$Pfad, [string]$Inhalt) {
    $ordner = Split-Path -Parent $Pfad
    if ($ordner -and -not (Test-Path -LiteralPath $ordner)) {
        New-Item -ItemType Directory -Path $ordner -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Pfad, $Inhalt, (New-Object System.Text.UTF8Encoding($false)))
}

# Baut ein vollständiges, fehlerfreies Mini-Projekt (Version 1.02, 07.11.2026, 1 Seite).
# -Geschichte wählt eine Datei aus tests/fixtures/geschichte; sie wird nach
# source/ und story/current/ gelegt, damit beide bytegleich bleiben.
function New-MiniProjekt {
    param(
        [Parameter(Mandatory)][string]$Ziel,
        [string]$Geschichte = "basis.html.fixture",
        [string]$Pdf = "deckblatt-v1.02.pdf"
    )
    if (Test-Path -LiteralPath $Ziel) { Remove-Item -LiteralPath $Ziel -Recurse -Force }
    New-Item -ItemType Directory -Path (Join-Path $Ziel "scripts") -Force | Out-Null

    foreach ($skript in @("ci-check.ps1", "publish-release.ps1", "build-upload.ps1")) {
        Copy-Item -LiteralPath (Join-Path $script:RepoRoot "scripts/$skript") -Destination (Join-Path $Ziel "scripts/$skript")
    }

    $miniRoot = Join-Path $script:FixtureRoot "mini-projekt"
    foreach ($datei in (Get-ChildItem -LiteralPath $miniRoot -Recurse -File -Filter "*.fixture")) {
        $relativ = $datei.FullName.Substring($miniRoot.Length + 1) -replace '\.fixture$', ''
        $zielDatei = Join-Path $Ziel $relativ
        New-Item -ItemType Directory -Path (Split-Path -Parent $zielDatei) -Force | Out-Null
        Copy-Item -LiteralPath $datei.FullName -Destination $zielDatei
    }

    foreach ($relativ in $script:Platzhalter) {
        Write-Utf8Datei (Join-Path $Ziel $relativ) "Platzhalter für Tests`n"
    }

    # Podcast: versionierte Prüfsummendatei aus dem echten Projekt und ein
    # kleines Cover mit PNG-Kennung. MP3 legt bei Bedarf New-PodcastMp3 an.
    New-Item -ItemType Directory -Path (Join-Path $Ziel "assets/audio") -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $script:RepoRoot "assets/audio/SHA256SUMS.txt") -Destination (Join-Path $Ziel "assets/audio/SHA256SUMS.txt")
    [System.IO.File]::WriteAllBytes((Join-Path $Ziel "assets/img/reling-it-podcast-cover.png"),
        [byte[]](0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A))

    $geschichtePfad = Join-Path $script:FixtureRoot "geschichte/$Geschichte"
    foreach ($relativ in @("source/fahrt-zum-kunden.html", "story/current/fahrt-zum-kunden.html")) {
        $zielDatei = Join-Path $Ziel $relativ
        New-Item -ItemType Directory -Path (Split-Path -Parent $zielDatei) -Force | Out-Null
        Copy-Item -LiteralPath $geschichtePfad -Destination $zielDatei
    }

    $pdfPfad = Join-Path $script:FixtureRoot "pdf/$Pdf"
    foreach ($relativ in @("source/Die-Fahrt-zum-Kunden.pdf", "story/current/geschichte.pdf", "story/current/workshop-handout.pdf")) {
        Copy-Item -LiteralPath $pdfPfad -Destination (Join-Path $Ziel $relativ)
    }
    return $Ziel
}

# Die vier MP3-Namen aus scripts/ci-check.ps1 und scripts/build-upload.ps1.
$script:PodcastMp3 = @(
    "ki-als-beifahrer-im-it-systemhaus.mp3", "vom-logbuch-zum-ki-ticketsystem.mp3",
    "warum-ki-nicht-lenken-darf.mp3", "roman-als-ki-blaupause.mp3"
)

# Legt kleine Ersatz-MP3 (ID3-Kennung) im Mini-Projekt an. Mit
# -PruefsummenAnpassen wird assets/audio/SHA256SUMS.txt passend zu diesen
# Dateien neu geschrieben; ohne bleibt die echte Datei und die Prüfsummen weichen ab.
function New-PodcastMp3 {
    param(
        [Parameter(Mandatory)][string]$Projekt,
        [switch]$PruefsummenAnpassen
    )
    $groessen = @()
    $summen = @()
    foreach ($name in $script:PodcastMp3) {
        $pfad = Join-Path $Projekt "assets/audio/$name"
        Write-Utf8Datei $pfad "ID3 Ersatz-MP3 für Tests: $name`n"
        $groessen += "# groesse $((Get-Item -LiteralPath $pfad).Length) $name"
        $summen += "$((Get-FileHash -Algorithm SHA256 -LiteralPath $pfad).Hash.ToLowerInvariant())  $name"
    }
    if ($PruefsummenAnpassen) {
        Write-Utf8Datei (Join-Path $Projekt "assets/audio/SHA256SUMS.txt") ((@("# Testdaten") + $groessen + $summen) -join "`n")
    }
}

# Liefert die Dateinamen im ZIP (ohne Ordnereinträge).
function Get-ZipEintraege([string]$ZipPfad) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archiv = [System.IO.Compression.ZipFile]::OpenRead($ZipPfad)
    try {
        return @($archiv.Entries | Where-Object { -not $_.FullName.EndsWith('/') } | ForEach-Object FullName)
    } finally {
        $archiv.Dispose()
    }
}

# Startet ein Skript des Mini-Projekts in einem eigenen pwsh-Prozess und
# liefert Exit-Code und gesamte Ausgabe (stdout und stderr) zurück.
function Invoke-MiniSkript {
    param(
        [Parameter(Mandatory)][string]$Projekt,
        [Parameter(Mandatory)][string]$Skript,
        [string[]]$Argumente = @()
    )
    $pfad = (Join-Path $Projekt "scripts/$Skript") -replace "'", "''"
    # Parameternamen (-Name) bleiben unquotiert, Werte werden in einfache Anführungszeichen gesetzt.
    $argumentText = ($Argumente | ForEach-Object {
        if ($_ -match '^-[A-Za-z]+$') { $_ } else { "'" + ($_ -replace "'", "''") + "'" }
    }) -join " "
    # Klartext ohne Farben und ohne Zeilenumbruch nach Konsolenbreite, Ausgabe in UTF-8,
    # damit die Meldungen (mit Umlauten) zuverlässig verglichen werden können.
    $befehl = "if (`$PSStyle) { `$PSStyle.OutputRendering = 'PlainText' }; `$ErrorView = 'NormalView'; " +
        "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; & '$pfad' $argumentText"
    $vorher = $ErrorActionPreference
    $vorherEncoding = [Console]::OutputEncoding
    $ErrorActionPreference = "Continue"
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    try {
        $ausgabe = & (Get-PwshPfad) -NoProfile -NonInteractive -Command $befehl 2>&1 |
            ForEach-Object { "$_" }
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $vorher
        [Console]::OutputEncoding = $vorherEncoding
    }
    return [pscustomobject]@{
        ExitCode = $exitCode
        Ausgabe  = ($ausgabe -join "`n")
    }
}

function Assert-Fehlschlag($Ergebnis, [string]$Muster) {
    if ($Ergebnis.ExitCode -eq 0) {
        throw "Erwartet: Abbruch (Exit-Code ungleich 0). Erhalten: 0.`n$($Ergebnis.Ausgabe)"
    }
    if ($Ergebnis.Ausgabe -notmatch $Muster) {
        throw "Erwartete Meldung (Muster '$Muster') fehlt in der Ausgabe:`n$($Ergebnis.Ausgabe)"
    }
}

function Assert-Erfolg($Ergebnis, [string]$Muster) {
    if ($Ergebnis.ExitCode -ne 0) {
        throw "Erwartet: Exit-Code 0. Erhalten: $($Ergebnis.ExitCode).`n$($Ergebnis.Ausgabe)"
    }
    if ($Muster -and $Ergebnis.Ausgabe -notmatch $Muster) {
        throw "Erwartete Meldung (Muster '$Muster') fehlt in der Ausgabe:`n$($Ergebnis.Ausgabe)"
    }
}

function Assert-Enthaelt($Ergebnis, [string]$Muster) {
    if ($Ergebnis.Ausgabe -notmatch $Muster) {
        throw "Erwartete Meldung (Muster '$Muster') fehlt in der Ausgabe:`n$($Ergebnis.Ausgabe)"
    }
}
