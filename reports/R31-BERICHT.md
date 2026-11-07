---
id: R31
titel: Barrierefreiheit, Kontrast und Handy-Darstellung (statische Prüfung)
status: erledigt (Leseauftrag, keine Änderungen)
start: 2026-11-07T06:31+01:00
ende: 2026-11-07T06:50+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: origin/main 44898de
---

# R31 – Barrierefreiheit, Kontrast und Handy-Darstellung

Geprüft: index.html, lesen.html, handout.html, pdf.html, impressum.html, datenschutz.html, source/fahrt-zum-kunden.html (eingebettetes CSS Z. 6–589), assets/css/styles.css, assets/css/legal.css, dazu die Viewer-Skripte (story-viewer.js, handout-viewer.js, app.js) für Fokus, Zoom und Statusmeldungen. Alles gelesen per `git show origin/main:<pfad>`. Arbeitsbaum unverändert.

## Ergebnis

- Die Grundlage ist solide: `lang="de"` überall, viewport-Meta auf allen sechs Seiten, sichtbarer Fokus (`:focus-visible`, 3px), kein `outline:none`, native `<audio controls>`, Formularfelder mit `label for`, iframes haben `title`, SVG-Grafiken haben `role="img"` mit `aria-label`, es gibt `prefers-reduced-motion`.
- **8 Befunde „muss“ (WCAG-AA-Verstoß):** Für die 4 Podcast-Folgen gibt es keine Transkripte (1.2.1). Der Name von Marken-Link und Zoom-Reset passt nicht zur sichtbaren Beschriftung (2.5.3). Der Fokusrahmen und die Feldrahmen im Feedbackformular haben zu wenig Kontrast (1.4.11). Text-Kontrast fällt durch bei `.meta`/footer (3,77:1), `.form-note` (4,2:1) und in der Lesefassung bei `--ink-soft`/`--ink-faint`/`--accent` auf `--surface`/`--surface-2` (2,49–4,46:1).
- Der Hinweis „Textkontrast verbessert“ in v1.37 reicht nicht: Die Kästen (`.disclaimer`, `.intro`, `aside.real`, `.appendix`, `.codebox`) liegen weiter unter 4,5:1.
- Auf dem Handy: Es gibt keine festen Breiten über 360px, die nicht per Medienabfrage aufgehoben werden. Risiken sind die SVG-Schrift in der Lesefassung (am Handy ca. 3–5px), die fehlende Hauptnavigation unter 800px und der doppelte Scrollbereich in der Lese-/Handout-Ansicht. Screenshots waren nicht möglich, weil playwright fehlt.
- PR #10 (Draft, v1.38) übernimmt dieselben Farbtokens und Muster (SVG-Text mit `fill-opacity` .6–.8, Schrift 8,5–9,5) und fügt zwei `h2` hinzu. Damit erbt er die Kontrastbefunde der Lesefassung, bringt aber keine neuen Verstöße.

## Befunde

