---
id: R06
titel: 'Anhang-Box „Die sieben Standards“ und Klarstellung ADR gegen ADG (v1.39)'
status: erledigt (Draft-PR offen, CI grün, nicht gemergt)
datum: 2026-11-09
branch: auftrag-R06-standards-box-v139
pr: https://github.com/Reling-IT/relingit/pull/27 (Draft)
commit: 8fabbf2 (davor 756c499)
ci: 'grün (Website prüfen, Lauf 42559536073)'
pdf: 'neu erzeugt, 80 Seiten; verify_layout nur teilweise (numpy/pillow fehlen)'
---

# R06 Bericht: Die sieben Standards und ADR/ADG in v1.39

## Ergebnis

- Draft-PR #27 hebt das Buch auf **Version 1.39 vom 09.11.2026**. Neu sind die Anhang-Box `#kap-sieben-standards` „Die sieben Standards hinter Navis und Lumen“ und ein Rückverweis aus „Functional is not Done“. Dazu kommt eine **Fußnote** zu ADR und ADG im TDF/ADR-Wissensblock. Keine neue Szene, keine neue Figur, der Erzähltext ist unverändert.
- PDF neu gerendert (**80 Seiten**, vorher 77). `story/current`, `app.js`, `lesen.html` und `index.html` hat `publish-release.ps1 -OhneAudio` erzeugt. Das ist der Ablauf aus `docs/NEUE-GESCHICHTE.md`, Schritt 2 bis 4, und so hat es auch R16 gemacht. Installiert habe ich nichts.
- `ci-check` lokal und in GitHub grün, Pester 21/21.
- `verify_layout.py` läuft nicht vollständig: Ihm fehlen numpy und pillow, Exit 2. Die textbasierten Prüfungen (Struktur, Überschriften-Reihenfolge, Kapitel-Links) habe ich ohne numpy aufgerufen, Ergebnis OK. Das Layout habe ich zusätzlich von Hand an PNGs geprüft.
- Nicht gemergt, kein Tag, kein Release, kein Upload. Das FTP-Paket liegt nur lokal unter `output/ftp` (gitignored).

## ADR-Fundstellen (`source/fahrt-zum-kunden.html`, Stand origin/main 01defe7)

In den base64-Bildern (Zeilen 2019 und 2043) kommt die Zeichenfolge „ADR“ nur zufällig vor. Das sind keine Fundstellen.

| Zeile | Kontext | Bedeutung | Änderung |
|---|---|---|---|
| 1748 | Begriff „ADR – Architecture Decision Record (früher ADF)“ im Wissensblock „Rahmen und Dokumenttyp …“ | Dokumenttyp | Fußnotenzeichen 1 |
| 1749 (2×) | „… wird ein ADR nach Verabschiedung nicht mehr verändert …“, „Ein ADR beantwortet …“ | Dokumenttyp | keine |
| 1772 | Randnotiz „… im selben Repository wie TDF und ADR …“ | Dokumenttyp | keine |
| 2249 (3×) | Versionshistorie: Umbenennung ADF → ADR, „ADR-Konzept“, „ADR ist einer von mehreren Dokumenttypen“ | Dokumenttyp (Historie) | keine |
| 2272, 2277 | Versionshistorie: „TDF/ADR-Wissensblock“ | Name des Blocks | keine |

Das bestätigt R04: Im Buch meint ADR nirgends den Standard ADG.

## Box-Text

Überschrift: **Die sieben Standards hinter Navis und Lumen**

