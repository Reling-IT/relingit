<#
Zweck:
    Prüft vor der Freigabe einer neuen Version die automatisierbaren Tore aus
    docs/freigabe.yaml (G1 Code, G2 Kommentare, G6 Lokal, G7 Git) und
    schreibt den Freigabebericht. Tore ohne Automatik (G3 Layout, G4 UI,
    G5 Inhalt, G8 Freigabe Bernd) werden nie als bestanden ausgegeben: G3 bis
    G5 bleiben offen, G8 ist offen oder gesperrt. Der Prozess steht in
    docs/FREIGABE.md.

Eingabe:
    -Projekt        Projektordner (Standard: Ordner über scripts/). Kann auf
                    einen anderen Worktree zeigen, z. B. für einen Probelauf
                    auf einem Release-Zweig. Das Skript ändert dort nichts.
    -Version        Version X.YY (Standard: Deckblatt von
                    source/fahrt-zum-kunden.html).
    -AusgabeOrdner  Ziel für die Berichte (Standard: <Projekt>/reports, in
                    .gitignore eingetragen).
    -AudioOrdner    Ordner mit den lokalen Podcast-MP3 (Standard:
                    <Projekt>/assets/audio).
    -Paket          Upload-Paket aus scripts/build-upload.ps1 (ZIP oder
                    Ordner). Standard: das jüngste
                    <Projekt>/output/ftp/relingit-upload-v<Version>-*.zip.
                    Ein Paket ohne Audio (Name endet auf -ohne-audio oder
                    Manifest mit Zeile "Ohne Audio:") macht die MP3-Prüfung
                    in G6 nicht zutreffend.
    -OhnePester     Pester-Tests nicht ausführen (G1 dann offen).
    -OhneGh         Pull-Request-Stand nicht mit gh abfragen (Teile von G2
                    und G7 dann offen).

Ausgabe:
    <AusgabeOrdner>/FREIGABE-vX.YY.md  Tabelle Tor, Ergebnis, Nachweis und
                                       alle Einzelprüfungen; wird bei jedem
                                       Lauf neu geschrieben.
    <AusgabeOrdner>/SICHTUNG-vX.YY.md  Sichtungsliste für Bernd (Spalten
                                       Ergebnis Ja/Nein und Bemerkung). Wird
                                       nur angelegt, wenn sie fehlt; eine
                                       vorhandene Liste wird gelesen und
                                       ausgewertet, nie überschrieben.
    Exit-Code 1, wenn eine automatische Prüfung nicht bestanden ist, sonst 0.
    Exit-Code 0 bedeutet nicht Freigabe: G8 erteilt nur Bernd.
#>
param(
    [string]$Projekt = "",
    [string]$Version = "",
    [string]$AusgabeOrdner = "",
    [string]$AudioOrdner = "",
    [string]$Paket = "",
    [switch]$OhnePester,
    [switch]$OhneGh
)

$ErrorActionPreference = "Stop"
if (-not $Projekt) { $Projekt = Split-Path -Parent $PSScriptRoot }
$Projekt = (Resolve-Path -LiteralPath $Projekt).Path
if (-not $AusgabeOrdner) { $AusgabeOrdner = Join-Path $Projekt "reports" }
if (-not $AudioOrdner) { $AudioOrdner = Join-Path $Projekt "assets/audio" }
$pwshPfad = (Get-Process -Id $PID).Path

# Ergebniswerte laut docs/freigabe.yaml. Rangfolge für die Zusammenfassung je Tor.
# "nicht zutreffend" zählt nicht gegen das Tor (z. B. MP3-Prüfung bei einem Paket ohne Audio).
$rang = @{ "nicht zutreffend" = -1; "bestanden" = 0; "offen" = 1; "gesperrt" = 2; "nicht bestanden" = 3 }
$nichtBlockierend = @("bestanden", "nicht zutreffend")
$pruefungen = [System.Collections.Generic.List[object]]::new()
function Add-Pruefung([string]$Tor, [string]$Name, [string]$Ergebnis, [string]$Nachweis) {
    $pruefungen.Add([pscustomobject]@{ Tor = $Tor; Pruefung = $Name; Ergebnis = $Ergebnis; Nachweis = $Nachweis })
}

# Führt einen externen Befehl im Projektordner aus und liefert Exit-Code und Ausgabe.
function Invoke-Befehl([string]$Datei, [string[]]$Argumente) {
    $vorher = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    Push-Location -LiteralPath $Projekt
    try {
        $ausgabe = & $Datei @Argumente 2>&1 | ForEach-Object { "$_" }
        $code = $LASTEXITCODE
    } finally {
        Pop-Location
        $ErrorActionPreference = $vorher
    }
    return [pscustomobject]@{ ExitCode = $code; Ausgabe = @($ausgabe) }
}

