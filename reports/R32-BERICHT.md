---
id: R32
titel: Entscheidungspakete zu den Sollte- und Kann-Befunden aus R19
status: erledigt
start: 2026-11-07T06:31+01:00
ende: 2026-11-07T06:40+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: 'origin/geschichte-veraltete-daten-20261107 @ 9dfdc54 (PR #10), source/fahrt-zum-kunden.html, 2296 Zeilen'
---

# R32: Entscheidungspakete zu den Sollte- und Kann-Befunden aus R19

## Ergebnis

Die 43 offenen Befunde (S1–S23, K1–K20) habe ich zu 9 Gruppen zusammengefasst. 23 Befunde empfehle ich ohne Rückfrage umzusetzen: G1 und G6 ganz, dazu Teile von G4, G5 und G9. 18 Befunde hängen an 12 kurzen Fragen an Bernd: G2, G3, G7, G8 sowie K7, K9 und K15. 2 Befunde empfehle ich nicht umzusetzen (K14, K20).
Der Branch steht weiterhin auf 9dfdc54 und hat 2296 Zeilen; ein @font-face im Kopf gibt es nicht. Die Stichprobe von 39 Zeilen passt zu R19. Es gibt eine Ausnahme: Die SVG-Zeile „19:42 · A7 Richtung Süden“ (S12) steht in Z. 1000, nicht in Z. 994.
Die Report-Repos heißen klein: bmarnau/ireport, qreport, nreport, sreport, areport. Damit ist S21 bis auf die Schreibweise geklärt.
Ein Entwurf für den Folgeauftrag liegt unten. Er ist nicht in die Warteschlange gelegt. Die Nummer vergibt der Planer, denn R33 ist schon belegt.

## Gruppen

