---
id: R07
titel: Anhang als eigene Webseite vorbereiten (q12), ohne Doppelpflege
status: erledigt (Draft-PR offen, CI grün, nicht gemergt, nicht scharf geschaltet)
datum: 2026-11-09
branch: auftrag-R07-anhang-seite
pr: https://github.com/Reling-IT/relingit/pull/26
commit: 27d8428
ci: grün (Website prüfen, Lauf 42559072146)
---

## Ergebnis
Die Seite `anhang.html` zeigt die sechs Anhang-Blöcke des Buches mit eigenem Inhaltsverzeichnis. Den Inhalt `story/current/anhang.html` erzeugt `scripts/build-anhang.ps1` aus `source/fahrt-zum-kunden.html`. `publish-release.ps1` ruft das Skript bei jedem Release auf. `ci-check.ps1` meldet einen Fehler, wenn die erzeugte Seite nicht mehr zur Buchquelle passt oder ein Anhang-Block keine eindeutige, stabile ID hat. Am Buchtext habe ich nichts geändert. Die Seite war ohne Buchänderung möglich, der Auftrag ist also nicht blockiert.

## Anhang-Liste (source/fahrt-zum-kunden.html, v1.38)
Ausgabe von `./scripts/build-anhang.ps1 -Liste`:

| Zeile | ID | ID sitzt an | Titel |
|---|---|---|---|
| 2014 | kap-handout | h2 (section ohne ID) | Die Vorlage: Handout „Sysing Dashboard – Agentenprojekt“ |
| 2024 | kap-sysingboard-architektur | section | Das Sysingboard in echt: Navis’ einzige Quelle |
| 2034 | kap-reportfamilie-architektur | section | Die Report-Familie in echt: zwei Architekturbilder |
| 2048 | kap-avkk-quelle | section | Woher AVKK kommt: das ZAVKK-Modell |
| 2058 | kap-standard | h2 (section ohne ID) | Functional is not Done: der Prüf-Standard hinter jeder Freigabe |
| 2097 | kap-versionen | section | Versionshistorie |

Fehlende Anker gibt es nicht. Auffällig sind zwei Blöcke, deren ID nur an der h2 sitzt (kap-handout, kap-standard). Die Prüfung lässt „ID an der section oder an der ersten h2“ zu. Die sechs IDs stimmen mit der Gruppe „Anhang“ im Mini-Inhaltsverzeichnis des Buches überein. Aus dem Anhang führen keine internen Links in die Kapitel.

## Konzept (umgesetzt im Draft)
- **Erzeugung** `scripts/build-anhang.ps1`. Gelesen werden die Blöcke `<div class="box-shell"><section class="appendix">…</section></div>`. Gibt es eine section.appendix in anderer Form, bricht das Skript ab. Die Ausgabe besteht aus dem `<head>` der Buchquelle mit eigenem Titel („Anhang | Die Fahrt zum Kunden“), einem Inhaltsverzeichnis `nav.cover-toc#anhang-inhalt` in der Buch-Gestaltung, den Blöcken bytegenau wie im Buch und dem Buch-Fuß. Die Datei wird mit LF, UTF-8 ohne BOM und ohne Zeitstempel geschrieben und ist damit deterministisch. Das Skript kennt die Modi `-Pruefen` (Befunde als Text, für ci-check) und `-Liste`.
- **Release** In `publish-release.ps1` läuft die Erzeugung vor dem Kopieren nach story/current. Ein Anker-Fehler bricht also ab, bevor etwas ersetzt wird. Der Stand wird auch in `anhang.html` gesetzt.
- **Viewer** `anhang.html` im Projektstamm ist aufgebaut wie `lesen.html` und nutzt dasselbe `assets/js/story-viewer.js` mit data-Attributen am iframe:
  - `data-local-url`
  - `data-remote-path=""`: kein Supabase-Abruf
  - `data-release-info="static"`: Die Version wird nicht aus Supabase überschrieben, denn die lokale Datei kann älter sein.
  - `data-top-label`, `data-status-text`
  - `data-outside-target="lesen.html"`: Links auf Kapitel außerhalb des Anhangs führen zur Lesefassung.

  Neu für beide Viewer ist der Sprung zum Anker aus der Adresse. Für `lesen.html` ist das Verhalten sonst unverändert (Standardwerte), der Cache-Parameter steht jetzt auf v=20261109-1.
