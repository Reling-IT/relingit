---
id: R24
titel: Pester-Tests für publish-release.ps1 und ci-check.ps1
status: erledigt (Teilstand, PR als Draft wegen Sitzungsende)
start: 2026-11-07T07:04+01:00
ende: 2026-11-07T07:22+01:00
branch: auftrag-R24-pester-tests
pr: https://github.com/Reling-IT/relingit/pull/15 (Draft)
commit: e8d0200
ci: nicht abgewartet (Abbruch durch Owner)
---

## Ergebnis
8 Pester-Tests (6 ci-check, 2 publish-release) mit kleinen Fixtures in tests/, alle grün mit Pester 3.4.0 (pwsh 7.6.9 und Windows PowerShell 5.1).
Jeder Test baut ein Mini-Projekt im TestDrive und startet die kopierten Skripte in einem eigenen pwsh-Prozess.
Fixtures tragen die Endung .fixture, deshalb bleibt die echte ci-check-Prüfung grün; ci-check.ps1 wurde nicht geändert.
Pester 5 ist nicht installiert; die Tests sind für Pester 5 geschrieben, ein Lauf damit fehlt noch.
PR #15 ist ein Draft, CI-Ergebnis und PR-Kommentar fehlen.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Pester-Verfügbarkeit | Nur Pester 3.4.0 (C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0) in pwsh und powershell.exe | `Get-Module -ListAvailable Pester` |
| Installationsbefehl (nicht ausgeführt) | `Install-Module Pester -MinimumVersion 5.5 -Scope CurrentUser` | – |
| Kompatibilität | Kein `Should`, eigene Assert-Funktionen; BeforeAll im Describe, `-Skip`; Testdateien mit UTF-8-BOM (für PS 5.1) | tests/TestHelfer.ps1 |
| Invoke-Pester | `Passed: 8 Failed: 0 Skipped: 0`, ca. 2 min, unter pwsh 7.6.9 und PS 5.1 | Ausgabe in der PR-Beschreibung |
| (a) fehlender Anker | Meldung „Interner Story-Link hat kein Ziel: #kap-gibt-es-nicht“ | ci-check.Tests.ps1 |
| (b) doppelte ID | Meldung für story/current und source | ci-check.Tests.ps1 |
| (c) Versionshistorie | fehlende Zeile 1.02, unpassendes Datum, unlesbare Zeile: jeweils eigener Test | ci-check.Tests.ps1 |
| publish-release | PDF v1.01 gegen HTML v1.02 bricht mit „PDF passt nicht zur HTML-Quelle“ ab, story/current/geschichte.pdf unverändert (Hash); Gegenprobe v1.02 meldet „OK: PDF-Deckblatt trägt Version 1.02“ | publish-release.Tests.ps1 |
| Test-PDF | Handgeschriebene 1-seitige PDFs (626 Byte, Helvetica-Text), einmalig mit Python ohne Zusatzpakete erzeugt; pdftotext und pdfinfo lesen sie fehlerfrei | tests/fixtures/pdf/ |
| Gegenproben | Fehlerfreies Mini-Projekt: ci-check Exit 0 | ci-check.Tests.ps1 |
| Echte ci-check | `pwsh -NoProfile -File scripts/ci-check.ps1`: OK, 11 HTML-Dateien (wie vorher) | Lauf nach den Änderungen |
| Doku | README: ein Satz zum Aufruf `Invoke-Pester -Path tests` | README.md |
| CI / PR-Kommentar | nicht abgewartet bzw. nicht geschrieben (Sitzungsende) | – |

## Offene Fragen, Risiken, Abweichungen
- Offen: Lauf mit Pester 5 nach Installation durch den Owner; CI-Ergebnis von PR #15; PR-Kommentar mit CI-Ergebnis; PR von Draft auf bereit setzen.
- Abweichung: PR als Draft und ohne CI-Abwartung, auf Anweisung des Koordinators.
- Risiko: core.autocrlf=true; die .fixture-Textdateien werden bei frischem Checkout mit CRLF ausgecheckt. Die Regexe vertragen `\s`, getestet wurde aber nur mit dem LF-Arbeitsstand. PDFs fallen unter `*.pdf binary`.
- Risiko: Die Gegenprobe zu publish-release lässt das Skript nach der PDF-Prüfung weiterlaufen (Kopieren, ci-check, build-upload bricht im Mini-Projekt wegen fehlender Podcast-Dateien ab). Das betrifft nur den TestDrive.
- Hinweis: Unter Linux (TEMP=/tmp) würde der Ausschluss `[\/]tmp[\/]` in ci-check den Google-Fonts- und Secret-Scan im Mini-Projekt überspringen; für die getesteten Meldungen nicht relevant.
- Die Fixtures für das Mini-Projekt sind an die heutigen Muster in ci-check.ps1 gebunden. Neue Invarianten in ci-check machen die Gegenprobe rot, bis die Fixtures nachgezogen sind (gewollt, aber Pflegeaufwand).

## Vorschläge und Ideen (Claude)
- CI-Einbau (nur Vorschlag, nicht umgesetzt): im Job „quality“ einen Schritt mit `shell: pwsh` ergänzen: `sudo apt-get install -y poppler-utils` (für pdftotext/pdfinfo), dann `Install-Module Pester -MinimumVersion 5.5 -Scope CurrentUser -Force` und `Invoke-Pester -Path tests -CI`. Laufzeit ca. 2 min; timeout-minutes ggf. auf 15 erhöhen.
- Laufzeit senken: mehrere Fälle in einem Mini-Projekt nacheinander prüfen oder ci-check in einem Prozess wiederverwenden.
- Weitere Fälle: Seitenzahl-Widerspruch, PDF ohne Versionsangabe, mehrere Versionen auf dem Deckblatt, fehlender Cover-Hinweis.
- Nach Installation von Pester 5 auf `Should -Match` umstellen, falls 3.4-Kompatibilität nicht mehr gebraucht wird.

Hygiene: Worktree C:\dev\wt-r24 bleibt bestehen (Branch gepusht, Arbeitsstand sauber); nichts installiert, nichts gemergt, kein Tag, keine Änderung an Workflows, Deployment oder Supabase; temporäre Mini-Projekte nur in TestDrive bzw. Scratchpad.

```yaml
Reifegrad: Tests lauffähig (Pester 3.4), Pester 5 und CI ungeprüft
Projektstatus: R24 als Draft-PR #15, Review und CI ausstehend
Offene_Fragen:
  - Pester 5 installieren und Tests damit laufen lassen?
  - Tests in die CI aufnehmen (Poppler und Pester im Runner)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
