# Sichtung v1.39 (Liste zum Abhaken)

Vorbereitet am 12.11.2026 (R66). Vorlage: `reports/SICHTUNG-v1.38.md` (26 Punkte), ergänzt um die Neuerungen von v1.39. Alle Ergebnisfelder sind leer; ausgefüllt wird in der Vorschau-Sitzung durch den Product Owner.

## Kopf (nach R60 eintragen)

| Feld | Inhalt |
| --- | --- |
| Version | 1.39 |
| Datum der Fassung | 15.11.2026 (Renderdatum nach Korrekturen in der Sichtung, vom Product Owner am 15.11. bestätigt; R60 hatte 14.11.2026) |
| Seitenzahl | 80 (`pdfinfo`) |
| Paket | `relingit-upload-v1.39-2026-11-15-ohne-audio.zip` (Worktree `C:\dev\wt\relingit\r60\output\ftp`) |
| Paket-Hash (SHA-256) | `6E48827B3C69CC57C7CF20531327EAC7645E0A62587F16C469189205C75C1B98` |
| Basis-Commit | PR #37, Head a470a41 (main 69cae23 plus #27, #33, #35, R60 e31c893 und vier Korrekturen aus der Sichtung) |
| Gesichtet am / von | 15.11.2026 / Product Owner (begleitet von einer KI-Sitzung, Claude Code) |

## So wird gesichtet

1. Im Stand nach R60: `./scripts/vorschau.ps1` (öffnet `http://127.0.0.1:8043/index.html`), für das PDF `./scripts/vorschau.ps1 -Pdf`.
2. Breiten 390, 768 und 1280 px über die Entwicklerwerkzeuge des Browsers.
3. Je Punkt Ja oder Nein eintragen, bei Nein eine Bemerkung. Ein Nein sperrt G8, bis es behoben oder ausdrücklich angenommen ist.
4. Vergleichsbilder für die Kontraste: `reports/R41-bilder/*-nachher.png`.

Die Vorschau zeigt die lokale Rückfallfassung des Zweigs und ruft Supabase nicht auf.

## Tor-Stand (nach R60 und nach der Sichtung eintragen)

| Tor | Stand | Beleg |
| --- | --- | --- |
| G1 Code | bestanden | `freigabe-pruefen.ps1` 15.11.2026 auf a470a41: ci-check, node --check, Pester 54 bestanden, 0 fehlgeschlagen |
| G2 Kommentare | bestanden | `freigabe-pruefen.ps1`: Skriptköpfe, kein Review mit Änderungswunsch |
| G3 Layout | vollständig, Bestätigung mit G8 | Liste unten: 15 von 15 Ja (`freigabe-pruefen.ps1`: 0 Nein, 0 leer) |
| G4 UI | vollständig, Bestätigung mit G8 | Liste unten: 28 von 28 Ja (`freigabe-pruefen.ps1`: 0 Nein, 0 leer) |
| G5 Inhalt | vollständig, Bestätigung mit G8 | Liste unten: 13 von 13 Ja (`freigabe-pruefen.ps1`: 0 Nein, 0 leer) |
| G6 Lokal | bestanden | Podcast-MP3: nicht zutreffend (Paket ohne Audio); Vorschau möglich |
| G7 Git | offen | sauber, Branch gleich origin, CI grün; PR #37 ist noch Draft |
| G8 Freigabe | gesperrt | erteilt nur der Product Owner, nach vollständiger Liste |

## Seitenverweise im PDF (R60, 14.11.2026)

Ermittelt mit `pdftotext` je Seite aus `story/current/geschichte.pdf` auf #37 (80 Seiten). Hilfe zum Auffinden, keine Prüfung.