> Diese Standards regeln, wie die KI-Seite des Systemhauses gebaut wird, nicht den Betrieb bei den Kunden. Je ein kurzer Eintrag sagt, wofür ein Standard steht und wo er bisher angewendet wird (Stand der Repositorys: 06.11.2026).
>
> - **ADG – AI Development Governance:** Wer bei der Entwicklung von Navis und Lumen was entscheiden darf, Mensch oder KI, regelt die AI Development Governance. Bisher wird sie im Projekt eher als Haltung gelebt als als festes Prüftor.
> - **AQGS – Application Quality Gate Standard:** Ob eine Funktion fertig ist, misst der Application Quality Gate Standard. Das Sysingboard war seine erste Referenzumsetzung, alle Report-Apps führen ein eigenes Profil, ohne damit schon ein ‚bestanden‘ zu behaupten.
> - **TDF – Technical Documentation Framework:** Das Technical Documentation Framework gibt Dokumenten und Nachweisen ihre Ordnung, im Sysingboard etwa im Artefakt- und Nachweisregister.
> - **SEC – Security Standard:** Der Sicherheitsstandard liefert die Basisanforderungen. In den Apps hinter Navis und Lumen ist er bisher noch nicht ausdrücklich verankert.
> - **DSG – DSGVO-Compliance:** Die DSGVO-Anforderungen liegen als eigener Standard vor. Ein ausdrücklicher Bezug in den Apps fehlt noch.
> - **AI – AI-Act-Compliance:** Was die EU-KI-Verordnung von Navis und Lumen verlangt, ist als Standard beschrieben. Angewendet wird er bisher nur in den Bibliotheken, als Leitlinie.
> - **LIB – Bibliothek:** Wie eine Bibliothek Wissen prüft und freigibt, legt der Bibliothek-Standard fest. Ennos TDF-Bibliothek ist danach abgeglichen, die HI-Bibliothek führt einen eigenen Abgleich und steht damit noch am Anfang; keiner der beiden Abgleiche behauptet, dass der Standard erfüllt ist.
>
> *Bei SEC, DSG und AI beschreibt die Box eine Lücke, keine Erfüllung. Den Prüf-Standard „Functional is not Done“ erklärt der vorige Anhang.*

Quelle: R04, Abschnitt „Vorschlag: je ein Satz für die Anhang-Box“. Belege je Standard: R04, Tabelle 2.

## Vorher-Nachher

| Stelle | Vorher | Nachher |
|---|---|---|
| Deckblatt | 07.11.2026 · Version 1.38 | 09.11.2026 · Version 1.39 |
| Cover-Hinweis | „Neu in v1.38 Neue Geschichte ‚Die veralteten Daten‘ …“ | „Neu in v1.39 Neue Anhang-Box ‚Die sieben Standards‘ mit je einem Satz pro Standard und eine Fußnote zu ADR und ADG im Architektur-Exkurs – siehe Versionshistorie am Ende.“ |
| Inhaltsverzeichnis, Anhang | … · Der Prüf-Standard · Versionshistorie | … · Der Prüf-Standard · Die sieben Standards · Versionshistorie |
| ADR-Begriff (Z. 1748) | ohne Zeichen | mit Fußnotenzeichen 1 (Link auf `#fn-adr`) |
| Fußnote (neu) | – | „¹ Hier ist ADR der Dokumenttyp Architecture Decision Record. Davon zu unterscheiden ist der Standard ADG (AI Development Governance): ADR ist dessen früherer Kurzname und gilt als Alias noch bis 30.06.2027. ↑“ |
| Ende „Functional is not Done“ (neu) | – | „Neben diesem Prüf-Standard gibt es sieben Standards, nach denen die KI-Seite des Systemhauses gebaut wird. Wofür jeder steht und wo er schon angewendet wird, auch in den beiden Bibliotheken (TDF-Bibliothek und HI-Bibliothek), zeigt die Anhang-Box Die sieben Standards.“ |
| Versionshistorie | letzte Zeile 1.38 | neue Zeile 1.39, 09.11.2026 |
| CSS | – | neu: `a.inref` (Akzentfarbe für Verweis-Links), `.fnref`, `.fn` |
| Rückfallwerte | 1.38 / 7. November 2026 / 77 | 1.39 / 9. November 2026 / 80 |
| Personenliste | – | unverändert (keine neue Figur; Enno ist schon enthalten) |

