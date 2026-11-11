# Vorschlag an den Planer: Pester-Tests in die CI (11.11.2026)

Freigabe des Product Owners zum Vorschlag: ja, 11.11.2026. Ob daraus ein Auftrag wird, entscheidet der Planer; die Workflow-Änderung braucht die ausdrückliche Freigabe des Product Owners (gemeinsame Regel: nichts an `.github/workflows` ohne Auftrag).

## Anlass

- Am 10.11. waren auf #25 seit fa4a49f vier Pester-Tests rot (TestHelfer kannte `navis.svg` und `lumen.svg` nicht). Die CI blieb grün, weil sie Pester nicht ausführt (Tagesbericht 10.11., R29-20261110-BERICHT.md).
- G1 in docs/FREIGABE.md verlangt Pester, die CI prüft es aber nicht. Heute fällt ein Testfehler nur lokal auf.

## Ist-Stand (gelesen auf main 8abe213)

- `.github/workflows/ci.yml`: ein Job „Website prüfen“ auf ubuntu-latest: ci-check.ps1, `node --check`, Historienprüfung, Whitespace. Kein Pester.
- `tests/`: fünf Testdateien (build-upload, ci-check, freigabe-pruefen, publish-release, vorschau). Die zwei PDF-Tests in publish-release.Tests.ps1 überspringen sich selbst ohne `pdftotext` (`-Skip:$ohnePdfToText`).
- README: `Invoke-Pester -Path tests`, Zielversion Pester 5.

## Vorschlag Auftrag (Entwurf; Nummer vergibt der Planer, R61 ist inzwischen anders belegt)

```yaml
id: R6x
titel: 'CI: Pester-Tests als eigener Schritt (ohne PDF-Tests oder mit poppler-utils)'
art: code-pr
gate: ja        # Workflow-Aenderung, ausdrueckliche Freigabe des Product Owners
abhaengig_von: [R57]
ziel: 'Ein roter Pester-Test macht die CI rot. G1 wird damit auch auf GitHub belegt.'
schritte:
- 'Branch von origin/main. In .github/workflows/ci.yml nach ci-check einen Schritt "Pester-Tests" (shell pwsh): Pester 5 sicherstellen, Invoke-Pester -Path tests -CI. Keine anderen Schritte aendern, Action-Pins unveraendert.'
- 'Variante waehlen und begruenden: (a) poppler-utils per apt installieren, dann laufen auch die PDF-Tests; (b) ohne Poppler, die PDF-Tests ueberspringen sich selbst.'
- 'Vorher pruefen, ob alle Tests unter Linux laufen (Pfadtrenner, Windows-Annahmen in vorschau.ps1 oder freigabe-pruefen.ps1). Gefundene Testannahmen im selben PR korrigieren, Skripte selbst nur, wenn noetig, und im Bericht nennen.'
- 'Gegenprobe: ein absichtlich roter Test in einem Wegwerf-Commit auf dem Branch macht die CI rot; danach entfernen.'
nachweis: 'Draft-PR mit gruener CI, CI-Lauf mit sichtbarem Pester-Ergebnis, Gegenprobe-Lauf rot, Bericht reports/R61-BERICHT.md.'
grenzen: 'Nur ci.yml und tests/. Keine Aenderung an Deployment, FTP, Supabase, Admin, Berechtigungen (permissions bleibt contents: read). Kein Merge, kein Tag.'
```

## Reihenfolge und Risiken

- Nach R57 und vor den Merge-Blöcken einplanen: Dann prüft die CI ab dem ersten Merge auch Pester. Die offenen Drafts erben den Schritt erst nach einem Nachzug auf main.
- Risiko: Einzelne Tests könnten Windows voraussetzen. Dann wird der Auftrag größer; ein `-ExcludeTag` für solche Tests ist der Rückfallweg.
- Laufzeit: lokal wenige Sekunden je Datei; das Zeitlimit des Jobs (10 Minuten) reicht.

## Vorschläge und Ideen (Claude)

- `freigabe-pruefen.ps1` könnte danach für G1 den CI-Lauf des PR als Beleg lesen, statt Pester lokal zu verlangen.
- Mittelfristig Pester-Ergebnis als NUnit-XML im Lauf ablegen (Artefakt), damit Berichte auf einen Lauf verweisen können.

Hygiene: gemergte Remote-Branches 0; offene PRs 8 (#25 bis #28, #30 bis #33), alle Draft.