# Tabellenzellen: keine Zeilenumbrüche, senkrechte Striche maskiert.
function Format-Zelle([string]$Text) {
    return (($Text -replace '\r?\n', ' ' -replace '\s{2,}', ' ') -replace '\|', '\|').Trim()
}

# --- Version ---------------------------------------------------------------
$quellHtml = Join-Path $Projekt "source/fahrt-zum-kunden.html"
if (-not $Version) {
    if (-not (Test-Path -LiteralPath $quellHtml)) { throw "Version nicht angegeben und $quellHtml fehlt." }
    $cover = [regex]::Match((Get-Content -Raw -LiteralPath $quellHtml), '<div\s+class="cover-meta">[\s\S]*?<span>\s*Version\s+(?<v>\d+\.\d+)\s*</span>')
    if (-not $cover.Success) { throw "Version im Deckblatt von source/fahrt-zum-kunden.html nicht lesbar. Bitte -Version angeben." }
    $Version = $cover.Groups['v'].Value
}
if ($Version -notmatch '^\d+\.\d+$') { throw "Version muss die Form X.YY haben: $Version" }

# --- G7 Git (zuerst, damit die eigenen Berichte den Status nicht beeinflussen) ---
$gitVorhanden = [bool](Get-Command git -ErrorAction SilentlyContinue)
$branch = ""
$commit = ""
if (-not $gitVorhanden) {
    Add-Pruefung "G7" "git status sauber" "offen" "git nicht gefunden"
} else {
    $istRepo = Invoke-Befehl "git" @("rev-parse", "--is-inside-work-tree")
    if ($istRepo.ExitCode -ne 0) {
        Add-Pruefung "G7" "git status sauber" "nicht bestanden" "kein Git-Arbeitsverzeichnis: $Projekt"
    } else {
        $status = Invoke-Befehl "git" @("status", "--porcelain")
        if ($status.ExitCode -ne 0) {
            Add-Pruefung "G7" "git status sauber" "nicht bestanden" "git status fehlgeschlagen"
        } elseif ($status.Ausgabe.Count -gt 0) {
            $liste = ($status.Ausgabe | Select-Object -First 5) -join "; "
            Add-Pruefung "G7" "git status sauber" "nicht bestanden" "$($status.Ausgabe.Count) Änderung(en): $liste"
        } else {
            Add-Pruefung "G7" "git status sauber" "bestanden" "git status --porcelain ohne Ausgabe"
        }

        $commit = ((Invoke-Befehl "git" @("rev-parse", "--short", "HEAD")).Ausgabe | Select-Object -First 1)
        $branch = ((Invoke-Befehl "git" @("rev-parse", "--abbrev-ref", "HEAD")).Ausgabe | Select-Object -First 1)
        $losgeloest = $branch -eq "HEAD"
        if ($losgeloest) {
            # Losgelöster Stand (z. B. Probelauf-Worktree): Branch über den Remote-Zweig ermitteln.
            $remote = (Invoke-Befehl "git" @("branch", "-r", "--points-at", "HEAD", "--format=%(refname:short)")).Ausgabe |
                Where-Object { $_ -like "origin/*" -and $_ -ne "origin/HEAD" -and $_ -ne "origin" } | Select-Object -First 1
            $branch = if ($remote) { $remote -replace '^origin/', '' } else { "" }
        }
        if (-not $branch) {
            Add-Pruefung "G7" "Feature-Branch, gleich Upstream" "nicht bestanden" "losgelöster Stand $commit ohne passenden Remote-Zweig"
        } elseif ($branch -eq "main") {
            Add-Pruefung "G7" "Feature-Branch, gleich Upstream" "nicht bestanden" "Branch ist main; Freigabe wird auf dem Feature-Branch vor dem Merge geprüft"
        } else {
            $upstream = Invoke-Befehl "git" @("rev-parse", "--verify", "--quiet", "refs/remotes/origin/$branch")
            $head = (Invoke-Befehl "git" @("rev-parse", "HEAD")).Ausgabe | Select-Object -First 1
            $zusatz = if ($losgeloest) { " (losgelöster Stand)" } else { "" }
            $hinter = (Invoke-Befehl "git" @("rev-list", "--count", "HEAD..origin/main")).Ausgabe | Select-Object -First 1
            $hinterText = if ($hinter -match '^\d+$' -and [int]$hinter -gt 0) { "; Hinweis: $hinter Commit(s) hinter origin/main" } else { "" }
            if ($upstream.ExitCode -ne 0) {
                Add-Pruefung "G7" "Feature-Branch, gleich Upstream" "nicht bestanden" "Branch $branch$zusatz ist nicht auf origin gepusht"
            } elseif (($upstream.Ausgabe | Select-Object -First 1) -ne $head) {
                Add-Pruefung "G7" "Feature-Branch, gleich Upstream" "nicht bestanden" "Branch $branch${zusatz}: HEAD $commit weicht von origin/$branch ab$hinterText"
            } else {
                Add-Pruefung "G7" "Feature-Branch, gleich Upstream" "bestanden" "Branch $branch$zusatz, HEAD $commit = origin/$branch$hinterText"
            }
        }
    }
}