| Gruppe | Befunde (IDs/Fundstellen) | Anzahl | Aufwand | Risiko | Empfehlung | Begründung |
|---|---|---|---|---|---|---|
| G1 Schreibweise, mechanisch | S23 (Historie Z. 2269 „reguläraen“, Z. 2264 „fruehreren“), K8 (Bildunterschrift Z. 1211 „Freisprecheinrichtung“), K12 (Inhaltsverzeichnis Z. 676 „Reportfamilie-Architektur“, nur der Linktext, nicht der Anker `#kap-reportfamilie-architektur`), K13 (aria-label Z. 1530, 1923, dazu 612, 980, 1074, 1326: fuer/ueber/Ausloeser/erhaelt), K19 (Z. 1523 ‹…› → „…“) | 5 | gering (Literal-Ersetzungen) | gering | **umsetzen** | Eindeutige Tippfehler oder Vereinheitlichungen. Handlung und Ton bleiben unberührt. Bei K12 darf sich die Anker-ID nicht ändern. |
| G2 Hausregel ß/ss | S16 (ganze Datei: Landstrasse 10×, weiss 9×, grosse/n/r 7×, ausschliesslich 3×, Strasse 2×, schliesslich 2×, dazu ausser, aussen, heisst, Grosskunde, gleichermassen, abschliessend, Seitenstrasse, umschliesst; daneben ß-Formen wie ausschließlich 4×, außerhalb 3×, größten, Größe) | 1 (~45 Stellen) | mittel (Skript mit Wortliste, Treffer zählen) | gering bis mittel (Anker, Klassen und Code dürfen nicht getroffen werden) | **Bernd fragen** (Frage 1) | Das ist eine Hausregel, keine Korrektur. Laut R26 hat M11 im Anhang schon ß gesetzt. K2, K3 und S12 hängen davon ab. |
| G3 Report-Namen | S21 (kap-infos Z. 1860, SVG Z. 1862–1890, Bildunterschrift Z. 1911 „Areport“, Historie Z. 2151) | 1 | gering | gering | **Bernd fragen** (Frage 2) | Die Repos heißen klein (ireport … areport). Der Text mischt „ireport“, „iReport“ und „Areport“. Die Historie bleibt dabei unberührt (siehe G9). |
| G4 Grammatik | S15 (kap-kunde-der-ging Z. 1121 „ist wollen für jemand anderen“), K6 (kap-zwischenfall Z. 1140 „für die man ihre Kunden lange behält“), K7 (Z. 1141 „das interne SharePoint“) | 3 | gering | gering | **umsetzen** S15, K6; K7 **Bernd fragen** (Frage 3) | S15 und K6 sind sprachlich klar besser. Bei K7 sind beide Genera üblich („das“ für das Portal, „der“ für den Server), daher ist es eine Geschmacksfrage. |
| G5 Stil, Wortwiederholung | S8 (Z. 1346 „zweiten Zusatz“), K1 (Z. 807), K2 (Z. 933 „grosse … grosse“), K3 (Z. 853 „inzwischen“ doppelt), K4 (Z. 973 Reihenfolge), K11 (Z. 1279 „an Fenner gewandt“ doppelt), K18 (Z. 1859 „am Anfang“ → „in ‚Ankunft‘“); K9 (Formel „Genau die Art …“ Z. 1069, 1140, 1232, 1302; „kurz“/„genau“ gehäuft), K15 (Motto Deckblatt Z. 668 gegen Z. 1346) | 9 | gering (7 Einzelstellen), mittel (K9) | gering (7), mittel (K9, K15: Ton) | **umsetzen** S8, K1, K2, K3, K4, K11, K18; K9 und K15 **Bernd fragen** (Fragen 4, 5) | Die sieben Einzelstellen sind lokal und ändern nur den Satz, nicht die Aussage. Wenn K1 vor S1 umgesetzt wird, ändert sich Z. 807 doppelt, deshalb erst nach Frage 6. K9 betrifft die Erzählstimme des ganzen Teils 1. K15 kann ein bewusstes Echo sein. |
| G6 Zahlen und Fakten (innere Stimmigkeit) | S2 (kap-umweg Z. 848 „vor einem halben Jahr“ gegen 2. Lehrjahr), S3 (Z. 930 „Zehn-Köpfe-Betrieb“), K10 (Z. 1347 „bei zehn Köpfen“), S4 (Bildunterschrift Z. 967 „dieselbe Werkstudentin“), S7 (Z. 1668 „ohne sie beim Namen zu nennen“), S10 (Z. 1267 „Kaum ist der erste Punkt erledigt“), S11 (SVG Z. 1025 „Vertragsverlängerung: nächste Woche fällig“), K5 (Z. 972 „vor zwanzig Jahren“) | 8 | gering | gering (S4: prüfen, wer auf dem Bild ist) | **umsetzen** | Alles sind belegte Widersprüche im Text. Die Vorschläge aus R19 sind minimal. S3 und K10 schützen die Zählpointe 8 + 2 = 10 (Z. 1556). Bei S11 empfehle ich die Variante „Zeile streichen“, weil Navis nur zwei Punkte nennt. |
| G7 Zeitlinie und Handlung | S1 (Kaffeeecke Z. 801/807 gegen Abfahrt 19:42), S12 (Landstraße Z. 1005/1166/1318 gegen A7: SVG **Z. 1000**, Z. 1006 „Auffahrt“, Z. 1064 „Anschlussstelle“, Z. 1799 „die A7“), S13 (Teil 2 Morgenfahrt Z. 1799/1801, 1859, 1913 gegen Abendfahrt Teil 1), K16 (Z. 1135 „eine Ausfahrt weiter“ gegen Z. 1092 „eine Landstrasse weiter nördlich“), K17 (Petra 16:14 „auf dem Weg zum Auto“ Z. 970 gegen 19:51 „unterwegs nach Hause“ Z. 1092), S5 (Horst-Satz Z. 1100), S6 (Z. 1648 schließt den offenen Ausgang), S9 (Z. 1554 Kilians Frage an Nora gegen Z. 1445 an Finn) | 8 | mittel (S12, S13: mehrere Stellen, teils SVG) | **hoch** (Erzählung) | **Bernd fragen** (Fragen 6–10) | Diese Befunde berühren Handlung und Ton. S12, S13 und K16 hängen zusammen: Wer A7 sagt, muss auch K16 anpassen. Wer „typische Morgenfahrt“ sagt, braucht für S13 nur einen einleitenden Satz. |
| G8 Technik, Regelcheck Navis/Lumen | S14 (Navis „es“ Z. 897, 1035, 1140, 1515 gegen „er“ Z. 1522, 1968, 1970), S17 (Z. 1033 Backup „41 Stunden“ = Monitoring-Wissen), S18 (Lumen liest Angebot Z. 1067, Ticket-Historie und Servicehandbuch Z. 1277 direkt), S19 (Z. 1567, 1802, 1806, SVG 1569/1809 „greifen sie direkt auf Sysingboard und Report-Familie zu“), S20 (Z. 1609, 2054, 1739 „schreiben nur mit Freigabe“) | 5 | gering bis mittel | mittel (Regeln der EINBAU-CHECKLISTE §5; S17 und S18 ändern Figurenrede) | **Bernd fragen** (Fragen 11, 12) | Drei Regelverstöße sind belegt (Navis nur Sysingboard, Lumen nur über den Hub, Navis schreibt nie). Die Vorschläge aus R19 lösen sie mit wenig Text. Weil sie Dialoge betreffen, braucht es eine Freigabe. |
| G9 Versionshistorie, Hinweise | S22 (Z. 2166 „(v1.??)“), K14 (ae/oe/ue in der Historie Z. 2106–2279), K20 (Z. 2279 „68 Seiten“, nur Hinweis) | 3 | gering | gering | S22 **umsetzen** („(seit einer früheren Version)“, falls die Version in `git log` nicht eindeutig ist); K14, K20 **nicht umsetzen** | Die Historie ist ein Protokoll. Einen offenen Platzhalter schließen ist sinnvoll, alte Einträge umschreiben nicht. |

