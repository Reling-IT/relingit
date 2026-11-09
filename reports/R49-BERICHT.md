---
id: R49
titel: Aufbewahrungsregel für archive/ftp-packages (nur melden, nichts löschen)
status: erledigt (Draft-PR offen, CI grün, nicht gemergt)
datum: 2026-11-09
branch: auftrag-R49-aufbewahrung
pr: https://github.com/Reling-IT/relingit/pull/28
commit: 5e67269
ci: grün (Website prüfen, Lauf 42564106890)
---

## Ergebnis
Erledigt. `publish-release.ps1` meldet nach dem Verschieben alter Pakete, welche Pakete in `archive/ftp-packages` älter als die letzten drei und nicht geschützt sind. Das Skript löscht, verschiebt und ändert nichts im Archiv. Die Regel steht in `docs/ABLAUF.md`, Abschnitt 3. Merge erst nach Veröffentlichung v1.38 und Freigabe durch Bernd.

## Regel
- Die letzten drei Pakete bleiben immer. Maßgeblich ist der Zeitstempel im Ordnernamen (`yyyyMMdd-HHmmss-fff`), nicht das Änderungsdatum. Geschützte Pakete zählen bei den drei mit.
- Ältere Pakete werden nur gemeldet. Löschen geht nur nach Freigabe durch Bernd je Paket, als eigener Auftrag nach dem Verfahren aus R45/R48.
- **Geschützt** heißt: Im Paketordner liegt eine Datei `GESCHUETZT.txt`. Das Skript prüft nur, ob sie existiert (`[System.IO.File]::Exists`), und liest den Inhalt nie. Geschützte Pakete werden nie gemeldet.
- Begründung für die Markierungsdatei statt einer Liste:
  - Der Schutz liegt beim Paket und bleibt beim Verschieben oder Wiederherstellen erhalten.
  - Es gibt keine getrennte Liste, die veralten kann.
  - Die Prüfung braucht keinen Dateiinhalt, also werden keine OneDrive-Platzhalter hydriert.
  - Schutz setzen oder aufheben heißt nur: Datei anlegen oder entfernen.
- Beispiel: Für `20260905-193924-327` legt Bernd einmalig eine Markierung an. Der Befehl steht in ABLAUF.md: `Set-Content -LiteralPath "archive/ftp-packages/20260905-193924-327/GESCHUETZT.txt" -Value "…"`.
- Ordnernamen ohne gültigen Zeitstempel zählen nicht als Paket und erscheinen nur als Hinweis. Fehlt `archive/ftp-packages`, meldet das Skript „Ordner fehlt, nichts zu melden“, ohne Fehler.
- Das Skript liest nur direkte Unterordner (`Directory.EnumerateDirectories`). Es arbeitet nicht rekursiv und berechnet keine Größen.

## Änderungen
| Datei | Inhalt |
|---|---|
| scripts/publish-release.ps1 | Neue Funktionen `Get-FtpPaketAufbewahrung` (Bewertung, liefert Pakete, Behalten, Geschuetzt, Melden, Unbekannt, OrdnerFehlt) und `Write-FtpPaketAufbewahrung` (Ausgabe). Aufruf direkt nach dem Verschiebe-Block, unabhängig davon, ob etwas verschoben wurde |
| tests/publish-release.Tests.ps1 | Neuer Describe-Block mit 6 Tests im TestDrive. Die Funktionen werden per AST aus dem Skript geladen, das Skript wird dafür nicht gestartet. Der bestehende Gegenprobe-Test prüft zusätzlich die Meldung „Ordner fehlt“ im echten Skriptlauf des Mini-Projekts |
| docs/ABLAUF.md | Abschnitt 3 mit Regel, Begründung, Beispiel und Belegtabelle; Diagrammknoten G ergänzt |

README.md wurde bewusst nicht geändert. Die passende Stelle grenzt an die Änderung aus #26.