# Pull-Request-Stand per gh (G7) und Review-Status (G2).
$ghVorhanden = [bool](Get-Command gh -ErrorAction SilentlyContinue)
if ($OhneGh -or -not $ghVorhanden -or -not $branch -or $branch -eq "main") {
    $grund = if ($OhneGh) { "mit -OhneGh übersprungen" } elseif (-not $ghVorhanden) { "gh nicht gefunden" } else { "kein Feature-Branch" }
    Add-Pruefung "G7" "Pull Request offen, kein Draft, Checks grün" "offen" $grund
    Add-Pruefung "G2" "Review ohne Änderungswunsch" "offen" $grund
} else {
    $pr = Invoke-Befehl "gh" @("pr", "list", "--head", $branch, "--state", "open", "--json", "number,url,isDraft,baseRefName,reviewDecision,mergeable,statusCheckRollup")
    $daten = $null
    if ($pr.ExitCode -eq 0) { try { $daten = @(($pr.Ausgabe -join "`n") | ConvertFrom-Json) } catch { $daten = $null } }
    if ($null -eq $daten) {
        Add-Pruefung "G7" "Pull Request offen, kein Draft, Checks grün" "offen" "gh-Abfrage fehlgeschlagen: $(($pr.Ausgabe | Select-Object -First 1))"
        Add-Pruefung "G2" "Review ohne Änderungswunsch" "offen" "gh-Abfrage fehlgeschlagen"
    } elseif ($daten.Count -eq 0) {
        Add-Pruefung "G7" "Pull Request offen, kein Draft, Checks grün" "nicht bestanden" "kein offener Pull Request für $branch"
        Add-Pruefung "G2" "Review ohne Änderungswunsch" "offen" "kein offener Pull Request"
    } else {
        $p = $daten[0]
        $checks = @($p.statusCheckRollup)
        $fehler = @($checks | Where-Object { ($_.conclusion -and $_.conclusion -notin @("SUCCESS", "NEUTRAL", "SKIPPED")) -or $_.state -in @("FAILURE", "ERROR") })
        $laufend = @($checks | Where-Object { -not $_.conclusion -and $_.state -notin @("SUCCESS", "FAILURE", "ERROR") })
        $text = "PR #$($p.number) gegen $($p.baseRefName), Draft: $(if ($p.isDraft) { 'ja' } else { 'nein' }), mergeable: $($p.mergeable), Checks: $($checks.Count) gesamt, $($fehler.Count) fehlgeschlagen, $($laufend.Count) laufend ($($p.url))"
        $ergebnis = if ($p.baseRefName -ne "main" -or $p.isDraft -or $fehler.Count -gt 0 -or $p.mergeable -eq "CONFLICTING") { "nicht bestanden" }
            elseif ($checks.Count -eq 0 -or $laufend.Count -gt 0 -or $p.mergeable -ne "MERGEABLE") { "offen" }
            else { "bestanden" }
        Add-Pruefung "G7" "Pull Request offen, kein Draft, Checks grün" $ergebnis $text
        $review = if ($p.reviewDecision) { $p.reviewDecision } else { "kein Review-Status" }
        $reviewErgebnis = if ($p.reviewDecision -eq "CHANGES_REQUESTED") { "nicht bestanden" } else { "bestanden" }
        Add-Pruefung "G2" "Review ohne Änderungswunsch" $reviewErgebnis "PR #$($p.number): $review"
    }
}

# --- G1 Code ---------------------------------------------------------------
$ciCheck = Join-Path $Projekt "scripts/ci-check.ps1"
if (-not (Test-Path -LiteralPath $ciCheck)) {
    Add-Pruefung "G1" "ci-check.ps1" "nicht bestanden" "scripts/ci-check.ps1 fehlt"
} else {
    $ci = Invoke-Befehl $pwshPfad @("-NoProfile", "-NonInteractive", "-File", $ciCheck)
    if ($ci.ExitCode -eq 0) {
        $okZeile = $ci.Ausgabe | Where-Object { $_ -like "OK:*" } | Select-Object -Last 1
        Add-Pruefung "G1" "ci-check.ps1" "bestanden" "Exit 0; $okZeile"
    } else {
        $fehlerZeilen = ($ci.Ausgabe | Where-Object { $_ -and $_ -notlike "Hinweis:*" } | Select-Object -First 3) -join "; "
        Add-Pruefung "G1" "ci-check.ps1" "nicht bestanden" "Exit $($ci.ExitCode); $fehlerZeilen"
    }
}

