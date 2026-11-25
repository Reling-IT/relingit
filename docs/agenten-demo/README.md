# Navis und Lumen als Demo (Entwurf)

Stand: 25.11.2026. Wegwerf-Versuch aus einer KI-Sitzung, abgelegt, damit er nicht verloren geht.
Kein Teil der Webseite, nicht im Upload-Paket, nicht freigegeben.

## Was das ist

Zwei kleine Agenten beantworten Fragen zum Buch „Die Fahrt zum Kunden“ (v1.40), nur aus dem Buch,
per Text oder Sprache. Die Demo zeigt, was ein Agent technisch ist und wo seine Grenzen liegen.
Reling IT ist frei erfunden; das Buch und alle Apps dahinter arbeiten ausschließlich mit erfundenen
Demodaten.

## Dateien

| Datei | Inhalt |
|---|---|
| `navis-lumen.html.txt` | Die Demo-Seite: Reiter Gespräch, Anhang (Technik und Risiken), Status, Datenschutz |
| `buch.json` | Der Buchtext v1.40 als 36 Abschnitte (`nr`, `titel`, `teil`, `text`), abgeleitet aus `story/current/fahrt-zum-kunden.html` |
| `projektseite-reiter-demo.html.txt` | Baustein für die private Abstimmungsseite: Reiter „Navis & Lumen Demo“ |
| `projektseite-reiter-umsetzungsideen.html.txt` | Baustein für die private Abstimmungsseite: Reiter „Umsetzungsideen 2.0“ |

Die Bildmarken der beiden Figuren liegen schon im Repository: `assets/img/avatare/navis.svg` und
`assets/img/avatare/lumen.svg`.

## So läuft die Demo

Die Seite ist ein Claude-Artifact. Sie läuft nicht als gewöhnliche Webseite, weil sie drei Fähigkeiten
der Plattform braucht: Claude fragen (`sample`), vorlesen (`tts`) und Spracheingabe (`dictation`).

Veröffentlichen aus einer Claude-Code-Sitzung:

- Seite: `navis-lumen.html.txt`, vor dem Veröffentlichen als `navis-lumen.html` kopieren
- Beigelegte Dateien: `buch.json`, dazu `navis.svg` und `lumen.svg` aus `assets/img/avatare/`
- Fähigkeiten: `sample`, `tts`, `dictation`

Die Fragen laufen über das Claude-Konto der Person, die die Seite öffnet. Es gibt keinen Schlüssel
und keine Zugangsdaten in diesen Dateien.

## Stand und Grenzen

- Nur auf Syntax geprüft (`node --check` für das Skript). Nicht im Browser durchgetestet.
- Die Suche findet die Versionshistorie zu oft. Nicht behoben.
- `buch.json` wurde in der Sitzung von Hand erzeugt. Ein Skript dafür liegt nicht vor. Bei einer
  neuen Buchfassung muss die Datei neu erzeugt werden.
- Die Token im Reiter Status sind eine Schätzung (Zeichen geteilt durch 3). Die Plattform meldet
  der Seite keine Tokenzahlen.
- Der Reiter „Anhang“ ist ein Entwurf für den Buchanhang. Er ist nicht geprüft und nicht im Buch.
- Der Reiter „Datenschutz“ nennt Quellen mit Abrufdatum 25.11.2026. Er ist keine Rechtsberatung.
- Die Anbindung an Sysingboard und Reports ist nur beschrieben, nicht gebaut.

## Abgleich mit dem Buchanhang (25.11.2026)

Eine unabhängige Prüfung hat den bisherigen Anhang des Buchs (Teil 2) mit der Demo verglichen.
Ergebnis: Die Grundregeln decken sich (nur lesen, nichts raten, Quelle nennen, der Mensch
entscheidet). Der Aufbau weicht ab; der Reiter „Anhang“ der Demo führt die Unterschiede auf.

Offene Punkte für das Buch, als Vorschlag, nicht entschieden:

1. Abschnitt 22 nennt vier Bausteine (Trainiertes Wissen, Tools, Skills, MCP). Die Demo spricht
   von „Harness“. Der Begriff fehlt im Buch.
2. Abschnitt 26 beschreibt den Stand des Sysingboards vom 06.11.2026 (Daten teils noch im Browser).
   Die Nachschau vom 25.11.2026 fand Lesesichten in der Datenbank. Der Stand im Buch ist zu prüfen.
3. Abschnitt 22 sagt, ein Betrieb des Sprachmodells „nachweislich in Europa“ sei möglich. Nach den
   Unterlagen des Anbieters vom 25.11.2026 gilt das nur über Cloud-Plattformen Dritter. Der Satz
   ist zu präzisieren.
4. Abschnitt 21 und das Architekturbild der Reportfamilie nennen verschiedene Andockpunkte für
   Lumen (Hub oder Areport). Nicht entschieden.

## Nächste Schritte (Vorschlag)

- Demo im Browser testen, Rückmeldungen einarbeiten.
- Reiter „Anhang“ durchsehen; danach entscheiden, ob er in die nächste Buchfassung kommt.
- Vor jeder Fassung für Dritte: die Schritte im Reiter „Datenschutz“, Abschnitt 10.

## Warum `.html.txt`

Die CI-Prüfung behandelt jede `.html`-Datei im Repository als Seite der Webseite (keine externen
Schriften, alle lokalen Verweise vorhanden). Die Demo ist keine Seite der Webseite. Deshalb liegen
die drei Dateien wie `docs/vorlagen/KAPITEL-VORLAGE.html.txt` mit der Endung `.html.txt` hier.
