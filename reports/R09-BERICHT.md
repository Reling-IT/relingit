---
titel: 'R09 Live-Prüfung v1.40 (nur lesend)'
datum: 2026-11-23
auftrag: R09
pruefstand_main: 84ae3427ea0e81dfb084d326f3da8547ef84c3ac
abruf_webspace: 2026-11-23T14:21:25Z
abruf_supabase: 2026-11-23T14:22:29Z
ergebnis: nicht bestanden
---

# R09 Live-Prüfung v1.40

> Nachtrag 23.11.2026, 14:52 UTC: Nach der Aktualisierung von Supabase ist R09 bestanden. Siehe [R09-NACHPRUEFUNG-v1.40.md](R09-NACHPRUEFUNG-v1.40.md).

Auftrag des Product Owners im Chat am 23.11.2026: R09 für v1.40, nur lesen. Die Live-Seite berndmarnau.de/relingit wird mit `main` 84ae342 (`story/current`: Version 1.40, 16.11.2026, 80 Seiten) verglichen. Ausnahme zu den Grenzen in `queue/R09.yaml`: Der Product Owner hat das Lesen von `story_release` mit dem öffentlichen Schlüssel aus `assets/js/supabase-config.js` ausdrücklich verlangt. Es gab keine Anmeldung, kein FTP, keinen Tag und keine Änderung an der Seite oder in Supabase.

## Ergebnis in Kürze

- **Webspace (FTP-Teil): stimmt mit `main` überein.** Alle 39 abrufbaren Nutzdateien des Pakets v1.40 sind inhaltlich gleich mit `main`, 10 davon unterscheiden sich nur in den Zeilenenden (CRLF). `.htaccess` ist wie vorgesehen gesperrt (403), ihre Header wirken.
- **Supabase (Versionsangabe und Speicher `story/current`): steht noch auf v1.37.** Die Startseite, die Leseansicht, der Anhang, die PDF-Ansicht und das Handout laden ihre Inhalte und Versionsangaben aus Supabase. Besucher sehen deshalb v1.37 vom 5. September 2026.
- R09 ist damit für v1.40 **nicht bestanden**. Die Ursache liegt allein im Supabase-Teil der Veröffentlichung (Admin-Bereich, siehe README.md und `scripts/publish-release.ps1`, Abschnitt „Übergabe an den Admin-Bereich“).

## 1. Soll: Stand auf `main` 84ae342

| Merkmal | Wert | Beleg |
|---|---|---|
| Deckblatt Buchquelle | Version 1.40 | `story/current/fahrt-zum-kunden.html:689` `<span>Version 1.40</span>` |
| PDF | 80 Seiten, Deckblatt „Version 1.40“, „16.11.2026“, Renderstand 16.11.2026 07:49 MEZ | `python -I` mit pypdf: `len(PdfReader(...).pages)` = 80, Text von Seite 1 |
| Rückfallwerte | version "1.40", date "16. November 2026", pageCount 80 | `assets/js/app.js:7-11` |
| Statische Seitenzahl | 80 | `index.html:38` `<span data-page-count>80</span>` |
| lesen.html, anhang.html | „Version 1.40 · 16. November 2026“ | `id="story-release"` |

## 2. Supabase, nur lesend

Befehl: `curl -s "<url>/rest/v1/story_release?id=eq.current&select=version,display_date,page_count"` mit dem öffentlichen Schlüssel aus `assets/js/supabase-config.js`.
Ergebnis: HTTP 200, `[{"version":"1.37","display_date":"5. September 2026","page_count":64}]`

Speicher `story/current`, öffentlich abgerufen mit `curl <url>/storage/v1/object/public/story/current/<datei>`:

| Datei | Speicher (Last-Modified, Bytes, SHA-256) | `main` 84ae342 (Bytes, SHA-256) | Inhalt Speicher |
|---|---|---|---|
| geschichte.pdf | 05.09.2026 18:02 GMT, 1855398, `bbfd1991…446f` | 2080126, `c421ed71…26ae1` | Deckblatt „Version 1.37“, 69 Seiten |
| fahrt-zum-kunden.html | 05.09.2026 18:01 GMT, 1584463, `7f38cb12…9a106` | 1622808, `ef71ab34…05e31` | `<span>Version 1.37</span>` |
| workshop-handout.pdf | 05.09.2026 18:02 GMT, 105494, `8eb1b903…34d6` | 217169, `1ed0758b…0700` | 2 Seiten |
| workshop-handout.html | 05.09.2026 18:02 GMT, 7183, `6dd3f0d3…1222` | 7054, `a75c8e4c…a63` | – |

Nebenbefund: In `story_release` steht page_count 64, die PDF im Speicher hat aber 69 Seiten. Die Angabe war also schon für v1.37 nicht stimmig.

## 3. Webspace: alle Paketdateien gegen `main`

