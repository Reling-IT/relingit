---
id: R66
titel: Sichtungsliste v1.39 vorbereiten (nur ops/reports)
status: erledigt
start: 2026-11-12T04:50+01:00
ende: 2026-11-12T04:55+01:00
---

# R66 – Sichtungsliste v1.39

Auftrag: `queue/R66.yaml` (ops/queue 9ffaea5). Ergebnis: `reports/SICHTUNG-v1.39.md`, alle Ergebnisfelder leer. Geschrieben wurde nur auf ops/reports.

## Inhalt

| Tor | v1.38 (Vorlage) | v1.39 | davon neu |
| --- | --- | --- | --- |
| G4 UI (Webseiten) | 18 | 28 | 10: Anhang-Seite (#26, drei Breiten), Bildmarken (#25, drei Breiten), Handout-Datum HTML und PDF (R65), Kontraste der Lesefassung (#33, zwei Breiten) |
| G3 Layout (PDF) | 6 | 15 | 9: sechs Kontrast-Ausschnitte nach `R41-bilder` (#33), Box „Die sieben Standards“ und Fußnote ADR/ADG (#27), Zeile „(früher ADF)“ |
| G5 Inhalt | 2 | 13 | 11: vier R65-Textstellen (Backup-Ticket mit Gegenstelle bei Navis), Handout-Datum, Versionshistorie v1.39, Box und Fußnote inhaltlich, Datum und Seitenzahl einheitlich |
| Summe | 26 | 56 | 30 |

- Je Punkt: Tor, Bereich, Adresse der Vorschau (`http://127.0.0.1:8043/…` aus `scripts/vorschau.ps1`) oder Stelle im Buch, erwartetes Ergebnis, Feld Ja/Nein, Bemerkung.
- Kopf mit Platzhaltern für Version, Datum, Seitenzahl, Paket, Paket-Hash und Basis-Commit; wird nach R60 eingetragen. Dazu eine leere Tabelle für den Tor-Stand und für die Entscheidung G8.
- Die 26 Punkte der Vorlage sind übernommen; P01, P02, P05, I01 und I02 sind auf v1.39 umformuliert („geänderte Szenen“ statt „neue Szene“, weil v1.39 kein neues Kapitel bringt).

## Belege für die neuen Punkte

| Punkt | Beleg |
| --- | --- |
| Anhang-Seite | `anhang.html` im Branch von #26 (`git ls-tree`); Befund C1 (R57) |
| Bildmarken | Diff von #25 in `index.html`: Bildmarken im Kopf und im Abschnitt „Worum es geht“ |
| Box und Fußnote | Diff von #27: Anker `kap-sieben-standards`, `fn-adr`, `fnref-adr` |
| Kontraste | `reports/R41-bilder/` (sechs Paare vorher/nachher), R41-BERICHT.md |
| R65-Stellen | PR #35, `reports/R65-BERICHT.md` |
| Datum, Seitenzahl, ADF-Zeile | R63-BERICHT.md (Seitenzahl 80 im Trockenlauf; Datum an fünf Stellen; ADF-Zeile Befund 4) |

## Abweichungen und Hinweise

- Der Auftrag nennt die Seitenzahl „in Deckblatt, PDF und Startseite“. Das Deckblatt trägt keine Seitenzahl (R63). Punkt I13 prüft deshalb PDF, Startseite, `story/current` und den Rückfallwert in `assets/js/app.js`.
- Der Wortlaut der R65-Stellen ist noch nicht freigegeben. Die Punkte I03 bis I07 beschreiben deshalb die Wirkung und verweisen auf R65-BERICHT.md, sie zitieren keinen Satz.
- W26 (Handout-PDF) wird mit „Nein“ enden, solange das Handout-PDF nicht neu gerendert ist (siehe R65).
- Die Liste ist von Hand aus der Vorlage abgeleitet, nicht von `scripts/freigabe-pruefen.ps1` erzeugt. Ein Lauf des Skripts für v1.39 schreibt lokal wieder seine eigene Liste mit 26 Punkten.
- Die Befunde aus R69 sind nicht als eigene Punkte aufgenommen, weil über sie noch nicht entschieden ist.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Die zusätzlichen Punkte je Version als kleine Datei im Repository führen (zum Beispiel `docs/sichtung-zusatz.yaml`) und von `freigabe-pruefen.ps1` einlesen lassen. Dann entsteht die vollständige Liste aus einem Lauf, und R68 kann das mitnehmen.
- Nach der Entscheidung zu R69 Nr. 1 und Nr. 2 zwei Punkte in G5 nachtragen.
- Die Sichtung in der Reihenfolge PDF, Lesefassung, Startseite machen: Die meisten neuen Punkte hängen am Buch, die Webseiten-Punkte sind danach schnell abgehakt.

Hygiene: gemergte Remote-Branches 0; offene PRs 10 (#25 bis #28, #30 bis #35), alle Draft.

```yaml
Reifegrad: Sichtungsliste v1.39 mit 56 Punkten liegt leer vor; Kopf wartet auf R60
Projektstatus: Sichtung v1.39 nach Merge-Block und R60; Upload v1.38 weiter offen
Offene_Fragen:
  - Sollen die Zusatzpunkte kuenftig von freigabe-pruefen.ps1 erzeugt werden (R68)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
