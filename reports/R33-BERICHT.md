---
id: R33
titel: Repo-Dokumentation gegen den Ist-Stand abgleichen
status: erledigt (Leseauftrag, keine Änderungen)
start: 2026-11-07T06:31+01:00
ende: 2026-11-07T06:49+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: origin/main 44898de
---

# R33 – Abgleich der Repo-Dokumentation mit main (44898de)

## Ergebnis

- Geprüft: README.md, docs/*.md (ohne vorlagen), scripts/*.ps1, repo-aktualisieren.ps1, .github/workflows/ci.yml, .gitignore, scripts/pdf/* (soweit verwiesen). 28 Befunde: 6 muss, 14 sollte, 8 kann.
- Größter Block: `docs/ABLAUF.md` ist seit den Merges von #8/#11/#13 überholt. Fast alle README- und publish-release-Zeilenbelege sind verschoben, „gilt ab Merge von PR #8“ und „offen (R14)“ gelten nicht mehr.
- FTP-Regel: README, NEUE-GESCHICHTE, DOMAINFACTORY-DEPLOYMENT und publish-release nennen jetzt einheitlich die vier Pfade aus q15. Unscharf bleiben README:79 und ABLAUF:127/137. Fachlich offen ist, dass Änderungen an `assets/css` und an weiteren Seiten ebenfalls nur per FTP live gehen.
- Podcast-Werkzeug ist widersprüchlich: NotebookLM steht in index.html, datenschutz.html und ci-check, Gemini in NEUE-GESCHICHTE §6 und EINBAU-CHECKLISTE. Die Entscheidung liegt beim Owner.
- Alte Repo-Namen (`bmarnau/relingit`) kommen nicht mehr vor. `CODEX_PROMPT.md` und `REVIEW.md` sind inhaltlich veraltet (Stand v1.25, anon-INSERT-Modell).

### Befundtabelle

| # | Fundstelle | Soll | Ist | Vorschlag | Schweregrad |
|---|---|---|---|---|---|
| 1 | docs/ABLAUF.md:5-10, 46, 52, 64, 69, 72 | Seit 6c7a034 ist PR #8 gemergt. Die Angaben gelten auf main. | Die Kennzeichnung „gilt ab Merge von PR #8“, die Klasse `pr8` und „Stand 2f8cd6d“ stehen noch da. | Kennzeichnung, Klasse `pr8` und Legendensatz entfernen. „Stand 44898de“ (bzw. den Merge-Stand der Bereinigung) setzen. | muss |
| 2 | docs/ABLAUF.md:40, 68, 103, 135 | Mit PR #11 gibt es Werkzeug und Befehl: `scripts/pdf/render_story_pdf.py`, `verify_layout.py`, `docs/PDF-ERZEUGEN.md`. | Knoten B ist als „OFFEN: Werkzeug kommt mit R14“ gekennzeichnet, ebenso der offene Punkt. | Knoten B als Owner-Schritt mit Verweis auf PDF-ERZEUGEN.md führen (Belege: PDF-ERZEUGEN.md:45-57). Offenen Punkt streichen. | muss |
| 3 | docs/ABLAUF.md Belegtabelle (Z. 82-131), README-Belege | Die Zeilen stimmen mit README@44898de überein. | Alle README-Verweise sind um 1 bis 12 Zeilen verschoben. Beispiele: :18→19, :16→17, :13→14, :15→16, :9-11→9-12, :14→15, :17→18, :12/:20→13/21, :26-27→31-32, :28-33→33-38, :37→42, :41-42→43-47, :46-50→58-62, :51→63, :59-64→71-77, :67→79, :93→105, „:24 (PR #8)“→25 | Belegtabelle neu erzeugen. Am besten Zeilen nur noch als Anker oder Abschnittsnamen angeben (siehe Vorschläge). | muss |
| 4 | docs/ABLAUF.md Belegtabelle, publish-release- und build-upload-Belege | Die Zeilen stimmen mit scripts@44898de überein. | publish-release: 13-14→17-18, 24-50→28-54, 55-62→59-66 (55-57 ist der Google-Fonts-Check), 66-78→68-82, 84-86 und 85-86→88-90 und 89-90, 88-107→92-111, 109→113, 111-123 und 113-123→115-127, 125→129, 127→131. build-upload: 73→86 (Compress-Archive), 59-105→72-118. ci-check: 106-189 deckt die Version (106-174) ab, die bytegenaue Prüfung steht aber in 289-302. | Belege korrigieren. Achtung: R15 fügt in publish-release nach Z. 84 rund 37 Zeilen ein. Die publish-release-Belege ab 88 verschieben sich nach dem R15-Merge erneut, deshalb erst nach R15 bereinigen. | muss |
| 5 | docs/ABLAUF.md:74, 136 | Auf main ist die Reihenfolge „PR, dann Admin-Bereich“ festgelegt (NEUE-GESCHICHTE.md:54-75). | „Auf main ist sie **offen**“ | Satz und offenen Punkt streichen. Beleg NEUE-GESCHICHTE.md:54-75 angeben. | sollte |
| 6 | docs/ABLAUF.md:116, 118, 122, 124, 126, 129, 131 | Die Belege beziehen sich auf main. | Sie tragen den Zusatz „(PR #8)“ bzw. „(main)“ und alte Zeilen: :127 (main) ist die OK-Zeile, heute :131. | Zusätze entfernen. Die Zeilen 170-227, 199-200 (jetzt 200), 216 und 224-226 stimmen auf main. | sollte |
| 7 | docs/ABLAUF.md:127, 137 | Die FTP-Regel ist angeglichen: DOMAINFACTORY-DEPLOYMENT.md:59 nennt die vier Pfade und zusätzlich den Hinweis auf `assets/css` und `.htaccess`. | Es heißt noch, DOMAINFACTORY:57 nenne „Landingpage, Gestaltung, …“. Die Angleichung sei offen. | Zeile 127 und den offenen Punkt 137 streichen oder auf Befund 9 (README:79) umstellen. | sollte |
| 8 | docs/ABLAUF.md:16-30 (Verzeichniskarte) | Der Ist-Stand umfasst `assets/audio` (Podcast, nicht in Git), `scripts/pdf`, `docs/vorlagen`, die neuen Dokumente PDF-ERZEUGEN/PODCAST und `.gitignore`-Zeilen 19-21. | Diese Teile fehlen. Für `assets` werden nur css/img/js genannt. | Knoten ergänzen, Belege README.md:10-11 und .gitignore:19-21 angeben. | sollte |
| 9 | docs/ABLAUF.md:37-58 (Release-Ablauf) | Laut NEUE-GESCHICHTE.md:79-83 gibt es Schritt 6 (Podcast nur bei geändertem Erzähltext). build-upload bricht ohne Podcast-Dateien ab (build-upload.ps1:55-61). | Das Diagramm kennt keinen Podcast-Schritt und keine Voraussetzung „Podcast-Dateien lokal“ vor G. | Knoten „Podcast-Dateien lokal ablegen (docs/PODCAST.md)“ vor G einfügen, außerdem einen optionalen Podcast-Schritt nach P. | sollte |
| 10 | README.md:79 | Die FTP-Regel nennt wie README:25 die vier Pfade aus q15. | „Nur Änderungen an der Landingpage selbst werden erneut zu DomainFactory übertragen.“ | Satz durch Verweis auf Z. 25 ersetzen oder die vier Pfade nennen. | sollte |
| 11 | README.md:25; NEUE-GESCHICHTE.md:3, 77; DOMAINFACTORY-DEPLOYMENT.md:59; publish-release.ps1:199-202 | Fachlich gilt: Jede geänderte öffentlich ausgelieferte Datei kommt nur per FTP live, auch `assets/css`, `lesen.html`, `admin.html`, `.htaccess`. | Laut Text ist FTP „nur nötig“ für die vier Pfade. Andere Dateien erscheinen nur als „Hinweis“. NEUE-GESCHICHTE:3 sagt sogar „FTP wird für eine neue Buchfassung nicht benötigt“. | Owner-Rückfrage, siehe Offene Fragen. Entweder `assets/css` in die q15-Liste aufnehmen oder den Hinweis in allen drei Dokumenten gleichlautend erwähnen. | sollte |
| 12 | docs/NEUE-GESCHICHTE.md:81 und docs/vorlagen/EINBAU-CHECKLISTE.md:53 | Ein Werkzeugname, abgestimmt mit index.html:115, 127, datenschutz.html:96, 122 und ci-check.ps1:370-372 (Pflicht „Google NotebookLM“) | Dort steht „Google Gemini“. | Owner entscheidet (PODCAST.md:63-69). Bis dahin NEUE-GESCHICHTE §6 und die Checkliste auf „Google NotebookLM“ setzen, weil CI und Datenschutz das verlangen. | muss (inhaltlicher Widerspruch mit Datenschutzbezug) |
| 13 | docs/NEUE-GESCHICHTE.md:20-22 | Hinweis auf das Werkzeug: `docs/PDF-ERZEUGEN.md` (PR #11) | „Die passende PDF wird aus der HTML-Datei erzeugt“, ohne Verweis und ohne Befehl | Befehl `python scripts/pdf/render_story_pdf.py --out source/Die-Fahrt-zum-Kunden.pdf` oder einen Verweis ergänzen. R15 verweist nur in einem neuen Absatz nach Schritt 3 darauf, §2 bleibt unverändert. | sollte |
| 14 | docs/NEUE-GESCHICHTE.md:50 | Die Fehlermeldung so beschreiben, wie die Skripte sie ausgeben | „Bricht das Skript mit `FEHLER:` ab“. Kein Skript gibt `FEHLER:` aus: publish-release nutzt `throw`, ci-check `Write-Error` und „CI-Prüfung mit N Fehler(n) abgebrochen“. | Umformulieren: „Bricht das Skript mit einer roten Fehlermeldung ab (bei ci-check: Liste der Fehler, dann ‚CI-Prüfung mit N Fehler(n) abgebrochen‘)“. R15 lässt den Satz unverändert, der Befund bleibt also. | sollte |
| 15 | docs/NEUE-GESCHICHTE.md:34-48 | Die erwartete Ausgabe entspricht publish-release.ps1:170-226. | Die möglichen Zeilen „Nur Rückfallwerte: …“ und „Hinweis: weitere öffentliche Dateien geändert …“ fehlen. Bei „Handout geändert: ja“ folgen zwei Pfadzeilen, und die Zeile lautet „FTP-Upload nötig: ja, geändert: …“. | Beispiel um die optionalen Zeilen ergänzen und sie kurz deuten. | kann |
| 16 | docs/PDF-ERZEUGEN.md:82 | Den Bezugswert für den aktuellen Stand angeben: `story/current/geschichte.pdf` ist v1.37 vom 05.09.2026 mit 69 Seiten (pdfinfo, Fonts DejaVu/Liberation bestätigt). | „(v1.29) hat 69 Seiten“ | „(v1.37)“ eintragen. Die Seitenzahl stimmt. | sollte |
| 17 | docs/PDF-ERZEUGEN.md (fehlt) | publish-release braucht `pdfinfo` (publish-release.ps1:70-82), nach R15 auch `pdftotext`. Beide sind Teil von Poppler. | Poppler steht nur als Voraussetzung für `pdftoppm` im freiwilligen Werkzeug (Z. 27-31). README und NEUE-GESCHICHTE nennen `pdfinfo` als Voraussetzung nicht. | In NEUE-GESCHICHTE §3 oder im README einen Satz ergänzen: „Voraussetzung: Poppler (pdfinfo, ab R15 pdftotext), Einrichtung siehe PDF-ERZEUGEN.md Schritt 4“. | sollte |
| 18 | docs/CODEX_PROMPT.md:23 | Aktuelles Sicherheitsmodell (SICHERHEIT.md:47-57, README:87-89, setup.sql: `revoke all … from anon`): anonymes Feedback nur über die Edge Function | „erlaube `anon` nur INSERT“ | Ersetzen durch „kein direkter Tabellenzugriff für anon, Feedback nur über die Edge Function `submit-feedback`“. Wer den Prompt nutzt, würde sonst eine Rückkehr zum alten RLS-Modell anstoßen. | muss |
| 19 | docs/CODEX_PROMPT.md:8-9, 13 | Der Ablauf geht über `source/` und `publish-release.ps1` (README:31-38). Die Eingangsquelle ist HTML. | „Ersetze … nur `story/current/…`“, „Aktualisiere … app.js“, „Lies die neue PDF“ | Prompt an NEUE-GESCHICHTE.md anlehnen: neue Fassung nach `source/`, `publish-release.ps1`, keine Handkopien. Außerdem `lesen.html`/`index.html`, die CI-Pflichten und die Branch/PR-Regel nennen. | sollte |
| 20 | docs/REVIEW.md:1, 5 | Prüfung zum aktuellen Stand (v1.37, 69 Seiten) | „Version 1.25“, „57 Seiten“, Stand 03.09.2026 (f81d477) | Als historisch kennzeichnen oder neu erstellen. Die Punkte 1 (n8n „quelloffen“) und 2 (Platzhalter „v1.??“) sind in `source/fahrt-zum-kunden.html` v1.37 weiterhin vorhanden (2× „v1.??“, 2× „quelloffen“) und bleiben gültig. | sollte |
| 21 | docs/SUPABASE-ANLEITUNG.md:92-99 (Abschnitt G) | Laut q15 und NEUE-GESCHICHTE.md: `publish-release.ps1`, PR, dann Admin-Bereich, Handout nur bei Änderung | Nur Admin-Upload, ohne Skript, PR und Handout | Abschnitt G auf einen Verweis „siehe docs/NEUE-GESCHICHTE.md“ kürzen. | kann |
| 22 | docs/DOMAINFACTORY-DEPLOYMENT.md:27-38 | Für den regulären FTP-Fall: Inhalt des ZIP aus `output/ftp` hochladen, `UPLOAD-MANIFEST.txt` nicht übertragen (bzw. Regel nennen) | Die Schritte verweisen nur auf „die oben genannten Dateien“ des Erst-Uploads. Paket und Manifest kommen nicht vor, obwohl NEUE-GESCHICHTE.md:77 für den Paket-Upload hierher verweist. | Unterabschnitt „FTP-Paket hochladen“ ergänzen: ZIP entpacken, Inhalt ohne Manifest nach `/relingit`, versteckte Dateien. | sollte |
| 23 | README.md:65-77 | Klarstellen, dass `publish-release.ps1` das Paket bereits baut | „Vor einem FTP-Upload … `./scripts/build-upload.ps1`“. Ein zweiter Lauf ohne `-Suffix` scheitert mit „Paket existiert bereits“ (build-upload.ps1:34-36). | Präzisieren: „nur nötig, wenn ohne neue Buchfassung (z. B. nur Impressum) ein Paket gebaut werden soll“. | kann |
| 24 | README.md:105; SICHERHEIT.md:85-86; ABLAUF.md:35, 120 | Die CI-Beschreibung entspricht ci.yml und ci-check.ps1. | Der Vollständigkeits-Check der Buchquelle (ci-check:176-287) und die Podcast-Prüfung (336-372) fehlen in der Beschreibung. ci.yml:39-45 prüft die Syntax von `handout-viewer.js` nicht, obwohl die Datei Pflicht ist (ci-check:13). Der Workflow heißt „Website CI“, „Website prüfen“ ist der Job-/Check-Name. | Aufzählung ergänzen. `node --check assets/js/handout-viewer.js` in ci.yml aufnehmen (Code, eigener Auftrag). In ABLAUF „Job ‚Website prüfen‘ im Workflow ‚Website CI‘“ schreiben. | kann |
| 25 | docs/DOMAINFACTORY-DEPLOYMENT.md:23 | Vollständige Ausschlussliste | `output`, `tmp`, `ideen`, `LICENSE`, `.gitignore`, `.gitattributes` fehlen. | Ergänzen oder auf „nur den Inhalt des FTP-Pakets“ verweisen. | kann |
| 26 | docs/DOMAINFACTORY-DEPLOYMENT.md:42-45; SICHERHEIT.md:3, 113-116 | Aktueller Prüfstand der Sicherheitsheader | „Kontrolle am 4. September 2026“, seither nicht fortgeschrieben | Header-Prüfung wiederholen und das Datum fortschreiben (Leseauftrag mit curl -I). | kann |
| 27 | README.md:9-19 | Die Projektstruktur ist vollständig. | `scripts/pdf` (nur „lokale und CI-Prüfungen“) und `docs/vorlagen` fehlen. Der Projektstamm enthält auch `.htaccess`, `.gitignore`, `.gitattributes`. | Zwei Unterpunkte ergänzen. | kann |
| 28 | docs/PODCAST.md:34 | Ein Sicherungsort, der existiert bzw. benannt ist | Als Kopie wird `output/ftp/relingit-upload-v1.37-2026-09-05-podcast/` genannt. publish-release verschiebt Pakete aus `output/ftp` bei jedem Lauf nach `archive/ftp-packages/<Zeitstempel>/` (publish-release.ps1:115-127). | Hinweis ergänzen: Nach dem nächsten Release liegt diese Kopie unter `archive/ftp-packages/…`. Bestätigt das Sicherungsrisiko aus R23. | kann |

Ohne Befund geprüft:
- Alte Repo-Namen: Außer der gewollten Verbotsregel (README:27, NEUE-GESCHICHTE:5, DOMAINFACTORY:61) gibt es keine Treffer zu `bmarnau`. Alle URLs zeigen auf `Reling-IT/relingit`.
- Dateinamen und Pfade in README, NEUE-GESCHICHTE, DOMAINFACTORY und PODCAST existieren auf main oder sind als nicht versioniert gekennzeichnet (MP3, Cover).
- Die Admin-Dateinamenprüfung („andere Dateinamen lehnt der Admin-Bereich ab“) ist belegt in admin.js:236-245.
- PDF-ERZEUGEN: Standardpfade, Exit-Codes 0/1/2, die Meldungstexte, `requirements.txt` (inkl. tzdata nur für win32) und die Hintergrundfarbe #123b4e stimmen mit den Skripten überein.
- ci.yml:4-9, 35-55, :3, .gitignore:2-3, :5, build-upload:10-11, 30-32, 39-40, ci-check:9 sowie NEUE-GESCHICHTE:3, 22, 54-62, 64, 75 sind in ABLAUF weiterhin korrekt belegt.

## Offene Fragen, Risiken, Abweichungen

- **q15-Liste und CSS (Owner):** Soll `assets/css` (und ggf. `lesen.html`, `admin.html`, `.htaccess`) in die Liste „FTP nötig“ aufgenommen werden? Bisher meldet publish-release solche Änderungen nur als „Hinweis“. Daher rührt die Formulierung „Gestaltung“ in der früheren DOMAINFACTORY-Fassung. Risiko: Eine CSS-Änderung wird ins Repo gemergt, aber nicht hochgeladen.
- **Podcast-Werkzeug (Owner):** NotebookLM oder Gemini? Der Live-Text, Datenschutz und CI verlangen NotebookLM. Bei einem Wechsel müssen Datenschutz, FAQ, Quellenangabe und ci-check gemeinsam geändert werden (PODCAST.md:63-69).
- **R15-Überschneidung:** R15 (Branch `auftrag-R15-release-pruefungen`, kein PR offen) ändert publish-release (+37 Zeilen nach Z. 84), ci-check (Z. 374 ff.) und NEUE-GESCHICHTE §3. Befunde 4 und 6 (Zeilenbelege) sollten erst nach dem R15-Merge umgesetzt werden. Befunde 14 und 17 übernimmt R15 nicht; mit R15 kommt `pdftotext` als neue Voraussetzung hinzu. Befund 13 deckt R15 nur teilweise ab (Verweis im neuen Absatz, §2 unverändert).
- **ABLAUF.md als Belegdokument:** Zeilenbelege veralten bei jedem Merge. Ohne automatische Prüfung wird der Befund 3/4 immer wieder auftreten.
- **Grenze der Prüfung:** Die Live-Seite, das Supabase-Dashboard und der DomainFactory-Webspace wurden nicht geprüft. Auch der Inhalt des Buchs wurde nicht redaktionell gelesen, nur gezielt nach den REVIEW-Punkten durchsucht.

## Vorschläge und Ideen (Claude)

- **Belege mit Ankern statt Zeilennummern:** In ABLAUF.md Abschnittsnamen oder Suchmuster als Beleg angeben, z. B. `publish-release.ps1 › "Übergabe an den Admin-Bereich"`. Alternativ prüft ein kleiner ci-check-Teil, ob die in ABLAUF.md zitierten Zeilen ein Stichwort enthalten.
- **Eine Quelle für die FTP-Liste:** Die vier Pfade stehen in vier Dateien. Vorschlag: nur in NEUE-GESCHICHTE.md (bzw. publish-release.ps1) definieren, die anderen verweisen darauf.
- **CODEX_PROMPT.md:** Entweder neu schreiben (Agentenprompt für Buch-Updates mit den heutigen Regeln) oder nach `archive/` bzw. als historisch markieren.
- **REVIEW.md:** In „REVIEW-v1.25.md“ umbenennen und offene Punkte (n8n, v1.??) als Auftrag für den Buchtext führen (passt zu R03/v1.38).
- **Entwurf Folgeauftrag** (nicht in die Queue gelegt):

```yaml
id: R34
titel: Doku-Bereinigung nach R33 (ABLAUF, README, NEUE-GESCHICHTE, CODEX_PROMPT, REVIEW)
typ: Änderungsauftrag
voraussetzung: R15 gemergt; Owner-Entscheidungen zu Podcast-Werkzeug und CSS-in-q15-Liste
branch: auftrag-R34-doku-bereinigung
umfang:
  - docs/ABLAUF.md: PR-#8- und R14-Kennzeichnungen entfernen, Belegtabelle gegen neuen main-Stand neu erzeugen, Podcast- und PDF-Werkzeug-Knoten ergänzen (Befunde 1-9)
  - README.md: Z. 79 an q15 angleichen, Projektstruktur ergänzen, build-upload-Hinweis präzisieren, CI-Aufzählung (Befunde 10, 23, 24, 27)
  - docs/NEUE-GESCHICHTE.md: §2 Verweis PDF-ERZEUGEN, „FEHLER:“-Satz, Ausgabebeispiel, Poppler-Voraussetzung, §6 Werkzeugname (Befunde 12-15, 17)
  - docs/vorlagen/EINBAU-CHECKLISTE.md: Werkzeugname Podcast (Befund 12)
  - docs/PDF-ERZEUGEN.md: Bezugswert v1.37 (Befund 16)
  - docs/DOMAINFACTORY-DEPLOYMENT.md: Abschnitt „FTP-Paket hochladen“, Ausschlussliste (Befunde 22, 25)
  - docs/SUPABASE-ANLEITUNG.md §G: Verweis auf NEUE-GESCHICHTE (Befund 21)
  - docs/CODEX_PROMPT.md: an heutiges Sicherheitsmodell und Ablauf anpassen oder als historisch markieren (Befunde 18, 19)
  - docs/REVIEW.md: als historisch v1.25 kennzeichnen (Befund 20)
nicht_im_umfang: Skriptlogik, ci.yml (handout-viewer-Syntaxcheck als separater Kleinauftrag), Buchtext
abnahme:
  - ci-check.ps1 grün
  - keine Zeichenfolge „gilt ab Merge von PR #8“, „R14“, „2f8cd6d“ mehr in docs/ABLAUF.md
  - Stichprobe von 10 ABLAUF-Belegen stimmt mit main überein
  - git grep -n "Gemini\|NotebookLM" zeigt nur den entschiedenen Namen (außer PODCAST.md-Historie)
bericht: R34-BERICHT.md nach ops/reports
```

Hygiene: Remote-Branch `origin/quelle-pdf-werkzeuge-20261106` ist in main gemergt und kann gelöscht werden; die Branches zu R02/R14/R25/R28 sind schon entfernt. Nicht gemergt sind `auftrag-R03-buchtext-v138`, `auftrag-R15-release-pruefungen` (ohne PR), `avatare-buch-und-seite-20261106`, `geschichte-veraltete-daten-20261107`, `ops/queue`, `ops/reports`. Offene PRs: #6 Avatare (kein Draft), #9 R03 Buchtext v1.38 (Draft), #10 „Die veralteten Daten“ v1.38 (Draft); #9 und #10 zielen beide auf v1.38, Konflikt möglich.

```yaml
Reifegrad: Doku weitgehend aktuell für den Standardweg (Admin-Bereich); ABLAUF.md und Hilfsdokumente (CODEX_PROMPT, REVIEW) nachlaufend
Projektstatus:
  main: 44898de (PR #8, #11, #12, #13 gemergt)
  live_version: 1.37 vom 05.09.2026, 69 Seiten
  offene_prs: [6, 9 (Draft), 10 (Draft)]
  laufend: R15 (Release-Prüfungen, Branch ohne PR)
Offene_Fragen:
  - Podcast-Werkzeug NotebookLM oder Gemini (Owner)
  - assets/css und weitere öffentliche Dateien in die q15-FTP-Liste aufnehmen? (Owner)
  - Reihenfolge der Merges #9/#10 für v1.38
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```

> Nachtrag Koordinator (06:45): Die Hygiene-Angabe „R15 ist ein Branch ohne PR“ war zum Abfragezeitpunkt überholt; R15 hat PR #14 (offen, CI grün).
