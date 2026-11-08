---
id: R16
titel: 'Release-Zweig v1.38: Avatare (#6) und Buchtext (#9) einbezogen, PDF und story/current erzeugt, CI grün'
status: erledigt
start: 2026-11-08T05:15+01:00
ende: 2026-11-08T06:10+01:00
branch: geschichte-veraltete-daten-20261107
pr: https://github.com/Reling-IT/relingit/pull/10
commit: ba5a23c
ci: 'lokal ci-check OK (Exit 0), Pester 8/8; GitHub: gh pr checks 10 meldet keine Checks (Basis nicht main), manueller Lauf workflow_dispatch 42447886785 grün auf ba5a23c'
---

## Ziel
Ein einziger Zweig (PR #10) soll Folgendes enthalten: Buchtext v1.38 (R03), die Geschichte „Die veralteten Daten“, die Korrekturen R26/R38, die Schriften R27, die Avatare aus PR #6, die PDF und die neu erzeugte `story/current`. Die CI soll grün sein. Danach kann #10 auf main umgestellt werden, und #6 und #9 werden geschlossen.

## Ergebnis
Alles ist erreicht. Der Zweig steht auf `ba5a23c` (vorher `b4bb44f`) und ist normal gepusht. Die PDF hat **77 Seiten**. `ci-check` läuft lokal grün, die GitHub-CI ist per manuellem Lauf grün.
Eine Abweichung vom Auftrag gibt es: eine kleine Änderung an `scripts/ci-check.ps1`. Sie war nötig, weil sich main und PR #6 inhaltlich widersprachen (siehe unten).
`verify_layout.py` konnte nicht laufen, weil numpy und pillow fehlen. Ich habe sie nicht installiert. Das Layout habe ich stattdessen per PNG von Hand geprüft.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Worktree | `C:\dev\wt-r16`. Der lokale Branch stand auf 813d0dc, 1 Commit hinter origin. Ich habe ihn per Fast-Forward auf b4bb44f gebracht, danach war er gleich origin | `git merge --ff-only`, `git status -sb` |
| Merge main | `c01a13b` (Merge-Commit, Eltern b4bb44f + 1281bbe), 1 Konflikt (s. u.) | `git log` |
| Merge PR #6 | `185d917` (Eltern c01a13b + 0fcd750), 6 Konflikte in der Buchquelle (s. u.). Die 7 Bilddateien unter `assets/img/avatare/` sind ohne Konflikt übernommen | `git log -1 --format=%p` |
| Icon-Umstellung | `788e882`, 2 Zeilen geändert (`.who`-SVG der zwei Navis-Blöcke in `kap-veraltete-daten`) | `git diff --stat`: 2+/2− |
| ci-check-Anpassung | `a35f500` (Abweichung, s. u.) | Regex-Test, Pester 8/8 |
| PDF + Release | `ba5a23c`: PDF, story/current (HTML+PDF), app.js, index.html, lesen.html | `cmp` source ↔ story/current: identisch |
| R03 (#9) enthalten | `auftrag-R03-buchtext-v138` ist kein direkter Vorfahr, weil der Branch dort zuletzt noch main eingemergt hat (d7d7e16). Inhaltlich ist er vollständig enthalten. Ein Probe-Merge per `git merge-tree` ergibt keine Änderung am Baum | `git diff --stat HEAD <merge-tree>`: leer |
| PR #6 enthalten | `git merge-base --is-ancestor origin/avatare-buch-und-seite-20261106 HEAD` → ja | – |

## Merges und Konfliktlösungen

### Merge origin/main → `scripts/build-upload.ps1` (Liste `$publicFiles`)
- **Stelle:** die Dateiliste des FTP-Pakets nach `assets/css/styles.css`.
- **Dieser Zweig (R27):** 11 Einträge `assets/fonts/*` (7 woff2, 3 OFL, HERKUNFT.txt).
- **main (R28):** 4 Einträge `assets/audio/*.mp3`, dazu (ohne Konflikt) `assets/img/reling-it-podcast-cover.png` und eine Prüfung auf fehlende Dateien.
- **Lösung:** beide Blöcke hintereinander übernommen, erst die Schriften, dann das Audio.
- **Grund:** Die Änderungen sind unabhängig voneinander, und beide Dateigruppen gehören ins Paket. Ohne die Schriften fehlen sie auf der Website, ohne Audio fehlt der Podcast.

### Merge PR #6 → `source/fahrt-zum-kunden.html` (6 Konflikte)
Alle sechs Konflikte sind gleich gelagert. Der Konfliktblock umfasst jeweils die Zeile `<span class="who">` (Bildmarke) und die Zeile `<span class="say">` (Sprechtext) desselben Blocks:
- PR #6 hat nur die Bildmarke geändert.
- Dieser Zweig hat nur den Sprechtext geändert (R26/R38).

Ich habe die Konflikte mit einem Skript Zeile für Zeile gelöst: `.who` aus PR #6, `.say` aus diesem Zweig. Das Skript bricht ab, wenn eine andere Art Zeile abweicht oder wenn der Sprechtext von PR #6 nicht wörtlich in der Merge-Basis 361f26c vorkommt. Beides trat nicht auf, es ging also kein Text von #6 verloren.

| Nr | Stelle (Kapitel, Zeile nach Merge) | dieser Zweig | PR #6 | gewählt | Grund |
|---|---|---|---|---|---|
| 1 | Navis meldet sich, 2 Navis-Blöcke (Z. 1055/1060) | Text R38 S17: „ein offenes Ticket: …“, ohne „41 Stunden“; alte Bildmarke | neue Bildmarke; Text wie Basis | Text hier + Bildmarke #6 | Lektorat freigegeben, #6 ändert keinen Text |
| 2 | Eine Frage an Lumen (Z. 1089) | „Ich habe **im Hub** das Angebot …“ (R38 S18) | neue Lumen-Marke | Text hier + Marke #6 | wie oben |
| 3 | Am Konferenztisch, Navis + Lumen (Z. 1240/1245) | Lumen: „Ergänzend aus der Report-Familie: Verfügbarkeit … 99,7 Prozent …“ (R26, Verfügbarkeit von Navis zu Lumen verschoben) | neue Marken; Text wie Basis | Text hier + Marken #6 | wie oben |
| 4 | Drucker, Lumen (Z. 1299) | „Im Servicehandbuch, **das im Hub liegt**, …“ (R38) | neue Lumen-Marke | Text hier + Marke #6 | wie oben |
| 5 | Brandt, Lumen (Z. 1322) | ß-Hausregel R38 („abschließend“) | neue Lumen-Marke | Text hier + Marke #6 | wie oben |
| 6 | Kaffeeecke, Lumen (Z. 1426) | „bei **fünf** davon …“ (R26, Rechnung) | „bei sechs davon“ (Basis) + neue Marke | Text hier + Marke #6 | R26 korrigiert die Rechnung |

Gegenprobe nach dem Merge: Der Diff zu c01a13b enthält nur 17 `.who`-Zeilen (der Teil nach dem SVG ist identisch: 10× „Navis“, 7× „Lumen“), die zwei Badges der Personenliste und drei CSS-Zeilen (`.avatar` 17→20 px, zwei `.has-img`-Regeln). Keine `.say`- oder Fließtextzeile ist geändert.

## Icon-Umstellung
Die zwei Navis-Blöcke in `kap-veraltete-daten` (Z. 1535 und 1542) trugen noch das alte SVG (`viewBox 0 0 24 24`, `#12292a`/`#4fd1c5`). Ich habe beide durch das identische SVG der übrigen Navis-Blöcke aus #6 ersetzt (`viewBox 0 0 64 64`, `#1d6f8c`, Stern `#f4c76f`). Das Skript prüft, dass genau diese zwei Treffer innerhalb des Kapitels liegen.
Danach gibt es 17 Avatare, alle im neuen Format (10 Navis, 7 Lumen), und kein altes Avatar-SVG mehr. Der Text ist unverändert.

## PDF-Werkzeuge mit Versionen
| Werkzeug | Version | Befehl / Herkunft |
|---|---|---|
| Python | 3.11.9 (`C:\Users\bmarn\AppData\Local\Programs\Python\Python311`) | vorhanden |
| venv | `C:\dev\venv-pdf` | `python -m venv --system-site-packages C:\dev\venv-pdf` (System-Pakete nur lesbar, damit vorhandenes pypdf/tzdata genutzt wird, ohne etwas zu installieren) |
| playwright | 1.64.1 (+ greenlet 3.5.6, pyee 13.0.1, nur in der venv) | `C:\dev\venv-pdf\Scripts\python.exe -m pip install playwright` |
| Chromium | Chrome for Testing 156.0.8078.4 (chromium v1248), Headless Shell 156.0.8078.4, FFmpeg v1013 | `C:\dev\venv-pdf\Scripts\python.exe -m playwright install chromium`; Ablage `%LOCALAPPDATA%\ms-playwright` (Standardort von Playwright, kein Systemeingriff; dort lagen schon v1228/v1234) |
| pypdf | 6.21.0 | System, vorhanden |
| tzdata | 2026.5 | System, vorhanden |
| Poppler | 25.07.0 (pdfinfo, pdftoppm, pdftotext, pdffonts) | vorhanden (winget) |
| numpy, pillow | **fehlen** | nicht installiert, nur gemeldet → `verify_layout.py` bricht mit Exit 2 ab („Python-Paket fehlt (numpy)“) |

Renderbefehl: `C:\dev\venv-pdf\Scripts\python.exe scripts/pdf/render_story_pdf.py --source source/fahrt-zum-kunden.html --out output/Die-Fahrt-zum-Kunden.pdf`
→ `OK -> C:\dev\wt-r16\output\Die-Fahrt-zum-Kunden.pdf | Seiten: 77 | Renderstand: 08.11.2026, 05:30 Uhr (MEZ)`

## Seitenzahl
- **77 Seiten** (A4, 595.92 × 842.88 pt), laut `pdfinfo`. Ein zweiter Renderlauf in den Scratchpad ergab ebenfalls 77.
- Vergleichswerte: Cloud-Probe 76, Windows-Vorversion 69, Edge-Probe aus R27 72 (Letter, nicht vergleichbar). Die Abweichung kommt von den echten Buchschriften (R27), den Textänderungen aus R26/R38 und den größeren Avataren (20 px).
- Deckblatt (PDF Seite 1, pdftotext): „07.11.2026 … Version 1.38“. Das passt zu `cover-meta` und zur letzten Historienzeile, publish-release meldet „OK: PDF-Deckblatt trägt Version 1.38“. Das Deckblatt selbst nennt keine Seitenzahl.
- Startseite: `index.html` `<span data-page-count>` 69 → 77, `app.js` fallbackRelease 1.37/5. September 2026/69 → 1.38/7. November 2026/77, `lesen.html` → „Version 1.38 · 7. November 2026“. ci-check bestätigt, dass diese Werte zusammenpassen.
- Schriften (`pdffonts`): IBMPlexMono (Regular/Medm/Italic), WorkSans (Regular/Bold/Italic) und Fraunces (als Type 3) sind eingebettet. ArialMT kommt nur in der Fußzeile vor, die das Render-Skript ausdrücklich mit `font-family:Arial` setzt. Keine Georgia, Segoe oder Consolas.

## Layoutbefund (PNG bei 60 dpi, Ausschnitte bei 130/200 dpi angesehen)
| Seite | Inhalt | Befund |
|---|---|---|
| 1 | Deckblatt | sauber; Version 1.38, Datum, Renderstand sichtbar |
| 2 | „Neu in v1.38“, Inhaltsverzeichnis | sauber, alle drei Gruppen, Link „Die veralteten Daten“ und „Datenstand“ vorhanden |
| 4 | Personenliste | Navis und Lumen zeigen die neuen runden Bildmarken, die übrigen das Kürzel; Raster intakt |
| 33–34 | Die veralteten Daten | Kapitel beginnt unter der Illustration des Vorkapitels. Beide Navis-Blöcke zeigen die neue Bildmarke, Kästen sind nicht angeschnitten, Fließtext läuft normal |
| 35 | Ankunft, noch einmal | Kapitelende, unteres Viertel frei (Schluss Teil 1, erwartbar) |
| 53–54 | Anhang-Box „Datenstand“ | Die Box läuft über zwei Seiten. Auf S. 53 ist das untere Drittel leer, weil der Kasten „Fehlerklasse“ geschlossen auf S. 54 springt. **Auffällig:** Die zwei Links (YouTube und „Zur Szene: Die veralteten Daten“) stehen in Browser-Standardblau auf dunklem Grund und haben zu wenig Kontrast. Es ist die einzige Box ohne eigene Linkfarbe. Nicht geändert (außerhalb des Auftrags) |
| 58 | Grafik Report-Familie | Grafikseite, unten frei (vorbestehendes Muster) |
| 63, 76, 77 | Versionshistorie | Tabelle sauber umbrochen, Kopfzeile wiederholt sich, die Zeile v1.38 ist vollständig; danach Schlussvermerk. Die Zeile v1.38 erwähnt die Avatare aus #6 nicht |

`verify_layout.py` (automatische Prüfung auf Rand, Luftzone, Fast-leer und Überschriften-Reihenfolge) lief **nicht**. Das muss nachgeholt werden, sobald numpy und pillow freigegeben sind.

## publish-release-Ausgabe
Vorher habe ich den Code gelesen. Das Skript kopiert und schreibt nur lokal, ruft ci-check und `build-upload.ps1` auf (ZIP unter `output/ftp`) und gibt am Ende nur eine Anleitung aus. Es gibt keinen FTP- oder Netzwerkaufruf.

1. Lauf: Version geprüft und Dateien kopiert, dann hat ci-check mit 2 Fehlern abgebrochen:
   „Personenliste, Eintrag 'Navis' (und 'Lumen'): Feld 'badge' fehlt oder ist leer“
   Ursache: Die Personenlisten-Prüfung aus main verlangt Text im Badge, PR #6 setzt dort ein `<img>`.
   → Korrektur in `a35f500` (s. Abweichungen).
2. Lauf (Exit 1, erwartet):
```text
OK: PDF-Deckblatt trägt Version 1.38 wie die HTML-Quelle.
Hinweis: 5 von 5 Podcast-Dateien liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). build-upload.ps1 baut ohne sie kein Paket.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
Exception: scripts/build-upload.ps1:67
  Paket abgebrochen, Dateien fehlen: assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3, assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3, assets/audio/warum-ki-nicht-lenken-darf.mp3, assets/audio/roman-als-ki-blaupause.mp3, assets/img/reling-it-podcast-cover.png. Podcast-Dateien aus der lokalen Ablage kopieren (siehe docs/PODCAST.md).
```
   Die Release-Werte sind gesetzt und `story/current` ist bytegleich zu `source`. Es ist kein FTP-Paket entstanden (`output/ftp` existiert nicht), und es wurde nichts hochgeladen. Die Übergabe-Ausgabe für den Admin-Bereich wird erst nach dem Paketbau gedruckt und fehlt deshalb. Die Werte für den Admin-Upload: Version 1.38, Datum 7. November 2026, Seitenzahl 77.

## ci-check-Ausgabe
`pwsh -NoProfile -File scripts/ci-check.ps1` (Exit 0):
```text
Hinweis: 5 von 5 Podcast-Dateien liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). build-upload.ps1 baut ohne sie kein Paket.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
```
Damit ist der bekannte Fehler „story/current weicht von source ab“ aus R27/R38 behoben.
Weitere Prüfungen:
- `git diff --check`: sauber.
- `Invoke-Pester -Path tests` (Pester 3.4.0): `Passed: 8 Failed: 0`, 129 s.
- Regex-Test der Badge-Regel: mit alt-Text → gültig; `alt=""`, ohne alt und leeres Badge → Fehler.

## CI
- `gh pr checks 10 --repo Reling-IT/relingit` → „no checks reported on the 'geschichte-veraltete-daten-20261107' branch“. Grund: Die Basis von #10 ist `auftrag-R03-buchtext-v138`, und `ci.yml` läuft bei `pull_request` nur auf `branches: [main]`. Die Basis habe ich nicht geändert.
- Ersatzbeleg: `gh workflow run ci.yml --ref geschichte-veraltete-daten-20261107`. Der Workflow hat dafür bereits `workflow_dispatch`, `ci.yml` ist unverändert. Lauf https://github.com/Reling-IT/relingit/actions/runs/42447886785, headSha `ba5a23c`: ✓ „Website prüfen“ in 12 s. Annotation: nur ein Hinweis zur Umstellung von ubuntu-latest.

## Commits
| Commit | Nachricht |
|---|---|
| c01a13b | R16: origin/main (1281bbe) in den Release-Zweig gemergt |
| 185d917 | R16: PR #6 (Avatare für Navis, Lumen, Ancora) in den Release-Zweig gemergt |
| 788e882 | R16: Bildmarke von PR #6 auch für die zwei Navis-Blöcke im Kapitel Die veralteten Daten |
| a35f500 | R16: ci-check akzeptiert Bildmarke im Badge der Personenliste |
| ba5a23c | R16: PDF v1.38 (77 Seiten) und story/current per publish-release erzeugt |

Alle Commits tragen Co-Authored-By und sind normal gepusht (`b4bb44f..ba5a23c`).

## PR-Kommentar
https://github.com/Reling-IT/relingit/pull/10#issuecomment-6717381343. Er enthält die Zusammenfassung und den Hinweis an Bernd: #10 auf main umstellen, #6 und #9 nach dem Merge schließen.

## Offene Fragen, Risiken, Abweichungen
- **Abweichung `scripts/ci-check.ps1`:** Main und PR #6 widersprechen sich inhaltlich. Die Personenlisten-Prüfung verlangt ein Text-Badge, #6 setzt ein Bild. Ohne Anpassung wäre die CI nach dem Merge rot. Ich habe die Prüfung minimal erweitert: Ein Bild mit nicht leerem `alt` zählt als gefüllt. Das ist keine Workflow-Datei, und die Pester-Tests sind grün. Bitte im Review bestätigen.
- **verify_layout.py nicht gelaufen:** numpy und pillow fehlen. Sie wurden nicht installiert, weil die Freigabe nur Playwright umfasst. Vorschlag: Bernd gibt `C:\dev\venv-pdf\Scripts\python.exe -m pip install numpy pillow` frei, dann `verify_layout.py --pdf output/Die-Fahrt-zum-Kunden.pdf --no-render`.
- **Seitenzahl 77 ≠ Cloud-Probe 76:** Die Ursache ist nicht im Einzelnen belegt. Vermutlich unterscheiden sich die Chromium-Version oder der Textstand (die Cloud-Probe war vor R38?). Für die Veröffentlichung gilt der Wert aus der eingecheckten PDF.
- **Paketbau:** `publish-release.ps1` endet lokal mit Exit 1, weil die Podcast-Dateien nicht im Repo und nicht in `C:\dev\relingit\assets\audio` liegen. Vor einem FTP-Upload müssen sie laut docs/PODCAST.md aus der Ablage kopiert werden. Danach `build-upload.ps1` erneut ausführen.
- **Versionshistorie v1.38:** Die neuen Bildmarken (#6) fehlen. Für den Nachtrag ist eine Textänderung nötig, die braucht Bernds Freigabe.
- **Box „Datenstand“:** Die Links sind kontrastschwach (Standardblau auf Dunkelblau). Das ist ein CSS-Thema und sollte vor dem Release noch behoben werden.
- **PDF nicht getaggt:** `render_story_pdf.py` setzt `tagged=True`, aber in der Ausgabe fehlen `StructTreeRoot` und `MarkInfo` (pypdf-Rootschlüssel: nur Names/Outlines/Pages/Type). Vermutlich verwirft sie der pypdf-Nachlauf (`writer.append`). Das gilt seit jeher, ist hier aber erstmals belegt.
- **R03-Branch:** Er ist kein direkter Vorfahr (Merge-Commit d7d7e16 fehlt), inhaltlich aber vollständig enthalten. #9 kann trotzdem geschlossen werden.
- **Chromium-Ablage:** `playwright install` legt Chromium im Benutzerprofil ab (`%LOCALAPPDATA%\ms-playwright`), nicht in der venv. Das ist der Standard von Playwright. Ich habe nichts systemweit installiert und keine Administratorrechte genutzt.

## Vorschläge und Ideen (Claude)
- In `render_story_pdf.py` `page.evaluate("document.fonts.ready")` statt fester 400 ms abwarten. Außerdem den pypdf-Nachlauf so umbauen, dass Tags erhalten bleiben (z. B. `PdfWriter(clone_from=reader)` statt `append`) und danach per pypdf prüfen, dass `/StructTreeRoot` vorhanden ist.
- `scripts/pdf/requirements.txt` mit Versionen pinnen (playwright==1.64.1 u. a.). Die Seitenzahl hängt an der Chromium-Version.
- Box „Datenstand“: eine Linkregel wie `.cover-toc a` setzen. Allgemein könnte ci-check prüfen, dass in `aside`/`.appendix` kein `<a>` ohne Klassenstil steht (schwer allgemein lösbar; alternativ eine globale Linkfarbe für dunkle Kästen).
- Eine ci-check-Regel ergänzen: Jeder `.voice .who` muss dasselbe SVG wie die anderen Blöcke derselben Figur tragen. Das hätte die zwei alten Navis-Icons automatisch gefunden.
- Die PR-CI zusätzlich für Basis-Branches `auftrag-*` freischalten oder Release-PRs grundsätzlich gegen main öffnen, damit `gh pr checks` ohne manuellen Lauf einen Beleg liefert (Workflow-Änderung, nur mit Freigabe).

Hygiene: Worktree `C:\dev\wt-r16` bleibt bestehen (Branch gepusht, Arbeitsbaum sauber; `output/` ist ignoriert und enthält die Render-PDF). Offene PRs: #6, #9 (Draft), #10 (Draft), #17, #18, #19. Remote-Branches, die in main gemergt sind und gelöscht werden könnten: auftrag-R35-podcast-sicherung, auftrag-R37-notebooklm, quelle-pdf-werkzeuge-20261106. Nichts gemergt, nichts geschlossen, kein Tag, kein FTP, keine Zugangsdaten, `.github/workflows` unverändert. Die venv `C:\dev\venv-pdf` liegt außerhalb des Repos.

```yaml
Reifegrad: "Release-Zweig v1.38 vollständig (Text, Geschichte, Schriften, Avatare, PDF 77 S., story/current); CI grün per workflow_dispatch; automatischer Layout-Check offen"
Projektstatus: "PR #10 (Draft, Basis auftrag-R03-buchtext-v138) bereit zum Umstellen auf main; #6 und #9 danach schließen"
Offene_Fragen:
  - "Freigabe numpy/pillow in C:\\dev\\venv-pdf für verify_layout.py?"
  - "ci-check-Erweiterung (Badge mit Bild) akzeptiert?"
  - "Versionshistorie v1.38 um die Bildmarken (#6) ergänzen?"
  - "Linkfarbe in der Box Datenstand vor Release korrigieren?"
  - "Podcast-Dateien für den FTP-Paketbau bereitstellen"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
