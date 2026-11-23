---
titel: 'R09 Nachprüfung v1.40 nach Aktualisierung von Supabase (nur lesend)'
datum: 2026-11-23
auftrag: R09
vorbericht: reports/R09-BERICHT.md
pruefstand_main: 84ae3427ea0e81dfb084d326f3da8547ef84c3ac
supabase_precheck: 2026-11-23T14:50:43Z
supabase_aenderung: 2026-11-23T14:50:46Z
supabase_diffcheck: 2026-11-23T14:50:54Z
abruf_r09: 2026-11-23T14:52:27Z
ergebnis: bestanden
---

# R09 Nachprüfung v1.40

Der Vorbericht `reports/R09-BERICHT.md` (14:21 UTC) war nicht bestanden: Supabase stand noch auf v1.37. Danach hat der Product Owner im Chat den Supabase-Teil der Veröffentlichung freigegeben. Dieser Bericht hält die Vorab-Prüfung, die Änderung, die Nachkontrolle und die erneute Live-Prüfung fest.

## 1. Supabase-Aktualisierung (Freigabe Product Owner im Chat, 23.11.2026)

Umfang laut Freigabe: `story_release` id=current auf Version 1.40, „16. November 2026“, 80 Seiten, `published_at` auf den Zeitpunkt der Änderung. Im Speicher `story/current` nur die vier Dateien ersetzen, nichts löschen, keine anderen Objekte.

Weg: Ein PowerShell-Skript in der Sitzung hat direkt die Supabase-Schnittstellen aufgerufen, so wie `assets/js/admin.js` es tut (PUT auf `/storage/v1/object/story/current/<datei>`, PATCH auf `/rest/v1/story_release?id=eq.current`). Der Schlüssel mit Schreibrecht kam aus der Sitzungsumgebung und steht in keiner Datei. Inhaltstypen wie in `admin.js`: `text/html; charset=utf-8` und `application/pdf`. Quelle der Dateien: `git show origin/main:story/current/<datei>` bei 84ae342. `publish-release.ps1` schreibt nicht nach Supabase und wurde nicht verwendet.

### Precheck, 14:50:43 UTC (nur lesend)

Das Skript bricht ab, wenn eine Bedingung nicht stimmt. Ergebnis: „Precheck OK“.

| Prüfung | Erwartet | Ist |
|---|---|---|
| `story_release` id=current | 1.37 / 5. September 2026 / 64, genau 1 Zeile | gleich |
| Speicher, SHA-256 der vier Dateien | Stand aus Schritt 1 (siehe Vorbericht, Abschnitt 2) | gleich |
| Quelldateien | SHA-256 gleich `origin/main` 84ae342 | gleich |

### Änderung, 14:50:45 bis 14:50:46 UTC

Ausgabe: `ersetzt: fahrt-zum-kunden.html`, `ersetzt: geschichte.pdf`, `ersetzt: workshop-handout.html`, `ersetzt: workshop-handout.pdf`, `story_release aktualisiert, Zeilen: 1`.

### Diff-Check, 14:50:54 UTC (nur lesend)

| Ort | Soll | Ist | Ergebnis |
|---|---|---|---|
| `story_release` version | 1.40 | 1.40 | OK |
| `story_release` display_date | 16. November 2026 | 16. November 2026 | OK |
| `story_release` page_count | 80 | 80 | OK |
| `story_release` published_at | Zeitpunkt der Änderung | 2026-11-23 14:50:46 UTC | OK |
| `geschichte.pdf` | 2080126, `c421ed71…26ae1` | gleich | OK |
| `fahrt-zum-kunden.html` | 1622808, `ef71ab34…05e31` | gleich | OK |
| `workshop-handout.pdf` | 217169, `1ed0758b…0700` | gleich | OK |
| `workshop-handout.html` | 7054, `a75c8e4c…6a63` | gleich | OK |
| Objekte in `story/current` | genau diese vier | genau diese vier | OK |

Die Hashes stimmen mit Anmeldung und öffentlich ohne Cache überein.

## 2. Live-Prüfung R09, 14:52:27 UTC

Nur lesend. Keine Anmeldung. Supabase mit dem öffentlichen Schlüssel aus `assets/js/supabase-config.js`. Jeder Abruf mit `Cache-Control: no-cache`, Dateiabrufe zusätzlich mit wechselndem Parameter `?nc=<Zeit>`. Vergleich mit `git show origin/main:<pfad>`: zuerst byteweise, bei Textdateien sonst nach Umwandlung von CRLF in LF.

Befehle (Kurzform):

- `Invoke-WebRequest -Headers @{apikey=<öffentlicher Schlüssel>; 'Cache-Control'='no-cache'} <url>/rest/v1/story_release?id=eq.current&select=version,display_date,page_count`
- `Invoke-WebRequest <url>/storage/v1/object/public/story/current/<datei>?nc=<zeit>`, dann SHA-256
- `Invoke-WebRequest https://berndmarnau.de/relingit/<pfad>?nc=<zeit>`, dann SHA-256 gegen `git show origin/main:<pfad>`
- PDF: `C:\dev\venv-pdf\Scripts\python.exe -I` mit pypdf, Seitenzahl und Text von Seite 1

