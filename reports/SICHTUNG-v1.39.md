# Sichtung v1.39 (Liste zum Abhaken)

Vorbereitet am 12.11.2026 (R66). Vorlage: `reports/SICHTUNG-v1.38.md` (26 Punkte), ergänzt um die Neuerungen von v1.39. Alle Ergebnisfelder sind leer; ausgefüllt wird in der Vorschau-Sitzung durch den Product Owner.

## Kopf (nach R60 eintragen)

| Feld | Inhalt |
| --- | --- |
| Version | 1.39 |
| Datum der Fassung | _nach R60 eintragen_ (Entscheidung 11.11.: Renderdatum von R60, an allen Stellen gleich) |
| Seitenzahl | _nach R60 eintragen_ (Trockenlauf R63: 80) |
| Paket | _Dateiname nach R60 eintragen_ |
| Paket-Hash (SHA-256) | _nach R60 eintragen_ |
| Basis-Commit | _nach R60 eintragen_ |
| Gesichtet am / von | _Datum_ / Product Owner |

## So wird gesichtet

1. Im Stand nach R60: `./scripts/vorschau.ps1` (öffnet `http://127.0.0.1:8043/index.html`), für das PDF `./scripts/vorschau.ps1 -Pdf`.
2. Breiten 390, 768 und 1280 px über die Entwicklerwerkzeuge des Browsers.
3. Je Punkt Ja oder Nein eintragen, bei Nein eine Bemerkung. Ein Nein sperrt G8, bis es behoben oder ausdrücklich angenommen ist.
4. Vergleichsbilder für die Kontraste: `reports/R41-bilder/*-nachher.png`.

Die Vorschau zeigt die lokale Rückfallfassung des Zweigs und ruft Supabase nicht auf.

## Tor-Stand (nach R60 und nach der Sichtung eintragen)

| Tor | Stand | Beleg |
| --- | --- | --- |
| G1 Code |  |  |
| G2 Kommentare |  |  |
| G3 Layout |  | Liste unten: 15 Punkte |
| G4 UI |  | Liste unten: 28 Punkte |
| G5 Inhalt |  | Liste unten: 13 Punkte |
| G6 Lokal |  |  |
| G7 Git |  |  |
| G8 Freigabe | gesperrt | erteilt nur der Product Owner, nach vollständiger Liste |

## Webseiten (G4 UI)

