# Podcast „Die Geschichte zum Hören“

Die Landingpage (`index.html`, Abschnitt `#podcast`) bindet vier KI-generierte
Audio-Zusammenfassungen und ein Cover-Bild ein. Die Dateien werden vom
DomainFactory-Webspace ausgeliefert (siehe `datenschutz.html`, Abschnitt 4).

## Dateien

Die vier MP3 sind zusammen 74 222 992 Byte (rund 74,2 MB bzw. 70,8 MiB) groß
und werden deshalb nicht versioniert; `.gitignore` schließt `assets/audio/*.mp3`
aus. Versioniert sind seit R36:

- `assets/audio/SHA256SUMS.txt`: Prüfsummen und Größen in Byte der vier MP3
  (Format von `sha256sum`, Größen als Kommentarzeilen `# groesse <Byte> <Datei>`),
- `assets/img/reling-it-podcast-cover.png`: das Cover (Freigabe Bernd, 07.11.2026).

| Folge | Datei (Einbindungspfad) | Größe | SHA-256 |
|---|---|---|---|
| 01 KI als Beifahrer im IT-Systemhaus (11:44) | `assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3` | 11 262 465 B (10,7 MiB) | `4098a1416ca256dbc518c7786b0909b1bc63be9ab63ebdbfbe8150d2029accff` |
| 02 Vom manuellen Logbuch zum KI-gestützten Ticketsystem (19:23) | `assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3` | 18 608 515 B (17,7 MiB) | `9e4e409963d969474096da0f236b2c6094b15284a45da43277dff62895df2bad` |
| 03 Warum KI im Systemhaus nicht lenken darf (23:10) | `assets/audio/warum-ki-nicht-lenken-darf.mp3` | 22 233 475 B (21,2 MiB) | `63091782bf2d8c62020fc69a2746887cdb7fbb136b1c4006be23f2f793ade844` |
| 04 Ein Roman als Blaupause für verantwortungsvolle KI (23:02) | `assets/audio/roman-als-ki-blaupause.mp3` | 22 118 537 B (21,1 MiB) | `816100ff810bcbcef4dd965f0ceb1bcecd1f8de12064f7c02d25968a6b2d9f30` |
| Cover | `assets/img/reling-it-podcast-cover.png` | 1 005 947 B | `6068294ea84e215e20d265d949b32d01f024cd4d9a7cbfee832b9d4be28d9edd` |

Quelle der Werte: Bericht R23 vom 07.11.2026 (Messung im OneDrive-Ordner),
gegengeprüft in R36 am 08.11.2026. Die Seite nennt seit R36 Dezimal-MB
(11,3 / 18,6 / 22,2 / 22,1 MB), vorher standen dort die MiB-Werte mit „MB“.

Prüfen lokal (Git Bash bzw. PowerShell):

```sh
cd assets/audio && sha256sum -c SHA256SUMS.txt
```

```powershell
Get-FileHash -Algorithm SHA256 assets/audio/*.mp3
```

Prüfen live, ohne Download (HTTP HEAD, vergleicht `Content-Length` mit den
Größen aus `SHA256SUMS.txt`; nur lesend, kein FTP):

```powershell
./scripts/pruefe-podcast-live.ps1           # echte HEAD-Anfragen
./scripts/pruefe-podcast-live.ps1 -Trocken  # nur geplante Anfragen anzeigen
```

## Ablageort

- Arbeitsstand: `C:\Users\bmarn\OneDrive\HTML\reling it\assets\audio\` und
  `…\assets\img\reling-it-podcast-cover.png`
- Kopie im selben OneDrive: `output/ftp/relingit-upload-v1.37-2026-09-05-podcast/`
  (keine unabhängige Sicherung, weil derselbe Speicherort)
- Live: `https://berndmarnau.de/relingit/assets/audio/<datei>.mp3`

Für einen Paketbau mit Audio aus einem anderen Klon die vier MP3 an die oben
genannten Einbindungspfade kopieren.

## Verhalten der Skripte

- `scripts/ci-check.ps1`: Fehlen die MP3 (immer in GitHub Actions), meldet
  die Prüfung einen Hinweis und keinen Fehler. Die Verweisprüfung überspringt
  nur genau diese vier Pfade in `index.html` und nur dann, wenn sie fehlen.
  Sind die MP3 vorhanden, prüft sie MP3-Kennung und Größe gegen
  `SHA256SUMS.txt`. Immer Pflicht: das Cover (PNG-Kennung), eine
  `SHA256SUMS.txt` mit Prüfsumme und Größe für genau die vier MP3, die
  Einbindung aller fünf Dateien in `index.html` und die sichtbare
  Quellenangabe „Google NotebookLM“ und „KI-generiert“.
- `scripts/build-upload.ps1` (und damit `publish-release.ps1`): bricht ab,
  bevor ein Paketordner angelegt wird, wenn eine MP3 fehlt oder ihre SHA-256
  nicht zu `SHA256SUMS.txt` passt. Ein FTP-Paket ohne Podcast kann so nicht
  unbemerkt entstehen.
- `-OhneAudio` (bei `build-upload.ps1` und `publish-release.ps1`): Für
  Textkorrekturen ohne neue Folgen. Die MP3 werden weder verlangt noch in ZIP
  und Manifest aufgenommen, der Paketname endet auf `-ohne-audio`, das Manifest
  trägt den Hinweis „Ohne Audio“. Beim Upload die Live-MP3 auf dem Server nicht
  löschen; danach `pruefe-podcast-live.ps1` ausführen.

## Regel für neue Folgen

Den Podcast nur neu erzeugen, wenn der Erzähltext geändert wurde. Dann:

1. Neue MP3 an den Einbindungspfad legen (gleicher Name oder neuer Name plus
   Anpassung in `index.html`, `ci-check.ps1`, `build-upload.ps1` und
   `tests/TestHelfer.ps1`).
2. Größe, Dauer und SHA-256 in dieser Datei, in `assets/audio/SHA256SUMS.txt`
   und in `index.html` (Dezimal-MB) nachtragen.
3. Zusätzliche Sicherung außerhalb von OneDrive anlegen (Vorschlag siehe unten).

## Offene Frage an den Owner

Werkzeug: `datenschutz.html`, `index.html` und `ci-check.ps1` nennen
**Google NotebookLM** (so auch live). `docs/NEUE-GESCHICHTE.md` §6 und
`docs/vorlagen/EINBAU-CHECKLISTE.md` nennen **Google Gemini**. Bis zur Klärung bleibt der
Live-Text (NotebookLM) unverändert. Bei einem Wechsel müssen Datenschutz,
Quellenangabe, FAQ und die Prüfung in `ci-check.ps1` gemeinsam angepasst werden.

## Sicherung (Vorschlag, nicht umgesetzt)

Zusätzlich zu OneDrive die vier MP3 als Assets eines GitHub-Release
(z. B. `podcast-2026-10`) ablegen und die Prüfsummen oben dagegen vergleichen.
Die Entscheidung liegt beim Owner (siehe Bericht R23, Option A + C).
