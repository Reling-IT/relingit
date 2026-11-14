<#
Zweck:
    Berechnet den Ordner-Hash nach der Methode aus R45/R48 (Inventur und
    Löschlauf in archive/ftp-packages), nur lesend. Das Skript schreibt,
    verschiebt und löscht nichts und hydriert keine OneDrive-Platzhalter:
    Vor dem ersten Lesen eines Dateiinhalts werden nur Attribute geprüft;
    findet sich ein Cloud-Platzhalter, bricht es ab, ohne etwas zu hashen.

Methode (wie R45, Methode Punkt 4):
    1. Alle Dateien unter -Pfad, rekursiv, auch versteckte.
    2. Reihenfolge: Sort-Object FullName, kulturabhängig und ohne Beachtung
       der Groß-/Kleinschreibung (Standard von Sort-Object), Kultur fest
       de-DE wie bei der Inventur R45. Ordinal sortiert ergibt einen anderen
       Hash (Fehlstart R48), deshalb nur als Vergleich mit -Sortierung Ordinal.
    3. Je Datei eine Zeile: SHA-256 der Datei in Großbuchstaben, zwei
       Leerzeichen, Pfad relativ zu -Pfad mit Backslash.
    4. Zeilen mit LF verbunden, ohne LF am Ende, als UTF-8 ohne BOM.
    5. SHA-256 dieser Bytes, Großbuchstaben ohne Bindestriche.

Eingabe:
    -Pfad        Ordner, z. B. archive/ftp-packages/<Zeitstempel>.
    -Erwartet    Optional: Referenz-Hash (z. B. aus einem Bericht). Bei
                 Abweichung Exit-Code 1.
    -Sortierung  Kultur (Standard, reproduziert R45) oder Ordinal.
    -Kultur      Kultur für -Sortierung Kultur (Standard de-DE).
    -Zeilen      Gibt zusätzlich die gehashten Zeilen aus (zum Vergleich).

Ausgabe:
    Anzahl Dateien und Byte, Anzahl Platzhalter, Sortierung, Ordner-Hash.
    Exit-Code 0: Hash berechnet (und gleich -Erwartet, falls angegeben).
    Exit-Code 1: Hash weicht von -Erwartet ab.
    Exit-Code 2: Abbruch ohne Hash (Ordner fehlt, leer, Cloud-Platzhalter).
#>
param(
    [Parameter(Mandatory)][string]$Pfad,
    [string]$Erwartet = "",
    [ValidateSet("Kultur", "Ordinal")][string]$Sortierung = "Kultur",
    [string]$Kultur = "de-DE",
    [switch]$Zeilen
)

$ErrorActionPreference = "Stop"

# Offline (0x1000), RecallOnOpen (0x40000), RecallOnDataAccess (0x400000):
# dieselbe Maske wie in R45/R48. ReparsePoint (0x400) und Unpinned allein
# sind bei OneDrive üblich und kein Platzhalter.
$platzhalterMaske = 0x400000 -bor 0x40000 -bor 0x1000

function Stop-OhneHash([string]$Meldung) {
    Write-Host "Abbruch, kein Hash berechnet: $Meldung"
    exit 2
}

if (-not (Test-Path -LiteralPath $Pfad -PathType Container)) {
    Stop-OhneHash "Ordner fehlt: $Pfad"
}
$wurzel = (Get-Item -LiteralPath $Pfad -Force).FullName.TrimEnd('\', '/')

# Eigene Rekursion: Ein Unterordner wird erst gelesen, nachdem seine
# Attribute geprüft sind. Platzhalter werden gesammelt, nicht geöffnet.
$dateien = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
$platzhalter = [System.Collections.Generic.List[string]]::new()
$offen = [System.Collections.Generic.Stack[string]]::new()
$offen.Push($wurzel)
while ($offen.Count -gt 0) {
    $ordner = $offen.Pop()
    foreach ($eintrag in @(Get-ChildItem -LiteralPath $ordner -Force)) {
        $relativ = $eintrag.FullName.Substring($wurzel.Length + 1) -replace '/', '\'
        if (([int]$eintrag.Attributes -band $platzhalterMaske) -ne 0) {
            $platzhalter.Add("$relativ ($($eintrag.Attributes))")
            continue
        }
        if ($eintrag.PSIsContainer) { $offen.Push($eintrag.FullName) } else { $dateien.Add($eintrag) }
    }
}

if ($platzhalter.Count -gt 0) {
    Write-Host "Cloud-Platzhalter: $($platzhalter.Count)"
    foreach ($eintrag in $platzhalter) { Write-Host "  $eintrag" }
    Stop-OhneHash "Cloud-Platzhalter gefunden. Nichts hydriert; Ordner zuerst lokal vorhalten oder auslassen."
}
if ($dateien.Count -eq 0) {
    Stop-OhneHash "keine Dateien in $wurzel"
}

if ($Sortierung -eq "Kultur") {
    $sortiert = @($dateien | Sort-Object FullName -Culture $Kultur)
    $sortierText = "Kultur $Kultur (Sort-Object FullName -Culture $Kultur, ohne Groß-/Kleinschreibung), Methode R45"
} else {
    $liste = [System.Collections.Generic.List[System.IO.FileInfo]]::new($dateien)
    $liste.Sort([System.Comparison[System.IO.FileInfo]] { param($a, $b) [string]::CompareOrdinal($a.FullName, $b.FullName) })
    $sortiert = @($liste)
    $sortierText = "Ordinal ([string]::CompareOrdinal), weicht von R45 ab"
}

$hashZeilen = foreach ($datei in $sortiert) {
    $relativ = $datei.FullName.Substring($wurzel.Length + 1) -replace '/', '\'
    (Get-FileHash -Algorithm SHA256 -LiteralPath $datei.FullName).Hash.ToUpperInvariant() + "  " + $relativ
}
$bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes(($hashZeilen -join "`n"))
$sha = [System.Security.Cryptography.SHA256]::Create()
try {
    $ordnerHash = [System.BitConverter]::ToString($sha.ComputeHash($bytes)).Replace("-", "")
} finally {
    $sha.Dispose()
}

$summe = ($dateien | Measure-Object -Property Length -Sum).Sum
Write-Host "Ordner: $wurzel"
Write-Host "Dateien: $($dateien.Count), Byte: $summe"
Write-Host "Cloud-Platzhalter: 0"
Write-Host "Sortierung: $sortierText"
if ($Zeilen) {
    Write-Host "Zeilen:"
    foreach ($zeile in $hashZeilen) { Write-Host "  $zeile" }
}
Write-Host "Ordner-Hash: $ordnerHash"

if ($Erwartet) {
    if ($ordnerHash -eq $Erwartet.Trim().ToUpperInvariant()) {
        Write-Host "Vergleich: gleich -Erwartet"
    } else {
        Write-Host "Vergleich: ABWEICHUNG, erwartet $($Erwartet.Trim().ToUpperInvariant())"
        exit 1
    }
}
exit 0
