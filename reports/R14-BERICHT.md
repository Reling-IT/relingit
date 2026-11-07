---
id: R14
titel: PDF-Werkzeuge übernehmen und dokumentieren
status: erledigt
start: 2026-11-07T05:06+01:00
ende: 2026-11-07T05:17+01:00
branch: auftrag-R14-pdf-werkzeuge
pr: https://github.com/Reling-IT/relingit/pull/11
commit: 3b14d6d
ci: pass (GitHub „Website prüfen“, lokal ci-check.ps1 Exit 0)
---

## Ergebnis

Die PDF-Werkzeuge sind übernommen, unter Windows abgesichert und in `docs/PDF-ERZEUGEN.md` beschrieben (PR #11, nicht gemergt).
Rendern und Pixelprüfung konnten lokal **nicht** laufen: playwright (Python), numpy und pillow fehlen. Ich habe nichts installiert.
Die Teilprüfung (Struktur, Überschriften, Kapitel-Links) gegen die vorhandenen 69-Seiten-PDFs findet keine Verletzung.
Wichtigster Befund: Die Quelle lädt keine Webfonts. Die Referenz-PDF wurde mit Linux-Ersatzschriften gesetzt, deshalb hängt die Seitenzahl von der Maschine ab.
`docs/NEUE-GESCHICHTE.md` gibt es auf diesem Branch nicht (auch nicht auf main). Der Verweis steht deshalb nur im README.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Worktree | `C:\dev\wt-r14` auf 4a88f92 angelegt, enthält main (2f8cd6d) | `git worktree add ...` → „HEAD is now at 4a88f92“; `merge-base --is-ancestor origin/main HEAD` → enthalten |
| Python, pip | vorhanden | `python --version` → 3.11.9; `python -m pip --version` → pip 24.0 |
| pypdf, tzdata | vorhanden | pypdf 6.21.0, tzdata 2026.5 |
| playwright (Python) | fehlt | `ModuleNotFoundError: No module named 'playwright'` |
| numpy, pillow | fehlen | `No module named 'numpy'` bzw. `'PIL'` |
| Chromium | Ordner `chromium-1228`, `chromium-1234` in `%LOCALAPPDATA%\ms-playwright` vorhanden; passt zur Python-Playwright-Version erst nach deren Installation prüfbar | `Get-ChildItem $env:LOCALAPPDATA\ms-playwright` |
| Poppler | pdftoppm/pdfinfo 25.07.0 im PATH (winget) | `where.exe pdftoppm`, `pdftoppm -v` |
| Installationsbefehl Fehlendes | `python -m pip install -r scripts/pdf/requirements.txt`, danach `python -m playwright install chromium` | nicht ausgeführt |
| Schritt 3 Rendern und Prüfen | nicht ausführbar | `verify_layout.py --no-render` → „ABBRUCH: Python-Paket fehlt (numpy)…“, Exit 2; `render_story_pdf.py` → „…(playwright)…“, Exit 1 |
| Teilprüfung Text | Struktur OK, 69 Seiten, Überschriften/Links OK für `story/current/geschichte.pdf` und `source/Die-Fahrt-zum-Kunden.pdf` | Scratch-Skript mit `check_structure`/`check_headings_and_links` aus verify_layout.py, numpy/PIL nur als Platzhalter |
| Ursache 70 statt 69 Seiten | Quelle verlangt Fraunces/Work Sans/IBM Plex Mono, bindet sie aber nicht ein. Referenz-PDF enthält DejaVuSansMono, LiberationSerif, LiberationSans. Windows hat Georgia, Segoe UI, Consolas (und auch Liberation/DejaVu installiert, die aber erst später in der Liste stehen) | `grep` ohne `<link>`/`@font-face`; `pdffonts story/current/geschichte.pdf`; Fonts-Ordner |
| Skriptanpassung tzdata | `tzdata; sys_platform == "win32"` in requirements: zoneinfo hat unter Windows keine Zeitzonendatenbank | Commit e760de1 |
| Skriptanpassung Kodierung | stdout als UTF-8: vorbeugend, damit eine Umleitung unter cp1252 nicht abbricht. Aktuelle h2 enthalten keine Zeichen außerhalb von cp1252 | Prüfung der 29 h2 → keine |
| Skriptanpassung Meldungen | Fehlende Pakete, fehlendes Chromium, fehlendes pdftoppm und fehlende Quelle bringen eine Meldung mit Befehl statt Traceback. Quelldatei wird geschlossen. Schwellen und Regeln unverändert | `git diff 4a88f92 -- scripts/pdf` |
| Doku | `docs/PDF-ERZEUGEN.md` neu, Verweis in README.md | Commit 3b14d6d |
| output/ ignoriert | ja | `git check-ignore -v output/x.pdf` → `.gitignore:5:output/` |
| ci-check | Werkzeuge keine Pflicht, Lauf grün | `pwsh -NoProfile -File scripts/ci-check.ps1` → „OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, lokale Links, PDFs und Secret-Schutz geprüft.“ Exit 0; `gh pr checks 11` → pass |
| PR und Kommentar | PR #11 und Prüfkommentar | https://github.com/Reling-IT/relingit/pull/11, Kommentar #issuecomment-6702138959 |

## Offene Fragen, Risiken, Abweichungen

- Schritt 3 (frisches Rendern, Seitenzahl, Randhinweise S. 15 und 24) ist nicht belegt. Nachholen, sobald die Pakete installiert sind.
- Die Seitenzahl ist nicht reproduzierbar, solange die Schriften nicht eingebunden sind. Eine unter Windows gerenderte PDF kann von 69 abweichen. `publish-release.ps1` übernimmt die Zahl dann automatisch. Das ist korrekt, ändert aber LP und Version.
- Die Randhinweise aus dem Cloud-Lauf kommen wahrscheinlich ebenfalls von den Ersatzschriften. Belegt ist das nicht.
- Abweichung: Verweis aus `docs/NEUE-GESCHICHTE.md` fehlt, weil die Datei erst mit PR #8 kommt. Nach dem Merge von #8 ergänzen.
- Die Teilprüfung lief mit Platzhaltern für numpy/PIL im Scratchpad. Sie ersetzt die Pixelprüfung nicht.

## Vorschläge und Ideen (Claude)

- Die drei Schriften als WOFF2 unter `assets/fonts/` ablegen und per `@font-face` in die Quelle einbinden (SIL OFL, zulässig). Dann setzt jede Maschine gleich, und die Seitenzahl wird reproduzierbar. Achtung: Das ändert Buchquelle und Layout, also nur als eigener Auftrag mit Freigabe.
- Im Render-Skript nach `page.goto` auf `document.fonts.ready` warten statt fest 400 ms. Mit eingebundenen Schriften ist das robuster.
- Optional `verify_layout.py --expect-pages N`, das mit `story/current/geschichte.pdf` vergleicht. Die Prüfregeln werden dadurch nicht weicher, Abweichungen fallen aber sofort auf.
- Die Schriftliste (`pdffonts`) als Hinweis in der Ausgabe des Render-Skripts melden.

Hygiene: Keine gemergten Remote-Branches außer main (`git branch -r --merged origin/main` → nur origin/main, origin/HEAD). Offene PRs: #12 R25, #11 R14, #8 R02, #7 R08, #6 Avatare. Drafts: #10 Geschichte „Die veralteten Daten“, #9 R03. Quellbranch `quelle-pdf-werkzeuge-20261106` kann nach dem Merge von #11 gelöscht werden. Worktree `C:\dev\wt-r14` ist noch vorhanden.

```yaml
Reifegrad: PDF-Werkzeuge im Repo und dokumentiert; lokal unter Windows noch nicht End-to-End gelaufen (Pakete fehlen)
Projektstatus: Website und Buch v1.29 live; mehrere PRs offen (#6, #7, #8, #11, #12), Drafts #9, #10
Offene_Fragen:
  - Installation von playwright, numpy, pillow und Chromium freigeben, dann Schritt 3 nachholen
  - Sollen Webfonts eingebunden werden, damit die Seitenzahl reproduzierbar wird?
  - Verweis in docs/NEUE-GESCHICHTE.md nach Merge von PR #8 ergänzen
Roadmap:
  Sprints_bis_BSF: 1   # unbelegte Schätzung
  Sprints_bis_MVP: 2   # unbelegte Schätzung
```
