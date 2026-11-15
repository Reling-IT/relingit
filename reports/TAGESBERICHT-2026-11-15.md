# Tagesbericht 15.11.2026 (Claude Code)

## Tagesstart
Protokoll: `reports/TAGESSTART-2026-11-15.md` (4f34f1a, Nachtrag 18:25 in ee1aea2). Warteschlange nach `git fetch` gelesen (ops/queue 7d26ac0, seit 12.11. unverändert).

## Tagesabschluss (18:35, Claude Code)

Rolle: KI-Sitzung, nachmittags bis 18:35 mit dem Product Owner. Kein Tag, kein Upload, kein FTP.

### TA-01 Aufgaben

| Aufgabe | Stand | Nachweis |
| --- | --- | --- |
| Sichtung v1.39 (R60) | erledigt: 56 von 56 Punkten Ja | `SICHTUNG-v1.39.md` (9fc8087, 923b0be, 4a22a54) |
| Korrekturen aus der Sichtung, je mit Entscheidung des Product Owners | erledigt, auf #37 | 531b42a Handout-Datum Startseite; 8a54375 Anhang-Box „Die neun Standards“ (IAM, REST), Fassung 15.11.2026, neu gerendert; 90ecfd3 und a470a41 Seitenumbrüche |
| Freigabetore G1 bis G8 | erledigt: G1, G2, G6, G7 per `freigabe-pruefen.ps1`; G3 bis G5 per Liste; G8 vom Product Owner | PR-Kommentar #37 (Head a470a41) |
| Merge #37 | gemergt, a1b11a8; main danach CI grün, `ci-check.ps1` Exit 0, Pester 54/0 | Nachtrag Tagesstart 18:25 |
| Upload v1.39 | offen, beim Product Owner | Paket `relingit-upload-v1.39-2026-11-15-ohne-audio.zip`, SHA-256 `6E48827B3C69CC57C7CF20531327EAC7645E0A62587F16C469189205C75C1B98`, liegt in `C:\dev\wt\relingit\r60\output\ftp` |

Abweichungen:
- Merge durch die KI-Sitzung auf ausdrückliche Anweisung des Product Owners, abweichend von `CLAUDE.md`. Gebunden an den freigegebenen Head (`--match-head-commit a470a41`).
- #27, #33 und #35 hat GitHub beim Merge selbst als gemergt markiert (Heads in #37 enthalten); die vier Branches löschte die Repository-Einstellung `delete_branch_on_merge`. Kein eigenes Schließen oder Löschen.
- Der erste Versuch für P12 (Zeilenschutz für alle Zeilen der Versionshistorie) ergab 85 statt 80 Seiten und wurde verworfen; übernommen ist der Schutz nur der neuesten Zeile.

### TA-02 Fragen

In der Sitzung beantwortet (24 Fragen): Sichtung heute; Handout-Datum Startseite; Navigation unter 800 px annehmen; Wortlaut IAM und REST; Fassung 15.11.2026; erst rendern, dann weiter; zwei Seitenumbrüche beheben; Webseiten, PDF und Inhalt nach Vorschlag; Download-Link W07 bis W09 (A: annehmen, Liste korrigieren); #37 Ready; G8; Merge (B); Worktrees entfernen; `wt-rep` verschieben; Stunden; Aufträge für den Planer.

Offen, je mit Empfehlung:
1. Upload v1.39 (Entscheidung v1.38 oder v1.39 am 16.11.). Empfehlung: v1.39 hochladen; v1.38 ist darin aufgegangen.
2. R70 Teil 2 und zweiter Klon `C:\dev\reling-it\relingit`. Empfehlung: unverändert, nach Prüfung durch den Product Owner.

### TA-03 Offene Pull Requests

Keine. Offene Agenten-PRs: 0 (Grenze 3).

### TA-04 Aufräumen (nach `git fetch --prune`)

| Prüfpunkt | Befund |
| --- | --- |
| Arbeitsklon | `main` gleich `origin/main` a1b11a8, sauber |
| Remote-Branches | nur `main`, `ops/queue`, `ops/reports`; gemergte: 0 |
| Entfernt (Freigabe Product Owner) | Worktrees `wt-r41`, `wt/relingit/r65`, `wt-r06` und ihre lokalen Branches (`git branch -d`, alle in main); `r65` und `wt-r06` mit ignorierten Zwischenständen (`output/`, `reports/`), vorher gesichtet |
| Verschoben | `wt-rep` nach `C:\dev\wt\relingit\rep` (`git worktree move`) |
| Belassen | `wt/relingit/r60` (Branch auf GitHub gelöscht, lokal gemergt): enthält das Upload-Paket; nach dem Upload entfernen |
| Lokaler Branch `ops/queue` | 29 hinter origin (gelesen wird `origin/ops/queue`) |
| Weitere Klone | `C:\dev\reling-it\relingit`, nur gemeldet |
| Lose Dateien in `C:\dev` | keine mehr. Die sechs `wt-*.md` aus R70 waren beim Abschluss nicht mehr vorhanden; von dieser Sitzung nicht entfernt |
| Temporäre Dateien | eigene Vorschau-Kopien in `%TEMP%` gelöscht; Vorschau beendet |

