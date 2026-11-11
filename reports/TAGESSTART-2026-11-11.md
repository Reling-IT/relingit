# Tagesprotokoll 2026-11-11 – Reling-IT/relingit

## Tagesstart (Claude Code)

| Punkt | Ergebnis |
| --- | --- |
| Umgebung (TS-01) | ok: Arbeitsklon C:\dev\relingit, git 2.55.0, gh angemeldet, PowerShell 7.6.9; Pester und Poppler nicht geprüft (kein Release-Lauf im Tagesstart) |
| Aufgaben (TS-02) | nach `git fetch`, origin/ops/queue (Stand 2026-11-10 07:10): 56 Aufträge; erledigt 48, wartet_auf_voraussetzung 5 (R09, R41, R42, R52, R53), geplant 1 (R12), blockiert 1 (R05), bereit 1 (R29, wiederkehrend zum Tagesabschluss) |
| Git und lokal (TS-03) | main = origin/main 8abe213, sauber; Worktrees: wt-r06 (#27, sauber) und Ablage-Worktree wt-rep (ops/reports); gemergte Remote-Branches 0; lokal 1 gemergter Branch (auftrag-R50-kleines-systemhaus, Remote gelöscht, Freigabe offen); lokale ops/queue und ops/reports hinter origin (nur Ablage) |
| Plan und Doku (TS-04) | STATUS.yaml Stand 2026-11-10T07:16. Abweichungen: R34 in der Warteschlange erledigt, in STATUS.yaml blockiert; R18 erledigt, ohne Eintrag in STATUS.yaml; Warteschlange führt #29 (R50) noch als „nicht gemergt“, gemergt seit 09.11. (main 8abe213) |
| Zielbezug (TS-05) | Ziel: offen; hilfsweise Projektstatus „Release v1.38 vor dem Workshop Ende November“ |
| Offene Merges und Fragen (TS-06) | 7 Drafts, alle CI grün und CLEAN: #25 d1257f7, #31 b2bc305, #28 81f8e48, #30 586404f, #32 35c2d44, #26 2133502, #27 8ea4c62; Fragen: 6 aus dem Tagesbericht 10.11. |

Upload-Paket in `output/ftp`: `relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, SHA-256 `76692313…984C` (wie im Tagesbericht 10.11.). Upload v1.38 nicht geprüft (kein Tag, kein Beleg im Repository).

Heute dran (laut Arbeitspaket 10.11.):
1. R09 Live-Prüfung, sobald der Upload v1.38 bestätigt ist; Zielbezug: Abschluss Release v1.38.
2. Merge-Blöcke nach Freigabe (#25, #31, #28, #30, #32 nach Nachzug, #26); Zielbezug: Werkzeuge und Webseite für den Workshop auf main.
3. R52 Tag v1.38 nach Freigabe; Zielbezug: Release v1.38 abschließen.
4. #27 auf main nachziehen, anhang.html auf 1.39 (C1); Zielbezug: nächste Buchfassung nach v1.38.

```yaml
Reifegrad: v1.38-Paket aus main gebaut und uploadbereit; sieben Drafts gruen und mergefaehig
Projektstatus: Release v1.38 wartet auf Upload und Live-Pruefung R09; danach Tag und Merge-Bloecke
Offene_Fragen:
  - Ist v1.38 hochgeladen (Voraussetzung R09)?
  - Merges in Bloecken nach TA-03 vom 10.11. freigeben?
  - Lokalen Branch auftrag-R50-kleines-systemhaus loeschen?
  - Papierkorb nach R09 leeren?
  - OneDrive-Klon entfallen lassen (Auftrag ueber R13)?
  - C1 beim zweiten Merge von 26 und 27 nachziehen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
