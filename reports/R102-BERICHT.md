# R102: Lesender Abgleich Abstimmungsseite, Projektdoku und Git-Stand

Auftrag: `queue/R102.yaml` (`ops/queue` 2b633e6). Start durch den Product Owner im Chat am 27.11.2026. Ausgeführt von Claude Code (Opus) im Arbeitsklon `C:\dev\relingit`. Nur gelesen: kein PR, kein Merge, kein Tag, keine Löschung, `git:hygiene` ohne `--fix`. Abrufe am 27.11.2026 zwischen 05:24 und 05:30 (MEZ), je Zeile genannt.

Gelesen: Abstimmungsseite (privates claude.ai-Artefakt „Reling IT Abstimmung“, Version 1795753229-4450, Stand der Seite 27.11.2026 07:00), `origin/main` 0a158a8 von Reling-IT/relingit, Live-Seite, GitHub-API, lokale Klone.

## Kennzahlen

| Repository | Gemergte Remote-Branches | Offene PRs | davon Drafts | Tags | Lokaler Klon | Abruf |
|---|---|---|---|---|---|---|
| Reling-IT/relingit | 0 (nur `main`, `ops/queue`, `ops/reports`) | 0 | 0 | `v1.40`, `podcast-2026-10`, `v0.1.0` | `main` 2 hinter `origin/main`, sauber | 05:24 |
| bmarnau-standards/ki-agenten-standard | 0 | 3 (#1, #2, #3) | 3 | keine | `main` gleich `origin/main` 6d59225, sauber | 05:25 |
| bmarnau/sysingdashboard (`npm run git:hygiene`, ohne `--fix`) | 0 | 5 (#124, #155, #298, #301, #308) | 4 | zuletzt `v1.65.0` | sauber, 3 Ordner nicht eingecheckt und nicht ignoriert | 05:25 |

## Aussagen der Seite gegen Git

| Nr. | Aussage der Seite | Ergebnis | Beleg (Abruf 27.11.2026) |
|---|---|---|---|
| 1 | Live v1.40, 80 Seiten | stimmt | Live-PDF 80 Seiten, SHA-256 gleich `origin/main:story/current/geschichte.pdf` (c421ed71…26ae1); Live-`app.js` Rückfallwert 1.40 / 80 (05:24) |
| 2 | Tag v1.40 auf 84ae342 | stimmt | `git rev-list -n1 v1.40` = 84ae3427 (annotierter Tag) |
| 3 | Startseite nennt aktuelle Seitenzahl (V1) | stimmt, V1 geschlossen | Live-`index.html` `<span data-page-count>80`; `scripts/publish-release.ps1` Z. 155–159 setzt die Zahl in `index.html` |
| 4 | Release-Kette `publish-release.ps1` und `ci-check.ps1` | stimmt | beide auf `origin/main`; `ci-check.ps1` Z. 228 Vollständigkeit der Buchquelle |
| 5 | Admin-Bereich mit Supabase ist Standardweg | stimmt | `README.md` Z. 29 |
| 6 | Auftrag A: Repo-Links auf Reling-IT/relingit | stimmt | Live-`index.html`: 1 Link `github.com/Reling-IT/relingit`, 0 auf den alten Pfad; `git grep bmarnau/relingit origin/main` ohne Treffer außerhalb `reports` |
| 7 | #42, #43, #44, #46 gemergt, main 0a158a8, CI grün | stimmt | `gh pr view`: gemergt 23./24.11.; Lauf „Website CI“ auf 0a158a8 success (24.11. 06:07 UTC) |
| 8 | keine offenen PRs in relingit | stimmt | `gh pr list --state open`: leer |
| 9 | PR #1 im ki-agenten-standard ist ein Entwurf | stimmt | #1 offen, Draft, Head a355a80 |
| 10 | Standards-Erfahrungsblätter gemergt | teilweise | Supabase-Blätter gemergt (identity-rbac-standard #14, resilience-recovery #6, 23.11.); Blätter „KI-Agenten aus Reling IT“ offen: ADG #54, ai-act-compliance #18, dsgvo-compliance #20, identity-rbac-standard #15, security-standard #29 |
| 11 | Sysingboard 1.70.0 | stimmt | `package.json`/`CHANGELOG.md` „1.70.0 – 2026-11-05“ auf `origin/main` 4be6f49 |
| 12 | Hub 1.6.6 (Reiter Figuren, Repos-Tabelle, Diagramm) | weicht ab | `package.json` und `CHANGELOG.md` auf `origin/main` 59c8526: 1.10.0 (23.11.); an anderer Stelle nennt die Seite selbst 1.10.0 |

## Lücken V1 bis V6 (Seite: „nicht neu gegen das Repo geprüft“)

| Lücke | Stand | Beleg |
|---|---|---|
| V1 feste Seitenzahl in `index.html` | geschlossen | Zeile 3 oben |
| V2 Vollständigkeitsprüfung im CI | geschlossen | `ci-check.ps1` Z. 228 ff. |
| V3 PDF separat gebaut | offen | `scripts/pdf/render_story_pdf.py` vorhanden; `publish-release.ps1` liest `source/Die-Fahrt-zum-Kunden.pdf` (Z. 33) und ruft das Rendern nicht auf |
| V4 Podcast-Schritt und Ablage | geschlossen | `docs/PODCAST.md` (Ablage `assets/audio`, Prüfsummen); `docs/NEUE-GESCHICHTE.md` Abschnitt 6 |
| V5 zwei Veröffentlichungswege | geschlossen | `README.md` Z. 29 |
| V6 Anhang-Seite in CI und Paket | geschlossen | `ci-check.ps1` Z. 9 und 107 ff.; `build-upload.ps1` Z. 47 f. |

## Befunde

| Nr. | Fundstelle | Befund | Beleg | Vorschlag | Schweregrad |
|---|---|---|---|---|---|
| B1 | Seite, Reiter Figuren, Tabelle „Repos und ihre Rolle“, Zeile relingit | „Live v1.37 (69 Seiten); main v1.39; Upload offen“ ist veraltet | Aussagen 1, 2 | auf „v1.40 live, 80 Seiten“ setzen | Soll |
| B2 | Seite, Reiter Figuren und Diagramm | Hub 1.6.6 statt 1.10.0; widerspricht der eigenen Angabe weiter unten | Aussage 12 | Version an allen Stellen aus einer Angabe | Soll |
| B3 | Seite, Tabelle Bestand, Zeile Startseite | „Live-Seite verlinkt noch den alten Repo-Pfad“ und „Seitenzahl … nicht geprüft“ sind überholt | Aussagen 3, 6 | Satz streichen | Soll |
| B4 | Seite, Kopfzeile | „Standards-Erfahrungsblätter gemergt“ gilt nur für die Supabase-Blätter | Aussage 10 | „Supabase-Blätter gemergt, KI-Agenten-Blätter in 5 PRs offen“ | Soll |
| B5 | Seite, Ablauf „Lücken V1 bis V6“ | Abschnitt als „zu prüfen“ markiert | Tabelle V1–V6 | V1, V2, V4, V5, V6 als geschlossen kennzeichnen, V3 offen lassen | Soll |
| B6 | `queue/R102.yaml`, Schritte 1 und Ziel (4) | CURRENT-STATUS, Tracker, Merge-Checkliste, BACKLOG, Tagebuch und `npm run git:hygiene` gibt es nur in bmarnau/sysingdashboard, nicht in relingit | `git ls-tree origin/main` beider Repos | im Auftrag das Repository nennen; hier dort gelesen | Soll |
| B7 | Seite, Lücke V4 | nennt Google Gemini, `NEUE-GESCHICHTE.md` nennt Google NotebookLM | `docs/NEUE-GESCHICHTE.md` Z. 110 | Werkzeugname angleichen | Kann |
| B8 | sysingdashboard `docs/BACKLOG.md` | Kopf „Stand: 2026-11-16“, letzter Commit der Datei 23.11. | `git log -1 -- docs/BACKLOG.md` 5c2748d | Stand nachziehen (im dortigen Projekt) | Kann |
| B9 | sysingdashboard `docs/MERGE-CHECKLISTE-GOLDEN-GATE.md` | Liste offener PRs vom 17.11., #308 fehlt | `gh pr list` 05:25 | beim nächsten Tagesbündel dort nachziehen | Kann |
| B10 | Tags sysingdashboard und hub | letzter Tag `v1.65.0` bzw. `v1.8.0`, Version 1.70.0 bzw. 1.10.0 | `git describe --tags` | nur melden; Tagging ist Sache der Projekte | Kann |

Doku sysingdashboard gegen Git: `docs/CURRENT-STATUS.md`, `docs/ENTWICKLUNGSTAGEBUCH.md` und `docs/GOLDEN-GATE-EXECUTION-TRACKER.yaml` tragen Stand 24.11.; der letzte Commit auf `origin/main` ist vom 24.11. (4be6f49, Merge #307). Keine Abweichung über 14 Tage.

## Hinweise

- ki-agenten-standard: 3 offene Entwurfs-PRs aus KI-Sitzungen; die Grenze von 3 ist erreicht.
- sysingdashboard: 5 offene PRs; ob alle aus KI-Sitzungen stammen, ist hier nicht geprüft.
- relingit lokal: Worktrees `r87-teil2` und `r92-backup` sowie die lokalen Branches `auftrag-R87-teil2`, `auftrag-R92-backup` und `pilot-2026-11-23` gehören zu gemergten, auf GitHub gelöschten Branches. Nichts entfernt (Auftrag R93 bzw. R13).

## Vorschläge für neue Aufträge

Keine Muss-Befunde, daher keine Pflichtvorschläge. Empfehlung (Claude): B1 bis B5 und B7 in einem Durchgang an der Abstimmungsseite durch die Planer-Session; B6 beim nächsten Auftrag dieser Art im Auftragstext berücksichtigen.

## Vorschläge und Ideen (Claude)

- Die App-Versionen auf der Seite aus einer Stelle speisen (eine Tabelle, auf die Diagramm und Texte verweisen), damit B2 nicht wieder entsteht.
- Den lesenden Abgleich zur Wiederholung vor jedem Workshop oder Release einplanen; die Kennzahlentabelle oben lässt sich direkt fortschreiben.