$jsDateien = @(Get-ChildItem -LiteralPath (Join-Path $Projekt "assets/js") -Filter "*.js" -File -ErrorAction SilentlyContinue)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Add-Pruefung "G1" "node --check" "offen" "node nicht gefunden"
} elseif ($jsDateien.Count -eq 0) {
    Add-Pruefung "G1" "node --check" "nicht bestanden" "keine Dateien unter assets/js"
} else {
    $nodeFehler = @()
    foreach ($js in $jsDateien) {
        if ((Invoke-Befehl "node" @("--check", $js.FullName)).ExitCode -ne 0) { $nodeFehler += $js.Name }
    }
    if ($nodeFehler.Count -gt 0) {
        Add-Pruefung "G1" "node --check" "nicht bestanden" "Syntaxfehler in: $($nodeFehler -join ', ')"
    } else {
        Add-Pruefung "G1" "node --check" "bestanden" "$($jsDateien.Count) Dateien ohne Fehler: $(($jsDateien | ForEach-Object Name) -join ', ')"
    }
}

$testOrdner = Join-Path $Projekt "tests"
if ($OhnePester) {
    Add-Pruefung "G1" "Pester-Tests" "offen" "mit -OhnePester übersprungen"
} elseif (-not (Test-Path -LiteralPath $testOrdner)) {
    Add-Pruefung "G1" "Pester-Tests" "offen" "kein Ordner tests/"
} else {
    $pesterBefehl = "`$r = Invoke-Pester -Path '$($testOrdner -replace "'", "''")' -PassThru; " +
        "Write-Output ('PESTER-ERGEBNIS ' + `$r.PassedCount + ' ' + `$r.FailedCount); exit [int](`$r.FailedCount -gt 0)"
    $pester = Invoke-Befehl $pwshPfad @("-NoProfile", "-NonInteractive", "-Command", $pesterBefehl)
    $zeile = $pester.Ausgabe | Where-Object { $_ -match '^PESTER-ERGEBNIS (\d+) (\d+)$' } | Select-Object -Last 1
    if ($zeile -match '^PESTER-ERGEBNIS (?<ok>\d+) (?<fehler>\d+)$') {
        $ergebnis = if ($pester.ExitCode -eq 0 -and [int]$Matches.fehler -eq 0) { "bestanden" } else { "nicht bestanden" }
        Add-Pruefung "G1" "Pester-Tests" $ergebnis "Invoke-Pester -Path tests: $($Matches.ok) bestanden, $($Matches.fehler) fehlgeschlagen"
    } else {
        Add-Pruefung "G1" "Pester-Tests" "nicht bestanden" "Invoke-Pester ohne Ergebnis, Exit $($pester.ExitCode): $(($pester.Ausgabe | Select-Object -Last 1))"
    }
}

# --- G2 Kommentare: jedes Skript erklärt sich in den ersten zehn Zeilen. ----
$skripte = @(Get-ChildItem -LiteralPath (Join-Path $Projekt "scripts") -Recurse -File -Include "*.ps1", "*.py" -ErrorAction SilentlyContinue)
$ohneKommentar = @()
foreach ($skript in $skripte) {
    $kopf = @(Get-Content -LiteralPath $skript.FullName -TotalCount 10)
    if (-not ($kopf | Where-Object { $_ -match '^\s*(#|<#|""")' })) {
        $ohneKommentar += $skript.FullName.Substring($Projekt.Length + 1)
    }
}
if ($skripte.Count -eq 0) {
    Add-Pruefung "G2" "Kopfkommentar je Skript" "offen" "keine Skripte unter scripts/"
} elseif ($ohneKommentar.Count -gt 0) {
    Add-Pruefung "G2" "Kopfkommentar je Skript" "nicht bestanden" "ohne Kommentar in den ersten zehn Zeilen: $($ohneKommentar -join ', ')"
} else {
    Add-Pruefung "G2" "Kopfkommentar je Skript" "bestanden" "$($skripte.Count) Skripte unter scripts/ mit Kommentar in den ersten zehn Zeilen"
}

