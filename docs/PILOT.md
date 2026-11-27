# Pilot-Steckbrief: Die Fahrt zum Kunden (Reling IT)

Vorlage nach `REPOSITORY_BASISHYGIENE.md` („Mindestausstattung je Art“) und `SITZUNGSROUTINE.md` (TA-09) aus `bmarnau-standards/ai-development-governance`, Datei `vorlagen/pilot-steckbrief.md`. Ablage im Repository als `docs/PILOT.md`, Pfad im Projektprofil (`steckbrief` in [CLAUDE.md](../CLAUDE.md)). Nur belegte Angaben; Unbekanntes als `unklar`.

Stand: 27.11.2026 (Tagesabschluss, Stunden 24. und 27.11.), korrigiert am 24.11.2026 (Auftrag R92), angelegt am 12.11.2026 mit Auftrag R73 (`queue/R73.yaml` auf dem Branch `ops/queue`). Berichte, auf die verwiesen wird, liegen unter `reports/` auf dem Branch `ops/reports`.

## Kurzprofil

| Feld | Angabe | Beleg |
| --- | --- | --- |
| Zweck (ein Satz) | Landingpage, Online-Lesefassung und Workshop-Handout zur fortlaufenden Kurzgeschichte „Die Fahrt zum Kunden“; laut Auftrag dienen die Kurzgeschichten der Workshop-Vorbereitung. | [README.md](../README.md), erster Absatz; Auftrag R73, Schritt 2 |
| Zielgruppe | Kolleginnen und Kollegen sowie Workshop-Teilnehmende. Im Repository selbst steht dazu nur das Workshop-Handout; eine Beschreibung der Zielgruppe fehlt dort. | Auftrag R73, Schritt 2; [README.md](../README.md) |
| Tatsächliche Nutzer | unklar (keine Anzahl und keine Nutzungsdaten im Repository) | – |
| Status | Pilot (Entscheidung des Product Owners vom 12.11.2026). Belegter Stand: Version 1.40 (16. November 2026, 80 Seiten) ist live, auf dem Webspace und in Supabase, live geprüft am 23.11.2026 (R09, R89) und als `v1.40` auf 84ae342 getaggt (R88). Supabase stand vor der Aktualisierung auf 1.37 (R09); ob Version 1.39 vorher auf dem Webspace lag, ist unklar. Tag v1.39 entfällt (Entscheidung Product Owner 23.11.2026, R52 erledigt). | `queue/R73.yaml` (Feld `entscheidungen_bernd_2026_11_12`); `queue/R52.yaml` (Feld `entscheidung_bernd_2026_11_23`); PR #41 (Merge 84ae342); R09-NACHPRUEFUNG-v1.40.md, R89-BERICHT.md, R88-BERICHT.md; TAGESBERICHT-2026-11-23.md |
| Start | 2026-08-30 (erster Commit auf `main`) | Commit f426a21 |
| Werkzeuge | Claude als Planer (Warteschlange) und Claude Code als ausführende KI-Sitzung; GitHub mit GitHub Actions, GitHub-CLI, PowerShell 7 mit Pester, Python und Poppler für die PDF. Ein früherer Codex-Prompt ist als veraltet gekennzeichnet. | [CLAUDE.md](../CLAUDE.md); [TAGESSTART.md](TAGESSTART.md); `queue/INDEX.yaml` (Feld `planer`); [PDF-ERZEUGEN.md](PDF-ERZEUGEN.md); [CODEX_PROMPT.md](CODEX_PROMPT.md) |
| Technik | Frontend: statische Webseite (HTML, CSS, JavaScript ohne Framework). Backend und Datenbank: Supabase für Leserfeedback, Versionsmetadaten sowie die aktuelle HTML- und PDF-Fassung; geschützter Admin-Bereich für Version, Datum und Seitenzahl. PDF: lokal aus der HTML-Quelle erzeugt und geprüft. Hosting: manuell per FTP bei einem Webhoster; GitHub führt kein Deployment aus. Prüfung: `scripts/ci-check.ps1` lokal und in der CI, Pester-Tests unter `tests/`. | [README.md](../README.md); [SICHERHEIT.md](SICHERHEIT.md); `scripts/pdf/`; `.github/workflows/ci.yml` |
| Repositories | Reling-IT/relingit (öffentlich) | [README.md](../README.md), Abschnitt „Neue Version veröffentlichen“ |

## Aufwand

Stunden trägt nur der Product Owner ein oder nennt sie auf Nachfrage im Tagesabschluss (TA-09). Ein Agent schätzt nie selbst.

| Datum | Stunden (geschätzt) | Wofür (Fachlogik, Oberfläche, Fehlersuche, Infrastruktur, Doku und Standards, Prozess) |
| --- | --- | --- |
| 12.11.2026 | 2 | keine Angabe |
| 14.11.2026 | 3 | keine Angabe |
| 15.11.2026 | 7 | keine Angabe |
| 16.11.2026 | 2 | keine Angabe |
| 23.11.2026 | 2 | keine Angabe |
| 24.11.2026 | 2 | keine Angabe |
| 27.11.2026 | 2 | keine Angabe |

