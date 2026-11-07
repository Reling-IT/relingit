# Podcast „Die Geschichte zum Hören“

Die Landingpage (`index.html`, Abschnitt `#podcast`) bindet vier KI-generierte
Audio-Zusammenfassungen und ein Cover-Bild ein. Die Dateien werden vom
DomainFactory-Webspace ausgeliefert (siehe `datenschutz.html`, Abschnitt 4).

## Dateien (nicht im Repository)

Die MP3 und das Cover sind zusammen rund 72 MB groß und werden deshalb nicht
versioniert. `.gitignore` schließt `assets/audio/*.mp3` und
`assets/img/reling-it-podcast-cover.png` aus.

| Folge | Datei (Einbindungspfad) | Größe | SHA-256 |
|---|---|---|---|
| 01 KI als Beifahrer im IT-Systemhaus (11:44) | `assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3` | 11 262 465 B (10,7 MiB) | `4098a1416ca256dbc518c7786b0909b1bc63be9ab63ebdbfbe8150d2029accff` |
| 02 Vom manuellen Logbuch zum KI-gestützten Ticketsystem (19:23) | `assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3` | 18 608 515 B (17,7 MiB) | `9e4e409963d969474096da0f236b2c6094b15284a45da43277dff62895df2bad` |
| 03 Warum KI im Systemhaus nicht lenken darf (23:10) | `assets/audio/warum-ki-nicht-lenken-darf.mp3` | 22 233 475 B (21,2 MiB) | `63091782bf2d8c62020fc69a2746887cdb7fbb136b1c4006be23f2f793ade844` |
| 04 Ein Roman als Blaupause für verantwortungsvolle KI (23:02) | `assets/audio/roman-als-ki-blaupause.mp3` | 22 118 537 B (21,1 MiB) | `816100ff810bcbcef4dd965f0ceb1bcecd1f8de12064f7c02d25968a6b2d9f30` |
| Cover | `assets/img/reling-it-podcast-cover.png` | 1 005 947 B | `6068294ea84e215e20d265d949b32d01f024cd4d9a7cbfee832b9d4be28d9edd` |

Quelle der Werte: Bericht R23 vom 07.11.2026 (Messung im OneDrive-Ordner). Die
Größenangaben auf der Seite („10,7 MB“ usw.) sind MiB-Werte.

Prüfen unter PowerShell im Projektordner:

```powershell
Get-FileHash -Algorithm SHA256 assets/audio/*.mp3, assets/img/reling-it-podcast-cover.png
```

## Ablageort

- Arbeitsstand: `C:\Users\bmarn\OneDrive\HTML\reling it\assets\audio\` und
  `…\assets\img\reling-it-podcast-cover.png`
- Kopie im selben OneDrive: `output/ftp/relingit-upload-v1.37-2026-09-05-podcast/`
  (keine unabhängige Sicherung, weil derselbe Speicherort)
- Live: `https://berndmarnau.de/relingit/assets/audio/<datei>.mp3`

Für einen Paketbau aus einem anderen Klon die fünf Dateien an die oben genannten
Einbindungspfade kopieren.

## Verhalten der Skripte

- `scripts/ci-check.ps1`: Fehlen die Dateien (immer in GitHub Actions), meldet
  die Prüfung einen Hinweis und keinen Fehler. Die Verweisprüfung überspringt
  nur genau diese fünf Pfade in `index.html` und nur dann, wenn sie fehlen.
  Sind die Dateien vorhanden, prüft sie die MP3- bzw. PNG-Kennung. Immer Pflicht:
  Jede der fünf Dateien muss in `index.html` noch eingebunden sein, und die
  Seite muss die sichtbare Quellenangabe „Google NotebookLM“ und
  „KI-generiert“ enthalten.
- `scripts/build-upload.ps1` (und damit `publish-release.ps1`): bricht ab,
  bevor ein Paketordner angelegt wird, wenn eine der Dateien fehlt. Ein
  FTP-Paket ohne Podcast kann so nicht unbemerkt entstehen.

## Regel für neue Folgen

Den Podcast nur neu erzeugen, wenn der Erzähltext geändert wurde. Dann:

1. Neue MP3 an den Einbindungspfad legen (gleicher Name oder neuer Name plus
   Anpassung in `index.html`, `ci-check.ps1` und `build-upload.ps1`).
2. Größe, Dauer und SHA-256 in dieser Datei und in `index.html` nachtragen.
3. Zusätzliche Sicherung außerhalb von OneDrive anlegen (Vorschlag siehe unten).

## Offene Frage an den Owner

Werkzeug: `datenschutz.html`, `index.html` und `ci-check.ps1` nennen
**Google NotebookLM** (so auch live). `docs/NEUE-GESCHICHTE.md` §6 und
`docs/vorlagen/EINBAU-CHECKLISTE.md` nennen **Google Gemini**. Bis zur Klärung bleibt der
Live-Text (NotebookLM) unverändert. Bei einem Wechsel müssen Datenschutz,
Quellenangabe, FAQ und die Prüfung in `ci-check.ps1` gemeinsam angepasst werden.

## Sicherung (Vorschlag, nicht umgesetzt)

Zusätzlich zu OneDrive die fünf Dateien als Assets eines GitHub-Release
(z. B. `podcast-2026-10`) ablegen und die Prüfsummen oben dagegen vergleichen.
Die Entscheidung liegt beim Owner (siehe Bericht R23, Option A + C).
