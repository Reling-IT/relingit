---
id: R39
titel: 'Doku-Bereinigung nach R33: ABLAUF.md, CODEX_PROMPT.md, FTP-Regel, veraltete Dateien'
status: erledigt (PR offen, nicht gemergt)
datum: 2026-11-08
branch: auftrag-r39-doku (Worktree C:\dev\wt-r39, von origin/main 1281bbe)
pr: https://github.com/Reling-IT/relingit/pull/21
commit: c1ffcae
ci: 'Website prüfen: pass (9 s), https://github.com/Reling-IT/relingit/actions/runs/42447179374'
---

# Bericht R39 – Doku-Bereinigung nach R33

## Ziel

Die Doku soll mit `main` (1281bbe) übereinstimmen. Grundlage sind die Befunde 1 bis 28 aus `reports/R33-BERICHT.md`, Schwerpunkt die 6 Muss-Befunde. Geändert wurde nur Doku: kein Buchtext, keine PDF, keine Skripte, keine Workflows. 9 Dateien, 148 Einfügungen, 99 Löschungen.

## Umgesetzt

| Befund | alt | neu |
|---|---|---|
| 1 (muss) ABLAUF Kennzeichnung | „gilt ab Merge von PR #8“, Klasse `pr8`, Legendensatz, „Stand 2f8cd6d“ | entfernt; „Stand: `main` 1281bbe vom 08.11.2026“ |
| 2 (muss) ABLAUF Knoten B | „OFFEN: Werkzeug kommt mit R14“, Klasse `offen`, offener Punkt R14 | Owner-Schritt „PDF mit scripts/pdf/render_story_pdf.py erzeugen … siehe docs/PDF-ERZEUGEN.md“; offener Punkt gestrichen |
| 3, 4 (muss), 6 (sollte) ABLAUF Belegtabelle | Zeilennummern, um 1 bis 12 Zeilen verschoben; Zusätze „(PR #8)“/„(main)“ | Belege als Abschnittsname (`›`) oder wörtlicher Suchbegriff; Erklärung oben in der Datei; neue Belege für pdftotext, Podcast und FTP-Fall |
| 5 ABLAUF Reihenfolge | „Auf `main` ist sie offen“ | „Erst Pull Request und Merge, dann Admin-Bereich (NEUE-GESCHICHTE Schritte 4 und 5)“ |
| 7, 10, 11 FTP-Regel | README: „Nur Änderungen an der Landingpage selbst“; ABLAUF:127/137 „Landingpage, Gestaltung …“, Angleichung offen; README/NEUE-GESCHICHTE/DOMAINFACTORY: nur vier q15-Pfade | Einheitlich formuliert: Admin-Bereich ist der Standardweg; FTP für `index.html`, `assets/js`, `assets/css`, `assets/fonts` (sobald vorhanden), `impressum.html`, `datenschutz.html` und weitere Seiten außerhalb des Admin-Bereichs. Die vollständige Liste steht als einzige Quelle in NEUE-GESCHICHTE › „FTP-Fall“ (neue Überschrift mit Anker). README (zwei Stellen), DOMAINFACTORY und ABLAUF (Knoten N und Belege) verweisen darauf. Deutung der Skriptausgabe: Auch ein „Hinweis: weitere öffentliche Dateien geändert“ bedeutet FTP-Upload. |
| 8 ABLAUF Verzeichniskarte | ohne `assets/audio`, `scripts/pdf`, `docs/vorlagen`, `tests`, Stammdateien | Knoten ergänzt |
| 9 ABLAUF Release-Ablauf | kein Podcast-Schritt | Knoten Q „Podcast-Dateien lokal ablegen“ vor dem Skriptlauf; nach P die Entscheidung „Erzähltext geändert?“ → „Podcast mit Google NotebookLM neu erzeugen“ |
| 13 NEUE-GESCHICHTE §2 | „Die passende PDF wird aus der HTML-Datei erzeugt“ ohne Befehl | Befehl `python scripts/pdf/render_story_pdf.py --out source/Die-Fahrt-zum-Kunden.pdf` und Verweis auf PDF-ERZEUGEN.md |
| 14 NEUE-GESCHICHTE §3 | „Bricht das Skript mit `FEHLER:` ab“ | „mit einer roten Fehlermeldung ab (bei ci-check: Liste der Fehler, danach ‚CI-Prüfung mit N Fehler(n) abgebrochen‘)“, Wortlaut gegen ci-check geprüft |
| 15 NEUE-GESCHICHTE §3 | Ausgabebeispiel ohne optionale Zeilen | zweiter Block mit Handout-Pfaden, „FTP-Upload nötig: ja, geändert“, Paketzeile, „Nur Rückfallwerte“, „Hinweis“, dazu eine kurze Deutung (Texte aus publish-release übernommen) |
| 16 PDF-ERZEUGEN Bezugswert | „(v1.29) hat 69 Seiten“ | „(v1.37)“; `pdfinfo story/current/geschichte.pdf`: Pages 69 |
| 17 Poppler-Voraussetzung | nur für `pdftoppm` genannt | PDF-ERZEUGEN Schritt 4, README (Absatz PDF-Werkzeuge) und NEUE-GESCHICHTE §2: `pdfinfo` und `pdftotext` werden für publish-release gebraucht |
| 18 (muss) CODEX_PROMPT anon | „erlaube `anon` nur INSERT – niemals SELECT, UPDATE oder DELETE“ | „`anon` erhält keinen direkten Zugriff auf die Feedbacktabellen; Rückmeldungen laufen nur über die Edge Function `submit-feedback`. Lesend darf `anon` nur die öffentlichen Versionsangaben (`story_release`) abfragen.“ |
| 19 CODEX_PROMPT Ablauf | nicht gekennzeichnet | Hinweis oben: „Veraltet, Stand v1.25“, Verweis auf NEUE-GESCHICHTE und SICHERHEIT; Inhalt nicht umgeschrieben (Auftrag) |
| 20 REVIEW.md | nicht gekennzeichnet | Hinweis oben „Veraltet, Stand v1.25 (03.09.2026, 57 Seiten)“; Punkte 1 und 2 am 08.11.2026 erneut gefunden (je 2 Treffer „v1.??“ und „quelloffen“ in source v1.37) |
| 21 SUPABASE-ANLEITUNG § G | Ablauf nur über den Admin-Upload | Verweis auf NEUE-GESCHICHTE (publish-release, PR, Admin-Bereich, Handout nur bei Änderung) |
| 22 DOMAINFACTORY Paket-Upload | Paket und Manifest nicht beschrieben | neuer Abschnitt „FTP-Paket hochladen“: Ordner oder ZIP, versteckte Dateien, Inhalt nach `relingit`, `UPLOAD-MANIFEST.txt` nicht nötig, nichts außerhalb des Pakets; Schritt 8 im Erst-Upload verweist darauf |
| 23 README build-upload | „Vor einem FTP-Upload … ausführen“ | „publish-release baut das Paket bereits mit; build-upload nur, wenn ohne neue Buchfassung ein Paket gebaut werden soll“ |
| 24 CI-Beschreibung (Doku-Teil) | Vollständigkeits- und Podcast-Prüfung fehlen; „Workflow ‚Website prüfen‘“ | README › Continuous Integration und SICHERHEIT ergänzt; „Job ‚Website prüfen‘ im Workflow ‚Website CI‘“ in README und ABLAUF |
| 25 DOMAINFACTORY Ausschlussliste | ohne `output`, `tmp`, `ideen`, `LICENSE`, `.gitignore`, `.gitattributes` | ergänzt, dazu `tests`; Hinweis „nur den Inhalt des FTP-Pakets übertragen“ |
| 26 Header-Prüfdatum | „Kontrolle am 4. September 2026“ | zusätzlich 8. November 2026, `curl -sI https://berndmarnau.de/relingit/`: 200 OK, keine HSTS-/CSP-/nosniff-/Referrer-/Frame-/Permissions-Header (DOMAINFACTORY und SICHERHEIT) |
| 27 README Projektstruktur | ohne `scripts/pdf`, `docs/vorlagen`, `tests`, `.htaccess`/`.gitignore`/`.gitattributes` | ergänzt |

Zählung: 24 von 28 Befunden ganz umgesetzt (1–10, 13–23, 25–27), Befund 11 und 24 nur im Doku-Teil. Befund 12 ist durch #17 erledigt. Offen bleiben Befund 28 sowie die Code-/Buchtext-Anteile von 11, 20 und 24.

## Nicht umgesetzt (mit Grund)

| Befund | Grund |
|---|---|
| 12 Gemini/NotebookLM (NEUE-GESCHICHTE §6, EINBAU-CHECKLISTE) | durch #17 (R37) erledigt; die Zeilen sind bewusst nicht angefasst. ABLAUF nennt NotebookLM im neuen Podcast-Knoten, passend zu #17. |
| 11 publish-release-Ausgabe | Skript (Auftragsgrenze). Das Skript meldet weiterhin nur die vier q15-Pfade als „FTP-Upload nötig: ja“, `assets/css` u. a. nur als „Hinweis“. Die Doku deutet beides jetzt als FTP-Bedarf. Vorschlag siehe unten. |
| 24 ci.yml `node --check assets/js/handout-viewer.js` | Workflow (Auftragsgrenze), eigener Kleinauftrag |
| 28 PODCAST.md Sicherungsort `output/ftp/…` | PODCAST.md wird von #17, #18 (R35) und #20 (R36) geändert; Rücksicht auf diese PRs, nach deren Merge nachziehen |
| 20 Buchtext (n8n „quelloffen“, Platzhalter „v1.??“) | Buchtext (Auftragsgrenze); passt zu R03/v1.38 |

## Prüfungen

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| ci-check lokal | `pwsh -NoProfile -File scripts/ci-check.ps1` | Exit 0; „OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.“ Hinweis: 5 von 5 Podcast-Dateien lokal nicht vorhanden (erwartet) |
| Interne Links und Anker | eigenes Skript (Scratchpad `linkcheck.py`, GitHub-Slug-Regel, README.md und docs/**/*.md, ohne Codeblöcke) | 18 interne Links in 11 Dateien, 0 Fehler |
| Pfade in Backticks | Shell-Schleife über `` `docs/…` ``, `` `scripts/…` `` usw. | Es fehlen nur die erwarteten, nicht versionierten Dateien: `assets/audio/*`, das Podcast-Cover und `assets/fonts` (als „sobald vorhanden“ gekennzeichnet) |
| ABLAUF-Belege | Python-Skript: jeder Suchbegriff „…“ und jeder Abschnitt `›` in der genannten Datei | 71 Belege, 0 Fehler |
| Mermaid | `mmdc` nicht installiert, kein globales mermaid-Paket; npx bewusst nicht genutzt | Manuell geprüft: eindeutige Knoten-IDs, Kantenlabels in Anführungszeichen, alle `class`-Zuweisungen haben ein `classDef`, die entfernte Klasse `offen`/`pr8` wird nirgends mehr verwendet, Shapes `[""]`, `{""}`, `([""])` |
| Whitespace | `git diff --check` | ohne Befund |
| Konflikte mit parallelen PRs | `git merge-tree --write-tree HEAD origin/<branch>` | konfliktfrei mit #17 (R37), #18 (R35), #20 (R36) |
| Schlüsselmuster | grep mit den Mustern aus ci.yml und ci-check.ps1 über PR-Text und Bericht | 0 Treffer |

## CI

`gh pr checks 21 --watch`: „Website prüfen“ **pass** (9 s), Lauf https://github.com/Reling-IT/relingit/actions/runs/42447179374. PR-Kommentar: https://github.com/Reling-IT/relingit/pull/21#issuecomment-6717263862

## PR

https://github.com/Reling-IT/relingit/pull/21 (offen, kein Draft, nicht gemergt)

## Offene Fragen, Risiken, Abweichungen

- **FTP-Liste erweitert:** Die Liste in R39 (`assets/css`, `assets/fonts`, weitere Seiten) geht über die Owner-Entscheidung q15 hinaus, die nur vier Pfade nennt. Damit ist die offene Frage aus R33 (CSS in die Liste?) in der Doku beantwortet. Eine ausdrückliche Bestätigung durch den Owner fehlt noch. `assets/fonts` gibt es im Repo noch nicht und ist deshalb als „sobald vorhanden“ gekennzeichnet.
- **Abweichung CODEX_PROMPT:** Der Auftrag sagt „kein direkter Tabellenzugriff für anon“. Laut `supabase/setup.sql` darf `anon` aber `story_release` lesen (`grant select … to anon`, Policy „Anyone may read current release“). Formuliert ist deshalb: kein direkter Zugriff auf die *Feedbacktabellen*, lesend nur `story_release`.
- **Überschneidung mit R36 (#20):** #20 nimmt das Podcast-Cover ins Repo auf. Nach dem Merge stimmen ABLAUF (Knoten „assets/audio und Podcast-Cover nur lokal“), README › Projektstruktur („das Podcast-Cover liegt nur lokal“, von mir nicht geändert) und DOMAINFACTORY (Podcast-Absatz) teilweise nicht mehr. Das ist dann eine kleine Nacharbeit; ein Git-Konflikt besteht nicht.
- **NotebookLM in ABLAUF:** Der neue Podcast-Knoten nennt NotebookLM. Bis #17 gemergt ist, steht in NEUE-GESCHICHTE §6 noch „Gemini“.
- **Belege ohne automatische Prüfung:** Die Suchbegriffe sind robuster als Zeilennummern, können aber bei Umformulierungen in Skripten veralten (z. B. durch R36 in publish-release).
- **Header-Prüfung:** Nur die Startseite wurde per `curl -sI` geprüft. Ob `.htaccess` auf dem Server liegt, ist ungeklärt; das Problem bleibt seit September bestehen.

## Vorschläge und Ideen (Claude)

- **publish-release-Ausgabe angleichen (Skript, eigener Auftrag):** `assets/css`, `assets/fonts` und die weiteren öffentlichen Dateien in `$ftpPaths` aufnehmen oder die Hinweiszeile in „FTP-Upload nötig: ja (weitere öffentliche Dateien)“ ändern. Dann widersprechen sich Doku und Ausgabe nicht mehr; danach den Erklärsatz im FTP-Fall kürzen.
- **Belegprüfung in ci-check:** Die Suchbegriffe „…“ der ABLAUF-Belegtabelle maschinell gegen die genannten Dateien prüfen. Das hier genutzte Python-Snippet lässt sich in PowerShell mit etwa 30 Zeilen nachbauen.
- **Markdown-Link- und Ankerprüfung** in ci-check (heute nur HTML). Das Skript `linkcheck.py` aus diesem Auftrag kann als Vorlage dienen.
- **CODEX_PROMPT.md** nach `archive/` verschieben oder als neuen Agentenprompt auf Basis von NEUE-GESCHICHTE schreiben. **REVIEW.md** in `REVIEW-v1.25.md` umbenennen und die Punkte 1 und 2 in den v1.38-Auftrag übernehmen.
- **PODCAST.md** nach dem Merge von #17/#18/#20: Befund 28 nachziehen (die Kopie wandert beim nächsten Release nach `archive/ftp-packages/`). Mit dem GitHub-Release aus R35 ist die OneDrive-Kopie ohnehin nicht mehr die einzige Sicherung.
- **Sicherheitsheader:** Eigener Leseauftrag mit `curl -sI` auf mehrere Seiten und auf `.htaccess` (sollte 403 liefern), danach DomainFactory-Anfrage durch den Owner.

Hygiene: gemergter Remote-Branch noch vorhanden: origin/quelle-pdf-werkzeuge-20261106. Offene PRs: #21 (R39), #20 (R36), #19 (R40), #18 (R35), #17 (R37), #6; Drafts: #9, #10. Worktree C:\dev\wt-r39 bleibt bestehen (sauber, gepusht). Nichts gemergt, kein Tag, keine Veröffentlichung, kein FTP.

```yaml
Reifegrad: Doku auf Stand main 1281bbe, Belege ohne Zeilennummern, ci-check und CI grün
Projektstatus: R39 als PR #21 offen (CI grün), Review durch Owner ausstehend; parallel offen #17, #18, #19, #20
Offene_Fragen:
  - Bestätigt der Owner die erweiterte FTP-Liste (assets/css, assets/fonts, weitere Seiten) über q15 hinaus?
  - publish-release-Ausgabe an die FTP-Regel angleichen (eigener Skriptauftrag)?
  - Nach Merge von #20: Hinweise zum Podcast-Cover in README, ABLAUF, DOMAINFACTORY nachziehen?
  - CODEX_PROMPT.md archivieren oder neu schreiben?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
