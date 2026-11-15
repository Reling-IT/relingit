# Tagesstart 15.11.2026 (Claude Code)

Rolle: KI-Sitzung. Nur gelesen; einzige Schreibaktion ist diese Datei. Grundlage: ADG `SITZUNGSROUTINE.md` 0.2.0-entwurf, `docs/TAGESSTART.md`. Letztes Protokoll: `TAGESBERICHT-2026-11-14.md` mit Nachträgen bis 16:35.

## TS-01 Umgebung

Umgebung: ok. Git 2.55.0, gh angemeldet, PowerShell 7.7.0, Pester 3.4.0, Poppler (`pdfinfo`, `pdftotext`) vorhanden. Chromium für Playwright nicht geprüft (nur vor einem neuen Render nötig).

## TS-02 Aufgaben (`origin/ops/queue` 7d26ac0 vom 12.11., nach `git fetch`)

| Status | Anzahl |
| --- | --- |
| erledigt | 62 |
| wartet_auf_voraussetzung | 7 |
| geplant | 4 |
| bereit | 2 |
| blockiert | 1 |

Die Warteschlange ist seit 12.11. unverändert. R76 steht noch auf bereit und R60 auf wartend, obwohl beide am 14.11. erledigt wurden (`R76-BERICHT.md`, `R60-BERICHT.md`). Pflege durch den Planer.

Nächste drei: Sichtung und Freigabe #37 (R60, Product Owner), R29 (Tagesabschluss-Prüfung, wiederkehrend, bereit), R09 (Live-Prüfung, wartet auf Upload v1.39).

## TS-03 Git und lokal (nach `git fetch --prune`)

| Prüfpunkt | Befund |
| --- | --- |
| Arbeitsklon | `main` gleich `origin/main` 69cae23, sauber |
| Worktrees | 5: `wt/relingit/r60` (#37), `wt/relingit/r65` (#35), `wt-r06` (#27, lokal 15 hinter origin), `wt-r41` (#33), `wt-rep` (ops/reports); keiner verwaist, alle sauber |
| Worktree-Ablage | `wt-r06`, `wt-r41`, `wt-rep` liegen direkt in `C:\dev` statt unter `C:\dev\wt\relingit\`; nur gemeldet |
| Remote-Branches | gemergt 0; 4 `auftrag-*`, je zu offenem PR |
| Lokale Branches | gemergt 0; `ops/queue` 29 hinter origin (gelesen wird `origin/ops/queue`) |
| Weitere Klone | `C:\dev\reling-it\relingit`, nur gemeldet (R53, R70) |
| Lose Dateien in `C:\dev` | sechs `wt-*-pr.md`/`wt-*-review.md` (R70 Teil 2), unverändert |

## TS-04 Plan und Doku

- `reports/STATUS.yaml` Stand 14.11. 09:57; letzter Commit auf main 14.11. Kein Verzug über 14 Tage.
- Abweichung: Warteschlange führt R76 und R60 nicht als erledigt (siehe TS-02).
- Pilot-Steckbrief `docs/PILOT.md` liegt auf main. Stunden 14.11. (3 h) noch nicht eingetragen; kommt mit dem Doku-PR.

## TS-05 Zielbezug (`ziel: offen`, hilfsweise Projektstatus 14.11.)

- Sichtung und Freigabe #37: direkt Release v1.39.
- R09: Live-Prüfung nach dem Upload von v1.39, schließt das Release ab.
- R29: Hygiene, kein direkter Release-Bezug.
- Doku-PR `docs/TAGESSTART.md` und `docs/PDF-ERZEUGEN.md`: Arbeitsweise, kein direkter Release-Bezug; nach Merge von #37 wegen PR-Grenze.

## TS-06 Wartet auf den Product Owner

Offene Agenten-PRs: 4, über der Grenze von 3. Keine neuen Aufträge, nur Nacharbeit.

| PR | Head | Draft | Zustand | CI | Hinweis |
| --- | --- | --- | --- | --- | --- |
| #37 R60 | e31c893 | ja | CLEAN | grün | Sichtung nach `SICHTUNG-v1.39.md`, G1 bis G8, Merge nach Einzelfreigabe |
| #27 R06 | fb83613 | nein | BEHIND | rot | in #37 aufgenommen; nach Merge von #37 schließen (Freigabe) |
| #33 R41 | ecfbebb | ja | BEHIND | rot | in #37 aufgenommen |
| #35 R65 ff. | 6cf48a8 | ja | BEHIND | rot | in #37 aufgenommen |

Offene Fragen aus dem 14.11.: Sichtung #37 (für heute geplant); R70 Teil 2 und zweiter Klon (wartet auf Prüfung durch den Product Owner); Upload-Entscheidung v1.38/v1.39 am 16.11.

```yaml
Reifegrad: v1.39 als Draft-PR 37 (Head e31c893) gerendert, 80 Seiten, CI gruen; nicht gesichtet, nicht hochgeladen
Projektstatus: wartet auf Sichtung und Freigabe G1 bis G8 fuer PR 37; Upload-Entscheidung v1.38/v1.39 am 16.11.
Offene_Fragen:
  - Sichtung PR 37 heute durchfuehren?
  - R70 Teil 2 und zweiter Klon - Freigabe nach Pruefung?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```

## Nachtrag (18:25): Sichtung v1.39, G8 und Merge #37

- Sichtung mit dem Product Owner: 56 von 56 Punkten Ja (`reports/SICHTUNG-v1.39.md`, 9fc8087, 923b0be, 4a22a54).
- Änderungen in der Sichtung, je mit Entscheidung des Product Owners, Commits auf #37: 531b42a (Handout-Datum Startseite), 8a54375 (Anhang-Box „Die neun Standards“ mit IAM und REST, Fassung 15.11.2026, neu gerendert), 90ecfd3 und a470a41 (Seitenumbrüche Definitionsbox und Versionshistorie). 80 Seiten, `verify_layout` OK.
- G7: #37 auf Ready gesetzt (Freigabe des Product Owners). `freigabe-pruefen.ps1`: G1, G2, G6, G7 bestanden.
- G8 vom Product Owner erteilt, als Kommentar auf #37 festgehalten (Head a470a41, Paket `relingit-upload-v1.39-2026-11-15-ohne-audio.zip`, SHA-256 6E48827B…1B98).
- Merge #37 durch die KI-Sitzung auf ausdrückliche Anweisung des Product Owners („B“), abweichend von `CLAUDE.md` („Gemergt wird nicht von einer KI-Sitzung“). `gh pr merge --merge --match-head-commit a470a41`, Merge-Commit a1b11a8. main danach: CI grün, `ci-check.ps1` Exit 0, Pester 54/0.
- GitHub hat #27, #33 und #35 beim Merge selbst als gemergt markiert, weil ihre Heads in #37 enthalten sind; die vier Branches wurden durch die Repository-Einstellung `delete_branch_on_merge` gelöscht. Kein eigenes Schließen oder Löschen durch diese Sitzung. Offene PRs: 0.
- Nur gemeldet: Worktrees `wt/relingit/r60`, `wt/relingit/r65`, `wt-r06`, `wt-r41` stehen jetzt auf gelöschten Branches; Entfernen über R13 mit Freigabe.
- Offen für v1.39: Upload durch den Product Owner (Entscheidung am 16.11.), danach R09 Live-Prüfung und Tag.