Liste: die 40 Nutzdateien aus `output/ftp/relingit-upload-v1.40-2026-11-16-ohne-audio.zip` (SHA-256 `C4107586…7537`, siehe UPLOAD-CHECKLISTE-v1.40.md). Jede Datei wurde mit `curl https://berndmarnau.de/relingit/<datei>` abgerufen und mit `git show origin/main:<datei>` verglichen: zuerst byteweise, sonst ohne CR.

| Ergebnis | Anzahl | Dateien |
|---|---|---|
| byte-gleich | 29 | u. a. index.html, lesen.html, anhang.html, handout.html, handout-pdf.html, pdf.html, admin.html, impressum.html, datenschutz.html, assets/css/*, Schriften, Bilder, trailer-poster.jpg, Trailer-MP4, alle vier Dateien in story/current |
| gleich bis auf Zeilenenden (Server CRLF) | 10 | assets/js/* (6), assets/img/*.svg (3), IBMPlexMono-OFL.txt |
| inhaltlich abweichend | 0 | – |
| nicht abrufbar | 1 | .htaccess: 403, wie vorgesehen |

index.html ist byte-gleich mit `main` (SHA-256 `5f01013b…743f`, 12868 Bytes, Last-Modified 23.11.2026 14:15:03 GMT).

## 4. Einzelprüfungen

| Prüfpunkt | Soll | Ist | Bewertung |
|---|---|---|---|
| Startseite, Kicker „Version …“ | 1.40 | Statisch leer (`<span data-version>`). `app.js` setzt den Wert aus `story_release`, also **1.37** | Abweichung (Supabase) |
| Startseite, „Seiten · aktualisiert am“ | 80 · 16. November 2026 | Statisch 80. Nach dem Laden von `story_release` **64 · 5. September 2026** | Abweichung (Supabase) |
| PDF-Link „PDF herunterladen“ | PDF v1.40, 80 Seiten | Statisch `story/current/geschichte.pdf` (Webspace, v1.40). `setStoryLinks` (`app.js:37-41`) biegt ihn auf den Supabase-Speicher um, dort liegt **v1.37, 69 Seiten** | Abweichung (Supabase) |
| PDF ansehen (pdf.html) | v1.40 | `pdf-viewer.js:14` lädt aus dem Speicher: **v1.37** | Abweichung (Supabase) |
| Handout (handout.html, Download) | Stand `main` | `handout-viewer.js:73` und `setStoryLinks` laden aus dem Speicher: Stand 05.09.2026 | Abweichung (Supabase) |
| Leseansicht lesen.html | 1.40 | Statisch „Version 1.40 · 16. November 2026“. `story-viewer.js:311` überschreibt das aus `story_release` mit 1.37 und lädt die HTML aus dem Speicher (v1.37) | Abweichung (Supabase) |
| Anhang anhang.html | 1.40 | wie lesen.html (gleicher Viewer, `data-extract="anhang"`): 1.37 | Abweichung (Supabase) |
| `/relingit/geschichte.pdf` | – | 404. Der Pfad ist nirgends verlinkt, gültig ist `/relingit/story/current/geschichte.pdf` (200, application/pdf, 2080126 Bytes = `main`) | Hinweis |
| Trailer | MP4 und Poster wie `main` | `assets/video/fahrt-zum-kunden-trailer.mp4` 200, video/mp4, 2105919 Bytes, byte-gleich. Range-Abruf `-r 0-99` liefert 206. Poster byte-gleich | in Ordnung |
| Link zur Fahrt | `lesen.html#kap-aufbruch` | `index.html:61` vorhanden. Anker `id="kap-aufbruch"` ist in der HTML auf `main` und auch in der Speicherfassung v1.37 enthalten | in Ordnung |
| .htaccess-Header | wie `.htaccess:9-14` | Auf `/`, PDF, Trailer und der 403-Antwort sind HSTS, nosniff, Referrer-Policy, X-Frame-Options, Permissions-Policy und CSP gesetzt, gleich der Datei auf `main`. `http://` → 301 auf `https://` | in Ordnung |
| R40-Dateien | Stand `main` | index.html, lesen.html, handout.html, assets/css/styles.css byte-gleich; story-viewer.js, handout-viewer.js gleich ohne CR. Marken-Link `aria-label="Reling IT / Geschichte – zur Startseite"` live (index.html:15) | in Ordnung |
| supabase-config.js | kein Platzhalter `HIER_` | kein Platzhalter, gleich `main` ohne CR | in Ordnung |

Die Werte, die JavaScript setzt, sind aus Code und Daten abgeleitet: `app.js` übernimmt `story_release` ohne weitere Bearbeitung. Gerendert im Browser habe ich die Seite nicht.

## 5. Abweichungen (Datei, Soll, Ist)

| Ort | Soll | Ist |
|---|---|---|
| Supabase `story_release` id=current | 1.40 / 16. November 2026 / 80 | 1.37 / 5. September 2026 / 64 |
| Speicher `story/current/geschichte.pdf` | SHA-256 `c421ed71…26ae1`, 80 Seiten | `bbfd1991…446f`, v1.37, 69 Seiten |
| Speicher `story/current/fahrt-zum-kunden.html` | `ef71ab34…05e31` | `7f38cb12…9a106` (v1.37) |
| Speicher `story/current/workshop-handout.pdf` | `1ed0758b…0700` | `8eb1b903…34d6` |
| Speicher `story/current/workshop-handout.html` | `a75c8e4c…a63` | `6dd3f0d3…1222` |

## 6. Veröffentlichung in Supabase nicht ausgeführt

Der Product Owner hat am 23.11.2026 das Schreiben der fünf Punkte aus Abschnitt 5 mit `scripts/publish-release.ps1` freigegeben. Ausgeführt wurde es nicht. Grund: Das Skript schreibt nicht nach Supabase. Es kopiert `source/` nach `story/current`, setzt die Rückfallwerte, baut das FTP-Paket, verschiebt ältere Pakete aus `output/ftp` nach `archive/ftp-packages` und gibt die Werte für den Admin-Bereich aus. Das Schreiben in Supabase geschieht nur über `admin.html` mit Anmeldung (`assets/js/admin.js`: `signIn`, `uploadStoryFile`, PATCH auf `story_release`). Konten und Anmeldungen sind für die KI-Sitzung ausgeschlossen. Nach der Vorgabe „Weicht etwas ab, stoppe und frage“ wurde gestoppt und gefragt.

Precheck für den Product Owner, Quelle passt zu `main`: Der Arbeitsklon `story/current` ist gleich `origin/main` 84ae342 (`git diff --quiet origin/main -- story/current`), die PDF hat 80 Seiten und trägt Version 1.40. Die zu wählenden Werte und Dateien im Admin-Bereich: Version 1.40, Datum „16. November 2026“, Seitenzahl 80, `story/current/fahrt-zum-kunden.html`, `story/current/geschichte.pdf`, Handout-Paar `story/current/workshop-handout.html` und `.pdf`. Danach R09 wiederholen (Diff-Check gegen die Hashes in Abschnitt 5).

## 7. Abgleich mit der Warteschlange (für den Planer)

- `queue/R09.yaml` (Stand 16.11.) beschreibt noch die Prüfung v1.39 und steht auf `wartet_auf_voraussetzung`. Der Product Owner hat R09 am 23.11. für v1.40 beauftragt. Vorschlag: Titel und Hinweis auf v1.40 umstellen, Status `blockiert` bis zur Veröffentlichung im Admin-Bereich.
- R52 (Tag v1.39) und R53 hängen an R09 v1.39. Laut UPLOAD-CHECKLISTE-v1.40.md sollte v1.39 vor v1.40 live geprüft werden. Der Webspace trägt jetzt aber schon v1.40, eine Live-Prüfung v1.39 ist nicht mehr möglich. Der Planer sollte entscheiden, ob R52 ohne Live-Beleg auf 907ca58 gesetzt wird oder entfällt.
- Die Warteschlange (`stand: 2026-11-16 08:40`) ist 7 Tage alt.

## Vorschläge und Ideen (Claude)

- `publish-release.ps1` am Ende ausdrücklich ausgeben lassen, dass Supabase noch nicht aktualisiert ist. So entsteht nicht der Eindruck, das Skript veröffentliche.
- Eine kleine Prüfung `scripts/live-check.ps1`, nur lesend: `story_release` und die Hashes im Speicher gegen `main`. Sie würde diese Abweichung sofort zeigen.
- page_count in `story_release` künftig aus der hochgeladenen PDF ableiten (Abweichung 64 statt 69 bei v1.37).
- Zeilenenden: Der Server erhält bei 10 Dateien CRLF. Das ist harmlos, erschwert aber Hash-Vergleiche. Das Paket mit LF bauen (siehe Upload-Checkliste v1.40, Prüfung).

Hygiene: offene PRs nicht neu geprüft; nichts gemergt, kein Tag, kein FTP, keine Änderung an Workflows, Supabase oder Konten.

```yaml
Reifegrad: Release v1.40 auf dem Webspace, Supabase noch v1.37
Projektstatus: R09 v1.40 nicht bestanden; Ursache Supabase-Teil der Veröffentlichung (Admin-Bereich)
Offene_Fragen:
  - Veröffentlicht der Product Owner v1.40 im Admin-Bereich (empfohlen), danach R09 erneut?
  - R52 (Tag v1.39) ohne Live-Beleg oder entfallen lassen?
Roadmap:
  Sprints_bis_BSF: unklar
  Sprints_bis_MVP: unklar
```
