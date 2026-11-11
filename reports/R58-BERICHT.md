---
id: R58
titel: 'STATUS.yaml abgleichen: R34, R18 und Hinweis #29 (nur ops/reports)'
status: erledigt
start: 2026-11-11T04:32+01:00
ende: 2026-11-11T04:40+01:00
branch: ops/reports
quelle_queue: 'origin/ops/queue 02cbacf (Planer Claude, Co-Authored-By und Claude-Session-Link; Commit nicht signiert)'
---

# R58 Bericht: STATUS.yaml gegen INDEX.yaml

## Ergebnis

| Punkt | Vorher (STATUS.yaml) | Nachher | Beleg |
|---|---|---|---|
| R34 | blockiert | erledigt, Hinweis ergänzt | queue/R34.yaml `abschluss` (Kern durch R28 erledigt, Delta nach R36); ops/queue 185a7c1 vom 07.11.; PR #13 gemergt (main 44898de); reports/R34-BERICHT.md |
| R18 | kein Eintrag | erledigt, ohne eigenen Bericht | queue/R18.yaml `hinweis` (Teil von R16); reports/R16-BERICHT.md, Abschnitt „Icon-Umstellung“, Commit 788e882; `git merge-base --is-ancestor 788e882 origin/main` → ja (über PR #10, gemergt 08.11.) |
| #29 (R50) | bereits richtig: „gemergt 2026-11-09T11:05+01:00 durch Product Owner, Merge 8abe213“ | unverändert | `gh pr view 29`; die Abweichung steht nur in queue/INDEX.yaml (`pr: … nicht gemergt`) und ist Sache des Planers |

Außerdem: R57 (in_arbeit) und R58 (erledigt) eingetragen, `stand` und `quelle_queue` aktualisiert.

Prüfung: `yaml.safe_load(reports/STATUS.yaml)` ohne Fehler, 54 Einträge. Danach stimmt jeder Auftrag mit Eintrag in STATUS.yaml mit INDEX.yaml überein, außer R29 (wiederkehrend; INDEX geplant, STATUS führt den letzten Lauf) und den Aufträgen ohne Lauf (R09, R12, R41, R42, R52, R53).

## Abweichungen

- queue/INDEX.yaml nicht angefasst (Grenze des Auftrags). Dort sind noch veraltet: R50 `pr` („nicht gemergt“) und R11 `offen` („Draft-PR #25, Merge erst nach Release v1.38“, inhaltlich noch gültig).
- In STATUS.yaml steht R11 zweimal (Z. 46 alt `wartet_auf_voraussetzung`, später `erledigt`). Nicht geändert, weil nicht Teil von R58. Wer die Datei als Wörterbuch liest, bekommt den späteren Eintrag.
- Der Queue-Commit 02cbacf ist nicht signiert (Planer-Sitzung, mit Co-Authored-By und Session-Link), wie die früheren Planer-Commits.

## Vorschläge und Ideen (Claude)

- Den alten R11-Eintrag (Z. 46–48) streichen oder als `ersetzt` kennzeichnen; ein kleiner Prüfschritt in R29 könnte doppelte IDs in STATUS.yaml melden.
- Planer: In INDEX.yaml bei R50 `pr` auf „gemergt 09.11., main 8abe213“ setzen.
- Aufträge, die in einem anderen aufgehen (R18 in R16, R34 in R28), gleich beim Abschluss in STATUS.yaml mit Verweis eintragen, dann entstehen solche Lücken nicht.

Hygiene: gemergte Remote-Branches 0; offene PRs 7 (#25, #26, #27, #28, #30, #31, #32), alle Draft.

```yaml
Reifegrad: STATUS.yaml und INDEX.yaml stimmen fuer alle gelaufenen Auftraege ueberein (ausser wiederkehrendem R29)
Projektstatus: Release v1.38 wartet auf Upload und Live-Pruefung R09; Kreuzpruefung R57 laeuft
Offene_Fragen:
  - Alten R11-Eintrag in STATUS.yaml bereinigen?
  - INDEX.yaml R50 pr nachziehen (Planer)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
