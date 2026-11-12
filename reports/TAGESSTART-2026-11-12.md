# Tagesprotokoll 2026-11-12 – Reling-IT/relingit

## Tagesstart (04:20, Claude Code)

| Punkt | Ergebnis |
| --- | --- |
| Umgebung (TS-01) | ok: Arbeitsklon C:\dev\relingit, git 2.55.0, gh angemeldet, PowerShell 7.7.0, Pester 3.4.0, Poppler (`pdfinfo`, `pdftotext`) vorhanden |
| Aufgaben (TS-02) | nach `git fetch --prune`, origin/ops/queue 1711e0d (11.11. 14:56): 69 Aufträge; erledigt 56, wartet_auf_voraussetzung 7 (R09, R42, R52, R53, R60, R67, R68), bereit 4 (R29, R65, R66, R69), geplant 1 (R12), blockiert 1 (R05). Nächste drei in Listenreihenfolge: R65 (Gate ja), R66, R69; R29 ist wiederkehrend zum Tagesabschluss |
| Git und lokal (TS-03) | main = origin/main 8abe213, sauber, 0/0; Worktrees: wt-r06 (#27), wt-r41 (#33), wt-r62 (#34), wt-rep (Ablage), alle sauber und auf Stand ihres Remote-Branches; gemergte Remote-Branches 0; lokal gemergte Branches 0; lokale ops/queue 18 Commits hinter origin (nur Ablage, gelesen wird von origin); kein weiterer Klon desselben Remotes |
| Plan und Doku (TS-04) | STATUS.yaml Stand 2026-11-11T07:31, letzter Produkt-Commit auf main 09.11. (unter 14 Tagen). Abweichungen siehe unten |
| Zielbezug (TS-05) | Ziel: offen; hilfsweise Projektstatus „Upload v1.38, danach R09, R52 und Merge-Blöcke; v1.39 über R60“ (Tagesbericht 11.11.) |
| Offene Merges und Fragen (TS-06) | 9 offene PRs, alle Draft; 8 CI grün und CLEAN, #33 rot und BLOCKED (erwartet, story/current folgt in R60). Grenze offener Agenten-PRs (Vorgabe 3) überschritten. Fragen: 5 aus dem Tagesbericht 11.11. |

### Abweichungen (TS-03, TS-04)

- Pilot-Steckbrief `docs/PILOT.md` fehlt; Profilfeld `steckbrief` ist nicht gesetzt.
- Worktrees liegen unter `C:\dev\wt-*`, nicht unter der neuen Vorgabe `C:\dev\wt\<repo>\<kurzname>` (ADG-Ergänzung vom 11.11.). Nur gemeldet.
- Im Arbeitsverzeichnis `C:\dev` liegen sechs lose Dateien (PR- und Review-Texte vom 08. und 09.11., nicht aus diesem Repository). Nur gemeldet.
- queue/INDEX.yaml führt bei R50 noch „#29 offen, nicht gemergt“; gemergt seit 09.11. (main 8abe213). Pflege liegt beim Planer.
- R29 steht auf bereit mit Vermerk „Tagesabschluss 11.11.“; ein Bericht R29 für den 11.11. liegt nicht vor (vorhanden: 08.11. und 10.11.).
- Upload v1.38: nicht geprüft (kein Tag v1.38, kein Beleg im Repository; R09 wartet weiter).

### Offene Pull Requests (TS-06, Stand 04:19)

| PR | Auftrag | Head | Draft | Zustand | CI |
| --- | --- | --- | --- | --- | --- |
| #25 | R11 | d1257f7 | ja | CLEAN | grün |
| #26 | R07/R46 | 2133502 | ja | CLEAN | grün |
| #27 | R06 v1.39 | 8ea4c62 | ja | CLEAN | grün |
| #28 | R49 | 81f8e48 | ja | CLEAN | grün |
| #30 | R55 | 586404f | ja | CLEAN | grün |
| #31 | R54 | b2bc305 | ja | CLEAN | grün |
| #32 | R56 | d6de9ee | ja | CLEAN | grün |
| #33 | R41 | ecfbebb | ja | BLOCKED | rot (erwartet) |
| #34 | R62 | 82ddf15 | ja | CLEAN | grün |

Alle Heads unverändert gegenüber dem Tagesbericht 11.11. Reihenfolge nach R57 (D) und R63.

### Heute dran (Arbeitspaket 11.11., Schritt 2 entfällt)

1. R66 Sichtungsliste v1.39 (nur ops/reports); Zielbezug: Sichtung G3 bis G5 für v1.39 ohne Sondervermerke.
2. R69 Stimmigkeitsprüfung Rest des Buchs (nur lesen); Zielbezug: keine Muss-Fehler nach der Sichtung v1.39.
3. R65 Korrekturen v1.39 (Gate ja, neuer Draft-PR); Zielbezug: Buchquelle für v1.39 vor R60. Wäre der zehnte offene Agenten-PR, deshalb erst nach Entscheidung des Product Owners.
4. R09 Live-Prüfung, sobald der Upload v1.38 bestätigt ist; Zielbezug: Abschluss Release v1.38.

### Wartet auf den Product Owner

- Grenze offener Agenten-PRs: 9 offen, Vorgabe 3. Neue Aufträge heute beginnen oder nicht?
- Gate R65.
- Upload v1.38 (danach R09, R52, Merge-Blöcke mit Einzelfreigabe je PR und Head-SHA).
- Offene Fragen aus dem Tagesbericht 11.11.: Wortlaut G8, Pester in die CI, Papierkorb nach R09, OneDrive-Klon.
- Pilot-Steckbrief anlegen?

### Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Die PR-Grenze greift hier, weil alle Merges am Upload v1.38 hängen. Ein Teil der Drafts (#28, #30, #31, #32, #34, reine Werkzeuge) hängt inhaltlich nicht an der Buchfassung und könnte vor dem Upload freigegeben werden; das würde die Zahl auf vier senken.
- R65 könnte statt eines eigenen PRs auf einen gemeinsamen v1.39-Branch mit #27 und #33 gelegt werden (alle drei ändern dieselbe Buchquelle und gehen laut Entscheidung vom 11.11. ohnehin als Block mit R60). Das spart einen PR und die Konfliktprüfung.
- Profilfelder `worktrees`, `pr_grenze` und `steckbrief` im Projektprofil ergänzen, damit Tagesstart und Tagesabschluss nicht jedes Mal dieselbe Abweichung melden.

```yaml
Reifegrad: v1.38 freigegeben (G8), Paket 76692313...984C gleich main 8abe213; neun Drafts mit belegter Merge-Reihenfolge; v1.39 im Trockenlauf belegt (R63)
Projektstatus: Upload v1.38 durch den Product Owner offen; danach R09, R52 und Merge-Bloecke; v1.39 ueber R65, R66, R69 und R60
Offene_Fragen:
  - Neue Auftraege trotz neun offener Agenten-PRs (Vorgabe 3)?
  - Gate R65?
  - Termin Upload v1.38?
  - Wortlaut G8 bestaetigen und auf PR 29 festhalten?
  - Pester in die CI?
  - Papierkorb nach R09 leeren?
  - OneDrive-Klon entfallen lassen?
  - Pilot-Steckbrief docs/PILOT.md anlegen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
