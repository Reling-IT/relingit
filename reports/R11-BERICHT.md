---
id: R11
titel: Avatare von Navis und Lumen auf der Webseite zeigen
status: erledigt (Draft-PR offen, CI grün, nicht gemergt)
datum: 2026-11-09
branch: auftrag-R11-avatare-webseite
pr: https://github.com/Reling-IT/relingit/pull/25
commit: fa4a49f
ci: grün (Website prüfen, Lauf 42557936505)
---

## Ergebnis
Die Bildmarken von Navis und Lumen stehen jetzt an zwei Stellen auf der Startseite: in der Hero-Grafik und im Abschnitt „Worum es geht“, wo die Figuren eingeführt werden. Ancora ist nicht eingebunden. Die Lesefassung zeigt die Marken schon über die Personenliste im Buchtext (R16); ihr Rahmen lesen.html nennt die Figuren nicht. Es gibt keine neuen Abhängigkeiten, Skripte oder externen Quellen.

Voraussetzung geprüft: `git log origin/main` enthält 81849d9 (Merge PR #10) und a35f500 (R16, Bildmarke im Badge). `git ls-tree origin/main` listet assets/img/avatare/{navis,lumen,ancora}.{svg,png} und README.md.

## Fundstellen (origin/main 01defe7)
| Datei | Zeile | Inhalt |
|---|---|---|
| index.html | 44–45 | Hero-Grafik (`aria-hidden="true"`): `.signal.navis` / `.signal.lumen`, Name mit CSS-Punkt |
| index.html | 55 | „Worum es geht“: „… helfen Navis und Lumen bei der Vorbereitung …“ |
| index.html | 162 | Themenkarte „Technik“, Aufzählung (nicht geändert) |
| lesen.html | – | keine Nennung; die Figuren stehen nur im Buchtext im iframe |
| assets/css/styles.css | 251–269 | `.signal`, `.signal::before`, `.navis`, `.lumen` |
| assets/js/*.js | – | keine Nennung |
| story/current/fahrt-zum-kunden.html | 772 ff. | Personenliste mit eingebetteter Bildmarke (R16), nicht angefasst |

## Änderungen
| Datei | Änderung |
|---|---|
| index.html | Hero: `<img src="assets/img/avatare/navis.svg" alt="" width="56" height="56">` (Lumen genauso) vor dem Namen. Absatz Z. 55: `<img class="figure-mark" … width="24" height="24" alt="">` vor „Navis“ und „Lumen“ |
| assets/css/styles.css | `.signal::before` (8-px-Punkt) ersetzt durch `.signal img` (56 px, Ring 3 px in Figurenfarbe); `.signal` zentriert; neu `.figure-mark` (1,4 em, rund, auf Textlinie) |
| scripts/build-upload.ps1 | `$publicFiles` um `assets/img/avatare/navis.svg` und `lumen.svg` ergänzt. vorschau.ps1 liest dieselbe Liste |
| scripts/ci-check.ps1 | unverändert: Es gibt keine Prüfung auf unbekannte Bilddateien, und die neuen Verweise bestehen die Linkprüfung |

Barrierefreiheit: In beiden Fällen `alt=""`. Der Hero-Container ist `aria-hidden`. Im Fließtext steht der Name direkt danach, ein `alt="Navis"` würde doppelt vorgelesen. Die feste Größe per `width`/`height` verhindert einen Layoutsprung. Die R40-Befunde sind nicht berührt. Die CSP (`img-src 'self' data:`) passt ohne Änderung.

## Prüfbelege
```
pwsh ./scripts/ci-check.ps1
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.

node --check assets/js/*.js
admin.js, app.js, handout-viewer.js, pdf-viewer.js, story-viewer.js, supabase-config.js: exit 0

./scripts/build-upload.ps1 -OhneAudio -Suffix r11pruefung   (nur lokal, danach gelöscht)
OK: 37 aktuelle Quelldateien bytegenau im ZIP bestätigt.
ZIP assets/img/*: favicon.png, reling-it-logo.svg, reling-it-podcast-cover.png, avatare/lumen.svg, avatare/navis.svg

./scripts/vorschau.ps1 -NurBauen -> 37 Dateien (4 MP3 übersprungen)
python -m http.server 8143 --bind 127.0.0.1 (in der Kopie)
curl …/assets/img/avatare/navis.svg -> 200 image/svg+xml; lumen.svg -> 200 image/svg+xml

chrome --headless=new --window-size=1280,1500 --screenshot   (hell)
chrome --headless=new --force-dark-mode --blink-settings=preferredColorScheme=0 … (dunkel)
-> beide 198422 Byte, bytegleich: Die Seite hat nur ein dunkles Design, keine prefers-color-scheme-Regel und keinen Theme-Schalter.
Vergleich vorher (origin/main index.html + styles.css in Kopie, Port 8144) und nachher bei 1280 und 390 px angesehen.

PR #25 Checks: Website prüfen pass (9 s)
```
Sichtbefund: Im Hero sitzen die Kompassrose (türkiser Ring) und die Lichtkugel (goldener Ring) an der Stelle der früheren Punkte, die Namen stehen darunter. Im Absatz stehen kleine runde Marken vor den Namen, der Zeilenabstand ändert sich sichtbar nicht. Bei 390 px ist der rechte Rand abgeschnitten, vorher wie nachher. Das liegt an der Mindestbreite des Headless-Fensters und nicht an der Änderung. Screenshots liegen nur lokal im Scratchpad (r11-hell.png, r11-dunkel.png, r11-mobil.png, r11-vorher*.png).

## PR
https://github.com/Reling-IT/relingit/pull/25 (Draft, CI grün, nicht gemergt)

## Abweichungen
- Lesefassung: lesen.html bekommt kein Bild. Der Rahmen führt die Figuren nicht ein, das tut nur der Buchtext, und der ist gesperrt. Dort sind die Marken seit R16 sichtbar. Beide erlaubten Stellen liegen deshalb auf index.html.
- Hell/Dunkel: Ein heller Modus existiert nicht. Die Prüfung belegt nur, dass die erzwungene Farbschemaeinstellung nichts ändert.
- build-upload nimmt nur die zwei genutzten SVG auf, nicht das ganze Verzeichnis. Ancora ist ausgeschlossen, die PNG (je 0,6–0,9 MB) werden nicht genutzt und die README ist keine öffentliche Datei.
- Bericht liegt im Scratchpad, nicht im Repo (wie R43).
- Für die Veröffentlichung müssen index.html, styles.css und die zwei SVG per FTP hoch. Das geschieht erst mit einem Release und gehört nicht zu diesem Auftrag.

## Vorschläge und Ideen (Claude)
- ci-check: Jede Datei unter assets/img/, auf die eine öffentliche HTML-Seite verweist, muss in `$publicFiles` von build-upload.ps1 stehen. So fällt eine vergessene Paketdatei schon in der CI auf. Heute würde nur der Live-Betrieb einen 404 zeigen.
- Kommt ein heller Modus, die Ringfarben `--cyan` und `--gold` auf hellem Grund auf Kontrast prüfen.
- Die Themenkarte „Technik“ (index.html 162) könnte später auch die Marken tragen. Hier blieb sie wegen „höchstens zwei Stellen“ unverändert.
- In der Sichtungsliste aus R43 (W01 ff.) einen Punkt „Bildmarken Navis/Lumen sichtbar, kein Layoutsprung“ ergänzen.

Hygiene: keine gemergten Remote-Branches übrig (Remote: main, ops/queue, ops/reports, auftrag-R11-avatare-webseite). Offen ist nur PR #25 (Draft). Der Worktree C:\dev\wt-r11 bleibt stehen, sauber und gepusht. Testpaket und lokale Server sind entfernt bzw. beendet. Nichts installiert, gemergt oder getaggt, keine Änderung an Workflows, Deployment, Supabase oder Buchtext.

```yaml
Reifegrad: Startseite zeigt die Bildmarken; Lesefassung über den Buchtext (R16); per Headless-Chrome gesichtet, Sichtung durch Bernd offen
Projektstatus: R11 als Draft-PR #25 offen, CI grün, wartet auf Review und Merge durch Bernd; FTP erst mit nächstem Release
Offene_Fragen:
  - Reicht für die Lesefassung die Personenliste im Buchtext, oder soll der Rahmen lesen.html eine eigene Marke bekommen (dann eine dritte Stelle)?
  - Soll ein heller Modus der Website geplant werden?
  - Mit welchem Release gehen index.html, styles.css und die SVG per FTP hoch?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung, übernommen aus R43
```
