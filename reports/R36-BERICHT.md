---
id: R36
titel: 'Podcast-Hilfen: Schalter -OhneAudio im Paketbau, Live-Längenvergleich, MB/MiB-Angaben'
status: erledigt (PR offen, nicht gemergt)
start: 2026-11-08T05:05+01:00
ende: 2026-11-08T05:35+01:00
branch: auftrag-R36-podcast-hilfen
pr: https://github.com/Reling-IT/relingit/pull/20
commit: 11d41da
ci: 'bestanden, Lauf 42447025826 (Job „Website prüfen“, 10 s), als PR-Kommentar festgehalten'
---

# R36 Bericht: Podcast-Hilfen

## Ziel

Textkorrekturen sollen sich hochladen lassen, ohne die 74 MB MP3 erneut zu übertragen. Die Live-MP3 sollen sich ohne Download prüfen lassen. Dazu kommt das Delta aus R34: Prüfsummendatei, lokale Hash-Prüfung und Cover im Repo.

## Änderungen

| Datei | Änderung |
|---|---|
| `assets/audio/SHA256SUMS.txt` (neu) | SHA-256 der vier MP3 im `sha256sum`-Format, Größen in Byte als Kommentarzeilen `# groesse <Byte> <Datei>` |
| `assets/img/reling-it-podcast-cover.png` (neu) | Cover committet. SHA-256 6068294e… gegengeprüft, 1 005 947 Byte |
| `.gitignore` | Zeile für das Cover entfernt, Kommentar aktualisiert |
| `.gitattributes` | `SHA256SUMS.txt` immer mit LF, damit `sha256sum -c` auch unter Windows sauber läuft |
| `scripts/build-upload.ps1` | Hash-Prüfung der MP3 gegen `SHA256SUMS.txt` vor dem Paketordner. Schalter `-OhneAudio`: MP3 werden weder verlangt noch in ZIP, Manifest oder Nachkontrolle aufgenommen. Der Name erhält `-ohne-audio`, das Manifest den Hinweis „Ohne Audio“. Ohne Schalter bleibt das Verhalten wie bisher |
| `scripts/publish-release.ps1` | `-OhneAudio` wird an `build-upload.ps1` durchgereicht |
| `scripts/ci-check.ps1` | Das Cover ist Pflicht. `SHA256SUMS.txt` muss genau die vier MP3 mit Prüfsumme und Größe nennen. Vorhandene MP3 werden auf Größe geprüft. Ohne MP3 gibt es weiter nur einen Hinweis, CI bleibt grün |
| `scripts/pruefe-podcast-live.ps1` (neu) | HTTP HEAD auf die vier Live-MP3, vergleicht `Content-Length` mit `SHA256SUMS.txt`. Nur lesend, kein Download, kein FTP. `-Trocken` zeigt nur die geplanten Anfragen |
| `index.html` | Größen in Dezimal-MB: 10,7/17,7/21,2/21,1 MB werden zu 11,3/18,6/22,2/22,1 MB. Die Zeichenzahl bleibt gleich, daher kein Layoutrisiko |
| `tests/build-upload.Tests.ps1` (neu), `tests/TestHelfer.ps1` | 7 neue Testfälle, Hilfsfunktionen `New-PodcastMp3` und `Get-ZipEintraege`. Das Mini-Projekt erhält jetzt die Prüfsummendatei und ein PNG-Kurzcover |
| `docs/PODCAST.md`, `README.md`, `docs/DOMAINFACTORY-DEPLOYMENT.md` | Neuer Stand: Cover versioniert, Prüfsummendatei, `-OhneAudio`, Live-Prüfung |

Gegenprüfung der Quellwerte im OneDrive-Ordner, nur lesend: `Get-FileHash` für die vier MP3 und das Cover stimmt mit `docs/PODCAST.md` überein. `sha256sum -c SHA256SUMS.txt` im OneDrive-Audioordner ergibt 4× „OK“, Exit 0.

## Ausgabe der Skripte (ohne FTP, ohne Upload)

`scripts/pruefe-podcast-live.ps1 -Trocken` (Exit 0):

