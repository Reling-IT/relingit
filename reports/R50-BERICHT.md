# R50 – Muss-Korrektur v1.38: „ein kleines Systemhaus mit einer Kaffeeecke“

Stand: 2026-11-09, 05:52 bis 06:03 (Ortszeit, mit `date` geprüft). Ausgeführt vom Koordinator (Claude Code CLI) im Worktree `C:\dev\wt-r50\`, Branch `auftrag-R50-kleines-systemhaus`, Commit b1cbea1. Entscheidung Bernd 09.11.2026 (queue/R50.yaml).

## Ergebnis
Erledigt. PR #29 gegen main ist offen (kein Draft, CI grün, **nicht gemergt**): https://github.com/Reling-IT/relingit/pull/29.
- Genau eine Textstelle geändert. Version 1.38 und Datum 07.11.2026 sind unverändert, die Versionshistorie hat keine neue Zeile.
- PDF: 77 Seiten.
- Freigabeprüfung: G1, G2 und G7 bestanden, G3 bis G6 offen, G8 gesperrt.
- Die Vorschau läuft für die Sichtung.

## Vorab-Suche „zehn Köpfen“ im Buch
`grep -n -o ".{60}zehn Köpfen.{40}" source/fahrt-zum-kunden.html`:
- Zeile 833 (Kapitel Kaffeeecke): „… sondern zwei von zehn Köpfen, die ihren eigentlichen Job machen …“. Diese Stelle **bleibt**, weil dort die Gegenwart gilt.
- Zeile 1367 (Kapitel „Warum Navis und Lumen“, direkt unter `<h2 id="kap-warum-navis-lumen">` in Zeile 1366): Zielstelle.

## Vorher – Nachher
Literal-Ersetzung auf Bytes (Python, UTF-8) mit Abbruch, falls die Trefferzahl nicht genau 1 ist. Ausgabe: `Treffer: 1`.

| | Text (Zeile 1367) |
|---|---|
| vorher | „… viel große Vision, wenig davon passt auf **ein Systemhaus mit zehn Köpfen und einer Kaffeeecke**, in der gerade …“ |
| nachher | „… viel große Vision, wenig davon passt auf **ein kleines Systemhaus mit einer Kaffeeecke**, in der gerade …“ |

`git diff --numstat` nach der Ersetzung: `1 1 source/fahrt-zum-kunden.html`.

Umfang des Commits (`git diff --stat`):
- source/fahrt-zum-kunden.html: 1 Zeile
- story/current/fahrt-zum-kunden.html: 1 Zeile
- source/Die-Fahrt-zum-Kunden.pdf und story/current/geschichte.pdf: 2 065 217 → 2 065 170 Byte

## Prüfausgaben
1. **ci-check vor publish-release:** `./scripts/ci-check.ps1` direkt nach der Ersetzung endet mit **Exit 1**. Das ist erwartet: „Veröffentlichungsfassung ist nicht aktuell: story/current/fahrt-zum-kunden.html weicht von source/fahrt-zum-kunden.html ab“. Die Buchquelle selbst hat keinen Befund.
2. **verify_layout vollständig** (venv-pdf mit numpy und pillow, rendert selbst): `C:\dev\venv-pdf\Scripts\python.exe scripts/pdf/verify_layout.py --source source/fahrt-zum-kunden.html --pdf output/Die-Fahrt-zum-Kunden.pdf`, Exit 0. Ausgabe:
   - `OK -> …\output\Die-Fahrt-zum-Kunden.pdf | Seiten: 77 | Renderstand: 09.11.2026, 05:54 Uhr (MEZ)`
   - „Struktur-Check OK - alle vier Fix-Mechanismen sind im CSS vorhanden.“
   - „Geprueft: 77 Seiten (Rand/Luftzone/Fast-leer-Check)“
   - „OK - alle Seiten erfuellen den Layout-Check UND den Inhalt-Praesenz-/Positions-Check.“
3. **PDF ausdrücklich neu gerendert:**
   - `render_story_pdf.py --source … --out output/Die-Fahrt-zum-Kunden.pdf` → „Seiten: 77 | Renderstand: 09.11.2026, 05:55 Uhr“, Exit 0.
   - Danach `verify_layout.py --pdf … --no-render`: OK, Exit 0.
   - Nach `source/Die-Fahrt-zum-Kunden.pdf` kopiert, SHA-256 `FB7889E50C1F3A13B0F52206D7240EAB97FA293680E64B5C5FB9A26CC3E0E6F3`.
4. **Seitenzahl und Text:**
   - `pdfinfo` → `Pages: 77` (vorher ebenfalls 77).
   - Deckblatt per `pdftotext`: „07.11.2026“, „Version 1.38“.
   - Volltext mit normalisierten Leerzeichen: „… wenig davon passt auf ein kleines Systemhaus mit einer Kaffeeecke, in der gera…“. „zehn Köpfen und einer“: 0 Treffer.
5. **publish-release:** `./scripts/publish-release.ps1 -OhneAudio` → „OK: Version 1.38 vom 7. November 2026 mit 77 Seiten veröffentlicht und paketiert.“, Exit 0. Laut `git status` sind danach nur die vier oben genannten Dateien geändert.
   - Die Übergabe-Ausgabe meldet „FTP-Upload nötig: ja, geändert: assets/js/handout-viewer.js, assets/js/story-viewer.js, index.html“ und weist zusätzlich auf styles.css, das Podcast-Cover, handout.html und lesen.html hin.
   - R50 hat keine dieser Dateien geändert. Der Vergleichsstand ist ba5a23c (R16); die Änderungen stammen aus R36, R40, R43 und dem Schriften-Fix, die seitdem in main sind.
6. **ci-check nach publish-release:** `./scripts/ci-check.ps1` → „OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.“, Exit 0. `node --check assets/js/*.js`: ohne Fehler.
7. **build-upload:** `./scripts/build-upload.ps1 -OhneAudio`.
   - build-upload bricht ab, wenn ein Paket mit gleichem Namen existiert. Deshalb habe ich das Paket aus dem publish-Lauf (SHA-256 `3BAD923A520CF4B8DF12D924739B2896F10BAABF96B72289F4E332FEC4AF16BE`) vorher nach `output/ftp-publish-lauf/` verschoben.
   - Ausgabe: „OK: geprüftes Upload-Paket erstellt … OK: 35 aktuelle Quelldateien bytegenau im ZIP bestätigt.“
   - Inhaltsvergleich beider ZIPs (Name und CRC32): Nur UPLOAD-MANIFEST.txt weicht ab (Erstellzeit).
8. **CI von PR #29** („Website prüfen“): pass (10 s), https://github.com/Reling-IT/relingit/actions/runs/42564614362.
9. **Freigabeprüfung:** `./scripts/freigabe-pruefen.ps1` auf dem Feature-Branch, Exit 0 („keine automatische Prüfung nicht bestanden. G8 erteilt nur Bernd.“):

| Tor | Ergebnis | Nachweis (Auszug) |
|---|---|---|
| G1 Code | bestanden | ci-check Exit 0; node --check 6 Dateien; Pester 21 bestanden, 0 fehlgeschlagen |
| G2 Kommentare | bestanden | PR #29 ohne Änderungswunsch; Kopfkommentar je Skript (8) |
| G3 Layout | offen | Sichtung PDF 0 von 6 |
| G4 UI | offen | Sichtung Webseiten 0 von 18 |
| G5 Inhalt | offen | Sichtung 0 von 2 |
| G6 Lokal | offen | 0 von 4 MP3 lokal (Paket ohne Audio); Vorschau möglich |
| G7 Git | bestanden | Branch gleich Upstream b1cbea1; PR #29 offen, kein Draft, MERGEABLE, 1 Check grün |
| G8 Freigabe Bernd | gesperrt | G3 bis G6 offen |

   Bericht und Sichtungsliste liegen lokal: `C:\dev\wt-r50\reports\FREIGABE-v1.38.md`, `C:\dev\wt-r50\reports\SICHTUNG-v1.38.md`.
10. **Vorschau:** `./scripts/vorschau.ps1 -Port 8050 -Pdf` → „Vorschau läuft: http://127.0.0.1:8050/index.html“.
   - Kopie: `C:\Users\bmarn\AppData\Local\Temp\relingit-vorschau-20261109-060229-f466c1` (35 Dateien, Supabase abgeschaltet).
   - Abruf per curl: index.html, lesen.html, story/current/fahrt-zum-kunden.html und geschichte.pdf liefern je 200. Die Lesefassung enthält die neue Formulierung (1 Treffer).
   - Der Server läuft für Bernds Sichtung weiter. Strg+C oder das Ende der Sitzung beendet ihn.

## Neues Paket
- Datei: `C:\dev\wt-r50\output\ftp\relingit-upload-v1.38-2026-11-07-ohne-audio.zip` (lokal, nicht im Repo)
- Größe: 4 666 884 Byte (4,45 MiB), 36 Einträge
- **SHA-256: `A906DDF477C7B980E3AB1D5AD4867E2222FECA4B2EACEF29D2DC714B7E10205A`**
- Ersetzt das Paket vom Morgen (`7118198F…FAE4`, Bericht PAKET-v1.38-2026-11-09). Unterschied: eine Stelle im Buchtext und das neu gerenderte PDF (story/current/fahrt-zum-kunden.html 1 617 434 statt 1 617 443 Byte, geschichte.pdf 2 065 170 statt 2 065 217 Byte).

| Bytes | Datei |
|---:|---|
| 939 | .htaccess |
| 6426 | admin.html |
| 6861 | datenschutz.html |
| 1392 | handout-pdf.html |
| 2019 | handout.html |
| 1886 | impressum.html |
| 12249 | index.html |
| 2143 | lesen.html |
| 1387 | pdf.html |
| 1299 | assets/css/legal.css |
| 14181 | assets/css/styles.css |
| 4391 | assets/fonts/Fraunces-OFL.txt |
| 205500 | assets/fonts/Fraunces-Variable.woff2 |
| 2754 | assets/fonts/HERKUNFT.txt |
| 53408 | assets/fonts/IBMPlexMono-Italic.woff2 |
| 50400 | assets/fonts/IBMPlexMono-Medium.woff2 |
| 4456 | assets/fonts/IBMPlexMono-OFL.txt |
| 49248 | assets/fonts/IBMPlexMono-Regular.woff2 |
| 76284 | assets/fonts/WorkSans-Bold.woff2 |
| 66376 | assets/fonts/WorkSans-Italic.woff2 |
| 4396 | assets/fonts/WorkSans-OFL.txt |
| 71988 | assets/fonts/WorkSans-Regular.woff2 |
| 6752 | assets/img/favicon.png |
| 8423 | assets/img/reling-it-logo.svg |
| 1005947 | assets/img/reling-it-podcast-cover.png |
| 18682 | assets/js/admin.js |
| 4182 | assets/js/app.js |
| 4040 | assets/js/handout-viewer.js |
| 668 | assets/js/pdf-viewer.js |
| 7586 | assets/js/story-viewer.js |
| 246 | assets/js/supabase-config.js |
| 1617434 | story/current/fahrt-zum-kunden.html |
| 2065170 | story/current/geschichte.pdf |
| 7183 | story/current/workshop-handout.html |
| 105494 | story/current/workshop-handout.pdf |
| 3504 | UPLOAD-MANIFEST.txt |

## Abweichungen
- PR #29 ist kein Draft, damit G7 („PR offen, kein Draft“) prüfbar ist. R50 schreibt keinen Draft vor. Nicht gemergt.
- `build-upload.ps1` lief als eigener Schritt nach publish-release, obwohl publish-release schon ein Paket baut. Das erste Paket liegt unter `output/ftp-publish-lauf/`.
- Draft-PR #27 (v1.39) ändert dieselbe Buchquelle, das PDF und story/current. Nach dem Merge von #29 muss #27 main übernehmen und PDF und story/current neu erzeugen. Das steht auch im PR #29.

## Vorschläge und Ideen (Claude)
- `ci-check.ps1` um eine kleine Liste unerwünschter Formulierungen ergänzen (z. B. „Systemhaus mit zehn Köpfen“ vor der Einführung der Figuren), damit der Stimmigkeitsfehler nicht zurückkehrt.
- `build-upload.ps1` könnte nur melden statt abzubrechen, wenn das vorhandene Paket inhaltlich gleich ist (bis auf das Manifest). Dann muss nichts beiseitegelegt werden.
- Den Renderstand des PDF (Datum und Uhrzeit) in den Freigabebericht übernehmen, damit klar ist, welches PDF gesichtet wurde.

Hygiene: Remote-Branches: main, ops/queue, ops/reports und die Auftragsbranches R06, R07, R11, R49, R50; keiner davon gemergt. Offene PRs: #29 (R50, kein Draft) und die Drafts #25, #26, #27, #28. Nichts gemergt, kein Tag, kein FTP.

```yaml
Reifegrad: Buchfassung v1.38 mit Muss-Korrektur, PDF 77 Seiten, automatische Tore G1 G2 G7 bestanden
Projektstatus: PR 29 wartet auf Sichtung G3 bis G5 und Freigabe G8 durch Bernd; Upload danach von Hand
Offene_Fragen:
  - Sichtung von PDF und Webseiten in der laufenden Vorschau (G3 bis G5) durch Bernd
  - G6 bei Paket ohne Audio als nicht zutreffend werten?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
