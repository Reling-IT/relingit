# Bericht R37 – Podcast-Werkzeug vereinheitlichen (Google NotebookLM)

Stand: 2026-11-08 · Branch `auftrag-R37-notebooklm` · PR https://github.com/Reling-IT/relingit/pull/17 · Commit fe37fd0

## Ziel
Entscheidung des Owners vom 07.11.2026 umsetzen: Der Podcast wird mit Google NotebookLM erzeugt. index.html, datenschutz.html und ci-check.ps1 nennen das bereits; die Doku nannte noch Google Gemini. Nur die Werkzeugangabe ändern, Ablauf unverändert.

## Trefferliste
Befehl: `git grep -n -i gemini` (im Worktree C:\dev\wt-r37)

Vorher (origin/main 1281bbe):
```
docs/NEUE-GESCHICHTE.md:83:Nur wenn sich der Erzähltext geändert hat: Die Podcast-Fassung mit Google Gemini neu erzeugen. …
docs/PODCAST.md:67:`docs/vorlagen/EINBAU-CHECKLISTE.md` nennen **Google Gemini**. Bis zur Klärung bleibt der …
docs/vorlagen/EINBAU-CHECKLISTE.md:53:- [ ] Podcast nur neu erzeugen, wenn sich der Erzähltext geändert hat (Google Gemini).
```
Nachher: keine Treffer (git grep Exit-Code 1).

README.md und docs/ABLAUF.md enthielten keinen Gemini-Treffer (README nennt den Podcast nur in der Verzeichnisübersicht). Gemini in anderem Zusammenhang kam im Repo nicht vor.

## Änderungen
| Datei | Änderung |
|---|---|
| docs/NEUE-GESCHICHTE.md §6 | „mit Google Gemini“ → „mit Google NotebookLM“ |
| docs/vorlagen/EINBAU-CHECKLISTE.md §6 | „(Google Gemini)“ → „(Google NotebookLM)“ |
| docs/PODCAST.md | Abschnitt „Offene Frage an den Owner“ ersetzt durch „Werkzeug“ mit Entscheidung vom 07.11.2026; Hinweis auf gemeinsame Anpassung bei Wechsel beibehalten |

Nicht geändert: index.html, datenschutz.html, scripts/ci-check.ps1, Buchtext (source/, story/), Workflows. 3 Dateien, 8 Einfügungen, 8 Löschungen.

## ci-check-Ausgabe
`pwsh -File scripts/ci-check.ps1`:
```
Hinweis: 5 von 5 Podcast-Dateien liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). build-upload.ps1 baut ohne sie kein Paket.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
```
`git diff --check`: ohne Befund.

## CI
`gh pr checks 17 --watch`: „Website prüfen“ pass (10 s), Lauf https://github.com/Reling-IT/relingit/actions/runs/42445890337. Ergebnis als PR-Kommentar: https://github.com/Reling-IT/relingit/pull/17#issuecomment-6717108361

## PR
https://github.com/Reling-IT/relingit/pull/17 (offen, nicht gemergt)

## Offene Fragen, Risiken, Abweichungen
- Konfliktrisiko: R35/R36 ändern parallel docs/PODCAST.md. Meine Änderung betrifft nur den Abschnitt „Offene Frage an den Owner“ (Zeilen 63–69). Falls R35/R36 diesen Abschnitt ebenfalls anfasst, ist beim zweiten Merge ein kleiner Konflikt zu lösen.
- Abweichung: Neben der reinen Werkzeugangabe wurde in PODCAST.md die offene Frage als geklärt umformuliert, da sie sich durch die Entscheidung erledigt hat und sonst weiter „Gemini“ genannt hätte.
- Hinweis: Git meldet „LF will be replaced by CRLF“ (core.autocrlf); der Diff enthält nur die inhaltlichen Zeilen.

## Vorschläge und Ideen (Claude)
- Kleine Prüfung in ci-check.ps1 (eigener Auftrag), die in docs/ eine vom Live-Text abweichende Werkzeugangabe zum Podcast meldet.
- In docs/PODCAST.md Erzeugungsdatum und NotebookLM-Einstellungen (Sprache, Länge, Quelle) festhalten, damit eine Neuerzeugung nachvollziehbar ist.
- Nach Merge von R37 und R35/R36 einmal `git grep -n -i gemini` als Gegenprobe auf main laufen lassen.

Hygiene: gemergte Remote-Branches noch vorhanden: origin/auftrag-R24-pester-tests, origin/quelle-pdf-werkzeuge-20261106; offene PRs: #17 (R37), #6; Drafts: #9, #10. Worktree C:\dev\wt-r37 bleibt bestehen (sauber, gepusht). Nichts gemergt, kein Tag.

```yaml
Reifegrad: Doku einheitlich, ci-check und CI grün
Projektstatus: R37 als PR #17 offen, CI grün, Review durch Owner ausstehend
Offene_Fragen:
  - Reihenfolge der Merges R37 und R35/R36 (beide ändern docs/PODCAST.md)?
  - Soll ci-check eine abweichende Podcast-Werkzeugangabe in docs/ künftig melden?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
