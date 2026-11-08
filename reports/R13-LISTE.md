# R13 Phase 1 – Inventar und Kandidatenliste (nur lesen)

- Ordner: `C:\Users\bmarn\OneDrive\HTML\reling it`
- Branch: `codex/fix-admin-password-recovery` (`git branch --show-current`)
- Stand: 2026-11-08, erstellt durch Claude (Agent), Auftrag `queue/R13.yaml` auf `origin/ops/queue`
- In Phase 1 wurde **nichts gelöscht, verschoben oder geändert**. Es lief kein Git-Schreibbefehl.
- **Phase 2 erst, wenn Bernd die einzelnen L-Nummern im Chat schriftlich freigibt.**

## 0. Methode und Belege

Befehle (alle lesend):

```powershell
git -C "C:\Users\bmarn\OneDrive\HTML\reling it" branch --show-current
git -C "C:\Users\bmarn\OneDrive\HTML\reling it" status --porcelain
git -C "C:\Users\bmarn\OneDrive\HTML\reling it" status --porcelain --ignored
git -C "C:\Users\bmarn\OneDrive\HTML\reling it" -c core.quotepath=off ls-files      # 45 Dateien
# rekursive Aufzählung mit [IO.Directory]::EnumerateFileSystemEntries + Get-Item -Force,
# Einträge mit LinkType (Junction/SymbolicLink) werden NICHT betreten -> Ergebnis: 0 Links gefunden
# Get-FileHash -Algorithm SHA256 nur für lokal vorhandene Dateien (kein Offline/RecallOnDataAccess/RecallOnOpen)
```

Hinweis zum Attribut ReparsePoint: Im OneDrive-Ordner tragen praktisch alle Einträge das Attribut ReparsePoint (OneDrive-Cloud-Tag). Das sind **keine** Junctions/Symlinks. Maßgeblich ist `LinkType`; er war bei keinem Eintrag gesetzt. Platzhalter (nur in der Cloud) wurden am Attribut erkannt (z. B. Wert 5248544 = Offline + RecallOnDataAccess + Unpinned + Sparse) und **nicht gehasht**, damit kein Download ausgelöst wird.

## 1. Referenz: git status vorher

```
$ git status --porcelain
 M README.md
 M assets/css/styles.css
 M datenschutz.html
 M index.html
 M scripts/build-upload.ps1
 M scripts/ci-check.ps1
?? assets/audio/
?? assets/img/reling-it-podcast-cover.png

$ git status --porcelain --ignored   (zusätzliche Zeilen)
!! archive/_aufgeraeumt-2026-11-06/
!! archive/ftp-packages/
!! ideen/
!! output/
!! supabase/.temp/
```

Phase 2 muss nach dem Löschen exakt die ersten acht Zeilen wieder ergeben (Auftrag: `git status` vorher = nachher).

## 2. Inventar

### 2.1 Summen nach Git-Status

| Status | Dateien | Größe | davon Platzhalter |
|---|---:|---:|---:|
| Von Git verfolgt, unverändert | 39 | 7,10 MB (7 104 839 B) | 13 |
| Von Git verfolgt, lokal geändert | 6 | 0,06 MB (59 006 B) | 0 |
| Nicht verfolgt (`??`) | 5 | 75,23 MB (75 228 939 B) | 0 |
| Nicht verfolgt, ignoriert (`!!`) | 439 | 273,43 MB (273 434 738 B) | 10 |
| `.git` intern | 156 | 101,37 MB (101 371 916 B) | 63 |
| **Gesamt** | **645** | **457,20 MB** (457 199 438 B) | 86 |

(MB = 10^6 Byte nur zur Übersicht; maßgeblich sind die Byte-Werte.)

### 2.2 Nach Verzeichnis

