# R44 – Aufräumen nach Release-Merge

Stand: 2026-11-09, 04:36 bis 04:41 (Ortszeit, mit `date` geprüft). Ausgeführt vom Koordinator (Claude Code CLI), Remote-Löschung auf ausdrückliche Anweisung von Bernd in der Sitzung vom 09.11.2026.

## Ergebnis
Erledigt. Remote-Branch `auftrag-R03-buchtext-v138` gelöscht, zwei gemergte Worktrees entfernt, zehn gemergte lokale Branches gelöscht. Worktrees wt-r35 bis wt-r40 waren bereits nicht mehr vorhanden.

## Vorprüfung Remote-Branch auftrag-R03-buchtext-v138
- `gh pr view 9 --json state,mergedAt`: `"state":"CLOSED"`, `"mergedAt":null` – PR #9 geschlossen.
- `git merge-base --is-ancestor 1f49164 origin/main`: Exit 0 – Inhalt 1f49164 ist in main.
- `git log origin/main..origin/auftrag-R03-buchtext-v138`: nur `d7d7e16 Merge branch 'main' into auftrag-R03-buchtext-v138` (Eltern 1f49164, 361f26c) – wie im Auftrag erwartet.
- Gegenprobe Inhalt: `git merge-tree --write-tree origin/main origin/auftrag-R03-buchtext-v138` ergibt Baum `998f944…`, identisch mit dem Baum von origin/main (`998f944…`). Der Branch bringt keinen Inhalt mit, der in main fehlt.
- Löschung: `git push origin --delete auftrag-R03-buchtext-v138` → `- [deleted] auftrag-R03-buchtext-v138`.

## Worktrees

| Worktree | Branch | git status | in origin/main | Aktion |
|---|---|---|---|---|
| wt-r35 bis wt-r40 | – | – | – | nicht vorhanden (schon früher entfernt), nichts zu tun |
| C:\dev\wt-fix-lesen | auftrag-fix-lesen-schriften | sauber (0 Zeilen) | ja (PR #23 gemergt) | `git worktree remove`, Branch gelöscht |
| C:\dev\wt-r43 | auftrag-r43-freigabe | sauber (0 Zeilen) | ja (PR #22 gemergt) | `git worktree remove`, Branch gelöscht |
| scratchpad/ops-reports | ops/reports | – | – | belassen (Ablage-Worktree für Berichte) |
| C:\dev\wt-p5f, wt-p6, wt-p7, wt-p8, wt-queue | Repo bmarnau-standards/uebersicht | sauber | – | belassen, gehören nicht zu relingit |
| C:\dev\wt-tdf38 | Repo bmarnau-standards/technical-documentation-framework | sauber | – | belassen, gehört nicht zu relingit |

Die Dateien `C:\dev\wt-*-pr.md` und `wt-*-review.md` sind keine Worktrees und gehören zu den uebersicht-Arbeiten; belassen.

## Lokale Branches
Gelöscht mit `git branch -d` nach `git merge-base --is-ancestor <branch> origin/main` (Exit 0): auftrag-R03-buchtext-v138, auftrag-R24-pester-tests, auftrag-R35-podcast-sicherung, auftrag-R36-podcast-hilfen, auftrag-R37-notebooklm, auftrag-fix-lesen-schriften, auftrag-r39-doku, auftrag-r40-barrierefreiheit, auftrag-r43-freigabe, geschichte-veraltete-daten-20261107.

Sonderfall `docs/sitzungsroutine`: per Squash gemergt (PR #24, main 01defe7), daher kein Vorfahre von main. `git diff --stat docs/sitzungsroutine origin/main` ohne Ausgabe (Inhalt identisch), deshalb mit `git branch -D` gelöscht.

Belassen: main, ops/queue (lokal veraltet, wird nicht verwendet), ops/reports.

## Remote nach dem Aufräumen
`git fetch -p; git branch -r`: origin/main, origin/ops/queue, origin/ops/reports und neu origin/auftrag-R11-avatare-webseite (heutiger Auftrag R11). Keine gemergten Feature-Branches mehr auf dem Remote. `auftrag-fix-lesen-schriften` und `auftrag-r43-freigabe` waren auf dem Remote schon gelöscht (PR #22/#23 gemergt).

## Abweichungen
- Keine. Remote-Löschung durch den Koordinator selbst, nicht durch einen Agenten.

## Vorschläge und Ideen (Claude)
- GitHub-Einstellung „Automatically delete head branches“ einschalten, dann entfällt ein Großteil dieser Aufräumaufträge.
- Einen kleinen Befehl `scripts/aufraeumen-pruefen.ps1` (nur lesend) anlegen, der genau diese Prüfungen (Worktree sauber, Branch in main, Squash-Gleichheit per diff) als Tabelle ausgibt; Löschen bleibt Handarbeit.
- Den veralteten lokalen Branch ops/queue (40 Commits hinter origin) entweder löschen oder per `git fetch origin ops/queue:ops/queue` aktuell halten, damit niemand versehentlich den alten Stand liest.

Hygiene: 0 gemergte Remote-Branches übrig; offene PRs: nur die heutigen Drafts aus R06, R07, R11 (siehe deren Berichte); nichts gemergt, kein Tag, kein FTP, keine Zugangsdaten, kein Force-Push.

```yaml
Reifegrad: Git-Stand aufgeraeumt, Remote nur main, ops/queue, ops/reports und aktive Auftragsbranches
Projektstatus: v1.38 in main, Paket ohne Audio gebaut (siehe PAKET-v1.38-2026-11-09-BERICHT.md), Upload durch Bernd offen
Offene_Fragen:
  - Soll auf GitHub das automatische Loeschen gemergter Branches aktiviert werden?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
