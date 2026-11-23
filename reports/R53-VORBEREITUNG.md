---
titel: 'R53 Vorbereitung: Liste zum Aufräumen nach v1.40 (nur lesend)'
datum: 2026-11-23
auftrag: R53
ergebnis: vorgelegt, nichts gelöscht
---

# R53 Vorbereitung

Nur gelesen. Gelöscht, verschoben oder geändert wurde nichts. Jede Löschung braucht eine Einzelfreigabe des Product Owners. Einzige freigegebene Löschung war der Remote-Branch `auftrag-R87-supabase-betrieb`. Er war schon beim Merge von #42 automatisch entfernt (`delete_branch_on_merge: true`); sein Head 53e0a48 ist in `main` f48da7b enthalten. Es blieb nichts zu tun.

| Nr. | Objekt | Befund (Befehl) | Vorschlag (Claude) |
|---|---|---|---|
| 1 | Worktree `C:\dev\wt\relingit\r60`, Branch `auftrag-R60-v139` | sauber, 0 Commits außerhalb `origin/main`, Remote-Branch weg; ignoriert: `archive/ftp-packages/`, `output/`, `reports/` (`git status --porcelain --ignored`, `git rev-list --count HEAD --not origin/main`) | Entfernen, wenn die ignorierten Ordner nicht mehr gebraucht werden (vorher Inhalt zeigen). |
| 2 | Worktree `r86` | existiert nicht (`git worktree list`) | Aus R53 streichen. |
| 3 | Worktree `C:\dev\wt\relingit\trailer`, Branch `trailer-hero` | sauber, 0 eigene Commits, PR #38 gemergt; ignoriert: `archive/ftp-packages/`, `output/` | Entfernen wie Nr. 1. In R53 bisher nicht genannt. |
| 4 | Worktree `C:\dev\wt\relingit\paket-v139`, Branch `paket-v139` (nur lokal) | sauber; 2 Merge-Commits (d9a3434, a39d2a1) außerhalb `main`, Code gleich 907ca58, Unterschied nur in `docs/PDF-ERZEUGEN.md`, `docs/PILOT.md`, `docs/TAGESSTART.md` (auf `main` neuer); ignoriert: `output/` mit Paket v1.39 | Paket v1.39 ist Grundlage einer offenen Entscheidung zu R52. Erst danach entfernen. In R53 bisher nicht genannt. |
| 5 | Zweiter Klon `C:\dev\reling-it\relingit` | Remote Reling-IT/relingit, letzter Commit 6ea5f6d (27.10.2026), keine Änderungen, kein Stash, 0 eigene Commits | Entfernen (Regel: ein Arbeitsklon je Repo). |
| 6 | OneDrive-Klon `C:\Users\bmarn\OneDrive\HTML\reling it` | Remote ist die alte Adresse `bmarnau/relingit`; Branch `codex/fix-admin-password-recovery` (b671d7c, Remote weg), kein Stash; geändert: README.md, styles.css, datenschutz.html, index.html, build-upload.ps1, ci-check.ps1; nicht versioniert: `assets/audio/`, Podcast-Cover | Laut STATUS.yaml sind Bundle und zwei Patches gesichert (README.md, styles.css, index.html, build-upload.ps1, ci-check.ps1). `datenschutz.html` steht dort nicht, ist aber inhaltlich gleich `main` (Nachtrag unten). Nichts Ungesichertes bekannt; Wegfall möglich nach Freigabe. |
| 7 | Papierkorb | 28 Einträge. Fast alle stammen aus dem OneDrive-Klon (`archive/ftp-packages/2026090*`, `archive/_aufgeraeumt-2026-11-06/...`, `output/image/flyer-*`). Dazu `C:\dev\referenz` und eine Word-AutoWiederherstellen-Datei. Die Größe der Ordnerinhalte wurde nicht ermittelt; Dateien zusammen 1,3 MB. (`Shell.Application`, Namespace 10) | Leeren entscheidet der Product Owner. Die Word-Datei gehört nicht zum Projekt und sollte vorher angesehen werden. |

Befehle: `git worktree list`, `git -C <pfad> status --porcelain [--ignored]`, `git -C <pfad> rev-list --count HEAD --not origin/main`, `git diff --stat a39d2a1 907ca58`, `git -C <klon> --no-optional-locks status --porcelain`, Papierkorb über `Shell.Application`.

