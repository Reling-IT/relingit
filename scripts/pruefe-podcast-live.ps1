param(
    # Basisadresse der Live-Seite; die MP3 liegen darunter in assets/audio/.
    [string]$BasisUrl = "https://berndmarnau.de/relingit/",
    # Zeigt nur die geplanten Anfragen und die erwarteten Größen, ohne Netzwerkzugriff.
    [switch]$Trocken,
    [ValidateRange(1, 300)]
    [int]$TimeoutSekunden = 30
)

# Prüft die vier Live-MP3 ohne Download: je Datei eine HTTP-HEAD-Anfrage,
# Content-Length wird mit der Größe aus assets/audio/SHA256SUMS.txt verglichen.
# Nur lesend: kein FTP, keine Zugangsdaten, kein Download des Inhalts.
# Ergebnis: Exit-Code 0, wenn alle Größen stimmen, sonst Abbruch mit Fehler.
$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$sumsPath = Join-Path $projectRoot "assets/audio/SHA256SUMS.txt"
if (-not (Test-Path -LiteralPath $sumsPath -PathType Leaf)) {
    throw "assets/audio/SHA256SUMS.txt fehlt."
}

$erwartet = [ordered]@{}
foreach ($line in (Get-Content -LiteralPath $sumsPath -Encoding utf8)) {
    $sizeMatch = [regex]::Match($line, '^#\s*groesse\s+(?<bytes>\d+)\s+(?<name>\S+)\s*$')
    if ($sizeMatch.Success) { $erwartet[$sizeMatch.Groups['name'].Value] = [long]$sizeMatch.Groups['bytes'].Value }
}
if ($erwartet.Count -eq 0) {
    throw "assets/audio/SHA256SUMS.txt enthält keine Größenangaben (# groesse <Byte> <Datei>)."
}

$basis = if ($BasisUrl.EndsWith("/")) { $BasisUrl } else { "$BasisUrl/" }
$abweichungen = [System.Collections.Generic.List[string]]::new()

foreach ($name in $erwartet.Keys) {
    $url = "${basis}assets/audio/$name"
    $soll = $erwartet[$name]
    if ($Trocken) {
        Write-Host "Trocken: HEAD $url (erwartet $soll Byte)"
        continue
    }
    try {
        $antwort = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec $TimeoutSekunden -MaximumRedirection 3 -UseBasicParsing
    } catch {
        $abweichungen.Add("$name nicht abrufbar: $($_.Exception.Message)")
        Write-Host "FEHLER: $name nicht abrufbar ($url)"
        continue
    }
    $laengeWert = @($antwort.Headers['Content-Length'])[0]
    $geaendert = @($antwort.Headers['Last-Modified'])[0]
    $typ = @($antwort.Headers['Content-Type'])[0]
    if (-not $laengeWert) {
        $abweichungen.Add("$name ohne Content-Length")
        Write-Host "FEHLER: $name liefert keine Content-Length (HTTP $($antwort.StatusCode))"
        continue
    }
    $ist = [long]$laengeWert
    $zusatz = "HTTP $($antwort.StatusCode), $typ, Last-Modified $geaendert"
    if ($ist -eq $soll) {
        Write-Host "OK: $name $ist Byte ($zusatz)"
    } else {
        $abweichungen.Add("$name hat live $ist Byte, erwartet $soll")
        Write-Host "FEHLER: $name live $ist Byte, erwartet $soll ($zusatz)"
    }
}

if ($Trocken) {
    Write-Host "Trockenlauf: $($erwartet.Count) Anfragen geplant, kein Netzwerkzugriff."
    return
}
if ($abweichungen.Count -gt 0) {
    throw "Live-Prüfung mit $($abweichungen.Count) Abweichung(en): $($abweichungen -join '; ')"
}
Write-Host "OK: $($erwartet.Count) Live-MP3 unter $basis haben die Größe aus assets/audio/SHA256SUMS.txt."
