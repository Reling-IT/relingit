---
id: R63
titel: "Trockenlauf v1.39: Probe-Merge inkl. #33, Lesefassung und PDF in Wegwerf-Ordner (nur lesen)"
status: erledigt
start: 2026-11-11 06:49 +0100
ende: 2026-11-11 07:28 +0100
branch: keiner
quelle_queue: origin/ops/queue queue/R63.yaml
---

# R63-Bericht: Trockenlauf v1.39

Rolle: KI-Sitzung (Claude Code) auf dem Rechner des Product Owners. Es wurde nur gelesen. Kein Push, kein Merge, kein Tag, kein FTP und kein Upload. Es wurden keine Branches angelegt oder geändert. Alles lief in einem Wegwerf-Worktree (detached) im Scratchpad. Der Worktree ist entfernt.

## Ergebnis

- Der zusammengeführte Stand (Reihenfolge D aus R57 plus #34) ist am Ende grün: **ci-check Exit 0 und Pester 54/54** (failed=0, skipped=0, pending=0). Voraussetzung sind die drei bekannten Nachzüge: C1, story/current und der Konflikt in docs/ABLAUF.md.
- `publish-release.ps1 -OhneAudio` (aus #26) erledigt C1 und story/current in einem Lauf: Es kopiert die Buchquelle und die PDF nach story/current und setzt app.js, lesen.html, **anhang.html** und index.html. Der Lauf endete mit Exit 0.
- Seitenzahl v1.39: **80**, gleich in PDF (pdfinfo), story/current, app.js und Startseite. Sie ist auch gleich der PDF aus #27. Das Deckblatt nennt keine Seitenzahl.
- Paket `relingit-upload-v1.39-2026-11-09-ohne-audio.zip`: 4 683 423 Byte, 39 Einträge, SHA-256 `BB9E7170EA7B3414DC2C1FBDBD9245F8EFF8425F35B4B17A2291BB14858CF9A3`. `pruefe-paket.ps1` gegen v1.38 endete mit Exit 0 („OK, Paket gleich Manifest“). Davon 7 Dateien geändert, 3 neu, 28 unverändert, 0 entfallen.
- Die Zeile „(früher ADF)“ hat nachgerechnet 2,65:1 auf `--surface`. Vorschlag: `color:var(--ink-faint)` statt `opacity:.6`, das ergibt 4,56:1. Im Trockenlauf eingesetzt, die Seitenzahl bleibt 80.
- Der Arbeitsklon ist nachweislich unverändert. Die Hashes von output/, archive/ und reports/ sind vorher und nachher gleich (183 Dateien).

## Heads

Nach `git fetch --all` gegen `gh pr list` geprüft. Alle Heads stimmen mit dem Auftrag überein, und alle Branches setzen auf 8abe213 auf.

| PR | Branch | Head (gh = origin) | Merge-Basis |
|---|---|---|---|
| Basis | origin/main | 8abe213 | – |
| #25 | auftrag-R11-avatare-webseite | d1257f7 | 8abe213 |
| #28 | auftrag-R49-aufbewahrung | 81f8e48 | 8abe213 |
| #26 | auftrag-R07-anhang-seite | 2133502 | 8abe213 |
| #27 | auftrag-R06-standards-box-v139 | 8ea4c62 | 8abe213 |
| #33 | auftrag-R41-buchkontraste | ecfbebb | 8abe213 |
| #30 | auftrag-R55-ordner-hash | 586404f | 8abe213 |
| #31 | auftrag-R54-g6-ohne-audio | b2bc305 | 8abe213 |
| #32 | auftrag-R56-aufraeumen-pruefen | d6de9ee (neu, stabilisierter Test) | 8abe213 |
| #34 | auftrag-R62-pruefe-paket | 82ddf15 | 8abe213 |

## Merge-Schritte

Verfahren wie in R57:

- Für jeden Schritt kumulativ `git merge-tree --write-tree --name-only --merge-base=8abe213 <Baum> origin/<branch>`.
- Den Baum mit `git read-tree -u --reset` in den Worktree laden.
- Prüfen mit `pwsh -File scripts/ci-check.ps1` (ausgewertet: `$LASTEXITCODE`) und `Invoke-Pester -Path tests -PassThru` (lokal Pester 3.4.0).
- Es gab keine Commits, auch keine lokalen.
- Die Bäume D1, D2, D4 und D5 nach Nachzug sind hash-gleich mit R57 (c2fa03a, bc607c9, eb78625, 41fbac9).

| Schritt | PR | Baum | Konflikte | Nachzug | ci-check Exit | Pester |
|---|---|---|---|---|---|---|
| D0 | main | 575b282 | – | – | 0 | 21/21 |
| D1 | #25 | c2fa03a | keine | – | 0 | 21/21 |
| D2 | #28 | bc607c9 | keine | – | 0 | 28/28 |
| D3 | #26 | ff98fee | keine | – | 0 (12 HTML-Dateien) | 30/30 |
| D4 | #27 | eb78625 | keine (textlich) | C1 offen | **1**, genau 1 Fehler: „Versionsangabe in anhang.html weicht von lesen.html ab“ | 30/30 |
| D5 roh | #33 | 841c7af | keine (textlich) | C1 und story/current offen | **1**, genau 2 Fehler: C1 und „Veröffentlichungsfassung ist nicht aktuell: story/current/… weicht von source/… ab“ | nicht erneut gelaufen: tests/ und scripts/ sind gleich wie bei D4 |
| D5 + Nachzug | #33 | 41fbac9 | – | anhang.html auf „Version 1.39 · 9. November 2026“, source nach story/current kopiert (Probe) | 0 | – (siehe D6 ff.) |
| D6 | #30 | 6957c06 | keine | – | 0 | 35/35 |
| D7 | #31 | 9fe5567 | keine | – | 0 | 39/39 |
| D8 | #32 | 270d65d (nach Auflösung) | **docs/ABLAUF.md** | beide Abschnitte behalten, R55 vor R56 | 0 | 45/45 |
| D9 | #34 | c5a1d2b | keine (ABLAUF.md automatisch gemergt) | – | 0 | 54/54 |
| Ende | v1.39-Nachzug | c150d2e | – | ADF-Zeile, C2, PDF neu gerendert, `publish-release.ps1 -OhneAudio` | 0 | **54/54** |

Ein Pester-Lauf dauerte etwa 3 bis 4,5 Minuten, gemessen mit `date` (zum Beispiel D9 07:17:52 bis D-Ende 07:22:20). Der in R57 gemeldete instabile Test aus #32 ist in diesem Lauf in keinem Schritt aufgefallen. Das sind 3 Läufe mit #32 (D8, D9, Ende).

## Versionsstellen 1.39

„vorher“ ist der Stand auf main 8abe213, für anhang.html der Stand in #26. „nachher“ ist der Stand im Wegwerf-Ordner nach dem Lauf.

| Datei | Stelle | vorher | nachher | gesetzt durch |
|---|---|---|---|---|
| source/fahrt-zum-kunden.html | `div.cover-meta` (Deckblatt) | 07.11.2026 · Version 1.38 | 09.11.2026 · Version 1.39 | #27 (unverändert übernommen) |
| source/fahrt-zum-kunden.html | `p.cover-whatsnew` | Neu in v1.38 | Neu in v1.39 („Die sieben Standards“, Fußnote ADR/ADG) | #27 |
| source/fahrt-zum-kunden.html | Versionshistorie `#kap-versionen`, letzte Zeile | 1.38 · 07.11.2026 | 1.39 · 09.11.2026 | #27 |
| source/fahrt-zum-kunden.html | Begriffsliste, `(früher ADF)` | `style="opacity:.6"` (2,65:1) | `style="color:var(--ink-faint)"` (4,56:1) | Trockenlauf (Vorschlag) |
| story/current/fahrt-zum-kunden.html | ganze Datei | Stand 1.38 | bytegleich mit source (cmp) | publish-release.ps1 |
| story/current/geschichte.pdf | ganze Datei | 77 Seiten, v1.38 | 80 Seiten, v1.39, bytegleich mit source-PDF | Render + publish-release.ps1 |
| lesen.html | `#story-release` | Version 1.38 · 7. November 2026 | Version 1.39 · 9. November 2026 | #27, von publish-release.ps1 bestätigt |
| anhang.html | `#story-release` (C1) | Version 1.38 · 7. November 2026 | Version 1.39 · 9. November 2026 | publish-release.ps1 |
| anhang.html | `meta description` (C2) | „… ZAVKK-Quelle, Prüf-Standard und Versionshistorie.“ | „… ZAVKK-Quelle, Prüf-Standard, Die sieben Standards und Versionshistorie.“ | Trockenlauf (Vorschlag) |
| assets/js/app.js | `fallbackRelease` | 1.38 / 7. November 2026 / 77 | 1.39 / 9. November 2026 / 80 | #27, von publish-release.ps1 bestätigt |
| index.html | `<span data-page-count>` | 77 | 80 | #27, von publish-release.ps1 bestätigt |

Datum: #27 trägt „09.11.2026“ und „9. November 2026“. Dieser Wert wurde übernommen. Der PDF-Renderstand auf dem Deckblatt lautet dagegen „11.11.2026, 07:22 Uhr (MEZ)“. Offene Frage für den echten R60: Bleibt das Datum 09.11.2026, oder wird es auf den Tag des Renderns gesetzt? Seit dem 09.11. kamen #33 und die ADF-Zeile hinzu. Wird das Datum geändert, muss es an fünf Stellen gleich gesetzt werden: Deckblatt, Historienzeile, lesen.html, anhang.html und app.js. Außerdem ändert sich dann der Paketname. Die Historienzeile 1.39 erwähnt die Kontraste aus #33 bisher nicht.

Kontrast „(früher ADF)“: Der Hintergrund ist `--surface` #1b4f66, die Schrift `--accent` #a5b6ff. Gerechnet ist nach WCAG 2.x mit Alpha-Mischung, Skript im Scratchpad `kontrast.py`.

| Variante | Kontrast |
|---|---|
| opacity .6 (heute) | 2,65:1 (bestätigt den R41-Wert) |
| opacity .8 | 3,50:1 |
| opacity .9 | 4,02:1 |
| ohne opacity (`--accent`) | 4,55:1 |
| `color:var(--ink-faint)` (Vorschlag, gleiche Farbe wie der `<i>`-Untertitel davor) | 4,56:1 |
| `color:var(--ink-soft)` (mit Reserve) | 5,47:1 |

Keine opacity-Stufe unter 1,0 erreicht 4,5:1. Ein Token statt opacity ist darum nötig.

## Seitenzahlabgleich

| Stelle | Wert | Beleg |
|---|---|---|
| Deckblatt (source, cover-meta) | keine Seitenzahl vorhanden | `div.cover-meta` enthält Autor, Datum, Anlass, Version |
| PDF source/Die-Fahrt-zum-Kunden.pdf | 80 | `pdfinfo` Pages: 80; Renderlauf „Seiten: 80“ |
| story/current/geschichte.pdf | 80 | `pdfinfo` Pages: 80, `cmp` gleich mit der source-PDF |
| story/current/fahrt-zum-kunden.html | = source | `cmp` gleich |
| Startseite index.html | 80 | `<span data-page-count>80` |
| app.js fallbackRelease | 80 | `pageCount: 80` |
| Bezug: PDF aus #27 (Renderstand 10.11.) | 80 | `pdfinfo` |

- Gerendert wurde mit `scripts/pdf/render_story_pdf.py` (Exit 0, 07:22 bis 07:23).
- Danach lief `verify_layout.py --no-render` mit Exit 0: „OK – alle Seiten erfuellen den Layout-Check UND den Inhalt-Praesenz-/Positions-Check“, 80 Seiten geprüft.
- Die Schriften sind die echten Schriften (Fraunces, Work Sans, IBM Plex Mono, laut `pdffonts`), wie in der PDF aus #27.
- Die Kontraständerungen von #33 und die ADF-Zeile ändern die Seitenzahl nicht.

## Paket v1.39

| Feld | Wert |
|---|---|
| Name | relingit-upload-v1.39-2026-11-09-ohne-audio.zip |
| Größe | 4 683 423 Byte |
| Einträge | 39 (38 Nutzdateien + UPLOAD-MANIFEST.txt) |
| SHA-256 | BB9E7170EA7B3414DC2C1FBDBD9245F8EFF8425F35B4B17A2291BB14858CF9A3 |
| Bau | `scripts/publish-release.ps1 -OhneAudio` im Wegwerf-Worktree. Darin `build-upload.ps1`: „OK: 38 aktuelle Quelldateien bytegenau im ZIP bestätigt“, Exit 0 |
| Schreibort | `<Wegwerf-Worktree>/output/ftp` (`$projectRoot` = Elternordner von scripts/). Archiviert wurde nichts, weil dort kein altes Paket lag („Aufbewahrung archive/ftp-packages: Ordner fehlt, nichts zu melden“) |
| pruefe-paket.ps1 (#34) | `-Zip <v1.39> -Vorgaenger C:\dev\relingit\output\ftp\relingit-upload-v1.38-2026-11-07-ohne-audio.zip -ErwartetHash BB9E…9A3` mit **Exit 0**. Manifest: 38 gleich, 0 abweichend, 0 fehlend, 0 zusätzlich |
| gegenüber v1.38 (SHA-256 7669…984C, 36 Einträge) | geändert: index.html, lesen.html, assets/css/styles.css, assets/js/app.js, assets/js/story-viewer.js, story/current/fahrt-zum-kunden.html, story/current/geschichte.pdf; neu: anhang.html, assets/img/avatare/navis.svg, assets/img/avatare/lumen.svg; entfallen: 0 |
| PDF (in Paket und Ablage) | SHA-256 6AA87D4CEC8521B488174DA301DD6680BEAADE648567A2E0CFE646CC1967A48B, 2 073 595 Byte |

Ausgaben von publish-release.ps1 an den Admin-Bereich:

- „FTP-Upload nötig: ja, geändert: assets/js/story-viewer.js, index.html“
- „Nur Rückfallwerte: assets/js/app.js“
- „Hinweis: weitere öffentliche Dateien geändert: anhang.html, assets/css/styles.css, lesen.html“
- „Handout geändert: nein“

Das ZIP und die PDF wurden vor dem Entfernen nach `<scratchpad>/r63-ergebnis/` kopiert, zusammen mit `pruefe-paket.log`. Die Hashes der Kopien sind gleich.

## Nachweis Arbeitsklon unverändert

- Vor Beginn und am Ende wurde `find output archive reports -type f | sha256sum` gebildet. Dazu kam eine Liste mit Pfad, Größe und mtime.
- Ergebnis: 183 Dateien, `diff` ohne Ausgabe in beiden Listen („HASHES-GLEICH“, „LISTE-GLEICH“). Der Hash der Hashliste ist vorher und nachher 90b05e9975f6b8bb….
- `git status --short` im Arbeitsklon ist leer. HEAD ist main 8abe213, `git stash list` ist leer.
- Die lokalen Branch-Heads sind unverändert (alle wie in der Head-Tabelle). Es gibt keine neuen Refs.
- Die Worktrees wt-r06, wt-r41, wt-r62 und wt-rep wurden nicht angefasst. wt-rep steht jetzt auf 86b01ee statt a9997d5. Das kommt von einem Commit auf ops/reports außerhalb dieses Laufs.

`git worktree list` nach `git worktree remove --force <scratchpad>/r63-wt` und `git worktree prune`:

```
C:/dev/relingit 8abe213 [main]
C:/dev/wt-r06   8ea4c62 [auftrag-R06-standards-box-v139]
C:/dev/wt-r41   ecfbebb [auftrag-R41-buchkontraste]
C:/dev/wt-r62   82ddf15 [auftrag-R62-pruefe-paket]
C:/dev/wt-rep   86b01ee [ops/reports]
```

## Befundtabelle

| Nr | Fundstelle | Befund | Vorschlag | Schweregrad |
|---|---|---|---|---|
| 1 | anhang.html `#story-release` nach #26 + #27 | C1 bestätigt: D4 ci-check Exit 1 mit genau 1 Fehler | In R60 nicht von Hand setzen, sondern `publish-release.ps1` laufen lassen. Es setzt anhang.html mit (belegt: danach Exit 0) | muss |
| 2 | story/current/fahrt-zum-kunden.html nach #33 | D5 roh: genau 2 Fehler (C1 und story/current) | Ebenfalls über `publish-release.ps1` lösen, nach neuem PDF-Render. Im Block #27 → #33 → R60 ohne Zwischenstand auf main | muss |
| 3 | docs/ABLAUF.md, #30 + #32 | Textkonflikt wie in R57. Danach merget #34 (auch ABLAUF.md) ohne Konflikt | Beide Abschnitte behalten, R55 vor R56. Bei anderer Reihenfolge #34 neu prüfen | muss |
| 4 | source, Begriffsliste `(früher ADF)` | 2,65:1 (nachgerechnet) | `style="opacity:.6"` durch `style="color:var(--ink-faint)"` ersetzen (4,56:1, knapp) oder `--ink-soft` (5,47:1). Seitenzahl bleibt 80 | muss (PO-Entscheidung 11.11.) |
| 5 | Datum v1.39 | Deckblatt, Historie und Rückfallwerte sagen 09.11.2026. #33, ADF und der Render kommen später; Renderstand 11.11.2026 | PO entscheiden lassen: 09.11. lassen oder auf den Render-Tag setzen. Wenn ändern, dann an 5 Stellen gleich, dann ändert sich auch der Paketname | sollte |
| 6 | anhang.html `meta description` (C2) | Nennt „Die sieben Standards“ nicht | Ergänzen wie im Trockenlauf oder allgemeiner: „Anhang der Geschichte … mit allen Anhang-Blöcken der Buchfassung“ | sollte |
| 7 | Versionshistorie 1.39 | Erwähnt die Buchkontraste aus #33 (und die ADF-Zeile) nicht | In R60 einen Halbsatz zur Zeile 1.39 ergänzen (PO entscheidet) | sollte |
| 8 | index.html Z. 152, handout.html Z. 29, story/current/workshop-handout.html Z. 147 | Weiter „September 2026“, das Deckblatt sagt „Ende November 2026“ (C6 aus R29, offen) | Mit v1.39 angleichen oder bewusst zurückstellen. Das Handout ist laut publish-release nicht geändert | sollte |
| 9 | Paketumfang v1.39 | Nicht nur Admin-Weg: FTP ist nötig (index.html, story-viewer.js, dazu anhang.html, styles.css, lesen.html und Avatare neu) | In der Upload-Checkliste für v1.39 alle 10 geänderten oder neuen Dateien aufführen. pruefe-paket-Tabelle beilegen | sollte |
| 10 | ZIP-Hash | Nicht reproduzierbar: Das Manifest enthält „Erstellt“, und die PDF trägt den Renderstand | Der Hash aus diesem Trockenlauf gilt nicht für R60. R60 nennt seinen eigenen Hash, mit `pruefe-paket.ps1 -ErwartetHash` belegt | kann |
| 11 | scripts/pdf/requirements.txt | Playwright ist ungepinnt und im System-Python nicht installiert. Die neueste Version (1.65) bräuchte einen Chromium-Download (chromium-1254), installiert ist chromium-1248 | Im Trockenlauf Scratchpad-venv mit `playwright==1.64.0` (passt zu chromium-1248). Vorschlag: Version in requirements.txt pinnen | kann |
| 12 | Pester-Laufzeit | 54 Tests, etwa 3,5 bis 4,5 Minuten je Lauf. Bei „nach jedem Schritt“ (9 Schritte) etwa 35 Minuten nur für Pester | In R60 Pester nur nach Schritten laufen lassen, die scripts/ oder tests/ ändern. ci-check nach jedem Schritt | kann |
| 13 | `#render-stamp` | 2,93:1, nur im PDF | Bleibt laut PO-Entscheidung so; nur zur Vollständigkeit | kann |

## Zeitschätzung R60 (Schätzung, nicht gemessen)

Grundlage sind die gemessenen Einzelzeiten dieses Laufs:

| Schritt im Trockenlauf | Dauer |
|---|---|
| Render | etwa 1 Minute |
| verify_layout | unter 1 Minute |
| publish-release mit Paket | etwa 1 Minute |
| ci-check | Sekunden |
| Pester | 3,5 bis 4,5 Minuten |

Geschätzter Bedarf für R60:

| Aufgabe | Schätzung |
|---|---|
| Branch, Nachzüge (ADF, C2, ggf. Datum und Historie), Render, Prüfen, publish-release, Paket | etwa 30 bis 40 Minuten |
| ci-check und Pester nach jedem Merge-Schritt | etwa 30 bis 40 Minuten zusätzlich |
| Vorher-/Nachher-Bilder, Draft-PR und Bericht | etwa 30 Minuten |
| **Summe Agentenzeit** | **etwa 1,5 bis 2 Stunden** |

Dazu kommen die Wartezeiten auf die Einzelfreigaben des PO und auf die PR-CI je Schritt. Das ist eine Schätzung, nicht belegt.

## Vorschläge und Ideen (Claude)

- R60 sollte publish-release.ps1 als einzigen Weg nutzen und nichts von Hand kopieren. Das löst C1 und story/current zusammen, und die Seitenzahl kommt aus der PDF.
- Den Block #27 → #33 → R60 technisch als einen R60-Branch vorbereiten, der auf main nach #26 die beiden PRs plus Nachzug enthält. Dann sieht die PR-CI genau den Endstand, bevor der erste der drei gemergt wird.
- `requirements.txt` mit fester Playwright-Version und docs/PDF-ERZEUGEN.md um den venv-Weg ergänzen. Dann hängt der Render nicht vom System-Python ab.
- Kontrastprüfung aus R41 als CI-Regel. Dazu ein Verbot von Inline-`opacity` an Text in der Buchquelle, damit Fälle wie „(früher ADF)“ nicht wiederkommen.
- In pruefe-paket.ps1 optional die Manifest-Zeile „Erstellt“ beim Hashvergleich ausklammern oder einen inhaltlichen Hash ausgeben (Hash über alle Nutzdatei-Hashes). Dann lassen sich Trockenlauf und echter Lauf vergleichen.
- Das kumulative Probe-Merge-Verfahren (R57 und R63) als Skript `scripts/kreuzpruefung.ps1` mit Reihenfolge als Parameter festhalten.

Hygiene: Nach dem Lauf gibt es keinen eigenen Worktree mehr. Der Arbeitsklon ist sauber auf main 8abe213, es gibt keine neuen Branches und keinen Stash. Offen sind 9 Draft-PRs (#25–#28, #30–#34). Im Scratchpad bleiben `venv/` (Playwright 1.64.0), `r63-ergebnis/` (ZIP, PDF, pruefe-paket.log) und die Prüfprotokolle. Sie liegen nicht im Repository.

```yaml
Reifegrad: Trockenlauf v1.39 belegt; Endstand ci-check Exit 0, Pester 54/54, PDF 80 Seiten, Paket gegen v1.38 geprueft (Exit 0)
Projektstatus:
  main: 8abe213, ci-check Exit 0, Pester 21/21
  offene_PRs: 9 (alle Draft, #25-#28, #30-#34)
  Endstand_Probe: ci-check Exit 0, Pester 54/54 (mit Nachzuegen C1, story/current, ABLAUF.md, ADF, C2)
  Paket_Probe_v139: relingit-upload-v1.39-2026-11-09-ohne-audio.zip, SHA-256 BB9E7170EA7B3414DC2C1FBDBD9245F8EFF8425F35B4B17A2291BB14858CF9A3 (nicht reproduzierbar, nur Trockenlauf)
Offene_Fragen:
  - Bleibt das v1.39-Datum 09.11.2026 oder wird es in R60 auf den Render-Tag gesetzt?
  - ADF-Zeile mit --ink-faint (4,56:1) oder --ink-soft (5,47:1)?
  - Soll die Versionshistorie 1.39 die Buchkontraste (#33) nennen?
  - Wird C6 (Handout "September 2026") mit v1.39 angeglichen?
  - Playwright-Version in requirements.txt pinnen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```

## Gegenprobe Koordinator (11.11.2026, 07:30)

- Eigene Prüfsummen von `output/` und `archive/` im Arbeitsklon (178 Dateien, gesichert 06:50 vor dem Start) gegen den Stand nach dem Lauf: `diff` leer.
- `git status --porcelain` im Arbeitsklon leer, HEAD main 8abe213; kein Wegwerf-Worktree mehr in `git worktree list`.
- SHA-256 des Probe-Pakets v1.39 im Scratchpad beginnt mit `BB9E7170EA7B3414`, wie oben. ZIP und PDF bleiben im Scratchpad und werden nicht übernommen.

## Nachtrag 11.11.2026: Entscheidung des Product Owners zum Datum v1.39

v1.39 erhält beim Rendern in R60 das **aktuelle Datum** (Renderdatum), nicht den 09.11.2026 aus #27. Das Datum wird an allen Stellen gleich gesetzt (Buchquelle/Deckblatt, Startseite, lesen.html, anhang.html, Versionshistorie). Für den Planer: in queue/R60.yaml aufnehmen.