## Prüfbelege

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| Ersetzungen | `python -I r06edit.py source/fahrt-zum-kunden.html` | `OK 8 Ersetzungen` (jede genau ein Treffer, CRLF erhalten) |
| IDs/Anker | Python-Abgleich `id=` gegen `href="#…"` | `IDs 49 doppelt [] Anker 34 fehlend []` |
| Rendern | `C:\dev\venv-pdf\Scripts\python.exe scripts/pdf/render_story_pdf.py --source source/fahrt-zum-kunden.html --out source/Die-Fahrt-zum-Kunden.pdf` | `Seiten: 80 \| Renderstand: 09.11.2026, 04:57 Uhr (MEZ)` |
| Vergleichswert | derselbe Renderer, Quelle von origin/main | 77 Seiten, gleich der veröffentlichten v1.38 |
| verify_layout | `…python.exe scripts/pdf/verify_layout.py --pdf source/Die-Fahrt-zum-Kunden.pdf --no-render` | `ABBRUCH: Python-Paket fehlt (numpy)`, Exit 2 |
| Teilprüfung | `check_structure` und `check_headings_and_links` aus `verify_layout.py`, ohne numpy aufgerufen (Skript im Scratchpad) | `OK`. Gegenprobe mit alter PDF: `UEBERSCHRIFT FEHLT … Die sieben Standards …`, Exit 1 |
| publish-release | `pwsh -NoProfile -File scripts/publish-release.ps1 -OhneAudio` | `OK: PDF-Deckblatt trägt Version 1.39 wie die HTML-Quelle.` … `OK: Version 1.39 vom 9. November 2026 mit 80 Seiten veröffentlicht und paketiert.` Exit 0 |
| ci-check | `pwsh -NoProfile -File scripts/ci-check.ps1` | `OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.` Exit 0 |
| story/current | `cmp` HTML und PDF | identisch |
| JavaScript | `node --check assets/js/*.js` | 6 Dateien ok |
| Pester | `Invoke-Pester -Path tests -PassThru -Quiet` | `Passed: 21 Failed: 0 Total: 21` (Pester 3.4.0) |
| Whitespace | `git diff --check` | ohne Befund |
| Konflikte | `git merge-tree --write-tree HEAD` gegen #25 und #26 | keine |
| GitHub-CI | `gh pr checks 27 --watch` | `Website prüfen pass 19s` (Lauf 42559536073) |

**Layout (Sichtprüfung per pdftoppm):**
- S. 2: Cover-Hinweis und Inhaltsverzeichnis in Ordnung.
- S. 43: Fußnote klein unter dem Wissensblock.
- S. 62: Rückverweis.
- S. 63–64: neue Box, S. 64 zu etwa zwei Dritteln gefüllt.
- S. 79: Zeile 1.39 vollständig.
- S. 80: nur der Schlussvermerk. `verify_layout` nimmt die letzte Seite von der Fast-leer-Prüfung aus.

Der erste Lauf ergab 81 Seiten mit einer fast leeren S. 63. Ursache war der innere Kasten in `box-shell` (break-inside:avoid). Ich habe ihn auf `box-shell-flow` umgestellt, die vorhandene Ausnahme für lange Blöcke. Die Fußnote hat eine höhere CSS-Spezifität bekommen, weil `aside.real p` sonst die Schriftgröße überschreibt.

## Abweichungen und Auslegungen

