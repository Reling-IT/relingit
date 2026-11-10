# R56 – scripts/aufraeumen-pruefen.ps1: Worktrees und Branches nur lesend als Tabelle

Stand: 2026-11-10, 06:16 bis 06:44 (Ortszeit, mit `date` geprüft). Ausgeführt von Claude Code (Agent) im Worktree `C:/dev/wt-r56` auf dem Branch `auftrag-R56-aufraeumen-pruefen`, abgezweigt von origin/main 8abe213.

## Ergebnis
Erledigt. Draft-PR Reling-IT/relingit#32, Head `35c2d4407845e5bdf36fc2ce16baec3d7c89b490` (signiert, `%G?` = G). Die CI „Website CI / Website prüfen“ ist grün: Run 42763870110 (https://github.com/Reling-IT/relingit/actions/runs/42763870110), conclusion success, headSha 35c2d44.

Geänderte Dateien:
- `scripts/aufraeumen-pruefen.ps1`: neues Skript mit Kopfkommentar in den ersten zehn Zeilen (Block `<# … #>`)
- `tests/aufraeumen-pruefen.Tests.ps1`: neue Pester-Tests
- `docs/ABLAUF.md`: eigener Abschnitt „Aufräumen prüfen: Worktrees und Branches (scripts/aufraeumen-pruefen.ps1)“, direkt vor der Belegtabelle. Er ist unnummeriert, damit er nicht mit der Nummerierung aus R55 kollidiert. Das Mermaid-Diagramm ist absichtlich unverändert.
- `README.md`: drei Verweise (scripts-Zeile, tests-Zeile, Satz zu den Pester-Tests)

## Prüflogik
Die Prüfungen stammen aus reports/R44-BERICHT.md.

| Spalte | Prüfung |
|---|---|
| Name, Pfad | `git worktree list --porcelain` (Branch, losgelöst, gesperrt, prunable) und `git for-each-ref refs/heads` mit Upstream und Abstand |
| sauber | `git status --porcelain` ohne Ausgabe ergibt „ja“, sonst „nein (n)“. Fehlt das Verzeichnis, steht dort „fehlt“ mit dem Hinweis auf `git worktree prune`. |
| ignorierte Dateien | `git status --porcelain --ignored`, Zeilen mit `!!`, höchstens vier, danach „+n weitere“. Diese Dateien löscht `git worktree remove` mit (siehe wt-r50). |
| in origin/main | „ja“: `git merge-base --is-ancestor <sha> origin/main`. „Squash-gleich“: `git diff --quiet <sha> origin/main` (Inhalt identisch, wie in R44), oder die Patch-ID des Gesamtdiffs seit der Merge-Basis (`git patch-id --stable`) gehört zu einem Commit in `mb..origin/main`. Das erkennt einen Squash auch dann, wenn main danach weitergegangen ist. „nein“: mit der Anzahl eigener Commits und `git diff --shortstat`. |
| Remote | Upstream mit Abstand (zum Beispiel „behind 2“), „gelöscht“ bei `[gone]` |
| Empfehlung | Nur Text. Arbeitsklon und geschützte Branches (main, ops/queue, ops/reports) bleiben stehen, ebenso Worktrees mit Änderungen und Branches, deren Inhalt nicht in main ist. Bei „gleich Basis, keine eigenen Commits“ lautet die Empfehlung „neu oder aktiv?, erst nach Abschluss des Auftrags entfernen“. Bei ignorierten Dateien: erst sichern. Sonst: `git worktree remove` bzw. `git branch -d` (Vorfahre) oder `git branch -D` (Squash). Bei losgelösten Worktrees steht zusätzlich, in welchem Ref der Stand enthalten ist (`for-each-ref --contains`). |

Zum nur lesenden Zugriff:
- Das Skript setzt `GIT_OPTIONAL_LOCKS=0` und ruft Git immer mit `--no-optional-locks` auf.
- Erlaubt sind nur diese Git-Befehle: worktree list, status, for-each-ref, merge-base, diff, rev-parse, rev-list, log, cat-file und patch-id.
- `git fetch --prune origin` läuft nur mit dem Schalter `-Fetch`.
- `git merge-tree --write-tree` aus R44 wird bewusst nicht verwendet, weil es Objekte schreibt.
- Weitere Schalter: `-Markdown` (Tabelle für Berichte), `-Basis` (anderer Vergleichsstand), `-Geschuetzt` (Liste geschützter Branches).

