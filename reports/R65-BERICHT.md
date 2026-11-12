---
id: R65
titel: 'Korrekturen v1.39: Backup-Ticket, Navis-Zeitangabe, zweiter Switch, Cockpit, Handout-Datum'
status: erledigt (Draft-PR, CI erwartungsgemäß rot; Wortlaut zur Prüfung vorgelegt; Handout-PDF offen)
start: 2026-11-12T04:42+01:00
ende: 2026-11-12T04:50+01:00
branch: auftrag-R65-korrekturen-v139 (Worktree C:/dev/wt/relingit/r65, Basis origin/main 8abe213)
pr: '#35 (Draft)'
commit: 348ee9e (signiert)
ci: 'rot – genau 1 Fehler: story/current/fahrt-zum-kunden.html weicht von source/ ab (erwartet, wie #33; Lesefassung und PDF folgen in R60)'
---

# R65 – Korrekturen v1.39 in der Buchquelle

Auftrag: `queue/R65.yaml` (ops/queue 9ffaea5), Gate durch den Auftrag des Product Owners vom 12.11. Geändert sind drei Dateien (+7 −7): `source/fahrt-zum-kunden.html`, `handout.html`, `story/current/workshop-handout.html`. Nicht geändert: `story/current/fahrt-zum-kunden.html`, beide Buch-PDFs, das Handout-PDF.

## Wortlaut zur Prüfung durch den Product Owner

Der eingebaute Wortlaut ist ein Vorschlag. Wo es eine Wahl gab, steht eine Alternative dabei. Zeilennummern gelten für origin/main 8abe213.

### Punkt 1 – Backup-Ticket (Kapitel Kaffeeecke, Zeile 832)

- **Vorher:** „… blinkt kurz eine Zeile aus dem allgemeinen Alarmkanal auf – irgendein Kunde, dessen nächtlicher Backup-Job zum zweiten Mal fehlgeschlagen ist. Kilian registriert es, ohne genauer hinzusehen; darum kümmert sich heute Abend ohnehin jemand anderes.“
- **Nachher:** „… blinkt kurz eine Zeile aus dem allgemeinen Alarmkanal auf – der Landhandel Rehder, dessen nächtlicher Backup-Job wieder einmal fehlgeschlagen ist. Kilian registriert es, ohne genauer hinzusehen; um Rehder kümmert sich heute Abend ohnehin jemand anderes.“
- **Begründung:** Die Entscheidung verlangt einen anderen Kunden per Name oder eindeutigem Zusatz. Rehder ist im Buch schon Kunde, und dort geht es um die Sicherung (Zeile 920: altes NAS, „bevor die nächste Sicherung wieder eine Stunde länger braucht“). Es wird kein neuer Name erfunden. „zum zweiten Mal“ ist durch „wieder einmal“ ersetzt, weil Navis für Baumann wörtlich „zum zweiten Mal in Folge fehlgeschlagen“ meldet (Zeile 1056); zwei Kunden mit demselben Befund läse sich wieder wie eine Verbindung.
- **Zu prüfen:** (a) Passt Rehder? Das Kapitel „Der klare Auftrag“ spielt an einem Vormittag bei Rehder mit dem NAS-Tausch; ob dieser Vormittag vor oder nach dem Kaffeeecken-Nachmittag liegt, legt das Buch nicht fest (unklar). (b) „wieder einmal“ statt „zum zweiten Mal“ geht über die Mindeständerung hinaus.
- **Alternative ohne Namen:** „– irgendein anderer Kunde, nicht der von Miras Termin morgen, dessen nächtlicher Backup-Job fehlgeschlagen ist. … darum kümmert sich heute Abend ohnehin jemand anderes.“
- Unverändert: Navis-Aussage „Beides steht offen im Kundenprojekt, niemand ist aktuell zugewiesen“ (Zeile 1056). Offen bleibt offen.

### Punkt 2 – Navis-Zeitangabe (Kapitel Der Umweg, Zeile 873)

