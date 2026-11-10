# Tagesbericht 10.11.2026 (Claude Code)

## Tagesstart
Protokoll: `reports/TAGESSTART-2026-11-10.md` (ed05838). Vor jedem Lesen der Warteschlange lief `git fetch`.

## Tagesauftrag 10.11.2026 (Product Owner)
Nachträge zu R47, R49, R50, R46/R07, R06 und R11, keine neuen Aufträge. Ausgeführt vom Koordinator (Claude Code CLI); Punkt 3 und 4 parallel über Agenten in eigenen Worktrees. Kein Merge, kein Tag, kein FTP, kein Force-Push, keine Branch-Löschung.

| Nr. | Punkt | Stand | Nachweis |
|---|---|---|---|
| 1 | main lokal auf origin/main | erledigt: Fast-Forward 01defe7 → 8abe213, sauber | `git status -sb` |
| 2 | Paket v1.38 aus main | erledigt, siehe unten | `output/ftp`, `archive/ftp-packages/20261110-052115-235` |
| 3 | R47 Patch der drei übrigen Klon-Dateien | erledigt: 9 804 Byte, SHA-256 `4749dd34…fd7b`, Gegenprobe gegen Bundle ok, Klon unverändert | R47-BERICHT.md, Nachtrag 10.11. (f3d205e) |
| 4 | #27, #26, #25, #28 auf main nachziehen | erledigt, alle CI grün, CLEAN, Draft | Tabelle unten |
| 5 | R49: geschützte Pakete zählen bei den letzten drei mit | erledigt: war so umgesetzt; neu sind ein Pester-Test für genau diesen Fall und der Verweis auf die Entscheidung in docs/ABLAUF.md | #28, Commit 81f8e48 |
| – | wt-r50 entfernen | erledigt, nachdem Paket und Berichte gesichert waren | unten |

