# Abschlussbericht Warteschlange relingit, 06.11.2026

Queue-Stand: `ops/queue` `167c883`. Alle Aufträge mit Status `bereit` sind abgearbeitet (R04, R10, R08, R02, R03). Nichts gemergt, nichts veröffentlicht, kein Tag, kein FTP.

| Auftrag | Ergebnis | PR | CI |
|---|---|---|---|
| R04 | Bestandsaufnahme der Referenz-Repos (nur lesend) | – | – |
| R10 | Sachabgleich Buch gegen reale Repos (E1–E5, U1–U5) | – | – |
| R08 | Kapitel-Vorlage und Einbau-Checkliste | #7 | grün |
| R02 | Vollständigkeits-Check, Admin-Übergabe in publish-release, docs/NEUE-GESCHICHTE.md | #8 | grün |
| R03 | Buchtext v1.38 (k1–k3), PDF offen | #9 (Draft) | rot, 1 erwarteter Fehler |
| R11 | wartet auf Merge von PR #6, nicht begonnen | – | – |

## Für den Owner zu tun

1. PR #7 und #8 prüfen und mergen.
2. PDF v1.38 erzeugen; die Werkzeuge `verify_layout.py` und `render_story_pdf.py` fehlen hier. Danach `./scripts/publish-release.ps1`, Ergebnis auf den Branch von PR #9 committen, Draft aufheben.
3. Entscheiden, ob PR #6 (Avatare) vor dem Release v1.38 gemergt wird. Danach R11 auf `bereit` setzen.
4. Beim Release v1.38 ist einmal FTP nötig: `index.html` und `assets/js/app.js` wurden seit dem letzten Release durch PR #4 und #5 geändert.

## Vorschläge und Ideen (Claude)

1. Die Versionsnummer im PDF per `pdftotext` gegen das Deckblatt prüfen. Ein altes PDF wird derzeit nicht erkannt.
2. Die PDF-Werkzeuge ins Repo unter `scripts/` legen.
3. Release-Tags pro Version, sobald erlaubt, als eindeutige Vergleichsbasis für den FTP-Hinweis.
4. `output/` in `ci-check` ausnehmen. Die Zählung „21 HTML-Dateien“ ist irreführend.