```text
Trocken: HEAD https://berndmarnau.de/relingit/assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3 (erwartet 11262465 Byte)
Trocken: HEAD https://berndmarnau.de/relingit/assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3 (erwartet 18608515 Byte)
Trocken: HEAD https://berndmarnau.de/relingit/assets/audio/warum-ki-nicht-lenken-darf.mp3 (erwartet 22233475 Byte)
Trocken: HEAD https://berndmarnau.de/relingit/assets/audio/roman-als-ki-blaupause.mp3 (erwartet 22118537 Byte)
Trockenlauf: 4 Anfragen geplant, kein Netzwerkzugriff.
```

`scripts/pruefe-podcast-live.ps1`, echter HEAD-Lauf ohne Download (Exit 0):

```text
OK: ki-als-beifahrer-im-it-systemhaus.mp3 11262465 Byte (HTTP 200, audio/mpeg, Last-Modified Tue, 20 Oct 2026 18:36:56 GMT)
OK: vom-logbuch-zum-ki-ticketsystem.mp3 18608515 Byte (HTTP 200, audio/mpeg, Last-Modified Tue, 20 Oct 2026 18:36:56 GMT)
OK: warum-ki-nicht-lenken-darf.mp3 22233475 Byte (HTTP 200, audio/mpeg, Last-Modified Tue, 20 Oct 2026 18:36:56 GMT)
OK: roman-als-ki-blaupause.mp3 22118537 Byte (HTTP 200, audio/mpeg, Last-Modified Tue, 20 Oct 2026 18:36:56 GMT)
OK: 4 Live-MP3 unter https://berndmarnau.de/relingit/ haben die Größe aus assets/audio/SHA256SUMS.txt.
```

`scripts/build-upload.ps1 -OhneAudio -Suffix r36test` baut nur lokal ein Paket unter `output/ftp` im Worktree, ohne Upload (Exit 0). Das ZIP hat 3 902 302 Byte, das Manifest enthält keine MP3.

```text
Hinweis: 4 von 4 Podcast-MP3 liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). build-upload.ps1 baut ohne sie nur mit -OhneAudio ein Paket.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
OK: geprüftes Upload-Paket erstellt: C:\dev\wt-r36\output\ftp\relingit-upload-v1.37-2026-09-05-r36test-ohne-audio.zip
OK: 24 aktuelle Quelldateien bytegenau im ZIP bestätigt.
Hinweis: Paket ohne Podcast-MP3 (-OhneAudio). Beim Upload die Live-MP3 nicht löschen.
SHA-256 des ZIP: 7B1721B7886E9072B19F10F1A2F2E85AFBBF0129A0512626B0285A310A503B11
```

`scripts/build-upload.ps1 -Suffix r36test` lief mit den MP3, die aus OneDrive in den Worktree kopiert waren (git-ignoriert). Exit 0, ZIP 72 922 303 Byte:

```text
OK: 4 Podcast-MP3 lokal vorhanden, Dateikennungen und Größen geprüft.
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
OK: 4 Podcast-MP3 entsprechen assets/audio/SHA256SUMS.txt.
OK: geprüftes Upload-Paket erstellt: C:\dev\wt-r36\output\ftp\relingit-upload-v1.37-2026-09-05-r36test.zip
OK: 28 aktuelle Quelldateien bytegenau im ZIP bestätigt.
SHA-256 des ZIP: 547E35C7045477CBECA4B3254D8D8D4EA669B807C052D55825C9EAE2EFA9F60F
```

Danach habe ich die MP3-Kopien und `output/` im Worktree gelöscht. Der Worktree ist sauber.

## Tests

`Invoke-Pester -Path tests` mit Pester 3.4.0 unter pwsh: **Passed 15, Failed 0, Skipped 0**, 422 s.

Davon neu:
- **build-upload.ps1**
  - Abbruch ohne `-OhneAudio` bei fehlenden MP3, ohne `output/ftp` anzulegen.
  - `-OhneAudio` baut ein ZIP ohne MP3, Manifest ohne MP3 und mit Hinweis, Cover und `index.html` sind enthalten.
  - Abbruch bei falscher Größe; ci-check greift hier schon vorher.
  - Abbruch bei gleicher Größe und anderer Prüfsumme.
  - Gegenprobe: Mit passenden MP3 landen 4 MP3 im ZIP.
- **ci-check.ps1**
  - Fehlende Größenangabe wird gemeldet.
  - Fehlendes Cover wird gemeldet.

Die 8 bestehenden Tests aus R24 bleiben grün.

## ci-check, diff-check, CI

