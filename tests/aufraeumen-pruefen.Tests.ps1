# Pester-Tests für scripts/aufraeumen-pruefen.ps1 (Zielversion Pester 5, läuft auch mit Pester 3.4).
# Ausführen im Projektordner: Invoke-Pester -Path tests
# Die Tests bauen ein temporäres Git-Repository mit lokalem Bare-Repository als
# origin, mehreren Worktrees und Branches (Merge, Squash, inhaltsgleich, offen).
# Kein Netzwerkzugriff. Geprüft wird die Tabelle und dass das Skript nichts
# verändert (Refs, Worktrees, Index-Dateien, Objekte, ignorierte Dateien).

Describe "aufraeumen-pruefen.ps1" {
    BeforeAll {
        . (Join-Path $PSScriptRoot "TestHelfer.ps1")
        $script:Basis = Join-Path $TestDrive "aufraeumen"
        $script:Repo = Join-Path $script:Basis "repo"
        $script:Origin = Join-Path $script:Basis "origin.git"
        $script:SkriptOrt = Join-Path $script:Basis "werkzeug"
        New-Item -ItemType Directory -Path (Join-Path $script:SkriptOrt "scripts") -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $script:RepoRoot "scripts/aufraeumen-pruefen.ps1") -Destination (Join-Path $script:SkriptOrt "scripts/aufraeumen-pruefen.ps1")

        function G([string[]]$Argumente) {
            $vorher = $ErrorActionPreference
            $ErrorActionPreference = "Continue"
            try {
                $aus = & git -C $script:Repo @Argumente 2>&1
                if ($LASTEXITCODE -ne 0) { throw "git $($Argumente -join ' ') fehlgeschlagen:`n$aus" }
                return $aus
            } finally {
                $ErrorActionPreference = $vorher
            }
        }
        function Datei([string]$Name, [string]$Inhalt) { Write-Utf8Datei (Join-Path $script:Repo $Name) $Inhalt }
        function Commit([string]$Name, [string]$Inhalt) { Datei $Name $Inhalt; G @("add", "-A") | Out-Null; G @("commit", "-q", "-m", "$Name") | Out-Null }

        # commit.gpgsign gilt nur im Wegwerf-Repository des Tests.
        $vorher = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        git init -q --bare $script:Origin 2>&1 | Out-Null
        git init -q -b main $script:Repo 2>&1 | Out-Null
        $ErrorActionPreference = $vorher
        foreach ($c in @(@("user.name", "Test"), @("user.email", "test@example.invalid"), @("commit.gpgsign", "false"), @("core.autocrlf", "false"))) {
            G @("config", $c[0], $c[1]) | Out-Null
        }
        Datei ".gitignore" "output/`nreports/`n"
        Commit "a.txt" "a`n"

        # gemergt: per Merge-Commit in main (Vorfahre).
        G @("checkout", "-q", "-b", "gemergt") | Out-Null
        Commit "b.txt" "b`n"
        # gemergt2: ebenfalls per Merge-Commit, ohne Worktree.
        G @("checkout", "-q", "-b", "gemergt2", "main") | Out-Null
        Commit "b2.txt" "b2`n"
        # squash: zwei Commits, in main als ein Squash-Commit; danach geht main weiter.
        G @("checkout", "-q", "-b", "squash", "main") | Out-Null
        Commit "c1.txt" "c1`n"
        Commit "c2.txt" "c2`n"
        # offen: Inhalt fehlt in main.
        G @("checkout", "-q", "-b", "offen", "main") | Out-Null
        Commit "e.txt" "e`n"

        G @("checkout", "-q", "main") | Out-Null
        G @("merge", "-q", "--no-ff", "-m", "Merge gemergt", "gemergt") | Out-Null
        G @("merge", "-q", "--no-ff", "-m", "Merge gemergt2", "gemergt2") | Out-Null
        G @("merge", "-q", "--squash", "squash") | Out-Null
        G @("commit", "-q", "-m", "Squash squash") | Out-Null
        # inhalt: kein Vorfahre, aber derselbe Baum wie main am Ende.
        G @("branch", "inhalt", "main") | Out-Null
        Commit "d.txt" "d`n"
        G @("checkout", "-q", "inhalt") | Out-Null
        Commit "d.txt" "d`n"
        G @("checkout", "-q", "main") | Out-Null

        G @("remote", "add", "origin", $script:Origin) | Out-Null
        G @("push", "-q", "origin", "main") | Out-Null
        G @("fetch", "-q", "origin") | Out-Null

        # Worktrees: gemergt sauber mit ignorierter Datei, offen mit Änderung, neu ohne eigene Commits, losgelöst.
        $script:WtGemergt = Join-Path $script:Basis "wt-gemergt"
        $script:WtOffen = Join-Path $script:Basis "wt-offen"
        $script:WtNeu = Join-Path $script:Basis "wt-neu"
        $script:WtLos = Join-Path $script:Basis "wt-los"
        G @("worktree", "add", "-q", $script:WtGemergt, "gemergt") | Out-Null
        G @("worktree", "add", "-q", $script:WtOffen, "offen") | Out-Null
        G @("worktree", "add", "-q", "-b", "neu", $script:WtNeu, "origin/main") | Out-Null
        G @("worktree", "add", "-q", "--detach", $script:WtLos, "main~1") | Out-Null
        $script:Ignoriert = Join-Path $script:WtGemergt "output/paket.zip"
        Write-Utf8Datei $script:Ignoriert "ungesichertes Paket`n"
        Write-Utf8Datei (Join-Path $script:WtOffen "notiz.txt") "nicht committet`n"

        function Get-Zustand {
            $z = [ordered]@{}
            $z.Refs = (G @("for-each-ref", "--format=%(refname) %(objectname)")) -join "`n"
            $z.Worktrees = (G @("worktree", "list", "--porcelain")) -join "`n"
            $z.Objekte = (G @("count-objects", "-v")) -join "`n"
            foreach ($pfad in @($script:Repo, $script:WtGemergt, $script:WtOffen, $script:WtNeu, $script:WtLos)) {
                $z["status $pfad"] = (& git -C $pfad status --porcelain --ignored 2>&1) -join "`n"
            }
            $indexDateien = @(Get-Item -LiteralPath (Join-Path $script:Repo ".git/index")) + @(Get-ChildItem -Path (Join-Path $script:Repo ".git/worktrees") -Recurse -Filter index -File)
            foreach ($i in $indexDateien) { $z["index $($i.FullName)"] = $i.LastWriteTimeUtc.Ticks }
            return $z
        }
        # git status kann den Index beim ersten Aufruf auffrischen; danach ist der Stand stabil.
        Get-Zustand | Out-Null
        $script:Vorher = Get-Zustand
        $script:Ergebnis = Invoke-MiniSkript -Projekt $script:SkriptOrt -Skript "aufraeumen-pruefen.ps1" -Argumente @("-Projekt", $script:Repo, "-Markdown")
        $script:Nachher = Get-Zustand

        function Get-Zeile([string]$Name) {
            $treffer = @($script:Ergebnis.Ausgabe -split "`n" | Where-Object { $_ -like "| $Name |*" })
            if ($treffer.Count -ne 1) { throw "Erwartet genau eine Zeile für '$Name', gefunden: $($treffer.Count)`n$($script:Ergebnis.Ausgabe)" }
            return $treffer[0]
        }
        function Assert-Zeile([string]$Name, [string]$Muster) {
            $zeile = Get-Zeile $Name
            if ($zeile -notmatch $Muster) { throw "Zeile '$Name' passt nicht zu '$Muster':`n$zeile" }
        }
    }

    It "endet mit Exit 0 und gibt Kopf und Spalten aus" {
        Assert-Erfolg $script:Ergebnis "Basis: origin/main [0-9a-f]{7}; 5 Worktrees, 7 lokale Branches"
        if ($script:Ergebnis.Ausgabe -notmatch '\| Name \| Pfad \| sauber \| ignorierte Dateien \| in origin/main \| Remote \| Empfehlung \|') { throw "Spaltenkopf fehlt:`n$($script:Ergebnis.Ausgabe)" }
    }

    It "erkennt Vorfahren, Squash per patch-id, identischen Inhalt und offene Branches" {
        Assert-Zeile "gemergt2" '\| – \| – \| – \| ja \| [^|]+ \| löschbar: git branch -d gemergt2 \|'
        Assert-Zeile "squash" '\| Squash-gleich \|.*git branch -D squash'
        Assert-Zeile "inhalt" '\| Squash-gleich \|.*git branch -D inhalt'
        Assert-Zeile "main" '\| ja \| [^|]+ \| Arbeitsklon, belassen \|'
    }

    It "meldet Worktree-Zustand, ignorierte Dateien und passende Empfehlungen" {
        Assert-Zeile "gemergt" '\| ja \| output/ \| ja \|.*erst ignorierte Dateien sichern'
        Assert-Zeile "offen" '\| nein \(1\) \| – \| nein \(1 eigene Commits;.*belassen: ungesicherte Änderungen'
        Assert-Zeile "neu" '\| ja \| – \| ja \|.*keine eigenen Commits'
        $los = @($script:Ergebnis.Ausgabe -split "`n" | Where-Object { $_ -like "| (losgelöst *" })
        if ($los.Count -ne 1 -or $los[0] -notmatch '\| ja \| – \| ja \|.*entfernbar: git worktree remove') { throw "Losgelöster Worktree falsch:`n$($script:Ergebnis.Ausgabe)" }
    }

    It "verändert weder Refs noch Worktrees, Index, Objekte oder ignorierte Dateien" {
        foreach ($schluessel in $script:Vorher.Keys) {
            if ("$($script:Vorher[$schluessel])" -ne "$($script:Nachher[$schluessel])") { throw "Verändert: $schluessel`nvorher: $($script:Vorher[$schluessel])`nnachher: $($script:Nachher[$schluessel])" }
        }
        if (-not (Test-Path -LiteralPath $script:Ignoriert)) { throw "Ignorierte Datei wurde gelöscht." }
    }

    It "ruft Git nur lesend auf (kein push, kein Löschen, kein Ref-Schreiben)" {
        $text = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $script:RepoRoot "scripts/aufraeumen-pruefen.ps1")
        $verboten = [regex]::Matches($text, '(?m)&\s*git\b[^\r\n]*\b(push|branch\s+-[dDmM]|worktree\s+(remove|prune|add)|reset|checkout|switch|update-ref|merge-tree|gc|clean)\b')
        if ($verboten.Count -gt 0) { throw "Schreibender Git-Aufruf im Skript: $($verboten[0].Value)" }
    }

    It "bricht mit verständlicher Meldung ab, wenn die Basis fehlt" {
        $ergebnis = Invoke-MiniSkript -Projekt $script:SkriptOrt -Skript "aufraeumen-pruefen.ps1" -Argumente @("-Projekt", $script:Repo, "-Basis", "origin/gibtsnicht")
        Assert-Fehlschlag $ergebnis "Basis 'origin/gibtsnicht' nicht gefunden"
    }
}