Summe: 5 + 1 + 1 + 3 + 9 + 8 + 8 + 5 + 3 = 43.

## Fragen an Bernd

1. **ß/ss:** Überall deutsche Norm mit ß (Landstraße, weiß, ausschließlich), nur die Versionshistorie bleibt, wie sie ist? (ja/nein)
2. **Report-Namen:** Im Text klein wie die Repos (ireport, qreport, nreport, sreport, areport)? (ja / nein = Binnenmajuskel iReport … aReport)
3. **SharePoint:** „der interne SharePoint“ oder „das interne SharePoint“ lassen? (der/das)
4. **Füllwörter (K9):** Die Formel „Genau die Art …“ von 4 auf 1 ausdünnen und die Häufung von „kurz“ in Z. 896 auflösen? Der übrige Text bleibt. (ja/nein)
5. **Motto (K15):** Ist „Navis navigiert, du steuerst“ (Deckblatt) neben „Navis navigiert, Mira steuert“ (Z. 1346) gewollt? (ja = lassen / nein = angleichen)
6. **Kaffeeecke (S1):** Mira geht um 16:10 nicht zum Auto, sondern „auf dem Sprung zu einem Kundencall“, und die Fahrt ist „heute Abend“? (ja/nein)
7. **Straße (S12, K16):** Landstraße oder A7? (Landstraße = A7, Auffahrt und Anschlussstelle ersetzen / A7 = die „Landstrasse“-Stellen und K16 auf Autobahn umstellen)
8. **Teil 2 (S13):** Ist es dieselbe Abendfahrt wie in Teil 1 oder eine typische andere Fahrt? (dieselbe = Uhrzeit, Gruß und Ausdruck anpassen / andere = ein Satz „An einem anderen Morgen …“)
9. **Petras Tag (K17):** Um 19:51 „auf dem Heimweg von einem Abendtermin“? (ja/nein)
10. **Offene Enden und Zitate (S5, S6, S9):** Alle drei Vorschläge aus R19 übernehmen? S5: Horsts Satz wird „Sie ist nicht mehr die Neue …“. S6: Z. 1648 lässt offen, ob Petra die Checkliste selbst fertigmacht. S9: Nora stellt Finn Kilians echte Frage „Und was passiert, wenn er kaputtgeht?“ (ja / nein / einzeln: z. B. „nur S6“)
11. **Navis-Pronomen (S14):** Navis im Erzähl- und Sachtext „es“ (wie bisher überwiegend), „er“ nur in wörtlicher Rede? (es/er)
12. **Regelverstöße (S17–S20):** Die vier Vorschläge aus R19 übernehmen? S17: Backup als offenes Ticket statt „41 Stunden“. S18: Lumen nennt den Hub als Quelle, die Ticket-Historie kommt „laut Navis“. S19: „Navis direkt aufs Sysingboard, Lumen über den Hub“. S20: „angelegt wird nur nach ausdrücklicher Freigabe durch einen Menschen“. (ja / nein / einzeln)

## Entwurf Folgeauftrag

Nicht in `ops/queue` gelegt. `R3x` ist ein Platzhalter für die nächste freie Nummer, denn R33 ist schon belegt. Die Zeilen mit `[F…]` gelten nur, wenn Bernd die betreffende Frage freigibt; sonst entfallen sie.

