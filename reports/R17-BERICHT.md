---
id: R17
titel: 'Release-Trockenlauf v1.38: Paket bauen, Dateiliste für den Upload (kein Upload)'
status: erledigt
datum: 2026-11-08
basis: origin/main 81849d9 (PR #10 gemergt)
worktree: C:\dev\wt-r17 (detached, danach entfernt)
art: lesen – kein Commit, kein Upload, kein FTP
---

# Bericht R17 – Release-Trockenlauf v1.38

## Ziel

Bernd bekommt eine fertige Upload-Liste für v1.38: was über den Admin-Bereich (Supabase) hochgeladen wird und was per FTP. Dazu das lokal gebaute Paket, der Abgleich mit dem Stand v1.37 und mit der Live-Seite sowie eine Schritt-für-Schritt-Anleitung. Hochgeladen oder veröffentlicht wurde nichts.

## Vorprüfung der Skripte

- `scripts/build-upload.ps1` gelesen. Das Skript ruft `ci-check.ps1` auf, liest Version und Datum aus `assets/js/app.js`, kopiert die feste Liste `$publicFiles` nach `output/ftp/<Paket>`, schreibt `UPLOAD-MANIFEST.txt`, packt ein ZIP und prüft es bytegenau nach. Es gibt keinen FTP- oder Netzwerkaufruf.
- `scripts/ci-check.ps1`: Eine Suche nach `Invoke-WebRequest`, `Invoke-RestMethod`, `curl` und `ftp` findet keinen Netzwerkaufruf, nur `WebUtility.HtmlDecode`.
- `scripts/pruefe-podcast-live.ps1`: nur HTTP HEAD auf die vier MP3.

## Skriptausgabe

### Variante A: `build-upload.ps1 -OhneAudio` (empfohlen)

```text
Hinweis: 4 von 4 Podcast-MP3 liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). build-upload.ps1 baut ohne sie nur mit -OhneAudio ein Paket.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
OK: geprüftes Upload-Paket erstellt: C:\dev\wt-r17\output\ftp\relingit-upload-v1.38-2026-11-07-ohne-audio.zip
OK: 35 aktuelle Quelldateien bytegenau im ZIP bestätigt.
Hinweis: Paket ohne Podcast-MP3 (-OhneAudio). Beim Upload die Live-MP3 nicht löschen.
SHA-256 des ZIP: B1E02151D3ED05D011C195BDD74DDAD4966FF18C673D1F0E414D3D1618A8C124
```
Exit 0. ZIP: **4 666 653 Byte** (4,67 MB).

### Variante B: mit MP3 (zur Gegenprobe)

Die vier MP3 habe ich aus `C:\Users\bmarn\OneDrive\HTML\reling it\assets\audio` nur lesend nach `assets/audio/` im Worktree kopiert. Dort sind sie per `.gitignore:20` ignoriert. `sha256sum -c SHA256SUMS.txt` ergab 4× OK.

```text
OK: 4 Podcast-MP3 lokal vorhanden, Dateikennungen und Größen geprüft.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
OK: 4 Podcast-MP3 entsprechen assets/audio/SHA256SUMS.txt.
OK: geprüftes Upload-Paket erstellt: C:\dev\wt-r17\output\ftp\relingit-upload-v1.38-2026-11-07.zip
OK: 39 aktuelle Quelldateien bytegenau im ZIP bestätigt.
SHA-256 des ZIP: 332A0B1F905475115671929EA760EC0B88F25083600939697BBFFDADB5C695A9
```
Exit 0. ZIP: **73 686 657 Byte** (73,7 MB). Danach habe ich die MP3-Kopien gelöscht und den Worktree entfernt. Es gibt keine Kopie außerhalb des Worktrees.

### Release-Werte (Übergabe an den Admin-Bereich)

| Wert | Inhalt | Beleg |
|---|---|---|
| Version | **1.38** | `app.js` fallbackRelease, Manifest „Version: 1.38“ |
| Angezeigtes Datum | **7. November 2026** | `app.js`, `lesen.html` „Version 1.38 · 7. November 2026“ |
| Seitenzahl | **77** | `pdfinfo story/current/geschichte.pdf`: Pages 77; `index.html` `data-page-count>77` |
| HTML-Lesefassung | `source/fahrt-zum-kunden.html` (1 617 443 B) | bytegleich zu `story/current/fahrt-zum-kunden.html` (`cmp`) |
| PDF | `source/Die-Fahrt-zum-Kunden.pdf` (2 065 217 B) | bytegleich zu `story/current/geschichte.pdf` |
| Handout geändert | **nein** | `git diff --quiet f96ab5d..origin/main -- story/current/workshop-handout.*` |

Paketname: `relingit-upload-v1.38-2026-11-07-ohne-audio` (A) bzw. `relingit-upload-v1.38-2026-11-07` (B).

### Dateiliste des Pakets (A: 35 Dateien; B zusätzlich die 4 MP3)

`.htaccess`, `admin.html`, `datenschutz.html`, `handout-pdf.html`, `handout.html`, `impressum.html`, `index.html`, `lesen.html`, `pdf.html`, `assets/css/legal.css`, `assets/css/styles.css`, `assets/fonts/` (7 woff2: Fraunces-Variable, WorkSans-Regular/-Italic/-Bold, IBMPlexMono-Regular/-Italic/-Medium; 3 OFL-Texte; HERKUNFT.txt), `assets/img/favicon.png`, `assets/img/reling-it-logo.svg`, `assets/img/reling-it-podcast-cover.png`, `assets/js/admin.js`, `app.js`, `handout-viewer.js`, `pdf-viewer.js`, `story-viewer.js`, `supabase-config.js`, `story/current/fahrt-zum-kunden.html`, `geschichte.pdf`, `workshop-handout.html`, `workshop-handout.pdf`; dazu `UPLOAD-MANIFEST.txt`, das nicht übertragen wird.
Nur in B: `assets/audio/` mit den vier MP3.

## Diff gegen v1.37

**Stand v1.37:** `f96ab5d` (29.09.2026, „Fix admin password recovery flow (#2)“). Belege:
- `git log -S'version: "1.37"' -- assets/js/app.js` nennt f96ab5d (gesetzt) und ba5a23c (auf 1.38 geändert).
- f96ab5d ist der letzte Commit vor ba5a23c, der `story/current/fahrt-zum-kunden.html` ändert.
- `git show f96ab5d:assets/js/app.js`: 1.37 / 5. September 2026 / 69.
- Ein Tag v1.37 existiert nicht.

`git diff --stat f96ab5d..origin/main`: 67 Commits, 74 Dateien, +3348/−294. Ausgelieferte Dateien, 30 geändert:

```text
assets/audio/SHA256SUMS.txt            |  11 +   (neu, nicht im Paket)
assets/css/styles.css                  | 181 +-
assets/fonts/* (11 Dateien)            | neu
assets/img/avatare/* (7 Dateien)       | neu (nicht im Paket, von keiner Seite referenziert; Avatare sind Inline-SVG)
assets/img/reling-it-podcast-cover.png | neu
assets/js/app.js                       |  14 +-
assets/js/handout-viewer.js            |   4 +-
assets/js/story-viewer.js              |   4 +-
datenschutz.html                       |  23 +-
handout.html                           |   2 +-
index.html                             |  91 +-
lesen.html                             |   4 +-
story/current/fahrt-zum-kunden.html    | 324 +-
story/current/geschichte.pdf           | 1855398 -> 2065217 Byte
(source/ entsprechend)
```
Unverändert seit v1.37: `.htaccess`, `admin.html`, `impressum.html`, `pdf.html`, `handout-pdf.html`, `legal.css`, `admin.js`, `pdf-viewer.js`, `supabase-config.js`, `favicon.png`, `reling-it-logo.svg` und das Handout.

## Live-Stand (nur lesend per HTTP, 08.11.2026)

- **Supabase-Versionsangabe**, über denselben öffentlichen Lesezugriff, den `app.js` auf der Startseite macht (`story_release?id=eq.current`, öffentlicher Seitenschlüssel aus der live ausgelieferten `supabase-config.js`, ohne Anmeldung): `{"version":"1.37","display_date":"5. September 2026","page_count":64}`. Live wird also **1.37 · 5. September 2026 · 64 Seiten** angezeigt.
- **Live-`index.html`** stimmt mit keinem Commit überein. Sie entspricht dem Stand von R28 (`4df31e8`) bis auf zwei Zeilen: Sie enthält ein statisches „46 Seiten“ ohne `data-page-count`, und der Quellcode-Link zeigt auf `github.com/bmarnau/relingit`. Die Zahl überschreibt die live laufende `app.js` (v1.37) per `.meta`.
- **Podcast** (`scripts/pruefe-podcast-live.ps1`, Exit 0): 4× OK, die Größen stimmen mit `SHA256SUMS.txt` überein, Last-Modified 20.10.2026. Cover per HEAD: 1 005 947 Byte, gleich der Repo-Datei.
- **Abgleich je Datei**: Jede Paketdatei per GET geladen, dann `git hash-object` gegen origin/main und f96ab5d verglichen. Das Ergebnis steht in der Tabelle unten (Spalte „live = main“). `.htaccess` liefert 403, wie erwartet. Alle 11 Schriftdateien liefern **404**, sie sind live also noch nicht vorhanden.

## Einteilung Datei | Weg | geändert

„geändert v1.37“ = `git diff f96ab5d..origin/main`; „live = main“ = Hash der live ausgelieferten Datei gleich origin/main.

| Datei | Weg | geändert ggü. v1.37 | live = main? | Upload nötig |
|---|---|---|---|---|
| Version 1.38, Datum, Seitenzahl 77 | Admin | ja | nein (live 1.37/64) | **ja** |
| `source/fahrt-zum-kunden.html` | Admin | ja | nein | **ja** |
| `source/Die-Fahrt-zum-Kunden.pdf` | Admin | ja | nein | **ja** |
| Handout (HTML+PDF) | Admin | nein | ja | nein |
| `index.html` | FTP | ja | nein | **ja** |
| `assets/js/app.js` | FTP | ja | nein (= v1.37) | **ja** |
| `assets/js/story-viewer.js` | FTP | ja | nein (= v1.37) | **ja** |
| `assets/js/handout-viewer.js` | FTP | ja | nein (= v1.37) | **ja** |
| `assets/js/admin.js`, `pdf-viewer.js`, `supabase-config.js` | FTP | nein | ja | nein |
| `assets/css/styles.css` | FTP | ja | nein (R28-Stand) | **ja** |
| `assets/css/legal.css` | FTP | nein | ja | nein |
| `assets/fonts/*` (11) | FTP | ja (neu) | fehlen (404) | **ja** |
| `lesen.html` | FTP | ja | nein (= v1.37) | **ja** |
| `handout.html` | FTP | ja | nein (= v1.37) | **ja** |
| `datenschutz.html` | FTP | ja | **ja** (R28 schon live) | nein (unschädlich) |
| `impressum.html`, `admin.html`, `pdf.html`, `handout-pdf.html` | FTP | nein | ja | nein |
| `.htaccess` | FTP | nein | nicht prüfbar (403) | nein |
| `assets/img/favicon.png`, `reling-it-logo.svg` | FTP | nein | ja | nein |
| `assets/img/reling-it-podcast-cover.png` | FTP | ja (neu im Repo) | ja | nein |
| `story/current/fahrt-zum-kunden.html`, `geschichte.pdf` (Rückfallkopie) | FTP | ja | nein (= v1.37) | **ja** |
| `story/current/workshop-handout.*` | FTP | nein | ja | nein |
| `assets/audio/*.mp3` (4) | FTP | nein (Inhalt) | ja (Größe per HEAD) | **nein → -OhneAudio** |

Zählung:
- Admin-Bereich: 2 Dateien und 3 Werte, kein Handout.
- FTP: 20 Dateien wirklich nötig, nämlich 3 HTML (index, lesen, handout), styles.css, 11 Schriften, 3 JS und 2 Dateien in story/current. Empfohlen wird trotzdem der Upload des ganzen Pakets A mit 35 Dateien: Die übrigen 15 sind byte- bzw. inhaltsgleich, und so bleibt der Server sicher auf dem Paketstand.

### Empfehlung Audio

**Variante A (`-OhneAudio`) verwenden.** Gründe:
1. Die Live-MP3 haben genau die Größe aus `SHA256SUMS.txt`, und die OneDrive-Quelle ist hashgleich (`sha256sum -c` 4× OK). Ein Upload mit MP3 würde dieselben 69 MB noch einmal übertragen und nichts ändern.
2. Das Paket ist 4,7 MB statt 73,7 MB groß, damit sinkt das Abbruch- und Fehlerrisiko beim FTP.
3. Das Cover ist live schon identisch und steckt trotzdem im Paket.

Restrisiko: Die Live-MP3 sind nur über die Größe geprüft, nicht über einen Hash. Ein abweichender Inhalt bei gleicher Größe ist unwahrscheinlich, ich habe ihn aber nicht ausgeschlossen.
Hinweis: v1.38 ändert den Erzähltext (neues Kapitel „Die veralteten Daten“). Laut NEUE-GESCHICHTE §6 wäre eine neue Podcast-Fassung fällig. Das ist eine eigene Entscheidung von Bernd und hängt nicht an diesem Upload.

## Upload-Schritte (ohne Zugangsdaten)

**Vorbereitung**
1. Auf dem eigenen Rechner im Klon `C:\dev\relingit`, Stand main 81849d9: `./scripts/build-upload.ps1 -OhneAudio` ausführen. `publish-release.ps1` ist nicht nötig, weil story/current und die Rückfallwerte bereits auf main stehen.
   - Erwartet: `relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, „35 aktuelle Quelldateien“.
   - Der ZIP-Hash weicht vom hier genannten ab, weil die Erstellungszeit im Manifest steht.
2. Optional vorher `./scripts/pruefe-podcast-live.ps1`, erwartet 4× OK.

**A. Admin-Bereich (Standardweg)**
3. `https://berndmarnau.de/relingit/admin.html` öffnen, mit dem Administratorkonto anmelden und den Code der Authenticator-App bestätigen.
4. Eintragen: Version **1.38**, Datum **7. November 2026**, Seitenzahl **77**.
5. HTML `source/fahrt-zum-kunden.html` und PDF `source/Die-Fahrt-zum-Kunden.pdf` auswählen. **Kein Handout** auswählen.
6. Veröffentlichen. Kurzkontrolle in einem privaten Fenster: Die Startseite zeigt 1.38 und 77 Seiten. Das funktioniert auch mit der alten app.js.

**B. FTP (DomainFactory, von Hand)**
7. Im FTP-Programm versteckte Dateien anzeigen lassen, damit `.htaccess` mitkommt.
8. Den **Inhalt** des Paketordners mit seiner Ordnerstruktur nach `relingit/` übertragen und vorhandene Dateien überschreiben. `UPLOAD-MANIFEST.txt` nicht übertragen.
9. **Warnung:** Das Paket enthält keine MP3. **Die Live-Dateien unter `relingit/assets/audio/` dürfen nicht gelöscht werden.** Keine Spiegel- oder Synchronisationsfunktion mit „Löschen auf dem Ziel“ benutzen, nur hochladen und überschreiben.
10. `index.html` und `assets/js/app.js` in einem Durchgang hochladen. Die neue app.js setzt die Seitenzahl nur über `data-page-count`, das es erst in der neuen index.html gibt.
11. Nichts außerhalb des Pakets hochladen, also nichts aus `output/`, `archive/`, `source/` oder `docs/`.

**C. Nachkontrolle**
12. `./scripts/pruefe-podcast-live.ps1`, erwartet 4× OK.
13. Danach Auftrag **R09** (Live-Prüfung, nur lesend) auf bereit setzen. R09 vergleicht Version, Seitenzahl, Repo-Link (Reling-IT), supabase-config und die HTTP-Status je Datei. Zusätzlich empfehle ich zu prüfen, ob `assets/fonts/*.woff2` HTTP 200 liefern und welche Schrift `lesen.html` tatsächlich verwendet (siehe Abweichung 1).

## Offene Fragen und Abweichungen

1. **Schriftpfade in `lesen.html` zeigen live ins Leere (Befund, nicht behoben).**
   - `story-viewer.js` setzt die Geschichte als `srcdoc`. Die relativen Pfade `../assets/fonts/…` und `../../assets/fonts/…` lösen deshalb gegen `https://berndmarnau.de/relingit/lesen.html` auf und ergeben beide `https://berndmarnau.de/assets/fonts/…`. Dort kommt HTTP 404 (geprüft mit Python-`urljoin` und curl).
   - R27 hatte angenommen, `lesen.html` liege im Web-Stamm. Live liegt die Seite aber unter `/relingit/`.
   - Folge: In der Leseansicht erscheinen die Ersatzschriften, wegen `font-display:block` eventuell mit kurzer Verzögerung. Die direkt geöffnete `story/current/…` und die PDF sind nicht betroffen.
   - Der Upload ist dadurch nicht blockiert. Der Zweck von R27 wird in `lesen.html` aber verfehlt. Vorschlag siehe unten.
2. **Auftrag und Doku widersprechen sich bei der FTP-Liste.**
   - R17 nennt „FTP nur für index.html, assets/js, Impressum, Datenschutz“ (q15).
   - Die Doku nach R39 (NEUE-GESCHICHTE › FTP-Fall) nennt zusätzlich `assets/css`, `assets/fonts`, `lesen.html`, `handout.html`, `assets/img`, `assets/audio` und weitere Seiten.
   - Für v1.38 ist die erweiterte Liste nötig: `styles.css`, 11 Schriften, `lesen.html`, `handout.html` und die story/current-Kopie sind geändert bzw. fehlen live. `impressum.html` ist unverändert, `datenschutz.html` ist schon live. Ich bin der Doku gefolgt.
3. **publish-release würde jetzt Falsches melden.**
   - Der Vergleichsstand ist standardmäßig der letzte Commit an `story/current/fahrt-zum-kunden.html`. Das ist inzwischen ba5a23c, also v1.38 selbst. Ein erneuter Lauf auf main ergäbe „FTP-Upload nötig: nein“.
   - Richtig wäre `-VergleichMit f96ab5d`. Besser noch wäre ein Vergleich gegen den tatsächlich live hochgeladenen Stand.
   - Außerdem fehlen `assets/fonts` und `story/current` in `$otherPublicPaths`, neue Schriften würden also nicht einmal als Hinweis gemeldet.
4. **Supabase meldet live 64 Seiten**, Repo-v1.37 und die Rückfallwerte nennen 69, die statische Live-index.html nennt 46. Beim letzten Admin-Upload wurde offenbar eine andere Seitenzahl eingetragen. Für v1.38 gilt 77.
5. **Die Live-index.html stimmt mit keinem Commit überein.** Sie wurde aus dem R28-Stand ohne Seitenzahl-Span und mit dem alten Repo-Link `bmarnau/relingit` hochgeladen. Das neue Paket behebt beides.
6. **Die Doku ist veraltet:**
   - NEUE-GESCHICHTE, README und DOMAINFACTORY schreiben „`assets/fonts` (sobald vorhanden)“, die Schriften sind aber jetzt im Repo.
   - ABLAUF (Verzeichniskarte) sagt „Podcast-Cover nur lokal“, das Cover ist aber seit R36 versioniert.
   - Eine eigene „FTP-Upload-Checkliste“ gibt es nicht. `git ls-files | grep -i -E "ftp|checkliste|upload"` findet nur `docs/vorlagen/EINBAU-CHECKLISTE.md`, `scripts/build-upload.ps1` und `tests/build-upload.Tests.ps1`. Als Checkliste dienen NEUE-GESCHICHTE › FTP-Fall und DOMAINFACTORY › FTP-Paket hochladen.
7. **Cache:** `lesen.html` lädt `story-viewer.js?v=20260905-2`. Die Datei hat sich geändert, die Kennung nicht. Browser können also die alte Version aus dem Cache nehmen. Das ist geringfügig, es betrifft nur das aria-label.
8. **Supabase-Lesezugriff:** Für den Live-Stand habe ich die öffentliche Versionsangabe so gelesen, wie es die Startseite tut, also anonym und nur lesend. R09 schließt Supabase-Zugriff ausdrücklich aus. Falls das auch für R17 gelten sollte, ist das hier eine Abweichung.
9. Aus R16 offen: `verify_layout.py` ist nicht gelaufen, weil numpy und pillow fehlen. Ob `.htaccess` live wirkt, ist nicht prüfbar, die Sicherheitsheader fehlen laut R39.
10. R09 hat noch keinen Bericht. Der Verweis bezieht sich auf `queue/R09.yaml`.

## Vorschläge und Ideen (Claude)

- **Schriftpfad reparieren (kleiner Code-PR vor dem Upload):** In jeder `@font-face` als erste Quelle zusätzlich `url("assets/fonts/X.woff2")` aufnehmen, das passt für `lesen.html` im srcdoc. Alternativ in `story-viewer.js` vor dem Setzen von `srcdoc` ein `<base href>` auf das Verzeichnis von `lesen.html` einfügen. Ein ci-check-Test sollte die Pfade gegen eine Basis mit Unterverzeichnis auflösen, nicht gegen den Web-Stamm. Danach PDF und story/current neu erzeugen; die Seitenzahl dürfte gleich bleiben.
- **Vergleichsstand „live“ festhalten:** Nach jedem FTP-Upload einen Tag setzen (z. B. `live-ftp-JJJJMMTT`) und in `publish-release.ps1` als Standard für `-VergleichMit` nehmen. Damit wäre Abweichung 3 behoben und der wirkliche FTP-Bedarf sichtbar.
- **`$otherPublicPaths` aus `$publicFiles` von build-upload ableiten**, statt eine zweite Liste zu pflegen. Dann fehlen `assets/fonts` und `story/current` nicht mehr.
- **Live-Hashvergleich als Skript:** Den Abgleich aus diesem Auftrag (GET je Paketdatei, `git hash-object` gegen main) als `scripts/pruefe-live-stand.ps1` mit `-Trocken` anbieten. R09 könnte ihn direkt nutzen.
- **Cache-Kennungen** (`?v=`) für alle JS- und CSS-Einbindungen automatisch aus dem Datei-Hash setzen, z. B. in publish-release.
- Doku-Kleinigkeiten aus Abweichung 6 in einem Doku-Auftrag nachziehen.

Hygiene: Keine offenen PRs (`gh pr list --state open`: 0). Gemergte Remote-Branches noch vorhanden: `auftrag-R35-podcast-sicherung`, `auftrag-R36-podcast-hilfen`, `auftrag-R37-notebooklm`, `auftrag-r39-doku`, `auftrag-r40-barrierefreiheit`, `avatare-buch-und-seite-20261106`, `geschichte-veraltete-daten-20261107` (Löschkandidaten). Keine Drafts. Die alten Worktrees wt-r16, wt-r35, wt-r36, wt-r37, wt-r39, wt-r40 und wt-r43 bestehen noch. `C:\dev\wt-r17` ist entfernt: Vorher zeigte `git status --ignored` nur `!! output/`, die MP3-Kopien hatte ich schon gelöscht. `git worktree remove` lief ohne `--force`.

```yaml
Reifegrad: "v1.38 auf main paketierbar: build-upload -OhneAudio Exit 0 (35 Dateien, 4,67 MB), mit Audio Exit 0 (39 Dateien, 73,7 MB); Live noch v1.37 (Supabase 64 Seiten), Schriften live 404"
Projektstatus: "R17 erledigt (Trockenlauf). Upload durch Bernd ausstehend: Admin 2 Dateien + Werte 1.38/7. November 2026/77, danach FTP-Paket ohne Audio; dann R09"
Offene_Fragen:
  - "Schriftpfad-Fehler in lesen.html (srcdoc unter /relingit/) vor dem Upload beheben oder nachträglich?"
  - "Erweiterte FTP-Liste (css, fonts, lesen/handout, story/current) als Owner-Regel bestätigen statt q15?"
  - "Podcast nach neuem Kapitel mit NotebookLM neu erzeugen oder bewusst beim Stand 20.10.2026 bleiben?"
  - "publish-release-Vergleichsstand künftig auf einen Live-Tag umstellen?"
  - "Gemergte Remote-Branches und alte Worktrees aufräumen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
