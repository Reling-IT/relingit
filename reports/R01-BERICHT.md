---
id: R01
titel: 'Webseiten-Pflege: Seitenzahl, Repo-Links, Handout und Logo, Podcast-Ort'
status: erledigt
start: 2026-11-06T09:57+01:00
ende: 2026-11-06T10:13+01:00
branch: auftrag-a-website-pflege-20261106-0957
pr: https://github.com/Reling-IT/relingit/pull/4
commit: 928bcf0aa83c4b9938cb9bb7a27ad27161ed8375
ci: 'pass, https://github.com/Reling-IT/relingit/actions/runs/42191888846'
---

# R01 Bericht: Webseiten-Pflege

## Ergebnis

- `index.html` nennt statt 46 jetzt 69 Seiten. Der Rückfallwert `fallbackRelease` in `assets/js/app.js` stand bereits auf 1.37 / 5. September 2026 / 69 und blieb unverändert.
- Im Repo kommt `bmarnau/relingit` nicht mehr vor, also war kein Link anzupassen. Die Live-Seite zeigt noch den alten Link und 46 Seiten, weil der FTP-Upload aussteht.
- Handout und Logo sind korrekt verlinkt. Es gibt vier Vorschläge, aber keinen Fehler.
- Auf der Webseite ist kein Podcast-Audio eingebunden oder verlinkt.
- `ci-check.ps1` und `node --check` laufen lokal ohne Fehler. PR #4 ist offen, die CI ist grün, nichts ist gemergt.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| PDF-Seitenzahl | 69 Seiten | `pdfinfo story/current/geschichte.pdf` → `Pages: 69` |
| Buchversion | Deckblatt Version 1.37 | `grep` in `story/current/fahrt-zum-kunden.html`, Zeile 656 |
| Rückfallwert app.js | `1.37`, `5. September 2026`, `69` | `assets/js/app.js`, Zeilen 7–11 |
| Wahl Seitenzahl | konkreter Wert 69 statt neutraler Formulierung, damit Besucher ohne JavaScript den richtigen Wert sehen | PR #4, Abschnitt 1 |
| Vorschlag publish-release.ps1 | Seitenzahl in `index.html` per Skript mitpflegen | PR #4, Abschnitt 1. Auf Wunsch des Owners vorgezogen umgesetzt in PR #5 (siehe Abweichungen) |
| Repo-Links | Treffer: `index.html:113` und `docs/CODEX_PROMPT.md:4` zeigen beide korrekt auf `Reling-IT/relingit`. `github.com/n8n-io/n8n` im Buchtext ist eine Fremdquelle. Kein `bmarnau` im Repo | `git grep -nI -iE "bmarnau\|Reling-IT/relingit\|github\.com"` sowie `grep -rnI bmarnau` ohne Treffer |
| Live-Stand | Die Live-Seite zeigt `github.com/bmarnau/relingit` und `46 Seiten`, `app.js` live hat 69 | `curl https://berndmarnau.de/relingit/` → HTTP 200 (nur lesend) |
| Handout und Logo | Logo und Favicon sind auf allen Seiten relativ eingebunden, die lokalen Links sind in Ordnung. Vorschläge: Handout-Metazeile ist statisch, `handout-viewer.js` wird ohne Cache-Parameter geladen, die CI prüft `handout-viewer.js` nicht per `node --check`, das Handout-HTML hat keine externen Verweise | PR #4, Abschnitt 3 |
| Podcast | keine Fundstelle. Die CSP in `.htaccess` enthält kein `media-src` | Grep nach `podcast\|<audio\|.mp3\|.m4a\|.ogg\|.wav\|audio/` ohne Treffer, `find` nach Audiodateien leer |
| ci-check.ps1 | OK | `pwsh -NoProfile -File ./scripts/ci-check.ps1` → `OK: 11 HTML-Dateien, Version/Datum, lokale Links, PDFs und Secret-Schutz geprüft.`, Exit 0 |
| node --check | alle sechs Dateien ohne Fehler | `node --check assets/js/*.js` → jeweils Exit 0 (Node v24.16.0) |
| CI | pass | `gh pr checks 4` → `Website prüfen pass` |

## Offene Fragen, Risiken, Abweichungen

- **Nicht geprüft:** Supabase-Daten (`story_release`, Storage), Darstellung im Browser, Edge Function, FTP-Upload. Den Live-Stand habe ich nur bei Seitenzahl, Repo-Link und Rückfallwert verglichen.
- **Abweichung Branch-Name:** Statt `auftrag-R01-<kurzname>` heißt der Branch `auftrag-a-website-pflege-20261106-0957`. Der Owner hatte ihn vorgegeben, der Auftrag kam direkt vom Owner und nicht aus `ops/queue`. Ich benenne ihn nicht um, damit PR #4 erhalten bleibt.
- **Abweichung Quelle:** Zum Zeitpunkt der Ausführung lag `origin/ops/queue` noch nicht auf GitHub. Ich habe R01 nach dem gleichlautenden Direktauftrag des Owners ausgeführt. Den Inhalt von `queue/R01.yaml` habe ich gegen das ZIP `ops-queue-relingit-2026-11-06a.zip` abgeglichen, er deckt sich mit dem Direktauftrag.
- **Vorgezogener Teil von R02:** Auf Anweisung des Owners ist PR #5 (`auftrag-a-seitenzahl-skript-20261106`) angelegt. Er pflegt die Seitenzahl in `index.html` per `publish-release.ps1` und prüft sie in `ci-check.ps1`. R02 steht noch auf `wartet_auf_entscheidung`.
- **Risiko:** Die Live-Seite bleibt veraltet, bis der Owner nach dem Merge den FTP-Upload ausführt.
- **Hinweis zum Einspiel-Skript:** `queue-einspielen-relingit.ps1` erwartet standardmäßig `ops-queue-relingit-2026-11-06b.zip`, im Download-Ordner liegt aber nur `…-06a.zip`. Die Commit-Nachricht nennt „R01 bis R06“, das ZIP enthält nur R01 und R02. Ohne Parameter `-Zip` bricht das Skript ab.

Hygiene: keine gemergten Remote-Branches außer `main`, offen sind PR #4 und PR #5 (beide kein Draft, CI grün), keine Drafts.

```yaml
Reifegrad: "Webseiten-Pflege umgesetzt, im Repo korrekt; Live-Stand veraltet bis zum FTP-Upload"
Projektstatus: "R01 erledigt (PR #4 offen, CI grün); R02 wartet auf Entscheidung, Teil Seitenzahl vorab in PR #5"
Offene_Fragen:
  - "q15: Standardweg zum Hochladen (FTP-Paket oder Admin-Bereich mit Supabase)?"
  - "Bestätigung Reling-IT/relingit als endgültige Adresse"
  - "Reihenfolge Merge: #4 vor #5, oder nur #5 und #4 schließen?"
  - "Einspiel-Skript: Standard-ZIP 06b anpassen oder 06a per -Zip übergeben?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```