| Verzeichnis | Status | Dateien | Größe | neueste Datei |
|---|---|---:|---:|---|
| `.` (Wurzel) | verfolgt (8) + geändert (3) + 3 weitere verfolgt | 14 | 0,05 MB | 2026-10-20 16:24 |
| `.git` | intern | 156 | 101,37 MB | 2026-11-01 06:44 |
| `.github/workflows` | verfolgt | 1 | <0,01 MB | 2026-09-04 18:49 |
| `archive` (README.md, .gitignore) | verfolgt | 2 | <0,01 MB | 2026-08-30 20:23 |
| `archive/_aufgeraeumt-2026-11-06` | ignoriert | 59 | 28,83 MB | 2026-11-06 11:53 |
| `archive/ftp-packages` (11 Pakete) | ignoriert | 300 | 78,12 MB | 2026-09-05 19:39 |
| `assets/audio` | nicht verfolgt | 4 | 74,22 MB | 2026-10-20 16:23 |
| `assets/img` | 2 verfolgt + 1 nicht verfolgt (Cover) | 3 | 1,02 MB | 2026-10-20 16:21 |
| `assets/css` | 1 verfolgt + 1 geändert | 2 | 0,01 MB | 2026-10-20 16:25 |
| `assets/js` | verfolgt | 6 | 0,03 MB | 2026-09-05 19:53 |
| `docs` | verfolgt | 5 | 0,02 MB | 2026-09-05 11:52 |
| `ideen` (inkl. `ideen/logo`) | ignoriert | 21 | 7,78 MB | 2026-09-04 10:55 |
| `output/ftp` (2 Ordner + 2 ZIP) | ignoriert | 55 | 158,37 MB | 2026-10-20 16:26 |
| `output/image` | ignoriert | 2 | 0,22 MB | 2026-09-04 02:16 |
| `output/pdf` | ignoriert | 1 | 0,12 MB | 2026-09-04 02:12 |
| `scripts` | 1 verfolgt + 2 geändert | 3 | 0,03 MB | 2026-10-20 16:25 |
| `source` | verfolgt | 2 | 3,44 MB | 2026-09-05 19:21 |
| `story/current` | verfolgt | 4 | 3,55 MB | 2026-09-05 19:21 |
| `supabase` | verfolgt | 5 | 0,01 MB | 2026-09-04 18:49 |
| `supabase/.temp` | ignoriert | 1 | <0,01 MB | 2026-09-04 13:23 |
| `tmp` | leerer Ordner | 0 | 0 | 2026-11-06 11:53 |

Lokal geänderte Dateien (alle 2026-10-20): `README.md`, `assets/css/styles.css`, `datenschutz.html`, `index.html`, `scripts/build-upload.ps1`, `scripts/ci-check.ps1`.

## 3. Klassifizierung aller nicht verfolgten Dateien

| Bereich | Klasse | Bewertung |
|---|---|---|
| `assets/audio/*.mp3` (4 Dateien, 74,2 MB) | Podcast-Audio, nicht im Repo | **geschützt** |
| `assets/img/reling-it-podcast-cover.png` | Podcast-Cover, nicht im Repo | **geschützt** |
| `archive/_aufgeraeumt-2026-11-06/alte-buchstaende/*` (7 Ordner, 16 Dateien) | alte Romanstände (HTML/PDF v1.10–v1.25) | Kandidat (Block A) |
| `archive/_aufgeraeumt-2026-11-06/flyer/*` (2 PDF) | alte Flyer-Stände | Kandidat (Block A) |
| `archive/_aufgeraeumt-2026-11-06/ftp-pakete-alt/*` (v1.25-Paket + ZIP) | altes FTP-Paket | Kandidat (Block A) |
| `archive/_aufgeraeumt-2026-11-06/tmp/*` (5 JPEG lokal, 10 PNG Platzhalter) | Zwischenausgaben PDF-Review | Kandidat (Block A) |
| `archive/_aufgeraeumt-2026-11-06/WAS-WURDE-VERSCHOBEN.txt` | Protokoll der Umräumaktion 06.11. | Kandidat nur zusammen mit dem Rest (L15) |
| `archive/ftp-packages/<11 Zeitstempel>/` | Upload-Pakete v1.29–v1.37 (Ordner + ZIP) | 9 ältere = Kandidat (Block D), 2 neueste geschützt |
| `output/ftp/relingit-upload-v1.37-2026-09-05-podcast(.zip)` | Podcast-Upload-Paket, einzige Zweitkopie der MP3 | **geschützt** |
| `output/ftp/relingit-upload-v1.37-2026-09-05-viewer-upload-schutz(.zip)` | zweitneuestes Upload-Paket | **geschützt** (neueste zwei) |
| `output/image/*.png` (2) | Flyer-Bildausgaben | Kandidat (Block B) |
| `output/pdf/flyer-die-fahrt-zum-kunden.pdf` | einziges und damit neuestes PDF | **geschützt** |
| `ideen/*`, `ideen/logo/*` (21 Dateien) | Bernds Ideen, Bilder, Prompts, Logo-Varianten | **geschützt** |
| `supabase/.temp/cli-latest` (8 B) | Supabase-CLI-Cache | nicht im Auftrag, nur gemeldet |
| `tmp/` (leer) | leerer Ordner | nicht im Auftrag, nur gemeldet |

