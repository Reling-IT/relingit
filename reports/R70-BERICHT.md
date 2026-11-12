---
id: R70
titel: Lose Dateien im Arbeitsverzeichnis inventarisieren (Teil 1, nur lesen)
status: Teil 1 erledigt; Teil 2 (Papierkorb) wartet auf Bestätigung des Product Owners
start: 2026-11-12T04:49+01:00
ende: 2026-11-12T04:51+01:00
---

# R70 – Lose Dateien in `C:\dev` (Inventar)

Auftrag: `queue/R70.yaml` (ops/queue 9ffaea5). Nur gelesen: Name, Größe, Änderungsdatum, SHA-256 und die ersten Zeilen je Datei. Nichts verschoben, nichts gelöscht. Erfasst sind nur Dateien direkt im Arbeitsverzeichnis, keine Unterordner.

## Inventar (Stand 12.11.2026, 04:49)

| Nr | Datei | Byte | Geändert | SHA-256 | Zweck laut Kopfzeile | Empfehlung |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `wt-a96-pr.md` | 3015 | 09.11.2026 05:35 | `c8b2e28ff8bfcf060d62fb1c3462f2eb42d30d27ce7981ff4383be04fbc7a669` | PR-Text zu einem Auftrag „A96“ eines anderen Repositorys (Standardfamilie); laut Kopfzeile lag der Branch damals ohne PR vor | behalten, bis im Zielrepository geprüft ist, ob der PR inzwischen existiert; dann Papierkorb |
| 2 | `wt-a96-review.md` | 31670 | 09.11.2026 06:17 | `1378ef055dd6169ff72db90446e5651fd89954d08da7f367d9259ab5c7a46154` | Zweitprüfung zu A96 (anderes Repository) | wie Nr. 1; vorher prüfen, ob das Ergebnis im Zielrepository abgelegt ist |
| 3 | `wt-p7-pr.md` | 3465 | 08.11.2026 07:04 | `ecd79234727e2028125929eb6f8ecba4b43ff193877e858c87c142da13e69465` | PR-Text zu einem Paket „P7“ (anderes Repository) | Papierkorb, wenn der PR dort angelegt ist (nicht geprüft) |
| 4 | `wt-p7-review.md` | 10005 | 08.11.2026 07:03 | `32914a5808e3bab3780c44c85e60e1dc00035a61fdbdd92cdaa66a1ce80d90c3` | Zweitprüfung zu P7 (anderes Repository) | wie Nr. 3 |
| 5 | `wt-p8-pr.md` | 2234 | 08.11.2026 06:58 | `2a56c4e7deb53d654299753d1d1efd9e6f9fc1988aeb65aa0e19ded4f978fed8` | PR-Text zu einem Paket „P8“ (anderes Repository) | Papierkorb, wenn der PR dort angelegt ist (nicht geprüft) |
| 6 | `wt-p8-review.md` | 1547 | 08.11.2026 06:58 | `54d3b427d8ac424e7c2dddab9b57c358e72d356eb691e91b794196fafe49260a` | Zweitprüfung zu P8 (anderes Repository), zwei Runden | wie Nr. 5 |

Summe: 6 Dateien, 51 936 Byte.

## Bezug zu relingit

- Keine der sechs Dateien gehört zu Reling-IT/relingit. Die Kopfzeilen nennen ein anderes Repository und dessen Aufträge.
- Abgleich mit den offenen PRs #25 bis #34: In keiner PR-Beschreibung kommt einer der Dateinamen oder eines der Kürzel vor (Suche in den neun Beschreibungen, je 0 Treffer). Für relingit wird keine Datei gebraucht.
- Nicht geprüft: ob die Inhalte im anderen Repository schon als PR-Text oder Review abgelegt sind. Das wäre ein Lesezugriff auf ein Repository außerhalb dieses Auftrags.

## Empfehlung

Für relingit sind alle sechs Dateien entbehrlich. Weil es PR- und Review-Texte eines anderen Projekts sind, sollte vor dem Papierkorb dort kurz geprüft werden, ob sie übernommen sind (besonders Nr. 1 und 2: Branch laut Kopfzeile ohne PR). Der Papierkorb ist umkehrbar, die Prüfsummen oben erlauben den späteren Abgleich.

Teil 2 führe ich erst nach ausdrücklicher Bestätigung aus, nur für die bestätigten Dateien, nur in den Papierkorb, mit Hash-Vergleich vorher.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Die Dateien gehören fachlich in die Sitzung des anderen Projekts. Ein Hinweis dort („sechs lose Dateien, Inventar in relingit R70“) vermeidet, dass sie hier ohne Kenntnis des Zusammenhangs entsorgt werden.
- Nebenbefund außerhalb des Auftrags: Im Arbeitsverzeichnis liegen neben den relingit-Worktrees weitere Ordner nach dem alten Muster `wt-*`, die zu anderen Repositories gehören. Für relingit nur als Hinweis; aufräumen müsste das jeweilige Projekt.

Hygiene: gemergte Remote-Branches 0; offene PRs 10 (#25 bis #28, #30 bis #35), alle Draft.

```yaml
Reifegrad: Inventar der sechs losen Dateien mit Pruefsummen liegt vor; nichts veraendert
Projektstatus: Teil 2 (Papierkorb) wartet auf Bestaetigung des Product Owners je Datei
Offene_Fragen:
  - Welche der sechs Dateien duerfen in den Papierkorb?
  - Sind die Texte im anderen Repository bereits abgelegt?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
