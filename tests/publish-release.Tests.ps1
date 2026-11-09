# Pester-Tests für scripts/publish-release.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Prüfung der PDF-Version braucht pdftotext (Poppler); ohne pdftotext
# werden die Tests übersprungen.

$ohnePdfToText = -not (Get-Command pdftotext -ErrorAction SilentlyContinue)

Describe "publish-release.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Basis = Join-Path $TestDrive "publish-release"
    }

    It "bricht ab, wenn die PDF eine andere Deckblatt-Version trägt als die HTML" -Skip:$ohnePdfToText {
        # HTML-Quelle: Version 1.02; neue PDF unter source/: Version 1.01.
        $projekt = New-MiniProjekt -Ziel "$script:Basis-abweichend"
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot "fixtures/pdf/deckblatt-v1.01.pdf") `
            -Destination (Join-Path $projekt "source/Die-Fahrt-zum-Kunden.pdf") -Force
        $veroeffentlicht = Join-Path $projekt "story/current/geschichte.pdf"
        $hashVorher = (Get-FileHash -Algorithm SHA256 -LiteralPath $veroeffentlicht).Hash

        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "publish-release.ps1" -Argumente @("-PageCount", "1")

        Assert-Fehlschlag $ergebnis "PDF passt nicht zur HTML-Quelle: source/Die-Fahrt-zum-Kunden\.pdf trägt Version 1\.01, source/fahrt-zum-kunden\.html Version 1\.02"
        # Abbruch vor dem Kopieren: die veröffentlichte PDF bleibt unverändert.
        $hashNachher = (Get-FileHash -Algorithm SHA256 -LiteralPath $veroeffentlicht).Hash
        if ($hashNachher -ne $hashVorher) { throw "story/current/geschichte.pdf wurde trotz Abbruch ersetzt." }
    }

    It "akzeptiert eine PDF mit passender Deckblatt-Version (Gegenprobe)" -Skip:$ohnePdfToText {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-passend"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "publish-release.ps1" -Argumente @("-PageCount", "1")
        # Der weitere Lauf (Paketbau) bricht im Mini-Projekt ab, weil die
        # Podcast-Dateien fehlen. Geprüft wird nur, dass die PDF-Prüfung bestanden ist.
        Assert-Enthaelt $ergebnis "OK: PDF-Deckblatt trägt Version 1\.02 wie die HTML-Quelle\."
        # R49: Das Mini-Projekt hat kein archive/ftp-packages; die Meldung läuft ohne Fehler.
        Assert-Enthaelt $ergebnis "Aufbewahrung archive/ftp-packages: Ordner fehlt, nichts zu melden\."
    }
}

# Aufbewahrungsregel für archive/ftp-packages (R49). Die beiden Funktionen
# werden per AST aus publish-release.ps1 gelesen, ohne das Skript zu starten.
# Alle Ordner liegen im TestDrive; das echte Archiv wird nie berührt.
Describe "publish-release.ps1: Aufbewahrung archive/ftp-packages" {
    BeforeAll {
        $skriptPfad = Join-Path (Split-Path -Parent $PSScriptRoot) "scripts/publish-release.ps1"
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($skriptPfad, [ref]$null, [ref]$null)
        foreach ($name in @("Get-FtpPaketAufbewahrung", "Write-FtpPaketAufbewahrung")) {
            $funktion = $ast.Find({ param($k)
                $k -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $k.Name -eq $name }, $true)
            if (-not $funktion) { throw "Funktion $name fehlt in publish-release.ps1." }
            . ([scriptblock]::Create($funktion.Extent.Text))
        }

        # Legt Paketordner an. Das Änderungsdatum wird absichtlich gegenläufig
        # zum Zeitstempel im Namen gesetzt, damit eine Sortierung nach
        # Änderungsdatum auffallen würde.
        function New-Archiv([string]$Ziel, [string[]]$Namen, [string[]]$Geschuetzt = @()) {
            New-Item -ItemType Directory -Path $Ziel -Force | Out-Null
            $i = 0
            foreach ($name in $Namen) {
                $ordner = Join-Path $Ziel $name
                New-Item -ItemType Directory -Path $ordner -Force | Out-Null
                Set-Content -LiteralPath (Join-Path $ordner "UPLOAD-MANIFEST.txt") -Value "Testpaket $name"
                if ($Geschuetzt -contains $name) {
                    Set-Content -LiteralPath (Join-Path $ordner "GESCHUETZT.txt") -Value "Testgrund"
                }
                (Get-Item -LiteralPath $ordner).LastWriteTime = [datetime]'2020-01-01' + [timespan]::FromDays($i)
                $i++
            }
        }

        function Get-Inventur([string]$Ziel) {
            return @(Get-ChildItem -LiteralPath $Ziel -Recurse -Force | ForEach-Object {
                "$($_.FullName.Substring($Ziel.Length))|$($_.LastWriteTimeUtc.Ticks)"
            } | Sort-Object) -join "`n"
        }

        function Assert-Namen($Ist, [string[]]$Soll, [string]$Was) {
            $istText = @($Ist | ForEach-Object Name) -join ','
            $sollText = $Soll -join ','
            if ($istText -ne $sollText) { throw "${Was}: erwartet '$sollText', erhalten '$istText'." }
        }
    }

    It "meldet nur Pakete älter als die letzten drei, sortiert nach dem Namen, nicht nach dem Änderungsdatum" {
        $archiv = Join-Path $TestDrive "fuenf"
        # Absichtlich ungeordnet angelegt; das neueste bekommt das älteste Änderungsdatum.
        New-Archiv $archiv @("20260905-195306-580", "20260904-070529-752", "20260905-192045-642",
            "20261109-101500-001", "20260905-192135-924")
        $erg = Get-FtpPaketAufbewahrung -ArchivOrdner $archiv
        Assert-Namen $erg.Behalten @("20261109-101500-001", "20260905-195306-580", "20260905-192135-924") "Behalten"
        Assert-Namen $erg.Melden @("20260905-192045-642", "20260904-070529-752") "Melden"
        if ($erg.OrdnerFehlt) { throw "OrdnerFehlt darf nicht gesetzt sein." }
    }

    It "meldet ein geschütztes Paket (GESCHUETZT.txt) nie, auch wenn es älter ist" {
        $archiv = Join-Path $TestDrive "geschuetzt"
        New-Archiv $archiv @("20260904-070529-752", "20260905-192045-642", "20260905-193924-327",
            "20260905-195306-580", "20261109-101500-001", "20261110-080000-000") -Geschuetzt @("20260905-193924-327")
        $erg = Get-FtpPaketAufbewahrung -ArchivOrdner $archiv
        Assert-Namen $erg.Melden @("20260905-192045-642", "20260904-070529-752") "Melden"
        Assert-Namen $erg.Geschuetzt @("20260905-193924-327") "Geschützt"
        $text = (Write-FtpPaketAufbewahrung $erg 6>&1 | ForEach-Object { "$_" }) -join "`n"
        if ($text -notmatch 'Geschützt, nicht gemeldet: 20260905-193924-327') { throw "Hinweis auf geschütztes Paket fehlt:`n$text" }
        $gemeldet = ($text -split "`n" | Where-Object { $_ -match '^\s+\d{8}-' }) -join ','
        if ($gemeldet -match '20260905-193924-327') { throw "Geschütztes Paket wurde gemeldet:`n$text" }
    }

    It "verändert das Archiv nicht (kein Löschen, kein Verschieben, keine neue Datei)" {
        $archiv = Join-Path $TestDrive "unveraendert"
        New-Archiv $archiv @("20260901-000000-000", "20260902-000000-000", "20260903-000000-000",
            "20260904-000000-000", "20260905-000000-000") -Geschuetzt @("20260901-000000-000")
        $vorher = Get-Inventur $archiv
        $erg = Get-FtpPaketAufbewahrung -ArchivOrdner $archiv
        Write-FtpPaketAufbewahrung $erg 6>&1 | Out-Null
        $nachher = Get-Inventur $archiv
        if ($nachher -ne $vorher) { throw "Archiv wurde verändert.`nVorher:`n$vorher`nNachher:`n$nachher" }
    }

    It "meldet nichts bei drei oder weniger Paketen und ignoriert fremde Namen und Dateien" {
        $archiv = Join-Path $TestDrive "wenige"
        New-Archiv $archiv @("20260905-195306-580", "20260905-193924-327", "notizen", "20261399-000000-000")
        Set-Content -LiteralPath (Join-Path $archiv "lose-datei.txt") -Value "keine Paketdatei"
        $erg = Get-FtpPaketAufbewahrung -ArchivOrdner $archiv
        if (@($erg.Melden).Count -ne 0) { throw "Bei zwei Paketen darf nichts gemeldet werden." }
        Assert-Namen $erg.Pakete @("20260905-195306-580", "20260905-193924-327") "Pakete"
        if ((@($erg.Unbekannt) -join ',') -ne "20261399-000000-000,notizen") { throw "Unbekannte Ordner: $(@($erg.Unbekannt) -join ',')" }
        $text = (Write-FtpPaketAufbewahrung $erg 6>&1 | ForEach-Object { "$_" }) -join "`n"
        if ($text -notmatch 'Keine Pakete älter als die letzten 3 zu melden') { throw "Meldung fehlt:`n$text" }
    }

    It "leerer Ordner: kein Fehler, nichts zu melden" {
        $archiv = Join-Path $TestDrive "leer"
        New-Item -ItemType Directory -Path $archiv -Force | Out-Null
        $erg = Get-FtpPaketAufbewahrung -ArchivOrdner $archiv
        if (@($erg.Pakete).Count -ne 0 -or @($erg.Melden).Count -ne 0 -or $erg.OrdnerFehlt) { throw "Leerer Ordner falsch bewertet." }
    }

    It "fehlender Ordner archive/ftp-packages: kein Fehler, kein Ordner wird angelegt" {
        $archiv = Join-Path $TestDrive "gibt-es-nicht/archive/ftp-packages"
        $erg = Get-FtpPaketAufbewahrung -ArchivOrdner $archiv
        if (-not $erg.OrdnerFehlt) { throw "OrdnerFehlt muss gesetzt sein." }
        $text = (Write-FtpPaketAufbewahrung $erg 6>&1 | ForEach-Object { "$_" }) -join "`n"
        if ($text -notmatch 'Ordner fehlt, nichts zu melden') { throw "Meldung fehlt:`n$text" }
        if (Test-Path -LiteralPath (Join-Path $TestDrive "gibt-es-nicht")) { throw "Es wurde ein Ordner angelegt." }
    }
}
