---
id: R74
titel: 'R65 nachbessern: Wortlaut-Entscheidungen des Product Owners vom 12.11. in PR #35'
status: erledigt (PR #35 bleibt Draft, CI erwartungsgemäß rot)
start: 2026-11-12T05:25+01:00
ende: 2026-11-12T05:29+01:00
branch: auftrag-R65-korrekturen-v139 (Worktree C:/dev/wt/relingit/r65)
pr: '#35 (Draft)'
commit: db2804b (signiert)
---

# R74 – Wortlaut-Entscheidungen zu R65 eingearbeitet

Auftrag: `queue/R74.yaml` (ops/queue 879ce72), Gate ja; ausgeführt auf die Anweisung des Product Owners, die Warteschlange weiter abzuarbeiten. Geändert ist nur `source/fahrt-zum-kunden.html`, drei Zeilen (+3 −3 gegenüber R65).

## Vorher/Nachher

Zeilen in main 8abe213. „R65“ ist der Stand von Commit 348ee9e, „R74“ der neue Stand.

| Punkt | Zeile | R65 | R74 (Entscheidung 12.11.) |
| --- | --- | --- | --- |
| 1 Backup-Ticket | 832 | „– der Landhandel Rehder, dessen nächtlicher Backup-Job wieder einmal fehlgeschlagen ist. Kilian registriert es, ohne genauer hinzusehen; um Rehder kümmert sich heute Abend ohnehin jemand anderes.“ | „– irgendein anderer Kunde, nicht der von Miras Termin morgen, dessen nächtlicher Backup-Job fehlgeschlagen ist. Kilian registriert es, ohne genauer hinzusehen; darum kümmert sich heute Abend ohnehin jemand anderes.“ |
| 2 Navis-Zeitangabe | 873 | „… geredet, auch im Haus, lange bevor Navis und Lumen dort tatsächlich einzogen – das ist erst ein Vierteljahr her –, und Nora wollte unbedingt auch etwas bauen.“ | „… geredet, auch im Haus – Navis und Lumen selbst gab es dort damals noch nicht –, und Nora wollte unbedingt auch etwas bauen.“ |
| 3 Zweiter Switch | 1540 | „Den Switch in ihrem Karton hatte sie am Montag selbst aus dem Lager geholt, einen Tag bevor Reiner seinen einbaute; keiner wusste vom anderen.“ | „Den Switch in ihrem Karton hatte sie schon Anfang der Woche aus dem Lager mitgenommen, bevor Reiner seinen einbaute; keiner wusste vom anderen.“ |

Unverändert wie entschieden: „Sysingboard“ in Z. 1536 und 1547; „Managementcockpit“ in Z. 1992; Kilians Satz in der Rückblende (in der Datei Z. 877, im Auftrag als Z. 876 genannt); Handout-Zeilen aus R65. Gegenüber main besteht Punkt 1 damit aus dem Wort „anderer“, dem Einschub „nicht der von Miras Termin morgen“ und der Streichung von „zum zweiten Mal“; der Folgesatz ist wieder wortgleich mit main.

## Prüfungen

| Prüfung | Ergebnis |
| --- | --- |
| `scripts/ci-check.ps1` | Exit 1, genau 1 Fehler: story/current weicht von source ab (erwartet) |
| GitHub-CI auf #35 (Lauf 43155041365, Head c1efb21 mit R75) | rot mit demselben einen Fehler |
| Pester | 21 bestanden, 0 fehlgeschlagen (auf db2804b) |
| `git merge-tree` gegen #25, #26, #27, #33, #36 | je ohne Konflikt |
| Probe-Merge main + #27 + #33 + #35 (Head c1efb21) im Wegwerf-Worktree, ci-check | drei Merges ohne Konflikt, nur der eine erwartete Fehler; die drei neuen Sätze vorhanden, die drei alten nicht mehr; Worktree entfernt |
| Regelcheck | Navis liest nur (unverändert); Baumann bleibt unzugewiesen, Z. 1056 unverändert; keine neue Person, kein Kundenname; kein Wochentag und keine Zahl im Kapitel Der Umweg; ß und A7 nicht berührt |

Die PR-Beschreibung von #35 ist auf den Stand R65, R74 und R75 gebracht.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- In `reports/SICHTUNG-v1.39.md` ist Punkt I05 an die Entscheidung angepasst (keine Zahl mehr im Kapitel „Der Umweg“); die übrigen Punkte beschreiben die Wirkung und passen weiter.
- Die zwei Anhang-Empfehlungen aus R69 könnten als weiterer Nachtrag auf #35 gehen, sobald entschieden ist; danach ist der Buch-Block für R60 vollständig.

Hygiene: gemergte Remote-Branches 0; offene PRs 11 (#25 bis #28, #30 bis #36), alle Draft.

```yaml
Reifegrad: PR 35 traegt den entschiedenen Wortlaut; konfliktfrei mit 27 und 33; CI rot nur wegen story/current bis R60
Projektstatus: v1.39 wartet auf Entscheidung zu R69 Nr. 1 und 2, dann Merge-Block und R60; Upload v1.38 weiter offen
Offene_Fragen:
  - R69 Nr. 1 und Nr. 2 vor R60 loesen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
