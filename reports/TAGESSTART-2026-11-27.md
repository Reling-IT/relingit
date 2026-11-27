# Tagesstart 27.11.2026 (Claude Code)

Rolle: KI-Sitzung. Nur gelesen; einzige Schreibaktion ist diese Datei. Grundlage: ADG `SITZUNGSROUTINE.md` (main ccde604), `docs/TAGESSTART.md`. Letztes Protokoll: `TAGESBERICHT-2026-11-24.md`.

## TS-01 Umgebung

Umgebung: ok. Git 2.55.0, gh angemeldet, PowerShell 7.7.0, Pester 3.4.0, Python (`venv-pdf`). Profilpfade auf `origin/main`, `origin/ops/queue` und `origin/ops/reports` vorhanden. Skills `tagesstart` und `tagesabschluss` gleich ADG `vorlagen/skills/` (main ccde604).

## TS-02 Aufgaben (`origin/ops/queue` 69e6676 vom 25.11., nach `git fetch`)

| Status | erledigt | geplant | bereit | in_arbeit | blockiert | wartet_auf_voraussetzung | wartet_auf_entscheidung |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Anzahl | 76 | 10 | 7 | 1 | 1 | 1 | 1 |

Nächste drei: R78 (Sichtungsliste und Freigabeprüfung angleichen), R68 (G2/G7 auf main, hängt von R78 ab), R94 (Stunden 24.11. in `PILOT.md`, `PODCAST.md` prüfen, `STATUS.yaml`). Weitere bereit: R29, R93, R95, R96 (anderes Repository). Die acht Queue-Commits seit dem 23.11. sind nicht signiert (`%G?` = U); nur gemeldet.

## TS-03 Git und lokal (nach `git fetch --prune`)

| Prüfung | Ergebnis |
| --- | --- |
| Arbeitsklon | `main` 9b61ab4, 2 hinter `origin/main` 0a158a8 (#43, #46 gemergt), sauber |
| Worktrees | `r87-teil2`, `r92-backup` (Branches auf GitHub gelöscht, gemergt), `queue` (8 hinter), `rep` aktuell, `paket-v139` (wartet auf Entscheidung nach dem Workshop, R53) |
| Lokale Branches mit gelöschtem Upstream | `auftrag-R87-teil2`, `auftrag-R92-backup`, `pilot-2026-11-23` |
| Gemergte Remote-Branches | keine |
| Weitere Klone desselben Remotes | keine (`relingit-intern` ist ein anderes Repository) |
| Lose Dateien in `C:\dev` | keine |

## TS-04 Plan und Doku

- `reports/STATUS.yaml` Stand 24.11.; R93 bis R97 fehlen dort (Pflege durch Planer-Session). Nicht mehr als 14 Tage hinter dem letzten Produkt-Commit (24.11.).
- `docs/PILOT.md` vorhanden; Stunden 24.11. fehlen noch (R94).

## TS-05 Zielbezug

Kein Zielrahmen (`ziel: offen`), nächstes Ziel im Steckbrief „unklar“. R78/R68: Freigabetore sollen auf main richtig sperren; R94: Steckbrief und Status belegt halten; R95: Workshop-Vorbereitung.

## TS-06 Offene Merges und Fragen

Offene PRs: keine (0 von 3). Offene Fragen aus dem 24.11.: Worktrees und lokale Branches nach Merge entfernen (über R13/R93); Vorschau-Kopien entfernen; FTP-Pakete 1.38/1.39 archivieren.

## TS-08 Termine

Nicht berechenbar: Die Warteschlange führt keine Termine für offene Aufträge; die Pause hat keinen neuen Termin.
