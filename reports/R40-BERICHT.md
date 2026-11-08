---
id: R40
titel: 'Barrierefreiheit der Webseite: Muss-Befunde aus R31 (ohne Podcast-Transkripte und ohne Buchquelle)'
status: erledigt (PR offen, nicht gemergt)
start: 2026-11-08
ende: 2026-11-08
branch: auftrag-r40-barrierefreiheit
pr: https://github.com/Reling-IT/relingit/pull/19
commit: 5d58909
ci: bestanden (Website prüfen, https://github.com/Reling-IT/relingit/actions/runs/42446493197)
---

# R40 – Barrierefreiheit der Webseite (Muss-Befunde aus R31)

## Ziel

Die sieben Muss-Befunde der Webseite aus reports/R31-BERICHT.md sind behoben und mit Kontrastwerten belegt. Nicht enthalten sind die Podcast-Transkripte (R42) und der Kontrast der Buchquelle (R41). Geändert wurden nur index.html, lesen.html, handout.html, assets/css/styles.css, assets/js/story-viewer.js und assets/js/handout-viewer.js (6 Dateien, +15/−9 Zeilen). Die MB/MiB-Angaben in index.html (R36) wurden nicht berührt.

## Änderungen

| Fundstelle | alt | neu | Kontrast alt → neu (Soll) |
|---|---|---|---|
| index.html:15 Marken-Link (2.5.3) | `aria-label="Zur Startseite"` | `aria-label="Reling IT / Geschichte – zur Startseite"` | – (sichtbarer Text steht im Namen) |
| lesen.html:28, handout.html:26 Zoom-Reset (2.5.3) | `aria-label="Originalgröße wiederherstellen"` | `aria-label="100 % – Originalgröße wiederherstellen"` | – |
| story-viewer.js:57, handout-viewer.js:32 (2.5.3) | aktualisiert nur `textContent` | `aria-label` wird mit dem Prozentwert mitgeführt („120 % – Originalgröße wiederherstellen“) | – |
| styles.css:502 Fokusrahmen Feedbackformular (1.4.11) | `#f1b854` (Gold, globale Regel) | `.feedback :focus-visible { outline-color: var(--night); }` = `#123b4e` | gegen Papier 1,56 → 10,39:1; gegen Weiß 1,79 → 11,92:1 (3:1) |
| styles.css:494 Rahmen Select/Textarea (1.4.11) | `#aab4b6` | `#6b7880` | gegen Papier 1,85 → 3,96:1; gegen Weiß 2,12 → 4,54:1 (3:1) |
| styles.css:187 `.meta` (1.4.3) | `#8293a2` | `var(--muted)` = `#aebbc6` | auf `#123b4e` 3,77 → 6,09:1 (4,5:1) |
| styles.css:539 footer (1.4.3) | `#8293a2` | `var(--muted)` = `#aebbc6` | auf `#123b4e` 3,77 → 6,09:1 (4,5:1) |
| styles.css:513 `.form-note` (1.4.3, auch Statusmeldungen aus app.js) | `#66747c` | `#53636d` | auf `#f3efe6` 4,20 → 5,42:1 (4,5:1) |

## Kontrastskript

Datei: `C:\Users\bmarn\AppData\Local\Temp\claude\6631df4e69bbac2f\aa0f098d-a69a-4a60-a5a5-ca27c838f603\scratchpad\r40\kontrast.py` (Scratchpad, nicht committet), Aufruf `python -I kontrast.py`. Formel nach WCAG 2.x: sRGB linearisieren, relative Luminanz L = 0,2126 R + 0,7152 G + 0,0722 B, Verhältnis (L1 + 0,05) / (L2 + 0,05).

```python
def lum(h):
    h = h.lstrip('#'); c = [int(h[i:i+2], 16) / 255 for i in (0, 2, 4)]
    c = [x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]
def ratio(a, b):
    la, lb = sorted((lum(a), lum(b)), reverse=True); return (la + 0.05) / (lb + 0.05)
# Paare: (Name, alt, neu, Hintergrund, Soll) – siehe Ausgabe
```

Ausgabe:

```text
Fokusrahmen Formular: alt #f1b854 1.56:1 | neu #123b4e 10.39:1 | bg #f3efe6 | Soll 3.0 | ok
Fokusrahmen neben weißem Feld: alt #f1b854 1.79:1 | neu #123b4e 11.92:1 | bg #ffffff | Soll 3.0 | ok
Rahmen Select/Textarea vs. Papier: alt #aab4b6 1.85:1 | neu #6b7880 3.96:1 | bg #f3efe6 | Soll 3.0 | ok
Rahmen Select/Textarea vs. Feld weiß: alt #aab4b6 2.12:1 | neu #6b7880 4.54:1 | bg #ffffff | Soll 3.0 | ok
.meta auf Nachtblau: alt #8293a2 3.77:1 | neu #aebbc6 6.09:1 | bg #123b4e | Soll 4.5 | ok
footer auf Nachtblau: alt #8293a2 3.77:1 | neu #aebbc6 6.09:1 | bg #123b4e | Soll 4.5 | ok
.form-note auf Papier: alt #66747c 4.20:1 | neu #53636d 5.42:1 | bg #f3efe6 | Soll 4.5 | ok
```

Die alten Werte stimmen mit R31 überein (3,77 / 4,2 / 1,85 / 1,56 / 1,79). Damit ist die Rechnung gegengeprüft.

## Prüfungen

| Prüfung | Ergebnis | Beleg |
|---|---|---|
| `pwsh -File scripts/ci-check.ps1` | bestanden | `OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.` (Hinweis: 5 Podcast-Dateien liegen lokal nicht vor, das ist erwartet) |
| `node --check` story-viewer.js, handout-viewer.js | ohne Fehler | Node aus C:\Program Files\nodejs |
| `git diff --check` | ohne Befund | – |
| Screenshots index.html vorher/nachher, 1280 und 390 px | Layout unverändert: Seitenhöhe vorher und nachher gleich, 5392 px (Desktop) bzw. 7792 px (Handy). Im Formular-Ausschnitt ist der Fokusrahmen am Select jetzt dunkel statt gold und deutlich sichtbar, die Feldrahmen sind etwas dunkler. | Playwright aus C:\dev\sysingdashboard\node_modules (bereits vorhanden, nichts installiert); Bilder `...\scratchpad\r40\vorher-*.png`, `nachher-*.png`, nicht committet |
| Berechnete Stile im Browser | Fokus Textarea `rgb(18, 59, 78) solid 3px`; Rahmen `rgb(107, 120, 128)`; .meta/footer `rgb(174, 187, 198)`; .form-note `rgb(83, 99, 109)`; Name des Marken-Links „Reling IT / Geschichte – zur Startseite“ | `...\scratchpad\r40\probe.js` |
| CI PR #19 | bestanden (Job „Website prüfen“, 10 s) | Lauf 42446493197, PR-Kommentar #issuecomment-6717194765 |

## CI und PR

- PR: https://github.com/Reling-IT/relingit/pull/19 (kein Draft, offen, nicht gemergt)
- CI: Website prüfen – pass. Das Ergebnis steht als Kommentar im PR.

## FTP-Hinweis

Nach dem Merge gehen die geänderten Dateien (index.html, lesen.html, handout.html, assets/css/styles.css, assets/js/story-viewer.js, assets/js/handout-viewer.js) **per FTP** auf den Server, nicht über den Admin-Bereich (der veröffentlicht nur Buchversionen). In diesem Auftrag wurde kein FTP ausgeführt.

## Offene Fragen, Risiken, Abweichungen

- Der Zoom-Reset in lesen.html/handout.html ist nur statisch und im Code geprüft. Über file:// lädt der Viewer den Inhalt nicht per fetch, deshalb gibt es keinen Laufzeittest des mitgeführten aria-label. Die Änderung umfasst drei Zeilen je Datei, `node --check` ist grün.
- Entscheidung: Für den Zoom-Reset wurde ein aria-label mit vorangestelltem Prozentwert gewählt statt nur `title`. So bleibt die Funktion „Originalgröße wiederherstellen“ für Screenreader erhalten.
- Der neue Fokusrahmen gilt für alle fokussierbaren Elemente in `.feedback`, also auch für Checkbox und Senden-Button. Auf Papier ist das gewollt.
- Abweichung: C:\dev\venv-pdf existiert nicht. Playwright stammt aus einem anderen lokalen Projekt (sysingdashboard). Nichts installiert.
- Abweichung: Ein erster Versuch, den Bericht per Bash-Heredoc zu erzeugen, hat Backtick-Befehle aus dem Text ausgeführt (u. a. ci-check, nur lesend). Der Lauf wurde abgebrochen, beide Arbeitsbäume sind sauber geprüft (`git status`). Der Bericht wurde danach mit dem Write-Werkzeug erstellt.
- Der Platzhaltertext der Textarea (Browser-Standardfarbe) gehört nicht zu den R31-Befunden und wurde nicht geändert.
- Der Bericht enthält keine Schlüsselmuster aus ci.yml/ci-check.ps1.

## Vorschläge und Ideen (Claude)

- Kontrastskript als `tools/check_contrast.py` mit Paarliste (Token × Hintergrund) in ci-check aufnehmen; Abbruch unter 4,5:1 bzw. 3:1.
- Feste Farbwerte im Feedbackbereich (`#53636d`, `#6b7880`) als Tokens `--paper-muted` und `--paper-line` in `:root` führen.
- Sollte-Befunde aus R31 in einem kleinen Folgeauftrag bündeln: `role="group"` an `.zoom-controls`, Rahmen von Select und Zoom-Buttons im Viewer-Kopf, Pflichtfeld-Hinweis, Navigation am Handy umbrechen statt ausblenden.
- Das Screenshot-Skript (shot.js) als Werkzeug in scripts/ ablegen, sobald eine feste Playwright-Umgebung vereinbart ist.

Hygiene: origin/quelle-pdf-werkzeuge-20261106 ist in main gemergt und kann gelöscht werden; offene PRs #6, #9 (Draft), #10 (Draft), #17, #18, #19; Worktree C:\dev\wt-r40 bleibt bestehen (Branch gepusht, Arbeitsstand sauber); nichts gemergt, kein Tag, kein FTP, keine Änderung an Workflows.

```yaml
Reifegrad: Muss-Befunde der Webseite (ohne Transkripte) behoben, CI grün, Review ausstehend
Projektstatus: R40 als PR #19 offen; danach FTP-Upload der sechs Dateien durch den Owner
Offene_Fragen:
  - Zoom-Reset-Namen nach dem Upload einmal live mit Screenreader oder axe prüfen?
  - Kontrastprüfung dauerhaft in ci-check aufnehmen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
