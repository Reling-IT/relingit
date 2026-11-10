# Tagesprotokoll 2026-11-10 – Reling-IT/relingit

## Tagesstart (Claude Code)

| Punkt | Ergebnis |
| --- | --- |
| Umgebung (TS-01) | ok: Arbeitsklon C:\dev\relingit, git, gh angemeldet, PowerShell 7.6.9; Pester und Poppler nicht geprüft (heute kein Release-Lauf im Tagesstart) |
| Aufgaben (TS-02) | nach `git fetch`, origin/ops/queue ed87e9c: 50 Aufträge; erledigt 45, geplant 1 (R12), wartet_auf_voraussetzung 3 (R09, R41, R42), blockiert 1 (R05), bereit 0 |
| Git und lokal (TS-03) | main lokal 01defe7, origin/main 8abe213 (lokal 2 Commits zurück, Fast-Forward möglich); sauber ja; Worktrees 2 außer dem Arbeitsklon (wt-r50, Remote-Branch gelöscht; Ablage-Worktree ops/reports aus der Vorsitzung, sauber); gemergte Remote-Branches 0 |
| Plan und Doku (TS-04) | STATUS.yaml Stand 2026-11-09T06:36; Abweichung: #29 (R50) seit 09.11. 11:05 gemergt, im Plan noch als offen geführt; Upload v1.38 nicht geprüft (kein Tag, kein Beleg im Repository) |
| Zielbezug (TS-05) | Ziel: offen; hilfsweise Projektstatus „Release v1.38 vor dem Workshop Ende November“ |
| Offene Merges und Fragen (TS-06) | #25 fa4a49f, #26 6336236, #28 5e67269: Draft, CI grün, hinter main; #27 8fabbf2: Draft, CI grün, Konflikt mit main (erwartet nach #29); Fragen: 3 aus dem Tagesbericht 09.11. |

Heute dran:
1. Patch der drei übrigen Klon-Dateien neben das Bundle legen (Nachtrag R47); Zielbezug: Sicherung, unabhängig vom Release.
2. #27 (v1.39) per Merge mit main zusammenführen, PDF neu rendern, Prüfungen; Zielbezug: nächste Buchfassung nach v1.38.
3. R09 Live-Prüfung, sobald der Upload v1.38 bestätigt ist; Zielbezug: Abschluss Release v1.38.
4. #26, #25, #28 auf main nachziehen; Schutzdatei nach Merge #28.

```yaml
Reifegrad: v1.38 mit Muss-Korrektur auf main (PR 29 gemergt); v1.39, Anhang-Seite, Avatare und Aufbewahrungsregel als Drafts mit gruener CI
Projektstatus: Upload v1.38 und Live-Pruefung R09 offen; v1.39 muss auf main nachgezogen werden
Offene_Fragen:
  - Ist v1.38 hochgeladen (Voraussetzung R09)?
  - Zaehlen geschuetzte Pakete bei den letzten drei mit (R49)?
  - Wann darf der Papierkorb geleert werden?
  - Automatisches Loeschen gemergter Branches auf GitHub einschalten?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
