---
id: R19
titel: Lektorat und Stimmigkeit der Buchquelle v1.38
status: erledigt
start: 2026-11-07T05:06+01:00
ende: 2026-11-07T05:24+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner (Leseauftrag), Kommentar an #10'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: 'origin/geschichte-veraltete-daten-20261107 @ cfc1f9789de59576465ea34eac27df1608a6060d (PR #10, Basis PR #9), source/fahrt-zum-kunden.html, 2296 Zeilen'
---

# R19: Lektorat und Stimmigkeit der Buchquelle v1.38

## Ergebnis

Die Quelle habe ich kapitelweise vollständig gelesen: alle Kapitel von Teil 1 und Teil 2, den Anhang, die Versionshistorie, die SVG-Texte und die aria-labels. Base64-Bilder habe ich vorher entfernt; die Zeilennummern entsprechen der Originaldatei.
Ich habe **54 Befunde**: **11 muss**, **23 sollte**, **20 kann**. Die wichtigsten Muss-Befunde sind ein Rechenfehler (Lumen, 6 + 4 ≠ 9) und Reiners freier Donnerstag, der seinem festen Plan Mo–Do widerspricht. An zwei Stellen steht noch „Workshop Ende September“. Außerdem nennt Navis einen Verfügbarkeitswert, den das Sysingboard laut Buch gar nicht hat.
Die Zählung stimmt: Im Haus sind 8 Menschen plus Navis und Lumen, also zehn; Horst ist extern und wird nicht mitgezählt. Die Zählpointe in Zeile 1556 geht auf. Nur Zeile 930 („Zehn-Köpfe-Betrieb“ zu Insas Anfangszeit) passt nicht dazu.
Das PDF im Branch ist noch v1.37 (69 Seiten, „Workshop Ende September“). Vor der Veröffentlichung muss es neu gerendert werden.
In der Quelle habe ich nichts geändert.

