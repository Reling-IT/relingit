# Pester-Tests für scripts/freigabe-pruefen.ps1 und scripts/vorschau.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Tests laufen im temporären Mini-Projekt mit eigenem Git-Repository und
# einem lokalen Bare-Repository als origin. Kein Netzwerkzugriff, kein gh
# (-OhneGh), keine verschachtelten Pester-Läufe (-OhnePester).

Describe "freigabe-pruefen.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Basis = Join-Path $TestDrive "freigabe"

        # Mini-Projekt als Git-Repository auf einem gepushten Feature-Branch.
        # commit.gpgsign gilt nur im Wegwerf-Repository des Tests, damit die
        # Fixture-Commits ohne Signaturschlüssel entstehen.
        function New-FreigabeProjekt([string]$Ziel, [string]$Geschichte = "basis.html.fixture") {
            $projekt = New-MiniProjekt -Ziel $Ziel -Geschichte $Geschichte
            foreach ($skript in @("freigabe-pruefen.ps1", "vorschau.ps1")) {
                Copy-Item -LiteralPath (Join-Path $script:RepoRoot "scripts/$skript") -Destination (Join-Path $projekt "scripts/$skript")
            }
            # Platzhalter-JS aus dem Helfer sind kein gültiges JavaScript; für node --check ersetzen.
            foreach ($js in @("pdf-viewer.js", "story-viewer.js", "handout-viewer.js", "supabase-config.js")) {
                Write-Utf8Datei (Join-Path $projekt "assets/js/$js") "// Platzhalter für Tests`n"
            }
            Write-Utf8Datei (Join-Path $projekt ".gitignore") "reports/`noutput/`n"
            $origin = "$Ziel-origin.git"
            $vorher = $ErrorActionPreference
            $ErrorActionPreference = "Continue"
            try {
                git init -q --bare $origin 2>&1 | Out-Null
                git -C $projekt init -q 2>&1 | Out-Null
                git -C $projekt config user.name "Test" 2>&1 | Out-Null
                git -C $projekt config user.email "test@example.invalid" 2>&1 | Out-Null
                git -C $projekt config commit.gpgsign false 2>&1 | Out-Null
                git -C $projekt config core.autocrlf false 2>&1 | Out-Null
                git -C $projekt checkout -q -b auftrag-test 2>&1 | Out-Null
                git -C $projekt add -A 2>&1 | Out-Null
                git -C $projekt commit -q -m "Testprojekt" 2>&1 | Out-Null
                git -C $projekt remote add origin $origin 2>&1 | Out-Null
                git -C $projekt push -q -u origin auftrag-test 2>&1 | Out-Null
                # origin/main für den Hinweis auf Rückstand anlegen (gleicher Stand).
                git -C $projekt push -q origin auftrag-test:main 2>&1 | Out-Null
                git -C $projekt fetch -q origin 2>&1 | Out-Null
            } finally {
                $ErrorActionPreference = $vorher
            }
            if (-not (Test-Path -LiteralPath (Join-Path $projekt ".git"))) { throw "Git-Repository im Mini-Projekt nicht angelegt." }
            return $projekt
        }

        function Get-Bericht([string]$Projekt, [string]$Name) {
            $pfad = Join-Path $Projekt "reports/$Name"
            if (-not (Test-Path -LiteralPath $pfad)) { throw "Bericht fehlt: $pfad" }
            return Get-Content -Raw -Encoding utf8 -LiteralPath $pfad
        }

        function Assert-NieBestanden([string]$Bericht) {
            foreach ($tor in @("G3", "G4", "G5", "G8")) {
                if ($Bericht -match "(?m)^\| $tor \|[^\n]*\| bestanden \|") { throw "$tor wurde als bestanden ausgegeben:`n$Bericht" }
            }
        }

        # Legt unter output/ftp ein kleines Upload-Paket wie aus build-upload.ps1 an
        # (UPLOAD-MANIFEST.txt, index.html, optional die vier Ersatz-MP3).
        function New-TestPaket([string]$Projekt, [string]$Name, [switch]$MitMp3, [switch]$OhneAudioZeile) {
            $ordner = Join-Path $TestDrive "paket-$Name"
            $manifest = @("RelingIT FTP-Upload-Paket", "Version: 1.02")
            if ($OhneAudioZeile) { $manifest += "Ohne Audio: Die Podcast-MP3 sind nicht enthalten, die Live-Dateien unter assets/audio bleiben unverändert." }
            Write-Utf8Datei (Join-Path $ordner "UPLOAD-MANIFEST.txt") (($manifest -join "`n") + "`n")
            Write-Utf8Datei (Join-Path $ordner "index.html") "Platzhalter für Tests`n"
            if ($MitMp3) {
                foreach ($mp3 in $script:PodcastMp3) { Write-Utf8Datei (Join-Path $ordner "assets/audio/$mp3") "ID3 Ersatz-MP3 für Tests: $mp3`n" }
            }
            $ziel = Join-Path $Projekt "output/ftp"
            New-Item -ItemType Directory -Path $ziel -Force | Out-Null
            $zip = Join-Path $ziel "$Name.zip"
            Compress-Archive -Path (Join-Path $ordner "*") -DestinationPath $zip
            return $zip
        }

        function Set-SichtungErgebnis([string]$Projekt, [string]$Wert, [string]$NurNr = "") {
            $pfad = Join-Path $Projekt "reports/SICHTUNG-v1.02.md"
            $zeilen = Get-Content -Encoding utf8 -LiteralPath $pfad | ForEach-Object {
                if ($_ -match '^\| (?<nr>[WPI]\d{2}) \|' -and (-not $NurNr -or $Matches.nr -eq $NurNr)) { $_ -replace '\|  \|  \|$', "| $Wert | Test |" } else { $_ }
            }
            Write-Utf8Datei $pfad (($zeilen -join "`n") + "`n")
        }
    }

    It "schreibt Freigabebericht und Sichtungsliste und gibt G3, G4, G5 und G8 nie als bestanden aus" {
        $projekt = New-FreigabeProjekt "$script:Basis-ok"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh")
        Assert-Erfolg $ergebnis "Ergebnis: keine automatische Prüfung nicht bestanden"

        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        foreach ($muster in @(
            '\| G1 \| ci-check\.ps1 \| bestanden \| Exit 0',
            '\| G1 \| node --check \| bestanden \|',
            '\| G1 \| Pester-Tests \| offen \| mit -OhnePester übersprungen',
            '\| G2 \| Kopfkommentar je Skript \| bestanden \|',
            '\| G3 \| Layout \| offen \|', '\| G4 \| UI \| offen \|', '\| G5 \| Inhalt \| offen \|',
            '\| G7 \| git status sauber \| bestanden \|',
            '\| G7 \| Feature-Branch, gleich Upstream \| bestanden \| Branch auftrag-test',
            '\| G8 \| Freigabe Bernd \| gesperrt \|'
        )) {
            if ($bericht -notmatch $muster) { throw "Muster '$muster' fehlt im Bericht:`n$bericht" }
        }
        Assert-NieBestanden $bericht

        $sichtung = Get-Bericht $projekt "SICHTUNG-v1.02.md"
        if ($sichtung -notmatch '\| Nr \| Tor \| Bereich \| Prüfpunkt \| Breite \| Ergebnis \(Ja/Nein\) \| Bemerkung \|') { throw "Spaltenkopf der Sichtungsliste fehlt." }
        $punkte = [regex]::Matches($sichtung, '(?m)^\| [WPI]\d{2} \|').Count
        if ($punkte -ne 26) { throw "Erwartet 26 Prüfpunkte (18 Webseiten, 6 PDF, 2 Inhalt), gefunden: $punkte" }
        foreach ($muster in @("Startseite", "Lesefassung", "Handout", "Datenschutz", "Impressum", "Podcast-Player", "390 px", "768 px", "1280 px",
            "PDF: Deckblatt", "PDF: Neue Szene", "PDF: Codebox", "PDF: SVG-Seite", "PDF: Mini-TOC", "PDF: Seitenzahl")) {
            if (-not $sichtung.Contains($muster)) { throw "Prüfpunkt '$muster' fehlt in der Sichtungsliste." }
        }

        # Die Berichte liegen in reports/ (ignoriert) und machen den Arbeitsbaum nicht unsauber.
        if (git -C $projekt status --porcelain) { throw "reports/ verändert git status." }
    }

    It "meldet einen unsauberen Arbeitsbaum unter G7 und endet mit Exit-Code 1" {
        $projekt = New-FreigabeProjekt "$script:Basis-unsauber"
        Write-Utf8Datei (Join-Path $projekt "notiz.txt") "nicht committet`n"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh")
        Assert-Fehlschlag $ergebnis "automatische Prüfung\(en\) nicht bestanden"
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G7 \| git status sauber \| nicht bestanden \| 1 Änderung\(en\): \?\? notiz\.txt') { throw "G7 meldet die Änderung nicht:`n$bericht" }
    }

    It "meldet einen Fehler aus ci-check.ps1 unter G1" {
        $projekt = New-FreigabeProjekt "$script:Basis-ci" -Geschichte "fehlender-anker.html.fixture"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh")
        Assert-Fehlschlag $ergebnis "nicht bestanden"
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G1 \| Code \| nicht bestanden \|') { throw "G1 nicht als nicht bestanden gemeldet:`n$bericht" }
        Assert-NieBestanden $bericht
    }

    It "überschreibt eine ausgefüllte Sichtungsliste nicht und lässt G3 bis G5 trotz Ja offen" {
        $projekt = New-FreigabeProjekt "$script:Basis-ja"
        [void](Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh"))
        Set-SichtungErgebnis $projekt "Ja"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh")
        Assert-Enthaelt $ergebnis "vorhanden, ausgewertet, nicht überschrieben"

        $sichtung = Get-Bericht $projekt "SICHTUNG-v1.02.md"
        if ([regex]::Matches($sichtung, '\| Ja \| Test \|').Count -ne 26) { throw "Ausgefüllte Sichtungsliste wurde überschrieben." }
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G4 \| Sichtung Webseiten in 390, 768 und 1280 px \| offen \| SICHTUNG-v1\.02\.md: 18 Ja, 0 Nein, 0 leer von 18; vollständig') { throw "G4-Auswertung fehlt:`n$bericht" }
        Assert-NieBestanden $bericht
        if (git -C $projekt status --porcelain) { throw "Zweiter Lauf verändert git status." }
    }

    It "sperrt G8, solange die Sichtung einen Nein-Punkt enthält" {
        $projekt = New-FreigabeProjekt "$script:Basis-nein"
        [void](Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh"))
        Set-SichtungErgebnis $projekt "Nein" "W01"
        Set-SichtungErgebnis $projekt "Ja"
        [void](Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh"))
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch 'SICHTUNG-v1\.02\.md: 17 Ja, 1 Nein, 0 leer von 18 \(Nein: W01\)') { throw "Nein-Punkt nicht ausgewertet:`n$bericht" }
        if ($bericht -notmatch '\| G8 \| Freigabe durch Bernd \| gesperrt \|[^\n]*G4 Sichtung unvollständig \(1 Nein, 0 leer\)') { throw "G8 nicht wegen Nein gesperrt:`n$bericht" }
        Assert-NieBestanden $bericht
    }

    It "wertet die MP3-Prüfung bei einem Paket ohne Audio als nicht zutreffend, ohne G8 zu sperren" {
        $projekt = New-FreigabeProjekt "$script:Basis-ohneaudio"
        [void](New-TestPaket $projekt "relingit-upload-v1.02-2026-11-07-ohne-audio" -OhneAudioZeile)
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh")
        Assert-Erfolg $ergebnis "Ergebnis: keine automatische Prüfung nicht bestanden"
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G6 \| Podcast-MP3 gegen SHA256SUMS\.txt \| nicht zutreffend \| Paket relingit-upload-v1\.02-2026-11-07-ohne-audio\.zip enthält keine Podcast-MP3 \(ohne Audio\)') { throw "G6 nicht als nicht zutreffend gemeldet:`n$bericht" }
        if ($bericht -match '0 von 4 passend') { throw "MP3-Prüfung trotz Paket ohne Audio ausgeführt:`n$bericht" }
        if ($bericht -match '(?m)^\| G8 \| Freigabe durch Bernd \|[^
]*G6 nicht zutreffend') { throw "G8 wegen nicht zutreffend gesperrt:`n$bericht" }
        if ($bericht -match '\| G6 \| Lokale Vorschau möglich \| bestanden \|') {
            # Mit Python ist G6 insgesamt bestanden und kein Sperrgrund für G8.
            if ($bericht -notmatch '\| G6 \| Lokal \| bestanden \|') { throw "G6 insgesamt nicht bestanden:`n$bericht" }
            if ($bericht -match '(?m)^\| G8 \| Freigabe durch Bernd \|[^
]*G6 ') { throw "G6 sperrt G8:`n$bericht" }
        }
        Assert-NieBestanden $bericht
        if (git -C $projekt status --porcelain) { throw "output/ verändert git status." }
    }

    It "erkennt ein Paket ohne Audio auch am Manifest, wenn es mit -Paket übergeben wird" {
        $projekt = New-FreigabeProjekt "$script:Basis-manifest"
        $zip = New-TestPaket $projekt "relingit-upload-v1.02-2026-11-07-probe" -OhneAudioZeile
        [void](Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh", "-Paket", $zip))
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G6 \| Podcast-MP3 gegen SHA256SUMS\.txt \| nicht zutreffend \| Paket relingit-upload-v1\.02-2026-11-07-probe\.zip') { throw "Manifest-Zeile Ohne Audio nicht erkannt:`n$bericht" }
    }

    It "prüft bei einem Paket mit Audio die MP3 weiter gegen SHA256SUMS.txt" {
        $projekt = New-FreigabeProjekt "$script:Basis-mitaudio"
        [void](New-TestPaket $projekt "relingit-upload-v1.02-2026-11-07" -MitMp3)
        [void](Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh"))
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G6 \| Podcast-MP3 gegen SHA256SUMS\.txt \| offen \| Paket relingit-upload-v1\.02-2026-11-07\.zip mit Audio; 0 von 4 passend; nicht vorhanden in ') { throw "MP3 ohne lokale Dateien nicht als offen gemeldet:`n$bericht" }
        if ($bericht -notmatch '(?m)^\| G8 \| Freigabe durch Bernd \| gesperrt \|[^
]*G6 offen') { throw "G8 nicht wegen G6 gesperrt:`n$bericht" }

        # Mit passenden lokalen MP3 bestanden (Verhalten wie vor R54; G7 ist hier wegen der neuen Dateien egal).
        New-PodcastMp3 -Projekt $projekt -PruefsummenAnpassen
        [void](Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh"))
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G6 \| Podcast-MP3 gegen SHA256SUMS\.txt \| bestanden \| Paket relingit-upload-v1\.02-2026-11-07\.zip mit Audio; 4 von 4 passend \|') { throw "Passende MP3 nicht als bestanden gemeldet:`n$bericht" }
    }

    It "meldet ein als ohne Audio gekennzeichnetes Paket mit MP3 als nicht bestanden" {
        $projekt = New-FreigabeProjekt "$script:Basis-widerspruch"
        [void](New-TestPaket $projekt "relingit-upload-v1.02-2026-11-07-ohne-audio" -MitMp3)
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "freigabe-pruefen.ps1" -Argumente @("-OhnePester", "-OhneGh")
        Assert-Fehlschlag $ergebnis "automatische Prüfung\(en\) nicht bestanden"
        $bericht = Get-Bericht $projekt "FREIGABE-v1.02.md"
        if ($bericht -notmatch '\| G6 \| Podcast-MP3 gegen SHA256SUMS\.txt \| nicht bestanden \| Paket relingit-upload-v1\.02-2026-11-07-ohne-audio\.zip ist als ohne Audio gekennzeichnet, enthält aber 4 MP3') { throw "Widerspruch nicht gemeldet:`n$bericht" }
    }
}

Describe "vorschau.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
    }

    It "baut mit -NurBauen eine Kopie außerhalb des Projekts mit abgeschalteter Supabase-Konfiguration" {
        $projekt = New-MiniProjekt -Ziel (Join-Path $TestDrive "vorschau")
        Copy-Item -LiteralPath (Join-Path $script:RepoRoot "scripts/vorschau.ps1") -Destination (Join-Path $projekt "scripts/vorschau.ps1")
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "vorschau.ps1" -Argumente @("-NurBauen")
        Assert-Erfolg $ergebnis "Vorschau gebaut: .*Supabase in der Kopie abgeschaltet"
        Assert-Enthaelt $ergebnis "Hinweis: 4 Datei\(en\) nicht vorhanden, übersprungen: assets/audio/ki-als-beifahrer"
        $ziel = ($ergebnis.Ausgabe -split "`n" | Select-Object -Last 1).Trim()
        try {
            if (-not (Test-Path -LiteralPath (Join-Path $ziel "index.html"))) { throw "index.html fehlt in der Vorschau: $ziel" }
            if (-not (Test-Path -LiteralPath (Join-Path $ziel "story/current/geschichte.pdf"))) { throw "geschichte.pdf fehlt in der Vorschau." }
            if ($ziel.StartsWith($projekt, [System.StringComparison]::OrdinalIgnoreCase)) { throw "Vorschau liegt im Projekt: $ziel" }
            $konfiguration = Get-Content -Raw -LiteralPath (Join-Path $ziel "assets/js/supabase-config.js")
            if ($konfiguration -notmatch 'url: "", publishableKey: ""') { throw "Supabase-Konfiguration nicht geleert:`n$konfiguration" }
            if (Test-Path -LiteralPath (Join-Path $ziel "source")) { throw "source/ wurde in die Vorschau kopiert." }
        } finally {
            if ($ziel -and (Test-Path -LiteralPath $ziel)) { Remove-Item -LiteralPath $ziel -Recurse -Force }
        }
    }
}
