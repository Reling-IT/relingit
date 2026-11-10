# Sichtungsliste v1.38

Erzeugt: 2026-11-09 06:01 von scripts/freigabe-pruefen.ps1. Branch: auftrag-R50-kleines-systemhaus, Commit: b1cbea1.

Ablauf: Vorschau mit `./scripts/vorschau.ps1` starten (nur 127.0.0.1, Beenden mit Strg+C). Breite im Browser über die Entwicklerwerkzeuge einstellen (Strg+Umschalt+I, dann Strg+Umschalt+M). Die PDF liegt unter `story/current/geschichte.pdf` (`./scripts/vorschau.ps1 -Pdf`).

In der Spalte Ergebnis genau **Ja** oder **Nein** eintragen, bei Nein eine Bemerkung. Diese Liste ist der Nachweis für G3 Layout, G4 UI und G5 Inhalt (docs/FREIGABE.md). Solange ein Punkt Nein oder leer ist, bleibt G8 gesperrt. Das Skript überschreibt diese Datei nicht.

## Webseiten (G4 UI)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| W01 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 390 px |  |  |
| W02 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 768 px |  |  |
| W03 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 1280 px |  |  |
| W04 | G4 | Lesefassung | lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 390 px |  |  |
| W05 | G4 | Lesefassung | lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 768 px |  |  |
| W06 | G4 | Lesefassung | lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 1280 px |  |  |
| W07 | G4 | Handout | handout.html: Handout lädt, Download-Link vorhanden | 390 px |  |  |
| W08 | G4 | Handout | handout.html: Handout lädt, Download-Link vorhanden | 768 px |  |  |
| W09 | G4 | Handout | handout.html: Handout lädt, Download-Link vorhanden | 1280 px |  |  |
| W10 | G4 | Datenschutz | datenschutz.html: vollständig lesbar, nichts abgeschnitten | 390 px |  |  |
| W11 | G4 | Datenschutz | datenschutz.html: vollständig lesbar, nichts abgeschnitten | 768 px |  |  |
| W12 | G4 | Datenschutz | datenschutz.html: vollständig lesbar, nichts abgeschnitten | 1280 px |  |  |
| W13 | G4 | Impressum | impressum.html: vollständig lesbar, nichts abgeschnitten | 390 px |  |  |
| W14 | G4 | Impressum | impressum.html: vollständig lesbar, nichts abgeschnitten | 768 px |  |  |
| W15 | G4 | Impressum | impressum.html: vollständig lesbar, nichts abgeschnitten | 1280 px |  |  |
| W16 | G4 | Podcast-Player | index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 390 px |  |  |
| W17 | G4 | Podcast-Player | index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 768 px |  |  |
| W18 | G4 | Podcast-Player | index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 1280 px |  |  |

## PDF (G3 Layout)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| P01 | G3 | PDF: Deckblatt | Version 1.38, Datum und Hinweis Neu in v1.38 stimmen | - |  |  |
| P02 | G3 | PDF: Neue Szene | beginnt sauber, Überschrift vorhanden, kein abgeschnittener Text | - |  |  |
| P03 | G3 | PDF: Codebox | vollständig, nicht über den Seitenrand, gut lesbar | - |  |  |
| P04 | G3 | PDF: SVG-Seite | Grafik vollständig und scharf | - |  |  |
| P05 | G3 | PDF: Mini-TOC | alle Einträge vorhanden, Links springen an die richtige Stelle | - |  |  |
| P06 | G3 | PDF: Seitenzahl | Seitenzahl der PDF entspricht der Angabe auf der Startseite (77) | - |  |  |

## Inhalt (G5 Inhalt)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| I01 | G5 | Neue Szene gelesen | neue Szene vollständig gelesen, keine inhaltlichen oder sprachlichen Fehler | - |  |  |
| I02 | G5 | Versionshinweise | Versionshistorie und Neu in v1.38 beschreiben die Änderungen zutreffend | - |  |  |