- **Verlinkung**
  - `index.html`: Textlink „Anhang“ bei „Im Browser lesen / PDF ansehen“
  - `lesen.html`: Schaltfläche „Anhang“
  - `anhang.html`: Schaltfläche „Zur Geschichte“
  - CSS: Die Schaltflächen im Viewer-Kopf brechen nicht mehr um, bei 520 px darf der Kopf umbrechen.
- **Sicherheit**
  - Wie bei lesen.html: `sandbox="allow-same-origin"` ohne `allow-scripts`. Im Anhang wird also kein Skript ausgeführt. Dazu `referrerpolicy="no-referrer"`.
  - CSP in `.htaccess` unverändert und ausreichend: `script-src 'self'`; `img-src 'self' data:` für die eingebetteten JPEGs; `style-src 'unsafe-inline'` wie bisher für das Buch-CSS.
  - Der Anhang-Viewer spricht Supabase nicht an.
  - Die Sandbox-Prüfung in ci-check gilt jetzt auch für anhang.html.
  - admin.js nimmt nur den Dateinamen fahrt-zum-kunden.html an. Ein versehentlicher Upload von anhang.html ist dort ausgeschlossen.
- **CI** `ci-check.ps1`:
  - Pflichtdateien `anhang.html`, `story/current/anhang.html` und `scripts/build-anhang.ps1`
  - Anker-Prüfung: Jeder Block hat eine ID der Form `kap-…`, sie ist unter den Blöcken eindeutig und kommt im ganzen Buch genau einmal vor. Jeder Block hat eine h2.
  - Die erzeugte Datei muss genau der Skriptausgabe entsprechen. Zeilenenden werden dabei normalisiert, damit autocrlf keinen Fehlalarm auslöst.
  - Die Versionsangabe in anhang.html muss zu lesen.html passen.
- **Paket** `build-upload.ps1` nimmt `anhang.html` und `story/current/anhang.html` auf. `vorschau.ps1` übernimmt die Liste automatisch.
- **Doku** README (neuer Abschnitt „Anhang-Seite“, Release-Absatz), docs/NEUE-GESCHICHTE.md (git add, FTP-Fall), docs/DOMAINFACTORY-DEPLOYMENT.md (Erst-Upload-Liste).
- **Tests** Zusätzlich kopiert TestHelfer build-anhang.ps1 und erzeugt die Anhang-Seite im Mini-Projekt. Die Fixtures haben eine h2 in der Versionshistorie bekommen. Neu sind die Fixture `anhang-ohne-id` und die Mini-Fixture `anhang.html`. Drei neue Tests: Block ohne ID, von Hand geänderte Seite, Titel/Inhaltsverzeichnis/Anker.