| Nr | Fundstelle | Befund | Vorschlag (alt → neu) | Schweregrad |
|---|---|---|---|---|
| M1 | kap-kurz-vor-neun, Z. 1404 | Rechenfehler: „übrige neun“ = 6 + 4 = 10 | „bei sechs davon hatte ich die Information tatsächlich“ → „bei fünf davon hatte ich die Information tatsächlich“ | muss |
| M2 | kap-veraltete-daten, Z. 1510, 1523, 1525 | Reiner arbeitet laut Z. 894 „montags bis donnerstags“ vormittags, hier aber: „Donnerstags hat er frei“ | „Donnerstag, kurz nach sieben.“ → „Freitag, kurz nach sieben.“; „Donnerstags hat er frei“ → „Freitags hat er frei“; „an diesem Donnerstag“ → „an diesem Freitag“ | muss |
| M3 | kap-so-ist-es-gedacht, Z. 1608 | Workshop-Termin widerspricht dem Deckblatt (Z. 655: „Ende November 2026“) | „für den Workshop Ende September“ → „für den Workshop Ende November“ | muss |
| M4 | Fußzeile, Z. 2291 | Wie M3 (Commit cfc1f97 hat nur das Deckblatt geändert) | „Vorbereitungsmaterial für den Workshop Ende September“ → „… Ende November“ | muss |
| M5 | kap-navis-meldet-sich, Z. 1038 | Die Szene spielt am Abend (Z. 1033 „Guten Abend“, Termin morgen) | „Beides ist heute Vormittag machbar.“ → „Beides ist morgen Vormittag machbar.“ | muss |
| M6 | kap-freigabegrenze, Z. 932 | Grammatik | „Petra bekommt die Zeile lesen“ → „Petra bekommt die Zeile zu lesen“ | muss |
| M7 | kap-konferenztisch, Z. 1232 | Grammatik | „nach 14 Uhr im Abstimmung mit Fenner“ → „nach 14 Uhr in Abstimmung mit Fenner“ | muss |
| M8 | kap-konferenztisch, Z. 1321 | Kasus | „der widersprüchliche Altvertrag, der nur ein Mensch aufklären konnte“ → „…, den nur ein Mensch aufklären konnte“ | muss |
| M9 | kap-so-ist-es-gedacht, Z. 1567 | Am Konferenztisch entstehen 6 Entwürfe (5 angelegt, 1 offen), nicht vier | „wie die vier Arbeitspakete am Konferenztisch“ → „wie die sechs Arbeitspaket-Entwürfe am Konferenztisch“ | muss |
| M10 | kap-konferenztisch, Z. 1218 | Regelverstoß: Navis nennt „Verfügbarkeit der Kernsysteme: 99,7 Prozent“; laut Z. 2004 und v1.13 ist Verfügbarkeit „ausschliesslich Lumens Terrain“, nie Sysingboard | Satz bei Navis streichen und Lumen (Z. 1223) voranstellen: „Ergänzend aus der Report-Familie: Verfügbarkeit der Kernsysteme 99,7 Prozent. Heute früh kurzzeitig …“ | muss |
| M11 | Anhang kap-sysingboard-architektur Z. 2004, kap-reportfamilie-architektur Z. 2014 | ASCII-Umschrift im sichtbaren Text | „Zustaendigkeits-Regel, taeglich, AVKK-Uebersicht, Verfuegbarkeit, ausschliesslich, ueber“ → „Zuständigkeits-Regel, täglich, AVKK-Übersicht, Verfügbarkeit, ausschließlich, über“; Z. 2014 „fuer, oeffentlichen“ → „für, öffentlichen“ | muss |
| S1 | kap-kaffeeecke Z. 801/807; kap-aufbruch Z. 1005; SVG Z. 994 | Zeitlinie: In der Szene um 16:10 geht Mira „Autoschlüssel schon in der Hand“ los und hat „gleich anderthalb Stunden“ Fahrt vor sich. Z. 801 sagt aber „ein paar Stunden bevor“, und laut Z. 994 fährt sie erst um 19:42 los, „das Büro längst leer“ | Z. 807 „Autoschlüssel schon in der Hand“ → „auf dem Sprung zu einem Kundencall“; „die gleich anderthalb Stunden Landstrasse vor sich hat“ → „die heute Abend noch anderthalb Stunden Landstrasse vor sich hat“ | sollte |
| S2 | kap-umweg, Z. 848 | Nora ist im 2. Lehrjahr (Z. 714, 802), angeblich aber erst „vor einem halben Jahr“ gestartet | „Angefangen hat es vor einem halben Jahr, kurz nach ihrem Start“ → „Angefangen hat es vor gut einem Jahr, kurz nach ihrem Start“ | sollte |
| S3 | kap-freigabegrenze, Z. 930 | „Zehn-Köpfe-Betrieb“ zu Insas Anfangszeit passt nicht zur Regel 10 = 8 Menschen + Navis/Lumen (die Agenten sind erst seit Kurzem in Erprobung) | „vom Ein-Frau- zum Zehn-Köpfe-Betrieb“ → „vom Ein-Frau-Betrieb zum heutigen Team“ | sollte |
| S4 | kap-vor-reling-it, Bildunterschrift Z. 967 | „dieselbe Werkstudentin“: Petra ist heute Inhaberin, keine Werkstudentin; zugleich Verwechslungsgefahr mit Finn | „dieselbe Werkstudentin, zwei Zeitalter“ → „damals Werkstudentin, heute Inhaberin – zwei Zeitalter“ | sollte |
| S5 | kap-horst-avkk, Z. 1100 | Unlogisch: Die Gründerin ist nicht „erst seit ein paar Jahren länger dabei“ als die Auszubildende Nora | „Du bist hier erst seit ein paar Jahren länger dabei als sie, nicht seit einer Ewigkeit.“ → „Sie ist nicht mehr die Neue, und du musst nicht alles selbst machen.“ | sollte |
| S6 | kap-so-ist-es-gedacht, Z. 1648 | Legt fest, was Z. 1100 offen lässt („macht heute Abend trotzdem Nora“). Widerspruch, außerdem Regel „Offen bleibt offen“ | „– und die sie an diesem Abend trotzdem nicht davon abhalten, die Checkliste selbst fertigzumachen.“ → „– ob Petra die Checkliste an diesem Abend dann doch selbst fertigmacht, lässt die Szene offen.“ | sollte |
| S7 | kap-so-ist-es-gedacht, Z. 1668 | Widerspruch: Z. 1347 nennt die vier Gesetze ausdrücklich beim Namen | „kurz zurück, ohne sie beim Namen zu nennen“ → „kurz zurück und zählt sie dort beiläufig auf“ | sollte |
| S8 | kap-warum-navis-lumen, Z. 1346 | „zweiten Zusatz“, obwohl es keinen ersten gibt | „nur mit einem zweiten Zusatz“ → „nur mit einem Zusatz“ | sollte |
| S9 | kap-andere-fahrten, Z. 1554 | Kilian hat Nora diese Frage nie gestellt; in Z. 1445 fragt er Finn: „Was passiert, wenn er kaputtgeht?“ | „stellt beiläufig dieselbe Frage, die einmal Kilian ihr gestellt hat: „Und was macht ihr, wenn er sich irrt?““ → „stellt beiläufig die Frage, die Kilian ihm vor dem ersten Workflow gestellt hat: „Und was passiert, wenn er kaputtgeht?““ (Folgesatz anpassen: „… klingt wie Kilian damals“) | sollte |
| S10 | kap-konferenztisch, Z. 1267 | Punkt 1 (Firewall) ist erst für nach 14:30 Uhr geplant, also nicht „erledigt“ | „Kaum ist der erste Punkt erledigt“ → „Kaum sind die ersten drei Punkte angelegt“ | sollte |
| S11 | kap-aufbruch, SVG Z. 1025 | Die Grafik zeigt einen dritten Punkt „Vertragsverlängerung: nächste Woche fällig“. Navis nennt aber zwei Punkte, und der Vertrag ist später widersprüchlich (Z. 1138) | Zeile streichen oder → „Wartungsvertrag: zwei widersprüchliche Einträge“ | sollte |
| S12 | SVG Z. 994, kap-aufbruch Z. 1006, kap-frage-an-lumen Z. 1064, kap-kommunikation Z. 1799 | Straße uneinheitlich: Der Text sagt „eineinhalb Stunden Landstrasse“ (Z. 1005, 1166, 1318), dazu stehen „A7“, „Auffahrt“ und „Anschlussstelle“ | „19:42 · A7 Richtung Süden“ → „19:42 · Landstrasse Richtung Süden“; „Kurz vor der Auffahrt“ → „Kurz vor dem Ortsausgang“; „Kurz vor der Anschlussstelle“ → „Kurz vor der nächsten Kreuzung“; „die A7 liegt ruhig vor ihr“ → „die Landstrasse liegt ruhig vor ihr“ (oder umgekehrt überall Autobahn) | sollte |
| S13 | kap-kommunikation Z. 1799/1801, kap-infos Z. 1859/1913 | Teil 2 erzählt die Baumann-Fahrt als Morgenfahrt („kurz nach halb acht“, „Guten Morgen“, Ausdruck im Büro). In Teil 1 ist es eine Abendfahrt (19:42, „Guten Abend“) | „Es ist kurz nach halb acht“ → „Es ist kurz vor acht am Abend“; „Guten Morgen, Mira.“ → „Guten Abend, Mira.“; Z. 1859 „Bevor sie heute Morgen losgefahren ist … bevor die Kaffeemaschine im Büro überhaupt durchgelaufen war“ → „Bevor sie am Nachmittag losgefahren ist … bevor sie sich in der Kaffeeecke verabschiedet hatte“; Z. 1913 „den Stand von heute Morgen“ → „den Stand von gestern Nachmittag“ | sollte |
| S14 | Z. 897, 1035, 1140, 1515 (es) gegen Z. 1522, 1968, 1970 (er) | Pronomen für Navis im Erzähl- und Sachtext uneinheitlich | Z. 1968 „nicht, weil er sich irrt“ → „nicht, weil es sich irrt“; Z. 1970 „soll er genau diesen Datenstand“ → „soll es genau diesen Datenstand“; „er“ nur in wörtlicher Rede | sollte |
| S15 | kap-kunde-der-ging, Z. 1121 | Substantivierung | „Was es nicht kann, ist wollen für jemand anderen.“ → „Was es nicht kann: für jemand anderen wollen.“ | sollte |
| S16 | ganze Datei, z. B. Z. 1030 gegen 1913 | ß/ss uneinheitlich: etwa 45 ss-Formen (weiss, Landstrasse, grosse, ausschliesslich) gegen etwa 21 ß-Formen (großes Z. 853, größten Z. 1231, Größe Z. 1236/1445, außen Z. 1715, ausschließlich Z. 1913). Dasselbe Wort steht in beiden Formen | Hausregel festlegen (Vorschlag: deutsche Norm mit ß) und einheitlich ersetzen, z. B. „ausschliesslich“ → „ausschließlich“, „Landstrasse“ → „Landstraße“ | sollte |
| S17 | kap-navis-meldet-sich, Z. 1033 | Backup-Status mit „41 Stunden“ ist Monitoring- bzw. iReport-Wissen (Z. 1860), nicht Sysingboard | „der nächtliche Backup-Job ist zum zweiten Mal in Folge fehlgeschlagen, letzte erfolgreiche Sicherung liegt 41 Stunden zurück“ → „im Kundenprojekt steht ein offenes Ticket: der nächtliche Backup-Job ist zum zweiten Mal in Folge fehlgeschlagen“ | sollte |
| S18 | kap-frage-an-lumen Z. 1067, kap-konferenztisch Z. 1277 | Lumen liest Angebot, Ticket-Historie und Servicehandbuch direkt, nicht „ausschließlich beim Hub“ (Z. 1913) | Quelle benennen: „Ich habe im Hub das Angebot vom 11.08. …“; bei Z. 1277 die Ticket-Historie Navis zuordnen („laut Navis wurde bisher nur neu gestartet“) und das Servicehandbuch als Hub-Dokument kennzeichnen oder in Teil 2 als eigene Quelle belegen | sollte |
| S19 | kap-so-ist-es-gedacht Z. 1567, kap-kommunikation Z. 1802/1806, SVG Z. 1569/1809 | „greifen sie direkt auf Sysingboard und Report-Familie zu“: verwischt die Trennung „Navis = Sysingboard, Lumen = nur über den Hub“ | „greifen sie direkt auf Sysingboard und Report-Familie zu“ → „greift Navis direkt auf das Sysingboard zu, Lumen über den Hub auf die Report-Familie“; sinngemäß auch in Z. 1802/1806 | sollte |
| S20 | kap-so-ist-es-gedacht Z. 1609, kap-standard Z. 2054, Z. 1739 | „schreiben nur mit Freigabe“ und „ohne je selbst hineinzuschreiben, solange kein Mensch bestätigt hat“ lesen sich, als schreibe Navis nach der Freigabe selbst. Das kollidiert mit „Navis schreibt nie selbst“ | Z. 1609 „lesen dürfen sie viel, schreiben nur mit Freigabe“ → „lesen dürfen sie viel, angelegt wird nur nach ausdrücklicher Freigabe durch einen Menschen“; Z. 2054 „…, solange kein Mensch bestätigt hat“ → „… und nur Entwürfe vorlegt, die ein Mensch bestätigt“ | sollte |
| S21 | kap-infos Z. 1860, SVG Z. 1872–1884, Versionshistorie Z. 2151 | Schreibweise der Reports uneinheitlich: „ireport/qreport/nreport/sreport“ neben „Areport“ und „iReport“ | Mit den realen Repo-Namen abgleichen und einheitlich schreiben (z. B. „iReport, qReport, nReport, sReport, Areport“) | sollte |
| S22 | Versionshistorie v1.16, Z. 2166 | Platzhalter | „seit dem Logo auf dem Deckblatt (v1.??)“ → Version nachtragen oder „(seit einer früheren Version)“ | sollte |
| S23 | Versionshistorie Z. 2269, Z. 2264 | Tippfehler | „reguläraen“ → „regulären“; „fruehreren“ → „frueheren“ | sollte |
| K1 | kap-kaffeeecke, Z. 807 | Satz holpert | „wer heute Abend dafür zuständig ist, sieht ohnehin gleich jemand anderes“ → „darum kümmert sich heute Abend ohnehin jemand anderes“ | kann |
| K2 | kap-freigabegrenze, Z. 933 | Wortwiederholung im Satz | „keine grosse Sache … am Jahresende eine grosse wird“ → „keine große Sache … am Jahresende eine teure wird“ | kann |
| K3 | kap-umweg, Z. 853 | Wortwiederholung „inzwischen“ zweimal | „weil sie inzwischen weiss“ → „weil sie mittlerweile weiß“ | kann |
| K4 | kap-vor-reling-it, Z. 973 | Reihenfolge der Handlung | „Zurückfahren, umdrehen, nochmal hin.“ → „Umdrehen, zurückfahren, nochmal hin.“ | kann |
| K5 | kap-vor-reling-it, Z. 972 | „vor zwanzig Jahren“ wäre etwa 2006; da war DSL kein „Versprechen“ mehr | „vor zwanzig Jahren“ → „vor gut fünfundzwanzig Jahren“ (SVG Z. 940 „vor mehr als 20 Jahren“ passt weiterhin) | kann |
| K6 | kap-zwischenfall, Z. 1140 | Bezug unklar | „für die man ihre Kunden lange behält“ → „derentwegen ihre Kunden lange bei ihr bleiben“ | kann |
| K7 | kap-zwischenfall, Z. 1141 | Genus | „das interne SharePoint“ → „der interne SharePoint“ | kann |
| K8 | kap-konferenztisch, Bildunterschrift Z. 1211 | Begriff uneinheitlich (Z. 1007, 1092: Freisprechanlage) | „per Freisprecheinrichtung“ → „per Freisprechanlage“ | kann |
| K9 | Teil 1 gesamt | Formel „Genau die Art …“ viermal (Z. 1069, 1140, 1232, 1302); „kurz“ etwa 67-mal, „genau“ etwa 48-mal in Teil 1/2, „kurz“ viermal in Z. 896 | ausdünnen, z. B. Z. 1302 „Genau die Art Antwort, die Mira …“ → „So eine Antwort schätzt Mira …“ | kann |
| K10 | kap-warum-navis-lumen, Z. 1344/1347 | „zehn Köpfen“ in benachbarten Absätzen; ein Vierteljahr vorher waren Navis/Lumen noch nicht offiziell und Finn/Enno vermutlich noch nicht da | Z. 1347 „bei zehn Köpfen und ohnehin knapper Zeit“ → „bei so wenigen Leuten und ohnehin knapper Zeit“ | kann |
| K11 | kap-konferenztisch, Z. 1279 | „Dann, an Fenner gewandt“ doppelt; Baumann sprach Fenner schon an | „Dann, an Fenner gewandt:“ → „Dann, schon halb im Aufstehen:“ | kann |
| K12 | Inhaltsverzeichnis, Z. 676 | Schreibweise (sonst 27× „Report-Familie“) | „Reportfamilie-Architektur“ → „Report-Familie-Architektur“ | kann |
| K13 | aria-label Z. 1530, 1923 (auch 612, 980, 1074, 1326) | ASCII-Umschrift und ss im Screenreader-Text | „fuer“ → „für“; „ueber, Ausloeser, erhaelt“ → „über, Auslöser, erhält“ | kann |
| K14 | Versionshistorie Z. 2106–2279 | Viele ae/oe/ue-Umschriften | optional normalisieren; inhaltlich historisch nicht umschreiben | kann |
| K15 | Deckblatt Z. 668 gegen Z. 1346 | „Navis navigiert, du steuerst“ gegen „Navis navigiert, Mira steuert“ | gewollt? Falls nicht: in Z. 1346 ergänzen „– im Haus kurz: du steuerst“ | kann |
| K16 | kap-horst-avkk Z. 1092 gegen kap-zwischenfall Z. 1135 | „eine Landstrasse weiter nördlich“ gegen „nur eine Ausfahrt weiter als Petra“ | Z. 1135 „nur eine Ausfahrt weiter als Petra“ → „ein paar Kilometer südlich von Petra“ | kann |
| K17 | kap-vor-reling-it Z. 970 gegen kap-horst-avkk Z. 1092 (SVG 19:51) | Petra ist um 16:14 „auf dem Weg zum Auto“ und um 19:51 „ebenfalls unterwegs nach Hause“ | Z. 1092 „ebenfalls unterwegs nach Hause“ → „auf dem Heimweg von einem Abendtermin“ | kann |
| K18 | kap-infos, Z. 1859 | Das Zitat ist die Bildunterschrift von „Ankunft“ (Z. 1162), steht nicht „am Anfang“ | „wenn es am Anfang heißt“ → „wenn es in „Ankunft“ heißt“ | kann |
| K19 | kap-veraltete-daten, Z. 1523 | Anführungszeichen uneinheitlich (Z. 1970: „…“) | „‹An Team veröffentlichen›“ → „„An Team veröffentlichen““ | kann |
| K20 | Versionshistorie v1.37 Z. 2279 | „unveraendert 68 Seiten“; das veröffentlichte v1.37-PDF hat 69 Seiten und das Deckblattdatum 03.09.2026 (Historie: 05.09.2026) | nur Hinweis, Historie nicht umschreiben | kann |

