---
titel: 'Kurzbericht: Merge-Folge #40, #39, #38'
datum: 2026-11-16
stand: '07:35'
---

# Kurzbericht Merge, 16.11.2026

Reihenfolge vom Product Owner festgelegt: **#40 → #39 → #38**. Gemergt wird vom Product Owner, nicht von einer KI-Sitzung (CLAUDE.md), jeweils mit Head-SHA.

## Vorbereitet

- #40: Nachtrag PILOT.md (Entscheidung „weiter“), Commit 8ec3f5e, CI grün, auf Ready gesetzt, Kommentar am PR.
- Kreuzprüfung: `main` (a1b11a8) + #40 + #39 + #38 nacheinander zusammengeführt; `index.html` (#38/#39) ohne Konflikt, `scripts/ci-check.ps1` Exit 0.

## Merge-Folge

| Schritt | PR | Head vor dem Merge | Voraussetzung |
|---|---|---|---|
| 1 | #40 Doku R77 | 8ec3f5e | keine, Ready, CLEAN |
| 2 | #39 Link zur Fahrt | ba7c909, nach Schritt 1 neu (`update-branch`) | Sprung im Browser geprüft, Ready setzen |
| 3 | #38 Trailer | 10fb65f, nach Schritt 2 neu (`update-branch`) | Sichtung Video, Safari/iOS, „Bewegung reduzieren“ |

Wegen strict-Branchschutz ändert sich der Head von #39 und #38 nach jedem Merge. Den neuen SHA nennt die Ausführung nach dem jeweiligen `update-branch` und grüner CI.

## Danach

- PR-Platz frei → R86 (v1.40) als Draft-PR.
- Nach #39 und #38: Upload-Paket v1.39 (CDF23C5F…9218) mit `main` abgleichen, dann Upload durch den Product Owner.

## Vorschläge und Ideen (Claude)

- Nach Schritt 1 sofort R86 starten; die Sichtung von #38 muss darauf nicht warten.
