---
id: R26
titel: Korrekturen aus R19 (Muss-Befunde M1 bis M11) auf PR #10
status: erledigt
start: 2026-11-07T05:34+01:00
ende: 2026-11-07T05:48+01:00
branch: geschichte-veraltete-daten-20261107
pr: https://github.com/Reling-IT/relingit/pull/10
commit: 9dfdc548c1c65bde48810ee8a952432d724da91f
ci: 'ci-check Exit 1, vor und nach dem Commit identisch (1 vorbestehender Fehler: story/current weicht von source ab); keine neuen Fehler'
---

# R26: Muss-Befunde M1 bis M11 eingearbeitet

## Ergebnis

Alle elf Muss-Befunde aus R19 sind in `source/fahrt-zum-kunden.html` umgesetzt, wie in der Spalte „Vorschlag“ vorgegeben. Commit 9dfdc54 liegt auf cfc1f97 auf; ich habe normal gepusht, ohne Force.
Die Versionshistorie v1.38 hat einen zusätzlichen Satz bekommen. Deckblatt, Version, Datum, `story/current` und die PDF habe ich nicht angefasst.
Die Zeilenzahl bleibt bei 2296, deshalb stehen alle Befunde vorher und nachher in derselben Zeile.
`ci-check.ps1` endet vor und nach dem Commit mit Exit 1 und identischer Ausgabe. Der einzige Fehler bestand schon vorher: `story/current` weicht von `source` ab.
Der Kommentar an PR #10 ist gepostet: https://github.com/Reling-IT/relingit/pull/10#issuecomment-6702442391

| Punkt | Beobachtung | Beleg (Zeilen vorher/nachher) |
|---|---|---|
| M1 | „bei sechs davon“ → „bei fünf davon“; 5 + 4 = 9 geht auf | 1404 / 1404 |
| M2 | Donnerstag → Freitag an drei Stellen, sonst kein „Donnerstag“ in der Szene | 1510, 1523, 1525 / dieselben |
| M3 | „Workshop Ende September“ → „Ende November“; „Ende September“ steht jetzt nirgends mehr in der Datei | 1608 / 1608 |
| M4 | Fußzeile „Ende September“ → „Ende November“ | 2291 / 2291 |
| M5 | „heute Vormittag machbar“ → „morgen Vormittag machbar“ | 1038 / 1038 |
| M6 | „die Zeile lesen“ → „die Zeile zu lesen“ | 932 / 932 |
| M7 | „im Abstimmung“ → „in Abstimmung“ | 1232 / 1232 |
| M8 | „der nur ein Mensch“ → „den nur ein Mensch“ | 1321 / 1321 |
| M9 | „die vier Arbeitspakete“ → „die sechs Arbeitspaket-Entwürfe“ | 1567 / 1567 |
| M10 | Bei Navis „Verfügbarkeit der Kernsysteme: 99,7 Prozent.“ gestrichen. Lumen beginnt jetzt mit „Ergänzend aus der Report-Familie: Verfügbarkeit der Kernsysteme 99,7 Prozent. Heute früh kurzzeitig …“; „aus dem Monitoring, nur als Randnotiz“ entfällt wie im Vorschlag | 1218, 1223 / 1218, 1223 |
| M11 | Z. 2004: Zuständigkeits-Regel, täglich, AVKK-Übersicht, Verfügbarkeit, ausschließlich, über. Z. 2014: für, öffentlichen. Dasselbe „AVKK-Uebersicht“ steht auch in der Versionshistorie (Z. 2176); das habe ich nach K14 bewusst gelassen | 2004, 2014 / 2004, 2014 |
| Historie | Zeile v1.38 um einen Satz zu den R26-Korrekturen ergänzt; ci-check meldet bei Deckblatt und Historie keinen Fehler | 2284 / 2284 |

## Prüfung M2-Zeitrechnung und M10-Szene

**M2 (Freitag):**
- „Zuletzt vor neun Tagen veröffentlicht“: Neun Tage vor Freitag ist Mittwoch der Vorwoche.
- „Cockpit markiert seit gestern“: Laut Anhang-Box „Datenstand“ (Z. 1969) markiert das Cockpit „nach mehr als sieben Tagen“, also ab Tag 8. Das ist der Donnerstag, gestern. Das stimmt, und zwar unabhängig vom Wochentag, weil beide Angaben relativ sind.
- Reiner hat den Switch am Dienstag getauscht, einem Arbeitsvormittag nach Z. 894 (Mo–Do). Das liegt nach der letzten Veröffentlichung. Der Freitag ist sein freier Tag, das passt jetzt zu „keine Ausnahmen“.
- „Wenn Reiner wieder drei Tage nicht im Haus ist“ (Z. 1525) passt zu Fr–So sogar besser als vorher. „Montagsrunde“ ist der nächste Werktag. „Heute Abend nachholen“ bleibt möglich.

