# Pester-Tests für scripts/live-pruefen.ps1 (R87), ohne Netz.
# Zielversion Pester 5, läuft auch mit Pester 3.4 (ohne Should, siehe TestHelfer.ps1).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Funktionen werden per Dot-Sourcing geladen; der Hauptablauf (Netzabruf)
# läuft dabei nicht. Geprüft werden Sollwert-Ableitung, Hash-Normalisierung,
# Vergleich und Markdown-Ausgabe; der Live-Abruf selbst wird nicht getestet.

Describe "live-pruefen.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Skript = Join-Path (Split-Path -Parent $PSScriptRoot) "scripts/live-pruefen.ps1"
        . $script:Skript

        # Mini-Projekt mit genau den Dateien, die Get-ReleaseSoll liest.
        # Die Fixture-PDF hat eine Seite; mit und ohne pdfinfo gilt Seitenzahl 1.
        function New-SollProjekt([string]$Ziel, [int]$IndexSeiten = 1, [string]$AppVersion = "1.02") {
            New-Item -ItemType Directory -Path (Join-Path $Ziel "story/current") -Force | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $Ziel "assets/js") -Force | Out-Null
            Write-Utf8Datei (Join-Path $Ziel "story/current/fahrt-zum-kunden.html") "<html>`r`n<div class=`"cover-meta`"><span>Version 1.02</span><span>05.09.2026</span></div>`r`n</html>`r`n"
            Copy-Item -LiteralPath (Join-Path $PSScriptRoot "fixtures/pdf/deckblatt-v1.02.pdf") -Destination (Join-Path $Ziel "story/current/geschichte.pdf")
            Copy-Item -LiteralPath (Join-Path $PSScriptRoot "fixtures/pdf/deckblatt-v1.01.pdf") -Destination (Join-Path $Ziel "story/current/workshop-handout.pdf")
            Write-Utf8Datei (Join-Path $Ziel "story/current/workshop-handout.html") "<p>Handout</p>`n"
            Write-Utf8Datei (Join-Path $Ziel "assets/js/app.js") "const fallbackRelease = {`n  version: `"$AppVersion`",`n  date: `"5. September 2026`",`n  pageCount: 1,`n};`n"
            Write-Utf8Datei (Join-Path $Ziel "index.html") "<p><span data-page-count>$IndexSeiten</span> Seiten</p>`n"
            Write-Utf8Datei (Join-Path $Ziel "assets/js/supabase-config.js") "window.SUPABASE_CONFIG = Object.freeze({ url: `"https://beispiel.invalid`", publishableKey: `"oeffentlich`" });`n"
            return $Ziel
        }
    }

    It "behandelt CRLF und LF bei Textdateien gleich, bei Binärdateien nicht" {
        $crlf = Join-Path $TestDrive "crlf.txt"; $lf = Join-Path $TestDrive "lf.txt"
        [System.IO.File]::WriteAllBytes($crlf, [System.Text.Encoding]::UTF8.GetBytes("Zeile ä`r`nZeile ö`r`n"))
        [System.IO.File]::WriteAllBytes($lf, [System.Text.Encoding]::UTF8.GetBytes("Zeile ä`nZeile ö`n"))
        $a = Get-InhaltsHash -Pfad $crlf -Text; $b = Get-InhaltsHash -Pfad $lf -Text
        if ($a.Hash -ne $b.Hash) { throw "Normalisierte Hashes unterscheiden sich." }
        if ($a.Groesse -ne $b.Groesse) { throw "Normalisierte Größen unterscheiden sich." }
        if ((Get-InhaltsHash -Pfad $crlf).Hash -eq (Get-InhaltsHash -Pfad $lf).Hash) { throw "Ohne -Text darf nicht normalisiert werden." }
    }

    It "vergleicht Webspace-Dateien ohne die Rückfallwerte (Release ohne FTP-Upload)" {
        # Live liegt noch app.js/index.html des Vorgängers, lokal die neuen Rückfallwerte.
        $alt = Join-Path $TestDrive "app-alt.js"; $neu = Join-Path $TestDrive "app-neu.js"; $anders = Join-Path $TestDrive "app-anders.js"
        Write-Utf8Datei $alt "const fallbackRelease = {`r`n  version: `"1.37`",`r`n  date: `"5. September 2026`",`r`n  pageCount: 64,`r`n};`r`n<span data-page-count>64</span>`r`n"
        Write-Utf8Datei $neu "const fallbackRelease = {`n  version: `"1.40`",`n  date: `"16. November 2026`",`n  pageCount: 80,`n};`n<span data-page-count>80</span>`n"
        Write-Utf8Datei $anders "const fallbackRelease = {`n  version: `"1.40`",`n  date: `"16. November 2026`",`n  pageCount: 80,`n};`n<span data-page-count>80</span>`nneueFunktion();`n"
        if ((Get-InhaltsHash -Pfad $alt -OhneRueckfallwerte).Hash -ne (Get-InhaltsHash -Pfad $neu -OhneRueckfallwerte).Hash) {
            throw "Nur Rückfallwerte geändert, trotzdem Abweichung."
        }
        if ((Get-InhaltsHash -Pfad $anders -OhneRueckfallwerte).Hash -eq (Get-InhaltsHash -Pfad $neu -OhneRueckfallwerte).Hash) {
            throw "Echte Codeänderung wird nicht erkannt."
        }
    }

    It "formatiert das Datum wie publish-release.ps1" {
        if ((ConvertTo-Anzeigedatum "16.11.2026") -ne "16. November 2026") { throw "16.11.2026 falsch formatiert." }
        if ((ConvertTo-Anzeigedatum "05.09.2026") -ne "5. September 2026") { throw "05.09.2026 falsch formatiert." }
    }

    It "leitet die Sollwerte aus dem lokalen Stand ab" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "soll-ok")
        $soll = Get-ReleaseSoll -Projekt $projekt
        if ($soll.Version -ne "1.02") { throw "Version: $($soll.Version)" }
        if ($soll.Datum -ne "5. September 2026") { throw "Datum: $($soll.Datum)" }
        if ($soll.Seiten -ne 1) { throw "Seiten: $($soll.Seiten)" }
        if (@($soll.Dateien).Count -ne 4) { throw "Erwartet vier Speicherdateien." }
        if (@($soll.Webspace).Count -ne 2) { throw "Erwartet zwei Webspace-Dateien." }
        $html = $soll.Dateien | Where-Object Name -eq "fahrt-zum-kunden.html"
        $erwartet = (Get-InhaltsHash -Pfad (Join-Path $projekt "story/current/fahrt-zum-kunden.html") -Text).Hash
        if ($html.Hash -ne $erwartet -or -not $html.Text) { throw "HTML-Sollhash nicht normalisiert." }
    }

    It "bricht ab, wenn index.html eine andere Seitenzahl trägt" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "soll-index") -IndexSeiten 7
        $fehler = $null
        try { Get-ReleaseSoll -Projekt $projekt | Out-Null } catch { $fehler = $_.Exception.Message }
        if ($fehler -notmatch "index\.html data-page-count 7 statt 1") { throw "Unerwartet: $fehler" }
    }

    It "bricht ab, wenn die Rückfallversion in app.js nicht zum Deckblatt passt" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "soll-app") -AppVersion "1.01"
        $fehler = $null
        try { Get-ReleaseSoll -Projekt $projekt | Out-Null } catch { $fehler = $_.Exception.Message }
        if ($fehler -notmatch "app\.js version 1\.01 statt 1\.02") { throw "Unerwartet: $fehler" }
    }

    It "meldet OK, ABWEICHUNG und NICHT ABRUFBAR je Prüfpunkt" {
        $soll = [pscustomobject]@{
            Version = "1.40"; Datum = "16. November 2026"; Seiten = 80
            Dateien = @([pscustomobject]@{ Name = "geschichte.pdf"; Hash = "aa" }, [pscustomobject]@{ Name = "fahrt-zum-kunden.html"; Hash = "bb" })
            Webspace = @([pscustomobject]@{ Pfad = "index.html"; Hash = "cc" })
        }
        $ist = [pscustomobject]@{
            Release  = [pscustomobject]@{ version = "1.37"; display_date = "16. November 2026"; page_count = 80 }
            Dateien  = @{ "geschichte.pdf" = "aa" }
            Webspace = @{ "index.html" = "cc" }
        }
        $zeilen = Compare-LiveStand -Soll $soll -Ist $ist
        $nach = @{}; foreach ($z in $zeilen) { $nach[$z.Pruefpunkt] = $z.Ergebnis }
        if ($nach["story_release version"] -ne "ABWEICHUNG") { throw "version: $($nach['story_release version'])" }
        if ($nach["story_release page_count"] -ne "OK") { throw "page_count: $($nach['story_release page_count'])" }
        if ($nach["Speicher story/current/geschichte.pdf"] -ne "OK") { throw "geschichte.pdf" }
        if ($nach["Speicher story/current/fahrt-zum-kunden.html"] -ne "NICHT ABRUFBAR") { throw "fahrt-zum-kunden.html" }
        if ($nach["Webspace index.html (ohne Rückfallwerte)"] -ne "OK") { throw "index.html" }

        $ohneRelease = Compare-LiveStand -Soll $soll -Ist ([pscustomobject]@{ Release = $null; Dateien = @{}; Webspace = @{} })
        if (@($ohneRelease | Where-Object Ergebnis -ne "NICHT ABRUFBAR").Count -ne 0) { throw "Ohne Live-Daten muss alles NICHT ABRUFBAR sein." }
    }

    It "ruft Invoke-WebRequest mit Kopfzeilen, User-Agent und Zieldatei auf" {
        # Ersatz für den Netzabruf, nur in diesem Test; Signatur wie das echte Cmdlet.
        $script:Aufruf = $null
        function Invoke-WebRequest {
            param([string]$Uri, [System.Collections.IDictionary]$Headers, [string]$UserAgent, [string]$OutFile, $ErrorAction)
            $script:Aufruf = [pscustomobject]@{ Uri = $Uri; Headers = $Headers; UserAgent = $UserAgent; OutFile = $OutFile }
            [System.IO.File]::WriteAllText($OutFile, "[]")
        }
        $ziel = Join-Path $TestDrive "abruf.json"
        $ergebnis = Get-OhneCache "https://beispiel.invalid/x" $ziel @{ apikey = "oeffentlich" } 3>$null
        if ($ergebnis -ne $ziel) { throw "Get-OhneCache lieferte '$ergebnis' statt des Zielpfads." }
        if ($null -eq $script:Aufruf) { throw "Invoke-WebRequest wurde nicht aufgerufen." }
        if ($script:Aufruf.UserAgent -ne $script:UserAgent) { throw "User-Agent: '$($script:Aufruf.UserAgent)'" }
        foreach ($schluessel in @("Cache-Control", "Pragma", "apikey")) {
            if (-not $script:Aufruf.Headers.Contains($schluessel)) { throw "Kopfzeile fehlt: $schluessel" }
        }
    }

    It "wertet eine Supabase-Antwort ohne gültiges JSON als NICHT ABRUFBAR, nicht als Abbruch" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "kein-json")
        $soll = Get-ReleaseSoll -Projekt $projekt
        # Ersatz für den Netzabruf, nur in diesem Test: story_release liefert HTML statt JSON.
        function Get-OhneCache([string]$Url, [string]$Ziel, [hashtable]$Kopf = @{}) {
            if ($Url -match 'story_release') { [System.IO.File]::WriteAllText($Ziel, "<html>Wartung</html>"); return $Ziel }
            return $null
        }
        $ist = $null
        try { $ist = Get-LiveIst -Soll $soll -Supabase ([pscustomobject]@{ Url = "https://beispiel.invalid"; Schluessel = "x" }) -SiteUrl "https://beispiel.invalid" 3>$null }
        catch { throw "Get-LiveIst darf bei ungültigem JSON nicht abbrechen: $($_.Exception.Message)" }
        if ($null -ne $ist.Release) { throw "Release muss leer bleiben." }
        $zeilen = Compare-LiveStand -Soll $soll -Ist $ist
        $version = $zeilen | Where-Object Pruefpunkt -eq "story_release version"
        if ($version.Ergebnis -ne "NICHT ABRUFBAR") { throw "version: $($version.Ergebnis)" }
    }

    It "schreibt die Sollwerte als Markdown-Abschnitt für die Upload-Checkliste" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "soll-md")
        $md = Format-SollwerteMarkdown -Soll (Get-ReleaseSoll -Projekt $projekt) -Stand "Stand test"
        foreach ($muster in @('^## Supabase und Speicher', '\| version \| 1\.02 \|', '\| display_date \| 5\. September 2026 \|', '\| page_count \| 1 ', '\| geschichte\.pdf \|', '-NurPruefen')) {
            if ($md -notmatch "(?m)$muster") { throw "Markdown enthält nicht: $muster" }
        }
    }

    It "gibt mit -NurSollwerte ohne Netz die Sollwerte aus (Exit 0)" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "soll-lauf")
        $ausgabe = & (Get-PwshPfad) -NoProfile -File $script:Skript -NurSollwerte -Projekt $projekt 2>&1
        if ($LASTEXITCODE -ne 0) { throw "Exit $LASTEXITCODE`n$($ausgabe -join "`n")" }
        if (($ausgabe -join "`n") -notmatch '\| version \| 1\.02 \|') { throw "Sollwerte fehlen in der Ausgabe." }
    }

    It "endet mit Exit 2 ohne Netzabruf, wenn supabase-config.js keine Konfiguration enthält" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "ohne-konfig")
        Write-Utf8Datei (Join-Path $projekt "assets/js/supabase-config.js") "window.SUPABASE_CONFIG = Object.freeze({});`n"
        $ausgabe = & (Get-PwshPfad) -NoProfile -File $script:Skript -Projekt $projekt 2>&1
        if ($LASTEXITCODE -ne 2) { throw "Erwartet Exit 2, erhalten $LASTEXITCODE.`n$($ausgabe -join "`n")" }
        if (($ausgabe -join "`n") -notmatch "keine öffentliche Konfiguration") { throw "Meldung fehlt." }
    }

    It "endet mit Exit 2, wenn die Sollwerte nicht ableitbar sind" {
        $projekt = New-SollProjekt (Join-Path $TestDrive "soll-kaputt") -IndexSeiten 9
        & (Get-PwshPfad) -NoProfile -File $script:Skript -NurSollwerte -Projekt $projekt *> $null
        if ($LASTEXITCODE -ne 2) { throw "Erwartet Exit 2, erhalten $LASTEXITCODE." }
    }
}

Describe "publish-release.ps1 -NurPruefen" {
    It "kennt den Schalter und verzweigt vor jeder Änderung zur Live-Prüfung" {
        $pfad = Join-Path (Split-Path -Parent $PSScriptRoot) "scripts/publish-release.ps1"
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($pfad, [ref]$null, [ref]$null)
        $parameter = @($ast.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
        if ($parameter -notcontains "NurPruefen") { throw "Parameter -NurPruefen fehlt." }
        $text = [System.IO.File]::ReadAllText($pfad)
        $verzweigung = $text.IndexOf('if ($NurPruefen)')
        $ersteAenderung = $text.IndexOf('Copy-Item')
        if ($verzweigung -lt 0 -or $ersteAenderung -lt 0 -or $verzweigung -gt $ersteAenderung) {
            throw "-NurPruefen muss vor dem ersten Kopieren verzweigen."
        }
        if ($text.Substring($verzweigung, 120) -notmatch 'live-pruefen\.ps1"\s*\r?\n\s*exit \$LASTEXITCODE') {
            throw "Die Verzweigung muss live-pruefen.ps1 aufrufen und mit dessen Exit-Code enden."
        }
    }
}
