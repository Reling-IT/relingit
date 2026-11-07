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
    }
}
