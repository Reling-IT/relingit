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

## Nachtrag (09:03): Freigabe Werkzeug-PRs, Sichtung #35

- Entscheidung des Product Owners: Wortlaut der Anhang-Änderungen auf #35 wird bei der Sichtung im R60-PR geprüft (`SICHTUNG-v1.39.md`), nicht vorab.
- Freigabe des Product Owners zum Merge, je mit Head: #30 586404f, #31 b2bc305, #34 82ddf15, #36 8129697. Head je PR verglichen, dann `gh pr ready`; alle vier isDraft=false, CLEAN, Website prüfen SUCCESS. Kein Merge durch diese Sitzung.
- #32 (d6de9ee) nicht freigegeben: nach Merge von #30 Konflikt `docs/ABLAUF.md` nachziehen, danach neuer Head zur Freigabe.
- Nach Merge der acht Ready-PRs bleiben drei Agenten-PRs offen (#32, #33, #35), Grenze dann eingehalten.

## Nachtrag (09:06): Chromium-Vorab-Schritt

- Entscheidung des Product Owners: Vorab-Schritt „Chromium für Playwright vorhanden?“ mit Prüfbefehl als ein Satz in `docs/PDF-ERZEUGEN.md`, umgesetzt im Draft-PR von R60 (kein eigener PR). Für den Planer: in `queue/R60.yaml` aufnehmen.

## Nachtrag (09:30): Merge auf Anweisung des Product Owners

Anweisung des Product Owners: „alle mergen“ (die acht freigegebenen PRs). Abweichung von `CLAUDE.md` („Gemergt wird nicht von einer KI-Sitzung“) auf ausdrückliche Anweisung, hier vermerkt.

Weil `main` aktuelle Branches verlangt (strict), wurde jeder PR vor dem Merge per `gh pr update-branch` auf main gebracht. Vor jedem Merge geprüft: die geänderten Zeilen des PRs gleich denen des freigegebenen Heads; CI grün; Merge mit `--match-head-commit`.

| PR | freigegeben | gemergter Head | Merge |
| --- | --- | --- | --- |
| #25 | d1257f7 | d1257f7 | 657079e |
| #28 | 81f8e48 | 97bf8d8 | eae78f1 |
| #26 | 2133502 | 2151cfe | 6b31a02 |
| #30 | 586404f | 2a6c500 | 96b4633 |
| #31 | b2bc305 | 43cc604 | 80ae442 |
| #34 | 82ddf15 | 99b6a84 | bf3559b |
| #36 | 8129697 | 4cc32f6 | 057f9f0 |

- **#27 nicht gemergt:** nach Update (Head fb83613, Änderungszeilen gleich) CI rot: „Versionsangabe in anhang.html weicht von lesen.html ab“. Ursache: #26 bringt `anhang.html` mit 1.38, #27 hebt `lesen.html` auf 1.39. Der Nachzug „anhang.html 1.39“ steht in `queue/R60.yaml`.
- main 057f9f0: CI grün, `ci-check.ps1` lokal Exit 0. Arbeitsklon per Fast-Forward nachgezogen.
- Offen: #27 (Ready, rot), #32, #33, #35 (Draft). Vier Agenten-PRs, Grenze 3.
- #32 braucht jetzt den Nachzug `docs/ABLAUF.md` (Konflikt mit #30).

## Nachtrag (09:35): Entscheidung zu #27

- Entscheidung des Product Owners (Weg A): #27 wird wie #33 und #35 in R60 aufgenommen. R60 baut auf main 057f9f0 plus #27, #33, #35, zieht `anhang.html` auf 1.39 nach und öffnet einen Draft-PR mit grüner CI; #27, #33, #35 gelten mit dessen Merge als mitgemergt. Für den Planer: `queue/R60.yaml` (Aufbau, abhaengig_von) entsprechend anpassen.

## Nachtrag (09:57): #32 gemergt, R60 als Draft-PR #37

- #32 nach Nachzug `docs/ABLAUF.md` (f5115b9) mit Freigabe des Product Owners gemergt (69cae23). Eigener Worktree `wt/relingit/r56` und lokaler Branch entfernt.
- R60: Draft-PR #37 (Head e31c893), main plus #27, #33, #35, 80 Seiten, CI grün. Bericht `reports/R60-BERICHT.md`. Paket nicht hochgeladen.
- Renderumgebung `C:\dev\venv-pdf`: Playwright 1.64.1 → 1.64.0 (Pin). Chromium-Builds unverändert.
- Offen: #27, #33, #35 (in #37 aufgenommen), #37 (Draft). Nach Merge von #37 und Schließen der drei: ein offener PR weniger als die Grenze.
