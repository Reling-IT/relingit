<#
Zweck:
    Prüft ein FTP-Upload-Paket (ZIP aus build-upload.ps1) reproduzierbar und
    nur lesend: jede Datei gegen UPLOAD-MANIFEST.txt (SHA-256), Anzahl der
    Einträge, fehlende und zusätzliche Dateien und, mit -Vorgaenger, je Datei
    geändert, neu oder unverändert. Die Ausgabe ist eine Markdown-Tabelle wie
    in der Upload-Checkliste (R51) und lässt sich direkt in einen Bericht
    übernehmen.

Nur lesend:
    Das Skript entpackt nichts auf die Platte. Die Einträge werden direkt aus
    dem ZIP gelesen (Stream) und gehasht. Es entsteht kein temporärer Ordner,
    und weder das ZIP noch der Vorgänger werden verändert.

Manifest (Format aus build-upload.ps1):
    Kopfzeilen "Version: ...", "Veröffentlichungsdatum: ...", "Erstellt: ...",
    optional "Ohne Audio: ...", danach je Nutzdatei eine Zeile
    "<SHA-256 groß>  <Pfad mit />". UPLOAD-MANIFEST.txt selbst steht nicht
    im Manifest.

Eingabe:
    -Zip           Pflicht: das zu prüfende ZIP.
    -Vorgaenger    Optional: Vorgänger-Paket als ZIP oder entpackter Ordner.
                   Vergleich je Datei: geändert, neu, unverändert; Dateien
                   nur im Vorgänger werden als entfallen gemeldet.
    -ErwartetHash  Optional: SHA-256 des ZIP (z. B. aus der Checkliste). Bei
                   Abweichung Exit-Code 1.

Ausgabe:
    Kopf mit ZIP-Hash, Größe, Einträgen und Manifest-Angaben, Tabelle aller
    Einträge, Zusammenfassung.
    Exit-Code 0: Paket gleich Manifest (und ZIP-Hash gleich -ErwartetHash).
    Exit-Code 1: Abweichung (Prüfsumme, fehlende oder zusätzliche Datei,
                 Manifest fehlt oder ohne Prüfsummen, ZIP-Hash ungleich
                 -ErwartetHash).
    Exit-Code 2: Abbruch ohne Prüfung (ZIP oder Vorgänger fehlt oder ist
                 nicht lesbar).
#>
param(
    [Parameter(Mandatory)][string]$Zip,
    [string]$Vorgaenger = "",
    [string]$ErwartetHash = ""
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem

$manifestName = "UPLOAD-MANIFEST.txt"

function Stop-OhnePruefung([string]$Meldung) {
    Write-Output "Abbruch, keine Prüfung: $Meldung"
    exit 2
}

function Get-StreamHash([System.IO.Stream]$Stream) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [System.BitConverter]::ToString($sha.ComputeHash($Stream)).Replace("-", "")
    } finally {
        $sha.Dispose()
    }
}