## Prüfbelege (Worktree C:\dev\wt-r49, Commit 5e67269)
```
PS> git diff --check                       -> exit 0
PS> ./scripts/ci-check.ps1
Hinweis: 4 von 4 Podcast-MP3 liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). ...
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
ci-check exit 0
PS> node --check assets/js/app.js | admin.js | pdf-viewer.js | story-viewer.js | supabase-config.js   -> je exit 0
PS> Invoke-Pester -Path tests -PassThru -Quiet      (Pester 3.4.0 unter pwsh 7)
Passed 27 Failed 0 Skipped 0 Total 27
Passed  meldet nur Pakete älter als die letzten drei, sortiert nach dem Namen, nicht nach dem Änderungsdatum
Passed  meldet ein geschütztes Paket (GESCHUETZT.txt) nie, auch wenn es älter ist
Passed  verändert das Archiv nicht (kein Löschen, kein Verschieben, keine neue Datei)
Passed  meldet nichts bei drei oder weniger Paketen und ignoriert fremde Namen und Dateien
Passed  leerer Ordner: kein Fehler, nichts zu melden
Passed  fehlender Ordner archive/ftp-packages: kein Fehler, kein Ordner wird angelegt
PS> git diff origin/main HEAD | grep -cE '<CI-Suchmuster>'   -> 0
gh pr checks 28 -> Website prüfen: pass (Lauf 42564106890)
```
Hinweis: Nach dem Pester-Lauf steht `$LASTEXITCODE` der Shell auf 1. Ursache sind die Mini-Skripte, die in den Tests absichtlich abbrechen. Pester selbst meldet 0 Fehler.