### Punkt 2: Paket v1.38 aus main 8abe213
- In `output/ftp` lagen noch das Paket vom Morgen des 09.11. (SHA-256 `7118198F…FAE4`, gebaut auf 01defe7, also **vor** R50) und v1.37. Beide wurden wie in `publish-release.ps1` nach `archive/ftp-packages/20261110-052115-235` verschoben (nicht gelöscht), damit das alte Paket nicht versehentlich hochgeladen wird.
- `./scripts/build-upload.ps1 -OhneAudio`: „35 aktuelle Quelldateien bytegenau im ZIP bestätigt“.
  - Datei: `output/ftp/relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, 4 666 884 Byte, **36 Einträge**
  - **SHA-256 `766923139AD9955DCBAB3678783DBCEC96FFA91E0CDA2F8CF945D554542C984C`**
- Vergleich mit R50 (`A906DDF4…205A`, 36 Einträge): gleiche Eintragszahl und Größe. Entpackt sind alle Nutzdateien bytegleich (`diff -r`). Einziger Unterschied ist die Zeile `Erstellt:` in `UPLOAD-MANIFEST.txt` (10.11. 05:21:18 statt 09.11. 06:02:11). Daher die andere Prüfsumme; inhaltlich ist es dasselbe Paket.
- `scripts/freigabe-pruefen.ps1` auf main:

| Tor | Ergebnis | Bemerkung |
|---|---|---|
| G1 Code | bestanden | ci-check, node --check, Pester |
| G2 Kommentare | offen | „Review ohne Änderungswunsch“ ist auf main nicht prüfbar (kein Feature-Branch); Kopfkommentare bestanden. Auf dem R50-Branch war G2 bestanden (R50-FREIGABE-v1.38.md) |
| G3–G5 Sichtung | offen | Sichtungsliste leer (0 Ja, 0 Nein); auch die Liste aus wt-r50 war nicht ausgefüllt |
| G6 Lokal | **nicht zutreffend** (Paket ohne Audio, Entscheidung des Product Owners vom 09.11.) | Skript meldet „offen“, weil die MP3 lokal fehlen; Vorschau möglich: bestanden. Schalter im Skript fehlt noch (Auftrag G6 beim Planer) |
| G7 Git | nicht bestanden, erwartet | Das Tor prüft den Feature-Branch vor dem Merge; auf main gibt es keinen. git status sauber: bestanden. Auf dem R50-Branch war G7 bestanden |
| G8 Freigabe | gesperrt | erteilt nur der Product Owner |

Kein Upload, kein Tag.

### Punkt 4: Pull Requests (Stand 05:30)

| PR | Inhalt | Head neu | Konflikte | Prüfungen | CI | Zustand |
|---|---|---|---|---|---|---|
| #25 R11 | Bildmarken Navis/Lumen | d1257f7 | keine | ci-check OK, Pester 21/21 nach Testkorrektur | grün | CLEAN, Draft |
| #26 R07/R46 | Anhang-Seite | 2133502 | keine | ci-check OK, Pester 23/23; Anhang-Schnitt passt (6 Blöcke, IDs wie R46) | grün | CLEAN, Draft |
| #27 R06 | v1.39 | 8ea4c62 | nur die zwei PDFs (binär), neu gerendert | 80 Seiten, verify_layout vollständig OK, publish-release OK, ci-check OK, Pester 21/21 | grün | CLEAN, Draft |
| #28 R49 | Aufbewahrung | 81f8e48 | keine | ci-check OK, Pester 9/9 (publish-release), vorher 27/27 gesamt | grün | CLEAN, Draft |

- #27: Die R50-Formulierung „ein kleines Systemhaus mit einer Kaffeeecke“ steht in der v1.39-Quelle und im PDF. „zehn Köpfen“ kommt noch zweimal vor (Kapitel Kaffeeecke und eine Randfrage), genau wie auf main. R50 hat diese Stellen bewusst gelassen.
- #25: Seit fa4a49f schlugen 4 Pester-Tests fehl, weil das Test-Mini-Projekt `navis.svg` und `lumen.svg` nicht kannte. Behoben in d1257f7 (`tests/TestHelfer.ps1`). Die CI führt Pester nicht aus, deshalb fiel es nicht auf.
- Kreuzprüfung `git merge-tree --write-tree`: alle sechs Paare der vier PRs konfliktfrei (05:29).
- Empfohlene Merge-Reihenfolge: #25 (bringt die Testkorrektur), #28, #26, zuletzt #27 nach Veröffentlichung und Live-Prüfung v1.38. Nach jedem Merge stehen die anderen PRs wieder auf BEHIND, falls der Branch-Schutz das verlangt; Konflikte sind nicht zu erwarten.

### wt-r50 gesichert und entfernt
- Paket der Sichtung (`A906DDF4…205A`) mit Ordner und Dateiliste nach `archive/ftp-packages/20261109-060211-000`, Paket des Publish-Laufs (`3BAD923A…16BE`) nach `archive/ftp-packages/20261109-055650-000`, je mit `HERKUNFT.txt`. Alle Dateien per SHA-256 gegen die Quelle geprüft. Die Ordnernamen folgen der Erstellzeit im Manifest, damit R49 sie richtig einordnet.
- Freigabe- und Sichtungsbericht v1.38 aus wt-r50 als `reports/R50-FREIGABE-v1.38.md` und `reports/R50-SICHTUNG-v1.38.md` übernommen.
- Danach `git worktree remove C:/dev/wt-r50` ohne Force; der lokale Branch bleibt.
- Ebenso wt-r49 entfernt (sauber, gepusht). Stehen bleiben wt-r06 (#27, nur ignorierte Ausgaben) und der Ablage-Worktree für ops/reports.

### Abweichungen
- R47: Die Prüfsumme von `.git/index` im Klon hat sich seit dem 09.11. geändert, nicht im heutigen Lauf; Ursache nicht belegt. `ci-check.ps1` im Klon hat gemischte Zeilenenden; der Patch stellt den Inhalt wieder her, nicht byte-genau die Zeilenenden.
- Der erste Aufruf von `build-upload.ps1` brach ab, weil das alte Paket gleichen Namens noch in `output/ftp` lag; dabei wurde nichts verändert.

## Offene Fragen an den Product Owner
- Ist v1.38 hochgeladen? Wenn ja, R09 auf bereit setzen. Hochzuladen ist das heutige Paket `76692313…984C` (oder das inhaltsgleiche `A906DDF4…205A`), **nicht** `7118198F…FAE4`.
- Wann darf der Papierkorb geleert werden? Empfehlung: nach R09.
- Automatisches Löschen gemergter Branches auf GitHub einschalten? Empfehlung: ja.
- Kann der OneDrive-Klon ganz entfallen (eigener Auftrag über R13)? Er enthält jetzt nichts Ungesichertes mehr.

## Vorschläge und Ideen (Claude)
- Pester in die CI aufnehmen, notfalls als eigenen Job ohne die PDF-Tests; der Fehler aus R11 wäre sofort aufgefallen.
- `freigabe-pruefen.ps1`: auf main G7 als „nicht zutreffend“ statt „nicht bestanden“ ausgeben, einen Schalter für Pakete ohne Audio (G6) ergänzen und im Draft „offen“ statt „nicht bestanden“ melden.
- Bei Buch-PRs die PDFs erst kurz vor dem Merge neu erzeugen und den Ablauf „main nachziehen, PDF neu rendern, publish-release -OhneAudio“ in docs/NEUE-GESCHICHTE.md festhalten.
- In `archive/` des Klons eine `SHA256SUMS-R47.txt` für Bundle und beide Patches ablegen.

```yaml
Reifegrad: v1.38 auf main, Paket aus main gebaut und inhaltsgleich mit R50; vier Drafts (v1.39, Anhang-Seite, Avatare, Aufbewahrung) auf main nachgezogen, CI gruen, untereinander konfliktfrei
Projektstatus: Upload v1.38 und Live-Pruefung R09 offen; Merges der Drafts beim Product Owner
Offene_Fragen:
  - Ist v1.38 hochgeladen (Voraussetzung R09)?
  - Wann darf der Papierkorb geleert werden?
  - Automatisches Loeschen gemergter Branches auf GitHub einschalten?
  - Kann der OneDrive-Klon ganz entfallen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
