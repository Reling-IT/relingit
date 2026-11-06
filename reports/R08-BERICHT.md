---
id: R08
titel: 'Kapitel-Vorlage und Einbau-Checkliste fuer neue Geschichten'
status: erledigt
start: 2026-11-06T11:29+01:00
ende: 2026-11-06T11:32+01:00
branch: auftrag-R08-kapitel-vorlage
pr: https://github.com/Reling-IT/relingit/pull/7
commit: 7eb1c34
ci: 'pass, https://github.com/Reling-IT/relingit/actions/runs/42203278935'
---

# R08 Bericht: Kapitel-Vorlage und Einbau-Checkliste

## Ergebnis

- PR #7 enthält `docs/vorlagen/KAPITEL-VORLAGE.html.txt` (Bausteine mit Platzhaltern, kein Buchtext) und `docs/vorlagen/EINBAU-CHECKLISTE.md` (Pflichtstellen und Regeln für Navis und Lumen im Wortlaut des Buchs).
- Die Struktur der Buchquelle ist mit Fundstellen beschrieben (Tabelle unten und PR-Beschreibung).
- Die Vorlage wird weder von `ci-check` erfasst noch ins FTP-Paket übernommen. Die CI ist grün.
- Buchtext, PDF, Skripte und Workflows sind unverändert. Nicht gemergt.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Geschichten-Kapitel | `section.scene` in `div.road`: zuerst `div.box-shell > figure.scene-fig` (SVG plus figcaption), dann `h2#kap-…`, dann Absätze, optional `.voice` und `.drafttasks` | Buchquelle Zeilen 873–899 („Der klare Auftrag“), 1010–1041 („Navis meldet sich“), 1251–1267 („Am Konferenztisch“) |
| Anhang-Box | `aside.real` mit Eyebrow „Realer Bezug“, `h2#kap-…`, `p.narrative`, `div.defbox`, Figuren | Zeilen 1818–1878 („Woher kommen die Infos“), 1572 (defbox AVKK) |
| Pflichtstellen | `div.cover-meta` (Version, Datum), `p.cover-whatsnew`, `nav.cover-toc`, drei Deckblatt-Boxen, `#kap-personen`, `#kap-versionen table.vtable` | Zeilen 652–657, 662, 664–679, 681/683/685, 689–758, 2010–2220 |
| Layout-Regel | Jede gerahmte Box steht in `div.box-shell`, `box-shell-flow` nur ausnahmsweise | CSS-Kommentar, Zeilen etwa 380–420 |
| Vorlage nicht von ci-check erfasst | Der Filter `*.html` findet nichts unter `docs/vorlagen` | `Get-ChildItem -Filter *.html -Recurse` ohne Treffer für `vorlagen` |
| Vorlage nicht im FTP-Paket | `build-upload.ps1` nennt weder `docs` noch `vorlagen` | `Select-String scripts/build-upload.ps1 -Pattern 'docs|vorlagen'` ohne Treffer |
| ci-check | OK, Exit 0 | `pwsh -File ./scripts/ci-check.ps1` → `OK: 21 HTML-Dateien …` (11 Repo-Seiten plus 10 aus dem lokal entpackten, ignorierten FTP-Paket `output/ftp`) |
| CI | pass | `gh pr checks 7` → `Website prüfen pass` |
| Verweis in NEUE-GESCHICHTE.md | Datei existiert noch nicht | Als Folgeaufgabe in PR #7 vermerkt, wird in R02 umgesetzt |

## Vorschläge und Ideen (Claude)

1. **Zeilen statt IDs:** Die Checkliste nennt Zeilennummern aus v1.37. Die verschieben sich mit jeder Version. Vorschlag: später auf Kapitel-IDs umstellen (`#kap-navis-meldet-sich`) oder den Vollständigkeits-Check aus R02 die Fundstellen ausgeben lassen.
2. **Sachprüfung aufnehmen:** Die erlaubten und unzulässigen Aussagen aus R10 (E1–E5, U1–U5) als Abschnitt „Sachprüfung gegen das reale Repo“ in die Checkliste. So prüft jede neue Geschichte, ob sie dem Sysingboard etwas zuschreibt, was es nicht kann.
3. **Endung .html wieder möglich machen:** Wenn `ci-check.ps1` `docs/vorlagen/` ausdrücklich ausnimmt (eine Zeile), kann die Vorlage `KAPITEL-VORLAGE.html` heißen und im Editor mit HTML-Hervorhebung öffnen. Nicht umgesetzt, weil R08 Skriptänderungen ausschließt.
4. **Begriff „drei Deckblatt-Boxen“ festschreiben:** Im Buch ist nicht ausdrücklich definiert, welche drei Boxen gemeint sind. Ich habe „Zur Einordnung“, „Aufbau in zwei Teilen“ und „Ausgangslage“ angenommen. Bitte vom Owner bestätigen, weil R02 diese Annahme für den Vollständigkeits-Check übernimmt.

## Offene Fragen, Risiken, Abweichungen

- **Abweichung Dateiname:** Statt `KAPITEL-VORLAGE.html` heißt die Datei `KAPITEL-VORLAGE.html.txt`. Grund: Der Auftrag verlangt zugleich, dass ci-check die Vorlage nicht erfasst, und verbietet Skriptänderungen. Mit `.html` hätte ci-check sie geprüft. Begründung steht auch in PR #7.
- **Annahme:** Die Bedeutung der „drei Deckblatt-Boxen“ habe ich aus dem Buch abgeleitet (Vorschlag 4).
- **Hinweis:** Es gibt einen offenen PR #6 („Avatare für Navis, Lumen, Ancora“) vom Konto bmarnau mit Commits des Kontos claude. Er ändert `source/fahrt-zum-kunden.html` (+20/−18, Personenliste). Die Zeilenangaben in der Checkliste können sich nach seinem Merge leicht verschieben.
- **Abweichung Quelle:** wie bei R04, Commit `08ec617` ohne Trailer (siehe STATUS.yaml).

Hygiene: offen sind PR #6 (nicht von dieser Sitzung) und PR #7, keine Drafts; keine gemergten Branches neu.

```yaml
Reifegrad: "Einbau neuer Kapitel ist mit Vorlage und Checkliste beschrieben"
Projektstatus: "R08 erledigt, PR #7 offen, CI grün"
Offene_Fragen:
  - "Welche drei Boxen sind die 'drei Deckblatt-Boxen'? Annahme: Zur Einordnung, Aufbau in zwei Teilen, Ausgangslage"
  - "Endung .html.txt akzeptiert oder ci-check-Ausnahme für docs/vorlagen gewünscht?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
