---
titel: 'R90 Prüfung der Standards-PRs resilience-recovery #6 und identity-rbac-standard #14 (nur lesend)'
datum: 2026-11-23
auftrag: R90
queue_stand: 2203c60
ergebnis: kein Muss-Befund; je ein Soll-Befund
---

# R90 Prüfung der Standards-PRs

Nur gelesen (GitHub REST über `gh api` und `gh pr diff`). Kein Merge, keine Änderung, kein Kommentar an den PRs. Beide Repositories sind privat; dieser Bericht nennt deshalb nur, was für die Freigabe nötig ist.

## Kopfdaten

| PR | Head-SHA | Draft | mergeable_state | CI |
|---|---|---|---|---|
| bmarnau-standards/resilience-recovery#6 | `3994e71d0f96508ed3a61a37009917d5a650a4f8` | ja | clean | keine Prüfung vorhanden: kein Workflow im Repository (`.github/workflows` 404), 0 Check-Runs, Status `pending (0)` |
| bmarnau-standards/identity-rbac-standard#14 | `391440d7ba606f9237cc8b1dba245a16aa6049ce` | ja | clean | nicht zutreffend: `verify-cross-repo.yml` läuft nur bei Änderungen unter `requirements/`; 0 Check-Runs |

## Geänderte Dateien (Abgrenzung)

| PR | Dateien | Standardtext, `anforderungen.yaml`, `requirements/` |
|---|---|---|
| #6 | `CHANGELOG.md` (+4), neu `ERFAHRUNGEN-RELING-IT-SUPABASE.md` (+25) | unverändert |
| #14 | `CHANGELOG.md` (+1), neu `guidance/erfahrungen-reling-it-supabase.md` (+21) | unverändert |

## Anforderungs-IDs

| PR | Zitierte IDs | Ergebnis |
|---|---|---|
| #6 | REST-01, 02, 04, 07, 15, 31, 35, 43, 44, 45; W1, W2, W4, W6; N5, N7; S2 | alle in `anforderungen.yaml` (REST-01 bis REST-48) bzw. in `STANDARD-WIEDERHERSTELLBARKEIT.md` (Wege W1 bis W6, Notfälle, Schutzklassen) vorhanden |
| #14 | IAM-REQ-003, 016, 021, 022, 025, 027, 030, 032; Umsetzungshilfe `supabase-lovable-muster.md` Abschnitt 5 | alle unter `requirements/iam-req-*.yaml` vorhanden; Abschnitt 5 der Umsetzungshilfe ist „Server-Funktion mit Dienstschlüssel“ und passt |

Keine unbekannte ID.

## Befunde

| PR | Klasse | Fundstelle | Befund | Vorschlag |
|---|---|---|---|---|
| #6 | Soll | RI-03 | „nach Angabe des Herstellers … (etwa 90 Tage, zu belegen)“ widerspricht der Kennzeichnung am Kopf, nach der Tarif-, Pausen- und Backup-Angaben vom Owner aus dem Dashboard stammen. | „nach Owner-Angabe (Dashboard, Stand 23.11.2026)“ schreiben, wie in RI-05. |
| #6 | Hinweis | RI-06 | Zuordnung zu REST-43 (Restore-Skript) und REST-45 (Rollenabnahme) ist weit; die lesende Prüfung nach dem Upload passt am ehesten zu REST-31 (versionierte Prüfabfrage). | Zuordnung vom Owner bestätigen lassen. |
| #6 | Hinweis | RI-07 | REST-44 betrifft die Rechteprüfung nach einer Wiederherstellung, nicht den Nachweis einer Schreibaktion; REST-35 passt. | REST-44 streichen oder begründen. Die offene Frage 3 im Blatt (ADG statt hier) teile ich. |
| #6 | Hinweis | `CHANGELOG.md`, bestehende Zeile zu SysIng | enthält einen Personennamen; nicht Teil dieses PR. | Bei Gelegenheit auf „im Auftrag des Owners“ umstellen. |
| #14 | Soll | RI-03 | Enthält eine konkrete Betriebsaussage zum Umgang mit einem Schlüssel mit erweiterten Rechten in einem bestimmten Projekt. Für ein Erfahrungsblatt genügt das Muster. | Allgemein formulieren (Weg für KI-Sitzungen, Umfang vorher freigegeben, Nachweis vorher/nachher), ohne Aussage zum Zustand des Schlüssels. |
| beide | – | gesamter Diff | Keine Personennamen, keine Zugangsdaten, keine Schlüssel. Tarif- und Backup-Angaben nur in #6; RI-05 ist als Owner-Angabe gekennzeichnet, RI-03 nicht (siehe oben). | – |

## Ergebnis

Kein Muss-Befund. Vor einer Freigabe je Head-SHA sollten die beiden Soll-Befunde entschieden werden. Ändert sich ein Head, ist neu zu prüfen.

Geprüft von Claude Code (Opus), nicht Autor der PRs.
