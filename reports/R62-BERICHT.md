---
id: R62
titel: 'scripts/pruefe-paket.ps1: ZIP gegen Manifest und Vorgänger-Paket prüfen (Draft-PR)'
status: erledigt
start: 2026-11-11 05:59:29
ende: 2026-11-11 06:29:07
branch: auftrag-R62-pruefe-paket
pr: '#34 (Draft)'
commit: 82ddf15dc76038139b860e59e2db3605fc0635a5
ci: 'grün („Website prüfen“, 11 s)'
---

# R62: scripts/pruefe-paket.ps1

## Ergebnis

- Neues Skript `scripts/pruefe-paket.ps1` mit `-Zip` (Pflicht), `-Vorgaenger` (optional, ZIP oder entpackter Ordner) und `-ErwartetHash` (optional).
  - Es prüft jede Datei im ZIP per SHA-256 gegen `UPLOAD-MANIFEST.txt` und zählt die Einträge.
  - Es meldet Dateien, die im Manifest stehen, aber im ZIP fehlen, und Dateien im ZIP ohne Manifestzeile.
  - Gegenüber dem Vorgänger meldet es je Nutzdatei geändert, neu oder unverändert, dazu Dateien, die nur im Vorgänger stehen.
  - Die Ausgabe ist eine Markdown-Tabelle wie in der Upload-Checkliste R51. Die Reihenfolge folgt dem Manifest, also der Paketliste von `build-upload.ps1`; das Manifest selbst steht zuletzt.
- Exit-Codes wie `scripts/ordner-hash.ps1`: 0 Paket gleich Manifest, 1 Abweichung, 2 Abbruch ohne Prüfung.
- Neue Datei `tests/pruefe-paket.Tests.ps1` mit 9 Tests. Sie baut kleine Test-ZIPs im TestDrive und läuft mit Pester 3.4 und 5.
- `docs/ABLAUF.md`: neuer Abschnitt ganz am Ende der Datei.
- README bleibt unverändert. `ci-check.ps1` und die Tests erwarten keine vollständige Liste der Skripte. #32 ändert genau die README-Zeilen, die dafür in Frage kämen; eine Änderung hätte einen Konflikt erzeugt.
- Draft-PR #34, Head `82ddf15`, CI grün, signierter Commit.
- Worktree `C:\dev\wt-r62` bleibt für den offenen PR stehen.

## Probelauf (nur lesend)

Aufruf im Arbeitsklon:

```
pwsh -File C:/dev/wt-r62/scripts/pruefe-paket.ps1 -Zip output/ftp/relingit-upload-v1.38-2026-11-07-ohne-audio.zip -Vorgaenger archive/ftp-packages/20261110-052115-235/relingit-upload-v1.37-2026-09-05.zip -ErwartetHash 766923139AD9955DCBAB3678783DBCEC96FFA91E0CDA2F8CF945D554542C984C
```

| Kennzahl | pruefe-paket.ps1 | Checkliste R51 | Bewertung |
|---|---|---|---|
| ZIP-Hash | `766923139AD9…984C`, gleich `-ErwartetHash` | `766923139AD9…984C` | gleich |
| Größe | 4 666 884 Byte | 4 666 884 Byte | gleich |
| Einträge | 36 (35 Nutzdateien + Manifest) | 36 | gleich |
| Manifest | 35 Prüfsummen, 35 gleich, 0 abweichend, 0 fehlend, 0 zusätzlich | 35 = 35 | gleich |
| Manifest-Kopf | 1.38, 7. November 2026, erstellt 2026-11-10 05:21:18 +01:00, ohne Audio | gleich | gleich |
| Vorgänger v1.37 | SHA-256 `A710D248…747A`, 24 Einträge | `A710D248…747A`, 24 Einträge | gleich |
| geändert oder neu | 22 (10 geändert, 12 neu) | 22 | gleich |
| unverändert | 13 | 13 | gleich |
| entfallen | 0 | nicht ausgewiesen | 23 Nutzdateien v1.37 = 10 + 13 |
| je Datei | 36 Zeilen: SHA-256, Byte und ja/nein stimmen mit R51 Nr. 1 bis 36 überein | – | gleich |
| Exit-Code | 0 | – | – |

