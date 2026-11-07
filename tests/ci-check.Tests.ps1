# Pester-Tests für scripts/ci-check.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests

Describe "ci-check.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Basis = Join-Path $TestDrive "ci-check"
    }

    It "läuft beim fehlerfreien Mini-Projekt ohne Befund durch" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-ok"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Erfolg $ergebnis "OK: \d+ HTML-Dateien"
    }

    It "meldet einen internen Link ohne Ziel-ID (fehlender Anker)" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-anker" -Geschichte "fehlender-anker.html.fixture"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Interner Story-Link hat kein Ziel: #kap-gibt-es-nicht"
    }

    It "meldet eine doppelte ID" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-id" -Geschichte "doppelte-id.html.fixture"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Doppelte ID 'kap-eins' in story[\\/]current[\\/]fahrt-zum-kunden\.html"
        Assert-Enthaelt $ergebnis "Doppelte ID 'kap-eins' in source[\\/]fahrt-zum-kunden\.html"
    }

    It "meldet eine fehlende Versionshistorien-Zeile zur Deckblatt-Version" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-zeile" -Geschichte "historie-zeile-fehlt.html.fixture"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Letzter Eintrag der Versionshistorie \(1\.01, 01\.11\.2026\) passt nicht zum Deckblatt \(1\.02, 07\.11\.2026\)"
        Assert-Enthaelt $ergebnis "Deckblatt-Version stimmt nicht mit letztem Historieneintrag überein"
    }

    It "meldet ein unpassendes Datum in der letzten Versionshistorien-Zeile" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-datum" -Geschichte "historie-datum-unpassend.html.fixture"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Deckblatt-Datum stimmt nicht mit letztem Historieneintrag überein"
    }

    It "meldet eine Versionshistorien-Zeile ohne lesbares Datum" {
        $projekt = New-MiniProjekt -Ziel "$script:Basis-unlesbar" -Geschichte "historie-zeile-unlesbar.html.fixture"
        $ergebnis = Invoke-MiniSkript -Projekt $projekt -Skript "ci-check.ps1"
        Assert-Fehlschlag $ergebnis "Versionshistorie: 1 von 2 Zeilen ohne lesbare Version"
    }
}