- **Vorher:** „Angefangen hat es vor gut einem Jahr, kurz nach ihrem Start im Systemhaus. Überall wurde über Navis und Lumen geredet, und Nora wollte unbedingt auch etwas bauen.“
- **Nachher:** „Angefangen hat es vor gut einem Jahr, kurz nach ihrem Start im Systemhaus. Überall wurde über KI-Assistenten geredet, auch im Haus, lange bevor Navis und Lumen dort tatsächlich einzogen – das ist erst ein Vierteljahr her –, und Nora wollte unbedingt auch etwas bauen.“
- **Begründung:** Geredet wurde schon länger, der Bot ist gut ein Jahr alt, Navis und Lumen sind erst seit einem Vierteljahr im Haus. Der Rest des Absatzes (Noras Ton, „nichts, was mit Navis oder Lumen selbst zu tun hatte“) ist unverändert.
- **Zu prüfen:** „das ist erst ein Vierteljahr her“ rechnet vom Zeitpunkt des Gesprächs aus. Das stimmt, wenn „Der Umweg“ etwa zur Zeit der Fahrt spielt; das Buch sagt es nicht ausdrücklich (unklar).
- **Alternative:** „… geredet, auch im Haus – Navis und Lumen selbst gab es dort damals noch nicht –, und Nora wollte …“ (ohne Vierteljahr; die Zahl steht dann nur im Kapitel „Warum Navis und Lumen“).
- **Beobachtung, nicht geändert:** In derselben Rückblende sagt Kilian (Zeile 876): „bei Navis steht am Anfang immer die Frage: was genau soll er können …“. Das Gespräch liegt gut ein Jahr zurück, also vor dem Einzug von Navis. Es passt nur, wenn Kilian damals schon an Navis gebaut hat. Vorschlag: vom Product Owner entscheiden lassen, ob der Satz bleibt.

### Punkt 3 – Zweiter Switch (Kapitel Die veralteten Daten, Zeile 1540)

- **Vorher:** „… Alles in Ordnung, nur eben nicht neu für sie. Zurück im Auto, die Tür noch offen, …“
- **Nachher:** „… Alles in Ordnung, nur eben nicht neu für sie. Den Switch in ihrem Karton hatte sie am Montag selbst aus dem Lager geholt, einen Tag bevor Reiner seinen einbaute; keiner wusste vom anderen. Zurück im Auto, die Tür noch offen, …“
- **Begründung:** Ein Satz, ohne Schuldzuweisung, an der Stelle, an der Mira beide Geräte vor sich hat. Früher (Zeile 1533) würde er die Auflösung vorwegnehmen.
- **Zu prüfen:** (a) „am Montag“ ist von mir gesetzt: Reiner hat laut Zeile 1539 am Dienstag getauscht, die Entscheidung sagt „bevor Reiner tauschte“. (b) „aus dem Lager“ statt „per Express“: Eine Express-Bestellung eines Switches für Dornbach gibt es schon im Kapitel „Die Freigabegrenze“ (Zeile 956, Insa). Ob Reiner jenes Gerät verbaut hat, sagt das Buch nicht (unklar); mit „Lager“ entsteht kein neuer Widerspruch.
- **Alternative:** „Den Switch in ihrem Karton hatte sie schon Anfang der Woche aus dem Lager mitgenommen, bevor Reiner seinen einbaute; keiner wusste vom anderen.“

### Punkt 4 – Cockpit (Kapitel Die veralteten Daten, Zeilen 1536 und 1547)

| Zeile | Vorher | Nachher |
| --- | --- | --- |
| 1536 (Navis) | „… das Cockpit markiert es seit gestern mit ‚Veröffentlichungsstand prüfen‘.“ | „… das Sysingboard markiert es seit gestern mit ‚Veröffentlichungsstand prüfen‘.“ |
| 1547 (Erzähltext) | „Das Cockpit hat es seit gestern markiert.“ | „Das Sysingboard hat es seit gestern markiert.“ |

Grammatik: beide Wörter sind Neutrum, der Satzbau bleibt. Navis liest weiter nur („steht dort nicht, und ich kann es nicht wissen“). Nicht geändert: „Managementcockpit“ im Sachteil „Datenstand“ (Zeile 1992); dort wird das reale Produkt beschrieben, der Befund nannte zwei Stellen. Falls auch diese Stelle gemeint ist, bitte als Entscheidung nachreichen.

### C6 – Handout-Datum

| Datei | Zeile | Vorher | Nachher |
| --- | --- | --- | --- |
| `handout.html` | 29 | „Workshop-Handout · September 2026“ | „Workshop-Handout · Ende November 2026“ |
| `story/current/workshop-handout.html` | 147 | „Workshop-Vorbereitungsmaterial · September 2026“ | „Workshop-Vorbereitungsmaterial · Ende November 2026“ |