1. **k6, Widerspruch im Auftrag:** Der Auftrag sagt „Im Text ADG nennen“, die jüngere Entscheidung von Bernd „ADR bleibt im Text, Fußnote, nicht pauschal ersetzen“. Ich bin der Entscheidung gefolgt: Keine ADR-Stelle ist ersetzt. ADG erscheint in der Fußnote und in der neuen Box. Im PR als offene Frage vermerkt.
2. **Wortlaut der Fußnote:** Die Vorgabe „ADR ist der frühere Name des Standards ADG“ steht drin, aber abgegrenzt („Hier ist ADR der Dokumenttyp … Davon zu unterscheiden ist der Standard ADG …“). An der Fundstelle ist laut R04 nämlich der Dokumenttyp gemeint, nicht der Standard. Die Fußnote steht an der einzigen Stelle, an der ADR definiert wird, also im TDF/ADR-Wissensblock.
3. **LIB-Satz gegenüber R04:** „für Horsts geplante KI“ ist gestrichen, weil R04 dafür keinen Repo-Beleg nennt. „dagegen“ ist zu „danach“ geworden. Ergänzt ist „keiner der beiden Abgleiche behauptet, dass der Standard erfüllt ist“, belegt durch R04 (`report.json` „claim: none“).
4. **Lücken offen genannt:** Die Box nennt die Lücken bei SEC, DSG und AI offen, wie in R04 vorgeschlagen. Ich verstehe „i19 Ja“ als Zustimmung zu dieser Form.
5. **Ort der Box:** direkt nach „Functional is not Done“, vor der Versionshistorie. Die ID sitzt an `section.appendix` (zweiter Commit), passend zum Muster von `kap-versionen` und zur ID-Regel aus R07.
6. **Zeile in der Versionshistorie gekürzt:** Sonst wäre auf S. 80 ein Zeilenrest allein stehen geblieben.
7. **FTP-Hinweis aus publish-release** (1. Lauf gegen ba5a23c): Gemeldet werden Änderungen an `handout-viewer.js`, `story-viewer.js`, `styles.css`, `handout.html` und am Podcast-Cover. Sie stammen aus früheren PRs auf main. Von R06 sind nur die Rückfallwerte. Im 2. Lauf (Vergleich gegen 756c499) lautete die Meldung „FTP-Upload nötig: nein“.

## Offene Punkte

- `verify_layout.py` vollständig (Pixelprüfung 1 bis 5) braucht numpy und pillow in `C:\dev\venv-pdf`. Installation nur nach Rückfrage.
- **Zusammenspiel mit Draft #26 (R07):** Es gibt keinen Git-Konflikt. Nach dem zweiten Merge muss aber `story/current/anhang.html` neu erzeugt werden, sonst wird der ci-check von #26 rot.
- Podcast entfällt, weil der Erzähltext unverändert ist (NEUE-GESCHICHTE.md, Schritt 6).
- Die Veröffentlichung über `admin.html` bleibt bei Bernd: 1.39, 9. November 2026, 80 Seiten, kein Handout.

## Vorschläge und Ideen (Claude)

1. **Fußnoten-Baustein in die Kapitel-Vorlage aufnehmen:** `.fnref`/`.fn` mit Rücksprung. Damit lassen sich künftige Klarstellungen machen, ohne den Fließtext umzuschreiben.
2. **`a.inref` auch für die zwei Links der Box „Datenstand“:** Das behebt den Kontrastbefund aus R16 mit zwei Attributen.
3. **k7 bald einplanen:** „Functional is not Done“ nennt AEAS einen „eigenen TDF-Standard“. Direkt danach führt die neue Box TDF als einen der sieben Standards, und der Widerspruch fällt jetzt stärker auf.
4. **Lumen-Halbsatz aus R04 (Idee 2) als kleine Ergänzung der Box anbieten.** Er war nicht beauftragt.
5. **numpy und pillow in die venv aufnehmen.** Danach ist der lokale PDF-Ablauf vollständig, und R16 und R06 müssen nicht mehr auf Sichtprüfung ausweichen.
6. **Teilprüfung als Schalter in `verify_layout.py`:** Die textbasierten Prüfungen laufen auch ohne numpy, ein Schalter wie `--nur-text` würde sie offiziell anbieten. Das wäre ein eigener kleiner Auftrag.

Hygiene: `git branch -r --merged origin/main` meldet keine gemergten Remote-Branches. Offen sind die Drafts #25 (R11), #26 (R07) und #27 (dieser Auftrag). Der Worktree `C:\dev\wt-r06` bleibt bestehen (Branch gepusht, sauber). Nichts installiert, nichts gemergt, kein Tag, keine Änderung an Workflows, Deployment, Supabase, ops/queue oder ops/reports.

