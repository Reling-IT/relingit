---
id: MERGE-4-5
titel: 'Merge PR #4 und PR #5 (Einzelfreigabe des Owners)'
status: erledigt
datum: 2026-11-06
main_vorher: 6ea5f6d
main_nachher: 2f8cd6d3ac33d9b29496c18c2d9729325386107d
ci_main: 'success, https://github.com/Reling-IT/relingit/actions/runs/42196366497'
---

# Bericht: Merge PR #4 und PR #5

## Ergebnis

- PR #4 und PR #5 sind in dieser Reihenfolge per Merge-Commit in `main` übernommen.
- Beide Merges hat der Owner selbst ausgeführt (`mergedBy: bmarnau`). Der Prüfmodus von Claude Code hatte `gh pr merge` für Claude blockiert („Merge Without Review“).
- Für PR #5 war kein „Update branch“ nötig.
- Auf `main` (2f8cd6d) laufen `ci-check.ps1`, `node --check` und die GitHub-CI ohne Fehler.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Vorbedingungen | #4 und #5 offen, kein Draft, `MERGEABLE`/`CLEAN`, „Website prüfen“ `SUCCESS` | `gh pr view 4/5 --json state,isDraft,mergeable,mergeStateStatus,statusCheckRollup` |
| Merge #4 | `MERGED` 2026-11-06T09:34:09Z, Commit `576c81ed5d54fd7a5ef9da25d8840b946e0b2f54` | `gh pr view 4 --json state,mergedAt,mergedBy,mergeCommit` |
| #5 nach Merge #4 | `MERGEABLE`/`CLEAN`, kein Update nötig | `gh pr view 5 --json mergeable,mergeStateStatus` |
| Merge #5 | `MERGED` 2026-11-06T09:36:37Z, Commit `2f8cd6d3ac33d9b29496c18c2d9729325386107d` | `gh pr view 5 --json state,mergedAt,mergedBy,mergeCommit` |
| main lokal | `git checkout main; git pull --ff-only` → HEAD `2f8cd6d`, `## main...origin/main` | `git log --oneline -5`, `git status -sb` |
| ci-check.ps1 | `OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, lokale Links, PDFs und Secret-Schutz geprüft.`, Exit 0 | `pwsh -NoProfile -File ./scripts/ci-check.ps1` (PowerShell 7.6.9) |
| node --check | alle sechs Dateien in `assets/js` mit Exit 0 | `node --check assets/js/*.js` (Node v24.16.0) |
| Seitenzahl main | `data-page-count>69` | `Select-String index.html` |
| CI main | `completed success` | `gh run list --branch main --commit 2f8cd6d` |

## Offene Fragen, Risiken, Abweichungen

- **Abweichung:** Laut Auftrag sollte Claude mergen. Tatsächlich hat der Owner beide Merges selbst ausgeführt, weil der Prüfmodus sie für Claude gesperrt hat. Alle übrigen Schritte liefen wie vorgesehen.
- **Grenzen eingehalten:** keine weiteren PRs gemergt, keine Tags erstellt (vorhanden ist nur `v0.1.0` vom 04.09.2026), kein Push auf `main` außer den Merges, kein FTP, keine Workflow- oder Konfigurationsänderung.
- **Risiko:** Die Live-Seite zeigt weiter `46 Seiten` und `bmarnau/relingit`, bis der Owner den FTP-Upload ausführt (`./scripts/build-upload.ps1`, dann hochladen).
- **Offen:** q15 (Standardweg zum Hochladen), Bestätigung der Adresse Reling-IT/relingit, R01 in `queue/INDEX.yaml` auf erledigt setzen (Planer).

Hygiene: Die gemergten Remote-Branches `auftrag-a-website-pflege-20261106-0957` und `auftrag-a-seitenzahl-skript-20261106` bestehen noch und können vom Owner gelöscht werden. Keine offenen PRs, keine Drafts.

```yaml
Reifegrad: "Webseiten-Pflege und Seitenzahl-Automatik auf main, CI grün; Live-Stand veraltet bis FTP-Upload"
Projektstatus: "PR #4 und #5 gemergt (576c81e, 2f8cd6d); keine offenen PRs; R02 wartet auf Entscheidung"
Offene_Fragen:
  - "Wann folgt der FTP-Upload des neuen main-Stands?"
  - "q15: Standardweg zum Hochladen (FTP-Paket oder Admin-Bereich mit Supabase)?"
  - "Bestätigung Reling-IT/relingit als endgültige Adresse"
  - "Gemergte Feature-Branches löschen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```
