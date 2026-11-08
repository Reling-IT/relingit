# Pester-Tests für scripts/build-upload.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Tests bauen nur im temporären Mini-Projekt (output/ftp dort). Kein Upload.

Describe "build-upload.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Basis = Join-Path $TestDrive "build-upload"
    }

    It "bricht ohne -OhneAudio ab, wenn die MP3 fehlen" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-fehlt"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "build-upload.ps1"
        Assert-Fehlschlag $ergebnis "Paket abgebrochen, Dateien fehlen: assets/audio/ki-als-beifahrer-im-it-systemhaus\.mp3"
        if (Test-Path -LiteralPath (Join-Path $projekt "output/ftp")) { throw "Trotz Abbruch wurde output/ftp angelegt." }
    }

    It "baut mit -OhneAudio ein Paket ohne MP3 in ZIP und Manifest" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-ohne"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "build-upload.ps1" -Argumente @("-OhneAudio")
        Assert-Erfolg $ergebnis "OK: geprüftes Upload-Paket erstellt: .*-ohne-audio\.zip"
        Assert-Enthaelt $ergebnis "Hinweis: Paket ohne Podcast-MP3"

        $zip = @(Get-ChildItem -LiteralPath (Join-Path $projekt "output/ftp") -Filter "*-ohne-audio.zip")
        if ($zip.Count -ne 1) { throw "Erwartet: genau ein ZIP mit Zusatz -ohne-audio, gefunden: $($zip.Count)." }
        $eintraege = Get-ZipEintraege $zip[0].FullName
        $mp3 = @($eintraege | Where-Object { $_ -like "*.mp3" })
        if ($mp3.Count -gt 0) { throw "ZIP enthält MP3: $($mp3 -join ', ')" }
        if ("assets/img/reling-it-podcast-cover.png" -notin $eintraege) { throw "ZIP enthält das Podcast-Cover nicht." }
        if ("index.html" -notin $eintraege) { throw "ZIP enthält index.html nicht." }

        $manifest = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $zip[0].FullName.Replace('.zip', '') "UPLOAD-MANIFEST.txt")
        if ($manifest -match '\.mp3') { throw "Manifest nennt MP3:`n$manifest" }
        if ($manifest -notmatch 'Ohne Audio:') { throw "Manifest ohne Hinweis 'Ohne Audio:'.`n$manifest" }
    }

    It "bricht ab, wenn eine MP3 nicht zu assets/audio/SHA256SUMS.txt passt" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-hash"
        New-PodcastMp3 -Projekt $projekt
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "build-upload.ps1"
        # Die Ersatz-MP3 sind kleiner als die echten: schon ci-check.ps1 meldet die Größe.
        Assert-Fehlschlag $ergebnis "Podcast-Größe weicht von assets/audio/SHA256SUMS\.txt ab"
        if (Test-Path -LiteralPath (Join-Path $projekt "output/ftp")) { throw "Trotz Abbruch wurde output/ftp angelegt." }
    }

    It "bricht ab, wenn bei passender Größe die Prüfsumme abweicht" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-summe"
        New-PodcastMp3 -Projekt $projekt -PruefsummenAnpassen
        # Inhalt gleich lang ändern: Größe stimmt weiter, Prüfsumme nicht.
        $pfad = Join-Path $projekt "assets/audio/roman-als-ki-blaupause.mp3"
        $bytes = [System.IO.File]::ReadAllBytes($pfad)
        $bytes[$bytes.Length - 2] = [byte](($bytes[$bytes.Length - 2] + 1) % 256)
        [System.IO.File]::WriteAllBytes($pfad, $bytes)
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "build-upload.ps1"
        Assert-Fehlschlag $ergebnis "Podcast-Dateien passen nicht zu assets/audio/SHA256SUMS\.txt: assets/audio/roman-als-ki-blaupause\.mp3 \(Prüfsumme weicht ab\)"
        if (Test-Path -LiteralPath (Join-Path $projekt "output/ftp")) { throw "Trotz Abbruch wurde output/ftp angelegt." }
    }

    It "baut mit passenden MP3 ein vollständiges Paket (Gegenprobe)" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-voll"
        New-PodcastMp3 -Projekt $projekt -PruefsummenAnpassen
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "build-upload.ps1"
        Assert-Erfolg $ergebnis "OK: 4 Podcast-MP3 entsprechen assets/audio/SHA256SUMS\.txt\."
        $zip = @(Get-ChildItem -LiteralPath (Join-Path $projekt "output/ftp") -Filter "*.zip")
        $mp3 = @(Get-ZipEintraege $zip[0].FullName | Where-Object { $_ -like "assets/audio/*.mp3" })
        if ($mp3.Count -ne 4) { throw "Erwartet: 4 MP3 im ZIP, gefunden: $($mp3.Count)." }
    }
}

Describe "ci-check.ps1 (Podcast-Prüfsummen)" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Basis = Join-Path $TestDrive "ci-podcast"
    }

    It "meldet eine fehlende Größenangabe in assets/audio/SHA256SUMS.txt" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-groesse"
        $summen = Join-Path $projekt "assets/audio/SHA256SUMS.txt"
        $zeilen = @(Get-Content -LiteralPath $summen -Encoding utf8 | Where-Object { $_ -notmatch 'groesse \d+ warum-ki-nicht-lenken-darf\.mp3' })
        Write-Utf8Datei $summen ($zeilen -join "`n")
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Größe \(# groesse <Byte> <Datei>\) fehlt für warum-ki-nicht-lenken-darf\.mp3"
    }

    It "meldet ein fehlendes Podcast-Cover" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-cover"
        Remove-Item -LiteralPath (Join-Path $projekt "assets/img/reling-it-podcast-cover.png")
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Podcast-Cover fehlt im Repository: assets/img/reling-it-podcast-cover\.png"
    }
}
