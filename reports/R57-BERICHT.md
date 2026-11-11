# R57-Bericht: Kreuzprüfung der sieben Drafts per Probe-Merge

Datum: 11.11.2026
Rolle: KI-Sitzung (Claude Code), nur lesend. Kein Push, kein Merge, kein Tag, kein Upload, keine Änderung an Branches. Erweitert um #33 (R41) und Reihenfolge D auf Wunsch des Product Owners.

## Basis und Heads

Nach `git fetch origin` gegen `gh pr list` geprüft. Alle Heads entsprechen den Angaben im Auftrag. Keiner weicht ab.

| PR | Branch | Head | Merge-Basis |
|---|---|---|---|
| Basis | origin/main | 8abe213 | – |
| #25 | auftrag-R11-avatare-webseite | d1257f7 | 8abe213 |
| #26 | auftrag-R07-anhang-seite | 2133502 | 8abe213 |
| #27 | auftrag-R06-standards-box-v139 | 8ea4c62 | 8abe213 |
| #28 | auftrag-R49-aufbewahrung | 81f8e48 | 8abe213 |
| #30 | auftrag-R55-ordner-hash | 586404f | 8abe213 |
| #31 | auftrag-R54-g6-ohne-audio | b2bc305 | 8abe213 |
| #32 | auftrag-R56-aufraeumen-pruefen | 35c2d44 | 8abe213 |
| #33 | auftrag-R41-buchkontraste | ecfbebb | 8abe213 |

Alle acht Branches setzen direkt auf 8abe213 auf. Darum ist 8abe213 in jedem Schritt die richtige Merge-Basis.

## Vorgehen

- Wegwerf-Worktrees unter dem Scratchpad: `git -C C:/dev/relingit worktree add --detach <scratchpad>/r57-<x> origin/main`. Es wurden keine Commits angelegt, auch keine lokalen Merge-Commits. Damit war keine Signatur nötig, und es entstand kein Ref.
- Je Schritt kumulativ: `git merge-tree --write-tree --name-only --merge-base=8abe213 <Baum bisher> origin/<branch>`. Exit 1 bedeutet Konflikt, die Datei steht in der Ausgabe. Danach `git -C <wt> read-tree -u --reset <Baum>`.
- Probe-Auflösung und Probe-Nachzug: Datei im Worktree bearbeitet, `git add -A` und `git write-tree` ergeben den neuen Baum. Weiter ging es auf diesem Baum.
- Prüfung je Stand mit einem eigenen Skript `pruefe.ps1` im Scratchpad:
  - `pwsh -NoProfile -File <wt>/scripts/ci-check.ps1`, ausgewertet wird `$LASTEXITCODE`;
  - `Invoke-Pester -Path tests -PassThru` in `<wt>`, gezählt werden PassedCount/TotalCount/FailedCount. Lokal ist nur Pester 3.4.0 vorhanden; laut README ist das zulässig.
- Umgebung: pdftotext (Poppler 25.07) vorhanden. Kein Test wurde übersprungen (skipped=0 und pending=0 in allen Läufen). Die 4 fehlenden Podcast-MP3 sind ein Hinweis von ci-check, kein Fehler, und auf main gleich.
- Pester baut ein Mini-Projekt aus `tests/fixtures`. Gelesen werden nur `scripts/*` und `assets/audio/SHA256SUMS.txt` aus dem Repo, nicht `anhang.html` oder die Buchquelle. Der Pester-Wert ist darum mit und ohne C1-Nachzug derselbe.
- Gleiche Bäume habe ich nicht doppelt geprüft. Der Hash ist jeweils angegeben: A1=B1=C1=D1, A2=B2=D2, A4(roh)=B4(roh)=D4(roh), A5–A7=B5–B7, C7 mit Nachzug = A7.
- Aufräumen: alle neun Wegwerf-Worktrees mit `git worktree remove --force` entfernt, danach `git worktree prune`. `git worktree list` zeigt danach nur C:/dev/relingit, C:/dev/wt-r06, C:/dev/wt-r41 und C:/dev/wt-rep. Der Arbeitsklon steht unverändert auf main 8abe213, `git status --short` ist leer.

## Baseline main (8abe213)

| Prüfung | Ergebnis |
|---|---|
| ci-check.ps1 | Exit 0 („OK: 11 HTML-Dateien …“) |
| Pester | 21/21 bestanden, failed=0, skipped=0 |
| PR-CI auf GitHub („Website prüfen“) | #25–#32 SUCCESS, #33 FAILURE (beides Einzelstand gegen main) |