- `pwsh -File scripts/ci-check.ps1` im Worktree ohne MP3: Exit 0, mit dem Hinweis „4 von 4 Podcast-MP3 liegen nicht vor“.
- `git diff --cached --check`: ohne Befund.
- CI auf PR #20, Commit 11d41da: „Website prüfen“ **pass** (10 s), https://github.com/Reling-IT/relingit/actions/runs/42447025826. Ergebnis als PR-Kommentar: https://github.com/Reling-IT/relingit/pull/20#issuecomment-6717249132

PR: https://github.com/Reling-IT/relingit/pull/20 (kein Draft, nicht gemergt)

## Offene Fragen, Risiken, Abweichungen

- **Konflikte mit offenen PRs möglich**: #17 (R37) und #18 (R35) ändern ebenfalls `docs/PODCAST.md`, #19 (R40) ändert `index.html`. Wer zuletzt merged, muss die Konflikte auflösen. Bei `index.html` betrifft R36 nur die vier `MP3 · … MB`-Angaben.
- **Abweichung**: `index.html` wurde direkt geändert. Statt „MiB“ zu schreiben, habe ich auf Dezimal-MB umgerechnet. Die Länge bleibt gleich, und MB ist für Leser vertrauter. Ist „MiB“ gewünscht, sind das vier Zeichen.
- **Abweichung (Ergänzung)**: `publish-release.ps1` hat ebenfalls `-OhneAudio` bekommen (reine Weitergabe). Das stand nicht ausdrücklich im Auftrag, ohne die Weitergabe hätte der Standardablauf den Schalter aber nicht nutzen können.
- **Verhaltensänderung**: ci-check verlangt jetzt das Cover und `SHA256SUMS.txt`. Ein Klon ohne diese Dateien wird rot. Das ist gewollt, weil beide jetzt versioniert sind.
- **Risiko**: Bei einem Upload mit `-OhneAudio` darf der FTP-Client die Live-MP3 nicht löschen, etwa bei einer Spiegel- oder Synchronisationsfunktion. Darauf weisen Skriptausgabe, Manifest und Doku hin. Erzwingen lässt es sich nicht.
- Pester läuft nicht in der CI. Grund: keine Workflow-Änderung erlaubt.

## Vorschläge und Ideen (Claude)

1. Pester-Tests in `ci.yml` aufnehmen (eigener Auftrag, Workflow-Änderung). Die Tests laufen mit Pester 3.4 und brauchen bis auf zwei Fälle nur pwsh. Die zwei Fälle mit `pdftotext` werden ohne das Werkzeug übersprungen.
2. ci-check könnte die MB-Angaben in `index.html` aus den Größen in `SHA256SUMS.txt` berechnen und vergleichen. Dann können Seite und Prüfsummendatei bei neuen Folgen nicht auseinanderlaufen.
3. `pruefe-podcast-live.ps1` könnte zusätzlich das Cover per HEAD prüfen (Größe aus Git). Die Prüfung sollte als Pflichtschritt nach jedem Upload in die Checkliste, vor allem nach `-OhneAudio`.
4. Die Zeilennummern-Belege in `docs/ABLAUF.md` stimmen schon vor R36 nicht mehr, z. B. `publish-release.ps1:125`. Ich schlage Abschnittsnamen statt Zeilennummern vor.
5. Die Pester-Laufzeit von rund 7 Minuten liegt fast nur am Start der pwsh-Prozesse. Eine gemeinsame Mini-Projekt-Vorlage je Describe würde die Tests spürbar beschleunigen.

Hygiene: 1 gemergter Remote-Branch übrig (`quelle-pdf-werkzeuge-20261106`, Löschkandidat). Offene PRs: #20 (R36), #19, #18, #17, #6, Drafts #10 und #9. Der Worktree `C:/dev/wt-r36` kann nach dem Merge entfernt werden.

```yaml
Reifegrad: "Podcast-Paketbau mit Hash-Prüfung und -OhneAudio, Live-Prüfung per HEAD, Cover versioniert; Pester 15/15 lokal, CI grün (PR #20, offen)"
Projektstatus: "R36 erledigt, PR #20 wartet auf Review und Merge"
Offene_Fragen:
  - "Dezimal-MB auf index.html in Ordnung oder lieber MiB schreiben?"
  - "Pester-Tests in die CI aufnehmen (Workflow-Auftrag)?"
  - "Merge-Reihenfolge mit #17, #18 (docs/PODCAST.md) und #19 (index.html)?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
