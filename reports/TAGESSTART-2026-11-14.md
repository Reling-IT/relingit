# Tagesstart 14.11.2026 (Claude Code)

Rolle: KI-Sitzung. Nur gelesen; einzige Schreibaktion ist diese Datei. Grundlage: ADG `SITZUNGSROUTINE.md` 0.2.0-entwurf, `docs/TAGESSTART.md`. Uhrzeit 08:30. Letztes Protokoll: `TAGESBERICHT-2026-11-12.md`; für den 13.11. gibt es kein Protokoll.

## TS-01 Umgebung

Umgebung: ok. Git 2.55.0, gh angemeldet, PowerShell 7.7.0, Pester 3.4.0, Poppler (`pdfinfo`, `pdftotext`) vorhanden. Chromium für Playwright nicht geprüft (nur vor dem Rendern nötig, Vorab-Schritt in `queue/R60.yaml`).

## TS-02 Aufgaben (`origin/ops/queue` 7d26ac0, nach `git fetch`)

| Status | Anzahl |
| --- | --- |
| erledigt | 62 |
| wartet_auf_voraussetzung | 7 |
| geplant | 4 |
| bereit | 2 |
| blockiert | 1 |

Nächste drei: R76 (Ready-Setzen #25, #28, #26, #27, bereit, Gate mit Freigabe vom 12.11.), R29 (Tagesabschluss-Prüfung, wiederkehrend), R60 (v1.39 rendern, wartet auf R76 und Merge #25, #28, #26, #27).

## TS-03 Git und lokal (nach `git fetch --prune`)

| Prüfpunkt | Befund |
| --- | --- |
| Arbeitsklon | `main` gleich `origin/main` 8abe213, sauber |
| Worktrees | 6: `wt/relingit/r65` (#35), `wt/relingit/r73` (#36), `wt-r06` (#27), `wt-r41` (#33), `wt-r62` (#34), `wt-rep` (ops/reports); keiner verwaist |
| Gemergte Remote-Branches | 0; 11 Remote-Branches `auftrag-*`, je zu einem offenen PR |
| Weitere Klone | `C:\dev\reling-it\relingit` (6ea5f6d vom 27.10.), nur gemeldet; Entscheidung laut `queue/R53.yaml` zusammen mit dem OneDrive-Klon |
| Lose Dateien in `C:\dev` | sechs `wt-*-pr.md`/`wt-*-review.md` (R70 Teil 2, wartet auf Prüfung im anderen Repository) |

## TS-04 Plan und Doku

- `reports/STATUS.yaml` Stand 12.11. 06:38; letzter Produkt-Commit auf main 09.11. Kein Verzug über 14 Tage.
- Abweichung: R76 steht in der Warteschlange (bereit), in `STATUS.yaml` noch nicht.
- Pilot-Steckbrief `docs/PILOT.md` fehlt auf main, liegt als Draft-PR #36 vor.

## TS-05 Zielbezug (`ziel: offen`, hilfsweise Projektstatus 12.11.)

- R76: macht den Merge von vier freigegebenen PRs möglich, Voraussetzung für R60 und Release v1.39.
- R60: rendert v1.39, das laut Entscheidung vom 11.11. vor v1.38 hochgeladen wird (Entscheidung am 16.11.).
- R29: Hygiene, kein direkter Release-Bezug.

## TS-06 Wartet auf den Product Owner

Offene PRs: 11, alle Draft, über der Grenze von 3. Keine neuen Aufträge, nur Nacharbeit (R76 zählt dazu).

| PR | Head | CI | Zustand | Hinweis |
| --- | --- | --- | --- | --- |
| #25 R11 | d1257f7 | grün | CLEAN | Head gleich Freigabe R76 |
| #28 R49 | 81f8e48 | grün | CLEAN | Head gleich Freigabe R76 |
| #26 R07/R46 | 2133502 | grün | CLEAN | Head gleich Freigabe R76 |
| #27 R06 | 8ea4c62 | grün | CLEAN | Head gleich Freigabe R76 |
| #33 R41 | ecfbebb | rot (erwartet) | BLOCKED | geht in R60 auf |
| #35 R65 ff. | 6cf48a8 | rot (erwartet) | BLOCKED | geht in R60 auf |
| #30 R55 | 586404f | grün | CLEAN | Werkzeug |
| #31 R54 | b2bc305 | grün | CLEAN | Werkzeug |
| #32 R56 | d6de9ee | grün | CLEAN | Werkzeug, Konflikt `docs/ABLAUF.md` mit #30 |
| #34 R62 | 82ddf15 | grün | CLEAN | Werkzeug |
| #36 R73 | 8129697 | grün | CLEAN | Steckbrief |

Offene Fragen aus dem 12.11.: Wortlaut der Anhang-Änderungen auf #35 bestätigen; R70 Teil 2 und zweiter Klon (entschieden: warten); Freigabe der Werkzeug-PRs.

```yaml
Reifegrad: v1.39 vollstaendig als Draft (PR 35, Head 6cf48a8); v1.38 freigegeben, nicht hochgeladen
Projektstatus: R76 bereit (Ready-Setzen von vier freigegebenen PRs), danach Merge durch den Product Owner und R60
Offene_Fragen:
  - R76 heute ausfuehren?
  - Wortlaut der Anhang-Aenderungen auf PR 35 bestaetigen?
  - Werkzeug-PRs 30, 31, 32, 34, 36 einzeln freigeben?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```

## Nachtrag (09:10): R76 erledigt, Entscheidung zur Doku

- R76 erledigt: #25, #28, #26, #27 Ready for review, Head unverändert (`reports/R76-BERICHT.md`, 4529ff4). `queue/INDEX.yaml` führt R76 noch als bereit (pflegt der Planer).
- Entscheidung des Product Owners: Auftrag für den Planer, `docs/TAGESSTART.md` als Draft-PR nachzuziehen (Worktree-Ablage `C:\dev\wt\relingit\` statt `C:\dev\wt-*`; Klonprüfung auf zwei Ordnerebenen). Erst nach dem Merge von #25, #28, #26, #27, wegen der PR-Grenze.
- Doku auf main zuletzt geändert am 08.11.; neuere Stände nur in offenen PRs (#35 `docs/PDF-ERZEUGEN.md`, #30/#32 `docs/ABLAUF.md`, #36 `docs/PILOT.md`). Chromium-Vorab-Schritt steht nur in `queue/R60.yaml`.