Summe bisher: 20 (12., 14., 15., 16., 23., 24. und 27.11.2026; für andere Tage keine Angabe). Belege: TAGESBERICHT-2026-11-14.md, TAGESBERICHT-2026-11-15.md, TAGESBERICHT-2026-11-16.md, TAGESBERICHT-2026-11-23.md, TAGESBERICHT-2026-11-24.md und TAGESBERICHT-2026-11-27.md (TA-09; 23., 24. und 27.11. Angabe des Product Owners im Chat, 24. und 27.11. am 27.11.2026 genannt); 15.11. vom Product Owner am 16.11.2026 bestätigt (3 am Tag und 4 am Abend).

## Nutzen

- Was kann die Anwendung heute, das vorher nicht ging? Belegt ist der Funktionsumfang: Die Geschichte lässt sich im Browser lesen und als PDF laden, dazu gibt es ein Workshop-Handout, einen Podcast und ein Rückmeldeformular ohne Kontaktdaten; eine neue Fassung wird über den Admin-Bereich veröffentlicht, ohne FTP-Upload ([README.md](../README.md)). Was davon vorher nicht ging: unklar.
- Wer hat sie zuletzt wann benutzt? unklar.
- Woran wird Nutzen gemessen? unklar. Das Projektprofil führt `ziel: offen`; eine Ziel- oder Meilensteindatei gibt es im Repository nicht ([CLAUDE.md](../CLAUDE.md)).

## Erkenntnisse

Was dieser Pilot über den Aufwand zeigt. Je Eintrag Datum und Beleg (PR, Commit, Bericht). Aufgeführt sind nur belegte Beobachtungen; eine Bewertung in Stunden fehlt (siehe Aufwand).

- 08.11.2026: Jede Version durchläuft die Freigabetore G1 bis G8. Vier davon (G3 Layout, G4 UI, G5 Inhalt, G8 Freigabe) haben keine Automatik; Sichtung und Freigabe bleiben Handarbeit des Product Owners. Beleg: [FREIGABE.md](FREIGABE.md), PR #22, Commit 5ce8c9a.
- 08.11.2026: Eine lokal veraltete Warteschlange führte dazu, dass ein Auftrag doppelt gestartet wurde. Seitdem wird die Warteschlange immer nach `git fetch` gelesen. Beleg: [TAGESSTART.md](TAGESSTART.md), Schritt 2.
- 11.11.2026: Die Merge-Reihenfolge der offenen Drafts wurde per Probe-Merge geprüft (Reihenfolgen A bis D). Es gab Fälle ohne textlichen Konflikt, in denen `ci-check.ps1` trotzdem einen Fehler meldete (Befund C1, abweichende Versionsangabe zwischen zwei Seiten). Eine reine Konfliktprüfung reicht also nicht. Beleg: R57-BERICHT.md.
- 11.11.2026: Der Trockenlauf für v1.39 (alle Drafts zusammengeführt) endete mit `ci-check` Exit 0 und Pester 54/54, setzt aber drei Nachzüge von Hand voraus. Beleg: R63-BERICHT.md.
- 11.11.2026: Befund F2: Auf `main` sind die Tore G2 und G7 der Freigabeprüfung vom Aufbau her nicht bestehbar; der Lauf zeigt dort Sperrgründe, die keine sind. Beleg: R61-BERICHT.md, PR #31 (Draft).
- 11.11.2026: Die Pester-Tests laufen nicht in der CI, nur lokal. Beleg: TAGESBERICHT-2026-11-11.md (Risiken), VORSCHLAG-PESTER-CI.md.
- 12.11.2026: Neun Pull Requests aus KI-Sitzungen sind offen, alle als Draft; die Merges warten auf den Upload von v1.38 und die Einzelfreigabe je PR. Die Vorgabe von höchstens drei offenen PRs ist überschritten. Beleg: TAGESSTART-2026-11-12.md.

## Nächster Meilenstein

- Erreicht: Version 1.40 ist live, geprüft und getaggt (R09, R89, R88); ein Tag v1.39 entfällt (R52). Der vorherige Rahmen vom 16.11.2026 lautete „Upload und Tag v1.39, danach Upload v1.40 als kleine Korrekturfassung“. Beleg: R09-NACHPRUEFUNG-v1.40.md, R88-BERICHT.md, `queue/R52.yaml`; Auftrag R73, Schritt 4.
- Nächstes Ziel: unklar (vom Product Owner noch nicht festgelegt).
- Abnahmekriterium: unklar (für diesen Meilenstein nicht festgelegt). Allgemein gilt: Tore G1 bis G8 bestanden beziehungsweise erteilt, siehe [FREIGABE.md](FREIGABE.md).
- Entscheidung „weiter / einfrieren / einstellen“: **weiter** (Product Owner, 16.11.2026). Die bisher geplante Pause bis zum Jahresende ist verschoben, ein neuer Termin ist offen. Beleg: `ops/queue` ea666f2 (`hinweis_owner`), `reports/STATUS.yaml` (Feld `entscheidung_weiter`).
