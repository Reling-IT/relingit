# Pester-Tests für scripts/ordner-hash.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Tests arbeiten nur in einem kleinen Testordner im TestDrive. Das Skript
# selbst wird unverändert aus scripts/ in einem eigenen pwsh-Prozess gestartet;
# es liest nur und braucht darum kein Mini-Projekt.

$ohneWindows = -not $IsWindows -and $PSVersionTable.PSEdition -eq "Core"

Describe "ordner-hash.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")

        # Kleiner Paketordner wie in archive/ftp-packages: ZIP neben dem
        # gleichnamigen Ordner, Großbuchstaben (UPLOAD-MANIFEST.txt) neben
        # Kleinbuchstaben. Kulturabhängig und ordinal sortiert ergeben sich
        # dadurch verschiedene Reihenfolgen.
        $script:Inhalt = [ordered]@{
            "paket.zip"                 = "zip`n"
            "paket\UPLOAD-MANIFEST.txt" = "Manifest`n"
            "paket\admin.html"          = "<p>admin</p>`n"
            "paket\assets\js\app.js"    = "// app`n"
            "paket\index.html"          = "<p>Start</p>`r`n"
        }
        function New-TestOrdner([string]$Name) {
            $ziel = Join-Path $TestDrive $Name
            foreach ($relativ in $script:Inhalt.Keys) {
                Write-Utf8Datei (Join-Path $ziel ($relativ -replace '\\', [IO.Path]::DirectorySeparatorChar)) $script:Inhalt[$relativ]
            }
            return $ziel
        }

        # Erwarteter Hash unabhängig vom Skript: Reihenfolge von Hand
        # festgelegt, so wie Sort-Object FullName in de-DE sortiert.
        function Get-ErwarteterHash([string]$Ordner, [string[]]$Reihenfolge) {
            $zeilen = foreach ($relativ in $Reihenfolge) {
                $datei = Join-Path $Ordner ($relativ -replace '\\', [IO.Path]::DirectorySeparatorChar)
                (Get-FileHash -Algorithm SHA256 -LiteralPath $datei).Hash + "  " + $relativ
            }
            $sha = [System.Security.Cryptography.SHA256]::Create()
            $bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes(($zeilen -join "`n"))
            return [System.BitConverter]::ToString($sha.ComputeHash($bytes)).Replace("-", "")
        }
        $script:Kultur = @("paket.zip", "paket\admin.html", "paket\assets\js\app.js", "paket\index.html", "paket\UPLOAD-MANIFEST.txt")
        $script:Ordinal = @("paket.zip", "paket\UPLOAD-MANIFEST.txt", "paket\admin.html", "paket\assets\js\app.js", "paket\index.html")

        # Stand des Ordners: Dateien mit Länge, Änderungszeit und Attributen,
        # Ordner nur mit Namen (NTFS setzt deren Änderungszeit verzögert).
        function Get-Stand([string]$Ordner) {
            return (@(Get-ChildItem -LiteralPath $Ordner -Recurse -Force) |
                ForEach-Object {
                    if ($_.PSIsContainer) { "$($_.FullName)|Ordner" }
                    else { "$($_.FullName)|$($_.Length)|$($_.LastWriteTimeUtc.Ticks)|$($_.Attributes)" }
                } | Sort-Object) -join "`n"
        }

        # Startet das Skript mit -File in einem eigenen pwsh-Prozess, damit
        # die Exit-Codes 1 und 2 unverändert ankommen (-Command liefert nur 0/1).
        function Invoke-OrdnerHash([string[]]$Argumente) {
            $skript = Join-Path $script:RepoRoot "scripts/ordner-hash.ps1"
            $vorher = $ErrorActionPreference
            $ErrorActionPreference = "Continue"
            try {
                $ausgabe = & (Get-PwshPfad) -NoProfile -NonInteractive -File $skript @Argumente 2>&1 | ForEach-Object { "$_" }
                $exitCode = $LASTEXITCODE
            } finally {
                $ErrorActionPreference = $vorher
            }
            return [pscustomobject]@{ ExitCode = $exitCode; Ausgabe = ($ausgabe -join "`n") }
        }
    }

    It "berechnet den Hash nach der Methode R45 (kulturabhängige Sortierung, LF ohne Schluss-LF)" {
        $ordner = New-TestOrdner "kultur"
        $erwartet = Get-ErwarteterHash $ordner $script:Kultur
        $ergebnis = Invoke-OrdnerHash @("-Pfad", $ordner, "-Erwartet", $erwartet)
        Assert-Erfolg $ergebnis "Ordner-Hash: $erwartet"
        Assert-Enthaelt $ergebnis "Dateien: 5, "
        Assert-Enthaelt $ergebnis "Cloud-Platzhalter: 0"
        Assert-Enthaelt $ergebnis "Vergleich: gleich -Erwartet"
    }

    It "ordinal sortiert ergibt einen anderen Hash (Fehlstart R48) und meldet die Abweichung mit Exit 1" {
        $ordner = New-TestOrdner "ordinal"
        $kultur = Get-ErwarteterHash $ordner $script:Kultur
        $ordinal = Get-ErwarteterHash $ordner $script:Ordinal
        if ($kultur -eq $ordinal) { throw "Testordner taugt nicht: beide Sortierungen ergeben denselben Hash." }

        $ergebnis = Invoke-OrdnerHash @("-Pfad", $ordner, "-Sortierung", "Ordinal", "-Erwartet", $kultur)
        if ($ergebnis.ExitCode -ne 1) { throw "Erwartet: Exit-Code 1. Erhalten: $($ergebnis.ExitCode).`n$($ergebnis.Ausgabe)" }
        Assert-Enthaelt $ergebnis "Ordner-Hash: $ordinal"
        Assert-Enthaelt $ergebnis "Vergleich: ABWEICHUNG"
    }

    It "schreibt, verschiebt und löscht nichts im Ordner" {
        $ordner = New-TestOrdner "unveraendert"
        $vorher = Get-Stand $ordner
        $ergebnis = Invoke-OrdnerHash @("-Pfad", $ordner, "-Zeilen")
        Assert-Erfolg $ergebnis "Ordner-Hash: [0-9A-F]{64}"
        Assert-Enthaelt $ergebnis "  [0-9A-F]{64}  paket\\UPLOAD-MANIFEST\.txt"
        $nachher = Get-Stand $ordner
        if ($nachher -ne $vorher) { throw "Der Ordner hat sich verändert.`nVorher:`n$vorher`nNachher:`n$nachher" }
    }

    It "bricht bei einem Cloud-Platzhalter ab, ohne zu hashen (Attribut Offline)" -Skip:$ohneWindows {
        $ordner = New-TestOrdner "platzhalter"
        $datei = Get-Item -LiteralPath (Join-Path $ordner "paket\index.html")
        $datei.Attributes = $datei.Attributes -bor [System.IO.FileAttributes]::Offline
        $ergebnis = Invoke-OrdnerHash @("-Pfad", $ordner)
        if ($ergebnis.ExitCode -ne 2) { throw "Erwartet: Exit-Code 2. Erhalten: $($ergebnis.ExitCode).`n$($ergebnis.Ausgabe)" }
        Assert-Enthaelt $ergebnis "Cloud-Platzhalter: 1"
        Assert-Enthaelt $ergebnis "paket\\index\.html \(.*Offline"
        Assert-Enthaelt $ergebnis "Abbruch, kein Hash berechnet: Cloud-Platzhalter gefunden"
        if ($ergebnis.Ausgabe -match "Ordner-Hash:") { throw "Trotz Platzhalter wurde ein Hash ausgegeben.`n$($ergebnis.Ausgabe)" }
    }

    It "bricht bei fehlendem oder leerem Ordner mit Exit 2 ab" {
        $fehlt = Invoke-OrdnerHash @("-Pfad", (Join-Path $TestDrive "gibt-es-nicht"))
        if ($fehlt.ExitCode -ne 2) { throw "Erwartet: Exit-Code 2. Erhalten: $($fehlt.ExitCode).`n$($fehlt.Ausgabe)" }
        Assert-Enthaelt $fehlt "Abbruch, kein Hash berechnet: Ordner fehlt"
        if (Test-Path -LiteralPath (Join-Path $TestDrive "gibt-es-nicht")) { throw "Der fehlende Ordner wurde angelegt." }

        $leer = Join-Path $TestDrive "leer"
        New-Item -ItemType Directory -Path $leer | Out-Null
        $ergebnis = Invoke-OrdnerHash @("-Pfad", $leer)
        if ($ergebnis.ExitCode -ne 2) { throw "Erwartet: Exit-Code 2. Erhalten: $($ergebnis.ExitCode).`n$($ergebnis.Ausgabe)" }
        Assert-Enthaelt $ergebnis "keine Dateien"
    }
}