```yaml
id: R3x
titel: 'Sollte- und Kann-Befunde aus R19 (freigegebene Gruppen laut R32) auf PR #10 umsetzen'
art: code-pr
gate: nein
abhaengig_von:
- R19
- R26
- R32
ziel: Die freigegebenen Sollte- und Kann-Befunde aus reports/R19-BERICHT.md sind im Buchtext v1.38 behoben, bevor story/current und die PDF neu erzeugt werden.
schritte:
- 'Arbeiten auf dem Branch geschichte-veraltete-daten-20261107 (PR #10), nicht auf main. Gemeinsame Regel: alle Quelltext-Aenderungen v1.38 auf diesem Branch stapeln. Neuen Commit auf den aktuellen Kopf setzen, nichts umschreiben, kein Force-Push. Fundstellen ueber den Text suchen, nicht ueber die Zeilennummer (seit 9dfdc54 koennen Zeilen verschoben sein).'
- 'Ersetzungen per Skript als Literal-Ersetzung: genau ein Treffer pro Befund, sonst abbrechen und im Bericht melden. Anker-IDs, Klassen, href und Code nicht anfassen.'
- 'G1 umsetzen: S23, K8, K12 (nur Linktext, Anker #kap-reportfamilie-architektur bleibt), K13 (aria-labels Z. 612, 980, 1074, 1326, 1530, 1923), K19.'
- 'G4 umsetzen: S15, K6. [F3] K7 nur nach Antwort auf Frage 3.'
- 'G5 umsetzen: S8, K1, K2, K3, K4, K11, K18. K1 erst nach S1 entscheiden (dieselbe Zeile 807). K2/K3 in der Schreibweise laut Frage 1. [F4] K9: Genau die Art ... auf ein Vorkommen ausduennen, Z. 896 kurz-Haeufung aufloesen. [F5] K15 nur bei nein.'
- 'G6 umsetzen: S2, S3, K10, S4 (vorher pruefen, wer im Bild gemeint ist), S7, S10, S11 (Zeile im SVG streichen), K5. Danach die Zaehlpointe Z. 1556 (8 Menschen + Navis + Lumen = 10) noch einmal pruefen.'
- 'G9: S22 umsetzen (Version per git log ermitteln, sonst (seit einer frueheren Version)). K14 und K20 NICHT umsetzen.'
- '[F1] G2 ss -> ss nach Hausregel ersetzen, ausser in der Versionshistorie; Wortliste und Trefferzahlen vorher und nachher im Bericht.'
- '[F2] G3 Report-Namen einheitlich nach Antwort auf Frage 2 (Text, SVG, Bildunterschrift Z. 1911; Historie nicht).'
- '[F6-F10] G7 nur die freigegebenen Varianten: S1, S12 inkl. SVG-Text 19:42 (Z. 1000) und K16, S13, K17, S5/S6/S9. Danach Teil 1 und Teil 2 auf die Zeitleiste 16:10 / 16:14 / 19:42 / 19:51 / 19:54 / 07:58 gegenlesen.'
- '[F11] S14 Pronomen fuer Navis nach Antwort. [F12] S17 bis S20 nach Antwort; danach Regelcheck EINBAU-CHECKLISTE Abschnitt 5 fuer die betroffenen Szenen wiederholen.'
- 'Versionshistorie: die Zeile v1.38 um einen Satz zu diesen Korrekturen ergaenzen; Version und Datum im Deckblatt unveraendert. Nicht freigegebene Befunde NICHT umsetzen.'
- 'Pruefen: ci-check.ps1 (vorbestehender Fehler story/current darf bleiben, keine neuen), keine doppelten IDs, alle Anker loesen auf. story/current und PDF nicht erzeugen und nicht committen.'
nachweis: 'Commit auf dem Branch von PR #10, Kommentar im PR mit Tabelle Befund, Fundstelle (Text), alt, neu; Bericht reports/R3x-BERICHT.md.'
grenzen: Kein Merge, kein Tag, keine Veroeffentlichung, kein FTP, keine Zugangsdaten, keine Aenderung an .github/workflows, Deployment, Supabase-Konfiguration oder Admin-Konten. Nur die freigegebenen Befunde aus R32, kein weiterer Buchtext, keine PDF.
status: entwurf
stand: 2026-11-07 06:40
planer: Claude (Planer-Session)
repo: Reling-IT/relingit
```