```yaml
Reifegrad: "Buchtext v1.39 fertig mit PDF (80 Seiten) und story/current; Pixelprüfung verify_layout offen"
Projektstatus: "R06 als Draft-PR #27 offen, CI grün, wartet auf Review und Freigabe (G3 bis G5, G8) durch Bernd"
Offene_Fragen:
  - "k6: Ist die Auslegung richtig (ADR bleibt überall, ADG nur in Fußnote und Box statt 'im Text ADG nennen')?"
  - "Passt der Wortlaut der Fußnote, die Dokumenttyp ADR und Standard ADG abgrenzt?"
  - "Dürfen numpy und pillow in C:\\dev\\venv-pdf installiert werden, damit verify_layout vollständig läuft?"
  - "In welcher Reihenfolge werden #26 (R07) und #27 gemergt? Danach muss anhang.html neu erzeugt werden."
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```

## Ergänzung 09.11.2026: verify_layout vollständig

Am 09.11.2026 hat Bernd die Installation freigegeben, nur in `C:\dev\venv-pdf`.

**Installation**

Befehl: `C:\dev\venv-pdf\Scripts\python.exe -m pip install numpy pillow`

```text
Installing collected packages: pillow, numpy
Successfully installed numpy-2.4.6 pillow-13.0.0
```

Kontrolle: `python -c "import numpy, PIL; ..."` gibt `numpy 2.4.6 pillow 13.0.0` aus. Außerhalb der venv ist nichts installiert, auch kein pip-Update.

**Lauf 1: committete PDF**

Worktree `C:\dev\wt-r06`, nach `git pull --ff-only` (`Already up to date`), Stand 8fabbf2.

Befehl: `C:\dev\venv-pdf\Scripts\python.exe scripts/pdf/verify_layout.py --pdf source/Die-Fahrt-zum-Kunden.pdf --no-render`

```text
Hintergrundfarbe aus dem Quelltext: #123b4e
Struktur-Check OK - alle vier Fix-Mechanismen sind im CSS vorhanden.
Geprueft: 80 Seiten (Rand/Luftzone/Fast-leer-Check)
Geprueft: Ueberschriften-Reihenfolge + Kapitel-Verlinkung (Inhalt-Check)
OK - alle Seiten erfuellen den Layout-Check UND den Inhalt-Praesenz-/Positions-Check.
```

Exit-Code 0.

**Lauf 2: frisch gerendert**

Befehl: `…python.exe scripts/pdf/verify_layout.py --source source/fahrt-zum-kunden.html --pdf output/Die-Fahrt-zum-Kunden.pdf`

Ergebnis: `OK -> …\output\Die-Fahrt-zum-Kunden.pdf | Seiten: 80 | Renderstand: 09.11.2026, 05:18 Uhr (MEZ)`. Danach folgen dieselben OK-Zeilen wie in Lauf 1. Exit-Code 0.

Die Seitenzahl ist damit deterministisch, beide Läufe ergeben 80.

**Ergebnis**

- Das Layout hat keinen Befund. Am Buch habe ich nichts geändert.
- Die Prüfung hat nur `output/` erzeugt. Der Ordner ist gitignored, also gibt es nichts zu committen; `git status` ist sauber.

**Offene Fragen aus dem Bericht, jetzt beantwortet (Bernd, 09.11.2026)**

1. k6-Auslegung: bestätigt. ADR bleibt im Text, ADG steht nur in Fußnote und Box.
2. Wortlaut der Fußnote: bestätigt, sie bleibt so.
3. numpy und pillow: erlaubt, nur in `C:\dev\venv-pdf`. Installiert, verify_layout ist grün.
4. Merge-Reihenfolge: erst #27, dann das umgebaute #26, dann #25. Gemergt wird erst nach der Veröffentlichung von v1.38.