| Datei:Zeile | Befund | WCAG-Kriterium | Vorschlag | Schweregrad |
|---|---|---|---|---|
| index.html:70–113 | 4 Podcast-Folgen (11–23 min) ohne Transkript oder Textfassung; die Geschichte ist keine 1:1-Textalternative, weil die Folgen KI-erzeugte Gespräche sind | 1.2.1 Nur Audio (A) | Je Folge ein Transkript verlinken (z. B. `assets/audio/<name>.html` oder `<details>` unter dem Player), etwa aus NotebookLM-Export oder Whisper, danach redaktionell prüfen | muss |
| index.html:15–18 | Marken-Link `aria-label="Zur Startseite"` überschreibt den sichtbaren Text „Reling IT / Geschichte“ | 2.5.3 Beschriftung im Namen (A) | `aria-label` entfernen (sichtbarer Text reicht) oder `aria-label="Reling IT / Geschichte – zur Startseite"` | muss |
| lesen.html:28, handout.html:26; story-viewer.js:57, handout-viewer.js:32 | Zoom-Reset zeigt „100 %“ bzw. „120 %“, der Name lautet „Originalgröße wiederherstellen“ | 2.5.3 (A) | `aria-label` entfernen und `title="Originalgröße wiederherstellen"` setzen oder den Namen per JS als „120 % – Originalgröße wiederherstellen“ mitführen | muss |
| styles.css:34–41 mit :482 | Fokusrahmen Gold `#f1b854` auf Papier `#f3efe6` hat 1,56:1, neben weißen Feldern 1,79:1, also im Feedbackformular kaum sichtbar | 1.4.11 Nicht-Text-Kontrast (AA); 2.4.7 | Im Formular eigene Fokusfarbe setzen: `.feedback :focus-visible{outline-color:var(--night)}` (`#123b4e` auf Papier 10,39:1) | muss |
| styles.css:494–496 | Rahmen von Select und Textarea `#aab4b6` gegen Papier 1,85:1, die weiße Feldfläche gegen Papier 1,15:1: Feldgrenzen sind nicht ausreichend erkennbar | 1.4.11 (AA) | Rahmen z. B. `#6b7880` (nachgerechnet 3,96:1 gegen `#f3efe6`) | muss |
| styles.css:186–188, :537 | `.meta` und footer `#8293a2` auf `#123b4e` = 3,77:1 bei 0,85rem | 1.4.3 Kontrast (AA) | Auf `--muted` `#aebbc6` (6,09:1) umstellen | muss |
| styles.css:511 | `.form-note` `#66747c` auf Papier = 4,2:1 (0,8rem); betrifft auch die Statusmeldungen aus app.js:89–131 | 1.4.3 (AA) | `#53636d` (5,42:1) wie im Absatz darüber | muss |
| source/fahrt-zum-kunden.html:14–15, 61–352, 575–587 | `--ink-soft` auf `--surface` 4,29:1; `--ink-faint` auf `--surface` 3,39:1 bzw. auf `--surface-2` 2,49:1; `--accent` auf `--surface` 3,33:1; `.codebox` (`--surface-2`) mit allen Textfarben 2,49–3,52:1; `.tenure` 2,72:1; `.cover-toc-title` 4,46:1 (siehe Kontrasttabelle) | 1.4.3 (AA) | Tokens anheben, z. B. `--ink-soft:#c3cbdc` (5,47:1 auf surface), `--ink-faint:#b0bacd` (4,56:1), `--accent:#a5b6ff` (4,55:1). Diese reichen auf `--surface-2` nicht (4,03 bzw. 3,36:1), deshalb zusätzlich `.codebox` auf `--surface` oder dunkler setzen. `.tenure` ohne `opacity`. Wirkt auch auf das PDF | muss |
| source/fahrt-zum-kunden.html:1–5 | Kein viewport-Meta. Im iframe (srcdoc) ohne Wirkung, aber `story/current/fahrt-zum-kunden.html` lässt sich direkt öffnen und wird am Handy dann in 980px-Desktopbreite verkleinert | 1.4.10 Umbruch (AA), Risiko | `<meta name="viewport" content="width=device-width, initial-scale=1">` ergänzen (vorher prüfen, ob der PDF-Renderer das ignoriert) | sollte |
| source/fahrt-zum-kunden.html: 141 `<text>` in SVG, z. B. :767 | SVG-Schrift 6,5–11 (viewBox 600) wird am Handy mit ca. 0,42 skaliert, also auf ≈ 3–5px. Einige Texte mit `fill-opacity` .4–.5 haben nur 3,54:1 (u. a. „GEKÜNDIGT“, „Workflow“) | 1.4.3 / 1.4.4 (Grenzfall: Text in Grafik, `aria-label` vorhanden) | Wichtige Inhalte der Grafik in `figcaption` oder Fließtext wiederholen; `fill-opacity` ≥ .55; am Handy optional größere Grafikvariante | sollte |
| lesen.html:26, handout.html:24 | `aria-label` auf `<div>` ohne Rolle wird von Screenreadern ignoriert (ARIA 1.2: verboten auf generic) | 4.1.2 / 1.3.1 | `role="group"` ergänzen | sollte |
| styles.css:606–613, :632–637 | Select und Zoom-Buttons im Viewer-Kopf: Rahmen `--line` auf `--panel` = 1,03:1, Fläche gleich dem Kopfhintergrund; das Select ist kaum als Feld zu erkennen | 1.4.11 (Grenzfall: Text bzw. Pfeil identifizieren das Element) | Rahmen in `--muted` (4,55:1) oder Fläche `--night` | sollte |
| index.html:173–183 | Pflichtfelder (Textarea mit `minlength=10`, Zustimmung) sind nicht als Pflicht gekennzeichnet, die Mindestlänge wird nicht genannt | 3.3.2 Beschriftungen/Anweisungen (A), Grenzfall | „(Pflicht, mind. 10 Zeichen)“ in Label oder Hinweis | sollte |
| styles.css:689 | Unter 800px `.site-header nav {display:none}` ohne Ersatz; am Handy fehlt die Navigation zu Podcast und Rückmeldung | kein AA-Verstoß (Inhalt per Scrollen erreichbar); 2.4.5 | Nav umbrechen lassen (`flex-wrap`, kleinere Gaps) statt ausblenden | sollte |
| styles.css:668, :723 | iframe `min-height: calc(100vh - 160px)`; am Handy ist der gestapelte Kopf (Logo, Select, Zoom, Meta) aber ca. 300px hoch → Seite und iframe scrollen beide, zwei Scrollbereiche | 1.4.10 (Bedienbarkeit, kein klarer Verstoß) | `100dvh` und Kopf im Hochformat kompakter (Meta ausblenden oder Zoom in eine Zeile mit dem Select) | sollte |
| alle Seiten | Kein Skip-Link. 2.4.1 ist über Landmarks/Überschriften erfüllt, aber in lesen/handout liegen vor dem iframe 7 Tab-Stopps | 2.4.1 (A) erfüllt; Komfort | „Zum Text springen“ als erstes Element, Ziel `#story-frame` | sollte |
| index.html:79, 90, 101, 112 | 4× gleicher Linktext „Folge herunterladen“; im Kontext (article) zulässig, in Linklisten aber nicht unterscheidbar | 2.4.4 (A) erfüllt; 2.4.9 (AAA) | Unsichtbaren Zusatz `<span class="visually-hidden"> 01: KI als Beifahrer</span>` | kann |
| lesen.html:16–17, handout.html, pdf.html:16–17 | Zwei benachbarte Links zum selben Ziel (Logo und „← Zurück“); Logo-Name „Zurück zur Landingpage“ statt sichtbarem Logo-Text | 2.5.3 Grenzfall, 2.4.4 | Logo-Link `aria-hidden="true" tabindex="-1"` oder zusammenfassen | kann |
| source/fahrt-zum-kunden.html:664–680 | Inhaltsverzeichnis-Links 12,5px, Zeilenhöhe 22,5px, nur durch „·“ getrennt; Tippflächen unter 24px hoch, Abstandsausnahme greift knapp nicht sicher | 2.5.8 Zielgröße min. (AA), Grenzfall | `line-height:2.2` oder Links als Liste mit `padding:4px 2px` | kann |
| source/fahrt-zum-kunden.html:596–800 | Struktur flach: ein h1, 29 h2 (mit PR #10: 31). „Teil 1/2/Anhang“ sind nur `<span class="part-divider">`; kein `<main>`-Landmark | 1.3.1 (erfüllt, keine Sprünge) | `part-divider` als h2 und Kapitel als h3, oder mindestens `<main>` um `.wrap` | kann |
| styles.css:111–115; story-viewer.js:137/198/204, handout-viewer.js:89 | `scrollIntoView({behavior:"smooth"})` und `translateY` bei Hover/Fokus beachten `prefers-reduced-motion` nicht (CSS deckt nur `scroll-behavior` ab) | 2.3.3 (AAA) | `matchMedia('(prefers-reduced-motion: reduce)')` → `behavior:"auto"`; `transform:none` in der Medienabfrage | kann |
| index.html:125–140; styles.css:34–38 | `summary` fehlt in der `:focus-visible`-Liste (nutzt den Browser-Standard, sichtbar, aber uneinheitlich) | 2.4.7 erfüllt | `summary:focus-visible` ergänzen | kann |
| index.html:183 | Native Checkbox ca. 13×13px; die umschließende `<label>` vergrößert die Klickfläche, deshalb kein Verstoß | 2.5.8 erfüllt | `width/height:20px` für bessere Bedienbarkeit am Handy | kann |
| styles.css:86–90, :132–137, :537; index.html:198 | Text-Links 0,85–0,9rem (≈ 22–23px hoch); durch Abstand (Ausnahme 2.5.8) erfüllt | 2.5.8 erfüllt | `padding-block:2px` für ≥ 24px | kann |
| index.html:127 | „Google NotebookLM“ hier ohne `lang="en"` (in Z. 115 mit) | 3.1.2 (Eigennamen ausgenommen) | Einheitlich machen | kann |
| index.html:37 | `<time data-date>` ohne `datetime` | – | `datetime` per app.js setzen | kann |
| datenschutz.html:94–102 | Text spricht von „der Audio-Zusammenfassung“ (Singular), es sind 4 Folgen (inhaltlich, nicht a11y) | – | Plural | kann |

Statisch geprüft und **ohne Befund**: `lang="de"` auf allen 7 Dokumenten; Überschriften ohne Sprünge (index h1 → h2 → h3; Impressum/Datenschutz h1 → h2; Lesefassung h1 → h2); alt-Texte (Podcast-Cover aussagekräftig, Logo im Marken-Link `alt=""` korrekt, 5 Anhang-Bilder in der Lesefassung beschrieben, 15 Avatar-SVGs `aria-hidden`); Formularbeschriftungen (`label for` für kind und message, Checkbox per umschließendem Label, Honeypot `aria-hidden` mit `tabindex="-1"`); kein positives `tabindex`, daher folgt die Fokusreihenfolge dem DOM; kein `outline:none`; Statusmeldungen über `aria-live="polite"` bzw. `role="status"`; iframes mit `title`; keine Linktexte „hier“ oder „mehr“; Audio nativ und damit per Tastatur bedienbar; Details/Summary nativ.

## Kontrast

Berechnet mit `C:\Users\bmarn\AppData\Local\Temp\claude\6631df4e69bbac2f\7afc4643-2502-4b66-a5f5-00a6fef5dcf8\scratchpad\r31\kontrast.py` (WCAG-Formel der relativen Luminanz; Transparenz per Alpha-Mischung auf den Hintergrund). Großer Text (≥ 24px bzw. ≥ 18,66px fett) kommt in den Paaren mit Fehlwert nicht vor, alle betroffenen Texte sind 9,5–15px. Zeilen mit „UI:“ sind Nicht-Text-Kontraste (Soll 3:1).

| Vordergrund | Hintergrund | Verhältnis | Soll | Ergebnis | Fundstelle |
|---|---|---|---|---|---|
| `#edf2f4` | `#123b4e` | 10,56:1 | 4,5:1 | bestanden | styles.css:25 body-Text |
| `#aebbc6` | `#123b4e` | 6,09:1 | 4,5:1 | bestanden | styles.css:6 --muted auf Nachtblau (lede :175, story-copy :290, text-link :134, Nav :87, legal.css:21) |
| `#aebbc6` | `#1b4f66` | 4,55:1 | 4,5:1 | bestanden (knapp) | styles.css:590/602/619 Viewer-Kopf; legal.css:35 .notice |
| `#aebbc6` | `#0f3445` | 6,71:1 | 4,5:1 | bestanden | styles.css:377/402 Audio-Karte Dauer, MP3-Angabe |
| `#aebbc6` | `#173f52` | 5,74:1 | 4,5:1 | bestanden | styles.css:456 FAQ-Antwort |
| `#8293a2` | `#123b4e` | 3,77:1 | 4,5:1 | **nicht bestanden** | styles.css:187 .meta (0,85rem), :537 footer |
| `#93a5b2` | `#123b4e` | 4,69:1 | 4,5:1 | bestanden | styles.css:409 .source-note (0,82rem) |
| `#55d6c2` | `#123b4e` | 6,69:1 | 4,5:1 | bestanden | styles.css:141 .kicker/.section-label, :129 .secondary, legal.css:22 Links |
| `#071710` | `#55d6c2` | 10,35:1 | 4,5:1 | bestanden | styles.css:124 .primary, :387 .episode-number |
| `#edf2f4` | `#1b4f66` | 7,9:1 | 4,5:1 | bestanden | styles.css:612/639 Kapitel-Select, Zoom-Buttons |
| `#edf2f4` | `#0f3445` | 11,65:1 | 4,5:1 | bestanden | styles.css:365 Audio-Titel |
| `#edf2f4` | `#173f52` | 9,95:1 | 4,5:1 | bestanden | styles.css:428 FAQ-summary |
| `#c8f5ef` | `#071b2b` | 14,79:1 | 4,5:1 | bestanden | styles.css:334–335 Podcast-figcaption (Alpha .9 über Bild, ohne Bild gerechnet) |
| `#14202a` | `#f3efe6` | 14,41:1 | 4,5:1 | bestanden | styles.css:482–483 Feedback-Bereich |
| `#53636d` | `#f3efe6` | 5,42:1 | 4,5:1 | bestanden | styles.css:486 Feedback-Absatz |
| `#66747c` | `#f3efe6` | 4,2:1 | 4,5:1 | **nicht bestanden** | styles.css:511 .form-note (0,8rem) |
| `#f1b854` | `#123b4e` | 6,66:1 | 4,5:1 | bestanden | styles.css:472 .themes Nummern |
| `#ffc78d` | `#3a251b` | 9,45:1 | 4,5:1 | bestanden | legal.css:28–29 .placeholder |
| `#f1b854` | `#123b4e` | 6,66:1 | 3,0:1 | bestanden | UI: styles.css:39 Fokusrahmen auf Nachtblau |
| `#f1b854` | `#1b4f66` | 4,97:1 | 3,0:1 | bestanden | UI: styles.css:39 Fokusrahmen im Viewer-Kopf |
| `#f1b854` | `#f3efe6` | 1,56:1 | 3,0:1 | **nicht bestanden** | UI: styles.css:39 Fokusrahmen im Feedbackformular |
| `#f1b854` | `#ffffff` | 1,79:1 | 3,0:1 | **nicht bestanden** | UI: styles.css:39 Fokusrahmen neben weißem Feld |
| `#55d6c2` | `#1b4f66` | 5,0:1 | 3,0:1 | bestanden | UI: styles.css:646 Fokusrahmen Zoom-Buttons |
| `#aab4b6` | `#f3efe6` | 1,85:1 | 3,0:1 | **nicht bestanden** | UI: styles.css:494 Feldrahmen gegen Papier |
| `#ffffff` | `#f3efe6` | 1,15:1 | 3,0:1 | **nicht bestanden** | UI: styles.css:496 Feldfläche weiß gegen Papier |
| `#265066` | `#1b4f66` | 1,03:1 | 3,0:1 | **nicht bestanden** (Grenzfall, s. Befund) | UI: styles.css:609/636 Rahmen Select/Zoom-Buttons |
| `#55d6c2` | `#123b4e` | 6,69:1 | 3,0:1 | bestanden | UI: styles.css:103 Rahmen .secondary |
| `#55d6c2` | `#173f52` | 6,3:1 | 3,0:1 | bestanden | UI: styles.css:445 FAQ-Symbol +/− |
| `#eef2fb` | `#123b4e` | 10,63:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:32 body |
| `#aab4cc` | `#123b4e` | 5,74:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:61 .subtitle, :538 .cover-whatsnew, :527 TOC-Links |
| `#93a0ba` | `#123b4e` | 4,53:1 | 4,5:1 | bestanden (knapp) | fahrt-zum-kunden.html:474 .cover-meta, :513 .part-divider, :523 TOC-Label, :358 footer, :609 Untertitel |
| `#aab4cc` | `#1b4f66` | 4,29:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:67 .disclaimer, :306 aside.real p, :325 .appendix p, :350 .intro p, :182 .name, :284 .defitem p |
| `#93a0ba` | `#1b4f66` | 3,39:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:186 .role, :337 appendix figcaption, :575/585 vtable th/Datum |
| `#7b90a9` (= faint × .8) | `#1b4f66` | 2,72:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:189–191 .tenure (9,5px) |
| `#aab4cc` | `#24647e` | 3,16:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:253 .codebox pre, :175 .badge |
| `#93a0ba` | `#24647e` | 2,49:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:245 .codebox-head, :259 .codebox .c |
| `#4fd1c5` | `#24647e` | 3,52:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:257 .codebox .k, :177 badge navis |
| `#7bc493` | `#24647e` | 3,18:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:258 .codebox .s |
| `#e8b34c` | `#24647e` | 3,43:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:178 badge lumen |
| `#aab4cc` | `#12292a` | 7,35:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:150 .voice.navis .say |
| `#aab4cc` | `#2c2311` | 7,46:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:150 .voice.lumen .say |
| `#4fd1c5` | `#12292a` | 8,18:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:148 .voice.navis .who |
| `#e8b34c` | `#2c2311` | 8,1:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:149 .voice.lumen .who |
| `#8098ff` | `#1a2140` | 5,88:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:44–45 .eyebrow, :211 .drafttasks-head, :226 .n |
| `#aab4cc` | `#1a2140` | 7,57:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:217 .draftitem |
| `#7bc493` | `#16241c` | 7,8:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:214 approved-Kopf, :550–551 .tag |
| `#eef2fb` | `#16241c` | 14,37:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:231 approved .draftitem |
| `#8098ff` | `#123b4e` | 4,46:1 | 4,5:1 | **nicht bestanden** (knapp) | fahrt-zum-kunden.html:494 .cover-toc-title |
| `#8098ff` | `#1b4f66` | 3,33:1 | 4,5:1 | **nicht bestanden** | fahrt-zum-kunden.html:280 .defitem .term, :580 vtable Version, :309 Link |
| `#7bc493` | `#123b4e` | 5,77:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:541 .cover-whatsnew a |
| `#597389` (= faint × .55) | `#123b4e` | 2,41:1 | 4,5:1 | **nicht bestanden** (auf main leer) | fahrt-zum-kunden.html:658 #render-stamp (9,5px) |
| `#898f9c` (ink × .55) | `#0e1728` | 5,52:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:767 u. a., SVG-Text fill-opacity .55 (15×) |
| `#949aa7` (ink × .6) | `#0e1728` | 6,35:1 | 4,5:1 | bestanden | SVG-Text fill-opacity .6 (23×) |
| `#abb0bc` (ink × .7) | `#0e1728` | 8,25:1 | 4,5:1 | bestanden | SVG-Text fill-opacity .7 (27×) |
| `#686f7c` (ink × .4) | `#0e1728` | 3,54:1 | 4,5:1 | **nicht bestanden** | SVG-Text fill-opacity .4/.5 (z. B. „GEKÜNDIGT“) |
| `#4fd1c5` | `#0e1728` | 9,61:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:641 SVG-Text Navis |
| `#e8b34c` | `#0e1728` | 9,37:1 | 4,5:1 | bestanden | fahrt-zum-kunden.html:642 SVG-Text Lumen |

## Handy-Darstellung (statisch)

- **viewport-Meta:** auf allen 6 Seiten vorhanden; in der Lesefassung fehlt es (siehe Befund).
- **Feste Breiten über 360px:** `.hero` `min-height:680px` (Höhe, unkritisch), `.hero-art` `height:520px` (am Handy auf 380px gesetzt), `.route` `height:420px` (in `overflow:hidden`). `.podcast` `minmax(280px,…)` und `.reader-navigation` `minmax(190px,320px)` werden bei 800px bzw. 520px aufgehoben. `.wrap` 700px und `main` 1180px sind nur `max-width`. Keine `min-width` über 360px.
- **Überlauf:** `h1` der Startseite am Handy 64px (`clamp(4rem,20vw,6rem)`). Nach Schätzung der Georgia-Breiten passt „Kunden“ in 264px Inhaltsbreite (bei 320px Viewport); Podcast-`h2` „Perspektiven.“ ≈ 250px von 264px, also knapp. Ohne `overflow-wrap`/`hyphens` ist das ein Risiko bei längeren Überschriften. `.vtable` mit `nowrap` in Spalte 1 und 2 ist unkritisch (kurze Werte).
- **Medienabfragen:** styles.css 800px und 520px, Lesefassung 520px, dazu Druck. legal.css hat keine eigene (nutzt `clamp`).
- **Tippflächen:** `.button` mindestens 50px, Zoom-Buttons 42px, Select 42px, Logo-Link 46px. Unter 24px liegen Text-Links (≈ 22–23px, Abstandsausnahme greift), die Checkbox (über das Label erfüllt) und das Inhaltsverzeichnis der Lesefassung (Grenzfall).
- **Schriftgrößen:** Website 0,72–0,9rem für Meta und Labels. Lesefassung 9,5–12,5px für viele Metatexte; die SVG-Schrift ist am Handy effektiv ≈ 3–5px.
- **Screenshots:** nicht möglich, playwright ist nicht installiert (Vorgabe: nichts installieren). Die Aussagen zur Darstellung sind statisch abgeleitet und nicht visuell bestätigt.

## Offene Fragen, Risiken, Abweichungen

- Transkripte (1.2.1): Gibt es aus NotebookLM einen Textexport, oder muss transkribiert werden? Der Aufwand liegt beim PO, die redaktionelle Prüfung ist nötig.
- Die Kontrastkorrektur der Lesefassung ändert auch das PDF (gleiche CSS-Datei, Druck mit `print-color-adjust:exact`). Die Seitenzahl bleibt vermutlich gleich, das Rendering sollte trotzdem neu geprüft werden. PR #10 und PR #9 (beide Draft, v1.38) bauen auf den alten Tokens auf: Die Korrektur sollte nach deren Merge oder in einem der beiden erfolgen, sonst gibt es Konflikte.
- SVG-Hintergründe: Gerechnet wurde nur gegen `#0e1728` (12 von 26 Grafiken). Die übrigen haben Verläufe, z. B. Cover `#081f29`→`#123b4e`, und sind nicht berechnet.
- Podcast-figcaption: Gerechnet mit deckendem `#071b2b`; tatsächlich Alpha .9 über dem Cover. Bei hellen Bildstellen ist der Wert etwas niedriger, aber weiter deutlich über 4,5:1.
- PDF (`story/current/geschichte.pdf`) und handout.html-Inhalt (`story/current/workshop-handout.html`) wurden nicht geprüft (Tagged PDF, Lesereihenfolge). Das liegt außerhalb des Auftrags.
- admin.html wurde nicht geprüft (nicht im Auftrag), nutzt aber legal.css.
- PR #6 (Avatare, nicht Draft) ändert laut Titel ebenfalls Buch und Seite. Nicht geprüft.
- Abweichung: Ein Bash-Heredoc mit dem Skript scheiterte; das Skript wurde stattdessen mit dem Write-Werkzeug im Scratchpad angelegt. Inhaltlich ohne Folgen.

## Vorschläge und Ideen (Claude)

- **Kontrast-Check in `ci-check`:** kontrast.py aus dem Scratchpad als `tools/check_contrast.py` übernehmen. Paare als Daten (Token × Hintergrund), Abbruch bei < 4,5:1. So kann eine Aussage wie „Kontrast verbessert“ (v1.37) nicht mehr ungeprüft ins Buch gelangen.
- **Ein Token-Satz für Website und Buch:** styles.css (`--muted #aebbc6`) und die Lesefassung (`--ink-soft #aab4cc`) haben fast gleiche, aber verschiedene Werte. Gemeinsame, geprüfte Tokens vermeiden Doppelpflege.
- **Transkripte als Mehrwert:** Transkripte als eigene HTML-Seiten mit Kapitelsprüngen erfüllen 1.2.1, sind durchsuchbar und helfen der Auffindbarkeit (SEO).
- **axe-core per CDN ohne Installation:** Ein einmaliger Lauf über die Browser-Erweiterung (Claude in Chrome) auf der Live-Seite würde die statischen Befunde visuell bestätigen und die Screenshot-Lücke schließen. Das sollte ein eigener Auftrag sein.
- **Handy-Grafiken:** Für die SVG-Szenen eine `@media (max-width:520px)`-Regel, die die Bildunterschrift stärker betont, oder eine Hochformat-Variante. Alternativ den Grafiktext auf 2–3 große Worte begrenzen.

Hygiene: gemergte Remote-Branches außer main: `origin/quelle-pdf-werkzeuge-20261106` (löschbar nach Bestätigung). Offene PRs: #10 (Draft, v1.38 „Die veralteten Daten“), #9 (Draft, R03 Buchtext v1.38), #6 (offen, kein Draft, Avatare). Weitere Remote-Branches: `auftrag-R03-buchtext-v138`, `auftrag-R15-release-pruefungen` (ohne offenen PR, prüfen), `avatare-buch-und-seite-20261106`, `geschichte-veraltete-daten-20261107`, `ops/queue`, `ops/reports`. Lokaler Arbeitsbaum sauber (auf `auftrag-R02-veroeffentlichung`, unverändert).

```yaml
Reifegrad: Beta – solide Grundlage (Landmarks, Labels, Fokus, native Medien), aber 8 AA-Verstöße offen (Transkripte, Label-in-Name, Formular-Kontraste, Kontrast der Buch-Kästen)
Projektstatus: Website live-fähig; Barrierefreiheit nicht AA-konform; v1.38 in zwei Draft-PRs (#9, #10) in Arbeit
Offene_Fragen:
  - Transkripte der 4 Podcast-Folgen: Quelle (NotebookLM-Export oder Transkription) und Freigabe durch den PO?
  - Kontrastkorrektur der Lesefassung vor oder nach Merge von PR #9/#10?
  - Kontrast-Check dauerhaft in ci-check aufnehmen?
  - Visuelle Prüfung (Screenshots/axe) über Browser-Erweiterung als Folgeauftrag?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
