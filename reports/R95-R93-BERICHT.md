# R95 und R93: Bericht 27.11.2026

Auftrag des Product Owners im Chat am 27.11.2026, Warteschlange `ops/queue` 2ca795d oder neuer. Ausgeführt von Claude Code (Opus) im Arbeitsklon `C:\dev\relingit`. Nichts gemergt, nichts getaggt, nichts hochgeladen, nichts endgültig gelöscht. Stunden trägt der Product Owner ein.

Vorab: Arbeitsklon per Fast-Forward von 9b61ab4 auf `origin/main` 0a158a8 (27.11.2026 vor 05:35, `git merge --ff-only`).

## R95 Workshop-Feedback-Vorlage

| Punkt | Ergebnis | Beleg |
|---|---|---|
| PR-Grenze | Platz: 0 offene PRs in relingit vor dem Start | `gh pr list --state open` (27.11., vor 05:35) |
| Vorlage | `docs/WORKSHOP-FEEDBACK.md`, eine Seite: Regeln, Felder (Datum, Wer als Rolle, Fundstelle, Beobachtung, Art, Vorschlag, Queue-Verweis), Sammeltabelle, Ablauf nach dem Workshop | PR #48, Commit c8d77a1 |
| Verweis | `README.md`, Abschnitt Projektstruktur, Zeile `docs`; `docs/PILOT.md` hat keinen passenden Abschnitt, dort nichts geändert | PR #48 |
| Prüfung | `scripts/ci-check.ps1` lokal Exit 0; CI „Website prüfen“ pass | Lauf 45940826562 |
| PR | #48, Entwurf, Head c8d77a187cb873b97491056f9ba050769e6fe61d, mergeStateStatus CLEAN (05:38) | https://github.com/Reling-IT/relingit/pull/48 |

Abweichung: R95 nennt als Quelle der Regel „R70/12.11.“. Die Entscheidung vom 12.11.2026 (sammeln und parken, nur Muss-Fehler sofort) steht in `queue/R72.yaml`; die Vorlage verweist darauf. Eine unabhängige Zweitprüfung steht vor einem Merge noch aus.

## R93 Lokal aufräumen

| Teil laut `queue/R93.yaml` | Vorgefunden am 27.11. | Beleg |
|---|---|---|
| Worktree `pilot-2311` entfernen | schon entfernt | `git worktree list` (Tagesstart 27.11.) |
| Zwölf Ordner `relingit-vorschau-*` im Temp-Ordner | keiner vorhanden; im Papierkorb unter diesem Namen keiner. Wie und wann sie entfernt wurden: unklar | `ls %LOCALAPPDATA%\Temp\relingit-vorschau-*`: 0; Papierkorb gelesen |
| Verwaiste Trailer-Vorschau in der lokalen Startkonfiguration | keine `launch.json` im Arbeitsklon oder in den Worktrees gefunden; im Papierkorb liegt `relingit-trailer` aus `C:\tmp`, gelöscht am 25.11.2026 05:51. Ob das der gemeinte Eintrag war: unklar | `find … -name launch.json`; Papierkorb gelesen |
| FTP-Pakete 1.38 und 1.39 ins lokale Archiv | nicht mehr in `output/ftp`; sie liegen im Papierkorb (Ursprung `C:\dev\relingit\output\ftp`, gelöscht am 25.11.2026 05:56), nicht im Archiv. Prüfsummen vorher/nachher liegen nicht vor | Papierkorb gelesen; `ls output/ftp`: nur v1.40 (mit und ohne Audio) |

Die drei Teile waren damit vor dieser Sitzung ausgeführt, durch wen ist hier nicht belegt. Abweichung zu R93: die FTP-Pakete gingen in den Papierkorb statt ins Archiv. Papierkorb-Inhalt nicht angefasst (Grenze). Nicht angefasst: Worktree `paket-v139`, Upload-Paket 1.40, Podcast-MP3 in der OneDrive-Ablage, `archive/_gesichert-2026-11-23`.

### Worktrees und lokale Branches nach dem Merge

Vorab geprüft mit `scripts/aufraeumen-pruefen.ps1` (nur lesend): beide Worktrees sauber, keine ignorierten Dateien, kein Stash, Inhalt squash-gleich in `origin/main`, Remote-Branch gelöscht.

| Objekt | Aktion | Beleg |
|---|---|---|
| Worktree `r87-teil2` | in den Papierkorb verschoben (27.11.2026 05:38), danach `git worktree prune` | 120 Dateien, SHA-256 der Dateiliste EEE36EA0…2ED0 |
| Worktree `r92-backup` | in den Papierkorb verschoben (27.11.2026 05:38), danach `git worktree prune` | 117 Dateien, SHA-256 der Dateiliste DBC9E003…2E32 |
| Branch `auftrag-R87-teil2` | belassen (12397da) | `git branch -vv` |
| Branch `auftrag-R92-backup` | belassen (705a482) | `git branch -vv` |
| Branch `pilot-2026-11-23` | belassen (cd6fb73) | `git branch -vv` |

Die Branches bleiben als Rückfall, bis der Product Owner das Löschen einzeln freigibt: Ein Branch lässt sich nicht in den Papierkorb legen. Mit ihnen lassen sich die Worktrees jederzeit neu anlegen.

## Offene PRs aus KI-Sitzungen

relingit: 1 (#48, Entwurf).

## Vorschläge und Ideen (Claude)

- Freigabe zum Löschen der drei lokalen Branches (`git branch -D`, SHAs oben); Empfehlung: ja, alle drei sind squash-gleich in `main`.
- R93 in der Warteschlange auf erledigt setzen, mit dem Vermerk, dass die FTP-Pakete 1.38 und 1.39 im Papierkorb liegen; ob sie ins Archiv sollen, entscheidet der Product Owner.
- Zweitprüfung von #48 vor einem Merge durch einen Unteragenten mit eigenem Kontext.

## Nachtrag 27.11.2026: Branches gelöscht

Freigabe des Product Owners im Chat am 27.11.2026. Ausgeführt mit `git branch -D`:

| Branch | SHA vorher |
|---|---|
| `auftrag-R87-teil2` | 12397da |
| `auftrag-R92-backup` | 705a482 |
| `pilot-2026-11-23` | cd6fb73 |

Danach lokal nur noch `main`, `ops/queue`, `ops/reports`, `paket-v139` und `auftrag-R95-feedback` (#48). Beleg: `git branch -vv`.
