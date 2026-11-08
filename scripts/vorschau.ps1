<#
Zweck:
    Lokale Vorschau der Website aus dem aktuellen Zweig, damit Bernd eine
    Version vor der Freigabe selbst sichten kann (Tore G3 bis G5, siehe
    docs/FREIGABE.md). Kein FTP, keine Zugangsdaten, kein Netzwerkzugriff
    außer dem lokalen Webserver auf 127.0.0.1.

Eingabe:
    -Projekt     Projektordner (Standard: Ordner über scripts/).
    -Port        Port des lokalen Servers (Standard 8043).
    -Pdf         Öffnet zusätzlich story/current/geschichte.pdf aus der Kopie.
    -OhneBrowser Startet nur den Server, öffnet keinen Browser.
    -NurBauen    Baut nur die Kopie, gibt den Pfad aus und startet keinen Server.

Ablauf und Ausgabe:
    1. Kopiert die öffentlichen Dateien (Liste $publicFiles aus
       scripts/build-upload.ps1) in einen neuen Ordner unter dem
       Temp-Verzeichnis des Benutzers, außerhalb des Repositorys. Fehlende
       Podcast-MP3 werden übersprungen (sie liegen nicht im Repository).
    2. Ersetzt in der Kopie assets/js/supabase-config.js durch eine leere
       Konfiguration. Die Seiten zeigen damit die lokale Rückfallfassung
       dieses Zweigs und rufen Supabase nicht auf.
    3. Startet python -m http.server nur auf 127.0.0.1 und öffnet
       http://127.0.0.1:<Port>/index.html im Standardbrowser.
    4. Strg+C beendet den Server; die temporäre Kopie wird gelöscht.
#>
param(
    [string]$Projekt = "",
    [ValidateRange(1024, 65535)]
    [int]$Port = 8043,
    [switch]$Pdf,
    [switch]$OhneBrowser,
    [switch]$NurBauen
)

$ErrorActionPreference = "Stop"
if (-not $Projekt) { $Projekt = Split-Path -Parent $PSScriptRoot }
$Projekt = (Resolve-Path -LiteralPath $Projekt).Path

# Dateiliste aus build-upload.ps1 lesen (keine zweite Liste pflegen).
$buildSkript = Join-Path $Projekt "scripts/build-upload.ps1"
if (-not (Test-Path -LiteralPath $buildSkript)) { throw "scripts/build-upload.ps1 fehlt; die Dateiliste wird von dort gelesen." }
$ast = [System.Management.Automation.Language.Parser]::ParseFile($buildSkript, [ref]$null, [ref]$null)
$zuweisung = $ast.FindAll({
    param($knoten)
    $knoten -is [System.Management.Automation.Language.AssignmentStatementAst] -and
    $knoten.Left.Extent.Text -eq '$publicFiles'
}, $true) | Select-Object -First 1
if (-not $zuweisung) { throw "Liste `$publicFiles in scripts/build-upload.ps1 nicht gefunden." }
$dateien = @($zuweisung.Right.FindAll({ param($k) $k -is [System.Management.Automation.Language.StringConstantExpressionAst] }, $true) | ForEach-Object Value)
if ($dateien.Count -eq 0) { throw "Liste `$publicFiles in scripts/build-upload.ps1 ist leer." }

# Zielordner im Temp-Verzeichnis, sicher außerhalb des Projekts.
$tempBasis = [System.IO.Path]::GetTempPath()
$ziel = Join-Path $tempBasis ("relingit-vorschau-" + (Get-Date).ToString("yyyyMMdd-HHmmss") + "-" + [guid]::NewGuid().ToString("N").Substring(0, 6))
$zielVoll = [System.IO.Path]::GetFullPath($ziel)
if ($zielVoll.StartsWith($Projekt.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Temp-Verzeichnis liegt im Projekt ($zielVoll); Vorschau abgebrochen."
}
New-Item -ItemType Directory -Path $ziel | Out-Null

$kopiert = 0
$uebersprungen = @()
foreach ($relativ in $dateien) {
    $quelle = Join-Path $Projekt $relativ
    if (-not (Test-Path -LiteralPath $quelle -PathType Leaf)) {
        if ($relativ -like "assets/audio/*.mp3") { $uebersprungen += $relativ; continue }
        Remove-Item -LiteralPath $ziel -Recurse -Force
        throw "Datei fehlt: $relativ"
    }
    $zielDatei = Join-Path $ziel $relativ
    New-Item -ItemType Directory -Path (Split-Path -Parent $zielDatei) -Force | Out-Null
    Copy-Item -LiteralPath $quelle -Destination $zielDatei
    $kopiert++
}

# Leere Supabase-Konfiguration: Die Seiten nutzen die lokale Rückfallfassung.
$leereKonfiguration = "// Lokale Vorschau (scripts/vorschau.ps1): ohne Supabase, Seiten zeigen die lokale Rückfallfassung.`nwindow.SUPABASE_CONFIG = Object.freeze({ url: `"`", publishableKey: `"`" });`n"
[System.IO.File]::WriteAllText((Join-Path $ziel "assets/js/supabase-config.js"), $leereKonfiguration, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Vorschau gebaut: $ziel ($kopiert Dateien, Supabase in der Kopie abgeschaltet)."
if ($uebersprungen.Count -gt 0) { Write-Host "Hinweis: $($uebersprungen.Count) Podcast-MP3 nicht vorhanden, der Player zeigt nur die Darstellung." }
if ($NurBauen) {
    Write-Output $ziel
    return
}

# Python suchen (python oder python3); der Server lauscht nur auf 127.0.0.1.
$python = Get-Command python, python3 -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $python) {
    Remove-Item -LiteralPath $ziel -Recurse -Force
    throw "Python nicht gefunden. Für die Vorschau wird python -m http.server benötigt."
}
# Port frei? Probeweise auf 127.0.0.1 binden und sofort wieder freigeben.
$belegt = $false
$probe = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
try { $probe.Start() } catch { $belegt = $true } finally { $probe.Stop() }
if ($belegt) {
    Remove-Item -LiteralPath $ziel -Recurse -Force
    throw "Port $Port ist belegt. Bitte mit -Port einen anderen Port wählen."
}

$server = Start-Process -FilePath $python.Source -ArgumentList @("-m", "http.server", "$Port", "--bind", "127.0.0.1", "--directory", "`"$ziel`"") -NoNewWindow -PassThru
try {
    $adresse = "http://127.0.0.1:$Port/index.html"
    $bereit = $false
    for ($i = 0; $i -lt 50 -and -not $server.HasExited; $i++) {
        try {
            $antwort = Invoke-WebRequest -Uri $adresse -UseBasicParsing -TimeoutSec 2
            if ($antwort.StatusCode -eq 200) { $bereit = $true; break }
        } catch { Start-Sleep -Milliseconds 200 }
    }
    if (-not $bereit) { throw "Lokaler Server antwortet nicht unter $adresse." }
    Write-Host "Vorschau läuft: $adresse (nur 127.0.0.1). Beenden mit Strg+C."
    if (-not $OhneBrowser) {
        Start-Process $adresse
        if ($Pdf) { Start-Process "http://127.0.0.1:$Port/story/current/geschichte.pdf" }
    }
    while (-not $server.HasExited) { Start-Sleep -Milliseconds 500 }
    Write-Host "Server wurde beendet."
} finally {
    if (-not $server.HasExited) { Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue; $server.WaitForExit(5000) | Out-Null }
    Remove-Item -LiteralPath $ziel -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Vorschau beendet, temporäre Kopie gelöscht."
}
