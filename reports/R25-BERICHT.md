---
id: R25
titel: "Doku-Diagramme Repo-Struktur und Release-Ablauf"
status: erledigt (PR offen, nicht gemergt)
start: 2026-11-07T05:06+01:00
ende: 2026-11-07T05:17+01:00
branch: auftrag-R25-doku-diagramme (Worktree C:\dev\wt-r25, Basis origin/main 2f8cd6d)
pr: https://github.com/Reling-IT/relingit/pull/12
commit: a7fa51a
ci: grün ("Website prüfen", 8 s, Run 42337671067)
---

## Ergebnis

docs/ABLAUF.md mit zwei Mermaid-Diagrammen (Verzeichniskarte, Release-Ablauf mit Verantwortlichem je Schritt) und Belegtabelle Datei:Zeile angelegt.
PDF-Erzeugung als „offen“ (R14), Aussagen aus PR #8 als „gilt ab Merge von PR #8“ markiert.
README verweist in Zeile 14 (Projektstruktur, ohne Zeilenverschiebung) auf docs/ABLAUF.md.
ci-check lokal ohne Befund, CI grün, PR #12 offen, Kommentar mit CI-Ergebnis und PR-#8-Abhängigkeit geschrieben.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Worktree | angelegt auf origin/main 2f8cd6d | `git worktree add -b auftrag-R25-doku-diagramme /c/dev/wt-r25 origin/main` |
| Admin-Übergabe auf main | nicht vorhanden; publish-release.ps1 endet auf main mit OK-Zeile (Z. 127). Übergabe nur in PR #8 (Z. 170-227) | `git diff origin/main...origin/auftrag-R02-veroeffentlichung -- scripts` |
| NEUE-GESCHICHTE.md | nur auf PR-#8-Branch, per `git show` gelesen | docs/ABLAUF.md, Kennzeichnung „(PR #8)“ |
| Diagramm 1 | 9 Bereiche inkl. Projektstamm, Zweck je Ordner | docs/ABLAUF.md Abschnitt 1 |
| Diagramm 2 | 16 Knoten A-P, Farben je Verantwortlichem, B offen, H ab PR #8 | docs/ABLAUF.md Abschnitt 2 |
| Belegtabelle | jede Aussage mit Datei:Zeile, Zeilen ohne Zusatz = main 2f8cd6d | docs/ABLAUF.md „Belegtabelle“ |
| Mermaid-Syntax | `mermaid.parse` (mermaid 11.4.1 + jsdom) für beide Blöcke OK, Negativtest erkennt Fehler | lokale Prüfung im Scratchpad |
| README-Verweis | Zeile 14 ergänzt, damit Zeilenbelege stabil bleiben und kein Konflikt mit PR #8 | `git diff README.md` |
| ci-check lokal | `OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, lokale Links, PDFs und Secret-Schutz geprüft.` exit=0 | `pwsh -NoProfile -File scripts/ci-check.ps1` |
| git diff --check | ohne Befund | exit=0 |
| CI | Website prüfen: pass (8 s) | https://github.com/Reling-IT/relingit/actions/runs/42337671067 |
| PR-Kommentar | CI-Ergebnis + Abhängigkeit zu PR #8 | https://github.com/Reling-IT/relingit/pull/12#issuecomment-6702143176 |

## Offene Fragen, Risiken, Abweichungen

- FTP-Regel widersprüchlich: PR #8 nennt index.html, assets/js, impressum.html, datenschutz.html; docs/DOMAINFACTORY-DEPLOYMENT.md:57 (main) nennt zusätzlich „Gestaltung“ (assets/css); README.md:67 nur „Landingpage selbst“. In ABLAUF.md als offener Punkt vermerkt. Entscheidung beim Owner.
- Reihenfolge „PR/Merge vor Admin-Upload“ ist nur in NEUE-GESCHICHTE.md (PR #8) belegt, auf main offen.
- NEUE-GESCHICHTE.md (PR #8) verweist auf docs/vorlagen/…, das auf dem PR-#8-Branch nicht existiert; vermutlich aus PR #7 (R08). Merge-Reihenfolge #7 vor/mit #8 beachten.
- Zeilenbelege veralten bei jeder Änderung an README/Skripten; nach Merge von PR #8 (und ggf. #11 R14 PDF-Werkzeuge) muss ABLAUF.md nachgezogen werden.
- Supabase ist im Diagramm Zielsystem, kein Verantwortlicher (bewusste Abweichung von „Verantwortlicher je Schritt“ für Knoten M).
- Lokale ci-check-Ausgabe zeigt Umlaut als „�“ (Konsolenkodierung), ohne Einfluss auf das Ergebnis.

## Vorschläge und Ideen (Claude)

- ci-check um eine Prüfung ergänzen, dass in docs/ABLAUF.md zitierte Dateien existieren (keine Zeilennummern, nur Pfade) – würde Skript-Änderung erfordern, daher eigener Auftrag.
- Nach Merge von #8 und #11 einen kleinen Folgeauftrag „ABLAUF.md nachziehen“: PR-#8-Vermerke entfernen, PDF-Schritt mit R14-Befehl füllen.
- FTP-Regel einmalig zentral festlegen (eine Liste in README) und DOMAINFACTORY-DEPLOYMENT.md darauf verweisen lassen.
- Optional Podcast-Schritt (NEUE-GESCHICHTE.md:79-83, PR #8) als optionalen Endknoten ins Diagramm aufnehmen.

Hygiene: Gemergte Remote-Branches außer main keine (`git branch -r --merged origin/main` → nur origin/main). Offene PRs: #12 (R25), #11 (R14), #8 (R02), #7 (R08), #6 (Avatare); Drafts: #10 (Geschichte v1.38), #9 (R03). Worktree C:\dev\wt-r25 besteht weiter.

```yaml
Reifegrad: "Doku: Struktur und Release-Ablauf als Diagramme mit Belegen; abhängig von PR #8 und R14"
Projektstatus: "Release-Ablauf skriptgestützt und CI-geprüft; Admin-Standardweg und PDF-Erzeugung noch in offenen PRs (#8, #11)"
Offene_Fragen:
  - "FTP-Regel: gehört assets/css (Gestaltung) dazu?"
  - "Admin-Upload vor oder nach Merge?"
  - "Merge-Reihenfolge #7/#8 wegen docs/vorlagen"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
