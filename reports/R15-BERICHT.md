---
id: R15
titel: "Release-Prüfungen – PDF-Version gegen Deckblatt, output/ aus ci-check ausnehmen"
status: erledigt (PR offen, nicht gemergt)
start: 2026-11-07T06:00+01:00
ende: 2026-11-07T06:35+01:00
branch: auftrag-R15-release-pruefungen
pr: https://github.com/Reling-IT/relingit/pull/14
commit: 450b38e
ci: "Website prüfen – pass (Run 42343249236)"
---

## Ergebnis

`publish-release.ps1` liest die Version vom PDF-Deckblatt (pdftotext, Seite 1) und bricht vor dem Kopieren nach `story/current` ab, wenn sie nicht zur HTML-Quelle passt. Die Meldung nennt beide Versionen.
Fehlt pdftotext, bricht das Skript ab. Nur der Schalter `-OhnePdfVersionspruefung` lässt den Lauf weiterlaufen, mit sichtbarer Warnung.
`ci-check.ps1` nimmt `output/`, `archive/` und `tmp/` aus der HTML-Schleife aus. Mit dem entpackten FTP-Paket zählt es wieder 11 statt 21 HTML-Dateien.
Der Konflikt mit R28 (PR #13, inzwischen gemergt) ist im Merge-Commit 450b38e aufgelöst. Die CI ist grün, PR #14 ist mergeable. Kein Tag, kein Merge.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| 0 Ausgangslage | `main` = 361f26c; Quell-PDF und `story/current/geschichte.pdf` sind bytegleich (SHA-256 bbfd1991…), Deckblatt „Version 1.37“, 69 Seiten; Quell-HTML Deckblatt 1.37 | `pdftotext -f 1 -l 1`, `pdfinfo`, `sha256sum` |
| 1 publish-release | Neue Prüfung nach dem pdfinfo-Block, vor `Copy-Item`. Abbruch bei: Exit-Code von pdftotext ≠ 0, keiner Versionsangabe, mehreren verschiedenen Versionen, Abweichung von der HTML. Ohne pdftotext: Abbruch, nur `-OhnePdfVersionspruefung` lässt den Lauf mit Warnung weiter | Commit bd854dd |
| 1 Begründung Schalter | Wie bei pdfinfo, dort ist `-PageCount` der ausdrückliche Ersatz. Für die Version gibt es keinen sinnvollen Ersatzwert, deshalb ist der Ausweg ein bewusster Verzicht. Eine bloße Warnung hätte den Fehler aus R03 wieder still durchgelassen | Kommentar im Skript, PR-Text |
| 2 ci-check | Die HTML-Schleife filtert `^(?:archive\|output\|tmp)[\\/]` relativ zum Projekt. `output/` ist git-ignoriert (`.gitignore:5:output/`) | Commit ae36efe, Merge 450b38e |
| 2 Vorher/Nachher | Vorher mit `output/test/index-kopie.html`: 14 Fehler „Fehlender lokaler Verweis in output\test\index-kopie.html: …“, Exit 1. Nachher: „OK: 11 HTML-Dateien …“, Exit 0. Mit entpacktem FTP-Paket (10 HTML in output/ftp): 11 | Logs in `r15-logs/ci-*.txt` |
| 3 Doku | `docs/NEUE-GESCHICHTE.md` Schritt 3: Prüfung der PDF-Version, Beispielmeldung, Notfallschalter | Commit 0388951 |
| 4 Probeläufe | Falsche Version: Exit 1, `story/current` unverändert. Richtige Version: Exit 0. Ohne Poppler: Exit 1; mit Schalter: Exit 0 mit Warnung. Nach dem R28-Merge wiederholt, gleiches Ergebnis | siehe Abschnitt Probeläufe |
| 5 PR/CI | PR #14 offen, CI „Website prüfen“ pass, PR-Kommentar mit CI-Ergebnis | PR #14, Kommentar 6702880865 |

## Probeläufe

Alle Läufe fanden in einer losgelösten Worktree-Kopie statt (`…\scratchpad\r15-probe`, `git worktree add --detach`), die danach mit `git worktree remove` entfernt wurde. Im echten Worktree hat sich nichts verändert (`git status` sauber), es wurde nichts aus der Probe gepusht.

1. **Falsche PDF-Version.** In der Kopie wurde die Quell-HTML auf 1.38 gesetzt: Deckblatt, „Neu in v1.38“ und ein neuer Historieneintrag 1.38/05.09.2026. Die PDF blieb 1.37.
   `PDF passt nicht zur HTML-Quelle: source/Die-Fahrt-zum-Kunden.pdf trägt Version 1.37, source/fahrt-zum-kunden.html Version 1.38. Bitte die PDF aus der aktuellen HTML neu erzeugen (docs/PDF-ERZEUGEN.md).` → **Exit-Code 1**. Die SHA-256-Werte von `story/current/*` waren vorher und nachher gleich, `output/` wurde nicht angelegt.
2. **Richtige Version** (Original 1.37/1.37): `OK: PDF-Deckblatt trägt Version 1.37 wie die HTML-Quelle.` → ci-check OK → ZIP `relingit-upload-v1.37-2026-09-05.zip`, 23 Dateien bestätigt → `OK: Version 1.37 vom 5. September 2026 mit 69 Seiten veröffentlicht und paketiert.` und die Admin-Übergabe → **Exit-Code 0**.
3. **Ohne Poppler** (PATH ohne pdftotext und pdfinfo, git vorhanden, `-PageCount 69`): `pdftotext fehlt (Poppler). Die PDF-Version kann nicht gegen das Deckblatt (1.37) geprüft werden. …` → **Exit 1**. Mit `-OhnePdfVersionspruefung`: `WARNUNG: pdftotext fehlt; die PDF-Version wird auf ausdrücklichen Wunsch (-OhnePdfVersionspruefung) NICHT geprüft. …` → Paket gebaut, **Exit 0**.
4. **Nach dem Merge von origin/main (R28)** auf 450b38e wiederholt, mit git-ignorierten Platzhaltern für die vier MP3 und das Podcast-Cover. Falsche Version: dieselbe Meldung, **Exit 1**. Richtige Version: `OK: 28 aktuelle Quelldateien bytegenau im ZIP bestätigt.`, **Exit 0**.

Logs: `C:\Users\bmarn\AppData\Local\Temp\claude\6631df4e69bbac2f\7afc4643-2502-4b66-a5f5-00a6fef5dcf8\scratchpad\r15-logs\` (probe-falsch.txt, probe-richtig.txt, probe-ohne-pdftotext*.txt, probe-*-nach-merge.txt, ci-vorher-mit-output.txt, ci-nachher-mit-output.txt).

## Vorschlag Release-Tags

Es wurde kein Tag gesetzt. Vorschlag: Nach jedem gemergten Release-PR einen annotierten Tag `geschichte-vX.YY` auf den Merge-Commit setzen, etwa `git tag -a geschichte-v1.38 -m "Geschichte v1.38" <merge-sha>`; das macht der Owner.
Nutzen:
- Eine eindeutige Vergleichsbasis für den FTP- und Handout-Hinweis: `./scripts/publish-release.ps1 -VergleichMit geschichte-v1.37`. Der heutige Standard („letzter Commit, der story/current/fahrt-zum-kunden.html geändert hat“) liefert f96ab5d vom 29.09.2026. Dadurch meldet der Probelauf „FTP-Upload nötig: ja (app.js, index.html)“, obwohl nichts veröffentlicht werden soll. Die Ursache sind spätere Änderungen an der Landingpage, nicht die Geschichte.
- Später könnte das Skript ohne `-VergleichMit` automatisch den jüngsten Tag `geschichte-v*` nehmen (`git describe --tags --match "geschichte-v*" --abbrev=0`).
- Die Versionsstände auf GitHub sind nachvollziehbar, auch für Rücksprünge.

## Offene Fragen, Risiken, Abweichungen

- **Abweichung (bewusst):** `ci-check` nimmt neben `output/` auch `archive/` und `tmp/` aus, damit alle drei Prüfungen dieselbe Ausnahme haben. Alle drei Ordner sind git-ignoriert. Anders als bei den bestehenden Schleifen wird der Pfad relativ zum Projekt geprüft. Sonst würde ein Klon unter z. B. `C:\tmp\…` alles ausschließen.
- **Befund, nicht behoben:** Das Datum auf dem PDF-Deckblatt ist **03.09.2026**, in der HTML-Quelle **05.09.2026** (beides v1.37). Eine Datumsprüfung würde daher auf dem heutigen `main` abbrechen. Sie wurde nicht eingebaut. Frage an den Owner: Soll das Datum ebenfalls geprüft werden, sobald eine neue PDF erzeugt ist?
- **R28-Überschneidung:** PR #13 wurde während der Arbeit gemergt. Der Konflikt in `ci-check.ps1` ist aufgelöst; der Podcast-Block bleibt unverändert, `build-upload.ps1` ist unberührt.
- **Folge von R28 (nicht R15):** `publish-release.ps1` bricht jetzt im Paketbau ab, wenn die MP3- und Cover-Dateien lokal fehlen. Das passiert erst *nach* dem Kopieren nach `story/current` und den Rückfallwerten. Ein Lauf ohne Podcast-Dateien hinterlässt also einen halb aktualisierten Arbeitsstand, den git aber zurücksetzen kann.
- Die Umlaute erscheinen in der Git-Bash-Konsole als „�“ (Konsolen-Codepage). Das betraf schon die bestehenden Meldungen; die Skriptdateien selbst sind UTF-8.
- Der Regex verlangt „Version X.YY“ als Text. Ändert sich das Deckblatt-Layout so, dass pdftotext das Wort trennt, bricht die Prüfung ab, sie lässt die PDF also nicht durch.

## Vorschläge und Ideen (Claude)

- Die Prüfung der Podcast-Dateien (R28) in `publish-release.ps1` vor das Kopieren ziehen, analog zur PDF-Prüfung, damit kein halbfertiger Stand entsteht.
- Die PDF-Versionsprüfung zusätzlich in `ci-check.ps1` einbauen, wenn pdftotext vorhanden ist; auf GitHub Actions ggf. Poppler im Workflow. Workflow-Änderungen waren für R15 ausgeschlossen, das entscheidet der Owner.
- Das Datum auf dem Deckblatt mitprüfen, nachdem die v1.37-PDF neu erzeugt ist (siehe Befund).
- Die Probeläufe als kleines Testskript (z. B. `scripts/test-publish-release.ps1`) anlegen, das selbst einen Worktree in `tmp/` erzeugt und wieder entfernt.
- Bei den beiden bestehenden Ausschlussfiltern (Google-Fonts, Secrets) ebenfalls den relativen Pfad prüfen.

Hygiene: gemergte Remote-Branches: `origin/quelle-pdf-werkzeuge-20261106` (löschbar nach Owner-Freigabe). Offene PRs: #14 (R15, dieser), #6 (Avatare). Drafts: #9 (R03 Buchtext v1.38), #10 (Geschichte „Die veralteten Daten“, v1.38). Lokale Worktrees: wt-r14, wt-r25, wt-r28 gehören zu bereits gemergten Aufträgen und können entfernt werden.

```yaml
Reifegrad: "Release-Ablauf mit Eingangsprüfungen für HTML, Seitenzahl und jetzt PDF-Version; lokal und in CI geprüft"
Projektstatus: "v1.37 live; v1.38 in Drafts (#9, #10); Release-Skript blockt falsche PDF-Version"
Offene_Fragen:
  - "Deckblatt-Datum der PDF (03.09.2026) weicht von der HTML (05.09.2026) ab – Datumsprüfung ergänzen, sobald die PDF neu erzeugt ist?"
  - "Release-Tags geschichte-vX.YY einführen (Vergleichsbasis für -VergleichMit)?"
  - "Podcast-Prüfung vor das Kopieren nach story/current ziehen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
