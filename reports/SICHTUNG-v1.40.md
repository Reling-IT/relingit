# Sichtungsliste v1.40

Erzeugt: 2026-11-16 08:01 von scripts/freigabe-pruefen.ps1. Branch: auftrag-R86-v140, Commit: 2779a95.

Ablauf: Vorschau mit `./scripts/vorschau.ps1` starten (nur 127.0.0.1, Beenden mit Strg+C). Breite im Browser über die Entwicklerwerkzeuge einstellen (Strg+Umschalt+I, dann Strg+Umschalt+M). Die PDF liegt unter `story/current/geschichte.pdf` (`./scripts/vorschau.ps1 -Pdf`).

In der Spalte Ergebnis genau **Ja** oder **Nein** eintragen, bei Nein eine Bemerkung. Diese Liste ist der Nachweis für G3 Layout, G4 UI und G5 Inhalt (docs/FREIGABE.md). Solange ein Punkt Nein oder leer ist, bleibt G8 gesperrt. Das Skript überschreibt diese Datei nicht.

## Webseiten (G4 UI)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| W01 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W02 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 768 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W03 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 1280 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W04 | G4 | Lesefassung | lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W05 | G4 | Lesefassung | lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 768 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W06 | G4 | Lesefassung | lesen.html: Geschichte lädt, Inhaltsverzeichnis springt zu den Kapiteln | 1280 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W07 | G4 | Handout | handout.html: Handout lädt, Download-Link vorhanden | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W08 | G4 | Handout | handout.html: Handout lädt, Download-Link vorhanden | 768 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W09 | G4 | Handout | handout.html: Handout lädt, Download-Link vorhanden | 1280 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W10 | G4 | Datenschutz | datenschutz.html: vollständig lesbar, nichts abgeschnitten | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W11 | G4 | Datenschutz | datenschutz.html: vollständig lesbar, nichts abgeschnitten | 768 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W12 | G4 | Datenschutz | datenschutz.html: vollständig lesbar, nichts abgeschnitten | 1280 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W13 | G4 | Impressum | impressum.html: vollständig lesbar, nichts abgeschnitten | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W14 | G4 | Impressum | impressum.html: vollständig lesbar, nichts abgeschnitten | 768 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W15 | G4 | Impressum | impressum.html: vollständig lesbar, nichts abgeschnitten | 1280 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W16 | G4 | Podcast-Player | index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W17 | G4 | Podcast-Player | index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 768 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| W18 | G4 | Podcast-Player | index.html, Abschnitt Podcast: Player und Cover sichtbar, Quellenangabe Google NotebookLM (ohne lokale MP3 nur Darstellung) | 1280 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |

## PDF (G3 Layout)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| P01 | G3 | PDF: Deckblatt | Version 1.40, Datum und Hinweis Neu in v1.40 stimmen | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| P02 | G3 | PDF: Neue Szene | beginnt sauber, Überschrift vorhanden, kein abgeschnittener Text | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| P03 | G3 | PDF: Codebox | vollständig, nicht über den Seitenrand, gut lesbar | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| P04 | G3 | PDF: SVG-Seite | Grafik vollständig und scharf | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| P05 | G3 | PDF: Mini-TOC | alle Einträge vorhanden, Links springen an die richtige Stelle | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| P06 | G3 | PDF: Seitenzahl | Seitenzahl der PDF entspricht der Angabe auf der Startseite (80) | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |

## Inhalt (G5 Inhalt)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| I01 | G5 | Neue Szene gelesen | neue Szene vollständig gelesen, keine inhaltlichen oder sprachlichen Fehler | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| I02 | G5 | Versionshinweise | Versionshistorie und Neu in v1.40 beschreiben die Änderungen zutreffend | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |

## Änderungen v1.40 (ergänzt von Claude, gleiche Spalten)

| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| V01 | G5 | Kap. 3 „Der klare Auftrag“ | PDF S. 9: neuer Einstieg Reiner (Entwurf PO) liest sich, Anschluss „Petra hat ihm das damals …“ trägt | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| V02 | G5 | Kap. 4 „Die Freigabegrenze“ | PDF S. 10: neuer Einstieg Insa (Vorschlag 1), Anschluss „Sie ist ungefähr zeitgleich …“ trägt | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| V03 | G5 | Inhaltsverzeichnis | PDF S. 2: Teil 1 in „Vor der Fahrt“, „Unterwegs“, „Am Ziel“ (Ankunft bis Warum Navis und Lumen), „Danach“ (Kurz vor neun bis Ankunft, noch einmal); Einteilung ab „Ankunft“ ist ein Vorschlag von Claude | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| V04 | G3 | Kasten „Aufbau in zwei Teilen“ | PDF S. 3: Satz „Die Fahrt beginnt mit dem Kapitel ‚Aufbruch‘.“, Link springt auf S. 13 | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| V05 | G5 | Handout | Einleitung „In der Geschichte: …“ neu (Navis, Lumen, Mira; vorher „Vorhersage-Modell“), Fußzeile „(Fassung 1.40)“, PDF 2 Seiten | - | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
| V06 | G4 | Startseite, Trailer | Restpunkt aus v1.39: Trailer in Safari/iOS und mit „Bewegung reduzieren“ (nur Standbild) | 390 px | Ja | Product Owner 16.11.2026 im Chat: „Sichtung positiv - passt“ |