### TA-05 Status und Plan

`reports/STATUS.yaml`: R60 mit Nachtrag 15.11., Stand und Abschlusszeile. `queue/INDEX.yaml` pflegt der Planer. Für den Planer (Entscheidung des Product Owners):
- R60 und R76 als erledigt vermerken; R29 auf bereit (wiederkehrend).
- **Neu, jetzt:** a) Doku-PR `docs/TAGESSTART.md` (Worktree-Ablage `C:\dev\wt\relingit\`, Klonprüfung auf zwei Ebenen), `C:\dev\venv-pdf` in `docs/PDF-ERZEUGEN.md`, Stunden 14.11. und 15.11. (je 3) in `docs/PILOT.md`. b) Sichtungsliste und `freigabe-pruefen.ps1` angleichen (Ergebnis fest aus Spalte 6; v1.39-Liste hatte eine Spalte mehr); Prüfpunkt W07 bis W09 (Download-Link liegt auf Startseite und `handout-pdf.html`) richtigstellen.
- **Danach:** c) Merge-Prüfung als Skript (Änderungszeilen, CI, `--match-head-commit`). d) Pester in die CI (`reports/VORSCHLAG-PESTER-CI.md`).
- **Vormerken:** e) Menü für Handys unter 800 px. f) Lesefassung: Anzeige unter dem Inhaltsverzeichnis zeigt nach einem Sprung kurz den Abschnitt davor. g) Hinweis an `bmarnau-standards/uebersicht`: dort noch „sieben Standards“.

### TA-06 Erreicht

1. v1.39 gesichtet: 56 von 56 Ja, Liste mit Bemerkungen und korrigierten Seitenverweisen.
2. Anhang auf neun Standards (IAM, REST) gebracht, Wortlaut vom Product Owner bestätigt, Fassung 15.11.2026, 80 Seiten.
3. Zwei Seitenumbrüche dauerhaft verhindert (Definitionseinträge, neueste Zeile der Versionshistorie).
4. G1 bis G8 erteilt, #37 gemergt (a1b11a8); offene PRs von 4 auf 0.
5. Lokale Ordnung: drei Worktrees entfernt, Berichte-Worktree an die vorgesehene Ablage verschoben.

Nächste Aufgaben, geordnet:
1. Upload v1.39 durch den Product Owner, Werte im Admin-Bereich.
2. R09 Live-Prüfung, danach Tag v1.39.
3. Worktree `wt/relingit/r60` nach dem Upload entfernen.
4. Aufträge a und b (sobald vom Planer angelegt).

### TA-07 Arbeitspaket nächste Sitzung (ca. 2 Stunden)

- **Ziel:** v1.39 ist live und geprüft, Tag gesetzt; Doku-PR a als Draft.
- **Zielbezug:** Release v1.39 abschließen.
- **Schritte:**
  1. `git fetch`; Warteschlange lesen (Aufträge a und b angelegt?).
  2. Nach dem Upload durch den Product Owner: R09 Live-Prüfung (Version, Datum 15. November 2026, 80 Seiten, Anhang mit neun Standards, Handout-Datum).
  3. Tag v1.39 auf a1b11a8 nach Freigabe.
  4. Worktree `r60` entfernen (Freigabe).
  5. Auftrag a als Draft-PR, danach b.
- **Abnahmekriterium:** R09-Bericht ohne Muss-Befund; Tag v1.39 auf origin; Draft-PR a mit grüner CI.
- **Vorbedingungen:** Upload und Werte im Admin-Bereich durch den Product Owner; Aufträge vom Planer.
- **Risiken:** Live-Stand liest Version und Datum aus Supabase; ohne Eintrag im Admin-Bereich zeigt die Seite die alten Werte. `publish-release.ps1` meldet „FTP-Upload nötig: nein“, weil es gegen den letzten Commit vergleicht; maßgeblich ist das Paket.

### TA-09 Stunden

Vom Product Owner für den 15.11. genannt: 3 Stunden. Eintrag in `docs/PILOT.md` mit dem Doku-PR (Auftrag a), zusammen mit 3 Stunden vom 14.11.

### Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Die Sichtungsliste künftig vom Skript erzeugen lassen und nur ergänzen; dann passen Spalten und Auswertung immer zusammen.
- Bei Textänderungen im Anhang die Seiten danach automatisch vergleichen (Text je Seite gegen den letzten Render). Das hat heute zwei Umbrüche sichtbar gemacht, die `verify_layout` nicht meldet.
- Den Stand-Satz der Standards-Box bei jeder Änderung mit dem Prüfdatum je Standard führen, wie heute („06.11.2026, IAM und REST: 15.11.2026“).

```yaml
Reifegrad: v1.39 auf main (a1b11a8), gesichtet 56/56, G1 bis G8 erteilt, 80 Seiten, Paket 6E48827B...1B98; nicht hochgeladen
Projektstatus: wartet auf Upload v1.39 durch den Product Owner, danach R09 und Tag
Offene_Fragen:
  - Upload v1.39 am 16.11.?
  - R70 Teil 2 und zweiter Klon - Freigabe nach Pruefung?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
