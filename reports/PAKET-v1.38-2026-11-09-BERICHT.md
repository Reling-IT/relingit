# Paketbau v1.38 auf main (nach Schriften-Fix) – 09.11.2026

Stand: 2026-11-09, 04:42 bis 04:44 (Ortszeit). Auftrag von Bernd in der Sitzung (kein Queue-Eintrag). Branch main, Commit 01defe7 (enthält PR #23 Schriftpfade lesen.html und PR #22 Freigabeprüfung). Kein Upload, kein Tag.

## Ergebnis
Paket gebaut und bytegenau geprüft. Freigabeprüfung gelaufen: G1 bestanden, G7 auf main erwartungsgemäß nicht bestanden, G2 bis G6 offen, G8 gesperrt. Das Paket ist damit **nicht freigegeben**; G3 bis G5 und G8 liegen bei Bernd.

## Paket
- Befehl: `./scripts/build-upload.ps1 -OhneAudio`
- Datei: `output/ftp/relingit-upload-v1.38-2026-11-07-ohne-audio.zip` (lokal, nicht im Repo)
- Größe: 4 666 966 Bytes (4,67 MB / 4,45 MiB)
- SHA-256: `7118198F87CF602C68C3E6EB7992C87EA95302D5D6A1EEB291C143C0A762FAE4` (Skriptausgabe und `Get-FileHash` übereinstimmend)
- Skriptausgabe: „OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.“ / „OK: 35 aktuelle Quelldateien bytegenau im ZIP bestätigt.“ / Hinweis: Paket ohne Podcast-MP3, beim Upload die Live-MP3 nicht löschen.

### Dateiliste (36 Einträge, Größe in Bytes)

| Bytes | Datei |
|---:|---|
| 939 | .htaccess |
| 6426 | admin.html |
| 6861 | datenschutz.html |
| 1392 | handout-pdf.html |
| 2019 | handout.html |
| 1886 | impressum.html |
| 12249 | index.html |
| 2143 | lesen.html |
| 1387 | pdf.html |
| 1299 | assets/css/legal.css |
| 14181 | assets/css/styles.css |
| 4391 | assets/fonts/Fraunces-OFL.txt |
| 205500 | assets/fonts/Fraunces-Variable.woff2 |
| 2754 | assets/fonts/HERKUNFT.txt |
| 53408 | assets/fonts/IBMPlexMono-Italic.woff2 |
| 50400 | assets/fonts/IBMPlexMono-Medium.woff2 |
| 4456 | assets/fonts/IBMPlexMono-OFL.txt |
| 49248 | assets/fonts/IBMPlexMono-Regular.woff2 |
| 76284 | assets/fonts/WorkSans-Bold.woff2 |
| 66376 | assets/fonts/WorkSans-Italic.woff2 |
| 4396 | assets/fonts/WorkSans-OFL.txt |
| 71988 | assets/fonts/WorkSans-Regular.woff2 |
| 6752 | assets/img/favicon.png |
| 8423 | assets/img/reling-it-logo.svg |
| 1005947 | assets/img/reling-it-podcast-cover.png |
| 18682 | assets/js/admin.js |
| 4182 | assets/js/app.js |
| 4040 | assets/js/handout-viewer.js |
| 668 | assets/js/pdf-viewer.js |
| 7586 | assets/js/story-viewer.js |
| 246 | assets/js/supabase-config.js |
| 1617443 | story/current/fahrt-zum-kunden.html |
| 2065217 | story/current/geschichte.pdf |
| 7183 | story/current/workshop-handout.html |
| 105494 | story/current/workshop-handout.pdf |
| 3504 | UPLOAD-MANIFEST.txt |

## Freigabeprüfung
Befehl: `./scripts/freigabe-pruefen.ps1` auf main, Exit 1. Bericht `reports/FREIGABE-v1.38.md`, Sichtungsliste `reports/SICHTUNG-v1.38.md` (neu angelegt), beides lokal.

| Tor | Ergebnis | Nachweis (Auszug) |
|---|---|---|
| G1 Code | bestanden | ci-check.ps1 Exit 0; node --check 6 Dateien; Pester 21 bestanden, 0 fehlgeschlagen |
| G2 Kommentare | offen | kein Feature-Branch; Kopfkommentar je Skript bestanden (8 Skripte) |
| G3 Layout | offen | Sichtung PDF 0 von 6 |
| G4 UI | offen | Sichtung Webseiten 0 von 18 |
| G5 Inhalt | offen | Sichtung 0 von 2 |
| G6 Lokal | offen | 0 von 4 MP3 lokal (Paket ohne Audio); Vorschau möglich |
| G7 Git | nicht bestanden | „Branch ist main; Freigabe wird auf dem Feature-Branch vor dem Merge geprüft“ |
| G8 Freigabe Bernd | gesperrt | Voraussetzungen fehlen |

Einordnung: G7 scheitert systembedingt, weil das Skript für Feature-Branches vor dem Merge gebaut ist; v1.38 ist bereits in main. Kein Codefehler.

## Lokale Ausgaben (C:\dev\relingit\reports, per .gitignore ausgenommen)
- build-upload-2026-11-09.log, freigabe-pruefen-2026-11-09.log
- paket-dateiliste-v1.38-2026-11-09.txt
- FREIGABE-v1.38.md, SICHTUNG-v1.38.md

## Befunde
- `assets/img/avatare/` ist nicht im Paket. Solange die Webseite die Avatare nicht verwendet, ist das folgenlos; R11 (heute als Draft-PR) muss das Verzeichnis in build-upload.ps1 aufnehmen.
- Paketname trägt das Datum aus app.js (2026-11-07), nicht das Baudatum.

## Vorschläge und Ideen (Claude)
- freigabe-pruefen.ps1 um einen Modus `-NachMerge` ergänzen: auf main gilt G7 als bestanden, wenn HEAD gleich origin/main und der Release-PR gemergt ist. Dann ist ein Lauf nach dem Merge aussagekräftig.
- G6 bei `-OhneAudio` als „nicht zutreffend“ werten (Vorschlag schon in R43).
- Den SHA-256 des Pakets automatisch in reports/ ablegen (z. B. `<paket>.zip.sha256`), damit er beim Upload gegengeprüft werden kann.

Hygiene: Remote nur main, ops/queue, ops/reports und heutige Auftragsbranches; offene PRs: heutige Drafts R06, R07, R11; kein Upload, kein Tag, kein Merge.

```yaml
Reifegrad: Paket v1.38 ohne Audio reproduzierbar gebaut und geprueft; manuelle Tore offen
Projektstatus: Upload-Paket bereit zur Sichtung durch Bernd, nicht freigegeben
Offene_Fragen:
  - Sichtung G3 bis G5 und Freigabe G8 durch Bernd vor dem Upload
  - Soll freigabe-pruefen.ps1 einen Modus fuer den Stand nach dem Merge bekommen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