## Prüfbelege
```
> pwsh -File scripts/ci-check.ps1            (Worktree C:\dev\wt-r07, Commit 27d8428)
Hinweis: 4 von 4 Podcast-MP3 liegen nicht vor (...)
OK: 13 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
exit 0

> node --check assets/js/<datei>.js
OK admin.js, app.js, handout-viewer.js, pdf-viewer.js, story-viewer.js, supabase-config.js

> Invoke-Pester -Path tests                  (Pester 3.4.0, pwsh 7.6.9)
Tests completed in 322.07s
Passed: 24 Failed: 0 Skipped: 0     (vor dem Auftrag: 21/0)

> Gegenprobe: <h2>Versionshistorie</h2> in story/current/anhang.html von Hand geändert, ci-check
Anhang: Anhang-Seite ist nicht aktuell: story/current/anhang.html entspricht nicht source/fahrt-zum-kunden.html (mit scripts/build-anhang.ps1 neu erzeugen, nicht von Hand bearbeiten)
(danach neu erzeugt, ci-check wieder OK)

> build-upload.ps1 -OhneAudio -Suffix r07probe
OK: 37 aktuelle Quelldateien bytegenau im ZIP bestätigt.
ZIP-Einträge mit "anhang": story/current/anhang.html, anhang.html     (Probepaket danach gelöscht)

> git diff --cached --check                  ohne Befund
> Suchmuster aus ci.yml auf story/current/anhang.html und Buchquelle: keine Treffer
```
Lokale Vorschau: `scripts/vorschau.ps1 -OhneBrowser -Port 8072` (zuvor 8071). Geöffnet mit Microsoft Edge headless (`--dump-dom`, `--virtual-time-budget=8000`). Die Chrome-Erweiterung war nicht verbunden.
```
GET anhang.html 200 (2557 B), story/current/anhang.html 200 (1 438 052 B), assets/fonts/WorkSans-Regular.woff2 200

anhang.html#kap-versionen
  <title>Anhang | Die Fahrt zum Kunden</title>
  <option value="__top">Anfang des Anhangs</option>
  <option value="kap-handout">Die Vorlage: Handout „Sysing Dashboard – Agentenprojekt“</option>
  <option value="kap-sysingboard-architektur">Das Sysingboard in echt: Navis’ einzige Quelle</option>
  <option value="kap-reportfamilie-architektur">Die Report-Familie in echt: zwei Architekturbilder</option>
  <option value="kap-avkk-quelle">Woher AVKK kommt: das ZAVKK-Modell</option>
  <option value="kap-standard">Functional is not Done: der Prüf-Standard hinter jeder Freigabe</option>
  <option value="kap-versionen">Versionshistorie</option>
  current-section: Abschnitt 6 von 6: Versionshistorie
  story-status: Anhang aus der Buchquelle
anhang.html#kap-avkk-quelle   current-section: Abschnitt 4 von 6: Woher AVKK kommt: das ZAVKK-Modell
lesen.html#kap-umweg          current-section: Abschnitt 2 von 31: Der Umweg; Link "Anhang" vorhanden
index.html                    <a class="text-link" href="anhang.html">Anhang
```
Screenshots in 1280 und 390 px (Scratchpad anhang-1280.png, anhang-390.png): Die Gestaltung entspricht der Lesefassung, Webschriften und Bilder werden geladen. Bei 390 px ist der Viewer-Kopf rechts etwas abgeschnitten. Das ist bei lesen.html genauso (Vergleich lesen-390.png) und nicht neu.

CI: PR #26, Job „Website prüfen“: pass (8 s), https://github.com/Reling-IT/relingit/actions/runs/42559072146

## PR
https://github.com/Reling-IT/relingit/pull/26 (Draft, offen, nicht gemergt)