| Prüfpunkt | Soll | Ist | Ergebnis |
|---|---|---|---|
| Startseitenzeile (aus `story_release`) | Version 1.40 · 80 Seiten · 16. November 2026 | HTTP 200 `[{"version":"1.40","display_date":"16. November 2026","page_count":80}]`; statisch `data-page-count` 80 | OK |
| PDF-Link | `setStoryLinks` biegt auf Speicher `story/current/geschichte.pdf` um; dort v1.40 | HTTP 200, application/pdf, 2080126 Bytes, gleich `main`; 80 Seiten, Deckblatt „Version 1.40“, „16.11.2026“. Rückfall auf dem Webspace ebenfalls gleich `main` | OK |
| Handout-Link | Speicher `story/current/workshop-handout.pdf` gleich `main` | HTTP 200, application/pdf, 217169 Bytes, gleich `main`, 2 Seiten; `workshop-handout.html` gleich `main` | OK |
| Lesefassung (lesen.html) | Viewer lädt `fahrt-zum-kunden.html` aus dem Speicher, v1.40 | lesen.html byte-gleich, story-viewer.js gleich ohne CR; Speicherdatei gleich `main`, Deckblatt `<span>Version 1.40</span>` | OK |
| Anhang (anhang.html) | gleiche Buchfassung, Auszug `section.appendix` | anhang.html byte-gleich; Speicherfassung enthält 7 Blöcke `section.appendix` | OK |
| Trailer | MP4 und Poster gleich `main` | `assets/video/fahrt-zum-kunden-trailer.mp4` HTTP 200, 2105919 Bytes, byte-gleich; `trailer-poster.jpg` byte-gleich | OK |
| Link zur Fahrt | `lesen.html#kap-aufbruch`, Anker in der Buchfassung | Link in index.html vorhanden; `id="kap-aufbruch"` in der Speicherfassung vorhanden | OK |
| index.html Server gegen `main` | gleich | byte-gleich, 12868 Bytes | OK |
| assets/js/app.js Server gegen `main` | gleich nach Normalisierung der Zeilenenden | gleich ohne CR (Server CRLF), 4511 Bytes | OK |
| weitere Viewer und Konfiguration | gleich `main` | pdf.html, handout.html byte-gleich; pdf-viewer.js, handout-viewer.js, supabase-config.js gleich ohne CR | OK |

Die Werte, die JavaScript setzt, sind aus Code und Daten abgeleitet. Im Browser gerendert habe ich die Seite nicht.

Hinweis: Der Speicher liefert die beiden HTML-Dateien öffentlich als `text/plain` aus. Die Viewer lesen sie mit `response.text()` und setzen sie in `iframe.srcdoc` (`story-viewer.js:56-64`, `:334`), daher wirkt sich das nicht aus.

## 3. Abgleich mit der Warteschlange (für den Planer)

`queue/INDEX.yaml` auf `ops/queue` mit `stand: 2026-11-23 15:30` gelesen. Nur Vorschläge, die Warteschlange wurde nicht geändert.

- **R09:** Im INDEX stehen noch Titel „v1.39“ und Status `wartet_auf_voraussetzung`. `queue/R09.yaml` enthält bereits `hinweis_2026_11_23` für v1.40. Vorschlag: Titel auf v1.40 umstellen, Status `erledigt`, Nachweis `R09-BERICHT.md` und dieser Bericht.
- **R52 (Tag v1.39) und R53:** Sie hängen an R09 v1.39. Eine Live-Prüfung v1.39 ist nicht mehr möglich, weil live v1.40 steht. Die Frage aus dem Vorbericht bleibt offen und ist eine Entscheidung des Product Owners. Laut UPLOAD-CHECKLISTE-v1.40.md folgt nach R09 der Tag v1.40 auf 84ae342; dafür gibt es im INDEX noch keinen Auftrag.
- **R87 (`bereit`):** Der Anlass ist mit diesem Bericht behoben. Der Auftrag (Ablauf, Sollwerte, lesender Modus) bleibt sinnvoll. Die Abläufe aus Abschnitt 1 und 2 eignen sich als Vorlage für `-NurPruefen`.

## Vorschläge und Ideen (Claude)

- In R87 die Vorab-Prüfung aus Abschnitt 1 übernehmen: alte Hashes und Werte als erwarteten Ist-Stand mitgeben. Weicht der Ist-Stand ab, wird nicht geschrieben.
- Bei lesenden Prüfungen mit PowerShell einen eigenen User-Agent setzen. Supabase behandelt den Standard-User-Agent als Browser.
- Die Inhaltstypen im Speicher (`text/plain` für HTML) in R87 als erwarteten Wert festhalten, damit eine spätere Prüfung sie nicht als Abweichung meldet.

Hygiene: nichts gemergt, kein Tag, kein FTP, kein Upload auf den Webspace. In Supabase wurde nur der freigegebene Umfang geschrieben.

```yaml
Reifegrad: Release v1.40 live (Webspace und Supabase)
Projektstatus: R09 v1.40 bestanden (Nachprüfung 23.11.2026)
Offene_Fragen:
  - Tag v1.40 auf 84ae342 setzen (Auftrag fehlt im INDEX)?
  - R52 (Tag v1.39) ohne Live-Beleg oder entfallen lassen?
Roadmap:
  Sprints_bis_BSF: unklar
  Sprints_bis_MVP: unklar
```
