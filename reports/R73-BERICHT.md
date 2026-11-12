# R73: Pilot-Steckbrief docs/PILOT.md (Draft-PR)

- Start: 12.11.2026, 04:48 Uhr (`date`)
- Ende: 12.11.2026, 04:55 Uhr (`date`)
- Rolle: KI-Sitzung (Claude Code, Agent) im eigenen Worktree `C:\dev\wt\relingit\r73`; der Arbeitsklon blieb unberührt auf `main`.
- Quelle: `queue/R73.yaml` auf `origin/ops/queue` (9ffaea5), Basis `origin/main` 8abe213.

## Ergebnis

| Punkt | Stand | Beleg |
| --- | --- | --- |
| Pull Request | #36, Draft, Basis `main`, Branch `auftrag-R73-pilot-steckbrief` | https://github.com/Reling-IT/relingit/pull/36 |
| Head-SHA | ef6199e8307ee1fca0dda706c9f4deaed01943dd (signiert, `%G?` = G) | `git log -1 --format='%H %G?'` |
| Änderung | `docs/PILOT.md` neu (54 Zeilen), `CLAUDE.md` plus eine Zeile | `git diff --cached --stat`: 2 Dateien, 55 Einfügungen |
| CI | grün: „Website prüfen“ pass (10 s), Zustand CLEAN | `gh pr checks 36`, Lauf 43150938608 |
| ci-check lokal | Exit 0 | `pwsh -NoProfile -File scripts/ci-check.ps1` im Worktree |
| Pester lokal | Passed: 21 Failed: 0 Skipped: 0 Pending: 0 Inconclusive: 0 (243,8 s, Pester 3.4.0) | `pwsh -NoProfile -c "Invoke-Pester tests"` im Worktree |

Kein Merge, kein Tag, kein FTP, kein Upload. Keine Änderung an Workflows, Deployment, Supabase, Admin, Buchtext oder PDFs. Gepusht wurde nur der eigene Branch. Im Standard-Repository wurde nichts geändert.

## Projektprofil

Das Projektprofil liegt in `CLAUDE.md` im Wurzelverzeichnis des Repositorys, YAML-Block `sitzungsroutine:`. Dort steht jetzt nach der Zeile `ziel:` die Zeile `steckbrief: docs/PILOT.md`. Sonst ist `CLAUDE.md` unverändert.

## Belegt (16)

| Angabe | Beleg |
| --- | --- |
| Zweck: Landingpage, Online-Lesefassung und Workshop-Handout zur Kurzgeschichte; Workshop-Vorbereitung | README.md, erster Absatz; Auftrag R73, Schritt 2 |
| Zielgruppe: Kolleginnen und Kollegen, Workshop-Teilnehmende | Auftrag R73, Schritt 2 (im Repository selbst nur das Workshop-Handout) |
| Stand: v1.38 auf main (7. November 2026, 77 Seiten), G8 verbucht, Upload steht aus, v1.39 als Entwurf | assets/js/app.js, Commit ba5a23c, PR #29 (Merge 8abe213), TAGESBERICHT-2026-11-11.md, TAGESSTART-2026-11-12.md, PR #27 und #33 |
| Start 2026-08-30 | Commit f426a21, erster Commit auf main |
| Werkzeuge: Claude (Planer), Claude Code, GitHub Actions, GitHub-CLI, PowerShell 7 mit Pester, Python, Poppler | CLAUDE.md, docs/TAGESSTART.md, queue/INDEX.yaml, docs/PDF-ERZEUGEN.md, docs/CODEX_PROMPT.md |
| Technik: statische Webseite, Supabase mit Admin-Bereich, PDF lokal erzeugt, FTP-Hosting, CI | README.md, docs/SICHERHEIT.md, scripts/pdf/, .github/workflows/ci.yml |
| Repository Reling-IT/relingit (öffentlich) | README.md |
| Funktionsumfang (Abschnitt Nutzen) | README.md |
| Erkenntnis: Tore G1 bis G8, vier ohne Automatik | docs/FREIGABE.md, PR #22, Commit 5ce8c9a |
| Erkenntnis: Warteschlange nur nach `git fetch` lesen (Doppelstart am 08.11.) | docs/TAGESSTART.md, Schritt 2 |
| Erkenntnis: Probe-Merge, Befund C1 (kein Textkonflikt, ci-check trotzdem mit Fehler) | R57-BERICHT.md |
| Erkenntnis: Trockenlauf v1.39, Pester 54/54, drei Nachzüge von Hand | R63-BERICHT.md |
| Erkenntnis: Befund F2 (G2 und G7 auf main nicht bestehbar) | R61-BERICHT.md, PR #31 |
| Erkenntnis: Pester läuft nicht in der CI | TAGESBERICHT-2026-11-11.md, VORSCHLAG-PESTER-CI.md |
| Erkenntnis: neun offene Draft-PRs am 12.11., Vorgabe drei | TAGESSTART-2026-11-12.md |
| Meilenstein: Release v1.39, Entscheidung am 16.11.2026, danach Pause bis Jahresende | Auftrag R73, Schritt 4; PR #27, PR #33, R63-BERICHT.md |

## Unklar (7)