| Nr | Tor | Bereich | Adresse (Vorschau) | Prüfpunkt / erwartet | Breite | Ergebnis (Ja/Nein) | Bemerkung |
| --- | --- | --- | --- | --- | --- | --- | --- |
| W01 | G4 | Startseite | `/index.html` | Kopf, Version 1.39, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 390 px |  |  |
| W02 | G4 | Startseite | `/index.html` | wie W01 | 768 px |  |  |
| W03 | G4 | Startseite | `/index.html` | wie W01 | 1280 px |  |  |
| W04 | G4 | Lesefassung | `/lesen.html` | Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 390 px |  |  |
| W05 | G4 | Lesefassung | `/lesen.html` | wie W04 | 768 px |  |  |
| W06 | G4 | Lesefassung | `/lesen.html` | wie W04 | 1280 px |  |  |
| W07 | G4 | Handout | `/handout.html` | Handout lädt, Download-Link vorhanden | 390 px |  |  |
| W08 | G4 | Handout | `/handout.html` | wie W07 | 768 px |  |  |
| W09 | G4 | Handout | `/handout.html` | wie W07 | 1280 px |  |  |
| W10 | G4 | Datenschutz | `/datenschutz.html` | vollständig lesbar, nichts abgeschnitten | 390 px |  |  |
| W11 | G4 | Datenschutz | `/datenschutz.html` | wie W10 | 768 px |  |  |
| W12 | G4 | Datenschutz | `/datenschutz.html` | wie W10 | 1280 px |  |  |
| W13 | G4 | Impressum | `/impressum.html` | vollständig lesbar, nichts abgeschnitten | 390 px |  |  |
| W14 | G4 | Impressum | `/impressum.html` | wie W13 | 768 px |  |  |
| W15 | G4 | Impressum | `/impressum.html` | wie W13 | 1280 px |  |  |
| W16 | G4 | Podcast-Player | `/index.html`, Abschnitt Podcast | Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 390 px |  |  |
| W17 | G4 | Podcast-Player | `/index.html`, Abschnitt Podcast | wie W16 | 768 px |  |  |
| W18 | G4 | Podcast-Player | `/index.html`, Abschnitt Podcast | wie W16 | 1280 px |  |  |
| W19 | G4 | **neu:** Anhang-Seite (#26) | `/anhang.html` | Seite lädt den Anhang aus der Buchfassung; alle Anhang-Blöcke vorhanden, auch „Die sieben Standards“; Version 1.39 wie in der Lesefassung (Befund C1) | 390 px |  |  |
| W20 | G4 | **neu:** Anhang-Seite (#26) | `/anhang.html` | wie W19 | 768 px |  |  |
| W21 | G4 | **neu:** Anhang-Seite (#26) | `/anhang.html` | wie W19 | 1280 px |  |  |
| W22 | G4 | **neu:** Bildmarken (#25) | `/index.html`, Kopf und Abschnitt „Worum es geht“ | Bildmarken von Navis und Lumen sichtbar, scharf, nicht verzerrt, Text daneben lesbar | 390 px |  |  |
| W23 | G4 | **neu:** Bildmarken (#25) | `/index.html`, Kopf und Abschnitt „Worum es geht“ | wie W22 | 768 px |  |  |
| W24 | G4 | **neu:** Bildmarken (#25) | `/index.html`, Kopf und Abschnitt „Worum es geht“ | wie W22 | 1280 px |  |  |
| W25 | G4 | **neu:** Handout-Datum (R65) | `/handout.html` | Kopfzeile „Workshop-Handout · Ende November 2026“; im geladenen Handout „Workshop-Vorbereitungsmaterial · Ende November 2026“ | 1280 px |  |  |
| W26 | G4 | **neu:** Handout-PDF (R65) | `/handout.html`, Download | PDF trägt dasselbe Datum wie die HTML-Fassung (Ende November 2026) | - |  |  |
| W27 | G4 | **neu:** Kontraste Lesefassung (#33) | `/lesen.html`, Deckblatt, Personen, eine Szene, Codebox, Versionshistorie | graue und farbige Schrift gut lesbar wie in `R41-bilder/*-nachher.png` | 390 px |  |  |
| W28 | G4 | **neu:** Kontraste Lesefassung (#33) | `/lesen.html`, dieselben Stellen | wie W27 | 1280 px |  |  |

## PDF (G3 Layout)

Adresse: `./scripts/vorschau.ps1 -Pdf` öffnet `story/current/geschichte.pdf` aus der Kopie.

| Nr | Tor | Bereich | Stelle | Prüfpunkt / erwartet | Ergebnis (Ja/Nein) | Bemerkung |
| --- | --- | --- | --- | --- | --- | --- |
| P01 | G3 | PDF: Deckblatt | Seite 1 | Version 1.39, Datum und Hinweis „Neu in v1.39“ stimmen | |  |
| P02 | G3 | PDF: geänderte Szenen | Kaffeeecke, Der Umweg, Die veralteten Daten | beginnen sauber, Überschrift vorhanden, kein abgeschnittener Text | |  |
| P03 | G3 | PDF: Codebox | Der Umweg, „Noras eckige Klammern“ | vollständig, nicht über den Seitenrand, gut lesbar | |  |
| P04 | G3 | PDF: SVG-Seite | Seiten mit Schemagrafiken | Grafik vollständig und scharf | |  |
| P05 | G3 | PDF: Mini-TOC | Deckblatt | alle Einträge vorhanden, auch „Die sieben Standards“; Links springen an die richtige Stelle | |  |
| P06 | G3 | PDF: Seitenzahl | `pdfinfo`, Startseite | Seitenzahl der PDF entspricht der Angabe auf der Startseite (Kopf oben) | |  |
| P07 | G3 | **neu:** Kontrast Codebox (#33) | Der Umweg | wie `R41-bilder/codebox-nachher.png`: Text, Kopfzeile, Schlüsselwörter gut lesbar | |  |
| P08 | G3 | **neu:** Kontrast Deckblatt (#33) | Seite 1 | wie `deckblatt-nachher.png`: Untertitel, Meta-Zeilen, Inhaltsverzeichnis gut lesbar | |  |
| P09 | G3 | **neu:** Kontrast Personen (#33) | Personenliste | wie `personen-nachher.png`: Rolle und Zugehörigkeit lesbar, Initialen-Marken erkennbar | |  |
| P10 | G3 | **neu:** Kontrast SVG-Seite (#33) | „Realer Bezug“ mit Abbildung | wie `svg-seite-nachher.png`: Bildunterschrift und Link lesbar | |  |
| P11 | G3 | **neu:** Kontrast Szene (#33) | eine Szene mit Navis- und Lumen-Box | wie `szene-nachher.png` | |  |
| P12 | G3 | **neu:** Kontrast Versionen (#33) | Versionshistorie | wie `versionen-nachher.png`: Kopfzeile, Datum, Versionsnummer lesbar | |  |
| P13 | G3 | **neu:** Box „Die sieben Standards“ (#27) | Anhang, Anker `kap-sieben-standards` | Box vollständig, kein hässlicher Umbruch, nicht über den Seitenrand | |  |
| P14 | G3 | **neu:** Fußnote ADR/ADG (#27) | Anker `fn-adr`, Rückverweis `fnref-adr` | Fußnote steht an der richtigen Stelle, Hin- und Rücksprung funktionieren | |  |
| P15 | G3 | **neu:** Zeile „(früher ADF)“ (R60) | Begriffsliste | Zeile gut lesbar (Kontrast angehoben, R63 Befund 4) | |  |

## Inhalt (G5 Inhalt)

| Nr | Tor | Bereich | Stelle | Prüfpunkt / erwartet | Ergebnis (Ja/Nein) | Bemerkung |
| --- | --- | --- | --- | --- | --- | --- |
| I01 | G5 | Geänderte Szenen gelesen | Kaffeeecke, Der Umweg, Die veralteten Daten | vollständig gelesen, keine inhaltlichen oder sprachlichen Fehler | |  |
| I02 | G5 | Versionshinweise | Deckblatt und Versionshistorie | Versionshistorie und „Neu in v1.39“ beschreiben die Änderungen zutreffend | |  |
| I03 | G5 | **neu:** Backup-Ticket (R65) | Kaffeeecke, Alarmkanal-Absatz | der Alarm gehört erkennbar zu einem anderen Kunden als Baumann; Wortlaut wie freigegeben (R65-BERICHT.md, Punkt 1) | |  |
| I04 | G5 | **neu:** Baumann unzugewiesen (R65) | Navis meldet sich | Navis sagt weiter „niemand ist aktuell zugewiesen“; kein Widerspruch zur Kaffeeecke | |  |
| I05 | G5 | **neu:** Navis-Zeitangabe (R65) | Der Umweg, „Angefangen hat es vor gut einem Jahr“ | über KI-Assistenten wurde schon länger geredet, Noras Bot vor gut einem Jahr, Navis und Lumen gab es damals im Haus noch nicht (keine Zahl in diesem Kapitel); Noras Ton erhalten | |  |
| I06 | G5 | **neu:** Zweiter Switch (R65) | Die veralteten Daten, am Rack | ein Satz zur Herkunft von Miras Switch; keiner wusste vom anderen; keine Schuldzuweisung | |  |
| I07 | G5 | **neu:** Sysingboard statt Cockpit (R65) | Die veralteten Daten, Navis-Rede und Erzähltext | an beiden Stellen „Sysingboard“; Navis liest nur, schreibt nie | |  |
| I08 | G5 | **neu:** Handout-Datum (R65) | Handout, HTML und PDF | überall „Ende November 2026“, passend zum Deckblatt des Buchs | |  |
| I09 | G5 | **neu:** Versionshistorie v1.39 | Anhang, Versionshistorie, oberste Zeile | Zeile 1.39 nennt Standards-Box, Fußnote, Kontraste und die Textkorrekturen; Datum wie Deckblatt | |  |
| I10 | G5 | **neu:** Box „Die sieben Standards“ (#27) | Anhang | Inhalt der Box richtig; Rückverweis aus dem Text führt zur Box | |  |
| I11 | G5 | **neu:** Fußnote ADR/ADG (#27) | Fußnote | Klarstellung ADR (Dokumenttyp) gegen ADG richtig und verständlich | |  |
| I12 | G5 | **neu:** Datum v1.39 einheitlich | Deckblatt, Versionshistorie, Rückfallwerte der Webseite, Paketname | überall dasselbe Datum (Renderdatum R60; fünf Stellen laut R63-BERICHT.md) | |  |
| I13 | G5 | **neu:** Seitenzahl einheitlich | PDF (`pdfinfo`), Startseite, `story/current`, Rückfallwert in `assets/js/app.js` | überall dieselbe Seitenzahl wie im Kopf dieser Liste (das Deckblatt selbst trägt keine Seitenzahl, R63) | |  |

## Entscheidung Product Owner (G8)

| Feld | Inhalt |
| --- | --- |
| Datum |  |
| Wortlaut |  |
| Paket und Hash |  |
| Basis |  |