**M10 (Konferenztisch, Z. 1214–1321):** Die Navis-Aussagen in der Szene sind:
- Z. 1218: Tickets, Reaktionszeit, SLA
- Z. 1248: Entwürfe für Arbeitspakete
- Z. 1271: Ticket-Historie des Druckers
- Z. 1295: Zugänge von Herrn Brandt

Keine davon stammt aus der Report-Familie (Monitoring, Verfügbarkeit, Sensoren). Lumens Satz schließt mit „Ergänzend“ direkt an Navis’ Ticketbilanz an, und Baumanns Antwort „Klingt besser, als ich gedacht hätte“ passt weiterhin auf beide Beiträge. Wie in R19 bleibt bei Z. 1295 offen, woher Navis die Zugänge kennt (Sollte-Thema, nicht umgesetzt).

## Offene Fragen, Risiken, Abweichungen

- **story/current (Befund, nicht geändert):** ci-check scheitert vor und nach dem Commit nur an „story/current/fahrt-zum-kunden.html weicht von source/fahrt-zum-kunden.html ab“. Weder PR #9 (`auftrag-R03-buchtext-v138`) noch PR #10 berühren `story/current`. `git log origin/main..HEAD -- story/current` ist leer, und `git diff origin/main..HEAD` ändert nur `source/fahrt-zum-kunden.html`. Die Abweichung kommt also schon aus R03/#9: Die Quelle wurde geändert, die Veröffentlichungsfassung nicht nachgezogen. Bei PR #9 ist der Check „Website prüfen“ deshalb rot (FAILURE). PR #10 zielt auf #9 statt auf main und hat keine Checks. Vor dem Merge nach main muss `story/current` aus der Quelle neu erzeugt werden; dafür braucht es einen eigenen Auftrag.
- **PDF:** `source/Die-Fahrt-zum-Kunden.pdf` und `story/current/geschichte.pdf` sind weiterhin v1.37 und untereinander gleich, deshalb meldet ci-check dafür keinen Fehler. Ein neues Rendern steht noch aus (laut R19 nötig).
- **M11/K14:** Die gleiche ASCII-Umschrift „AVKK-Uebersicht“ steht auch in der Versionshistorie (Z. 2176). Sie gehört nicht zu M11, und K14 rät, die Historie nicht umzuschreiben, deshalb habe ich sie gelassen.
- **M10:** Mit dem Vorschlag fällt Lumens „nur als Randnotiz“ weg. Der Ton wird dadurch etwas sachlicher; wenn der Autor das will, kann er „nur als Randnotiz“ vor „Heute früh“ wieder einsetzen.
- Sollte- und Kann-Befunde habe ich nicht umgesetzt.

## Vorschläge und Ideen (Claude)

- Einen eigenen kleinen Auftrag anlegen: `story/current/fahrt-zum-kunden.html` aus der Quelle neu erzeugen und die PDF v1.38 rendern, gebündelt vor dem Merge von #9/#10. Dann wird die CI grün.
- Einen CI-Workflow auch für PRs auf Nicht-main-Basen (gestapelte PRs wie #10) prüfen lassen, damit Fehler früher sichtbar werden (Änderung an `.github/workflows` nur mit Freigabe).
- Die Hausregel ß/ss gleich mitklären (S16). M11 hat im Anhang schon „ausschließlich“ mit ß gesetzt, an anderen Stellen steht weiter „ausschliesslich“.
- Das Ersetzungsskript (Literal-Ersetzung, genau ein Treffer pro Befund, sonst Abbruch) taugt als Muster für künftige Lektoratsrunden. In dieser Runde hat es die Doppelfundstelle in der Historie aufgedeckt.

Hygiene: Worktree `/c/dev/wt-r26` mit lokalem Branch `geschichte-veraltete-daten-20261107` angelegt und nicht entfernt; der Stand ist gleich origin (9dfdc54). Keine gemergten Remote-Branches übrig (`git branch -r --merged origin/main` leer). Offene PRs laut `gh pr list`: #6, #9, #10.

```yaml
Reifegrad: "Entwurf v1.38: Muss-Befunde aus R19 behoben; Sollte/Kann offen; story/current und PDF noch nicht nachgezogen"
Projektstatus: "PR #10 (Draft, Basis #9) mit Commit 9dfdc54; CI bei #9 rot wegen story/current (vorbestehend)"
Offene_Fragen:
  - "Wer erzeugt story/current und die PDF v1.38 neu, und wann (vor dem Merge von #9/#10)?"
  - "Soll Lumen bei M10 'nur als Randnotiz' behalten?"
  - "Hausregel ß oder ss (S16)?"
  - "Welche Sollte-Befunde aus R19 sollen in die nächste Runde?"
Roadmap:
  hinweis: "unbelegte Schätzung"
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```