## Regelcheck Abschnitt 5 (EINBAU-CHECKLISTE, Stand v1.37, aus origin/auftrag-R08-kapitel-vorlage)

| Regel | Ergebnis | Verstöße und Grenzfälle |
|---|---|---|
| Navis liest nur das Sysingboard | **Verstoß** | Z. 1218 Verfügbarkeit 99,7 % (M10); Z. 1033 Backup „41 Stunden“ (S17); Z. 1567, 1802, 1806 und SVG 1569/1809: Navis und Lumen greifen auf beide Systeme zu (S19); Z. 1295: Herkunft von „sieben aktive Zugänge“ (E-Mail, VPN, CRM, Mobilfunk) ist nicht belegt (Grenzfall). Eingehalten in Z. 1030, 1138, 1271, 1398, 1513, 1520 |
| Navis schreibt nie selbst | in den Szenen eingehalten, in den Sachtexten uneindeutig | Z. 1248–1313: Entwürfe „wartet auf Freigabe“, Anlage erst nach „So anlegen.“; Z. 1295 Sperrung nur vorbereitet; Z. 1227 archiviert Mira selbst. Uneindeutig formuliert: Z. 1609, 2054, 1739 („Arbeitspaket-Entwurf anlegen“ als Werkzeug), siehe S20 |
| Navis empfiehlt, entscheidet nicht | eingehalten | Z. 1035/1038 Optionen A/B; Z. 1520 „Frag bitte Reiner.“ |
| Lumen liest nur über den Hub | **Verstoß / unklar** | Z. 1067 Angebot, Z. 1277 Ticket-Historie und Servicehandbuch (S18); Z. 1223 „aus dem Monitoring … laut Reporting“ ist uneindeutig (Vorschlag: „aus der Report-Familie“). Z. 1404 ist ausdrücklich als Blick auf Noras Liste erklärt (v1.14) |
| Keine Scores | eingehalten | Z. 1914 als Regel. 99,7 % (Z. 1218) und 72 % (Z. 1914) sind Einzelwerte mit Herkunft, kein Gesamtscore. Noras „elf von zwanzig“ ist menschliche Zählung |
| Offen bleibt offen | **1 Verstoß** | Z. 1648 schließt den offenen Ausgang von Z. 1100 (S6). Eingehalten: Z. 1138, 1309/1313, 1520, 1525 („Vertretung: nicht zugeordnet“ bleibt), 1962, 1984–1986 |
| Keine neue Fähigkeit | Grenzfall | Lumen „legt Seiten aufs Tablet“ (Z. 1067, 1277): Ausgabe auf ein Gerät ist in Teil 2 nicht beschrieben. Neue Szene „Die veralteten Daten“: keine neue Fähigkeit, Navis nennt nur den Datenstand (passt zu Z. 1969/1970) |