## Reihenfolge A: #25, #28, #26, #27, #30, #31, #32

| Schritt | PR | Konflikte (Datei) | ci-check Exit | Pester | Befund |
|---|---|---|---|---|---|
| A1 | #25 | keine | 0 | 21/21 | Baum c2fa03a |
| A2 | #28 | keine | 0 | 28/28 | Baum bc607c9 |
| A3 | #26 | keine | 0 | 30/30 | 12 HTML-Dateien (anhang.html neu) |
| A4 | #27 | keine (textlich) | **1** (roh), 0 nach Probe-Nachzug | 30/30 | **C1**: genau 1 Fehler, „Versionsangabe in anhang.html weicht von lesen.html ab“. Probe-Nachzug: anhang.html auf „Version 1.39 · 9. November 2026“, danach Exit 0 (Baum 8ed665b) |
| A5 | #30 | keine | 0 | 35/35 | lief unter Annahme C1-Nachzug |
| A6 | #31 | keine | 0 | 39/39 | lief unter Annahme C1-Nachzug |
| A7 | #32 | **docs/ABLAUF.md** | 0 (nach Probe-Auflösung) | 45/45 | Textkonflikt R55- gegen R56-Abschnitt an derselben Stelle. Probe-Auflösung: beide Abschnitte behalten, R55 vor R56. README.md wird mit #26 automatisch gemergt. Endbaum 05b5e8d |

## Reihenfolge B: #25, #28, #27, #26, #30, #31, #32

| Schritt | PR | Konflikte (Datei) | ci-check Exit | Pester | Befund |
|---|---|---|---|---|---|
| B1 | #25 | keine | 0 | 21/21 | = A1 |
| B2 | #28 | keine | 0 | 28/28 | = A2 |
| B3 | #27 | keine | 0 | 28/28 | v1.39 allein ist stimmig (Baum 9aee1a0) |
| B4 | #26 | keine (textlich) | **1** (roh) | 30/30 | **C1** in umgekehrter Richtung: Baum identisch mit A4 roh (eb78625), gleicher einzelner Fehler. Der Nachzug gehört hier in #26: anhang.html auf 1.39 / 9. November 2026 |
| B5 | #30 | keine | 0 | 35/35 | = A5, unter Annahme C1-Nachzug |
| B6 | #31 | keine | 0 | 39/39 | = A6 |
| B7 | #32 | **docs/ABLAUF.md** | 0 (Probe-Auflösung) | 45/45 | = A7 |

## Reihenfolge C (Tagesbericht 10.11.): #25, #31, #28, #30, #32, #26, #27

| Schritt | PR | Konflikte (Datei) | ci-check Exit | Pester | Befund |
|---|---|---|---|---|---|
| C1 | #25 | keine | 0 | 21/21 | = A1 |
| C2 | #31 | keine | 0 | 25/25 | #31 früh ist unproblematisch |
| C3 | #28 | keine | 0 | 32/32 | |
| C4 | #30 | keine | 0 | 37/37 | |
| C5 | #32 | **docs/ABLAUF.md** | 0 (Probe-Auflösung) | 43/43 | gleicher Konflikt, gleiche Probe-Auflösung |
| C6 | #26 | keine | 0 | 44/45, Wiederholung 45/45 | 1 Fehlschlag im ersten Lauf: Test aus #32 „erkennt Vorfahren, Squash per patch-id …“, Zeile `inhalt`. Im zweiten Lauf auf demselben Baum bestanden. Der Test ist instabil (Befund 4), kein Merge-Problem |
| C7 | #27 | keine (textlich) | **1** (roh), 0 nach Probe-Nachzug | 45/45 | **C1** wie A4. Mit Nachzug ist der Baum identisch mit dem Endbaum A7 (05b5e8d) |

## Reihenfolge D (PO-Erweiterung): #25, #28, #26, #27, #33, #30, #31, #32

