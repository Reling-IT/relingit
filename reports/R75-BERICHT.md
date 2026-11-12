---
id: R75
titel: Handout-Renderweg ins Repository holen und Handout-PDF neu rendern
status: erledigt (als Commit auf PR #35, kein eigener PR)
start: 2026-11-12T05:25+01:00
ende: 2026-11-12T05:29+01:00
branch: auftrag-R65-korrekturen-v139 (Worktree C:/dev/wt/relingit/r65)
pr: '#35 (Draft)'
commit: c1efb21 (signiert)
---

# R75 – Handout-Renderweg und neues Handout-PDF

Auftrag: `queue/R75.yaml` (ops/queue 879ce72). Der Auftrag lässt die Wahl zwischen dem Branch von R65 und einem eigenen PR. Gewählt ist der Branch von R65: HTML und PDF des Handouts bleiben so ein Paar in einem PR, und es entsteht kein zwölfter offener PR.

## Herkunft des bisherigen PDFs (belegt, nicht geraten)

| Merkmal | Befund | Beleg |
| --- | --- | --- |
| Erzeugt am | 03.09.2026, 07:09 Uhr (MESZ) | Renderstand in der Fußzeile des PDFs; Commit e779825 vom 03.09.2026 |
| Werkzeugkette | Chromium-Druck, danach Metadaten mit pypdf: dieselbe Kette wie bei der Geschichte | `pdfinfo`: Producer pypdf, PDF 1.4, Metadaten Title, Subject, Keywords, Author, Creator im selben Muster wie `geschichte.pdf` |
| Rechner | ein Linux-System, nicht der Rechner des Product Owners | `pdffonts`: Liberation Sans, Liberation Serif, DejaVu Sans Mono, Noto Color Emoji |
| Format | A4 (595,92 × 842,88 pt), 2 Seiten, nicht getaggt | `pdfinfo` |
| Ränder | links 16 mm; Fußzeile links „Der Reling-IT-Transfer · frei erfunden“, Seitenzahl mittig | `pdftotext -bbox`: Fußzeile beginnt bei x = 45,4 pt (16 mm), Seitenzahl bei x ≈ 296 pt, y ≈ 820 pt; gleiche Lage wie in der Fußzeilenvorlage von `render_story_pdf.py` |
| Renderstand | wird in `#render-stamp` der HTML-Datei geschrieben | `workshop-handout.html` Z. 188, Text im PDF |

Nicht belegt ist das ursprüngliche Skript selbst; es liegt nicht im Repository. Die Merkmale oben passen ohne Abweichung zu `render_story_pdf.py` mit anderem Fußzeilentext und anderen Metadaten.

## Änderung

- `scripts/pdf/render_story_pdf.py` (+43 −12): neuer Parameter `--profil geschichte|handout`. Je Profil stehen Standardpfade, Fußzeilentext und Metadaten in einer Tabelle; Ränder, Format und Renderstand sind gemeinsam. Ohne Parameter verhält sich das Skript wie bisher, `verify_layout.py` ruft es unverändert auf.
- Der Anlass in den PDF-Metadaten steht einmal in der Konstante `ANLASS` („Ende November 2026“) und gilt für beide Profile. Damit ist auch die bisherige Zeile 87 (Subject der Geschichte, „September 2026“) angeglichen; wirksam wird das beim Rendern in R60.
- `story/current/workshop-handout.pdf` neu gerendert.
- `docs/PDF-ERZEUGEN.md`: Abschnitt „Handout rendern“.

Renderbefehl (aus dem Repo-Stamm, Python-Umgebung mit playwright und pypdf):

```powershell
python scripts/pdf/render_story_pdf.py --profil handout
pdfinfo output/workshop-handout.pdf
Copy-Item output/workshop-handout.pdf story/current/workshop-handout.pdf
```

## Vorher/Nachher

| Merkmal | vorher (main 8abe213) | nachher (c1efb21) |
| --- | --- | --- |
| Kopfzeile Seite 1 | WORKSHOP-VORBEREITUNGSMATERIAL · SEPTEMBER 2026 | WORKSHOP-VORBEREITUNGSMATERIAL · ENDE NOVEMBER 2026 |
| Subject | Begleitmaterial zu 'Die Fahrt zum Kunden' - Workshop-Vorbereitung September 2026 | Begleitmaterial zu 'Die Fahrt zum Kunden' - Workshop-Vorbereitung Ende November 2026 |
| Title, Keywords, Author, Creator | – | unverändert übernommen |
| Seiten, Format | 2, A4 | 2, A4 |
| Fußzeile | Der Reling-IT-Transfer · frei erfunden, Seitenzahl | gleich |
| Renderstand | 03.09.2026, 07:09 Uhr (MESZ) | 12.11.2026, 05:27 Uhr (MEZ) |
| Schriften | Liberation, DejaVu, Noto Color Emoji | Segoe UI, Georgia, Consolas, Arial, Segoe UI Emoji |
| Größe | 105 494 Byte | 217 069 Byte |
| SHA-256 | `8eb1b90372633917fdc0403df7fe28a9927a30d32cdb4d27f566e2885e5734d6` | `6d574ef8c6e26d295f1a6bfd43a2856ff37c6e4ad1f7ccd5c357f1f7c0001846` |

Sichtvergleich: beide Seiten alt und neu als Bild angesehen (50 dpi; Seite 1 alt und neu, Seite 2 neu). Aufbau, Umbruch und Farben stimmen überein; Seite 1 endet nach dem ersten Kasten, Seite 2 trägt die Übung und die Fußzeile mit Renderstand. Sichtbar anders sind nur die Schriften.

## Prüfungen

| Prüfung | Ergebnis |
| --- | --- |
| Handout-Profil | „OK … Seiten: 2“ |
| Standardprofil zur Kontrolle (Ausgabe nach output/, danach gelöscht) | 77 Seiten, Fußzeile der Geschichte, Subject mit „Ende November 2026“ |
| `scripts/ci-check.ps1` | nur der eine erwartete Fehler von #35 (story/current); keine Meldung zur PDF-Kennung |
| GitHub-CI auf #35 (Lauf 43155041365) | rot mit demselben einen Fehler |
| Pester | die Tests verweisen nicht auf `scripts/pdf` (0 Treffer); letzter Lauf 21/21 auf db2804b, nach R75 nicht wiederholt |
| `git merge-tree` gegen alle zehn anderen PR-Branches | ohne Konflikt |

## Abweichungen und Hinweise

- **Schriften:** Die Handout-HTML bindet keine Schriften ein (`"Work Sans","Segoe UI",Arial` ohne `@font-face`). Das PDF hängt deshalb vom Rechner ab. Die Geschichte hat dafür seit R27 lokale Schriften.
- Das neue PDF ist nicht getaggt, wie das alte und wie `geschichte.pdf`: Das Skript verlangt beim Druck Tags, `pdfinfo` meldet am fertigen PDF trotzdem „Tagged: no“. Das betrifft auch die Geschichte und ist älter als dieser Auftrag; die Ursache ist nicht untersucht (unklar).
- Kein PDF wurde als Release markiert, nichts hochgeladen.
- Die Python-Umgebung mit playwright liegt auf dem Rechner außerhalb des Repositorys; im Standard-Python fehlt playwright. `docs/PDF-ERZEUGEN.md` beschreibt die Einrichtung.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Dem Handout dieselben lokalen Schriften geben wie der Geschichte (`@font-face` wie in R27); dann sieht das PDF auf jedem Rechner gleich aus.
- Die Tag-Frage als eigenen kleinen Auftrag prüfen: Geht die Struktur beim Schreiben der Metadaten verloren, wäre das für die Barrierefreiheit der PDFs ein Befund (Bezug R31).
- ci-check um eine Prüfung ergänzen: Datum in `workshop-handout.html` gegen den Text des Handout-PDFs, damit das Paar nicht wieder auseinanderläuft.
- W26 und I08 in `SICHTUNG-v1.39.md` können jetzt mit Ja enden.

Hygiene: gemergte Remote-Branches 0; offene PRs 11 (#25 bis #28, #30 bis #36), alle Draft.

```yaml
Reifegrad: Handout als Paar reproduzierbar renderbar; HTML und PDF tragen Ende November 2026; Renderweg dokumentiert
Projektstatus: PR 35 enthaelt Text, Handout und Renderweg; wartet auf Einzelfreigabe im Block mit 27 und 33, danach R60
Offene_Fragen:
  - Handout mit lokalen Schriften ausstatten wie die Geschichte?
  - PDFs sind nicht getaggt - eigenen Auftrag anlegen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