Außerdem: Die Zeilenangaben in Checkliste Abschnitt 5 sind veraltet. Das Hub-Zitat steht jetzt in Z. 1913 (nicht 1875), das Score-Zitat in Z. 1914 (nicht 1876), der Konferenztisch-Block in Z. 1247–1313.

## Offene Fragen, Risiken, Abweichungen

- **PDF veraltet:** `source/Die-Fahrt-zum-Kunden.pdf` und `story/current/geschichte.pdf` im Branch sind v1.37. Das Deckblatt zeigt 03.09.2026 und „Workshop Ende September“, die Datei hat 69 Seiten und enthält „Die veralteten Daten“ noch nicht. `index.html` zeigt „69 Seiten“. Vor der Veröffentlichung neu rendern (Checkliste §4); die Seitenzahl ändert sich dann.
- **M2 Wochentag:** Mein Vorschlag (Freitag) ändert die Szene. Alternativ bleibt es beim Donnerstag und Reiner hat „ausnahmsweise“ frei. Das kollidiert aber mit seinem „keine Ausnahmen“ (Z. 894). Entscheidung beim Autor.
- **S12/S13 (Landstraße/A7, Morgen/Abend):** Die Kapitel in Teil 2 könnten eine bewusst „typische“ Fahrt zeigen statt der Fahrt aus Teil 1. Falls ja, reicht ein Satz wie „An einem anderen Morgen …“ statt der Anpassungen.
- **S21 Report-Namen:** Die realen Repo-Namen habe ich nicht geprüft. Die Schreibweise sollte gegen die Report-Familie-Repos abgeglichen werden.
- **PR #6 (Avatare, „Ancora“)** ändert laut Titel die Personenliste im Buch. Kommt dort eine dritte Nicht-Person dazu, kippt die Zählpointe 8 + 2 = 10 (Z. 1556, Ausgangslage Z. 686). Vor dem Merge abgleichen.
- Die Datei hat 2296 Zeilen, aber vier Base64-Zeilen bis 456 KB. Für das Lektorat habe ich sie herausgefiltert; die Bildinhalte habe ich nicht geprüft.
- Die Zeilennummern beziehen sich auf Commit cfc1f97. Werden die Muss-Befunde eingearbeitet, verschieben sich nachfolgende Zeilen.

