# Tagesstart 24.11.2026 (Claude Code, nachgeholt)

Rolle: KI-Sitzung. Nur gelesen; einzige Schreibaktion ist diese Datei. Grundlage: ADG `SITZUNGSROUTINE.md` (main d78426e), `docs/TAGESSTART.md`. Letztes Protokoll: `TAGESBERICHT-2026-11-23.md`.

Abweichung von der Reihenfolge: Der Tagesstart ist nachgeholt (Auftrag des Product Owners im Chat). Vorher hat die Sitzung das Arbeitspaket aus TA-07 des 23.11. bearbeitet (R87 abschließen, PR #43). Dabei war R92 in der Warteschlange noch nicht bekannt (siehe TS-02).

## TS-01 Umgebung

Umgebung: ok. Git 2.55.0, gh angemeldet, PowerShell 7.7.0, Pester 3.4.0, Poppler (`pdfinfo`, `pdftotext`) und Python vorhanden. Profilpfade auf `origin/main`, `origin/ops/queue` und `origin/ops/reports` vorhanden. Die lokalen Skills `tagesstart` und `tagesabschluss` weichen von ADG `vorlagen/skills/` (main d78426e) um 3 bzw. 5 Zeilen ab; nur gemeldet.

## TS-02 Aufgaben (`origin/ops/queue` e9b6204 vom 24.11. 04:51, nach `git fetch`)

| Status | Anzahl |
| --- | --- |
| erledigt | 74 |
| geplant | 9 |
| wartet_auf_voraussetzung | 3 |
| bereit | 2 |
| in_arbeit | 2 |
| blockiert | 1 |
| wartet_auf_entscheidung | 1 |

Nächste drei: R92 (autonomes 2-Stunden-Paket 24.11., bereit), R29 (Tagesabschluss-Prüfung, bereit), R87 (in Arbeit, PR #43).

R92 überschneidet sich mit der heutigen Arbeit: Schritt „R87 Teil 2 zweitprüfen, Muss-Befunde umsetzen“ und Block B1 (Testlauf `-NurPruefen` live) sind erledigt, siehe TS-06. Offen aus R92: #45 korrigieren (R52 entfällt), Satz zu Datenbank-Backups in `docs/SUPABASE-BETRIEB.md`, Planung R78/R68, R29, B2, B3, Bericht `R92-BERICHT.md`.

Die Commits auf `ops/queue` vom 23. und 24.11. sind nicht signiert (`%G?` = U); nur gemeldet.

## TS-03 Git und lokal (nach `git fetch --prune`)

| Prüfpunkt | Befund |
| --- | --- |
| Arbeitsklon | `main` gleich `origin/main` f7c59da, sauber, kein Stash |
| Worktrees | 5 unter `C:\dev\wt\relingit\`: `r87-teil2` (#43), `pilot-2311` (#45), `queue` (4 hinter `origin/ops/queue`), `rep` (gleich origin), `paket-v139` (2 voraus, 17 hinter `origin/main`; wartet auf Entscheidung R52/R53) |
| Remote-Branches | `main`, `ops/queue`, `ops/reports`, `auftrag-R87-teil2`, `pilot-2026-11-23`; gemergt 0 |
| Lokale Branches | gemergt 0 außer `main` |
| Weitere Klone | keine |
| Lose Dateien in `C:\dev` | keine |
| Außerhalb von Git | 12 alte Vorschau-Kopien `relingit-vorschau-*` im Temp-Ordner; vier FTP-Pakete in `output/ftp` (1.38, 1.39, 1.40 ohne Audio, 1.40 vollständig vom 23.11.); nur gemeldet |
| Podcast-MP3 | Die in `docs/PODCAST.md` genannte Ablage im OneDrive besteht nicht mehr. Lokale Kopien nur im Arbeitsklon (`assets/audio`, von Git ausgeschlossen) und im Paket 1.40 in `output/ftp`; Prüfsummen passen zu `SHA256SUMS.txt`. Keine unabhängige Sicherung belegt. |

## TS-04 Plan und Doku

- `reports/STATUS.yaml` Stand 23.11. 17:00, letzter Commit auf main 23.11. Kein Verzug über 14 Tage.
- Abweichung: R92 fehlt in `STATUS.yaml` (neu seit 24.11.).
- `docs/PILOT.md` auf main hat Stand 16.11. und nennt v1.40 noch als PR zur Sichtung. Die Aktualisierung liegt in #45.
- `docs/PODCAST.md`: Abschnitt „Ablageort“ nennt eine Ablage, die nicht mehr besteht (siehe TS-03).
- Termine: nicht berechenbar. Die Warteschlange führt keine Termine für offene Aufträge; die Pause ist ohne neuen Termin (Hinweis in R92).

## TS-05 Zielbezug (`ziel: offen`, hilfsweise Projektstatus 23.11.)

- R92 und R87 (#43): Ein Release soll nicht unbemerkt auf altem Stand live bleiben.
- #45: Der Pilot-Steckbrief soll den belegten Stand und die Stunden zeigen.
- R29: Hygiene, kein direkter Release-Bezug.
- R78/R68: Freigabeprüfung passend zu `main`; berührt `publish-release.ps1` wie R87.

## TS-06 Wartet auf den Product Owner

Offene Agenten-PRs: 2, unter der Grenze von 3.

| PR | Head | Draft | Zustand | CI | Stand |
| --- | --- | --- | --- | --- | --- |
| #43 R87 Teil 2 | 12397da | ja | MERGEABLE | grün | Zweitprüfung Runde 4 am Head: 0 Muss, 0 Soll (PR-Kommentar). Live-Lauf `-NurPruefen` am 24.11. 04:24 UTC: 9 von 9 OK, Exit 0. Freigabe durch den Product Owner im Chat erteilt; Merge durch den Product Owner selbst. |
| #45 PILOT.md | 34d53ad | nein | MERGEABLE | grün | Laut R92 erst korrigieren (R52 entfällt), dann Freigabe |

Offene Fragen:
- Satz zu Datenbank-Backups (R92) in #43 vor dem Merge oder in einem eigenen PR?
- R92-Rest heute weiterführen?
- Sicherung der Podcast-MP3 und Korrektur von `docs/PODCAST.md`.

```yaml
Reifegrad: v1.40 live und geprueft (Live-Lauf 24.11. Exit 0); Live-Pruefung -NurPruefen als PR 43 (Head 12397da) freigegeben, nicht gemergt
Projektstatus: R87 vor dem Abschluss; R92 teilweise erledigt; PR 45 wartet auf Korrektur
Offene_Fragen:
  - Backup-Satz in PR 43 oder eigener PR?
  - R92-Rest heute weiterfuehren?
  - Sicherung Podcast-MP3 und docs/PODCAST.md
Roadmap:
  Sprints_bis_BSF: unklar
  Sprints_bis_MVP: unklar
  Hinweis: keine Grundlage fuer eine Schaetzung
```