| Schritt | PR | Konflikte (Datei) | ci-check Exit | Pester | Befund |
|---|---|---|---|---|---|
| D1–D3 | #25, #28, #26 | keine | 0 | 21 → 28 → 30, alle bestanden | = A1–A3 |
| D4 | #27 | keine (textlich) | **1** (roh), 0 nach Probe-Nachzug | 30/30 | C1, = A4 |
| D5 | #33 | keine (textlich, obwohl #27 und #33 dieselbe Buchquelle ändern) | **1** | 30/30 | Roh auf D4 ohne C1-Nachzug: genau **2** Fehler, C1 und „Veröffentlichungsfassung ist nicht aktuell: story/current/fahrt-zum-kunden.html weicht von source/fahrt-zum-kunden.html ab“. Auf D4 mit C1-Nachzug bleibt genau **1** Fehler, der story/current-Fehler. **Probe-Nachzug:** story/current/fahrt-zum-kunden.html aus source/ kopiert, danach Exit 0 (Baum 41fbac9) |
| D6 | #30 | keine | 0 | 35/35 | lief unter Annahme C1- und story/current-Nachzug |
| D7 | #31 | keine | 0 | 39/39 | dto. |
| D8 | #32 | **docs/ABLAUF.md** | 0 (Probe-Auflösung) | 45/45 | Endbaum 0b304ad. Er unterscheidet sich von A7 nur in source/ und story/current/fahrt-zum-kunden.html (je 7+/5−) |

Gegenprobe #33 allein auf main: ci-check Exit 1 mit genau 1 Fehler (story/current weicht von source ab). Das deckt sich mit der roten PR-CI und mit der Erwartung des PO.

## Befunde

1. **muss – C1 bestätigt, in beiden Richtungen.** Sobald #26 und #27 zusammen auf main sind, endet ci-check mit Exit 1 und genau einem Fehler: „Versionsangabe in anhang.html weicht von lesen.html ab“. Das gilt für A4, B4, C7 und D4. Der zweite der beiden PRs braucht einen Nachzug in `anhang.html`, Zeile `id="story-release"`, auf „Version 1.39 · 9. November 2026“. Belegt ist, dass dieser eine Zeilenwechsel reicht: danach Exit 0. Laut PO übernimmt R60 diesen Nachzug.
2. **muss – Textkonflikt #30 + #32 in docs/ABLAUF.md.** Er tritt in jeder Reihenfolge auf, und zwar beim zweiten der beiden PRs. Beide fügen an derselben Stelle (nach Zeile 80, vor „## Belegtabelle“) einen eigenen Abschnitt ein. Die Abschnitte sind unabhängig voneinander. Die Probe-Auflösung „beide behalten“ ergibt ci-check Exit 0 und Pester 45/45. Nachzug: den zweiten PR auf main aktualisieren und beide Abschnitte behalten.
3. **muss – #33 braucht story/current.** Allein und in Reihenfolge D ist ci-check rot. Nach #27 + #33 treten ohne C1-Nachzug genau 2 Fehler auf (C1 und story/current), mit C1-Nachzug genau 1. Weitere Fehler gibt es nicht, auch nicht aus der Anhang-ID-Prüfung von #26 auf der geänderten Buchquelle. Nach dem Probe-Kopieren von source/ nach story/current/ bleiben alle Folgeschritte grün. Nachzug laut PO in R60 („v1.39 rendern“).
4. **sollte – Instabiler Pester-Test in #32.** In tests/aufraeumen-pruefen.Tests.ps1 schlug „erkennt Vorfahren, Squash per patch-id, identischen Inhalt und offene Branches“ einmal fehl (C6: 44/45). Auf demselben Baum lief er danach mit 45/45 durch, und in A7, B7, C5, C7 und D8 bestand er ebenfalls. Wahrscheinliche Ursache ist der Testaufbau (Zeilen 64–67). Auf `main` und auf `inhalt` entsteht je ein Commit `d.txt` mit gleichem Elternteil, Baum, Autor und gleicher Nachricht. Fallen beide in dieselbe Sekunde, haben sie denselben Hash. `inhalt` ist dann ein Vorfahre („löschbar: git branch -d“) statt „Squash-gleich“. Vorschlag: eine andere Commit-Nachricht oder ein fester, verschiedener `GIT_COMMITTER_DATE`.
5. **sollte – Grüne PR-CI deckt die Kombinationen nicht ab.** #25–#32 sind einzeln grün („Website prüfen“ SUCCESS), trotzdem ergibt die Kombination #26 + #27 rot. Pester läuft in der CI nicht. Gemessen ist nur, dass Pester in allen Schritten grün war, außer dem instabilen Lauf aus Befund 4. Nach jedem Merge müssen die übrigen PRs auf main aktualisiert werden, und ihre CI muss neu laufen.
6. **kann – ci-check prüft das PDF nicht gegen die HTML-Farben.** Nach #33 und dem kopierten story/current-Stand ist ci-check grün, obwohl `geschichte.pdf` noch die alten Farben trägt. R60 muss das PDF neu rendern, das ist eine Sichtprüfung. Die Versionsangaben im Endstand stimmen überein: lesen.html und anhang.html (nach Nachzug) „Version 1.39 · 9. November 2026“, app.js 1.39 / 9. November 2026 / 80 Seiten, index.html 80, Deckblatt der Buchquelle 09.11.2026, source und story/current bytegleich (HTML und PDF, Endbaum A7).
7. **kann – #31 früh oder spät ist gleichgültig.** Reihenfolge C ist bis auf C1 genauso tragfähig wie A. #31 berührt nur Freigabe-Dateien und hat keine Überschneidung.

