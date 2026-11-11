# Sichtung v1.38 (Stand und Liste)

## Stand 11.11.2026 (R61)

Paket: `relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, SHA-256 `76692313…984C`, inhaltsgleich mit main 8abe213.

| Tor | Stand | Beleg |
|---|---|---|
| G1 Code | erfüllt | freigabe-pruefen.ps1 auf main 8abe213, 11.11. 06:04 |
| G2 Kommentare | erfüllt | R50-FREIGABE-v1.38.md (b1cbea1, gleicher Baum wie main) |
| G3 Layout | offen | Liste unten: 6 Punkte leer |
| G4 UI | offen | Liste unten: 18 Punkte leer |
| G5 Inhalt | offen | Liste unten: 2 Punkte leer |
| G6 Lokal | nicht zutreffend | Paket ohne Audio, Entscheidung des Product Owners 09.11. |
| G7 Git | erfüllt | R50-FREIGABE-v1.38.md (PR #29, gleicher Baum wie main) |
| G8 Freigabe | gesperrt | erteilt nur der Product Owner, nach vollständiger Liste |

Die Liste unten ist die von `scripts/freigabe-pruefen.ps1` erzeugte Vorlage. Bitte auf main 8abe213 sichten (`./scripts/vorschau.ps1`, PDF mit `-Pdf`) und je Punkt Ja oder Nein eintragen.

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

## Entscheidung Product Owner 11.11.2026

| Feld | Inhalt |
|---|---|
| Datum | 11.11.2026, 06:17 |
| Wortlaut (laut Auftrag R64) | „G8 wird erteilt. Die manuelle Sichtung vom 09.11.2026 (G3 bis G5) war positiv und gilt; die 26 Punkte der Liste wurden nicht abgehakt.“ Am 11.11. ausdrücklich bestätigt. |
| Quelle | queue/R64.yaml auf ops/queue, Commit 103c0f6 (Planer-Sitzung, nicht signiert); verbucht von Claude Code (R64) |
| Paket | `relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, SHA-256 `766923139AD9955DCBAB3678783DBCEC96FFA91E0CDA2F8CF945D554542C984C`, 36 Einträge |
| Basis | main 8abe213 (Paketinhalt gleich main, R61; Manifest gleich ZIP, R62) |

Tor-Stand nach der Entscheidung:

| Tor | Stand | Grundlage |
|---|---|---|
| G1 Code | erfüllt | freigabe-pruefen.ps1 auf main 8abe213 (R61) |
| G2 Kommentare | erfüllt | R50-FREIGABE-v1.38.md, gleicher Baum wie main |
| G3 Layout | bestätigt durch Sichtung 09.11. | Entscheidung oben; Liste oben bewusst nicht abgehakt |
| G4 UI | bestätigt durch Sichtung 09.11. | wie G3 |
| G5 Inhalt | bestätigt durch Sichtung 09.11. | wie G3 |
| G6 Lokal | nicht zutreffend | Paket ohne Audio, Entscheidung 09.11. |
| G7 Git | erfüllt | R50-FREIGABE-v1.38.md (PR #29), gleicher Baum wie main |
| G8 Freigabe | **erteilt** | Entscheidung oben |

Bekannt: `freigabe-pruefen.ps1` meldet auf main weiter G8 „gesperrt“, weil es G2 und G7 auf main nicht prüfen kann, G6 ohne R54 (#31) als offen führt und die Liste leer ist (R61, Befund F2). Die Entscheidung oben ersetzt diesen Lauf für v1.38; die Liste bleibt als Vorlage für künftige Versionen unverändert.
