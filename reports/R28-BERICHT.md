---
id: R28
titel: 'Podcast-Einbindung nach main holen'
status: erledigt
start: 2026-11-07T05:34+01:00
ende: 2026-11-07T06:09+01:00
branch: 'auftrag-R28-podcast-einbindung'
pr: 'https://github.com/Reling-IT/relingit/pull/13 (offen, nicht gemergt)'
commit: '430cc14'
ci: 'grün (Website prüfen, Run 42341439046)'
---

## Ergebnis

- PR #13 bringt Podcast-Abschnitt, Player, FAQ, Datenschutz §4 und CSS aus dem Live-Stand nach main. Die Änderungen sind per `git apply` portiert, nicht kopiert. MP3 und Cover sind nicht im Repo.
- Gegen live (OneDrive-Klon) sind `datenschutz.html` und `styles.css` identisch. `index.html` weicht nur in den zwei gewollten main-Zeilen ab: Seitenzahl und Repo-Link.
- `ci-check.ps1` meldet fehlende Podcast-Dateien nur als Hinweis und lässt in der Verweisprüfung nur genau diese 5 Pfade aus. `build-upload.ps1` bricht ohne die Dateien ab. Lokal und in CI grün.
- origin/main (361f26c, mit #8, #11, #12) ist konfliktfrei hereingemergt. Der Kommentar an #8 entfällt, weil #8 schon gemergt ist.
- Offen für Bernd: NotebookLM oder Gemini. Vor dem nächsten FTP-Upload #13 mergen.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| 1 Worktree | `C:\dev\wt-r28` auf Branch `auftrag-R28-podcast-einbindung`, angelegt aus origin/main 2f8cd6d, danach main 361f26c hereingemergt (eaf072d) | `git worktree add`, `git merge origin/main` ohne Konflikt |
| 2 Portierung HTML/CSS | Diff aus dem OneDrive-Klon (nur gelesen) mit `git apply` eingespielt. `datenschutz.html` und `styles.css` hatten dort dieselbe Basis wie main, `index.html` ließ sich sauber anwenden. CRLF-Zeilenenden passen, `git diff --check` ist sauber. | Commit 4df31e8 |
| 2 Vergleich live | `datenschutz.html` und `styles.css` sind identisch. `index.html` Z. 37: `<span data-page-count>69</span> Seiten` statt `46 Seiten` (PR #4/#5). Z. 198: Link `Reling-IT/relingit` statt `bmarnau/relingit` (PR #3). Beides soll so bleiben. | `diff --strip-trailing-cr` gegen den OneDrive-Klon |
| 3 build-upload.ps1 | Lokale Fassung: 4 MP3 und das Cover stehen in `$publicFiles`. Fehlt eine Datei, bricht `Copy-Item` mit einem allgemeinen Fehler ab, und der halb angelegte Paketordner bleibt liegen. Übernommen ist dasselbe Abbruchverhalten. Der Abbruch kommt jetzt **vor** `New-Item` und nennt die fehlenden Dateien sowie `docs/PODCAST.md`. | Probe `-Suffix r28probe`: „Paket abgebrochen, Dateien fehlen: …“, kein `output/` entstanden |
| 3 ci-check.ps1 | Die lokale Fassung führte die Dateien als Pflichtdateien, damit wäre CI rot. Neu ist ein eigener Block vor der Verweisprüfung: Fehlt eine Datei, gibt es einen Hinweis. Ist sie vorhanden, wird die Kennung geprüft (MP3: ID3/0xFF, Cover: PNG). Jede der 5 Dateien muss weiter in `index.html` stehen, und die Quellenangabe „Google NotebookLM“ und „KI-generiert“ ist Pflicht. In der Verweisschleife gibt es eine Zeile Ausnahme, nur für `index.html` und nur für die fehlenden bekannten Pfade. | Commit 9b46859; Gegenprobe mit falschem Pfad: „Fehlender lokaler Verweis in index.html: assets/audio/gibtsnicht.mp3“ |
| 3 Überschneidung PR #8 | #8 ist inzwischen gemergt. R02 fügte `Test-StoryCompleteness` nach dem Seitenzahl-Block ein und änderte die Abschluss-Ausgabe. R28 steht davon getrennt: Block Z. 336–373, Verweisschleife Z. 393 f., Hinweis Z. 440–445 (main-Zählung). Die Abschlusszeile ist unverändert. `build-upload.ps1` hat #8 nicht berührt. | `git merge-tree` vor dem Merge ohne Konflikt; Probe-Merge und echter Merge, ci-check grün |
| 4 docs/PODCAST.md | Enthält Dateinamen, Größen, SHA-256 (aus R23), Dauer, Ablageort, Einbindungspfade, Live-URL, Skriptverhalten, die Regel „nur neu erzeugen, wenn der Erzähltext geändert wurde“, die offene Frage und den Sicherungsvorschlag. Dazu je ein Hinweis in README und DOMAINFACTORY-DEPLOYMENT. | Commits 05d9ea9, 430cc14 |
| 4 .gitignore | `assets/audio/*.mp3` und `assets/img/reling-it-podcast-cover.png` ergänzt | `git check-ignore -v` trifft beide |
| 5 ci-check lokal | Ohne `assets/audio`: „Hinweis: 5 von 5 Podcast-Dateien liegen nicht vor …“, danach „OK: 11 HTML-Dateien, … lokale Links, PDFs und Secret-Schutz geprüft.“, Exit 0. Ein Lauf mit Dateien war ohne Kopieren nicht möglich, deshalb nicht durchgeführt. | `pwsh -NoProfile -File scripts/ci-check.ps1` |
| 6 PR, CI | PR #13 ist offen. CI „Website prüfen“ ist grün, das Log zeigt dieselbe Hinweiszeile. Der CI-Kommentar ist gesetzt. | PR-Kommentar 6702643819 |
| 7 Sicherung | Nur als Vorschlag, siehe unten. Kein Release angelegt. | – |

## Offene Fragen, Risiken, Abweichungen

- **Owner-Frage NotebookLM/Gemini:** Live, `datenschutz.html`, `index.html` und `ci-check.ps1` nennen Google NotebookLM. `docs/NEUE-GESCHICHTE.md` §6 und `docs/vorlagen/EINBAU-CHECKLISTE.md` (beide jetzt auf main) nennen Google Gemini. Ich habe das nicht entschieden, der Live-Text ist wortgleich übernommen.
- **Risiko bleibt bis zum Merge:** Ein FTP-Paket aus main ohne #13 entfernt den Podcast live. Mit #13 bricht das Paket ab, wenn die 5 Dateien lokal fehlen. Sie müssen vor dem Paketbau aus OneDrive in den Arbeitsklon kopiert werden.
- **Abweichung zu R23:** R23 empfahl, das Cover (1 MB) zu committen. Laut Auftrag bleibt es außerhalb des Repos und ist ebenfalls ignoriert. Wenn Bernd das anders will, reichen eine Zeile in `.gitignore` und `git add`.
- **Abweichung zu R23:** Statt `assets/audio/SHA256SUMS.txt` stehen die Prüfsummen in `docs/PODCAST.md`. ci-check prüft keine Hashes, sonst müsste ci-check bei jeder neuen Folge angepasst werden.
- **Überschneidung R15 (parallel):** R15 ändert `ci-check.ps1` (Ausnahme `output/`) und `publish-release.ps1`. R28 fasst die Dateisuchen mit `archive|output|tmp` nicht an, ein Konflikt ist nur in der Nähe von Z. 336 bzw. 440 denkbar. `publish-release.ps1` ruft `build-upload.ps1` auf und bricht damit ohne Podcast-Dateien ebenfalls ab. Das ist gewollt, R15 sollte es aber wissen.
- `publish-release.ps1` wird dadurch auch bei einer reinen Buchfassung (Admin-Weg) abbrechen, sobald es das FTP-Paket baut und die MP3 im Klon fehlen. Das ist tragbar, sollte aber in NEUE-GESCHICHTE erwähnt werden (nicht geändert, um R15 nicht zu stören).
- Der OneDrive-Klon wurde nur gelesen (`git status`, `git diff`, Dateien). Er steht weiter auf dem gelöschten Branch mit uncommitteten Änderungen. Nach dem Merge von #13 sollte Bernd ihn auf main bringen. Den Weg dafür muss Bernd selbst festlegen, weil die MP3 dort unversioniert liegen und nach dem Merge ignoriert sind.

## Vorschläge und Ideen (Claude)

- **MP3 zusätzlich sichern (nur Vorschlag):** GitHub-Release `podcast-2026-10` ohne Code-Tag-Bedeutung anlegen und die 4 MP3 plus Cover als Assets hochladen (`gh release create podcast-2026-10 --notes-file docs/PODCAST.md <dateien>`). Danach Hashes gegen `docs/PODCAST.md` prüfen. Die Assets wären öffentlich, das ist inhaltlich unkritisch. Ergänzend eine Offline-Kopie auf einer externen Platte, weil OneDrive mitlöscht.
- `build-upload.ps1 -OhneAudio` als bewusster Schalter für reine Textkorrekturen. Dann müssen die 71 MiB nicht jedes Mal mit, und das Paket enthält einen deutlichen Vermerk im Manifest.
- Optional prüft `build-upload.ps1` die SHA-256 der MP3 gegen eine maschinenlesbare Liste, z. B. einen Block in `docs/PODCAST.md` oder eine eigene `SHA256SUMS.txt`.
- Größenangaben auf der Seite in „MiB“ ändern oder auf MB umrechnen (Hinweis aus R23).
- Nach Klärung NotebookLM/Gemini die Begriffe in einem PR vereinheitlichen. Betroffen wären datenschutz, index (Quellenangabe, FAQ), ci-check, NEUE-GESCHICHTE und die Checkliste.

Hygiene: Gemergt, aber auf dem Remote noch vorhanden ist `origin/quelle-pdf-werkzeuge-20261106` (Inhalt durch #11 in main, löschbar nach Owner-OK). Offene PRs sind #13 (R28), #6 (Avatare), #10 und #9 (beide Draft). `ops/queue` und `ops/reports` sind Betriebsbranches. Lokale Worktrees wt-r14/wt-r25 gehören zu gemergten PRs und lassen sich aufräumen.

```yaml
Reifegrad: 'Podcast-Einbindung versioniert (PR #13, CI grün); Audiodateien weiter nur in OneDrive, Paketbau bricht ohne sie ab'
Projektstatus: 'PR #13 wartet auf Merge; vor nächstem FTP-Upload mergen'
Offene_Fragen:
  - 'Podcast-Werkzeug: Google NotebookLM (live, Datenschutz) oder Google Gemini (NEUE-GESCHICHTE, Checkliste)?'
  - 'Cover-PNG doch versionieren (R23-Empfehlung) oder wie jetzt außerhalb lassen?'
  - 'Sicherung der MP3 als GitHub-Release-Asset freigeben?'
  - 'OneDrive-Klon nach Merge auf main bringen (Vorgehen durch Owner)'
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: 'unbelegte Schätzung'
```
