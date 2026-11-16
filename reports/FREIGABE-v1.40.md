# Freigabebericht v1.40

Erzeugt: 2026-11-16 08:12 von scripts/freigabe-pruefen.ps1. Branch: auftrag-R86-v140, Commit: 1eaabbf. Projekt: `C:\dev\wt\relingit\r86`.

Regel (docs/FREIGABE.md): Kein Merge, kein Tag und kein Upload, solange ein Tor nicht bestanden, offen oder gesperrt ist. G3, G4, G5 und G8 gibt das Skript nie als bestanden aus; G8 erteilt nur Bernd.

## Tore

| Tor | Name | Ergebnis | Nachweis |
|---|---|---|---|
| G1 | Code | bestanden | ci-check.ps1: bestanden; node --check: bestanden; Pester-Tests: bestanden |
| G2 | Kommentare | bestanden | Review ohne Änderungswunsch: bestanden; Kopfkommentar je Skript: bestanden |
| G3 | Layout | offen | Sichtung PDF: offen |
| G4 | UI | offen | Sichtung Webseiten in 390, 768 und 1280 px: offen |
| G5 | Inhalt | offen | Inhalt gelesen: offen |
| G6 | Lokal | bestanden | Podcast-MP3 gegen SHA256SUMS.txt: nicht zutreffend; Lokale Vorschau möglich: bestanden |
| G7 | Git | bestanden | git status sauber: bestanden; Feature-Branch, gleich Upstream: bestanden; Pull Request offen, kein Draft, Checks grün: bestanden |
| G8 | Freigabe Bernd | offen | Freigabe durch Bernd: offen |

## Einzelprüfungen

| Tor | Prüfung | Ergebnis | Nachweis |
|---|---|---|---|
| G1 | ci-check.ps1 | bestanden | Exit 0; OK: 12 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft. |
| G1 | node --check | bestanden | 6 Dateien ohne Fehler: admin.js, app.js, handout-viewer.js, pdf-viewer.js, story-viewer.js, supabase-config.js |
| G1 | Pester-Tests | bestanden | Invoke-Pester -Path tests: 55 bestanden, 0 fehlgeschlagen |
| G2 | Review ohne Änderungswunsch | bestanden | PR #41: kein Review-Status |
| G2 | Kopfkommentar je Skript | bestanden | 12 Skripte unter scripts/ mit Kommentar in den ersten zehn Zeilen |
| G3 | Sichtung PDF | offen | SICHTUNG-v1.40.md: 6 Ja, 0 Nein, 0 leer von 6; vollständig, Bestätigung durch Bernd mit G8 |
| G4 | Sichtung Webseiten in 390, 768 und 1280 px | offen | SICHTUNG-v1.40.md: 18 Ja, 0 Nein, 0 leer von 18; vollständig, Bestätigung durch Bernd mit G8 |
| G5 | Inhalt gelesen | offen | SICHTUNG-v1.40.md: 2 Ja, 0 Nein, 0 leer von 2; vollständig, Bestätigung durch Bernd mit G8 |
| G6 | Podcast-MP3 gegen SHA256SUMS.txt | nicht zutreffend | Paket relingit-upload-v1.40-2026-11-16-ohne-audio.zip enthält keine Podcast-MP3 (ohne Audio); die Live-MP3 bleiben beim Upload unverändert, darum entfällt der Prüfsummenvergleich |
| G6 | Lokale Vorschau möglich | bestanden | scripts/vorschau.ps1 vorhanden, Python: C:\Users\bmarn\AppData\Local\Programs\Python\Python311\python.exe |
| G7 | git status sauber | bestanden | git status --porcelain ohne Ausgabe |
| G7 | Feature-Branch, gleich Upstream | bestanden | Branch auftrag-R86-v140, HEAD 1eaabbf = origin/auftrag-R86-v140 |
| G7 | Pull Request offen, kein Draft, Checks grün | bestanden | PR #41 gegen main, Draft: nein, mergeable: MERGEABLE, Checks: 1 gesamt, 0 fehlgeschlagen, 0 laufend (https://github.com/Reling-IT/relingit/pull/41) |
| G8 | Freigabe durch Bernd | offen | Voraussetzungen erfüllt; Freigabe nur durch Bernd, z. B. PR-Kommentar 'Freigabe G8 v1.40: ja' |

## Gesamtergebnis

Keine automatische Prüfung nicht bestanden. Freigabe erst nach Sichtung und Entscheidung von Bernd (G8).

Sichtungsliste: `SICHTUNG-v1.40.md` (vorhanden, ausgewertet, nicht überschrieben).
