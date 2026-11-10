# Freigabebericht v1.38

Erzeugt: 2026-11-09 06:01 von scripts/freigabe-pruefen.ps1. Branch: auftrag-R50-kleines-systemhaus, Commit: b1cbea1. Projekt: `C:\dev\wt-r50`.

Regel (docs/FREIGABE.md): Kein Merge, kein Tag und kein Upload, solange ein Tor nicht bestanden, offen oder gesperrt ist. G3, G4, G5 und G8 gibt das Skript nie als bestanden aus; G8 erteilt nur Bernd.

## Tore

| Tor | Name | Ergebnis | Nachweis |
|---|---|---|---|
| G1 | Code | bestanden | ci-check.ps1: bestanden; node --check: bestanden; Pester-Tests: bestanden |
| G2 | Kommentare | bestanden | Review ohne Änderungswunsch: bestanden; Kopfkommentar je Skript: bestanden |
| G3 | Layout | offen | Sichtung PDF: offen |
| G4 | UI | offen | Sichtung Webseiten in 390, 768 und 1280 px: offen |
| G5 | Inhalt | offen | Inhalt gelesen: offen |
| G6 | Lokal | offen | Podcast-MP3 gegen SHA256SUMS.txt: offen; Lokale Vorschau möglich: bestanden |
| G7 | Git | bestanden | git status sauber: bestanden; Feature-Branch, gleich Upstream: bestanden; Pull Request offen, kein Draft, Checks grün: bestanden |
| G8 | Freigabe Bernd | gesperrt | Freigabe durch Bernd: gesperrt |

## Einzelprüfungen

| Tor | Prüfung | Ergebnis | Nachweis |
|---|---|---|---|
| G1 | ci-check.ps1 | bestanden | Exit 0; OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft. |
| G1 | node --check | bestanden | 6 Dateien ohne Fehler: admin.js, app.js, handout-viewer.js, pdf-viewer.js, story-viewer.js, supabase-config.js |
| G1 | Pester-Tests | bestanden | Invoke-Pester -Path tests: 21 bestanden, 0 fehlgeschlagen |
| G2 | Review ohne Änderungswunsch | bestanden | PR #29: kein Review-Status |
| G2 | Kopfkommentar je Skript | bestanden | 8 Skripte unter scripts/ mit Kommentar in den ersten zehn Zeilen |
| G3 | Sichtung PDF | offen | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 6 leer von 6 |
| G4 | Sichtung Webseiten in 390, 768 und 1280 px | offen | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 18 leer von 18 |
| G5 | Inhalt gelesen | offen | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 2 leer von 2 |
| G6 | Podcast-MP3 gegen SHA256SUMS.txt | offen | 0 von 4 passend; nicht vorhanden in C:\dev\wt-r50\assets\audio: ki-als-beifahrer-im-it-systemhaus.mp3, vom-logbuch-zum-ki-ticketsystem.mp3, warum-ki-nicht-lenken-darf.mp3, roman-als-ki-blaupause.mp3 |
| G6 | Lokale Vorschau möglich | bestanden | scripts/vorschau.ps1 vorhanden, Python: C:\Users\bmarn\AppData\Local\Programs\Python\Python311\python.exe |
| G7 | git status sauber | bestanden | git status --porcelain ohne Ausgabe |
| G7 | Feature-Branch, gleich Upstream | bestanden | Branch auftrag-R50-kleines-systemhaus, HEAD b1cbea1 = origin/auftrag-R50-kleines-systemhaus |
| G7 | Pull Request offen, kein Draft, Checks grün | bestanden | PR #29 gegen main, Draft: nein, mergeable: MERGEABLE, Checks: 1 gesamt, 0 fehlgeschlagen, 0 laufend (https://github.com/Reling-IT/relingit/pull/29) |
| G8 | Freigabe durch Bernd | gesperrt | Voraussetzungen fehlen: G6 offen; G3 Sichtung unvollständig (0 Nein, 6 leer); G4 Sichtung unvollständig (0 Nein, 18 leer); G5 Sichtung unvollständig (0 Nein, 2 leer) |

## Gesamtergebnis

Keine automatische Prüfung nicht bestanden. Freigabe erst nach Sichtung und Entscheidung von Bernd (G8).

Sichtungsliste: `SICHTUNG-v1.38.md` (neu angelegt).