## Nachtrag 23.11.2026: `datenschutz.html` im OneDrive-Klon

Auf Wunsch des Product Owners nur lesend verglichen. Die Datei im Klon (geändert am 20.10.2026) ist ohne Zeilenenden-Unterschied gleich `origin/main` f7c59da: `git diff --no-index --quiet --ignore-cr-at-eol` ohne Unterschied, SHA-256 nach CRLF zu LF bei beiden `a451aac17faf35a3…`. Gegenüber dem Klon-Stand b671d7c enthält sie den Abschnitt „4. Lokal bereitgestellter Podcast“, die Ergänzung zur KI-Transparenz und den Stand 20. Oktober 2026. Das kam mit R28 (4df31e8, 07.11.2026) nach `main`. Damit ist im OneDrive-Klon nichts Ungesichertes mehr bekannt. Nicht versioniert sind dort noch `assets/audio/` und das Podcast-Cover; das Cover liegt auf `main` (`assets/img/reling-it-podcast-cover.png`), die MP3 liegen im Arbeitsklon unter `C:\dev\relingit\assets\audio` (laut R29, ci-check „4 Podcast-MP3 lokal vorhanden“).

## Ausführung 23.11.2026 (Freigabe Product Owner im Chat: r60, trailer, zweiter Klon, OneDrive-Klon)

Unmittelbar vor dem Löschen erneut geprüft, diesmal auch die von Git ignorierten Dateien (`git status --porcelain --ignored`, ZIP-Hashes gegen `C:\dev\relingit\archive`, `C:\dev\relingit\output` und `paket-v139/output`).

| Objekt | Ergebnis der Prüfung | Ausgeführt |
|---|---|---|
| Zweiter Klon `C:\dev\reling-it\relingit` | wie vorgelegt: keine Änderungen, kein Stash, keine eigenen Commits, keine ignorierten Dateien | **entfernt**. Der Ordner `C:\dev\reling-it` ist jetzt leer und steht noch. |
| Worktree `r60` | **Abweichung:** ignoriert liegen 5 ZIP-Pakete v1.39 (u. a. Sichtung 1), die es nur hier gibt, dazu `output/Die-Fahrt-zum-Kunden.pdf` und `reports/FREIGABE-v1.39.md`, `reports/SICHTUNG-v1.39.md` (lokale Fassungen) | nicht entfernt |
| Worktree `trailer` | **Abweichung:** ignoriert liegen ein ZIP-Paket v1.39 mit Trailer (nur hier) und die Render-Ausgaben `output/trailer/` (MP4, Kontrollbilder, render.log) | nicht entfernt |
| OneDrive-Klon | **Abweichung:** 7 Commits auf keinem Remote; die Sicherungen (Bundle, zwei Patches) liegen selbst im ignorierten `archive/` des Klons; dazu `ideen/`, `output/`, `archive/ftp-packages/`, `archive/_aufgeraeumt-2026-11-06/` | nicht entfernt |

Die erste Fassung dieser Liste hatte die ignorierten Dateien nur aufgezählt, nicht bewertet. Vorschlag: vor dem Entfernen festlegen, welche dieser Dateien außerhalb gesichert werden (z. B. Bundle und Patches, Pakete v1.39), dann erneut vorlegen.

## Sicherung 23.11.2026 (Freigabe Product Owner im Chat)

