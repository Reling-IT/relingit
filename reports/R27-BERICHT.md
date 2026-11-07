---
id: R27
titel: Schriften des Buchs lokal per @font-face einbinden (reproduzierbare Seitenzahl)
status: erledigt
start: 2026-11-07T06:31+01:00
ende: 2026-11-07T07:08+01:00
branch: geschichte-veraltete-daten-20261107
pr: https://github.com/Reling-IT/relingit/pull/10
commit: 813d0dcbfbc2a4fad3e3ea08cd7be71f475942c5
ci: "lokal ci-check vorher 1 Fehler, nachher 1 Fehler (derselbe, vorbestehend: story/current weicht von source ab); git diff --check sauber; GitHub: keine Checks gemeldet"
---

## Ergebnis
Fraunces (variabel), Work Sans (400, 400 kursiv, 700) und IBM Plex Mono (400, 400 kursiv, 500) liegen jetzt unverändert als woff2 unter `assets/fonts/`, mit OFL-1.1-Text je Familie und `HERKUNFT.txt` (Commit-gepinnte Quellen, SHA-256).
`source/fahrt-zum-kunden.html` bindet sie über sieben `@font-face`-Regeln ein. Jede Regel hat zwei relative Pfade, damit das von `source/`, `story/current/` und der Lesefassung in `lesen.html` aus funktioniert. Es gibt keine externen Server und kein Base64.
`scripts/build-upload.ps1` nimmt `assets/fonts` ins FTP-Paket auf. Ohne diese Änderung fehlen die Schriften auf der Website.
Der Render-Schritt nach docs/PDF-ERZEUGEN.md war nicht ausführbar, weil Playwright fehlt. Ersatzweise habe ich eine Probe mit Edge headless gemacht: Laut `pdffonts` sind nur noch die drei Buchschriften eingebettet, vorher waren es Consolas, Georgia und Segoe UI.
`story/current` habe ich nicht neu erzeugt, das macht R16.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| 1 Branch | Worktree `C:\dev\wt-r26` war aktuell, ff-merge war nicht nötig („Already up to date“), Head vorher 9dfdc54 | neuer Commit 813d0dc, normal gepusht |
| 2 Lizenz Fraunces | SIL OFL 1.1, ohne Reserved Font Name | https://raw.githubusercontent.com/undercasetype/Fraunces/7ccdec31c6028118dce3e47fe864e3744460371d/OFL.txt, abgerufen 2026-11-07T05:49:49Z; GitHub-API `license.spdx_id` = OFL-1.1; SHA-256 bdf4c228…833b |
| 2 Lizenz Work Sans | SIL OFL 1.1, ohne Reserved Font Name | https://raw.githubusercontent.com/weiweihuanghuang/Work-Sans/b35c81086186162164947bd39574683073d9b268/OFL.txt, abgerufen 2026-11-07T05:49:55Z; spdx OFL-1.1; SHA-256 749aca05…a9272 |
| 2 Lizenz IBM Plex Mono | SIL OFL 1.1 mit Reserved Font Name „Plex“. Deshalb ist die Datei nicht verändert und nicht untergesetzt | https://raw.githubusercontent.com/IBM/plex/48e8676114c04f29033b4b53da4ec579f8846297/packages/plex-mono/LICENSE.txt, abgerufen 2026-11-07T05:50:09Z; spdx OFL-1.1; als `IBMPlexMono-OFL.txt` abgelegt, SHA-256 7e6b2818…07da |
| 3 benötigte Schnitte | Aus dem CSS und Markup ermittelt: Fraunces 600 (scene h2), 700 (h1, aside/appendix h2), 400 (SVG „?“). Work Sans 400, kursiv (p.narrative, .defitem-note, em/i), 700 (b). Plex Mono 400, 500 (.voice .who, th, cover-meta b), kursiv (.codebox .c). Fraunces kursiv, Work Sans 500/600 und Plex Mono fett kommen nicht vor | Parser-Auswertung der Tags und Klassen |
| 3 Zeichensatz | Vollständige Dateien statt Google-„latin“-Subset, weil die Quelle → (U+2192, Fließtext und Mono-SVG) und ✓ (U+2713, .draftitem .n in Mono) nutzt. Das latin-Subset enthält beide nicht. cmap-Prüfung: Plex Mono deckt alles ab. Work Sans fehlt nur ✓, das in Mono steht. Fraunces fehlen →, ✓ und U+200B, die in Fraunces-Text nicht vorkommen. Umlaute, ß, „“, – und · sind in allen drei Familien vorhanden | cmap der zugehörigen TTFs aus denselben Commits |
| 3 Dateien + SHA-256 | Fraunces-Variable.woff2 205 500 B e6638ea113d0027354a08f957a4068975c8066395a0d0f7bb7861f6409621be3 · WorkSans-Regular.woff2 71 988 B 495ec293f0e79ad3d77bcfcf4c4adffb2fe8bd993c6c3800e4528850a3634108 · WorkSans-Italic.woff2 66 376 B 21f75b620a355fc62e286ea0570e0a25186da16d1973c2b7e9c0239bf1408169 · WorkSans-Bold.woff2 76 284 B b8426840585ab1093ce262d35aa03291f59719c38605d0b6ecbe2032924917a9 · IBMPlexMono-Regular.woff2 49 248 B ba204497f16b6d334cee9d1e963a831b73e3a56e1d6300a8489d18df7214b350 · IBMPlexMono-Italic.woff2 53 408 B 2024bf2b08027dcd6d09091385756e327744bbe26b782c411381dffc40ffc622 · IBMPlexMono-Medium.woff2 50 400 B 33faf307fa6031fb4062276d7320a6d632de890cbb347576fd80cfa01077bc25 | zusammen 573 204 B; alle mit Signatur `wOF2`; Quellpfade in assets/fonts/HERKUNFT.txt |
| 4 Einbindung | Je Schnitt `src: url("../assets/fonts/X.woff2"), url("../../assets/fonts/X.woff2")`. Der Browser nimmt den ersten Pfad, der lädt. `font-display:block`. Die Familiennamen entsprechen genau den font-family-Angaben der Quelle | Prüfskript: alle 7 Regeln lösen von source/, story/current/ und lesen.html (srcdoc) aus auf existierende wOF2-Dateien auf; keine nicht abgedeckte Familie; keine externen Schriftverweise |
| 4 Größe HTML | Im Git-Index (LF): 1 597 034 B vorher, 1 599 443 B nachher (+2 409 B). Arbeitskopie (CRLF): 1 599 330 B vorher, 1 601 762 B nachher | `git cat-file -s`, `ls -l` |
| 4 Base64 gegen Dateien | Entscheidung: Dateien. Grund 1: Die CSP der Website (.htaccess) hat kein `font-src`, also gilt `default-src 'self'`. data:-Schriften würden in lesen.html blockiert, weil das srcdoc-iframe die CSP der Seite erbt. Grund 2: Base64 hätte rund 764 KB zusätzlich gebracht (Quelle ca. 2,36 MB statt 1,60 MB). Nachteil: Wird die HTML direkt aus Supabase-Storage geöffnet, fehlen die Schriften. Die Website öffnet sie dort aber nie direkt | story-viewer.js: Supabase-Text wird als `srcdoc` gesetzt, die Basis-URL ist lesen.html im Web-Stamm |
| 5 story/current, lesen.html, build-upload | lesen.html und story-viewer.js bleiben unverändert: `../assets/fonts` löst im srcdoc auf `/assets/fonts` auf, egal ob der Text aus Supabase oder lokal kommt. story/current lädt über den zweiten Pfad `../../assets/fonts`. `build-upload.ps1` hatte eine feste Dateiliste ohne assets/fonts; ich habe 11 Einträge ergänzt (7 woff2, 3 OFL, HERKUNFT). Alle 34 Einträge der Liste existieren | Listenprüfung per pwsh |
| 6 PDF-Rendering | **Nicht ausführbar**: `import playwright` schlägt fehl (ModuleNotFoundError), Installation verboten. Ersatzprobe mit dem vorhandenen Edge headless `--print-to-pdf` (Letter, Standardränder, nicht vergleichbar mit dem offiziellen A4-Renderer, nur in der Scratchpad-Ablage): vorher 70 Seiten mit Consolas, Georgia(-Bold), SegoeUI(-Bold/-Italic) und SegoeUISymbol; nachher 72 Seiten mit IBMPlexMono, IBMPlexMono-Medm, IBMPlexMono-Italic, WorkSans-Regular/-Bold/-Italic und Fraunces (als Type 3). Text ist extrahierbar, Umlaute und Anführungszeichen sind korrekt | `pdffonts`, `pdfinfo`, pypdf |
| 7 ci-check / diff-check | Vorher und nachher genau 1 Fehler: „story/current/fahrt-zum-kunden.html weicht von source/fahrt-zum-kunden.html ab“ (vorbestehend). Keine neuen Befunde. `git diff --cached --check` sauber | pwsh -NoProfile -File scripts/ci-check.ps1 |
| 8 Commit/PR | Ein Commit 813d0dc auf Deutsch mit Co-Authored-By, normal gepusht, Kommentar an PR #10, nicht gemergt | gh |