- Tatsächliche Nutzer (keine Anzahl, keine Nutzungsdaten im Repository).
- Einordnung des Status nach der Vorlage (Experiment / Pilot / in Nutzung / eingestellt); legt der Product Owner fest.
- Öffentlich ausgelieferte Version: Der Auftrag nennt v1.37; im Repository gibt es dafür keinen Beleg (kein Tag, kein Live-Prüfbericht).
- Was die Anwendung heute kann, das vorher nicht ging.
- Wer sie zuletzt wann benutzt hat.
- Woran Nutzen gemessen wird (Profilfeld `ziel: offen`).
- Abnahmekriterium für den Meilenstein v1.39.

Dazu: Aufwand „keine Angabe“ (Tabelle und Summe; nichts geschätzt, auch nicht aus Commit-Zeiten). Die Entscheidung weiter / einfrieren / einstellen steht im Steckbrief als offene Frage an den Product Owner.

## Abweichungen

1. Vorlage: Die lokale Kopie `C:\Users\bmarn\.claude\vorlagen\pilot-steckbrief.md` weicht von der Fassung im Standard-Repository ab (Titelzeile, Verweis im Einleitungssatz, Wortlaut mehrerer Felder, Umlaute, Tabellentrenner). Die Struktur ist gleich. Verwendet wurde die Fassung aus dem Standard-Repository.
2. Die Vorlage im Standard-Repository ist ohne Umlaute geschrieben („Tatsaechliche“, „Naechster“). Der Steckbrief nutzt nach Vorgabe Umlaute und ß; die Überschriften weichen deshalb in der Schreibweise ab.
3. Das Kurzprofil hat eine dritte Spalte „Beleg“, die die Vorlage nicht vorsieht.
4. Die Vorlage verlangt keinen Personennamen. Der Steckbrief nennt nur Rollen.
5. Offene PRs aus KI-Sitzungen: mit #36 sind es elf, alle Draft (Vorgabe drei). #35 (R65) kam nach dem Tagesstart hinzu. Der Auftrag R73 beruht laut `queue/R73.yaml` auf einer Entscheidung des Product Owners vom 12.11.2026.
6. `queue/R73.yaml` und `queue/INDEX.yaml` tragen den Stand „2026-11-12 05:40“; die Systemuhr zeigte beim Start 04:48. Ursache unklar, nur gemeldet.
7. Zielgruppe und „v1.37 live“ stehen im Auftrag als belegbar. Im Repository fand sich für die Zielgruppe nur der Auftrag selbst als Quelle, für die ausgelieferte Version kein Beleg; die Version steht deshalb als unklar im Steckbrief.
8. Der Steckbrief nennt den Webhoster nicht beim Namen und enthält keine Angaben zu Kosten, Verträgen oder Restrisiken (öffentliches Repository).

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Die lokale Vorlage unter `C:\Users\bmarn\.claude\vorlagen` an die Fassung im Standard-Repository angleichen oder durch einen Verweis ersetzen, damit es nur eine Quelle gibt.
- Im Standard die Vorlage um eine Spalte „Beleg“ im Kurzprofil ergänzen; ohne sie lässt sich „nur belegte Angaben“ kaum prüfen.
- Den Status (Experiment / Pilot / in Nutzung / eingestellt) und die Zahl der tatsächlichen Nutzer beim nächsten Tagesabschluss zusammen mit den Stunden abfragen; das sind die Felder, die nur der Product Owner füllen kann.
- Nach dem Auftrag R09 (Live-Prüfung) die ausgelieferte Version mit Beleg im Steckbrief nachtragen.
- Den Steckbrief in `docs/TAGESSTART.md` (Schritt 4) als Prüfpunkt aufnehmen, sobald #36 gemergt ist; das wurde hier bewusst nicht geändert.
- Das Abnahmekriterium für v1.39 vor dem 16.11. festlegen, zum Beispiel „Tore G1 bis G8 für v1.39 belegt, Live-Prüfung ohne Muss-Befund“.

## Hygiene

Gemergte Remote-Branches: 0; offene PRs: 11 (#25 bis #28, #30 bis #36), alle Draft; neuer Worktree `C:\dev\wt\relingit\r73` bleibt stehen (Branch `auftrag-R73-pilot-steckbrief`, gleich `origin`); Arbeitsklon `main` gleich `origin/main`, sauber.

## Nachtrag des Koordinators (12.11.2026, 04:56)

Gegenprobe: Diff von #36 gelesen (zwei Dateien, +55; `docs/PILOT.md` und eine Zeile in `CLAUDE.md`), Commit ef6199e signiert, CI grün, `git merge-tree` gegen die zehn anderen offenen PR-Branches ohne Konflikt. Der Steckbrief enthält keine Stunden, keine Kosten und keine Personennamen. Hinweis: Der Steckbrief nennt „neun“ offene PRs mit Stand Tagesstart; nach dieser Sitzung sind es elf.

```yaml
Reifegrad: Pilot-Steckbrief als Draft-PR 36 (ef6199e), CI gruen, ci-check Exit 0, Pester 21/21; 16 Angaben belegt, 7 unklar, Aufwand keine Angabe
Projektstatus: PR 36 wartet auf Sichtung und Einzelfreigabe durch den Product Owner; unveraendert Upload v1.38 offen
Offene_Fragen:
  - Nach Release v1.39 weiter, einfrieren oder einstellen, und bis wann faellt die Entscheidung?
  - Einordnung des Status (Experiment, Pilot, in Nutzung, eingestellt)?
  - Tatsaechliche Nutzer und Nutzenmessung?
  - Abnahmekriterium fuer v1.39?
  - Geschaetzte Stunden (traegt nur der Product Owner ein)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung, aus dem Tagesbericht 11.11. uebernommen
```