## 4. Kandidatenliste zum Löschen (in den Papierkorb)

Reihenfolge laut Auftrag. Jede Zeile einzeln freigebbar. Pfade relativ zu `C:\Users\bmarn\OneDrive\HTML\reling it`. Datum = Spanne der Änderungsdaten der enthaltenen Dateien. „PH“ = enthält OneDrive-Platzhalter (nur in der Cloud).

### Block A – `archive\_aufgeraeumt-2026-11-06`

| Nr. | Pfad | Dateien | Größe (Byte) | Datum | Grund |
|---|---|---:|---:|---|---|
| L01 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-08-30-version-1-10\` | 2 | 1 644 662 | 2026-08-30 | alter Romanstand v1.10, aktueller Stand in `story/current` (Git) |
| L02 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-v1.11\` | 2 | 1 645 986 | 2026-08-30 – 08-31 | alter Romanstand v1.11 |
| L03 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-input-v1.18\` | 4 | 3 424 697 | 2026-09-03 | alter Eingangsstand v1.18 inkl. Handout (Handout-PDF identisch mit `story/current/workshop-handout.pdf` in allen Paketen) |
| L04 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-v1.18\` | 2 | 3 311 828 | 2026-09-03 | alter Romanstand v1.18; PDF identisch mit L03 |
| L05 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-input-v1.24\` | 2 | 3 351 862 | 2026-09-03 | alter Eingangsstand v1.24; identisch mit L06 und L07 |
| L06 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-version-1-25-input\` | 2 | 3 351 862 | 2026-09-03 | Dublette von L05 (gleicher SHA-256 beider Dateien) |
| L07 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\import-v1.24-2026-09-03\` | 2 | 3 351 862 | 2026-09-03 | Dublette von L05 (gleicher SHA-256 beider Dateien) |
| L08 | `archive\_aufgeraeumt-2026-11-06\flyer\flyer-before-links-2026-09-04\` | 1 | 20 786 | 2026-09-03 | alter Flyer-Stand, ersetzt durch `output/pdf` |
| L09 | `archive\_aufgeraeumt-2026-11-06\flyer\flyer-portrait-linked-2026-09-04\` | 1 | 21 169 | 2026-09-04 | alter Flyer-Stand, ersetzt durch `output/pdf` |
| L10 | `archive\_aufgeraeumt-2026-11-06\ftp-pakete-alt\ftp-packages-before-v1.29\` | 25 | 6 393 778 | 2026-08-30 – 09-04 | altes FTP-Paket v1.25 (Ordner + ZIP), mehrfach überholt |
| L11 | `archive\_aufgeraeumt-2026-11-06\tmp\embedded-0.jpeg` … `embedded-4.jpeg` (5 Dateien) | 5 | 1 024 319 | 2026-09-03 | aus PDF extrahierte Zwischenbilder |
| L12 | `archive\_aufgeraeumt-2026-11-06\tmp\pdf-review\` | 4 | 585 712 | 2026-09-03 | PDF-Review-Screenshots; **PH (4 Platzhalter)** |
| L13 | `archive\_aufgeraeumt-2026-11-06\tmp\pdf-review-v124\` | 3 | 395 769 | 2026-09-03 | PDF-Review-Screenshots v1.24; **PH (3 Platzhalter)** |
| L14 | `archive\_aufgeraeumt-2026-11-06\tmp\pdfs\` | 3 | 300 576 | 2026-08-30 | Seitenrenderings v1.11; **PH (3 Platzhalter)** |
| L15 | `archive\_aufgeraeumt-2026-11-06\WAS-WURDE-VERSCHOBEN.txt` und danach der dann leere Ordner `archive\_aufgeraeumt-2026-11-06\` | 1 | 711 | 2026-11-06 | Protokoll der Umräumaktion; nur sinnvoll, wenn L01–L14 alle freigegeben sind |

Summe Block A: **28 825 579 Byte (27,49 MiB)**, 59 Dateien.

### Block B – `output\image` und `output\pdf`

| Nr. | Pfad | Dateien | Größe (Byte) | Datum | Grund |
|---|---|---:|---:|---|---|
| L16 | `output\image\flyer-die-fahrt-zum-kunden.png` | 1 | 106 822 | 2026-09-03 15:57 | Zwischenausgabe Flyer-Bild (älterer Stand) |
| L17 | `output\image\flyer-die-fahrt-zum-kunden-700x700.png` | 1 | 117 804 | 2026-09-04 02:16 | Zwischenausgabe Flyer-Bild 700×700 |
| – | `output\pdf\` | – | – | – | **kein Kandidat**: enthält nur ein PDF, das als neuestes geschützt ist |

Summe Block B: **224 626 Byte (0,21 MiB)**, 2 Dateien.

### Block C – ältere `output\ftp`-Pakete

Kein Kandidat. `output\ftp` enthält genau zwei Pakete (podcast vom 2026-10-20 und viewer-upload-schutz vom 2026-09-05), jeweils Ordner + ZIP. Das sind die neuesten zwei; das Podcast-Paket ist zusätzlich durch die Schutzliste geschützt.

### Block D – ältere `archive\ftp-packages` (über die Auftragsreihenfolge hinaus)

Der Auftrag nennt in Phase 1 diese Pakete nicht ausdrücklich als Kandidaten, schützt aber nur die neuesten zwei (`20260905-193924-327` korrekturen und `20260905-195306-580` viewer-fix). Die neun älteren werden deshalb **getrennt** zur Entscheidung vorgelegt. Bitte nur bei ausdrücklichem Wunsch freigeben.

| Nr. | Pfad | Inhalt | Dateien | Größe (Byte) | neueste Datei | Grund |
|---|---|---|---:|---:|---|---|
| L18 | `archive\ftp-packages\20260904-070529-752\` | v1.29 | 25 | 6 408 859 | 2026-09-04 07:02 | altes Upload-Paket |
| L19 | `archive\ftp-packages\20260904-184557-555\` | v1.29 (erneut) + v1.29 security-pending-supabase | 50 | 12 826 353 | 2026-09-04 13:28 | altes Paket; v1.29-Ordner inhaltlich identisch mit L18 |
| L20 | `archive\ftp-packages\20260904-185157-249\` | v1.32 security-final | 25 | 6 525 556 | 2026-09-04 18:45 | altes Upload-Paket |
| L21 | `archive\ftp-packages\20260905-115310-734\` | v1.32 final-main | 25 | 6 528 710 | 2026-09-04 18:51 | altes Upload-Paket |
| L22 | `archive\ftp-packages\20260905-115912-216\` | v1.32 admin-recovery | 25 | 6 536 015 | 2026-09-05 11:53 | altes Upload-Paket |
| L23 | `archive\ftp-packages\20260905-121137-035\` | v1.32 admin-mfa | 25 | 6 536 184 | 2026-09-05 11:59 | altes Upload-Paket |
| L24 | `archive\ftp-packages\20260905-123424-410\` | v1.32 admin-mfa-qr-fix | 25 | 6 537 277 | 2026-09-05 12:11 | altes Upload-Paket |
| L25 | `archive\ftp-packages\20260905-192045-642\` | v1.32 admin-mfa-final | 25 | 6 538 559 | 2026-09-05 12:34 | altes Upload-Paket |
| L26 | `archive\ftp-packages\20260905-192135-924\` | v1.37 korrekturen (erster Lauf) | 25 | 6 560 679 | 2026-09-05 19:20 | fast gleich mit geschütztem `20260905-193924-327` |

Summe Block D: **64 998 192 Byte (61,99 MiB)**, 250 Dateien.

### Gesamtsummen

| Umfang | Einträge | Dateien | Größe |
|---|---|---:|---:|
| Auftragsreihenfolge (Block A + B) | L01–L17 | 61 | **29 050 205 Byte (27,70 MiB)** |
| zusätzlich Block D | L18–L26 | 250 | 64 998 192 Byte (61,99 MiB) |
| **alle Kandidaten** | **L01–L26** | **311** | **94 048 397 Byte (89,69 MiB)** |

Hinweis: Weil OneDrive die Dateien synchronisiert, wird der Platz in der Cloud erst frei, wenn auch der OneDrive-Online-Papierkorb geleert ist. Lokal belegen die Platzhalter aus L12–L14 (1,28 MB) ohnehin keinen Platz.

## 5. Geschützt, nur gemeldet

Diese Einträge stehen **nicht** auf der Löschliste (schutzregeln und schutzliste aus R13):

| Pfad | Größe (Byte) | Datum | Schutzgrund |
|---|---:|---|---|
| `.git\` (156 Dateien) | 101 371 916 | bis 2026-11-01 | Schutzregel: .git |
| `.github\` | 1 811 | 2026-09-04 | Schutzregel: .github |
| alle 45 Dateien aus `git ls-files` | 7 163 845 | – | Schutzregel: von Git verfolgt |
| `README.md`, `assets\css\styles.css`, `datenschutz.html`, `index.html`, `scripts\build-upload.ps1`, `scripts\ci-check.ps1` | 59 006 | 2026-10-20 | uncommittete Änderungen; Schutzliste bis R34 gemergt und R35 entschieden |
| `assets\audio\ki-als-beifahrer-im-it-systemhaus.mp3` | 11 262 465 | 2026-10-20 16:17 | Podcast, nicht im Repo |
| `assets\audio\roman-als-ki-blaupause.mp3` | 22 118 537 | 2026-10-20 16:23 | Podcast, nicht im Repo |
| `assets\audio\vom-logbuch-zum-ki-ticketsystem.mp3` | 18 608 515 | 2026-10-20 16:23 | Podcast, nicht im Repo |
| `assets\audio\warum-ki-nicht-lenken-darf.mp3` | 22 233 475 | 2026-10-20 16:23 | Podcast, nicht im Repo |
| `assets\img\reling-it-podcast-cover.png` | 1 005 947 | 2026-10-20 16:21 | Podcast-Cover, nicht im Repo |
| `output\ftp\relingit-upload-v1.37-2026-09-05-podcast\` (29 Dateien) | 78 882 860 | 2026-10-20 | Schutzliste `output/ftp/*podcast*`, einzige Zweitkopie |
| `output\ftp\relingit-upload-v1.37-2026-09-05-podcast.zip` | 72 922 306 | 2026-10-20 16:26 | Schutzliste `output/ftp/*podcast*` |
| `output\ftp\relingit-upload-v1.37-2026-09-05-viewer-upload-schutz\` + `.zip` | 3 643 953 + 2 920 844 | 2026-09-05 | neueste zwei in `output\ftp` |
| `output\pdf\flyer-die-fahrt-zum-kunden.pdf` | 117 641 | 2026-09-04 02:12 | neuestes PDF in `output\pdf` |
| `archive\ftp-packages\20260905-193924-327\` | 6 560 675 | 2026-09-05 19:21 | neueste zwei in `archive\ftp-packages` |
| `archive\ftp-packages\20260905-195306-580\` | 6 561 975 | 2026-09-05 19:39 | neueste zwei in `archive\ftp-packages` |
| `archive\README.md` | 1 131 | 2026-08-30 | Schutzregel |
| `ideen\` (21 Dateien) | 7 776 079 | bis 2026-09-04 | Schutzregel: Bernds Ideen und Bilder |
| `supabase\.temp\cli-latest` | 8 | 2026-09-04 | nicht im Auftrag genannt |
| `tmp\` (leer) | 0 | 2026-11-06 | nicht im Auftrag genannt |

Wichtige Beobachtung zum Podcast-Paket: `index.html`, `datenschutz.html` und `assets/css/styles.css` im Podcast-Paket haben **denselben SHA-256** wie die lokal geänderten Dateien im Arbeitsbaum. Das Paket ist also auch eine Sicherung der uncommitteten Änderungen (nicht nur der MP3).

## 6. Duplikate (gleicher SHA-256, nur gemeldet)

56 Hash-Gruppen mit mehr als einer Datei (nur lokal vorhandene Dateien, ohne `.git`). Die wichtigsten:

| SHA-256 (Anfang) | Anzahl | Größe je Datei | Fundorte |
|---|---:|---:|---|
| 63091782BF2D | 2 | 22 233 475 | `assets/audio/warum-ki-nicht-lenken-darf.mp3` = Podcast-Paket (geschützt, gewollte Zweitkopie) |
| 816100FF810B | 2 | 22 118 537 | `assets/audio/roman-als-ki-blaupause.mp3` = Podcast-Paket |
| 9E4E409963D9 | 2 | 18 608 515 | `assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3` = Podcast-Paket |
| 4098A1416CA2 | 2 | 11 262 465 | `assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3` = Podcast-Paket |
| 6068294EA84E | 2 | 1 005 947 | Podcast-Cover in `assets/img` = Podcast-Paket |
| 1423C9647021 | 4 | 1 795 875 | Roman-PDF v1.24 in L05, L06, L07 und L10 |
| EAF8BFFB7D0F | 3 | 1 555 987 | Roman-HTML v1.24 in L05, L06, L07 |
| 9C5713B13F71 | 2 | 1 774 704 | Roman-PDF v1.18 in L03 und L04 |
| 0B38A8680EAD | 6 | 1 846 385 | `geschichte.pdf` in L20–L25 |
| 9DA0370F4307 | 5 | 1 580 030 | `fahrt-zum-kunden.html` in L21–L25 |
| BBFD1991FCDE | 5 | 1 855 398 | `geschichte.pdf` in L26, beiden geschützten archive-Paketen und beiden `output/ftp`-Paketen |
| 7F38CB1231A4 | 6 | 1 584 463 | `fahrt-zum-kunden.html` in den geschützten Paketen = `story/current` und `source` (Git) |
| EF80D31D6AE4 / D22FE13C52A8 | je 3 | 1,80 / 1,56 MB | Roman v1.29 in L18 und zweimal in L19 |
| 2D8E6F3C44C3 | 2 | 1 711 447 | zwei gleiche ChatGPT-Bilder in `ideen/` (14_45_28 und 14_46_40) – geschützt |
| 8EB1B9037263 | 16 | 105 494 | Workshop-Handout-PDF in allen Paketen und L03 |

Die übrigen Gruppen sind kleine Web-Dateien (HTML, CSS, JS, Favicon, Logo), die in jedem Upload-Paket erneut liegen. Die Platzhalter (10 PNG in L12–L14 sowie 13 verfolgte Dateien) wurden bewusst nicht gehasht.

## 7. Papierkorb für den OneDrive-Pfad (Hinweis für Phase 2)

Festgestellt, **nicht** durch Löschen getestet:

```powershell
Get-Volume -DriveLetter C            # DriveType Fixed, NTFS, frei 17 053 343 744 Byte
Test-Path -LiteralPath 'C:\$Recycle.Bin'   # True
(Get-CimInstance Win32_Volume -Filter "DriveLetter='C:'").DeviceID   # Volume{804b5ffc-…}
Get-ItemProperty 'HKCU:\…\Explorer\BitBucket\Volume\{804b5ffc-07c6-47e5-aadc-9a31b4bb558d}'
#   NukeOnDelete = 0, MaxCapacity = 14186 (MB)
Get-ItemProperty 'HKCU:\…\Policies\Explorer'   # keine NoRecycleFiles-Richtlinie gesetzt
Get-Process OneDrive                 # läuft (2 Prozesse)
```

Bewertung: Der Ordner liegt auf dem lokalen NTFS-Laufwerk C:. Für dieses Volume ist der Windows-Papierkorb aktiv (NukeOnDelete = 0), Kapazität rund 13,9 GB, damit reicht er für die 94 MB deutlich. **Der Papierkorb ist voraussichtlich verfügbar.** Zusätzlich legt OneDrive gelöschte Dateien im Online-Papierkorb ab (nicht geprüft). Offener Punkt: Für die 10 Platzhalter in L12–L14 ist nicht belegt, ob Windows sie in den lokalen Papierkorb legt oder nur im OneDrive-Online-Papierkorb. Empfehlung: Wenn der Trockenlauf bzw. der Löschaufruf für L12–L14 einen Fehler oder einen Download-Dialog meldet, diese Einträge nicht erzwingen, sondern melden.

## 8. Befehlsentwurf für Phase 2 (NICHT ausgeführt)

Nur nach schriftlicher Freigabe durch Bernd. In `$freigabe` nur die freigegebenen L-Nummern eintragen. Erst mit `$trockenlauf = $true` laufen lassen, Ausgabe Bernd zeigen, dann erst mit `$false`.

```powershell
# R13 Phase 2 – Entwurf. Nicht ohne schriftliche Freigabe ausführen.
$ErrorActionPreference = 'Stop'
$root        = 'C:\Users\bmarn\OneDrive\HTML\reling it'
$trockenlauf = $true                      # erst Trockenlauf, danach bewusst auf $false
$freigabe    = @()                        # z. B. @('L01','L02','L16')
$A = 'archive\_aufgeraeumt-2026-11-06'
$liste = [ordered]@{
  'L01' = @("$A\alte-buchstaende\2026-08-30-version-1-10")
  'L02' = @("$A\alte-buchstaende\2026-09-03-v1.11")
  'L03' = @("$A\alte-buchstaende\2026-09-03-input-v1.18")
  'L04' = @("$A\alte-buchstaende\2026-09-03-v1.18")
  'L05' = @("$A\alte-buchstaende\2026-09-03-input-v1.24")
  'L06' = @("$A\alte-buchstaende\2026-09-03-version-1-25-input")
  'L07' = @("$A\alte-buchstaende\import-v1.24-2026-09-03")
  'L08' = @("$A\flyer\flyer-before-links-2026-09-04")
  'L09' = @("$A\flyer\flyer-portrait-linked-2026-09-04")
  'L10' = @("$A\ftp-pakete-alt\ftp-packages-before-v1.29")
  'L11' = @(0..4 | ForEach-Object { "$A\tmp\embedded-$_.jpeg" })
  'L12' = @("$A\tmp\pdf-review")
  'L13' = @("$A\tmp\pdf-review-v124")
  'L14' = @("$A\tmp\pdfs")
  'L15' = @("$A\WAS-WURDE-VERSCHOBEN.txt", $A)   # nur wenn L01–L14 freigegeben; Ordner muss danach leer sein
  'L16' = @('output\image\flyer-die-fahrt-zum-kunden.png')
  'L17' = @('output\image\flyer-die-fahrt-zum-kunden-700x700.png')
  'L18' = @('archive\ftp-packages\20260904-070529-752')
  'L19' = @('archive\ftp-packages\20260904-184557-555')
  'L20' = @('archive\ftp-packages\20260904-185157-249')
  'L21' = @('archive\ftp-packages\20260905-115310-734')
  'L22' = @('archive\ftp-packages\20260905-115912-216')
  'L23' = @('archive\ftp-packages\20260905-121137-035')
  'L24' = @('archive\ftp-packages\20260905-123424-410')
  'L25' = @('archive\ftp-packages\20260905-192045-642')
  'L26' = @('archive\ftp-packages\20260905-192135-924')
}
# Harte Sperren (Schutzregeln/Schutzliste)
$gesperrt = '(^|\\)\.git(\\|$)|(^|\\)\.github(\\|$)|^assets\\|podcast|^ideen(\\|$)|^archive\\README\.md$|^output\\pdf(\\|$)|^output\\ftp(\\|$)|20260905-193924-327|20260905-195306-580'

Add-Type -AssemblyName Microsoft.VisualBasic
$statusVorher = git -C $root status --porcelain
$statusVorher | Set-Content "$env:TEMP\R13-git-status-vorher.txt" -Encoding utf8

foreach ($nr in $freigabe) {
  if (-not $liste.Contains($nr)) { throw "Unbekannte Nummer: $nr" }
  foreach ($rel in $liste[$nr]) {
    if ($rel -match $gesperrt) { throw "$nr gesperrt: $rel" }
    $voll = [IO.Path]::GetFullPath((Join-Path $root $rel))
    if (-not $voll.StartsWith("$root\", [StringComparison]::OrdinalIgnoreCase)) { throw "$nr ausserhalb des Ordners: $voll" }
    if (-not (Test-Path -LiteralPath $voll)) { Write-Warning "$nr fehlt: $voll"; continue }
    $item = Get-Item -LiteralPath $voll -Force
    if ($item.LinkType) { throw "$nr ist Link ($($item.LinkType)): $voll" }
    if ($item.PSIsContainer) {
      $links = Get-ChildItem -LiteralPath $voll -Recurse -Force | Where-Object LinkType
      if ($links) { throw "$nr enthält Links: $($links.FullName -join ', ')" }
      if ($rel -eq $A -and (Get-ChildItem -LiteralPath $voll -Force)) { Write-Warning "L15: $A nicht leer, übersprungen"; continue }
    }
    $rp = $rel -replace '\\','/'
    if (git -C $root ls-files -- $rp)            { throw "$nr enthält von Git verfolgte Dateien: $rel" }
    if (git -C $root status --porcelain -- $rp)  { throw "$nr enthält Dateien mit Git-Status (geändert/neu): $rel" }
    if ($trockenlauf) { "TROCKENLAUF $nr -> $voll"; continue }
    if ($item.PSIsContainer) {
      [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($voll,
        [Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs,
        [Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin)
    } else {
      [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($voll,
        [Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs,
        [Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin)
    }
    "PAPIERKORB $nr -> $voll"
  }
}

$statusNachher = git -C $root status --porcelain
if (Compare-Object @($statusVorher) @($statusNachher)) { Write-Warning 'git status ABWEICHEND – sofort melden' } else { 'git status vorher = nachher' }
```

Hinweise zum Entwurf: Reihenfolge der Freigaben so eintragen, dass L15 zuletzt kommt. `git status --porcelain` zeigt ignorierte Pfade nicht; die Sperre `ls-files` deckt verfolgte Dateien ab, der Regex-Filter die Schutzliste.

## Vorschläge und Ideen (Claude)

- Zuerst nur Block A + B (L01–L17, 27,7 MiB) freigeben; Block D (62 MiB) separat entscheiden, sobald klar ist, ob alte Upload-Stände für Nachweise (z. B. Sicherheitsstände v1.29/v1.32) gebraucht werden. Die Stände sind ohnehin im Git-Verlauf von Reling-IT/relingit nachvollziehbar.
- Das Podcast-Paket in `output\ftp` sichert auch die uncommitteten Änderungen (gleiche Hashes). Sobald R34/R35 entschieden sind, die MP3 und das Cover an einen dauerhaften Ort außerhalb des alten Klons legen (z. B. eigener Ordner „Podcast-Master“), dann kann der ganze OneDrive-Klon später entfallen.
- Die zwei identischen ChatGPT-Bilder in `ideen\` könnte Bernd selbst zusammenlegen (nicht Teil von R13).
- Die 101 MB in `.git` (große Pack-/Objektdateien bis 28 MB) belasten OneDrive-Synchronisation; ein Git-Klon gehört eher nicht in OneDrive. Mittelfristig den alten Klon nach Sicherung der Podcast-Dateien und der lokalen Änderungen ganz außer Betrieb nehmen.
- Für L12–L14 (Cloud-Platzhalter) vor Phase 2 klären, ob ein lokaler Papierkorb-Eintrag entsteht; sonst nur über den OneDrive-Online-Papierkorb wiederherstellbar.

Hygiene: Phase 1 rein lesend; keine Git-Schreibbefehle, keine Junction/Symlink betreten (0 gefunden), keine Platzhalter heruntergeladen; Bericht enthält keine Zugangsdaten oder Schlüsselmuster.

```yaml
Reifegrad: Phase 1 abgeschlossen (Liste liegt vor), Phase 2 wartet auf Freigabe
Projektstatus: R13 Phase 1 fertig; 26 Kandidaten (L01–L26), 94 048 397 Byte; davon Auftragsumfang L01–L17 mit 29 050 205 Byte
Offene_Fragen:
  - Welche L-Nummern gibt Bernd frei (Empfehlung zuerst L01–L17)?
  - Soll Block D (ältere archive\ftp-packages, L18–L26) überhaupt gelöscht werden?
  - Landen gelöschte OneDrive-Platzhalter (L12–L14) im lokalen Papierkorb oder nur online?
  - Wann sind R34 (Merge) und R35 (Entscheidung) erledigt, damit die uncommitteten Änderungen nicht mehr geschützt werden müssen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schätzung
```
