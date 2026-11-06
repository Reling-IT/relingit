---
id: R02
titel: 'Veroeffentlichungsweg: Admin-Bereich als Standard, Vollstaendigkeits-Check, Anleitung'
status: erledigt
start: 2026-11-06T11:32+01:00
ende: 2026-11-06T11:45+01:00
branch: auftrag-R02-veroeffentlichung
pr: https://github.com/Reling-IT/relingit/pull/8
commit: 40961f1
ci: 'pass, https://github.com/Reling-IT/relingit/actions/runs/42204856756'
---

# R02 Bericht: Veröffentlichungsweg

## Ergebnis

PR #8 enthält drei kleine Commits:

1. **`ca69b0e` ci-check:** Der Vollständigkeits-Check der Buchquelle prüft:
   - `cover-meta` mit Version und Datum, dazu `cover-whatsnew` mit derselben Version.
   - Die drei Deckblatt-Boxen, je genau einmal in `box-shell`.
   - Die Personenliste: Felder badge, name, role und tenure gefüllt, Navis und Lumen vorhanden.
   - Das Inhaltsverzeichnis: Gruppen Teil 1, Teil 2 und Anhang; jedes `h2#kap-*` und jeder Anhang ist verlinkt.
   - Die Versionshistorie: Zeilen lesbar, Versionen aufsteigend, letzte Zeile gleich dem Deckblatt.
2. **`b21d227` publish-release.ps1:**
   - Gibt am Ende Version, Datum, Seitenzahl und die Pfade für `admin.html` aus.
   - Meldet, ob das Handout geändert ist und ob ein FTP-Upload nötig ist.
   - Vergleicht per `git diff` gegen den letzten Commit, der `story/current/fahrt-zum-kunden.html` geändert hat. Ein anderer Stand lässt sich mit `-VergleichMit` setzen.
   - Kein Upload.
3. **`40961f1` Dokumentation:**
   - Neu: `docs/NEUE-GESCHICHTE.md` mit sechs Schritten, jeweils mit Befehl und erwartetem Ergebnis.
   - README und `DOMAINFACTORY-DEPLOYMENT.md` nennen den Admin-Bereich als Standardweg und die kanonische Adresse `Reling-IT/relingit`.
   - Die Sicherheitshinweise sind unverändert.

Buchtext, PDF, Workflows, Deployment und Supabase sind unverändert. Der Anhang als eigene Seite (q12) ist nicht Teil dieses PRs, er gehört zu R07. Nicht gemergt.

### Erkennungsregeln im FTP-Hinweis

| Regel | Dateien | Ausgabe |
|---|---|---|
| FTP-Grund (q15) | `index.html`, `assets/js/**`, `impressum.html`, `datenschutz.html` | „FTP-Upload nötig: ja, geändert: …“ |
| Nur Rückfallwerte | Zeilen unterscheiden sich nur in `version:`, `date:`, `pageCount:`, `data-page-count>N<`, `id="story-release">Version …<` | „Nur Rückfallwerte: …“, zählt nicht als FTP-Grund |
| Weitere öffentliche Dateien | `.htaccess`, `lesen.html`, `pdf.html`, `handout.html`, `handout-pdf.html`, `admin.html`, `assets/css`, `assets/img` | „Hinweis: weitere öffentliche Dateien geändert …“ |
| Handout | `story/current/workshop-handout.html` und `.pdf` | „Handout geändert: ja“ mit beiden Pfaden als Paar |
| Neue Dateien | Dateien, die Git noch nicht verfolgt, in denselben Pfaden | wie geänderte Dateien |
| Kein Git oder kein Vergleichsstand | – | „nicht ermittelbar … Bitte von Hand prüfen.“ |