## Vorschläge und Ideen (Claude)

- **Hausregel ß/ss** einmal in `docs/vorlagen/` festhalten und per Skript prüfen (z. B. ein Grep auf `weiss|gross|Strasse|ausschliesslich` in `ci-check.ps1` als Warnung, nicht als Fehler).
- **Zuständigkeitsmatrix als Prüfliste:** eine kleine Tabelle „Information → Quelle → Agent“ (Tickets/Verträge/Arbeitspakete → Sysingboard → Navis; Verfügbarkeit/Backup/Sensoren → Report-Familie/Hub → Lumen). Gegen sie lässt sich jede neue Navis- oder Lumen-Zeile in einer Minute prüfen. Die Funde M10, S17 und S18 wären damit sofort aufgefallen.
- **Zeitleiste der Rahmenhandlung** als Anhang zur Checkliste (Kaffeeecke 16:10, Petra 16:14, Abfahrt 19:42, Petra 19:51, Mira 19:54, Ankunft 07:58, Konferenztisch bis 08:34, Montag 08:58). Die SVG-Uhrzeiten sind die verlässlichste Quelle dafür.
- **Arithmetik-Check:** Alle Zahlen in Navis- und Lumen-Dialogen (Z. 1218, 1271, 1295, 1398, 1404) in der Checkliste aufzählen und bei jeder Version nachrechnen.
- **Abschnitt 5 der Checkliste** auf Kapitel-IDs statt Zeilennummern umstellen. Die Zeilenangaben sind schon jetzt veraltet.
- Die Teil-2-Szenen (Kommunikation, Infos) entweder ausdrücklich als „eine typische Fahrt“ einleiten oder an die Abendfahrt aus Teil 1 angleichen. Das ist die größte erzählerische Unstimmigkeit nach M2.

