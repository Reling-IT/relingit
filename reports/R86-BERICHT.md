---
auftrag: R86
titel: 'v1.40 Korrekturfassung: Umsetzung bis zur Sichtung'
datum: 2026-11-16
pr: '#41'
---

# Bericht R86, 16.11.2026

## Ergebnis

| Schritt | Ergebnis | Beleg |
|---|---|---|
| V140-1 Einstiege Kap. 3 und 4 | umgesetzt nach Vormerkung | PR #41, Commit 9e89e2b |
| V140-2 Wegweiser | Satz mit Link im Kasten; Teil 1 in vier Gruppen | 9e89e2b, 6c71236 |
| V140-3 Handout | H2 neu, H6 mit Fassung; H1 ohne belegten Termin unverändert | 6c71236 |
| Version | 1.40 / 16. November 2026 (Deckblatt, Neu in v1.40, Versionshistorie, anhang.html, lesen.html, app.js) | 6c71236 |
| Rendern | Buch 80 Seiten, verify_layout Exit 0; Handout 2 Seiten (venv-pdf) | 6c71236 |
| Abgleich `main` | `main` 907ca58 (Trailer #38) in den Branch geführt, ohne Konflikt | 2779a95 |
| Prüfung | ci-check Exit 0, node --check ok, Pester 55/55, CI grün | PR #41 |
| Freigabeprüfung | G1, G2, G6, G7 bestanden; G3 bis G5 offen; G8 gesperrt bis zur Sichtung | FREIGABE-v1.40.md |
| Paket v1.40 | `output/ftp/relingit-upload-v1.40-2026-11-16-ohne-audio.zip` im Worktree r86, SHA-256 D6396E99…4A03, 40 Nutzdateien; **nicht hochladen vor Upload, R09 und Tag v1.39** | build-upload Exit 0 |
| Doku | PILOT.md Stand und Stunden 16.11. | 6e68c6a, 1eaabbf |

## Abweichungen

- Die Einteilung ab „Ankunft“ und der Umfang des Handouts lagen beim Product Owner. Auf Anweisung „setze alle Aufgaben bis zur Fertigstellung von 1.40 selbständig um“ hat Claude die eigenen Empfehlungen umgesetzt; beides ist in der Sichtung (V03, V05) ausdrücklich zu prüfen.
- Die Sichtungsliste nennt Commit 2779a95; danach kam nur 1eaabbf (PILOT.md). Paket D6396E99 wurde auf 2779a95 gebaut; PILOT.md ist nicht Teil des Pakets.

## Nächste Schritte

1. Sichtung durch den Product Owner (Vorschau läuft, `SICHTUNG-v1.40.md`).
2. G8 als PR-Kommentar „Freigabe G8 v1.40: ja“, dann Merge #41.
3. Upload v1.39, R09, Tag v1.39; danach Upload v1.40 (Paket nach Merge aus `main` neu bauen und gegen D6396E99 abgleichen), R09 für v1.40, Tag v1.40.

## Vorschläge und Ideen (Claude)

- `freigabe-pruefen.ps1` könnte die Sichtungspunkte je Version aus einer Datei `docs/sichtung-zusatz-vX.YY.md` übernehmen; dann müssen versionsspezifische Punkte nicht von Hand angehängt werden.
- Eine Seitenzahl-Liste der geänderten Stellen (wie V01 bis V04) automatisch aus dem PDF ziehen (Textsuche nach dem neuen Wortlaut) und in die Sichtungsliste schreiben.
- Den Upload von v1.39 und v1.40 nicht zusammenlegen: Erst v1.39 live prüfen und taggen, damit ein Rückfallpunkt mit Trailer existiert.
