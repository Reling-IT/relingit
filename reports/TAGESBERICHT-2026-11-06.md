---
titel: 'Tagesbericht Reling IT'
datum: 2026-11-06
main: 2f8cd6d3ac33d9b29496c18c2d9729325386107d
ci_main: 'success, https://github.com/Reling-IT/relingit/actions/runs/42196366497'
queue: 'origin/ops/queue d69b3a5'
---

# Tagesbericht Reling IT, 06.11.2026

## Ergebnis

Webseiten-Pflege (R01) und die Automatik für die Seitenzahl sind auf `main` (`2f8cd6d`) gemergt, die CI ist grün. Das FTP-Paket ist gebaut, hochgeladen ist es noch nicht. Die Live-Seite ist deshalb noch veraltet.

| Punkt | Stand | Beleg |
|---|---|---|
| Seitenzahl | `index.html` nennt 69 statt 46 Seiten. `publish-release.ps1` trägt die Zahl künftig selbst ein, `ci-check.ps1` vergleicht sie mit `app.js`. | PR #4 (`576c81e`), PR #5 (`2f8cd6d`) |
| Repo-Links | Im Repo zeigen alle Links auf `Reling-IT/relingit`. Live steht noch `bmarnau/relingit`. | `git grep`, `curl` Live-Seite |
| Handout, Logo | korrekt verlinkt, 4 Vorschläge, kein Fehler | PR #4, `reports/R01-BERICHT.md` |
| Podcast | auf der Webseite nicht eingebunden | Grep ohne Treffer |
| Prüfungen auf `main` | `ci-check.ps1` OK, `node --check` 6/6 ohne Fehler, GitHub-CI `success` | Lauf 42196366497, `reports/MERGE-4-5-BERICHT.md` |
| Warteschlange | `ops/queue` eingespielt (`d69b3a5`, Autor bmarnau). Berichte liegen auf `ops/reports`. | `git ls-remote` |
| FTP-Paket | `output\ftp\relingit-upload-v1.37-2026-09-05.zip`, 23 Dateien bytegenau, keine Interna, keine Zugangsdaten | SHA-256 `A710D2486DAAC169B552FBE52E00FBE7B66A4FCCED16092F6BA18C4ACE26747A` |
| Werkzeuge | PowerShell 7.6.9 nachinstalliert | `winget install Microsoft.PowerShell` |

## Abweichungen

- Die Merges hat der Owner selbst ausgeführt, weil der Prüfmodus von Claude Code sie für Claude gesperrt hatte.
- R01 lief, bevor die Warteschlange eingespielt war.
- Die Branch-Namen folgen nicht dem Schema `auftrag-<id>-<kurzname>`.

## Nächste Schritte

1. Owner: FTP-Paket hochladen. Danach prüft Claude die Live-Seite lesend.
2. Owner: q15 entscheiden und `Reling-IT/relingit` als Adresse bestätigen. Dann kann R02 starten.
3. Planer: R01 in `queue/INDEX.yaml` auf `erledigt` setzen.
4. Owner, optional: die zwei gemergten Feature-Branches löschen.

Hygiene: Claude prüft die Warteschlange weiter alle 30 Minuten. Keine offenen PRs, keine Drafts. Die gemergten Feature-Branches `auftrag-a-website-pflege-20261106-0957` und `auftrag-a-seitenzahl-skript-20261106` bestehen noch.

```yaml
Reifegrad: "Webseiten-Pflege auf main, CI grün, FTP-Paket bereit; Live-Stand veraltet bis Upload"
Projektstatus: "R01 erledigt; PR #4 und #5 gemergt; R02 wartet auf Entscheidung; Warteschlangen-Prüfung aktiv"
Offene_Fragen:
  - "Wann wird das FTP-Paket hochgeladen?"
  - "q15: Standardweg zum Hochladen (FTP-Paket oder Admin-Bereich mit Supabase)?"
  - "Bestätigung Reling-IT/relingit als endgültige Adresse"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
