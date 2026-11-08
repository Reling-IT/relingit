---
id: R38
titel: 'Sollte- und Kann-Befunde (R19/R32) mit den Antworten von Bernd auf PR #10 umgesetzt'
status: erledigt
start: 2026-11-08T05:10+01:00
ende: 2026-11-08T06:05+01:00
ausgefuehrt_von: 'Planer-Session (Claude Code lief seit 07.11. 07:25 nicht; kein PowerShell in der Cloud-Sitzung)'
branch: geschichte-veraltete-daten-20261107
pr: https://github.com/Reling-IT/relingit/pull/10
commit: b4bb44f
ci: 'nicht lokal ausfuehrbar (kein PowerShell); GitHub-CI laeuft nur fuer PRs auf main, der bekannte Fehler story/current weicht von source ab bleibt bis R16'
---

## Ergebnis

Alle freigegebenen Befunde stehen in `source/fahrt-zum-kunden.html` (ein Commit, kein Force-Push). `story/current` und PDF sind nicht angefasst. Jede Ersetzung ist eine Literal-Ersetzung mit genau einem Treffer (Skript brach sonst ab).

| Gruppe | Befunde | Umsetzung |
|---|---|---|
| Hausregel ß (F1) | S16 | Text und aria-label vor der Versionshistorie: weiß, ließ, groß, ausschließlich, schließlich, Straße, Seitenstraße, heißt/heißen, außer, außen, bloß, stößt, reißt, Spaß, abschließen/-d, dreißig, Dreiunddreißig, Größeres, Außendienst. Versionshistorie unverändert. |
| Report-Namen (F2) | S21 | Areport zu areport (7 im Text, 2 in Attributen). Historie unverändert. |
| Grammatik, Wortwahl | S15, K6, K7, K8, K12, K13, K19, S23 | „der interne SharePoint“; K19 nested mit ‚…‘ (Abweichung von R19, weil im Dialog verschachtelt); K13 fuer/ueber/Ausloeser/erhaelt/Uebersicht in aria-label |
| Stil | S8, K1, K2, K3, K4, K11, K18, K9 | „Genau die Art“ von 4 auf 1; „kurz“ in der Rehder-Szene zweimal aufgelöst; K15 bewusst unverändert |
| Erzählwelt, Zahlen | S2, S3, S4, S7, S10, S11, K5, K10 | S11: dritte SVG-Zeile (Vertragsverlängerung) samt Punkt gestrichen |
| Zeitlinie (F6 bis F9) | S1, S12, S13, K16, K17 | Kaffeeecke 16:10 „auf dem Sprung zu einem Kundencall“, Fahrt „heute Abend“; A7/Autobahn überall statt Landstraße; Petra 19:51 „Heimweg von einem Abendtermin“, „ein paar Kilometer nördlich/südlich“; Teil 2 beginnt „An einem anderen Morgen:“ |
| Offene Enden (F10) | S5, S6, S9 | alle drei wie in R19 |
| Navis-Pronomen (F11) | S14 | zwei „er“ im Sachtext zu „es“; wörtliche Rede (Finn) bleibt |
| Zuständigkeiten (F12) | S17, S18, S19, S20 | Backup als offenes Ticket (ohne 41 Stunden); Lumen nennt den Hub, Historie „laut Navis“; „Navis direkt Sysingboard, Lumen über den Hub“ (Text und zwei aria-label); „angelegt wird nur nach ausdrücklicher Freigabe durch einen Menschen“ |
| Platzhalter | S22 | „(eingeführt in einer früheren Version)“ |
| Nicht umgesetzt | K14, K20, K15 | wie vorgegeben |

Versionshistorie v1.38: ein Satz ergänzt; Version und Datum im Deckblatt unverändert.

## Prüfungen (belegt)
- HTML-Parser vorher/nachher: Tag-Differenz nur −1 Text, −1 Kreis (S11), keine doppelten IDs, alle Anker (href=#…) lösen auf.
- Suche nach ss/ae/ue-Restformen vor der Versionshistorie: keine verdächtigen Formen; „Landstra…“: 0; Autobahn/A7 je 4; „Genau die Art“: 1; „An einem anderen Morgen“: 1.
- Zeitleiste 16:10 / 16:14 / 19:42 / 19:51 / 19:54 / 07:58 im Text vorhanden.
- ci-check.ps1 nicht ausgeführt (kein PowerShell in der Cloud-Sitzung). R16 führt ihn aus.

## Offene Punkte
- Seitenumbrüche ändern sich durch die Textänderungen; PDF und verify_layout.py in R16.
- Kurzes Gegenlesen der geänderten Szenen durch Bernd ist sinnvoll (Zeitlinie, A7).