# Liest alle Dateieinträge eines ZIP: Name (mit /), Byte, SHA-256 und bei
# UPLOAD-MANIFEST.txt den Text. Ordnereinträge werden übergangen.
function Read-ZipEintraege([string]$Pfad) {
    $ergebnis = [ordered]@{}
    $archiv = [System.IO.Compression.ZipFile]::OpenRead($Pfad)
    try {
        foreach ($eintrag in $archiv.Entries) {
            $name = $eintrag.FullName.Replace('\', '/')
            if ($name.EndsWith('/')) { continue }
            $stream = $eintrag.Open()
            try { $hash = Get-StreamHash $stream } finally { $stream.Dispose() }
            $text = $null
            if ($name -eq $manifestName) {
                $leser = New-Object System.IO.StreamReader($eintrag.Open(), [System.Text.Encoding]::UTF8)
                try { $text = $leser.ReadToEnd() } finally { $leser.Dispose() }
            }
            $ergebnis[$name] = [pscustomobject]@{ Name = $name; Byte = $eintrag.Length; Hash = $hash; Text = $text }
        }
    } finally {
        $archiv.Dispose()
    }
    return $ergebnis
}

# Vorgänger als entpackter Ordner: Dateien rekursiv, auch versteckte.
function Read-OrdnerEintraege([string]$Pfad) {
    $ergebnis = [ordered]@{}
    $wurzel = (Get-Item -LiteralPath $Pfad -Force).FullName.TrimEnd('\', '/')
    foreach ($datei in @(Get-ChildItem -LiteralPath $wurzel -Recurse -File -Force)) {
        $name = $datei.FullName.Substring($wurzel.Length + 1).Replace('\', '/')
        $ergebnis[$name] = [pscustomobject]@{
            Name = $name; Byte = $datei.Length; Text = $null
            Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $datei.FullName).Hash.ToUpperInvariant()
        }
    }
    return $ergebnis
}

function Format-Byte([long]$Wert) {
    return $Wert.ToString("#,0", [System.Globalization.CultureInfo]::InvariantCulture).Replace(",", " ")
}

# --- Eingaben lesen ---------------------------------------------------------

if (-not (Test-Path -LiteralPath $Zip -PathType Leaf)) { Stop-OhnePruefung "ZIP fehlt: $Zip" }
$zipPfad = (Get-Item -LiteralPath $Zip -Force).FullName
try {
    $eintraege = Read-ZipEintraege $zipPfad
} catch {
    Stop-OhnePruefung "ZIP nicht lesbar: $zipPfad ($($_.Exception.Message))"
}
$zipHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPfad).Hash.ToUpperInvariant()
$zipByte = (Get-Item -LiteralPath $zipPfad -Force).Length

$vorgaengerEintraege = $null
$vorgaengerText = ""
if ($Vorgaenger) {
    if (Test-Path -LiteralPath $Vorgaenger -PathType Container) {
        $vorgaengerPfad = (Get-Item -LiteralPath $Vorgaenger -Force).FullName
        $vorgaengerEintraege = Read-OrdnerEintraege $vorgaengerPfad
        if ($vorgaengerEintraege.Count -eq 0) { Stop-OhnePruefung "Vorgänger-Ordner ist leer: $vorgaengerPfad" }
        $vorgaengerText = "Ordner $vorgaengerPfad"
    } elseif (Test-Path -LiteralPath $Vorgaenger -PathType Leaf) {
        $vorgaengerPfad = (Get-Item -LiteralPath $Vorgaenger -Force).FullName
        try {
            $vorgaengerEintraege = Read-ZipEintraege $vorgaengerPfad
        } catch {
            Stop-OhnePruefung "Vorgänger nicht lesbar: $vorgaengerPfad ($($_.Exception.Message))"
        }
        $vorgaengerText = "$vorgaengerPfad, SHA-256 $((Get-FileHash -Algorithm SHA256 -LiteralPath $vorgaengerPfad).Hash.ToUpperInvariant())"
    } else {
        Stop-OhnePruefung "Vorgänger fehlt: $Vorgaenger"
    }
}

# --- Manifest auswerten -----------------------------------------------------

$abweichungen = [System.Collections.Generic.List[string]]::new()
$soll = [ordered]@{}
$kopf = [ordered]@{}
if ($eintraege.Contains($manifestName)) {
    foreach ($zeile in ($eintraege[$manifestName].Text -split "\r?\n")) {
        $treffer = [regex]::Match($zeile, '^(?<hash>[0-9A-Fa-f]{64})  (?<name>.+)$')
        if ($treffer.Success) {
            $soll[$treffer.Groups['name'].Value.Trim().Replace('\', '/')] = $treffer.Groups['hash'].Value.ToUpperInvariant()
            continue
        }
        $kopfTreffer = [regex]::Match($zeile, '^(?<feld>Version|Veröffentlichungsdatum|Erstellt|Ohne Audio): (?<wert>.+)$')
        if ($kopfTreffer.Success) { $kopf[$kopfTreffer.Groups['feld'].Value] = $kopfTreffer.Groups['wert'].Value.Trim() }
    }
    if ($soll.Count -eq 0) { $abweichungen.Add("$manifestName enthält keine Prüfsummen") }
} else {
    $abweichungen.Add("$manifestName fehlt im ZIP")
}

# Reihenfolge wie im Manifest (= Paketliste von build-upload.ps1), danach
# zusätzliche Einträge, zuletzt das Manifest selbst.
$reihenfolge = [System.Collections.Generic.List[string]]::new()
foreach ($name in $soll.Keys) { $reihenfolge.Add($name) }
foreach ($name in $eintraege.Keys) {
    if ($name -ne $manifestName -and -not $soll.Contains($name)) { $reihenfolge.Add($name) }
}
if ($eintraege.Contains($manifestName)) { $reihenfolge.Add($manifestName) }

$zaehler = [ordered]@{ gleich = 0; abweichend = 0; fehlt = 0; zusaetzlich = 0; geaendert = 0; neu = 0; unveraendert = 0 }
$zeilen = [System.Collections.Generic.List[string]]::new()
$nr = 0
foreach ($name in $reihenfolge) {
    $nr++
    $ist = if ($eintraege.Contains($name)) { $eintraege[$name] } else { $null }
    $istManifest = $name -eq $manifestName

    if ($istManifest) {
        $manifestSpalte = "Manifest selbst"
    } elseif (-not $ist) {
        $manifestSpalte = "**fehlt im ZIP**"
        $zaehler.fehlt++
        $abweichungen.Add("fehlt im ZIP: $name")
    } elseif (-not $soll.Contains($name)) {
        $manifestSpalte = "**zusätzlich, nicht im Manifest**"
        $zaehler.zusaetzlich++
        $abweichungen.Add("zusätzlich im ZIP: $name")
    } elseif ($ist.Hash -eq $soll[$name]) {
        $manifestSpalte = "gleich"
        $zaehler.gleich++
    } else {
        $manifestSpalte = "**ABWEICHUNG**, Manifest $($soll[$name])"
        $zaehler.abweichend++
        $abweichungen.Add("Prüfsumme weicht vom Manifest ab: $name")
    }

    $vergleich = ""
    if ($null -ne $vorgaengerEintraege) {
        if (-not $ist) {
            $vergleich = "–"
        } elseif (-not $vorgaengerEintraege.Contains($name)) {
            $vergleich = "**neu**"
            if (-not $istManifest) { $zaehler.neu++ }
        } elseif ($vorgaengerEintraege[$name].Hash -eq $ist.Hash) {
            $vergleich = "unverändert"
            if (-not $istManifest) { $zaehler.unveraendert++ }
        } else {
            $vergleich = "**geändert**"
            if (-not $istManifest) { $zaehler.geaendert++ }
        }
    }

    $hashSpalte = if ($ist) { "``$($ist.Hash)``" } else { "–" }
    $byteSpalte = if ($ist) { Format-Byte $ist.Byte } else { "–" }
    $zeile = "| $nr | ``$name`` | $hashSpalte | $byteSpalte | $manifestSpalte |"
    if ($null -ne $vorgaengerEintraege) { $zeile += " $vergleich |" }
    $zeilen.Add($zeile)
}

$entfallen = @()
if ($null -ne $vorgaengerEintraege) {
    $entfallen = @($vorgaengerEintraege.Keys | Where-Object { $_ -ne $manifestName -and -not $eintraege.Contains($_) })
}

# --- Ausgabe ----------------------------------------------------------------

$nutz = @($eintraege.Keys | Where-Object { $_ -ne $manifestName }).Count
$mitManifest = if ($eintraege.Contains($manifestName)) { " + $manifestName" } else { ", ohne $manifestName" }

Write-Output "# Paketprüfung"
Write-Output ""
Write-Output "| | Wert |"
Write-Output "|---|---|"
Write-Output "| ZIP | ``$zipPfad`` |"
Write-Output "| SHA-256 | ``$zipHash`` |"
Write-Output "| Größe | $(Format-Byte $zipByte) Byte |"
Write-Output "| Einträge | $($eintraege.Count) ($nutz Nutzdateien$mitManifest) |"
foreach ($feld in $kopf.Keys) { Write-Output "| Manifest $feld | $($kopf[$feld]) |" }
if ($null -ne $vorgaengerEintraege) {
    Write-Output "| Vorgänger | ``$vorgaengerText``, $($vorgaengerEintraege.Count) Einträge |"
}
Write-Output ""
if ($null -ne $vorgaengerEintraege) {
    Write-Output "| Nr. | Datei | SHA-256 | Byte | Manifest | ggü. Vorgänger |"
    Write-Output "|---|---|---|---|---|---|"
} else {
    Write-Output "| Nr. | Datei | SHA-256 | Byte | Manifest |"
    Write-Output "|---|---|---|---|---|"
}
foreach ($zeile in $zeilen) { Write-Output $zeile }
Write-Output ""
Write-Output "## Zusammenfassung"
Write-Output ""
Write-Output "- Einträge: $($eintraege.Count) ($nutz Nutzdateien$mitManifest)"
Write-Output "- Manifest: $($soll.Count) Prüfsummen; $($zaehler.gleich) gleich, $($zaehler.abweichend) abweichend, $($zaehler.fehlt) fehlen im ZIP, $($zaehler.zusaetzlich) zusätzlich im ZIP"
if ($null -ne $vorgaengerEintraege) {
    Write-Output "- Gegenüber Vorgänger (Nutzdateien, ohne Manifest): $($zaehler.geaendert + $zaehler.neu) geändert oder neu ($($zaehler.geaendert) geändert, $($zaehler.neu) neu), $($zaehler.unveraendert) unverändert, $($entfallen.Count) entfallen"
    foreach ($name in $entfallen) { Write-Output "  - entfallen (nur im Vorgänger): ``$name``" }
}
if ($ErwartetHash) {
    $erwartet = $ErwartetHash.Trim().ToUpperInvariant()
    if ($zipHash -eq $erwartet) {
        Write-Output "- ZIP-Hash: gleich -ErwartetHash"
    } else {
        Write-Output "- ZIP-Hash: **ABWEICHUNG**, erwartet $erwartet"
        $abweichungen.Add("ZIP-Hash ungleich -ErwartetHash")
    }
}

if ($abweichungen.Count -gt 0) {
    Write-Output "- Ergebnis: **ABWEICHUNG** ($($abweichungen.Count))"
    foreach ($meldung in $abweichungen) { Write-Output "  - $meldung" }
    exit 1
}
Write-Output "- Ergebnis: OK, Paket gleich Manifest"
exit 0