**Nicht erledigt: Handout-PDF.** `story/current/workshop-handout.pdf` ist nicht neu gerendert. Im Repository gibt es keinen Renderweg für das Handout (`scripts/pdf/render_story_pdf.py` rendert nur die Geschichte, mit festem Fußzeilentext und festen Metadaten). Das PDF (2 Seiten) trägt weiter „September 2026“ in der Kopfzeile und im Metadatenfeld Subject. Ein Render mit geratenen Rändern und Metadaten wäre nicht belegbar gewesen.

## Prüfungen

| Prüfung | Ergebnis |
| --- | --- |
| `scripts/ci-check.ps1` im Worktree | Exit 1, genau 1 Fehler: story/current weicht von source ab (erwartet) |
| GitHub-CI auf #35 (Lauf 43150749461) | rot mit demselben einen Fehler |
| Pester (`Invoke-Pester tests`, Pester 3.4) | 21 bestanden, 0 fehlgeschlagen |
| `git merge-tree` gegen #25, #26, #27, #33 | je 0 Konflikte |
| Probe-Merge main + #27 + #33 + R65 im Wegwerf-Worktree (Scratchpad), dann ci-check | 3 Merges ohne Konflikt; ci-check wieder nur der eine erwartete Fehler; alle fünf neuen Textstellen im Ergebnis vorhanden; Worktree entfernt |
| Regelcheck | Navis liest nur, schreibt nie (Punkt 4); Baumann bleibt unzugewiesen (Punkt 1); zehn im Haus, Lumen/Hub nicht berührt; ß und Autobahn/A7 nicht berührt |

Hinweis zum Pester-Lauf: Er lief auf dem Arbeitsbaum vor dem Commit; die Tests arbeiten auf eigenen Mini-Projekten.

## Weitere Fundstellen „September 2026“ (nicht Teil des Auftrags, nicht geändert)

| Fundstelle | Inhalt | Vorschlag |
| --- | --- | --- |
| `scripts/pdf/render_story_pdf.py` Z. 87 | PDF-Metadatum Subject der Geschichte: „… Workshop September 2026“ | in R60 vor dem Rendern angleichen (kann) |
| `story/current/workshop-handout.pdf` | Kopfzeile und Subject „September 2026“ | mit dem Neurendern des Handouts (sollte) |

## Abweichungen

- Worktree unter `C:\dev\wt\relingit\r65` (neue Ablage-Vorgabe), nicht unter `C:\dev\wt-*`.
- Mit #35 sind zehn Agenten-PRs offen (Vorgabe 3); der Auftrag des Product Owners vom 12.11. verlangt ausdrücklich einen Draft-PR.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Für das Handout einen kleinen Auftrag anlegen: Renderweg ins Repository holen (Parameter für Fußzeile und Metadaten in `render_story_pdf.py` oder ein zweites Skript), dann HTML und PDF als Paar rendern. Bis dahin #35 nicht vor dem Handout-PDF mergen oder die Handout-Zeile aus #35 herausnehmen.
- Monat und Jahr des Workshops an einer Stelle führen (wie Version und Datum) und von ci-check gegen Deckblatt, Handout und PDF-Metadaten prüfen lassen.
- Die Beobachtung zu Zeile 876 (Kilian spricht in der Rückblende von Navis) zusammen mit Punkt 2 entscheiden.
- R60 sollte #35 in den Block mit #27 und #33 aufnehmen; der Probe-Merge oben zeigt, dass das ohne Konflikt geht.

Hygiene: gemergte Remote-Branches 0; offene PRs 10 (#25 bis #28, #30 bis #35), alle Draft.

```yaml
Reifegrad: Korrekturen v1.39 als Draft-PR 35, konfliktfrei mit 27 und 33; Wortlaut zur Pruefung vorgelegt; Handout-PDF offen
Projektstatus: v1.39 wartet auf Wortlaut-Pruefung, Merge-Block und R60; Upload v1.38 weiter offen
Offene_Fragen:
  - Wortlaut der Punkte 1 bis 3 so uebernehmen oder Alternative?
  - Managementcockpit im Sachteil (Zeile 1992) ebenfalls ersetzen?
  - Kilians Navis-Satz in der Rueckblende (Zeile 876) lassen?
  - Wie wird das Handout-PDF neu gerendert (kein Renderweg im Repository)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