Konfliktprüfung mit `git merge-tree --write-tree <branch> HEAD`:
- `origin/auftrag-R07-anhang-seite` (#26): Baum 005af4eb…, exit 0, kein Konflikt
- `origin/auftrag-R06-standards-box-v139` (#27): exit 0, kein Konflikt
- `origin/auftrag-R11-avatare-webseite` (#25): exit 0, kein Konflikt

#26 ändert andere Stellen in publish-release.ps1 (Schleife lesen/anhang, `$otherPublicPaths`).

## PR
https://github.com/Reling-IT/relingit/pull/28 (Draft, Basis main, CI grün)

## Abweichungen
- Der Bericht ist nicht committet und liegt nur im Scratchpad, wie im Auftrag verlangt. Er gehört nicht nach reports/ auf ops/reports.
- Der Pester-Lauf wurde versehentlich zweimal hintereinander gestartet (in einem Befehl). Das Ergebnis ändert sich dadurch nicht.
- `publish-release.ps1` lief nicht gegen echte Ordner. Am OneDrive-Archiv wurde nichts gemacht, auch nicht gelesen.

## Zusatz: Inventur archive\ftp-packages\20260905-195306-580 (nur lesend, Koordinator)

Stand: 2026-11-09, 05:38 bis 05:42 (Ortszeit). Auftrag Bernd 09.11.2026 als Zusatz zu R49. Nichts verschoben, nichts gelöscht, nichts hydriert. Das Bundle aus R47 bleibt nur im OneDrive-Ordner, es wurde keine zweite Kopie angelegt. Für die Gegenprobe wurde es nur in einen Wegwerf-Ordner im Scratchpad geklont, der danach wieder entfernt wurde.

### Steckbrief

| Feld | Wert |
|---|---|
| Pfad | `C:\Users\bmarn\OneDrive\HTML\reling it\archive\ftp-packages\20260905-195306-580\` |
| Inhalt | `relingit-upload-v1.37-2026-09-05-viewer-fix\` (Ordner) und `relingit-upload-v1.37-2026-09-05-viewer-fix.zip`; v1.37 mit Fix der Kapitelnavigation im Viewer |
| Dateien | 25 (24 im Paketordner plus ZIP) |
| Größe | 6 561 975 Byte (6,26 MiB) |
| Datum | Ordner 2026-09-05 19:55; neueste Datei 2026-09-05 19:39 |
| Cloud-Platzhalter | 0 von 25 (Prüfung `Attributes -band (0x400000 -bor 0x40000 -bor 0x1000)`), Links 0 |
| Ordner-Hash (Methode R45/R48: `Sort-Object FullName`, `<SHA-256>  <relativer Pfad>`, LF ohne Schluss-LF, UTF-8) | `D80F6E06D3C4EEAC3E87E07C89E8B1A32E0A5F00FDE39B1D996B4DE79E106618` |
| SHA-256 ZIP | `86ec5bee930025f40675398bd2a3f5ab5abc64e0d3144597ee7bb86f766568df` |

### Git-Abdeckung
Je Datei `git hash-object --no-filters` und ohne CR (beides ohne `-w`), dann `git cat-file -e`. UPLOAD-MANIFEST.txt ausgenommen.
- In `C:\dev\relingit`: 21 von 23 Dateien.
- Nicht in `C:\dev\relingit`: `admin.html`, `assets/js/admin.js`. Beide liegen im OneDrive-Klon (Commit c8044f4 „Complete robust MFA enrollment flow“, 2026-09-05 12:34). c8044f4 ist Vorfahre von `codex/fix-admin-password-recovery`; die Gegenprobe im geklonten Bundle aus R47 ergibt für beide: im Bundle ja.
- Damit ist der gesamte Inhalt (bis auf das Manifest) in Git oder im Bundle gesichert.

### Vergleich mit dem geschützten Paket 20260905-193924-327 (v1.37 korrekturen)
`diff -rq`: Es weichen nur `assets/js/story-viewer.js`, `lesen.html` und `UPLOAD-MANIFEST.txt` ab. Das passt zum Klon-Commit 1cd7fa9 „Fix story viewer chapter navigation“ (2026-09-05 19:39). 195306-580 ist also der spätere Stand, und zwar der letzte v1.37-Stand vor v1.38.

### Referenzen
- `git grep -E "20260905-195306-580|viewer-fix"` in HEAD, origin/main, origin/ops/queue und allen Auftragsbranches (R06, R07, R11): 0 Treffer.
- origin/ops/reports: `reports/R13-LISTE.md` Z. 153 und 199 („neueste zwei in archive\ftp-packages“, geschützt) und `reports/R48-BERICHT.md` Z. 32.
- Projektdokumente im OneDrive-Ordner (*.md, *.ps1, *.yaml, *.txt außerhalb von ftp-packages): 0 Treffer.
- Schutzregel queue/R13.yaml Z. 12: „Nie löschen: die jeweils neuesten zwei Pakete in output\ftp und archive\ftp-packages“.

### Vorlage an Bernd

| Paket | Empfehlung | Begründung |
|---|---|---|
| 20260905-195306-580 (v1.37 viewer-fix) | **Behalten** | Neuestes Paket im Archiv und nach der R13-Schutzregel geschützt. Es ist der letzte v1.37-Stand, der live war, also die Rückfallebene, bis v1.38 hochgeladen und geprüft ist (R09). Nach der neuen R49-Regel („letzte drei behalten“) gehört es ohnehin zu den drei behaltenen. |

Später möglich: Sobald v1.38 live geprüft ist, ist der Inhalt vollständig durch Git (C:\dev\relingit) und das Bundle (R47) gedeckt. Dann löst die Schutzregel es durch neuere Pakete ab; gelöscht würde es auch dann nur nach Freigabe durch Bernd. Nichts verschoben oder gelöscht.

Nebenbefund: queue/R13.yaml (Z. 29) schützt auch die uncommitteten Änderungen im OneDrive-Klon (u. a. styles.css, README.md), „solange R34 nicht gemergt und R35 nicht entschieden ist“. R34 und R35 sind erledigt. Die zwei Änderungen aus R47 sind also nicht mehr formal geschützt, aber auch nicht im Bundle. Entscheidung bei Bernd (siehe R47).

## Vorschläge und Ideen (Claude)
- `GESCHUETZT.txt` in `20260905-193924-327` anlegen. Das ist ein Handgriff für Bernd, eine Zeile, und kann vor dem Merge geschehen. Ohne die Datei meldet das Skript das Paket, sobald es nicht mehr zu den letzten drei gehört. Löschen würde es trotzdem nicht.
- Bis zur Entscheidung zu R47 L25 (`20260905-192045-642`) ebenfalls markieren. Beim nächsten Release wäre es sonst das älteste Paket und würde gemeldet.
- In `archive/README.md` einen Satz mit Verweis auf ABLAUF.md Abschnitt 3 ergänzen, als kleinen Folgeauftrag nach dem Merge von #26.
- Sollen Pester-Tests später in CI laufen, als Kriterium `FailedCount` des `-PassThru`-Ergebnisses nehmen, nicht `$LASTEXITCODE`.
- Ein späterer Aufräumauftrag kann `Get-FtpPaketAufbewahrung` per AST wiederverwenden (wie vorschau.ps1 `$publicFiles`). Dann melden und löschen dieselbe Liste.

Hygiene: gemergte Remote-Branches außer main: keine; offene PRs: Drafts #25, #26, #27 und neu #28; nichts gemergt, getaggt, gelöscht oder hochgeladen, Worktree C:\dev\wt-r49 bleibt stehen.

```yaml
Reifegrad: R49 umgesetzt als Draft-PR #28; Regel dokumentiert, 6 neue Tests grün, CI grün
Projektstatus: Aufbewahrungsmeldung bereit; wirksam nach Merge (nach v1.38 und Freigabe Bernd); Schutzmarkierung im echten Archiv noch nicht gesetzt
Offene_Fragen:
  - Legt Bernd GESCHUETZT.txt in 20260905-193924-327 an (und vorläufig in 20260905-192045-642 bis R47)?
  - Sollen geschützte Pakete bei den letzten drei mitzählen (so umgesetzt) oder zusätzlich zu drei ungeschützten bleiben?
  - Verweis in archive/README.md als Folgeauftrag nach #26?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schätzung
```
