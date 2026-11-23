---
titel: 'R53 Vorbereitung: Liste zum Aufräumen nach v1.40 (nur lesend)'
datum: 2026-11-23
auftrag: R53
ergebnis: vorgelegt, nichts gelöscht
---

# R53 Vorbereitung

Nur gelesen. Gelöscht, verschoben oder geändert wurde nichts. Jede Löschung braucht eine Einzelfreigabe des Product Owners. Einzige freigegebene Löschung war der Remote-Branch `auftrag-R87-supabase-betrieb`. Er war schon beim Merge von #42 automatisch entfernt (`delete_branch_on_merge: true`); sein Head 53e0a48 ist in `main` f48da7b enthalten. Es blieb nichts zu tun.

| Nr. | Objekt | Befund (Befehl) | Vorschlag (Claude) |
|---|---|---|---|
| 1 | Worktree `C:\dev\wt\relingit\r60`, Branch `auftrag-R60-v139` | sauber, 0 Commits außerhalb `origin/main`, Remote-Branch weg; ignoriert: `archive/ftp-packages/`, `output/`, `reports/` (`git status --porcelain --ignored`, `git rev-list --count HEAD --not origin/main`) | Entfernen, wenn die ignorierten Ordner nicht mehr gebraucht werden (vorher Inhalt zeigen). |
| 2 | Worktree `r86` | existiert nicht (`git worktree list`) | Aus R53 streichen. |
| 3 | Worktree `C:\dev\wt\relingit\trailer`, Branch `trailer-hero` | sauber, 0 eigene Commits, PR #38 gemergt; ignoriert: `archive/ftp-packages/`, `output/` | Entfernen wie Nr. 1. In R53 bisher nicht genannt. |
| 4 | Worktree `C:\dev\wt\relingit\paket-v139`, Branch `paket-v139` (nur lokal) | sauber; 2 Merge-Commits (d9a3434, a39d2a1) außerhalb `main`, Code gleich 907ca58, Unterschied nur in `docs/PDF-ERZEUGEN.md`, `docs/PILOT.md`, `docs/TAGESSTART.md` (auf `main` neuer); ignoriert: `output/` mit Paket v1.39 | Paket v1.39 ist Grundlage einer offenen Entscheidung zu R52. Erst danach entfernen. In R53 bisher nicht genannt. |
| 5 | Zweiter Klon `C:\dev\reling-it\relingit` | Remote Reling-IT/relingit, letzter Commit 6ea5f6d (27.10.2026), keine Änderungen, kein Stash, 0 eigene Commits | Entfernen (Regel: ein Arbeitsklon je Repo). |
| 6 | OneDrive-Klon `C:\Users\bmarn\OneDrive\HTML\reling it` | Remote ist die alte Adresse `bmarnau/relingit`; Branch `codex/fix-admin-password-recovery` (b671d7c, Remote weg), kein Stash; geändert: README.md, styles.css, datenschutz.html, index.html, build-upload.ps1, ci-check.ps1; nicht versioniert: `assets/audio/`, Podcast-Cover | Laut STATUS.yaml sind Bundle und zwei Patches gesichert (README.md, styles.css, index.html, build-upload.ps1, ci-check.ps1). **`datenschutz.html` steht dort nicht.** Ob sie gesichert ist: unklar. Vor dem Wegfall klären. |
| 7 | Papierkorb | 28 Einträge. Fast alle stammen aus dem OneDrive-Klon (`archive/ftp-packages/2026090*`, `archive/_aufgeraeumt-2026-11-06/...`, `output/image/flyer-*`). Dazu `C:\dev\referenz` und eine Word-AutoWiederherstellen-Datei. Die Größe der Ordnerinhalte wurde nicht ermittelt; Dateien zusammen 1,3 MB. (`Shell.Application`, Namespace 10) | Leeren entscheidet der Product Owner. Die Word-Datei gehört nicht zum Projekt und sollte vorher angesehen werden. |

Befehle: `git worktree list`, `git -C <pfad> status --porcelain [--ignored]`, `git -C <pfad> rev-list --count HEAD --not origin/main`, `git diff --stat a39d2a1 907ca58`, `git -C <klon> --no-optional-locks status --porcelain`, Papierkorb über `Shell.Application`.