## Offene Fragen, Risiken, Abweichungen
- **FTP-Hinweis:** Beim nächsten Upload muss `assets/fonts/` (11 Dateien) mit auf den Server. `build-upload.ps1` macht das jetzt automatisch. Bis dahin zeigt die Website die alten Ersatzschriften, es geht aber nichts kaputt. Ob Apache `.woff2` mit `font/woff2` ausliefert, habe ich nicht geprüft. Wegen `nosniff` ist das für Schriften unkritisch.
- **Seitenzahl ändert sich:** Mit den echten Schriften wird das Buch anders umbrochen. In der Edge-Probe waren es +2 Seiten, der offizielle A4-Wert ist offen. R16 muss die PDF mit `render_story_pdf.py` neu erzeugen und die Seitenzahl in `app.js` und `index.html` sowie den `page_count` im Admin-Upload anpassen. `verify_layout.py` sollte erneut laufen, weil sich Umbrüche und Luftzonen verschieben können.
- **Wartezeit im Renderer:** `render_story_pdf.py` wartet nach `goto` nur 400 ms. Wegen `font-display:block` und lokaler Dateien reicht das voraussichtlich. Robuster wäre `page.evaluate("document.fonts.ready")` vor `page.pdf`. Das Skript liegt auf main, ich habe es nicht geändert.
- **Fraunces als Type 3:** Chromium/Skia bettet Instanzen variabler Fonts als Type-3-Schrift ein. Text und Suche funktionieren. Für PDF/A oder Barrierefreiheitsprüfungen kann Type 3 ein Hinweispunkt sein. Alternative wären statische Fraunces-Schnitte (z. B. 72pt SemiBold und Bold), die aber nicht exakt der automatischen opsz-Anpassung entsprechen.
- **Abweichung von Google Fonts:** Die Dateien stammen aus den Projekt-Repos, nicht von Google Fonts. Fraunces 1.003 und Plex Mono 2.005 können sich in Details von den früher über Google geladenen Fassungen unterscheiden. Für die Reproduzierbarkeit ist entscheidend, dass jetzt überall dieselbe Datei verwendet wird.
- **Doppelter Pfad:** Von `story/current/` aus erzeugt der erste Pfad je Schnitt eine 404-Anfrage (`/story/assets/fonts/…`), bevor der zweite greift. Das kostet ein wenig Zeit, die Funktion ist nicht betroffen.
- **Supabase direkt:** Wird die HTML-Datei direkt über die Storage-URL geöffnet, fehlen die Schriften, und es greifen die alten Ersatzschriften. Die Website nutzt diesen Weg nicht.
- Ergänzend habe ich `.gitattributes` geändert (`*.woff2 binary`, Lizenztexte `-text -whitespace`), damit Hashes und der Original-Lizenztext bytegenau bleiben. Das ist keine Workflow- oder Deployment-Datei.

