# Pester-Tests für scripts/pruefe-paket.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Tests bauen kleine Testpakete (ZIP mit UPLOAD-MANIFEST.txt im Format von
# build-upload.ps1) im TestDrive. Das Skript wird unverändert aus scripts/ in
# einem eigenen pwsh-Prozess gestartet; es liest nur.

Describe "pruefe-paket.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        Add-Type -AssemblyName System.IO.Compression
        Add-Type -AssemblyName System.IO.Compression.FileSystem

        function Get-TextHash([string]$Text) {
            $sha = [System.Security.Cryptography.SHA256]::Create()
            try {
                $bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes($Text)
                return [System.BitConverter]::ToString($sha.ComputeHash($bytes)).Replace("-", "")
            } finally {
                $sha.Dispose()
            }
        }

        # Baut ein Test-ZIP. $Dateien: Name (mit /) -> Inhalt. Das Manifest
        # nennt die Dateien aus $Dateien, außer denen in -NichtImManifest;
        # -ManifestHash überschreibt einzelne Prüfsummen im Manifest.
        # Die Einträge werden mit festen Namen (/) angelegt, damit das ZIP
        # unter Windows und Linux gleich aussieht.
        function New-TestZip {
            param(
                [Parameter(Mandatory)][string]$Name,
                [Parameter(Mandatory)][System.Collections.Specialized.OrderedDictionary]$Dateien,
                [string[]]$NichtImManifest = @(),
                [hashtable]$ManifestHash = @{},
                [string[]]$NurImManifest = @(),
                [switch]$OhneManifest
            )
            $manifest = @(
                "RelingIT FTP-Upload-Paket", "Version: 1.02", "Veröffentlichungsdatum: 7. November 2026",
                "Erstellt: 2026-11-11 06:00:00 +01:00", "", "SHA-256-Prüfsummen:"
            )
            foreach ($datei in $Dateien.Keys) {
                if ($datei -in $NichtImManifest) { continue }
                $hash = if ($ManifestHash.ContainsKey($datei)) { $ManifestHash[$datei] } else { Get-TextHash $Dateien[$datei] }
                $manifest += "$hash  $datei"
            }
            foreach ($datei in $NurImManifest) { $manifest += "$(Get-TextHash 'fehlt')  $datei" }

            $pfad = Join-Path $TestDrive "$Name.zip"
            $strom = [System.IO.File]::Open($pfad, [System.IO.FileMode]::CreateNew)
            $archiv = New-Object System.IO.Compression.ZipArchive($strom, [System.IO.Compression.ZipArchiveMode]::Create)
            try {
                $inhalt = [ordered]@{}
                foreach ($datei in $Dateien.Keys) { $inhalt[$datei] = $Dateien[$datei] }
                if (-not $OhneManifest) { $inhalt["UPLOAD-MANIFEST.txt"] = ($manifest -join "`r`n") + "`r`n" }
                foreach ($datei in $inhalt.Keys) {
                    $eintrag = $archiv.CreateEntry($datei)
                    $schreiber = New-Object System.IO.StreamWriter($eintrag.Open(), (New-Object System.Text.UTF8Encoding($false)))
                    try { $schreiber.Write($inhalt[$datei]) } finally { $schreiber.Dispose() }
                }
            } finally {
                $archiv.Dispose()
                $strom.Dispose()
            }
            return $pfad
        }

        $script:Basis = [ordered]@{
            ".htaccess"         = "Header always set X-Test 1`n"
            "index.html"        = "<p>Start</p>`n"
            "assets/js/app.js"  = "// app`n"
        }
        function Copy-Basis {
            $kopie = [ordered]@{}
            foreach ($datei in $script:Basis.Keys) { $kopie[$datei] = $script:Basis[$datei] }
            return $kopie
        }

        # Stand eines Ordners: Dateien mit Länge, Änderungszeit und Attributen.
        function Get-Stand([string]$Ordner) {
            return (@(Get-ChildItem -LiteralPath $Ordner -Recurse -Force -File) |
                ForEach-Object { "$($_.FullName)|$($_.Length)|$($_.LastWriteTimeUtc.Ticks)|$($_.Attributes)" } |
                Sort-Object) -join "`n"
        }

        # Startet das Skript mit -File in einem eigenen pwsh-Prozess, damit
        # die Exit-Codes 1 und 2 unverändert ankommen (-Command liefert nur 0/1).
        function Invoke-PruefePaket([string[]]$Argumente) {
            $skript = Join-Path $script:RepoRoot "scripts/pruefe-paket.ps1"
            $vorher = $ErrorActionPreference
            $vorherEncoding = [Console]::OutputEncoding
            $ErrorActionPreference = "Continue"
            [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            try {
                $ausgabe = & (Get-PwshPfad) -NoProfile -NonInteractive -File $skript @Argumente 2>&1 | ForEach-Object { "$_" }
                $exitCode = $LASTEXITCODE
            } finally {
                $ErrorActionPreference = $vorher
                [Console]::OutputEncoding = $vorherEncoding
            }
            return [pscustomobject]@{ ExitCode = $exitCode; Ausgabe = ($ausgabe -join "`n") }
        }

        function Assert-ExitCode($Ergebnis, [int]$Erwartet) {
            if ($Ergebnis.ExitCode -ne $Erwartet) {
                throw "Erwartet: Exit-Code $Erwartet. Erhalten: $($Ergebnis.ExitCode).`n$($Ergebnis.Ausgabe)"
            }
        }
    }

    It "bestätigt ein Paket, das zum Manifest passt, und zählt die Einträge" {
        $zip = New-TestZip -Name "ok" -Dateien (Copy-Basis)
        $ergebnis = Invoke-PruefePaket @("-Zip", $zip)
        Assert-Erfolg $ergebnis "Ergebnis: OK, Paket gleich Manifest"
        Assert-Enthaelt $ergebnis "Einträge: 4 \(3 Nutzdateien \+ UPLOAD-MANIFEST\.txt\)"
        Assert-Enthaelt $ergebnis "Manifest: 3 Prüfsummen; 3 gleich, 0 abweichend, 0 fehlen im ZIP, 0 zusätzlich im ZIP"
        Assert-Enthaelt $ergebnis "\| 1 \| ``\.htaccess`` \| ``$(Get-TextHash $script:Basis['.htaccess'])`` \| 27 \| gleich \|"
        Assert-Enthaelt $ergebnis "\| 4 \| ``UPLOAD-MANIFEST\.txt`` \|"
        Assert-Enthaelt $ergebnis "\| Manifest Version \| 1\.02 \|"
        if ($ergebnis.Ausgabe -match "Vorgänger") { throw "Ohne -Vorgaenger erscheint ein Vorgänger-Vergleich.`n$($ergebnis.Ausgabe)" }
    }

    It "vergleicht mit dem Vorgänger: geändert, neu, unverändert, entfallen" {
        $alt = Copy-Basis
        $alt["alt.html"] = "<p>alt</p>`n"
        $vorgaenger = New-TestZip -Name "vorgaenger" -Dateien $alt
        $neu = Copy-Basis
        $neu["index.html"] = "<p>Start, neue Fassung</p>`n"
        $neu["assets/fonts/neu.woff2"] = "woff2`n"
        $zip = New-TestZip -Name "neu" -Dateien $neu

        $ergebnis = Invoke-PruefePaket @("-Zip", $zip, "-Vorgaenger", $vorgaenger)
        Assert-Erfolg $ergebnis "Ergebnis: OK"
        Assert-Enthaelt $ergebnis "\| ``index\.html`` \| .* \| gleich \| \*\*geändert\*\* \|"
        Assert-Enthaelt $ergebnis "\| ``assets/fonts/neu\.woff2`` \| .* \| gleich \| \*\*neu\*\* \|"
        Assert-Enthaelt $ergebnis "\| ``\.htaccess`` \| .* \| gleich \| unverändert \|"
        Assert-Enthaelt $ergebnis "2 geändert oder neu \(1 geändert, 1 neu\), 2 unverändert, 1 entfallen"
        Assert-Enthaelt $ergebnis "entfallen \(nur im Vorgänger\): ``alt\.html``"
    }

    It "nimmt als Vorgänger auch den entpackten Ordner" {
        $ordner = Join-Path $TestDrive "vorgaenger-ordner"
        foreach ($datei in $script:Basis.Keys) {
            Write-Utf8Datei (Join-Path $ordner ($datei -replace '/', [IO.Path]::DirectorySeparatorChar)) $script:Basis[$datei]
        }
        $neu = Copy-Basis
        $neu["assets/js/app.js"] = "// app, neu`n"
        $zip = New-TestZip -Name "gegen-ordner" -Dateien $neu
        $ergebnis = Invoke-PruefePaket @("-Zip", $zip, "-Vorgaenger", $ordner)
        Assert-Erfolg $ergebnis "Ergebnis: OK"
        Assert-Enthaelt $ergebnis "1 geändert oder neu \(1 geändert, 0 neu\), 2 unverändert, 0 entfallen"
    }

    It "vergleicht den ZIP-Hash mit -ErwartetHash (gleich Exit 0, abweichend Exit 1)" {
        $zip = New-TestZip -Name "hash" -Dateien (Copy-Basis)
        $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $zip).Hash
        $gleich = Invoke-PruefePaket @("-Zip", $zip, "-ErwartetHash", $hash.ToLowerInvariant())
        Assert-Erfolg $gleich "ZIP-Hash: gleich -ErwartetHash"
        Assert-Enthaelt $gleich "\| SHA-256 \| ``$hash`` \|"

        $anders = Invoke-PruefePaket @("-Zip", $zip, "-ErwartetHash", ("0" * 64))
        Assert-ExitCode $anders 1
        Assert-Enthaelt $anders "ZIP-Hash: \*\*ABWEICHUNG\*\*, erwartet 0{64}"
        Assert-Enthaelt $anders "ZIP-Hash ungleich -ErwartetHash"
    }

    It "meldet eine Datei, deren Prüfsumme nicht zum Manifest passt, mit Exit 1" {
        $zip = New-TestZip -Name "falsch" -Dateien (Copy-Basis) -ManifestHash @{ "index.html" = ("A" * 64) }
        $ergebnis = Invoke-PruefePaket @("-Zip", $zip)
        Assert-ExitCode $ergebnis 1
        Assert-Enthaelt $ergebnis "\| ``index\.html`` \| .* \| \*\*ABWEICHUNG\*\*, Manifest A{64} \|"
        Assert-Enthaelt $ergebnis "2 gleich, 1 abweichend"
        Assert-Enthaelt $ergebnis "Prüfsumme weicht vom Manifest ab: index\.html"
    }

    It "meldet fehlende und zusätzliche Dateien mit Exit 1" {
        $dateien = Copy-Basis
        $dateien["extra.txt"] = "nicht im Manifest`n"
        $zip = New-TestZip -Name "fehlt" -Dateien $dateien -NichtImManifest @("extra.txt") -NurImManifest @("assets/css/styles.css")
        $ergebnis = Invoke-PruefePaket @("-Zip", $zip)
        Assert-ExitCode $ergebnis 1
        Assert-Enthaelt $ergebnis "\| ``assets/css/styles\.css`` \| – \| – \| \*\*fehlt im ZIP\*\* \|"
        Assert-Enthaelt $ergebnis "\| ``extra\.txt`` \| .* \| \*\*zusätzlich, nicht im Manifest\*\* \|"
        Assert-Enthaelt $ergebnis "1 fehlen im ZIP, 1 zusätzlich im ZIP"
        Assert-Enthaelt $ergebnis "Ergebnis: \*\*ABWEICHUNG\*\* \(2\)"
    }

    It "meldet ein ZIP ohne UPLOAD-MANIFEST.txt mit Exit 1" {
        $zip = New-TestZip -Name "ohne-manifest" -Dateien (Copy-Basis) -OhneManifest
        $ergebnis = Invoke-PruefePaket @("-Zip", $zip)
        Assert-ExitCode $ergebnis 1
        Assert-Enthaelt $ergebnis "Einträge: 3 \(3 Nutzdateien, ohne UPLOAD-MANIFEST\.txt\)"
        Assert-Enthaelt $ergebnis "UPLOAD-MANIFEST\.txt fehlt im ZIP"
    }

    It "bricht bei fehlendem oder unlesbarem ZIP und fehlendem Vorgänger mit Exit 2 ab" {
        $fehlt = Invoke-PruefePaket @("-Zip", (Join-Path $TestDrive "gibt-es-nicht.zip"))
        Assert-ExitCode $fehlt 2
        Assert-Enthaelt $fehlt "Abbruch, keine Prüfung: ZIP fehlt"

        $kaputt = Join-Path $TestDrive "kaputt.zip"
        Write-Utf8Datei $kaputt "kein ZIP`n"
        $ergebnis = Invoke-PruefePaket @("-Zip", $kaputt)
        Assert-ExitCode $ergebnis 2
        Assert-Enthaelt $ergebnis "Abbruch, keine Prüfung: ZIP nicht lesbar"

        $zip = New-TestZip -Name "ohne-vorgaenger" -Dateien (Copy-Basis)
        $ohne = Invoke-PruefePaket @("-Zip", $zip, "-Vorgaenger", (Join-Path $TestDrive "gibt-es-nicht"))
        Assert-ExitCode $ohne 2
        Assert-Enthaelt $ohne "Abbruch, keine Prüfung: Vorgänger fehlt"
        if (Test-Path -LiteralPath (Join-Path $TestDrive "gibt-es-nicht")) { throw "Der fehlende Vorgänger wurde angelegt." }
    }

    It "liest nur: ZIP, Vorgänger und Temp-Verzeichnis bleiben unverändert" {
        $ordner = Join-Path $TestDrive "nur-lesen"
        New-Item -ItemType Directory -Path $ordner | Out-Null
        $vorgaenger = New-TestZip -Name "nur-lesen-alt" -Dateien (Copy-Basis)
        $zip = New-TestZip -Name "nur-lesen-neu" -Dateien (Copy-Basis)
        Move-Item -LiteralPath $vorgaenger -Destination $ordner
        Move-Item -LiteralPath $zip -Destination $ordner
        $temp = [System.IO.Path]::GetTempPath()
        $tempVorher = @(Get-ChildItem -LiteralPath $temp -Force -ErrorAction SilentlyContinue | ForEach-Object Name)
        $vorher = Get-Stand $ordner

        $ergebnis = Invoke-PruefePaket @("-Zip", (Join-Path $ordner "nur-lesen-neu.zip"), "-Vorgaenger", (Join-Path $ordner "nur-lesen-alt.zip"))
        Assert-Erfolg $ergebnis "0 geändert oder neu \(0 geändert, 0 neu\), 3 unverändert, 0 entfallen"

        $nachher = Get-Stand $ordner
        if ($nachher -ne $vorher) { throw "Der Ordner hat sich verändert.`nVorher:`n$vorher`nNachher:`n$nachher" }
        $tempNeu = @(Get-ChildItem -LiteralPath $temp -Force -ErrorAction SilentlyContinue | ForEach-Object Name |
            Where-Object { $_ -notin $tempVorher -and $_ -match 'UPLOAD-MANIFEST|nur-lesen' })
        if ($tempNeu.Count -gt 0) { throw "Im Temp-Verzeichnis sind Paketreste entstanden: $($tempNeu -join ', ')" }
    }
}