# --- G6 Lokal ----------------------------------------------------------------
# Upload-Paket ermitteln: -Paket oder das jüngste Paket dieser Version unter output/ftp.
$paketPfad = ""
if ($Paket) {
    if (-not (Test-Path -LiteralPath $Paket)) { throw "Paket nicht gefunden: $Paket" }
    $paketPfad = (Resolve-Path -LiteralPath $Paket).Path
} else {
    $kandidat = Get-ChildItem -LiteralPath (Join-Path $Projekt "output/ftp") -Filter "relingit-upload-v$Version-*.zip" -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($kandidat) { $paketPfad = $kandidat.FullName }
}
$paketName = if ($paketPfad) { Split-Path -Leaf $paketPfad } else { "" }
$paketOhneAudio = $false
$paketMp3 = @()
if ($paketPfad) {
    # Inhalt lesen: Dateiliste und UPLOAD-MANIFEST.txt, aus ZIP oder Ordner.
    $manifest = ""
    if (Test-Path -LiteralPath $paketPfad -PathType Container) {
        $paketDateien = @(Get-ChildItem -LiteralPath $paketPfad -Recurse -File | ForEach-Object { $_.FullName.Substring($paketPfad.Length + 1).Replace('\', '/') })
        $manifestPfad = Join-Path $paketPfad "UPLOAD-MANIFEST.txt"
        if (Test-Path -LiteralPath $manifestPfad) { $manifest = Get-Content -Raw -Encoding utf8 -LiteralPath $manifestPfad }
    } else {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $archiv = [System.IO.Compression.ZipFile]::OpenRead($paketPfad)
        try {
            $paketDateien = @($archiv.Entries | Where-Object { -not $_.FullName.EndsWith('/') } | ForEach-Object { $_.FullName.Replace('\', '/') })
            $eintrag = $archiv.Entries | Where-Object { $_.FullName -eq "UPLOAD-MANIFEST.txt" } | Select-Object -First 1
            if ($eintrag) {
                $leser = New-Object System.IO.StreamReader($eintrag.Open(), [System.Text.Encoding]::UTF8)
                try { $manifest = $leser.ReadToEnd() } finally { $leser.Dispose() }
            }
        } finally {
            $archiv.Dispose()
        }
    }
    $paketMp3 = @($paketDateien | Where-Object { $_ -like "assets/audio/*.mp3" })
    $paketOhneAudio = ($paketName -match '-ohne-audio(\.zip)?$') -or ($manifest -match '(?m)^Ohne Audio:')
}

$summenDatei = Join-Path $Projekt "assets/audio/SHA256SUMS.txt"
if ($paketOhneAudio -and $paketMp3.Count -gt 0) {
    Add-Pruefung "G6" "Podcast-MP3 gegen SHA256SUMS.txt" "nicht bestanden" "Paket $paketName ist als ohne Audio gekennzeichnet, enthält aber $($paketMp3.Count) MP3: $($paketMp3 -join ', ')"
} elseif ($paketOhneAudio) {
    # Entscheidung Bernd, 10.11.2026 (Auftrag R54): Bei einem Paket ohne Audio gilt die MP3-Prüfung nicht.
    Add-Pruefung "G6" "Podcast-MP3 gegen SHA256SUMS.txt" "nicht zutreffend" "Paket $paketName enthält keine Podcast-MP3 (ohne Audio); die Live-MP3 bleiben beim Upload unverändert, darum entfällt der Prüfsummenvergleich"
} elseif (-not (Test-Path -LiteralPath $summenDatei)) {
    Add-Pruefung "G6" "Podcast-MP3 gegen SHA256SUMS.txt" "nicht bestanden" "assets/audio/SHA256SUMS.txt fehlt"
} else {
    $erwartet = [ordered]@{}
    foreach ($zeile in (Get-Content -LiteralPath $summenDatei -Encoding utf8)) {
        $m = [regex]::Match($zeile, '^(?<hash>[0-9a-fA-F]{64}) [ *](?<name>\S+)$')
        if ($m.Success) { $erwartet[$m.Groups['name'].Value] = $m.Groups['hash'].Value.ToUpperInvariant() }
    }
    $fehlend = @(); $abweichend = @(); $passend = @()
    foreach ($name in $erwartet.Keys) {
        $pfad = Join-Path $AudioOrdner $name
        if (-not (Test-Path -LiteralPath $pfad -PathType Leaf)) { $fehlend += $name; continue }
        if ((Get-FileHash -Algorithm SHA256 -LiteralPath $pfad).Hash -eq $erwartet[$name]) { $passend += $name } else { $abweichend += $name }
    }
    $text = "$($passend.Count) von $($erwartet.Count) passend"
    $text = if ($paketName) { "Paket ${paketName} mit Audio; $text" } else { "kein Upload-Paket gefunden; $text" }
    if ($abweichend.Count -gt 0) { $text += "; abweichend: $($abweichend -join ', ')" }
    if ($fehlend.Count -gt 0) { $text += "; nicht vorhanden in ${AudioOrdner}: $($fehlend -join ', ')" }
    $ergebnis = if ($erwartet.Count -eq 0 -or $abweichend.Count -gt 0) { "nicht bestanden" } elseif ($fehlend.Count -gt 0) { "offen" } else { "bestanden" }
    Add-Pruefung "G6" "Podcast-MP3 gegen SHA256SUMS.txt" $ergebnis $text
}

$vorschau = Join-Path $PSScriptRoot "vorschau.ps1"
$python = Get-Command python, python3 -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not (Test-Path -LiteralPath $vorschau)) {
    Add-Pruefung "G6" "Lokale Vorschau möglich" "nicht bestanden" "scripts/vorschau.ps1 fehlt"
} elseif (-not $python) {
    Add-Pruefung "G6" "Lokale Vorschau möglich" "offen" "Python nicht gefunden (für python -m http.server)"
} else {
    Add-Pruefung "G6" "Lokale Vorschau möglich" "bestanden" "scripts/vorschau.ps1 vorhanden, Python: $($python.Source)"
}

# --- Sichtungsliste (Nachweis für G3, G4, G5) ---------------------------------
New-Item -ItemType Directory -Path $AusgabeOrdner -Force | Out-Null
$sichtungPfad = Join-Path $AusgabeOrdner "SICHTUNG-v$Version.md"
$freigabePfad = Join-Path $AusgabeOrdner "FREIGABE-v$Version.md"
$utf8 = New-Object System.Text.UTF8Encoding($false)
$jetzt = (Get-Date).ToString("yyyy-MM-dd HH:mm")

$seitenzahl = "?"
$appJs = Join-Path $Projekt "assets/js/app.js"
if (Test-Path -LiteralPath $appJs) {
    $m = [regex]::Match((Get-Content -Raw -LiteralPath $appJs), 'fallbackRelease\s*=\s*\{[\s\S]*?pageCount:\s*(?<n>\d+)')
    if ($m.Success) { $seitenzahl = $m.Groups['n'].Value }
}

if (-not (Test-Path -LiteralPath $sichtungPfad)) {
    $seiten = @(
        @("Startseite", "index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf"),
        @("Lesefassung", "lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln"),
        @("Handout", "handout.html: Handout lädt, Download-Link vorhanden"),
        @("Datenschutz", "datenschutz.html: vollständig lesbar, nichts abgeschnitten"),
        @("Impressum", "impressum.html: vollständig lesbar, nichts abgeschnitten"),
        @("Podcast-Player", "index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung)")
    )
    $pdf = @(
        @("Deckblatt", "Version $Version, Datum und Hinweis Neu in v$Version stimmen"),
        @("Neue Szene", "beginnt sauber, Überschrift vorhanden, kein abgeschnittener Text"),
        @("Codebox", "vollständig, nicht über den Seitenrand, gut lesbar"),
        @("SVG-Seite", "Grafik vollständig und scharf"),
        @("Mini-TOC", "alle Einträge vorhanden, Links springen an die richtige Stelle"),
        @("Seitenzahl", "Seitenzahl der PDF entspricht der Angabe auf der Startseite ($seitenzahl)")
    )
    $inhalt = @(
        @("Neue Szene gelesen", "neue Szene vollständig gelesen, keine inhaltlichen oder sprachlichen Fehler"),
        @("Versionshinweise", "Versionshistorie und Neu in v$Version beschreiben die Änderungen zutreffend")
    )
    $zeilen = [System.Collections.Generic.List[string]]::new()
    $zeilen.Add("# Sichtungsliste v$Version")
    $zeilen.Add("")
    $zeilen.Add("Erzeugt: $jetzt von scripts/freigabe-pruefen.ps1. Branch: $(if ($branch) { $branch } else { 'unbekannt' }), Commit: $(if ($commit) { $commit } else { 'unbekannt' }).")
    $zeilen.Add("")
    $zeilen.Add("Ablauf: Vorschau mit ``./scripts/vorschau.ps1`` starten (nur 127.0.0.1, Beenden mit Strg+C). Breite im Browser über die Entwicklerwerkzeuge einstellen (Strg+Umschalt+I, dann Strg+Umschalt+M). Die PDF liegt unter ``story/current/geschichte.pdf`` (``./scripts/vorschau.ps1 -Pdf``).")
    $zeilen.Add("")
    $zeilen.Add("In der Spalte Ergebnis genau **Ja** oder **Nein** eintragen, bei Nein eine Bemerkung. Diese Liste ist der Nachweis für G3 Layout, G4 UI und G5 Inhalt (docs/FREIGABE.md). Solange ein Punkt Nein oder leer ist, bleibt G8 gesperrt. Das Skript überschreibt diese Datei nicht.")
    $zeilen.Add("")
    $zeilen.Add("## Webseiten (G4 UI)")
    $zeilen.Add("")
    $zeilen.Add("| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |")
    $zeilen.Add("|---|---|---|---|---|---|---|")
    $nr = 0
    foreach ($seite in $seiten) {
        foreach ($breite in @(390, 768, 1280)) {
            $nr++
            $zeilen.Add(("| W{0:D2} | G4 | {1} | {2} | {3} px |  |  |" -f $nr, $seite[0], $seite[1], $breite))
        }
    }
    $zeilen.Add("")
    $zeilen.Add("## PDF (G3 Layout)")
    $zeilen.Add("")
    $zeilen.Add("| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |")
    $zeilen.Add("|---|---|---|---|---|---|---|")
    $nr = 0
    foreach ($punkt in $pdf) {
        $nr++
        $zeilen.Add(("| P{0:D2} | G3 | PDF: {1} | {2} | - |  |  |" -f $nr, $punkt[0], $punkt[1]))
    }
    $zeilen.Add("")
    $zeilen.Add("## Inhalt (G5 Inhalt)")
    $zeilen.Add("")
    $zeilen.Add("| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |")
    $zeilen.Add("|---|---|---|---|---|---|---|")
    $nr = 0
    foreach ($punkt in $inhalt) {
        $nr++
        $zeilen.Add(("| I{0:D2} | G5 | {1} | {2} | - |  |  |" -f $nr, $punkt[0], $punkt[1]))
    }
    [System.IO.File]::WriteAllText($sichtungPfad, (($zeilen -join "`n") + "`n"), $utf8)
    $sichtungNeu = $true
} else {
    $sichtungNeu = $false
}

# Auswertung der Sichtungsliste: Zeilen | Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis | Bemerkung |
$sichtung = @{}
foreach ($tor in @("G3", "G4", "G5")) { $sichtung[$tor] = [ordered]@{ Ja = 0; Nein = 0; Leer = 0; NeinNr = @() } }
foreach ($zeile in (Get-Content -LiteralPath $sichtungPfad -Encoding utf8)) {
    if ($zeile -notmatch '^\|\s*[WPI]\d{2}\s*\|') { continue }
    $zellen = $zeile -split '\|'
    if ($zellen.Count -lt 8) { continue }
    $tor = $zellen[2].Trim()
    if (-not $sichtung.ContainsKey($tor)) { continue }
    $wert = ($zellen[6].Trim() -replace '\*', '')
    if ($wert -match '^(?i)ja$') { $sichtung[$tor].Ja++ }
    elseif ($wert -match '^(?i)nein$') { $sichtung[$tor].Nein++; $sichtung[$tor].NeinNr += $zellen[1].Trim() }
    else { $sichtung[$tor].Leer++ }
}
$sichtungName = Split-Path -Leaf $sichtungPfad
$torNamen = @{ G3 = "Sichtung PDF"; G4 = "Sichtung Webseiten in 390, 768 und 1280 px"; G5 = "Inhalt gelesen" }
foreach ($tor in @("G3", "G4", "G5")) {
    $s = $sichtung[$tor]
    $summe = $s.Ja + $s.Nein + $s.Leer
    $text = "${sichtungName}: $($s.Ja) Ja, $($s.Nein) Nein, $($s.Leer) leer von $summe"
    if ($s.Nein -gt 0) { $text += " (Nein: $($s.NeinNr -join ', '))" }
    if ($summe -eq 0) { $text = "${sichtungName}: keine Prüfpunkte für $tor gefunden" }
    elseif ($s.Ja -eq $summe) { $text += "; vollständig, Bestätigung durch Bernd mit G8" }
    # Nie bestanden: Die Sichtung ist ein menschlicher Nachweis, keine Automatik.
    Add-Pruefung $tor $torNamen[$tor] "offen" $text
}

# --- G8 Freigabe Bernd: nie automatisch, gesperrt solange etwas fehlt. -----------
$sperrgruende = @()
foreach ($tor in @("G1", "G2", "G6", "G7")) {
    $schlecht = @($pruefungen | Where-Object { $_.Tor -eq $tor -and $_.Ergebnis -notin $nichtBlockierend })
    if ($schlecht.Count -gt 0) { $sperrgruende += "$tor $(($schlecht | ForEach-Object Ergebnis | Sort-Object { $rang[$_] } -Descending | Select-Object -First 1))" }
}
foreach ($tor in @("G3", "G4", "G5")) {
    $s = $sichtung[$tor]
    if ($s.Nein -gt 0 -or $s.Leer -gt 0 -or ($s.Ja + $s.Nein + $s.Leer) -eq 0) { $sperrgruende += "$tor Sichtung unvollständig ($($s.Nein) Nein, $($s.Leer) leer)" }
}
if ($sperrgruende.Count -gt 0) {
    Add-Pruefung "G8" "Freigabe durch Bernd" "gesperrt" "Voraussetzungen fehlen: $($sperrgruende -join '; ')"
} else {
    Add-Pruefung "G8" "Freigabe durch Bernd" "offen" "Voraussetzungen erfüllt; Freigabe nur durch Bernd, z. B. PR-Kommentar 'Freigabe G8 v${Version}: ja'"
}

# --- Bericht -------------------------------------------------------------------
$tore = [ordered]@{ G1 = "Code"; G2 = "Kommentare"; G3 = "Layout"; G4 = "UI"; G5 = "Inhalt"; G6 = "Lokal"; G7 = "Git"; G8 = "Freigabe Bernd" }
$zusammenfassung = foreach ($tor in $tore.Keys) {
    $eintraege = @($pruefungen | Where-Object Tor -eq $tor)
    $schlechtestes = $eintraege | ForEach-Object Ergebnis | Sort-Object { $rang[$_] } -Descending | Select-Object -First 1
    [pscustomobject]@{
        Tor = $tor; Name = $tore[$tor]; Ergebnis = $schlechtestes
        Nachweis = ($eintraege | ForEach-Object { "$($_.Pruefung): $($_.Ergebnis)" }) -join "; "
    }
}
$nichtBestanden = @($pruefungen | Where-Object Ergebnis -eq "nicht bestanden")

$bericht = [System.Collections.Generic.List[string]]::new()
$bericht.Add("# Freigabebericht v$Version")
$bericht.Add("")
$bericht.Add("Erzeugt: $jetzt von scripts/freigabe-pruefen.ps1. Branch: $(if ($branch) { $branch } else { 'unbekannt' }), Commit: $(if ($commit) { $commit } else { 'unbekannt' }). Projekt: ``$Projekt``.")
$bericht.Add("")
$bericht.Add("Regel (docs/FREIGABE.md): Kein Merge, kein Tag und kein Upload, solange ein Tor nicht bestanden, offen oder gesperrt ist. G3, G4, G5 und G8 gibt das Skript nie als bestanden aus; G8 erteilt nur Bernd.")
$bericht.Add("")
$bericht.Add("## Tore")
$bericht.Add("")
$bericht.Add("| Tor | Name | Ergebnis | Nachweis |")
$bericht.Add("|---|---|---|---|")
foreach ($z in $zusammenfassung) {
    $bericht.Add("| $($z.Tor) | $($z.Name) | $($z.Ergebnis) | $(Format-Zelle $z.Nachweis) |")
}
$bericht.Add("")
$bericht.Add("## Einzelprüfungen")
$bericht.Add("")
$bericht.Add("| Tor | Prüfung | Ergebnis | Nachweis |")
$bericht.Add("|---|---|---|---|")
foreach ($p in ($pruefungen | Sort-Object Tor)) {
    $bericht.Add("| $($p.Tor) | $(Format-Zelle $p.Pruefung) | $($p.Ergebnis) | $(Format-Zelle $p.Nachweis) |")
}
$bericht.Add("")
$bericht.Add("## Gesamtergebnis")
$bericht.Add("")
$sichtungHinweis = if ($sichtungNeu) { "neu angelegt" } else { "vorhanden, ausgewertet, nicht überschrieben" }
if ($nichtBestanden.Count -gt 0) {
    $bericht.Add("Nicht freigabefähig: $($nichtBestanden.Count) automatische Prüfung(en) nicht bestanden.")
} else {
    $bericht.Add("Keine automatische Prüfung nicht bestanden. Freigabe erst nach Sichtung und Entscheidung von Bernd (G8).")
}
$bericht.Add("")
$bericht.Add("Sichtungsliste: ``$sichtungName`` ($sichtungHinweis).")
[System.IO.File]::WriteAllText($freigabePfad, (($bericht -join "`n") + "`n"), $utf8)

foreach ($z in $zusammenfassung) { Write-Host ("{0} {1,-15} {2}" -f $z.Tor, $z.Name, $z.Ergebnis) }
Write-Host "Bericht: $freigabePfad"
Write-Host "Sichtungsliste: $sichtungPfad ($sichtungHinweis)"
if ($nichtBestanden.Count -gt 0) {
    Write-Host "Ergebnis: $($nichtBestanden.Count) automatische Prüfung(en) nicht bestanden."
    exit 1
}
Write-Host "Ergebnis: keine automatische Prüfung nicht bestanden. G8 erteilt nur Bernd."
exit 0
