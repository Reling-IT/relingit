---
id: R64
titel: 'G8 v1.38 verbuchen: Vermerk in SICHTUNG-v1.38.md und Freigabebericht (nur ops/reports)'
status: erledigt
start: 2026-11-11T06:31+01:00
ende: 2026-11-11T06:32+01:00
branch: ops/reports
quelle_queue: 'origin/ops/queue 103c0f6 (Planer Claude, Commit nicht signiert)'
---

# R64 Bericht: G8 v1.38 verbucht

## Ergebnis

- In `reports/SICHTUNG-v1.38.md` steht jetzt der Abschnitt „Entscheidung Product Owner 11.11.2026“ mit Datum, Wortlaut, Quelle, Paket-Hash `76692313…984C` und Basis main 8abe213 sowie dem Tor-Stand G1 bis G8.
- Die 26 Punkte der Sichtungsliste sind **nicht** nachträglich abgehakt.
- Nichts an `docs/freigabe.yaml` oder an Skripten geändert. Kein Merge, kein Tag, kein Upload.

## Abweichungen und Hinweise

- Der Wortlaut der Freigabe stammt aus dem Auftrag des Planers (103c0f6, nicht signiert). Der Product Owner hat ihn in der Claude-Code-Sitzung nicht selbst wiederholt. `docs/FREIGABE.md` nennt als Nachweis für G8 einen PR-Kommentar („Freigabe G8 vX.YY: ja“); PR #29 ist bereits gemergt.
- Das Prüfskript führt G8 auf main weiter als „gesperrt“ (R61, F2). Das ist bekannt und im Vermerk erklärt.

## Nächste Schritte (Product Owner)

1. Upload-Termin festlegen (offen).
2. Upload nach `reports/UPLOAD-CHECKLISTE-v1.38.md`: Paket `76692313…984C`, nicht das Altpaket `7118198F…FAE4`.
3. Danach R09 (Live-Prüfung) auf bereit setzen; anschließend R52 (Tag v1.38).

## Vorschläge und Ideen (Claude)

- G8 zusätzlich als Kommentar in einem Issue oder auf dem gemergten PR #29 festhalten („Freigabe G8 v1.38: ja, Paket 76692313…984C“), damit der Nachweis nach FREIGABE.md auch auf GitHub steht.
- Für künftige Versionen die Sichtungsliste direkt in der Vorschau-Sitzung ausfüllen, dann entfällt der Sondervermerk.

Hygiene: gemergte Remote-Branches 0; offene PRs 9 (#25 bis #28, #30 bis #34), alle Draft.

```yaml
Reifegrad: v1.38 freigegeben (G8 erteilt), Paket 76692313...984C geprueft und gleich main 8abe213
Projektstatus: Upload v1.38 durch den Product Owner offen (Termin offen); danach R09, R52
Offene_Fragen:
  - Wann ist der Upload-Termin?
  - G8 zusaetzlich als Kommentar auf GitHub festhalten?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
