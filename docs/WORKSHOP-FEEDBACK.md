# Workshop-Feedback: Vorlage

Eine Seite, um Rückmeldungen aus dem Workshop zu „Die Fahrt zum Kunden“ ohne Suchen in die Warteschlange zu bringen. Auftrag R95 (`queue/R95.yaml` auf dem Branch `ops/queue`).

## Regeln

- **Sammeln und parken.** Rückmeldungen werden gesammelt und geparkt. Nur ein Muss-Fehler wird sofort korrigiert (Entscheidung des Product Owners vom 12.11.2026, vermerkt in `queue/R72.yaml`).
- **Muss-Fehler** heißt: falsche Aussage, kaputter Link, fehlende oder unlesbare Seite, Fehler, der Lesende in die Irre führt. Er bekommt einen eigenen Auftrag in der Warteschlange und läuft wie jede Version durch die Tore G1 bis G8 ([FREIGABE.md](FREIGABE.md)).
- **Zuordnung.** Jede Rückmeldung wird einem Kapitel oder einer Stelle der Webseite zugeordnet und, wenn möglich, einer vorhandenen Idee oder einem Auftrag.
- **Wer** steht als Rolle (zum Beispiel „Teilnehmende“, „Moderation“, „Product Owner“). Ein Klarname ist nicht nötig und gehört nicht in dieses öffentliche Repository.
- **Nicht hierher:** Zugangsdaten, Kontaktdaten, Inhalte aus dem Leserfeedback der Webseite (Supabase). Diese Vorlage ist nur für Rückmeldungen aus dem Workshop.

## Felder

| Feld | Inhalt | Beispiel |
| --- | --- | --- |
| Datum | Tag der Rückmeldung (JJJJ-MM-TT) | 2026-11-30 |
| Wer | Rolle, kein Klarname | Teilnehmende |
| Fundstelle | Kapitel und Seite der PDF, oder Seite und Abschnitt der Webseite | Kapitel 3, S. 24; Startseite, Abschnitt Podcast |
| Beobachtung | Was aufgefallen ist, in einem Satz | Begriff „AVKK“ wird vor seiner Erklärung benutzt. |
| Art | eine von: Muss-Fehler sofort · Korrektur · Idee · geparkt | Korrektur |
| Vorschlag | Was geändert werden könnte, in einem Satz | Kurze Erklärung beim ersten Vorkommen ergänzen. |
| Queue-Verweis | Auftrag in `ops/queue` (zum Beispiel `Rnn`) oder „neu“ | neu |

## Sammeltabelle

Zum Ausfüllen kopieren. Eine Zeile je Rückmeldung.

| Datum | Wer | Fundstelle | Beobachtung | Art | Vorschlag | Queue-Verweis |
| --- | --- | --- | --- | --- | --- | --- |
| | | | | | | |

## Nach dem Workshop

1. Die ausgefüllte Tabelle an die Planer-Session geben.
2. Muss-Fehler als eigene Aufträge anlegen, die übrigen Zeilen gesammelt als geparkt in die Warteschlange.
3. Über die geparkten Rückmeldungen entscheidet der Product Owner, zusammen mit der Entscheidung zur Pause nach dem Workshop.
