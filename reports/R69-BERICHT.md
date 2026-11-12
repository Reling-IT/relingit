# R69: Stimmigkeitsprüfung Rest des Buchs (nur lesen)

- Start: 12.11.2026, 04:42 Uhr (MEZ, `date`)
- Ende: 12.11.2026, 04:52 Uhr (MEZ, `date`)
- Rolle: KI-Sitzung (Agent im Auftrag des Koordinators). Es wurde nur gelesen: kein Commit, kein Push, kein Branchwechsel im Arbeitsklon, keine PR-Kommentare.
- Auftrag: `queue/R69.yaml` auf `origin/ops/queue` (1711e0d), vollständig gelesen.

## Basis

| Stand | Commit | Datei | Zeilen |
|---|---|---|---|
| main | `origin/main` 8abe213 | `source/fahrt-zum-kunden.html` | 2319 |
| v1.39-Stand (Probe) | 8abe213 + `origin/auftrag-R06-standards-box-v139` 8ea4c62 (#27) + `origin/auftrag-R41-buchkontraste` ecfbebb (#33), lokal gemergt im Wegwerf-Worktree, ohne Konflikt, ohne Push | dieselbe Datei | 2369 |

Der v1.39-Stand entspricht den Buchquellen-Schritten D4 und D5 aus R63. Die Nachzüge aus R63 (ADF-Zeile, Renderdatum) und die Korrekturen aus R65 sind darin nicht enthalten.

Zeilenangaben: „main Z.“ bezieht sich auf 8abe213, „v1.39 Z.“ auf den Probe-Stand. Der Versatz beträgt +5 bis Z. 1751 (main) und +6 danach, ab der neuen Box +45.

**Grenze der Prüfung vom 09.11.: nicht belegt, daher ganz Teil 2 gelesen.** Auf `origin/ops/reports` gibt es keinen Bericht zu einer Stimmigkeitsprüfung vom 09.11. (gesucht in `reports/`, in den Tagesberichten vom 09. bis 11.11. und per `git grep` auf allen drei Branches). Belegt ist nur das Lektorat R19 vom 07.11. Teil 1 habe ich zusätzlich ganz gelesen, um Bezugsfakten zu haben.

## Muss-Befunde

Die Einstufung ist eine Empfehlung der KI-Sitzung. Beide Befunde habe ich ein zweites Mal gegen Text und Bild geprüft.

1. **Nr. 1, Anhang „Functional is not Done“:** Der Anhang beschreibt als Tatsache eine laufende CI für „Navis- oder Lumen-Code“. Teil 2 sagt im selben Buch, Navis sei „noch nicht als Code vorhanden“. Laut R04 kommt Lumen in keinem Repo vor.
2. **Nr. 2, Anhang „Die Report-Familie in echt“:** Beide Architekturbilder zeigen Reifegrad- und Compliance-Prozentwerte und das Wort „Bewerten“. Teil 2 sagt: „keinen Reifegrad-Score“. Das Zielbild meldet außerdem „LUMEN: integriert“.

Wer die Anhänge als bewusst erzählerisch oder als historische Arbeitsunterlage ansieht, kann beide auf „sollte“ setzen. Dann fehlt aber je ein Satz, der das im Buch sagt.

## Befundtabelle

| Nr | Fundstelle | Befund | Beleg (Zitat) | Vorschlag | Schweregrad |
|---|---|---|---|---|---|
| 1 | Anhang `kap-standard`, main Z. 2064, 2066, 2069, 2077 (v1.39 Z. 2070 bis 2083); dagegen `kap-datenstand` main Z. 1993 (v1.39 Z. 1999) | Aussage über echten Code ohne Beleg und Widerspruch im Buch. R10 und R21: keine Navis-Anbindung im Code. R04 (Z. 21): „Lumen kommt in keinem Repo vor.“ | „Jeder Commit an Navis- oder Lumen-Code stößt automatisch eine feste Kette von npm-Skripten an“; Kastentitel „Was in der CI-Pipeline tatsächlich geprüft wird“; dagegen „Navis ist im realen Repo (Stand 06.11.2026) noch nicht als Code vorhanden“ | Auf die realen Apps beziehen, z. B. „Jeder Commit am Code der Apps hinter Navis und Lumen (Sysingboard, Report-Familie) …“, und die Navis-Beispiele als Ziel formulieren („soll prüfen, dass Navis nur liest“). Oder ein Satz, dass der Kasten das Zielbild im erzählten Systemhaus zeigt | muss |
| 2 | Anhang `kap-reportfamilie-architektur`, Bilder main Z. 2039 und 2043 (v1.39 Z. 2045, 2049), Text main Z. 2037; dagegen `kap-infos` main Z. 1937 (v1.39 Z. 1943) | Die Bilder widersprechen der Regel „keine Scores“. Bild 1 zeigt in areport „Reifegrad 78 %“ und „Compliance 92 %“, eine Sprechblase „Zeige mir den aktuellen Reifegrad“ und den Kasten „Qualität & Reifegrad … Messen – Bewerten – Handeln“. Bild 2 nennt im Management Hub „Reifegrad & Compliance“, bei Lumen „Daten verknüpfen & bewerten“ und im Status „LUMEN: integriert“, „Zielbild: erreicht“ | Text: „Es gibt bewusst keine Gesamtampel und keinen Reifegrad-Score“; Anhang: Bilder „zeigen, wie areport und die vier Fachreports technisch zusammenspielen“ | Bilder nicht ändern, sondern im Anhangtext oder in der Bildunterschrift einordnen: ältere Arbeitsskizzen; Prozentanzeigen und „Bewerten“ sind Platzhalter und gelten nach „Woher kommen die Infos“ nicht; Lumen ist Zielbild. Alternativ Bild 1 ersetzen | muss |
| 3 | `kap-architektur-exkurs`, aria-label main Z. 1700 (v1.39 Z. 1705) | Der Screenreader-Text beschreibt die Reihenfolge verkehrt. In der Grafik stehen die Daten oben (y=10) und Navis und Lumen unten (y=266) | „Fünf Ebenen von unten nach oben: Sysingboard und Report-Familie haben die Daten; … ganz oben Navis und Lumen“ | „von oben nach unten … ganz unten Navis und Lumen“ | sollte |
| 4 | `kap-architektur-exkurs`, main Z. 1737 (v1.39 Z. 1742) | Lumen bekäme eine Rolle im Sysingboard. Das verwischt die Trennung: Navis liest das Sysingboard, Lumen nur über den Hub | „Navis und Lumen bekämen dort im Grunde nur eine neue, eng begrenzte Rolle in einem bestehenden System“ | „Navis bekäme dort …“ | sollte |
| 5 | `kap-architektur-exkurs`, main Z. 1738 (v1.39 Z. 1743); dagegen `kap-infos` Z. 1936 und `kap-datenstand` Z. 1993 | Pauschale Cloud-Aussage. Sie passt nicht zur Klarstellung aus v1.38 und liegt nahe an der unzulässigen Aussage U5 (alles zentral auf dem Server) | „Sysingboard liegt ohnehin schon in der Cloud“; dagegen „einige Module speichern ihre Daten aber noch im Browser“ | „Anmeldung und Rollenprüfung des Sysingboards laufen ohnehin schon über einen Cloud-Dienst“ | sollte |
| 6 | `kap-infos`, main Z. 1882 und 1936 (v1.39 Z. 1888, 1942); dagegen `kap-aufbruch` Z. 1030 und Versionshistorie v1.38 | Teil 2 gilt seit v1.38 als „anderer Morgen“. Dieser Absatz bindet den Morgen-Ausdruck aber an die „Ankunft“ aus Teil 1. Dort fährt Mira am Vorabend los und hat sich im Büro gerade nicht mehr eingelesen | „Bevor sie heute Morgen losgefahren ist … Genau das ist gemeint, wenn es in ‚Ankunft‘ heißt: vorbereitet, nicht überrumpelt“; Teil 1: „Eigentlich wollte sie sich im Büro noch einlesen. Ist nicht mehr passiert.“ | Den Rückbezug lösen, z. B. „Auch das gehört zu ‚vorbereitet, nicht überrumpelt‘ – an Tagen, an denen sie vom Büro aus startet“ | sollte |
| 7 | `kap-datenstand`, main Z. 1991 (v1.39 Z. 1997) | Pronomen für Navis wechselt im selben Satz (Rest aus R19 S14) | „nicht, weil es sich irrt, sondern weil der Eintrag, den er liest, nicht mehr stimmt“ | „den es liest“ | sollte |
| 8 | Anhang `kap-sysingboard-architektur`, main Z. 2026 bis 2030 (v1.39 Z. 2032 bis 2036) | Überschrift „in echt“ und Text lassen Navis als Teil des echten Dashboards erscheinen; real ist Navis nur geplant (R10). Im Mockup antwortet Navis auf „Erstelle den Leistungsnachweis“ mit „… erstellt … Zur Prüfung und Freigabe bereit“. Das liest sich wie Schreiben. Unten links steht ein Feld „Systemstatus“ mit „Backup (24h) OK“, der Text sagt aber, vom Monitoring sei nichts zu sehen. Angemeldet ist im Mockup eine andere Benutzerin, nicht Mira | „ein Mockup des echten Sysing-Dashboards, wie es Mira und ihre Kolleginnen täglich nutzen … Rechts eingeblendet: Navis selbst“; „Bewusst NICHT zu sehen: irgendetwas aus dem Monitoring“ | Ein Satz: Navis im Bild ist Zielbild, im realen Stand nicht gebaut; der gezeigte Leistungsnachweis ist ein Entwurf bis zur Freigabe; „Systemstatus“ meint das Dashboard selbst, nicht Kundensysteme | sollte |
| 9 | Anhang `kap-handout`, main Z. 2017 bis 2020 (v1.39 Z. 2023 bis 2026) | Das Handout-Bild zeigt Lumen in anderer Rolle als das Buch: „Dein Wissens- und Lernassistent“, mit „78 % Gesamtfortschritt“ und Folien im Dashboard. Im Buch ist Lumen der Agent für Management-Reports über den Hub. Der Text sagt „die Originalseite“, das Bild zeigt zwei Seiten (Navis und Lumen) | „die Originalseite …, auf der Navis und Lumen zuerst beschrieben wurden“ | „die beiden Originalseiten“ und ein Halbsatz: Lumens Rolle wurde seitdem auf die Report-Familie zugeschnitten | sollte |
| 10 | Teil 1 (Bezugslektüre): `kap-kaffeeecke` main Z. 823, 826, 827; dagegen `kap-warum-navis-lumen` Z. 1369 | Zeitlinie: Am Tag der Fahrt ist Kilians Navis-Test „offiziell“ nicht Teil der Arbeit. Ein Vierteljahr vorher hat Petra genau daraus ein offizielles Vorhaben gemacht | „gehört offiziell nicht dazu: ein Testfenster für Navis, mit dem er seit Wochen nach Feierabend herumspielt“; „inoffiziell die ersten Nutzer“; dagegen „macht aus seinem Feierabendprojekt offiziell ein Vorhaben mit Namen, Budget“ | In der Kaffeeecke „offiziell“ durch „zum Tagesgeschäft gehört das nicht“ ersetzen oder „seit Petras Freigabe vor einem Vierteljahr“ ergänzen | sollte |
| 11 | v1.39 Z. 692 (Deckblatt „Neu in v1.39“); dagegen v1.39 Z. 2107 und 2357 | Das Deckblatt verspricht je einen Satz, die Box hat bei sechs von sieben Standards zwei Sätze. Box und Historie sagen richtig „je ein kurzer Eintrag“ | „mit je einem Satz pro Standard“ | „mit je einem kurzen Eintrag pro Standard“ | kann |
| 12 | `kap-so-ist-es-gedacht`, aria-label und Grafik main Z. 1592, 1609 bis 1617 (v1.39 Z. 1597) | Der Fließtext nennt seit v1.38 den Hub, Grafik und aria-label nicht (Rest aus R19 S19) | „KI-Zentrale, die lesend auf Sysingboard und Report-Familie zugreift“ | aria-label ergänzen: „Navis auf das Sysingboard, Lumen über den Hub auf die Report-Familie“ | kann |
| 13 | aria-label main Z. 1169 (`kap-ankunft`), Z. 1150 (`kap-zwischenfall`), Z. 790 (`kap-kaffeeecke`) | Z. 1169 beschreibt einen Lichtkegel, den die Grafik nicht hat (gezeichnet: Gebäude, Tür, zwei gleichfarbige Fenster). Z. 1150 nennt ein „Warnsymbol“, gezeichnet ist ein Fragezeichen; diese Szene hat als einzige keine Bildunterschrift. Z. 790 holpert | „ein Lichtkegel aus zwei Farben trifft sich am Tor“; „Zwei Kolleginnen und Kollegen an einer Kaffeeecke“ | „Gebäude mit erleuchtetem Eingang und zwei beleuchteten Fenstern“; „Fragezeichen im Kreis“; „Kilian und Nora an der Kaffeeecke“ | kann |
| 14 | Bildunterschrift `kap-kaffeeecke`, main Z. 823; dagegen Personenliste Z. 732 und Text Z. 826 | Kilians Aufgabe heißt hier anders | „Offiziell Support und Kundenonboarding“; Liste: „Server- und Firewall-Administration“ | „Offiziell Serverbetreuung und Kundenonboarding“ | kann |
| 15 | Teil 1 (Bezugslektüre): `kap-kunde-der-ging`, main Z. 1130, 1141 | Die Figur wird nicht genannt. Das Zeitlabel deutet auf Mira (nur sie war bisher auf der A7), der Text auf Petra. Außerdem beginnt das Telefonat laut Label um 19:51 und ist um 19:54 schon drei Minuten vorbei | „19:54 · immer noch auf der A7“; „Der Anruf mit Horst ist kaum drei Minuten vorbei“ | Petra im ersten Satz nennen; Label auf „20:05 · Petra, weiter auf dem Heimweg“ oder ähnlich | kann |
| 16 | Bildunterschrift `kap-andere-fahrten`, main Z. 1574 | Nora fährt in dieser Szene nicht, sie sitzt mit Finn am Entwurf | „Dieselbe Straße, drei Fahrten“ | „drei Wege“ | kann |
| 17 | Teil 1 (Bezugslektüre): `kap-konferenztisch`, main Z. 1294 | Drei Ausfälle, aber „beide“ Tickets; der Bezug ist nur zu erraten | „drei Ausfälle in sechs Wochen … Beide bisherigen Tickets wurden mit einem Neustart geschlossen“ | „Die beiden früheren Tickets …“ | kann |
| 18 | Deckblatt-Box „Zur Einordnung“, main Z. 706; dagegen Anhang Z. 2030, 2040, 2054 | Die Box erklärt alle genannten Personen für erfunden. Der Anhang nennt aber eine reale Quelle mit Autor und Institut. Zwei Bildquellen schreiben reale Arbeitsunterlagen der erfundenen Firma zu. Ob das gewollt ist, ist unklar | „alle im Folgenden genannten Personen und Details sind frei erfunden“; „Quelle: interne Arbeitsunterlage, … Reling IT“ | In der Box ergänzen: „ausgenommen die Quellenangaben im Anhang“ | kann |
| 19 | Personenliste main Z. 738, `kap-kaffeeecke` Z. 827 | Berufsbezeichnung vermutlich veraltet: Der Ausbildungsberuf heißt nach meinem Kenntnisstand seit 2020 „Kauffrau für IT-System-Management“. Nicht im Repo belegt, bitte prüfen | „Auszubildende, IT-Systemkauffrau“ | bei Bestätigung anpassen | kann (unklar) |
| 20 | `kap-n8n`, main Z. 1944 | „quelloffen“ und „Fair-Code“ stehen nebeneinander; Fair-Code ist kein Open Source im engeren Sinn. Die Lizenzangabe selbst ist laut Historie v1.22 geprüft | „ein reales, quelloffenes Automatisierungswerkzeug (Fair-Code, Sustainable Use License, selbst hostbar)“ | „mit offen einsehbarem Quelltext“ | kann |
| 21 | `kap-datenstand`, main Z. 1992 | R10 und R21 empfehlen, das Managementcockpit als „in Erprobung“ einzuordnen. Der Hinweis fehlt | „markiert das Managementcockpit ein Projekt mit ‚Veröffentlichungsstand prüfen‘“ | „das Managementcockpit (in Erprobung)“ | kann |
| 22 | `kap-kommunikation`, main Z. 1829 | Zwei Doppelpunkte in einem Satz, dazu „über den Vermittler“ neben „direkt“ | „Lesen und Erklären laufen über den Vermittler: Navis liest direkt im Sysingboard“ | „… über den Vermittler. Navis liest im Sysingboard, Lumen über den Hub …“ | kann |
| 23 | Codebox `kap-umweg`, main Z. 881 bis 893 | Sichtbarer Text in ASCII-Umschrift, im Buch sonst mit Umlauten. Kann Absicht sein (Noras Bot verlor Umlaute) | „was der Bot koennen soll“, „Eingangsbestaetigung“, „Woerter“ | belassen oder Umlaute setzen; Entscheidung des Autors | kann |
| 24 | Versionshistorie, Zeile v1.38 main Z. 2307; Zeile v1.28 main Z. 2249 | v1.38 nennt den Block „Datenstand“ eine Anhang-Box, er steht in Teil 2. Dieselbe Zeile sagt „Report-Namen klein“ und schreibt zweimal „Areport“. In v1.28 steht noch ein Tippfehler (Rest aus R19 S23) | „in Teil 2 die Anhang-Box ‚Datenstand‘“; „(Areport, erlaubt)“; „fruehren“ | nur Hinweis; Historie wird nach Hausregel nicht umgeschrieben | kann |
| 25 | v1.39 Z. 2101, 2136 (Box „Die sieben Standards“); main Z. 2061 | „HI-Bibliothek“ wird nirgends aufgelöst. Der Name des Prüf-Standards ist in R04 nicht belegt, sein Verhältnis zu AQGS bleibt offen (schließt an C7 an) | „auch in den beiden Bibliotheken (TDF-Bibliothek und HI-Bibliothek)“; „AI-Assisted Engineering Acceptance Standard“ | Abkürzung einmal ausschreiben; Name des Prüf-Standards gegen das Standard-Repo prüfen | kann (unklar) |
| 26 | Mini-Inhaltsverzeichnis main Z. 689 bis 703, Personenliste Z. 714 | Die Personenliste hat einen Anker ohne Eintrag im Verzeichnis. Die Liste heißt „Personen bei Reling IT“ und führt den externen Coach mittendrin. Die Box „Aufbau in zwei Teilen“ erwähnt den Anhang nicht | `id="kap-personen"` ohne Link; „die wichtigsten Personen bei Reling IT“ | Eintrag „Wer vorkommt“ ergänzen; Horst ans Ende der Menschen stellen | kann |
| 27 | alt-Texte Anhang, main Z. 2039, 2043 | Z. 2039 nennt vier Fachreports, das Bild zeigt fünf Kästen (dazu „Audit-Extractor“) und Lumen. Z. 2043 ist sehr allgemein | „mit areport und den vier Fachreports ireport, qreport, nreport, sreport“; „mit erweiterten Komponenten“ | alt-Texte um die sichtbaren Hauptelemente ergänzen, zusammen mit Nr. 2 | kann |

Summe: 27 Befunde, davon 2 muss, 8 sollte, 17 kann.

### Bekannt, nicht gewertet

- R65-Stellen: Backup-Ticket und Kaffeeecke-Satz (main Z. 832), Navis-Zeitangabe bei Noras Bot (Z. 873), Herkunft des zweiten Switches (Z. 1533 bis 1540), „Cockpit“ (Z. 1536, 1547), Handout-Datum.
- C1 bis C7 aus R29 vom 10.11. Nur als Hinweis zu C3: main Z. 2270 gehört zum Eintrag v1.31, nicht v1.36.
- ADF-Zeile (main Z. 1748, v1.39 Z. 1753), Datum v1.39 und fehlende Erwähnung der Kontraste in der Historienzeile 1.39 (R63 Nr. 4, 5, 7).
- Aus R19 weiter sichtbar und dort schon gemeldet: Navis „kann die Sperrung vorbereiten“ (Z. 1318), Lumen legt Seiten auf ein Tablet (Z. 1090, 1300), Werkzeug „Arbeitspaket-Entwurf anlegen“ (Z. 1762), ASCII-Umschrift in alten Historienzeilen.

## Regelcheck

| Regel | Teil 2 | Anhang | v1.39-Unterschiede |
|---|---|---|---|
| Navis liest nur das Sysingboard, schreibt nie, empfiehlt | eingehalten (Z. 1590, 1829, 1936, 1993) | Text eingehalten (Z. 2062, 2077, 2083); Bild: Nr. 8 | Box: Navis nur als Gegenstand |
| Lumen liest nur über den Hub | eingehalten (Z. 1590, 1829, 1936); Ausnahme Nr. 4, Rest Nr. 12 | Bilder: Nr. 2, Nr. 9 | nicht berührt |
| Keine Scores | eingehalten (Z. 1937) | Verstoß im Bild: Nr. 2 | Box ohne Zahlen und Ampel |
| Zehn im Haus, Horst extern | Z. 1985, 2008 passen (bekannt, C4) | – | keine neue Person |
| Offen bleibt offen | eingehalten (Z. 1671, 1776 bis 1782, 1938, 1985, 2007 bis 2009) | eingehalten (Z. 2063, 2087 bis 2092) | „beschreibt die Box eine Lücke, keine Erfüllung“ |
| Zeitlinie, Namen, Orte, Wochentage | Nr. 6; sonst stimmig (Workshop Ende November Z. 1631; „An einem anderen Morgen“ Z. 1822) | Fußzeile 24.08.2026 gleich Historie v1.0 | Deckblatt und Historie beide 1.39 · 09.11.2026 |
| ß, Autobahn/A7 | keine ss-Formen im sichtbaren Text vor der Historie; „Landstraße“ nur noch in der Historienzeile v1.38; A7 und Autobahn einheitlich | ebenso | ebenso |
| Echte Repos nur belegt (E1 bis E5, U1 bis U5) | E1, E2, E4, E5 in Z. 1992 bis 1993 getroffen, U1 und U3 beachtet; Nr. 5, Nr. 21 | Nr. 1, Nr. 8 | Sätze der Box wortgleich mit R04 Z. 84 bis 89; Alias bis 30.06.2027 belegt (R04 Z. 100) |

Faktenliste aus Teil 1, gegen die geprüft wurde: Fahrt am Abend (19:42, A7 Richtung Süden, eineinhalb Stunden), Ankunft 07:58, Ende 08:34; Kaffeeecke 16:10, Petra 16:14, Telefonat 19:51; Baumann Elektrotechnik GmbH (Frank Baumann, Jule Fenner, Herr Vogt, Herr Brandt); Landhandel Rehder; Dornbach Fensterbau (Jonas Hellwig); Reiner montags bis donnerstags vormittags; Montagsrunde 08:58; „Die veralteten Daten“ am Freitag, Tausch am Dienstag; sechs Entwürfe am Konferenztisch; Lumen 11 + 5 + 4 = 20; sieben Zugänge; sieben Namen plus Mira plus Navis und Lumen ergibt zehn.

## Eigene Prüfabschnitte

- **Versionshistorie gegen Deckblatt:** main 1.38 · 07.11.2026 an beiden Stellen, 39 Zeilen. v1.39-Stand 1.39 · 09.11.2026 an beiden Stellen, 40 Zeilen. Eine Seitenzahl steht weder auf dem Deckblatt noch in den Zeilen 1.38 und 1.39. „Neu in v1.39“ passt bis auf Nr. 11.
- **Mini-Inhaltsverzeichnis:** Alle 19 Einträge von Teil 1 stimmen wörtlich und in der Reihenfolge mit den Überschriften überein. Teil 2 und Anhang nutzen Kurztitel; alle Anker lösen auf. Im v1.39-Stand ist „Die sieben Standards“ eingetragen. Keine doppelten IDs, kein Link ohne Ziel (main 39 Linkziele; im v1.39-Stand lösen auch die Fußnoten-Anker in beide Richtungen auf).
- **Bildunterschriften, alt, aria-label:** 31 Abbildungen, 29 Bildunterschriften (ohne: Deckblatt und „Der kleine Zwischenfall“), 28 aria-label (26 Grafiken, Logo, Inhaltsverzeichnis), 7 alt-Texte. `title` oder `desc` gibt es in keiner Grafik. Avatare sind `aria-hidden`. Keine ASCII-Umschrift mehr in aria-label. Alle Texte habe ich gegen die Grafik gelesen, die fünf Anhangbilder habe ich dafür angesehen. Ergebnis: Nr. 2, 3, 8, 9, 12, 13, 14, 16, 27. Der alt-Text der ZAVKK-Grafik stimmt mit dem Bild überein.
- **Personenliste:** neun Menschen (acht im Haus, Horst als extern markiert) plus Navis und Lumen. Rollen und Zugehörigkeit passen zum Text bis auf Nr. 14 und Nr. 19.
- **Die drei Deckblatt-Boxen:** „Zur Einordnung“ (Nr. 18), „Aufbau in zwei Teilen“ (Nr. 26), „Ausgangslage“ (nur C3, bekannt).
- **v1.39-Unterschiede:** Box mit sieben Einträgen in derselben Reihenfolge wie die Historienzeile; Fußnote ADR/ADG mit aria-label „Fußnote 1“ und „Zurück zum Text“; Kontrast-Tokens ändern nur CSS, keinen Text und keine Grafikfarben.

## Gelesene Kapitel

Zeilen in main 8abe213.

| Abschnitt | Zeilen | Umfang |
|---|---|---|
| Deckblatt, Neu-Hinweis, Mini-Inhaltsverzeichnis, drei Boxen, Personenliste | 620 bis 784 | vollständig |
| Teil 1, 19 Kapitel (Kaffeeecke bis Ankunft, noch einmal) | 788 bis 1581 | vollständig, als Bezugslektüre; nur Auffälliges gemeldet |
| So ist es tatsächlich gedacht | 1587 bis 1693 | vollständig |
| Architektur-Exkurs | 1695 bis 1785 | vollständig |
| Was passiert, wenn Mira mit Navis und Lumen kommuniziert? | 1787 bis 1877 | vollständig |
| Woher kommen die Infos und wo gehen sie hin? | 1879 bis 1939 | vollständig |
| n8n | 1941 bis 1986 | vollständig |
| Datenstand | 1988 bis 2012 | vollständig |
| Anhang: Handout, Sysingboard, Report-Familie, ZAVKK, Prüf-Standard | 2014 bis 2095 | vollständig, mit Bildern |
| Versionshistorie und Fußzeile | 2097 bis 2315 | vollständig |
| v1.39-Stand: alle Unterschiede zu main (CSS-Tokens, Deckblatt, Verzeichnis, Fußnote, Box, Historienzeile) | v1.39 Z. 32 bis 41, 48, 318 bis 320, 684 bis 706, 1753 bis 1757, 2101 bis 2139, 2354 bis 2357 | vollständig per Diff |

## Nicht geprüft

- **PDF** (`source/Die-Fahrt-zum-Kunden.pdf`, `story/current/geschichte.pdf`): nicht geöffnet, kein Render. Seitenzahl und PDF-Deckblatt stehen in R63.
- **`story/current/fahrt-zum-kunden.html`, `lesen.html`, `anhang.html`, `index.html`, Handout-Dateien:** nicht Teil des Auftrags.
- **Externe Links** (drei n8n-Adressen, ein Video): nicht aufgerufen.
- **Quellenangabe der ZAVKK-Grafik** (Autor, Institut, Buchtitel) und das im Text genannte „KI-Strategie-Journal“: im Repo nicht belegbar, unklar.
- **Reale Repos:** nicht neu abgefragt; Grundlage sind R04, R10 und R21 (Stand 06. und 07.11.2026). Die Aussage, die Report-Familie laufe nur im lokalen Netz ohne eigene Benutzerverwaltung (main Z. 1737), ist in diesen Berichten nicht belegt: unklar.
- **Zwei Bildmarken** in der Personenliste: nur die alt-Texte gelesen.
- **CSS vor Z. 620:** nur die geänderten Tokens im Diff.
- **R65-Stand:** nur den Diff gelesen, um die bekannten Stellen abzugrenzen.

## Vorschläge und Ideen (Claude)

Alles in diesem Abschnitt ist eine Empfehlung der KI-Sitzung, keine Tatsache.

1. Nr. 1 und Nr. 2 vor R60 dem Product Owner einzeln vorlegen. Beide lassen sich mit je einem Satz lösen, ohne Bild und ohne neue Seite. Ob die Seitenzahl 80 hält, zeigt erst der Render.
2. Die Anhangbilder in die Einbau-Checkliste Abschnitt 5 aufnehmen: „Zeigt ein Bild einen Score, eine Ampel oder eine Fähigkeit, die der Text ausschließt?“ Die Bilder waren bisher in keiner Prüfung enthalten (R19: „Bildinhalte habe ich nicht geprüft“).
3. Nr. 3, 4, 5 und 7 sind Einzeiler. Sie könnten als Nachtrag in den R65-Branch gehen, falls der Product Owner zustimmt.
4. Für aria-label eine feste Regel: beschreiben, was gezeichnet ist, nicht was gemeint ist. Bei jeder Änderung an einer Grafik den aria-label mitprüfen (Nr. 3, 12, 13).
5. Abschnitt 5 der Einbau-Checkliste nennt noch Zeilen aus v1.37 (1030, 1875, 1876). Besser auf Kapitel-Anker umstellen, wie schon in R19 vorgeschlagen.
6. Nach R65 heißt es in der Geschichte „das Sysingboard markiert“, in „Datenstand“ weiter „Managementcockpit“. Das passt zusammen, ein Halbsatz „das Managementcockpit im Sysingboard“ würde es aber verbinden.
7. Eine kleine CI-Warnung auf sichtbare Wörter wie „Reifegrad“ oder „Score“ außerhalb der Verbotsformulierung hilft bei Text, nicht bei Bildern. Für Bilder bleibt nur die Sichtprüfung.

## Hygiene

Arbeitsklon unverändert (`git status -sb`: `## main...origin/main`, HEAD 8abe213, kein Stash); Wegwerf-Worktree `<scratchpad>/r69/wt` mit `git worktree remove --force` entfernt und in `git worktree list` nicht mehr vorhanden. Hinweis: Mein anschließendes `git worktree prune` lief zu einem Zeitpunkt, als der Ordner eines fremden Probe-Worktrees (`<scratchpad>/r65-probe`, vorher in der Liste) nicht mehr existierte; dessen Eintrag steht seitdem nicht mehr in der Liste. Ob der Eintrag durch mein `prune` oder durch die andere Sitzung verschwand, ist unklar. Verbliebene Einträge: Arbeitsklon, r65, r73, wt-r06, wt-r41, wt-r62, wt-rep.

## Nachtrag des Koordinators (12.11.2026, 04:55)

- Gegenprobe am Text von main 8abe213: Nr. 1 bestätigt (Z. 2064 „den Code hinter Navis und Lumen … läuft bei jeder Änderung automatisch mit“ gegen Z. 1993 „Navis ist im realen Repo (Stand 06.11.2026) noch nicht als Code vorhanden“). Nr. 3 bestätigt (aria-label Z. 1700 „von unten nach oben“). Der Text zu Nr. 2 (Z. 1937 „keinen Reifegrad-Score“) ist bestätigt; die Bildinhalte zu Nr. 2, 8 und 9 habe ich nicht selbst angesehen.
- Zum Hinweis in der Hygiene-Zeile: Den Probe-Worktree `r65-probe` hat der Koordinator selbst mit `git worktree remove --force` entfernt (R65, Probe-Merge). Das `prune` des Agenten hat nichts Fremdes gelöscht.
- Die Einstufung „muss“ für Nr. 1 und Nr. 2 ist eine Empfehlung; die Entscheidung liegt beim Product Owner. Bis dahin sollte R60 nicht rendern, weil ein einordnender Satz die Seitenzahl ändern kann.

Hygiene: gemergte Remote-Branches 0; offene PRs 10 (#25 bis #28, #30 bis #35), alle Draft.

```yaml
Reifegrad: Buchquelle main und v1.39-Probe ab Teil 2 samt Anhang, Bildtexten und Versionshistorie gelesen; 27 Befunde (2 muss als Empfehlung, 8 sollte, 17 kann)
Projektstatus: zwei Muss-Empfehlungen im Anhang vor R60 zu entscheiden; Upload v1.38 weiter offen
Offene_Fragen:
  - Anhang Functional is not Done - Aussage zur laufenden CI fuer Navis- und Lumen-Code einordnen oder umformulieren?
  - Architekturbilder mit Reifegrad- und Compliance-Prozenten - einordnender Satz oder Bildtausch?
  - Welche der acht Sollte-Befunde gehen noch in v1.39?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
