# Pilot-Steckbrief: Die Fahrt zum Kunden (Reling IT)

Vorlage nach `REPOSITORY_BASISHYGIENE.md` („Mindestausstattung je Art“) und `SITZUNGSROUTINE.md` (TA-09) aus `bmarnau-standards/ai-development-governance`, Datei `vorlagen/pilot-steckbrief.md`. Ablage im Repository als `docs/PILOT.md`, Pfad im Projektprofil (`steckbrief` in [CLAUDE.md](../CLAUDE.md)). Nur belegte Angaben; Unbekanntes als `unklar`.

Stand: 12.11.2026, angelegt mit Auftrag R73 (`queue/R73.yaml` auf dem Branch `ops/queue`). Berichte, auf die verwiesen wird, liegen unter `reports/` auf dem Branch `ops/reports`.

## Kurzprofil

| Feld | Angabe | Beleg |
| --- | --- | --- |
| Zweck (ein Satz) | Landingpage, Online-Lesefassung und Workshop-Handout zur fortlaufenden Kurzgeschichte „Die Fahrt zum Kunden“; laut Auftrag dienen die Kurzgeschichten der Workshop-Vorbereitung. | [README.md](../README.md), erster Absatz; Auftrag R73, Schritt 2 |
| Zielgruppe | Kolleginnen und Kollegen sowie Workshop-Teilnehmende. Im Repository selbst steht dazu nur das Workshop-Handout; eine Beschreibung der Zielgruppe fehlt dort. | Auftrag R73, Schritt 2; [README.md](../README.md) |
| Tatsächliche Nutzer | unklar (keine Anzahl und keine Nutzungsdaten im Repository) | – |
| Status | Pilot (Entscheidung des Product Owners vom 12.11.2026). Belegter Stand: Auf `main` liegt Version 1.38 (7. November 2026, 77 Seiten), Freigabe G8 ist verbucht, der Upload steht aus. Welche Version öffentlich ausgeliefert wird, ist im Repository nicht belegt (laut Auftrag R73: v1.37). v1.39 liegt als Entwurf in Draft-PRs vor. | `queue/R73.yaml` (Feld `entscheidungen_bernd_2026_11_12`); `assets/js/app.js` (Rückfallwert); Commit ba5a23c; PR #29 (Merge 8abe213); TAGESBERICHT-2026-11-11.md; TAGESSTART-2026-11-12.md; PR #27 und #33 |
| Start | 2026-08-30 (erster Commit auf `main`) | Commit f426a21 |
| Werkzeuge | Claude als Planer (Warteschlange) und Claude Code als ausführende KI-Sitzung; GitHub mit GitHub Actions, GitHub-CLI, PowerShell 7 mit Pester, Python und Poppler für die PDF. Ein früherer Codex-Prompt ist als veraltet gekennzeichnet. | [CLAUDE.md](../CLAUDE.md); [TAGESSTART.md](TAGESSTART.md); `queue/INDEX.yaml` (Feld `planer`); [PDF-ERZEUGEN.md](PDF-ERZEUGEN.md); [CODEX_PROMPT.md](CODEX_PROMPT.md) |
| Technik | Frontend: statische Webseite (HTML, CSS, JavaScript ohne Framework). Backend und Datenbank: Supabase für Leserfeedback, Versionsmetadaten sowie die aktuelle HTML- und PDF-Fassung; geschützter Admin-Bereich für Version, Datum und Seitenzahl. PDF: lokal aus der HTML-Quelle erzeugt und geprüft. Hosting: manuell per FTP bei einem Webhoster; GitHub führt kein Deployment aus. Prüfung: `scripts/ci-check.ps1` lokal und in der CI, Pester-Tests unter `tests/`. | [README.md](../README.md); [SICHERHEIT.md](SICHERHEIT.md); `scripts/pdf/`; `.github/workflows/ci.yml` |
| Repositories | Reling-IT/relingit (öffentlich) | [README.md](../README.md), Abschnitt „Neue Version veröffentlichen“ |

## Aufwand

Stunden trägt nur der Product Owner ein oder nennt sie auf Nachfrage im Tagesabschluss (TA-09). Ein Agent schätzt nie selbst.

| Datum | Stunden (geschätzt) | Wofür (Fachlogik, Oberfläche, Fehlersuche, Infrastruktur, Doku und Standards, Prozess) |
| --- | --- | --- |
| keine Angabe | keine Angabe | keine Angabe |

Summe bisher: keine Angabe

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

- Ziel: Release v1.39. Beleg: Auftrag R73, Schritt 4; Vorarbeiten in PR #27, PR #33 und R63-BERICHT.md.
- Abnahmekriterium: unklar (für diesen Meilenstein nicht festgelegt). Allgemein gilt: Tore G1 bis G8 bestanden beziehungsweise erteilt, siehe [FREIGABE.md](FREIGABE.md).
- Entscheidung „weiter / einfrieren / einstellen“ bis: offen. Laut Auftrag R73 fällt am 16.11.2026 die Entscheidung zum Release v1.39; danach ist eine Pause bis zum Jahresende geplant.

Offene Frage an den Product Owner: Wird das Projekt nach dem Release v1.39 weitergeführt, eingefroren oder eingestellt, und bis wann fällt diese Entscheidung?