## Abweichungen und offene Punkte
- **FTP bei jedem Release:** Die Anhang-Seite geht nicht über den Admin-Bereich. Weil die Versionshistorie im Anhang steht, ändert sich `story/current/anhang.html` mit jeder Buchfassung. Ich habe die Datei in die FTP-relevante Liste von publish-release.ps1 aufgenommen. Damit meldet jeder Release „FTP-Upload nötig: ja“, was q15 („Admin-Bereich als Standard, FTP nur ausnahmsweise“) widerspricht. Vor dem Scharfschalten sollte der Owner entscheiden (siehe Vorschläge).
- **Auslegung „Teil 2“:** Umgesetzt sind wie in den Schritten beschrieben die Blöcke section.appendix. Die „Realer Bezug“-Kapitel (aside.real, darunter die Anhang-Box „Datenstand“ kap-datenstand) gehören nicht dazu.
- **ID an der h2:** Die Anker-Prüfung lässt die ID an der ersten h2 zu, weil kap-handout und kap-standard sonst ohne Buchänderung nicht bestehen würden.
- **Änderung an story-viewer.js:** Statt eines zweiten Viewer-Skripts wird das vorhandene gemeinsam genutzt. Das wirkt auch auf lesen.html: neuer Ankersprung aus der Adresse, sonst gleiches Verhalten.
- **Testlauf und letzte Änderungen:** Der Pester-Lauf (24/0) lief vor den letzten zwei kleinen Änderungen (Statustext per data-Attribut, `white-space: nowrap` für Viewer-Schaltflächen). Beide berühren keine Tests. ci-check und node --check liefen auf dem Endstand, die Kopfzeile mit nowrap habe ich nicht erneut per Screenshot geprüft.
- **Bericht:** Er liegt im Scratchpad und ist nicht committet, wie vorgegeben.
- **Aufräumen:** Nichts installiert. Zwei eigene Vorschau-Kopien im Temp-Ordner sind nach dem Abbruch der Server von Hand gelöscht.

## Vorschläge und Ideen (Claude)
- **Ohne FTP aktuell halten:** (a) admin.js lädt `story/current/anhang.html` zusammen mit der Buchfassung nach Supabase. Im Viewer genügen dann `data-remote-path="story/current/anhang.html"` und das Entfernen von `data-release-info`. (b) Alternativ schneidet der Viewer den Anhang im Browser aus der ohnehin geladenen Buchfassung (Supabase) aus. Dann braucht es keine zweite Datei und keinen FTP-Schritt, die erzeugte Datei bleibt lokale Rückfallfassung. (b) ist kleiner und braucht keinen Supabase-Eingriff.
- In der nächsten Buchversion die IDs von kap-handout und kap-standard an die section verschieben. Danach die Prüfung auf „ID an der section“ verschärfen.
- Rückverweise aus den Geschichten auf `anhang.html#kap-…` sind jetzt möglich (Ankersprung aus der Adresse). Das wäre der zweite Teil von q12 in der Buchversion.
- In freigabe-pruefen.ps1 die Sichtungsliste um anhang.html in 390, 768 und 1280 px ergänzen.
- Den abgeschnittenen Viewer-Kopf bei 390 px (lesen.html und anhang.html) in einem kleinen CSS-Auftrag prüfen.
- docs/ABLAUF.md (Diagramm der öffentlichen Seiten, Schritt E) beim Scharfschalten nachziehen.

Hygiene: keine gemergten Remote-Branches mehr vorhanden (remote nur main, auftrag-R11-avatare-webseite, auftrag-R07-anhang-seite und ops/*). Offene PRs: #25 (Draft, R11) und #26 (Draft, R07). Worktree C:\dev\wt-r07 bleibt stehen (sauber, gepusht). Nichts gemergt, kein Tag, keine Veröffentlichung, kein FTP, keine Änderung an Workflows, Supabase, Admin-Konten oder Buchtext.

```yaml
Reifegrad: Anhang-Seite als Draft lauffähig, aus der Buchquelle erzeugt und in CI abgesichert; Auslieferungsweg (FTP vs. Supabase) offen
Projektstatus: R07 als Draft-PR #26 offen, CI grün, wartet auf Entscheidung und Review durch Bernd
Offene_Fragen:
  - Soll die Anhang-Seite per FTP bei jedem Release, per Admin-Upload nach Supabase oder per Ausschnitt im Browser aktuell gehalten werden?
  - Gehören die Realer-Bezug-Kapitel (Teil 2, aside.real) ebenfalls auf eine eigene Seite, oder bleibt es bei section.appendix?
  - Sollen kap-handout und kap-standard in der nächsten Buchversion die ID an der section bekommen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