Die 12 neuen Dateien sind die 11 Schriftdateien in `assets/fonts` und das Podcast-Cover. Die 10 geänderten sind 4 HTML-Seiten, `styles.css`, 3 JS-Dateien und 2 Dateien in `story/current`. Das Skript trennt „geändert“ und „neu“. R51 fasst beides als „ja“ bzw. „ja (neu)“ zusammen. In der Summe gibt es keine Abweichung.

Gegenprobe: das Paket `archive/ftp-packages/20261110-052115-235/relingit-upload-v1.38-2026-11-07-ohne-audio.zip` mit dem Vermerk „NICHT HOCHLADEN“ in R51, Abschnitt 8.
- Mit `-ErwartetHash 7669…984C` endet der Lauf mit **Exit 1** („ZIP-Hash ungleich -ErwartetHash“).
- Gegen das richtige Paket als Vorgänger zeigt es 2 geänderte Dateien, wie in R51 (Buch-HTML und PDF), und 33 unveränderte.

Nach den Läufen war nichts verändert: `output/ftp` und `archive/ftp-packages` haben dieselben Änderungszeiten, der ZIP-Hash ist weiter `7669…984C`, und `git status` im Arbeitsklon ist leer.

## Prüfungen mit Belegen

| Prüfung | Ergebnis |
|---|---|
| `Invoke-Pester -Path tests`, Pester 3.4.0, 3 Läufe | 30/30, 30/30, 30/30 bestanden, 0 fehlgeschlagen (402 s, 317 s, 241 s) |
| `Invoke-Pester -Path tests`, Pester 5.7.1, nur zum Testen in den Scratchpad geladen | Lauf 1: 30/30 bestanden (248 s). Läufe 2 und 3 wurden nicht beendet, weil die Umgebung den Hintergrundprozess bei Speichermangel gestoppt hat. Sie wurden nicht neu gestartet. |
| `tests/pruefe-paket.Tests.ps1` allein (Pester 3.4) | 9/9 |
| `scripts/ci-check.ps1` im Worktree | Exit 0 |
| `git diff --check` | ohne Befund |
| CI #34 „Website prüfen“ | pass (11 s) |
| `git merge-tree --write-tree` R62 mit `origin/auftrag-R55-ordner-hash` (#30) | ohne Konflikt |
| `git merge-tree --write-tree` R62 mit `origin/auftrag-R56-aufraeumen-pruefen` (#32) | ohne Konflikt |
| Kreuzprüfung mit nachgestelltem Merge: R62 + #30 bzw. R62 + #32 in einem temporären Worktree, danach entfernt | Merge sauber, `ci-check` Exit 0, `pruefe-paket.Tests` 9/9, in beiden Fällen |
| `git merge-tree` #30 mit #32 | **Konflikt** in `docs/ABLAUF.md`: beide fügen vor „Belegtabelle“ ein. R62 ist davon nicht betroffen. |

Die Tests decken ab:
- OK-Fall mit Zählung
- Vorgänger-Vergleich mit allen vier Zuständen
- Vorgänger als Ordner
- `-ErwartetHash` gleich und abweichend
- Prüfsumme ungleich Manifest
- fehlende und zusätzliche Dateien
- fehlendes Manifest
- Exit 2 bei fehlendem oder unlesbarem ZIP und bei fehlendem Vorgänger
- nur lesend: Testordner und Temp-Verzeichnis unverändert

## Abweichungen und Risiken

- **Kein Entpacken nach temp.** Der Auftrag nennt „entpackt nur nach temp“. Das Skript liest die Einträge stattdessen direkt aus dem ZIP und hasht sie. Das ist strenger als verlangt: Es entsteht kein temporärer Ordner, der aufgeräumt werden müsste. Die geprüften Bytes sind dieselben.
- **Pester 5 nur einmal vollständig gelaufen** (siehe Tabelle). Mit Pester 3.4 gab es drei stabile Läufe.
- **Umlaute in der Ausgabe:** Wird `pwsh -File` aus einer anderen Shell aufgerufen und umgeleitet, kodiert pwsh die Umlaute nach der Konsolen-Codepage. In Git Bash erscheinen sie dann verstümmelt. Innerhalb von pwsh (`./scripts/pruefe-paket.ps1 > datei.md`) schreibt pwsh 7 UTF-8. Die Tests setzen die Kodierung wie `Invoke-MiniSkript` auf UTF-8. `ordner-hash.ps1` verhält sich genauso.
- **Linux:** Das Skript nutzt nur .NET-ZIP-APIs und `Get-FileHash`, keine Windows-Pfade. Die Tests bauen die Einträge mit `/`. Ein Lauf unter Linux ist nicht belegt, weil Pester in der CI derzeit nicht läuft.
- `docs/ABLAUF.md` wird weiter von drei offenen PRs ergänzt. Die Reihenfolge der Abschnitte hängt vom Merge ab.

## Vorschläge und Ideen (Claude)

- `build-upload.ps1` könnte am Ende `pruefe-paket.ps1 -Zip <neu> -Vorgaenger <letztes Archivpaket>` aufrufen und die Tabelle neben das ZIP schreiben. Die Checkliste entstünde dann bei jedem Bau mit.
- Ein Schalter `-NurGeaendert` könnte die Liste der geänderten und neuen Dateien als einfache Pfadliste ausgeben, als Vorlage für einen gezielten FTP-Upload (Vorschlag „Nur-Geänderte-Ordner“ aus R51), ohne dass etwas kopiert wird.
- #30 und #32 vor dem Merge so abstimmen, dass sich die Abschnitte in `docs/ABLAUF.md` nicht mehr überschneiden, z. B. #32 rebasen, nachdem #30 gemergt ist.
- Pester in der CI (ubuntu, pwsh vorinstalliert) als eigener Schritt, zunächst nur für die schnellen Tests ohne `pdftotext` (`ordner-hash`, `pruefe-paket`, `aufraeumen-pruefen`). Das betrifft `.github/workflows` und braucht einen eigenen Auftrag.
- In R51 die Spalte „geändert ggü. v1.37“ künftig wie das Skript in „geändert“ und „neu“ trennen. Dann lässt sich die Tabelle direkt vergleichen.

Hygiene: gemergte Remote-Branches 0 (`git branch -r --merged origin/main` nach `fetch --prune` ohne Treffer außer main). Offene PRs 9: #25, #26, #27, #28, #30, #31, #32, #33, #34, alle Draft. Drafts 9, dieselben. Worktrees: Arbeitsklon, wt-r06, wt-r41, wt-rep und neu wt-r62 (gehört zu #34). Der temporäre Prüf-Worktree wurde entfernt.

```yaml
Reifegrad: "pruefe-paket.ps1 als Draft #34, CI grün; Probelauf v1.38 gegen v1.37 reproduziert R51 exakt (36 Einträge, 35/35 Manifest, 22 geändert/neu, 13 unverändert, ZIP-Hash gleich)"
Projektstatus: "R62 erledigt (Draft #34, kein Merge). Upload v1.38 durch den Product Owner weiter offen; Tore G3–G5 offen, G8 beim Product Owner. #30 und #32 kollidieren untereinander in docs/ABLAUF.md"
Offene_Fragen:
  - "Soll build-upload.ps1 pruefe-paket.ps1 künftig automatisch mit dem letzten Archivpaket als Vorgänger aufrufen?"
  - "In welcher Reihenfolge werden #30, #32 und #34 gemergt (Konflikt #30/#32 in docs/ABLAUF.md)?"
  - "Soll Pester in der CI laufen (eigener Auftrag, Änderung an .github/workflows)?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schaetzung"
```

## Gegenprobe Koordinator (11.11.2026)

Unabhängiger Lauf im Worktree C:/dev/wt-r62 (82ddf15) gegen `output/ftp/relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, Vorgänger `archive/ftp-packages/20261110-052115-235/relingit-upload-v1.37-2026-09-05.zip`, mit `-ErwartetHash 7669…984C`: Exit 0; „35 gleich, 0 abweichend, 0 fehlen im ZIP, 0 zusätzlich“; „22 geändert oder neu (10 geändert, 12 neu), 13 unverändert, 0 entfallen“; „ZIP-Hash: gleich -ErwartetHash“. Arbeitsklon danach unverändert (`git status --porcelain` leer).