## Probelauf im echten Arbeitsklon
Aufruf: `pwsh -NoProfile -File C:/dev/wt-r56/scripts/aufraeumen-pruefen.ps1 -Projekt C:/dev/relingit -Markdown`, Exit 0. Danach meldete `git status --porcelain` im Arbeitsklon 0 Zeilen; es wurde nichts verändert. Stand 06:2x, R55 hatte zu diesem Zeitpunkt noch keinen Commit.

Aufräumen prüfen (nur lesend): C:\dev\relingit
Basis: origin/main 8abe213; 6 Worktrees, 11 lokale Branches

| Name | Pfad | sauber | ignorierte Dateien | in origin/main | Remote | Empfehlung |
|---|---|---|---|---|---|---|
| main | C:/dev/relingit | ja | archive/ftp-packages/, output/, reports/ | ja | origin/main | Arbeitsklon, belassen |
| auftrag-R06-standards-box-v139 | C:/dev/wt-r06 | ja | output/, reports/ | nein (3 eigene Commits; 7 files changed, 111 insertions(+), 15 deletions(-)) | origin/auftrag-R06-standards-box-v139 | belassen: Inhalt nicht in origin/main |
| auftrag-R54-g6-ohne-audio | C:/dev/wt-r54 | ja | – | ja | origin/main | keine eigenen Commits (neu oder aktiv?); erst nach Abschluss des Auftrags entfernen |
| auftrag-R55-ordner-hash | C:/dev/wt-r55 | nein (2) | – | ja | origin/main | belassen: ungesicherte Änderungen |
| auftrag-R56-aufraeumen-pruefen | C:/dev/wt-r56 | nein (1) | – | ja | origin/main | belassen: ungesicherte Änderungen |
| (losgelöst 9903d61) | C:/Users/…/scratchpad/rep | ja | – | nein (keine gemeinsame Basis) | – | belassen: Inhalt nicht in origin/main; Stand enthalten in origin/ops/reports |
| auftrag-R07-anhang-seite | – | – | – | nein (3 eigene Commits; 20 files changed, 362 insertions(+), 16 deletions(-)) | origin/auftrag-R07-anhang-seite | belassen: Inhalt nicht in origin/main |
| auftrag-R11-avatare-webseite | – | – | – | nein (3 eigene Commits; 4 files changed, 24 insertions(+), 10 deletions(-)) | origin/auftrag-R11-avatare-webseite | belassen: Inhalt nicht in origin/main |
| auftrag-R49-aufbewahrung | – | – | – | nein (3 eigene Commits; 3 files changed, 237 insertions(+), 1 deletion(-)) | origin/auftrag-R49-aufbewahrung | belassen: Inhalt nicht in origin/main |
| auftrag-R50-kleines-systemhaus | – | – | – | ja | origin/auftrag-R50-kleines-systemhaus gelöscht | löschbar: git branch -d auftrag-R50-kleines-systemhaus |
| ops/queue | – | – | – | nein (keine gemeinsame Basis) | origin/ops/queue behind 2 | geschützter Branch, belassen; lokal veraltet (behind 2) |
| ops/reports | – | – | – | nein (keine gemeinsame Basis) | origin/ops/reports behind 5 | geschützter Branch, belassen; lokal veraltet (behind 5) |

Hinweis: Das Skript hat nichts gelöscht, nichts gepusht und keine Refs geändert. Ignorierte Dateien löscht 'git worktree remove' mit.

Auswertung:
- auftrag-R50-kleines-systemhaus wird wie erwartet als „ja“ (Merge-Commit in main) und „löschbar mit -d“ erkannt; der Remote-Branch ist bereits gelöscht.
- Der Arbeitsklon und wt-r06 enthalten ignorierte Dateien (output/, reports/, bei main zusätzlich archive/ftp-packages/). Vor einem `git worktree remove` von wt-r06 müssen diese gesichert werden.
- Ein zweiter Lauf um 06:4x in Tabellenform zeigte den laufenden Stand: R55 jetzt mit 1 eigenem Commit und „belassen: Inhalt nicht in origin/main“, R54 mit Änderungen, ein zusätzlicher losgelöster Scratchpad-Worktree (Stand in origin/ops/queue), ops/queue behind 3, ops/reports behind 6.