Hygiene: keine gemergten Remote-Branches übrig (`git branch -r --merged origin/main` leer). 7 offene PRs (#6, #7, #8, #9, #10, #11, #12), davon 2 Drafts (#9, #10; #10 zielt auf #9). Branch `quelle-pdf-werkzeuge-20261106` ohne PR (1 Commit vor main); `ops/queue` und `ops/reports` sind Betriebszweige.

```yaml
Reifegrad: "Entwurf v1.38 inhaltlich weitgehend stimmig; 11 Muss-Befunde (Grammatik, Zahlen, Termin, eine Zuständigkeitsverletzung) vor Veröffentlichung beheben; PDF noch v1.37"
Projektstatus: "PR #10 (Draft) auf PR #9 (Draft); Lektorat R19 abgeschlossen, Korrekturen nicht eingearbeitet"
Offene_Fragen:
  - "Wochentag in 'Die veralteten Daten': Freitag statt Donnerstag oder Ausnahme für Reiner?"
  - "Sollen die Teil-2-Szenen dieselbe Fahrt wie Teil 1 sein (dann Abend und Landstraße) oder eine typische Morgenfahrt?"
  - "Hausregel ß oder ss?"
  - "Reale Schreibweise der Report-Namen (ireport/iReport, Areport)?"
  - "Ändert PR #6 (Ancora) die Zählung 8 + 2 = 10?"
Roadmap:
  hinweis: "unbelegte Schätzung"
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```