### Belege

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| Syntax | `Parser::ParseFile(publish-release.ps1)` | `PARSE OK` |
| ci-check im Repo | `pwsh -File scripts/ci-check.ps1` | `OK: 21 HTML-Dateien, … Vollständigkeit der Buchquelle … geprüft.` (11 Repo-Seiten plus 10 aus dem ignorierten `output/ftp`) |
| ci-check negativ | Kopie `scratchpad/r02neg` mit 5 eingebauten Fehlern | alle 5 benannt, Exit 1 |
| JavaScript | `node --check assets/js/*.js` | ohne Fehler |
| Whitespace | `git diff --check` | ohne Befund |
| Probelauf echter Stand | Klon `scratchpad/r02probe`, `pwsh -File scripts/publish-release.ps1` | Übergabe ausgegeben, Vergleichsstand `f96ab5d`, Handout nein, FTP ja für `assets/js/app.js` und `index.html` (durch PR #4 und #5 seit dem letzten Release geändert) |
| Nur Rückfallwerte | im Klon Version, Datum und Seitenzahl in `app.js` und `index.html` geändert | beide `True` (nur Rückfallwerte); nach angehängter Codezeile `app.js` = `False` |
| Handout und CSS | im Klon Handout und `assets/css/legal.css` geändert, `-VergleichMit <Basis>` | Handout ja mit Paar, FTP nein, Hinweis auf `assets/css/legal.css` |
| CI | `gh pr checks 8` | `Website prüfen pass` |

## Vorschläge und Ideen (Claude)

1. **Release-Tags einführen, sobald der Owner es freigibt:** Der Vergleich nutzt jetzt den letzten Commit, der die Geschichte geändert hat. Ein Tag pro Version (`v1.38`) wäre eindeutiger und ließe sich direkt mit `-VergleichMit v1.37` nutzen. Ich habe keinen Tag gesetzt, weil Tags ausgeschlossen sind.
2. **Erster echter Lauf wird „FTP ja“ melden:** Seit dem letzten Release (`f96ab5d`, 29.09.2026) haben PR #4 und #5 `index.html` und `app.js` geändert, nicht nur Rückfallwerte. Beim Release v1.38 (R03) ist deshalb einmal ein FTP-Upload nötig. Mit R11 (Avatare) kommen `index.html` und Bilder dazu.
3. **Dateinamen im Admin-Bereich:** `admin.js` verlangt die Namen `fahrt-zum-kunden.html` und `die-fahrt-zum-kunden.pdf` (Groß- und Kleinschreibung egal). Die Ausgabe nennt genau die Dateien aus `source/`. Eine Kopie unter anderem Namen wird abgelehnt. Das steht jetzt auch in der Anleitung.
4. **Zeilennummern in Fehlermeldungen:** Der Vollständigkeits-Check nennt Element und Inhalt, aber keine Zeilennummer. Für lange Quellen wäre die Zeile hilfreich. Das wäre eine kleine Folgeänderung.
5. **„21 HTML-Dateien“ ist irreführend:** `ci-check` zählt das lokal entpackte `output/ftp` mit. Vorschlag: `output/` in `ci-check` ausnehmen. Nicht umgesetzt, weil das über R02 hinausgeht.
6. **Ausgabe-Encoding:** In Git-Bash erscheinen Umlaute der Skriptausgabe verstümmelt. In PowerShell 7 im Terminal sind sie korrekt. Bei Bedarf `[Console]::OutputEncoding = [Text.UTF8Encoding]::new()` am Skriptanfang setzen.

## Offene Fragen, Risiken, Abweichungen

- **Podcast-Schritt:** In `NEUE-GESCHICHTE.md` ist Google Gemini als Werkzeug genannt, wie im Auftrag. Genaue Bedienschritte liegen im Repo nicht vor.
- **PDF-Erzeugung (Schritt 2):** Die Werkzeuge `verify_layout.py` und `render_story_pdf.py` fehlen im Repo und unter `C:\dev`. Die Anleitung beschreibt deshalb nur das Ergebnis, nicht den Befehl. Betrifft auch R03.
- **Neue Queue-Version:** `ops/queue` steht jetzt auf `167c883` (R11, Konto Claude, mit Trailer und Session-Link, gültig). R11 hat den Status `wartet_auf_voraussetzung` und wird nicht angefasst.

Hygiene: offen sind PR #6 (nicht aus dieser Sitzung), PR #7 und PR #8, keine Drafts.

```yaml
Reifegrad: "Veröffentlichungsweg dokumentiert und vom Skript angeleitet, Buchquelle automatisch auf Vollständigkeit geprüft"
Projektstatus: "R02 erledigt, PR #8 offen, CI grün; nächster Auftrag R03"
Offene_Fragen:
  - "Release-Tags pro Version erlaubt (bessere Vergleichsbasis)?"
  - "Wo liegen verify_layout.py und render_story_pdf.py?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