## Vorschläge und Ideen (Claude)
- ci-check könnte `url(...)` in `@font-face` der Buchquelle prüfen: Mindestens ein Pfad je Regel muss existieren, die Datei muss mit `wOF2` beginnen, und die SHA-256 müssen zu `HERKUNFT.txt` passen. So fällt ein vergessener oder veränderter Schriftsatz sofort auf.
- In `render_story_pdf.py` `document.fonts.ready` abwarten und nach dem Rendern per `pdffonts` prüfen, dass keine Systemschrift (Georgia, Segoe, Consolas, Arial) eingebettet ist. Das wäre ein harter Reproduzierbarkeits-Check.
- Optional `font-src 'self'` explizit in die CSP der .htaccess aufnehmen, als Dokumentation. Das ist eine Deployment-Änderung und braucht Freigabe durch den Owner.
- Langfristig könnte das Deckblatt neben dem Renderstand auch einen Hinweis auf den Schriftstand tragen (z. B. Hash-Kurzform von HERKUNFT.txt). Dann lässt sich eine PDF eindeutig einer Schriftversion zuordnen.

Hygiene: Downloads lagen in einem eigenen Scratchpad-Ordner (dl-fonts), Skripte in einem getrennten Ordner (tools), Python lief mit `-I`. Die Probe-PDFs liegen nur im Scratchpad (pdfprobe), keine PDF im Commit. Nichts installiert, keine Zugangsdaten, kein main, kein Merge, kein Tag, kein FTP. story/current ist unverändert, Arbeitsbaum sauber und gepusht.

```yaml
Reifegrad: "Schriften lokal und reproduzierbar eingebunden; PDF und Seitenzahl noch nicht neu gerendert (R16)"
Projektstatus: "PR #10 offen; ci-check lokal 1 vorbestehender Fehler (story/current ≠ source)"
Offene_Fragen:
  - "Neue offizielle Seitenzahl nach A4-Rendering mit echten Schriften (R16)"
  - "FTP-Upload inkl. assets/fonts beim nächsten Release"
  - "Fraunces als Type 3 im PDF akzeptabel oder statische Schnitte?"
  - "document.fonts.ready im Renderer ergänzen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