## Tests
- Neue Datei `tests/aufraeumen-pruefen.Tests.ps1`. Das Wegwerf-Repository in `$TestDrive` hat ein Bare-origin und `commit.gpgsign false` nur lokal. Es enthält die Branches gemergt, gemergt2 (Merge-Commit), squash (zwei Commits, Squash in main, danach ein weiterer main-Commit), inhalt (kein Vorfahre, gleicher Baum), offen und neu (gleich Basis). Dazu kommen vier Worktrees: gemergt sauber mit ignorierter `output/paket.zip`, offen mit unversionierter Datei, neu sowie losgelöst.
- Die sechs Tests prüfen: Kopfzeilen und Spalten; Vorfahre, Squash per patch-id, identischen Inhalt; Worktree-Zustand mit ignorierten Dateien und Empfehlungen; unveränderte Refs, `worktree list`, `count-objects`, `status --ignored` je Worktree, Zeitstempel aller Index-Dateien und die ignorierte Datei; keine schreibenden `& git`-Aufrufe im Skripttext; einen verständlichen Abbruch bei fehlender Basis.
- `Invoke-Pester -Path tests -PassThru -Quiet` (Pester 3.4.0, pwsh 7.6): Total 27, Passed 27, Failed 0, Skipped 0. Davon sind 6 neu.
- `pwsh -NoProfile -File scripts/ci-check.ps1`: Exit 0, „OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.“ Hinweis: 4 von 4 Podcast-MP3 liegen lokal nicht vor (erwartet).
- `git diff --cached --check` vor dem Commit: ohne Befund.
- CI: Run 42763870110, „Website prüfen“ pass (11 s), headSha 35c2d44.

## Abweichungen
- Die Prüfung mit `git merge-tree --write-tree` aus R44 ist nicht übernommen, weil sie Objekte schreibt. Ersatz ist die patch-id-Prüfung, die nur liest.
- README wurde zusätzlich zu docs/ABLAUF.md angepasst, damit die Skript- und Testlisten vollständig bleiben. Bei einem Merge mit R55 kann es dort und in ABLAUF.md zu kleinen Textkonflikten kommen; mein Abschnitt in ABLAUF.md ist eigenständig.
- Nicht erkannt wird ein Squash, bei dem in main nachträglich Konflikte aufgelöst oder Zusatzänderungen gemacht wurden. Solche Branches erscheinen als „nein“ mit diff-Statistik und bleiben deshalb stehen; das ist die sichere Seite.

## Vorschläge und Ideen (Claude)
- Das Skript im Tagesabschluss (Skill tagesabschluss-reling-it, Teil „Git aufräumen“) als ersten Schritt aufrufen und die Markdown-Tabelle ins Tagesprotokoll übernehmen. Dabei steht kein Pfad aus dem Temp-Ordner im öffentlichen Repository, denn die Pfade werden nur ausgegeben.
- Einen Schalter `-OhnePfade` oder eine Kürzung auf `…\scratchpad\…` ergänzen, damit Probeläufe in öffentlichen Berichten keine Benutzerpfade zeigen (TP-09).
- „Automatically delete head branches“ ist auf GitHub bereits aktiv (`delete_branch_on_merge` = true, geprüft vom Koordinator am 10.11.); die Remote-Spalte zeigt deshalb nach jedem Merge „gelöscht“.
- ops/queue und ops/reports lokal per `git fetch origin ops/queue:ops/queue ops/reports:ops/reports` aktuell halten oder lokal löschen; das Skript meldet sie als „lokal veraltet“.
- Optional könnte freigabe-pruefen.ps1 (G7) die Aufräumtabelle als Anhang ausgeben, damit Bernd vor einem Merge sieht, welche Worktrees ignorierte Upload-Pakete enthalten.

Hygiene: 0 gemergte Remote-Branches (R50 auf dem Remote bereits gelöscht, lokal noch vorhanden und als löschbar gemeldet); offene PRs: #25, #26, #27, #28, #30, #31, #32, alle Draft; nichts gemergt, kein Tag, kein FTP, keine Zugangsdaten, kein Force-Push.

```yaml
Reifegrad: Nur lesendes Aufräumwerkzeug mit Tests als Draft-PR #32, CI grün; Löschen bleibt Handarbeit
Projektstatus: main 8abe213 (v1.38 mit R50); sieben Draft-PRs offen (R06, R07/R46, R11, R49, R54, R55, R56); Upload v1.38 durch Bernd offen
Offene_Fragen:
  - Soll das Skript Teil des Tagesabschlusses werden, und sollen Benutzerpfade in öffentlichen Berichten gekürzt werden?
  - Lokalen Branch auftrag-R50-kleines-systemhaus jetzt mit git branch -d löschen (Freigabe Owner)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