Nur kopiert, nichts gelöscht. Ziel: `C:\dev\relingit\archive\_gesichert-2026-11-23\` (von Git ignoriert, nicht im Repository), mit `SHA256SUMS.txt`. 78 Dateien, 61,9 MB; jede Kopie per SHA-256 gegen die Quelle geprüft, alle gleich.

| Herkunft | Gesichert | Beleg |
|---|---|---|
| OneDrive-Klon `archive/` | Bundle `codex-fix-admin-password-recovery-b671d7c-2026-11-09.bundle` und zwei Patches | `git bundle verify`: okay; Bundle-Head b671d7c enthält alle 7 Commits, die auf keinem Remote liegen (a900924 bis b671d7c); Hashes `39340105…9b64`, `07a7786b…f0ce`, `4749dd34…fd7b` wie in STATUS.yaml |
| Worktree r60 | 5 ZIP-Pakete v1.39, `reports/FREIGABE-v1.39.md`, `reports/SICHTUNG-v1.39.md` | SHA-256 je Datei |
| Worktree trailer | ZIP-Paket v1.39 mit Trailer, `output/trailer/` (MP4, render.log, 62 Diagnosebilder) | SHA-256 je Datei |

Danach sind r60 und trailer ohne Verlust entfernbar (nur die gesicherten Dateien und reproduzierbare Paketentpackungen lagen dort).

**Noch nicht gesichert und im OneDrive-Klon nur dort:** `ideen/` (21 Dateien, 7,4 MB), `output/` (56 Dateien, 151,1 MB), `archive/ftp-packages/` und `archive/_aufgeraeumt-2026-11-06/`. Diese waren nicht Teil der Freigabe. Der OneDrive-Klon bleibt bis zur Entscheidung stehen.

## Nachtrag: `ideen/` gesichert, `output/` aufgelistet (23.11.2026)

- `ideen/` aus dem OneDrive-Klon: 21 Dateien (Bilder, Prompt- und Ideentexte, Logo-Varianten) nach `C:\dev\relingit\archive\_gesichert-2026-11-23\onedrive-klon\ideen\` kopiert, SHA-256 je Datei gleich, Einträge in `SHA256SUMS.txt` ergänzt.
- `output/` im OneDrive-Klon (nur gelesen, nicht kopiert), 151,1 MB:
  - `ftp/relingit-upload-v1.37-2026-09-05-podcast.zip` (69,5 MB) mit entpacktem Ordner (vier MP3, Cover, Seiten);
  - `ftp/relingit-upload-v1.37-2026-09-05-viewer-upload-schutz.zip` (2,8 MB) mit entpacktem Ordner;
  - `pdf/flyer-die-fahrt-zum-kunden.pdf` (0,1 MB);
  - `image/` leer.
  Die MP3, das Cover und mehrere statische Dateien gibt es mit gleichem Namen und gleicher Größe im Arbeitsklon. HTML, JS und CSS der v1.37-Pakete stimmen nicht mit dem heutigen Stand überein (ältere Fassung). Die beiden ZIP und der Flyer liegen sonst nirgends.

## Nachtrag: `output/` gesichert, Rest im OneDrive-Klon (23.11.2026)

- Gesichert (Freigabe im Chat): `output/ftp/relingit-upload-v1.37-2026-09-05-podcast.zip` (`07ef3f8d…`), `output/ftp/relingit-upload-v1.37-2026-09-05-viewer-upload-schutz.zip` (`e183cfb0…`), `output/pdf/flyer-die-fahrt-zum-kunden.pdf` (`43c9589d…`), SHA-256 je Kopie gleich, in `SHA256SUMS.txt`.
- Die entpackten Ordner entsprechen den ZIP genau (29 bzw. 24 Einträge, 0 Abweichungen, keine zusätzlichen Dateien); sie wurden deshalb nicht kopiert.
- Noch nicht gesichert und nur im OneDrive-Klon: `archive/ftp-packages/` (zwei Pakete vom 05.09.2026, 50 Dateien, 12,5 MB) und `archive/_aufgeraeumt-2026-11-06/tmp/` (10 Dateien, 1,2 MB). Die Aussage „danach ohne Verlust entfernbar“ gilt erst, wenn auch diese gesichert oder als entbehrlich entschieden sind.

## Nachtrag: Archivordner gesichert, Gegenprobe (23.11.2026)

- Gesichert (Freigabe im Chat): `archive/ftp-packages/` und `archive/_aufgeraeumt-2026-11-06/` aus dem OneDrive-Klon, 61 Dateien, SHA-256 je Kopie gleich.
- Gesamtsicherung `C:\dev\relingit\archive\_gesichert-2026-11-23\`: 163 Dateien, 155,5 MB, 163 Zeilen in `SHA256SUMS.txt`.
- Gegenprobe `git status --porcelain --ignored` im OneDrive-Klon: alle ignorierten Einträge sind gesichert oder entbehrlich. `supabase/.temp/` enthält nur `cli-latest` (8 Byte, Versionsmerker der Supabase-CLI), nicht gesichert.
- Damit ist im OneDrive-Klon, in `r60` und in `trailer` nichts Ungesichertes mehr bekannt. Entfernen erst nach erneuter Freigabe.