## Empfehlung Merge-Reihenfolge mit Nachzügen

Empfohlen ist Reihenfolge D, also A mit #33 als eigenem Schritt nach #27. Nach jedem Merge den nächsten PR auf main aktualisieren und seine CI abwarten.

1. #25 (R11). Kein Nachzug.
2. #28 (R49). Kein Nachzug.
3. #26 (R07/R46). Kein Nachzug.
4. #27 (R06, v1.39). **Nachzug C1:** anhang.html auf „Version 1.39 · 9. November 2026“, laut PO über R60. Ohne Nachzug ist main rot.
5. #33 (R41). **Nachzug:** story/current/fahrt-zum-kunden.html aus source/ übernehmen und das PDF neu rendern (R60). #27, #33 und R60 lassen sich als ein Schritt mergen, dann wird main nicht zwischendurch rot.
6. #30 (R55). Kein Nachzug.
7. #31 (R54). Kein Nachzug. Die Position ist frei wählbar, auch Platz 2 wie in C.
8. #32 (R56). **Nachzug:** auf main aktualisieren und den Konflikt in docs/ABLAUF.md lösen, beide Abschnitte behalten (R55 vor R56). Den instabilen Test (Befund 4) sollte #32 vorher stabilisieren.

Die Reihenfolge aus dem Tagesbericht vom 10.11. (C) passt ebenfalls. Bei ihr sind dieselben Nachzüge nötig: der ABLAUF-Konflikt bei #32 und C1 bei #27 als letztem Schritt.

## Vorschläge und Ideen (Claude)

- Kumulativen Probe-Merge-Lauf als Skript (etwa `scripts/kreuzpruefung.ps1`): Reihenfolge als Parameter, `merge-tree --write-tree --merge-base`, Ausgabe als Markdown-Tabelle. Damit lässt sich diese Prüfung vor jeder Merge-Runde in wenigen Minuten wiederholen.
- `publish-release.ps1` aus #26 setzt anhang.html bereits mit. Versionssprünge per Hand (wie in #27) vermeiden, dann entsteht C1 gar nicht erst.
- Pester in die CI aufnehmen, als eigener Job ohne Pflichtstatus. Dann fallen instabile Tests wie Befund 4 früher auf.
- In docs/ABLAUF.md je Skript eine eigene Datei oder eine feste Einfügestelle je Abschnitt vorsehen. Parallele Aufträge stoßen dann nicht an derselben Zeile zusammen.

Hygiene: Auf origin sind außer main keine in main gemergten Remote-Branches vorhanden (`git branch -r --merged origin/main`). Offen sind 8 PRs, alle als Draft (#25–#28, #30–#33).

```yaml
Reifegrad: Kreuzpruefung belegt; alle Reihenfolgen mit 3 bekannten Nachzuegen (C1, story/current, ABLAUF.md) gruen bis Endstand, Pester 45/45
Projektstatus:
  main: 8abe213, ci-check Exit 0, Pester 21/21
  offene_PRs: 8 (alle Draft)
  Endstand_Probe: ci-check Exit 0, Pester 45/45 (unter Probe-Nachzuegen)
Offene_Fragen:
  - Werden #27, #33 und R60 als ein Schritt gemergt, damit main nicht zwischendurch rot wird?
  - Wer stabilisiert den instabilen Test in #32 vor dem Merge?
  - Soll Pester als nicht verpflichtender CI-Job laufen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```

## Nachtrag 11.11.2026: Entscheidung des Product Owners

| Frage | Entscheidung |
|---|---|
| #27, #33 und R60 als ein Schritt mergen, damit main nicht zwischendurch rot ist? | **ja** – ein Block unmittelbar nacheinander |
| Wer stabilisiert den instabilen Test in #32? | offen |

Für den Planer: R60 sollte den Block ausdrücklich enthalten (Reihenfolge #27 → #33 → Nachzug Lesefassung, PDF, anhang.html 1.39, ADF-Zeile, C2), mit ci-check und Pester nach jedem Schritt; Merge jeweils nur nach Einzelfreigabe.
