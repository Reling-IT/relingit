---
id: R46
titel: 'Anhang-Seite per Browser-Extraktion aus der Buchfassung (PR #26 umbauen, kein zweiter Upload)'
status: erledigt (Draft-PR #26 aktualisiert, CI grün, nicht gemergt)
datum: 2026-11-09
branch: auftrag-R07-anhang-seite
pr: https://github.com/Reling-IT/relingit/pull/26
commit: 6336236
ci: grün (Website prüfen, Lauf 42561583888)
---

## Ergebnis
`anhang.html` lädt dieselbe Buchfassung wie `lesen.html`, also Supabase und sonst `story/current/fahrt-zum-kunden.html`. Der Viewer schneidet im Browser alle Blöcke `section.appendix` heraus und zeigt sie mit Inhaltsverzeichnis. Damit gilt die Entscheidung von Bernd vom 09.11.2026 (q15): ein Upload pro Buchfassung, keine erzeugte Datei, kein zusätzlicher FTP-Schritt pro Release. Am Buchtext habe ich nichts geändert. Der PR bleibt Draft.

## Änderungen gegenüber dem ersten Stand von PR #26 (Commit 27d8428)
| Datei | Änderung |
|---|---|
| assets/js/story-viewer.js | Neu ist `data-extract="anhang"` mit drei Funktionen. `extractAppendix()` parst die Buchfassung mit DOMParser, übernimmt `head style` (Schriftpfade schon umgeschrieben), alle section.appendix samt box-shell und den Buch-Fuß, und baut das Inhaltsverzeichnis `nav.cover-toc#anhang-inhalt` mit Stand „Version X vom TT.MM.JJJJ“. `removeExecutableContent()` entfernt script/noscript/iframe/frame/object/embed/form/link/meta/base, on*-Attribute und javascript:/vbscript:-Adressen. `prepareMarkup()` wählt zwischen ganzer Fassung und Anhang. Die Optionen data-local-url, data-remote-path und data-release-info sind entfallen. Geblieben sind data-top-label, data-status-text, data-outside-target und der Ankersprung aus der Adresse |
| anhang.html | `data-extract="anhang"` statt lokaler Datei und statischem Stand. Statustext „Anhang aus der Buchfassung“. Sandbox unverändert ohne allow-scripts |
| scripts/build-anhang.ps1, story/current/anhang.html | entfernt |
| scripts/ci-check.ps1 | Pflichtdateien ohne die erzeugte Datei und ohne das Skript. Neue Funktion `Test-AppendixAnchors`, sie prüft nur die Buchquelle: jeder Block hat eine h2, eine ID `kap-<name>` an der section oder ersten h2, eindeutig unter den Blöcken und genau einmal im Buch. Die Gleichheitsprüfung ist entfallen |
| scripts/publish-release.ps1 | Erzeugung und FTP-Eintrag entfernt. Der Rückfallstand in anhang.html wird weiter gesetzt, wie bei lesen.html |
| scripts/build-upload.ps1 | nur noch `anhang.html` |
| tests | TestHelfer ohne build-anhang. Entfernt: Tests „von Hand geänderte Seite“ und „erzeugte Seite mit Titel/Inhaltsverzeichnis/Anker“. Geblieben ist „Anhang-Block ohne ID“, neu ist „ID entspricht nicht dem Muster kap-<name>“ |
| README.md, docs/NEUE-GESCHICHTE.md | Beschreibung der Browser-Extraktion, FTP-Hinweise zur erzeugten Datei entfernt |

Unverändert geblieben sind die Verlinkung von index.html und lesen.html, die Kopfzeile mit nowrap und der Ankersprung für beide Viewer.

## Anhang-Liste (Quelle v1.38)
| Zeile | ID | ID sitzt an | Titel |
|---|---|---|---|
| 2014 | kap-handout | h2 | Die Vorlage: Handout „Sysing Dashboard – Agentenprojekt“ |
| 2024 | kap-sysingboard-architektur | section | Das Sysingboard in echt: Navis’ einzige Quelle |
| 2034 | kap-reportfamilie-architektur | section | Die Report-Familie in echt: zwei Architekturbilder |
| 2048 | kap-avkk-quelle | section | Woher AVKK kommt: das ZAVKK-Modell |
| 2058 | kap-standard | h2 | Functional is not Done: der Prüf-Standard hinter jeder Freigabe |
| 2097 | kap-versionen | section | Versionshistorie |

PR #27 (v1.39) fügt `kap-sieben-standards` als siebten Block hinzu, mit ID an der section. Der Viewer und die Prüfung arbeiten mit beliebig vielen Blöcken.

## Sicherheitsbewertung
- Die Sandbox `allow-same-origin` ohne `allow-scripts` ist unverändert. Im Anhang-Dokument laufen keine Skripte.
- DOMParser führt beim Parsen keine Skripte aus und lädt keine Ressourcen. Die Bereinigung ist eine zweite Sicherung, falls die Buchfassung einmal Skripte oder Handler enthält.
- Die Bilder bleiben data:-URIs (CSP `img-src 'self' data:`). Die Stylesheets sind Inline-Styles der Buchfassung (`style-src 'unsafe-inline'`, wie bisher bei lesen.html).
- Supabase wird nur wie bei lesen.html gelesen: öffentlicher Storage-Abruf und Versionsangabe mit Publishable Key. An der CSP ändert sich nichts.

## Prüfbelege
```
> pwsh -File scripts/ci-check.ps1                       (Endstand)
OK: 12 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
exit 0

> Gegenprobe: id="kap-avkk-quelle" in source entfernt, ci-check, danach git checkout der Quelle
Anhang: source/fahrt-zum-kunden.html: Anhang-Block in Zeile 2048 ('Woher AVKK kommt: das ZAVKK-Modell') ohne ID an section.appendix oder an der ersten h2

> node --check assets/js/<datei>.js
OK admin.js, app.js, handout-viewer.js, pdf-viewer.js, story-viewer.js, supabase-config.js

> Invoke-Pester -Path tests                             (Pester 3.4.0, pwsh 7.6.9)
Passed: 23 Failed: 0 Skipped: 0   (Tests completed in 233.19s; neu: Anhang-ID mit falschem Muster; entfernt: 2 Tests zur erzeugten Datei)

> build-upload.ps1 -OhneAudio -Suffix r46probe
OK: 36 aktuelle Quelldateien bytegenau im ZIP bestätigt.
ZIP-Einträge mit "anhang": anhang.html          (output/ danach gelöscht)

> git diff --cached --check                             ohne Befund
```
Lokale Vorschau `scripts/vorschau.ps1 -OhneBrowser -Port 8074`: Supabase ist in der Kopie abgeschaltet, also zeigt sie die lokale Buchfassung. Geöffnet mit Edge headless `--dump-dom --virtual-time-budget=10000`. Den `srcdoc` des iframes habe ich mit Python ausgewertet:
```
anhang.html#kap-versionen
  Viewer-Titel: Anhang | Die Fahrt zum Kunden; Titel im srcdoc: Anhang | Die Fahrt zum Kunden
  Auswahl Inhaltsverzeichnis: 7 Optionen (Anfang des Anhangs + kap-handout, kap-sysingboard-architektur,
    kap-reportfamilie-architektur, kap-avkk-quelle, kap-standard, kap-versionen)
  Inhaltsverzeichnis im Anhang: 6 Links #kap-…, 6 section.appendix; Stand: Version 1.38 vom 07.11.2026
  current-section: Abschnitt 6 von 6: Versionshistorie; story-status: Anhang aus der Buchfassung
  script-Tags 0, on*-Attribute 0, javascript: 0; Kapitel der Geschichte (kap-umweg) nicht enthalten
  14 Schrift-URLs absolut auf http://127.0.0.1:<port>/assets/fonts/
anhang.html#kap-avkk-quelle  -> Abschnitt 4 von 6: Woher AVKK kommt: das ZAVKK-Modell
lesen.html#kap-umweg         -> Abschnitt 2 von 31: Der Umweg; Schaltfläche "Anhang" vorhanden
story/current/anhang.html    -> HTTP 404 (entfernt)
```
Gefunden und behoben im ersten Vorschaulauf: Der Stand erschien als „07.11.2026 vom Version 1.38“, weil im Buch das Datum vor der Version steht. Version und Datum werden jetzt einzeln gesucht. Im zweiten Lauf mit Port 8074 ist es richtig.
Screenshots in 1280 und 390 px (Scratchpad r46-anhang-1280.png, r46-anhang-390.png): Gestaltung wie die Lesefassung. Schaltflächen im Kopf brechen nicht mehr um.

## PR
https://github.com/Reling-IT/relingit/pull/26 (Draft). Die Beschreibung ist per `gh pr edit 26` aktualisiert, mit Hinweis „Merge erst nach Release v1.38, Reihenfolge #27, dann #26, dann #25“.

## Abweichungen und offene Punkte
- Der Pester-Lauf startete vor der Korrektur der Reihenfolge von Version und Datum in story-viewer.js. Pester testet kein JavaScript. node --check und die Vorschau liefen auf dem Endstand.
- Mit Supabase-Konfiguration (live) habe ich nicht geprüft, weil die Vorschau Supabase abschaltet. Der Abruf nutzt denselben Pfad wie lesen.html.
- Das Löschen der Vorschau-Kopien über ein Suchmuster im Temp-Ordner hat die Rechteprüfung abgelehnt. Ich habe danach nur meine zwei Kopien mit vollem Namen gelöscht (05:19:06 und 05:20:13). Die fremde Kopie `relingit-vorschau-20261109-044111-e2500e` bleibt stehen.
- Bericht: liegt im Scratchpad, nicht committet.

## Vorschläge und Ideen (Claude)
- Nach dem Merge von #27 die Vorschau wiederholen. Erwartet sind 7 Einträge mit „Die sieben Standards“.
- In der nächsten Buchversion die IDs von kap-handout und kap-standard an die section verschieben und danach die Prüfung verschärfen.
- Rückverweise aus den Geschichten auf `anhang.html#kap-…` (zweiter Teil von q12) sind jetzt möglich.
- Der Anhang lädt die ganze Buchfassung (rund 1,6 MB). Bei Bedarf könnte ein sessionStorage-Cache zwischen lesen.html und anhang.html helfen.
- Die Sichtungsliste in freigabe-pruefen.ps1 um anhang.html in 390, 768 und 1280 px ergänzen. docs/ABLAUF.md beim Scharfschalten nachziehen.

Hygiene: keine gemergten Remote-Branches vorhanden (remote: main, auftrag-R06-standards-box-v139, auftrag-R07-anhang-seite, auftrag-R11-avatare-webseite, ops/*). Offene PRs: #25, #26 und #27, alle Draft. Worktree C:\dev\wt-r07 bleibt stehen (sauber, gepusht). Nichts gemergt, kein Tag, kein FTP, keine Änderung an Workflows, Supabase, Admin-Konten oder Buchtext.

```yaml
Reifegrad: Anhang-Seite als Draft lauffähig, Auslieferung über die vorhandene Buchfassung (ein Upload), Anker in CI geprüft
Projektstatus: R46 umgesetzt in Draft-PR #26; Merge nach Release v1.38 in der Reihenfolge #27, #26, #25 durch Bernd
Offene_Fragen:
  - Sollen kap-handout und kap-standard in v1.39 oder später die ID an der section bekommen?
  - Ist die Ladezeit des Anhangs (ganze Buchfassung) akzeptabel, oder soll ein Cache folgen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