## Offene Fragen, Risiken, Abweichungen

- **Zeilenangaben:** Branch-Kopf ist 9dfdc54, wie bei R26, mit 2296 Zeilen. Die Stichprobe passt, mit einer Ausnahme: Der SVG-Text „19:42 · A7 Richtung Süden“ steht in Z. 1000; R19 nannte Z. 994, dort steht eine `<line>`. Kommen weitere Commits dazu, gilt die Fundstelle über den Text (so auch im Entwurf).
- **Abhängigkeiten:** K1 und S1 betreffen dieselbe Zeile 807. K2, K3 und S12 schreiben ß- oder ss-Formen und hängen deshalb an Frage 1. S12 und K16 hängen an Frage 7.
- **S4:** Ob auf dem Bild Petra oder Insa als „Werkstudentin“ gemeint ist, habe ich nicht abschließend geprüft. Der Folgeauftrag soll das vor der Änderung klären.
- **S21:** Die realen Repo-Namen sind jetzt geprüft (`gh repo list bmarnau`: ireport, qreport, nreport, sreport, areport, report-family-platform). Offen ist nur noch, ob der Buchtext sie so oder als Produktnamen schreibt.
- **PR #6 (Ancora):** Wie in R19 gilt: Wird Ancora als dritte Nicht-Person eingeführt, kippen S3, K10 und die Zählpointe. Vor dem Folgeauftrag abgleichen.
- **story/current und PDF** sind weiterhin nicht nachgezogen (R26). Der Folgeauftrag ändert daran bewusst nichts.

## Vorschläge und Ideen (Claude)

- Bernd kann alle zwölf Fragen in einer Zeile beantworten, z. B. „1 ja, 2 ja, 3 der, 4 ja, 5 ja, 6 ja, 7 Landstraße, 8 dieselbe, 9 ja, 10 ja, 11 es, 12 ja“. Der Planer streicht dann die nicht freigegebenen `[F…]`-Zeilen und legt den Auftrag ab.
- Meine Voreinstellung, falls Bernd „wie empfohlen“ sagt: 1 ja, 2 ja (klein), 3 der, 4 ja, 5 ja (lassen), 6 ja, 7 Landstraße (der Text nennt sie dreimal, die A7 nur an einer Stelle im Fließtext), 8 dieselbe Fahrt, 9 ja, 10 ja, 11 es, 12 ja.
- Nach dieser Runde lohnt sich die Zuständigkeitsmatrix „Information → Quelle → Agent“ aus R19 als festes Prüfblatt. G8 zeigt, dass Regelverstöße beim Schreiben neuer Dialoge entstehen.
- Die ß/ss-Prüfung als Warnung in `ci-check.ps1` gehört in einen eigenen Auftrag, erst nachdem Frage 1 beantwortet ist.

Hygiene: `git branch -r --merged origin/main` zeigt `origin/quelle-pdf-werkzeuge-20261106` als gemergt (kann gelöscht werden; nicht gelöscht). Offene PRs: #14 (R15, offen), #10 (Draft, Basis #9), #9 (Draft), #6 (offen). Lokaler Klon steht auf `auftrag-R02-veroeffentlichung`, sauber, unverändert.

```yaml
Reifegrad: "Entwurf v1.38: Muss-Befunde behoben (R26); 43 Sollte/Kann-Befunde in 9 Gruppen aufbereitet, 23 ohne Rückfrage umsetzbar, 18 hängen an 12 Fragen, 2 nicht umsetzen"
Projektstatus: "PR #10 (Draft, Basis #9) auf 9dfdc54; Folgeauftrag als Entwurf in R32, wartet auf Bernds Antworten"
Offene_Fragen:
  - "Zwölf Fragen an Bernd aus R32 (ß/ss, Report-Namen, SharePoint, Füllwörter, Motto, Kaffeeecke, Landstraße/A7, Teil 2 Abend/Morgen, Petras Abendtermin, S5/S6/S9, Navis es/er, Regelverstöße S17–S20)"
  - "Ändert PR #6 (Ancora) die Zählung 8 + 2 = 10?"
  - "Wann werden story/current und die PDF v1.38 erzeugt?"
Roadmap:
  hinweis: "unbelegte Schätzung"
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```