| Punkt | Stelle | Seite |
| --- | --- | --- |
| P01, P05, P08, I02 | Deckblatt, „Neu in v1.39“, Mini-TOC mit „Die sieben Standards“ | 1–2 |
| P09 | Personenliste | 4 |
| I03 | Kaffeeecke, Alarmkanal-Absatz (Backup-Ticket) | 6 |
| I05 | Der Umweg, „Angefangen hat es vor gut einem Jahr“ | 7 |
| I04 | Navis meldet sich, „niemand ist aktuell zugewiesen“ | 14 |
| – | Kapitel Warum Navis und Lumen, „kleines Systemhaus“ (R50) | 28 |
| I07 | Die veralteten Daten, Navis-Rede (Sysingboard) | 33 |
| I06 | Die veralteten Daten, am Rack (zweiter Switch) | 34 |
| P15, P14, I11 | Begriffsliste „(früher ADF)“ und Fußnote ADR/ADG | 43 |
| P03, P07 | Codebox „Noras eckige Klammern“ | 8 (korrigiert 15.11.; auf Seite 44 steht nur der Rückbezug) |
| – | Einordnungsabsatz vor den Architekturbildern (R69 Nr. 2, aus #35) | 57 |
| – | „Functional is not Done“ auf die echten Apps bezogen, CI-Abschnitt (R69 Nr. 1, aus #35) | 60–61 |
| P13, I10 | Verweis auf die Box (62), Box „Die neun Standards“ | 62, 63–64 |
| P10 | „Realer Bezug“ mit Abbildung, „So ist es tatsächlich gedacht“ | 36 (korrigiert 15.11.) |
| P12, I09 | Versionshistorie, Zeile 1.39 | 80 (nach a470a41) |

Nicht einzeln zugeordnet: P04 (Seiten mit Schemagrafiken, ab Seite 57) und P11 (beliebige Szene mit Navis- und Lumen-Box, z. B. Seite 14).

## Webseiten (G4 UI)

| Nr | Tor | Bereich, Adresse (Vorschau) | Prüfpunkt / erwartet | Breite | Ergebnis (Ja/Nein) | Bemerkung |
| --- | --- | --- | --- | --- | --- | --- |
| W01 | G4 | Startseite, `/index.html` | Kopf, Version 1.39, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 390 px | Ja | Navigation unter 800 px bewusst ausgeblendet (styles.css, seit 30.08.2026), wie live |
| W02 | G4 | Startseite, `/index.html` | wie W01 | 768 px | Ja | wie W01 |
| W03 | G4 | Startseite, `/index.html` | wie W01 | 1280 px | Ja | |
| W04 | G4 | Lesefassung, `/lesen.html` | Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 390 px | Ja | |
| W05 | G4 | Lesefassung, `/lesen.html` | wie W04 | 768 px | Ja | |
| W06 | G4 | Lesefassung, `/lesen.html` | wie W04 | 1280 px | Ja | |
| W07 | G4 | Handout, `/handout.html` | Handout lädt, Download-Link vorhanden | 390 px | Ja | Download-Link auf der Startseite und auf handout-pdf.html, nicht auf handout.html (so seit v1.38); Prüfpunkt für die nächste Version anpassen |
| W08 | G4 | Handout, `/handout.html` | wie W07 | 768 px | Ja | wie W07 |
| W09 | G4 | Handout, `/handout.html` | wie W07 | 1280 px | Ja | wie W07 |
| W10 | G4 | Datenschutz, `/datenschutz.html` | vollständig lesbar, nichts abgeschnitten | 390 px | Ja | |
| W11 | G4 | Datenschutz, `/datenschutz.html` | wie W10 | 768 px | Ja | |
| W12 | G4 | Datenschutz, `/datenschutz.html` | wie W10 | 1280 px | Ja | |
| W13 | G4 | Impressum, `/impressum.html` | vollständig lesbar, nichts abgeschnitten | 390 px | Ja | |
| W14 | G4 | Impressum, `/impressum.html` | wie W13 | 768 px | Ja | |
| W15 | G4 | Impressum, `/impressum.html` | wie W13 | 1280 px | Ja | |
| W16 | G4 | Podcast-Player, `/index.html`, Abschnitt Podcast | Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 390 px | Ja | ohne lokale MP3 nur Darstellung |
| W17 | G4 | Podcast-Player, `/index.html`, Abschnitt Podcast | wie W16 | 768 px | Ja | wie W16 |
| W18 | G4 | Podcast-Player, `/index.html`, Abschnitt Podcast | wie W16 | 1280 px | Ja | wie W16 |
| W19 | G4 | **neu:** Anhang-Seite (#26), `/anhang.html` | Seite lädt den Anhang aus der Buchfassung; alle Anhang-Blöcke vorhanden, auch „Die sieben Standards“; Version 1.39 wie in der Lesefassung (Befund C1) | 390 px | Ja | neun Standards mit IAM und REST (8a54375) |
| W20 | G4 | **neu:** Anhang-Seite (#26), `/anhang.html` | wie W19 | 768 px | Ja | wie W19 |
| W21 | G4 | **neu:** Anhang-Seite (#26), `/anhang.html` | wie W19 | 1280 px | Ja | wie W19 |
| W22 | G4 | **neu:** Bildmarken (#25), `/index.html`, Kopf und Abschnitt „Worum es geht“ | Bildmarken von Navis und Lumen sichtbar, scharf, nicht verzerrt, Text daneben lesbar | 390 px | Ja | |
| W23 | G4 | **neu:** Bildmarken (#25), `/index.html`, Kopf und Abschnitt „Worum es geht“ | wie W22 | 768 px | Ja | |
| W24 | G4 | **neu:** Bildmarken (#25), `/index.html`, Kopf und Abschnitt „Worum es geht“ | wie W22 | 1280 px | Ja | |
| W25 | G4 | **neu:** Handout-Datum (R65), `/handout.html` | Kopfzeile „Workshop-Handout · Ende November 2026“; im geladenen Handout „Workshop-Vorbereitungsmaterial · Ende November 2026“ | 1280 px | Ja | Startseite ebenfalls korrigiert (531b42a) |
| W26 | G4 | **neu:** Handout-PDF (R65), `/handout.html`, Download | PDF trägt dasselbe Datum wie die HTML-Fassung (Ende November 2026) | - | Ja | |
| W27 | G4 | **neu:** Kontraste Lesefassung (#33), `/lesen.html`, Deckblatt, Personen, eine Szene, Codebox, Versionshistorie | graue und farbige Schrift gut lesbar wie in `R41-bilder/*-nachher.png` | 390 px | Ja | Farbwerte im CSS gleich R41 (ecfbebb) |
| W28 | G4 | **neu:** Kontraste Lesefassung (#33), `/lesen.html`, dieselben Stellen | wie W27 | 1280 px | Ja | wie W27 |

## PDF (G3 Layout)

Adresse: `./scripts/vorschau.ps1 -Pdf` öffnet `story/current/geschichte.pdf` aus der Kopie.

| Nr | Tor | Bereich | Stelle | Prüfpunkt / erwartet | Ergebnis (Ja/Nein) | Bemerkung |
| --- | --- | --- | --- | --- | --- | --- |
| P01 | G3 | PDF: Deckblatt | Seite 1 | Version 1.39, Datum und Hinweis „Neu in v1.39“ stimmen | Ja | |
| P02 | G3 | PDF: geänderte Szenen | Kaffeeecke, Der Umweg, Die veralteten Daten | beginnen sauber, Überschrift vorhanden, kein abgeschnittener Text | Ja | belegt durch verify_layout (Überschriften, Ränder, Umbrüche) |
| P03 | G3 | PDF: Codebox | Der Umweg, „Noras eckige Klammern“ | vollständig, nicht über den Seitenrand, gut lesbar | Ja | Seite 8 |
| P04 | G3 | PDF: SVG-Seite | Seiten mit Schemagrafiken | Grafik vollständig und scharf | Ja | |
| P05 | G3 | PDF: Mini-TOC | Deckblatt | alle Einträge vorhanden, auch „Die sieben Standards“; Links springen an die richtige Stelle | Ja | alle 39 Links mit Zielseite, Die neun Standards → Seite 63 |
| P06 | G3 | PDF: Seitenzahl | `pdfinfo`, Startseite | Seitenzahl der PDF entspricht der Angabe auf der Startseite (Kopf oben) | Ja | |
| P07 | G3 | **neu:** Kontrast Codebox (#33) | Der Umweg | wie `R41-bilder/codebox-nachher.png`: Text, Kopfzeile, Schlüsselwörter gut lesbar | Ja | Seite 8 |
| P08 | G3 | **neu:** Kontrast Deckblatt (#33) | Seite 1 | wie `deckblatt-nachher.png`: Untertitel, Meta-Zeilen, Inhaltsverzeichnis gut lesbar | Ja | |
| P09 | G3 | **neu:** Kontrast Personen (#33) | Personenliste | wie `personen-nachher.png`: Rolle und Zugehörigkeit lesbar, Initialen-Marken erkennbar | Ja | |
| P10 | G3 | **neu:** Kontrast SVG-Seite (#33) | „Realer Bezug“ mit Abbildung | wie `svg-seite-nachher.png`: Bildunterschrift und Link lesbar | Ja | Seite 36 |
| P11 | G3 | **neu:** Kontrast Szene (#33) | eine Szene mit Navis- und Lumen-Box | wie `szene-nachher.png` | Ja | |
| P12 | G3 | **neu:** Kontrast Versionen (#33) | Versionshistorie | wie `versionen-nachher.png`: Kopfzeile, Datum, Versionsnummer lesbar | Ja | Zeile 1.39 nach Korrektur a470a41 vollständig auf Seite 80 |
| P13 | G3 | **neu:** Box „Die sieben Standards“ (#27) | Anhang, Anker `kap-sieben-standards` | Box vollständig, kein hässlicher Umbruch, nicht über den Seitenrand | Ja | Seiten 63–64; getrennter DSG-Eintrag behoben (90ecfd3) |
| P14 | G3 | **neu:** Fußnote ADR/ADG (#27) | Anker `fn-adr`, Rückverweis `fnref-adr` | Fußnote steht an der richtigen Stelle, Hin- und Rücksprung funktionieren | Ja | Hin- und Rücksprung auf Seite 43 |
| P15 | G3 | **neu:** Zeile „(früher ADF)“ (R60) | Begriffsliste | Zeile gut lesbar (Kontrast angehoben, R63 Befund 4) | Ja | |

## Inhalt (G5 Inhalt)

| Nr | Tor | Bereich | Stelle | Prüfpunkt / erwartet | Ergebnis (Ja/Nein) | Bemerkung |
| --- | --- | --- | --- | --- | --- | --- |
| I01 | G5 | Geänderte Szenen gelesen | Kaffeeecke, Der Umweg, Die veralteten Daten | vollständig gelesen, keine inhaltlichen oder sprachlichen Fehler | Ja | |
| I02 | G5 | Versionshinweise | Deckblatt und Versionshistorie | Versionshistorie und „Neu in v1.39“ beschreiben die Änderungen zutreffend | Ja | |
| I03 | G5 | **neu:** Backup-Ticket (R65) | Kaffeeecke, Alarmkanal-Absatz | der Alarm gehört erkennbar zu einem anderen Kunden als Baumann; Wortlaut wie freigegeben (R65-BERICHT.md, Punkt 1) | Ja | |
| I04 | G5 | **neu:** Baumann unzugewiesen (R65) | Navis meldet sich | Navis sagt weiter „niemand ist aktuell zugewiesen“; kein Widerspruch zur Kaffeeecke | Ja | |
| I05 | G5 | **neu:** Navis-Zeitangabe (R65) | Der Umweg, „Angefangen hat es vor gut einem Jahr“ | über KI-Assistenten wurde schon länger geredet, Noras Bot vor gut einem Jahr, Navis und Lumen gab es damals im Haus noch nicht (keine Zahl in diesem Kapitel); Noras Ton erhalten | Ja | |
| I06 | G5 | **neu:** Zweiter Switch (R65) | Die veralteten Daten, am Rack | ein Satz zur Herkunft von Miras Switch; keiner wusste vom anderen; keine Schuldzuweisung | Ja | |
| I07 | G5 | **neu:** Sysingboard statt Cockpit (R65) | Die veralteten Daten, Navis-Rede und Erzähltext | an beiden Stellen „Sysingboard“; Navis liest nur, schreibt nie | Ja | |
| I08 | G5 | **neu:** Handout-Datum (R65) | Handout, HTML und PDF | überall „Ende November 2026“, passend zum Deckblatt des Buchs | Ja | Startseite korrigiert (531b42a) |
| I09 | G5 | **neu:** Versionshistorie v1.39 | Anhang, Versionshistorie, oberste Zeile | Zeile 1.39 nennt Standards-Box, Fußnote, Kontraste und die Textkorrekturen; Datum wie Deckblatt | Ja | |
| I10 | G5 | **neu:** Box „Die sieben Standards“ (#27) | Anhang | Inhalt der Box richtig; Rückverweis aus dem Text führt zur Box | Ja | neun Standards; Wortlaut IAM und REST vom Product Owner bestätigt; Verweis Seite 62 → 63 |
| I11 | G5 | **neu:** Fußnote ADR/ADG (#27) | Fußnote | Klarstellung ADR (Dokumenttyp) gegen ADG richtig und verständlich | Ja | deckt sich mit ADG-README (Alias ADR endet 2027-06-30) |
| I12 | G5 | **neu:** Datum v1.39 einheitlich | Deckblatt, Versionshistorie, Rückfallwerte der Webseite, Paketname | überall dasselbe Datum (Renderdatum R60; fünf Stellen laut R63-BERICHT.md) | Ja | 15.11.2026 bzw. 15. November 2026 an allen Stellen |
| I13 | G5 | **neu:** Seitenzahl einheitlich | PDF (`pdfinfo`), Startseite, `story/current`, Rückfallwert in `assets/js/app.js` | überall dieselbe Seitenzahl wie im Kopf dieser Liste (das Deckblatt selbst trägt keine Seitenzahl, R63) | Ja | 80 |

## Änderungen während der Sichtung (15.11.2026)

Je Änderung eine Entscheidung des Product Owners in der Sitzung, Commit auf PR #37:

| Commit | Änderung | Anlass |
| --- | --- | --- |
| 531b42a | Startseite: Handout „Ende November 2026“ statt „September 2026“ | I08 |
| 8a54375 | Anhang-Box „Die neun Standards“ mit IAM und REST (Wortlaut bestätigt), Fassung 15.11.2026, neu gerendert | Hinweis des Product Owners: zwei neue Standards seit 12.11. |
| 90ecfd3 | `.defitem{break-inside:avoid}`: DSG-Eintrag nicht mehr über Seite 63/64 getrennt | P13 |
| a470a41 | `.vtable tbody tr:last-child{break-inside:avoid}`: Zeile 1.39 nicht über Seite 79/80 getrennt (Variante für alle Zeilen ergab 85 Seiten, verworfen) | P12 |

Webseiten-Tabelle: Spalten „Bereich“ und „Adresse“ zusammengelegt, weil `freigabe-pruefen.ps1` das Ergebnis aus der sechsten Spalte liest.

## Entscheidung Product Owner (G8)

| Feld | Inhalt |
| --- | --- |
| Datum |  |
| Wortlaut |  |
| Paket und Hash |  |
| Basis |  |
