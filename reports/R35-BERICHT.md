---
id: R35
titel: Podcast-MP3 und Cover unabhängig sichern (GitHub-Release-Asset plus Prüfsummen)
status: erledigt (PR offen, nicht gemergt)
start: 2026-11-08T05:05+01:00
ende: 2026-11-08T05:20+01:00
branch: auftrag-R35-podcast-sicherung (Worktree C:/dev/wt-r35)
pr: https://github.com/Reling-IT/relingit/pull/18
commit: 919e2f9
ci: grün ("Website prüfen", Lauf 42446143741), Ergebnis als PR-Kommentar
release: https://github.com/Reling-IT/relingit/releases/tag/podcast-2026-10
---

## Ziel

Die vier Podcast-MP3 (74 222 992 Byte) und das Cover lagen nur in OneDrive, die Zweitkopie unter `output/ftp` liegt im selben OneDrive. R35 legt mit Freigabe des Owners (07.11.2026 07:06) eine davon unabhängige Kopie als Assets des Release `podcast-2026-10` an. Die Prüfsummen werden vor und nach dem Upload abgeglichen und der Sicherungsort in `docs/PODCAST.md` eingetragen.

## Hash-Prüfung lokal (vor dem Upload)

Quelle: `C:\Users\bmarn\OneDrive\HTML\reling it\assets\audio\*.mp3` und `...\assets\img\reling-it-podcast-cover.png`. Die Dateien wurden nur gelesen (`Get-FileHash -Algorithm SHA256`).

| Datei | Größe (B) | SHA-256 lokal | = docs/PODCAST.md |
|---|---|---|---|
| ki-als-beifahrer-im-it-systemhaus.mp3 | 11 262 465 | 4098a1416ca256dbc518c7786b0909b1bc63be9ab63ebdbfbe8150d2029accff | ja |
| vom-logbuch-zum-ki-ticketsystem.mp3 | 18 608 515 | 9e4e409963d969474096da0f236b2c6094b15284a45da43277dff62895df2bad | ja |
| warum-ki-nicht-lenken-darf.mp3 | 22 233 475 | 63091782bf2d8c62020fc69a2746887cdb7fbb136b1c4006be23f2f793ade844 | ja |
| roman-als-ki-blaupause.mp3 | 22 118 537 | 816100ff810bcbcef4dd965f0ceb1bcecd1f8de12064f7c02d25968a6b2d9f30 | ja |
| reling-it-podcast-cover.png | 1 005 947 | 6068294ea84e215e20d265d949b32d01f024cd4d9a7cbfee832b9d4be28d9edd | ja |

Die MP3 ergeben zusammen 74 222 992 B (`Measure-Object -Sum`), das entspricht dem Auftrag. Es gab keine Abweichung, deshalb wurde hochgeladen.

## Release

- Vorprüfung: `gh release view podcast-2026-10` meldete „release not found“. `git ls-remote --tags origin` zeigte nur `v0.1.0`. Es wurde also nichts überschrieben.
- Befehl: `gh release create podcast-2026-10 --repo Reling-IT/relingit --target 1281bbeb99ddd8f29b1f499208eec78d1ea83919 --latest=false --title "Podcast-Sicherung 2026-10 (vier Folgen und Cover)" --notes-file <scratchpad>/r35/release-notes.md <5 Dateien>`
- Link: https://github.com/Reling-IT/relingit/releases/tag/podcast-2026-10
- Veröffentlicht 2026-11-08T04:13:11Z. Tag `podcast-2026-10` → `1281bbe` (= origin/main zu diesem Zeitpunkt, laut `git ls-remote`). isDraft false, isPrerelease false.
- Die Beschreibung enthält eine Dateitabelle mit Pfad, Größe und SHA-256 sowie die Befehle zum Wiederherstellen.

## Asset-Liste (laut GitHub)

| Asset | size | digest (GitHub) |
|---|---|---|
| ki-als-beifahrer-im-it-systemhaus.mp3 | 11 262 465 | sha256:4098a141…accff |
| vom-logbuch-zum-ki-ticketsystem.mp3 | 18 608 515 | sha256:9e4e4099…f2bad |
| warum-ki-nicht-lenken-darf.mp3 | 22 233 475 | sha256:63091782…ade844 |
| roman-als-ki-blaupause.mp3 | 22 118 537 | sha256:816100ff…d9f30 |
| reling-it-podcast-cover.png | 1 005 947 | sha256:6068294e…49be28d9edd |

Alle fünf Werte sind vollständig identisch mit der Tabelle oben (`gh release view --json assets`). Summe aller Assets: 75 228 939 B.

## Hash-Vergleich nach Download

Die Assets wurden in den leeren Ordner `<scratchpad>\r35-download` geladen (`gh release download podcast-2026-10`) und dort mit `Get-FileHash` geprüft.

| Datei | Größe Download | SHA-256 Download | = Liste |
|---|---|---|---|
| ki-als-beifahrer-im-it-systemhaus.mp3 | 11 262 465 | 4098a1416ca256dbc518c7786b0909b1bc63be9ab63ebdbfbe8150d2029accff | ja |
| vom-logbuch-zum-ki-ticketsystem.mp3 | 18 608 515 | 9e4e409963d969474096da0f236b2c6094b15284a45da43277dff62895df2bad | ja |
| warum-ki-nicht-lenken-darf.mp3 | 22 233 475 | 63091782bf2d8c62020fc69a2746887cdb7fbb136b1c4006be23f2f793ade844 | ja |
| roman-als-ki-blaupause.mp3 | 22 118 537 | 816100ff810bcbcef4dd965f0ceb1bcecd1f8de12064f7c02d25968a6b2d9f30 | ja |
| reling-it-podcast-cover.png | 1 005 947 | 6068294ea84e215e20d265d949b32d01f024cd4d9a7cbfee832b9d4be28d9edd | ja |

Danach wurde der Download-Ordner entfernt (`Remove-Item -Recurse`, `Test-Path` → False).

## PR und CI

- PR: https://github.com/Reling-IT/relingit/pull/18, Branch `auftrag-R35-podcast-sicherung`, Commit 919e2f9. Nur `docs/PODCAST.md` ist geändert: Der Abschnitt „Sicherung (Vorschlag, nicht umgesetzt)“ heißt jetzt „Sicherung (GitHub-Release)“ und enthält Link, Datum, Ziel-Commit, Prüfsummenabgleich und die Befehle zum Wiederherstellen.
- Konflikte: Die Änderung ist mit PR #17 (R37, gleiche Datei, Abschnitt direkt davor) konfliktfrei mergebar (`git merge-tree --write-tree HEAD origin/auftrag-R37-notebooklm` ohne Konflikt). Skripte und SHA256SUMS (R36) sind nicht berührt.
- CI: „Website prüfen“ pass (7 s), https://github.com/Reling-IT/relingit/actions/runs/42446143741. PR-Kommentar: https://github.com/Reling-IT/relingit/pull/18#issuecomment-6717144031
- Nicht gemergt.

## Hinweise für Bernd (nicht ausgeführt)

### Lokale Sicherung auf ein externes Medium

Prüfsummenliste (Format `sha256sum`, als `SHA256SUMS.txt` neben die Dateien legen):

```text
4098a1416ca256dbc518c7786b0909b1bc63be9ab63ebdbfbe8150d2029accff  audio/ki-als-beifahrer-im-it-systemhaus.mp3
9e4e409963d969474096da0f236b2c6094b15284a45da43277dff62895df2bad  audio/vom-logbuch-zum-ki-ticketsystem.mp3
63091782bf2d8c62020fc69a2746887cdb7fbb136b1c4006be23f2f793ade844  audio/warum-ki-nicht-lenken-darf.mp3
816100ff810bcbcef4dd965f0ceb1bcecd1f8de12064f7c02d25968a6b2d9f30  audio/roman-als-ki-blaupause.mp3
6068294ea84e215e20d265d949b32d01f024cd4d9a7cbfee832b9d4be28d9edd  img/reling-it-podcast-cover.png
```

Kopierbefehle (PowerShell). Laufwerk `E:` ist ein Beispiel und muss angepasst werden:

```powershell
$quelle = 'C:\Users\bmarn\OneDrive\HTML\reling it\assets'
$ziel   = 'E:\Sicherung\relingit-podcast-2026-10'
New-Item -ItemType Directory -Force "$ziel\audio", "$ziel\img" | Out-Null
robocopy "$quelle\audio" "$ziel\audio" *.mp3 /COPY:DT /R:1 /W:1
robocopy "$quelle\img"   "$ziel\img"   reling-it-podcast-cover.png /COPY:DT /R:1 /W:1
# Prüfen: jede Zeile muss True zeigen
Get-Content "$ziel\SHA256SUMS.txt" | ForEach-Object {
  $h, $p = $_ -split '  ', 2
  $ist = (Get-FileHash -Algorithm SHA256 (Join-Path $ziel $p)).Hash.ToLower()
  '{0}  {1}' -f ($ist -eq $h), $p
}
```

Alternativ ohne OneDrive als Quelle: `gh release download podcast-2026-10 --repo Reling-IT/relingit --dir $ziel`. Die Dateien liegen dann flach im Ordner, die Pfade in der Liste ohne `audio/` und `img/` verwenden.

### OneDrive „Immer auf diesem Gerät behalten“

Lesend geprüft am 08.11.2026 (`[int](Get-Item …).Attributes`, vor und nach `Get-FileHash` unverändert):

- Alle fünf Dateien haben 0x420 (Archiv + ReparsePoint). Offline (0x1000) und RecallOnDataAccess (0x400000) fehlen, die Dateien sind also **aktuell lokal vorhanden** und keine Platzhalter. Pinned (0x80000) ist aber auch nicht gesetzt.
- Der Ordner `assets\audio` hat 0x100410 (Directory + ReparsePoint + **Unpinned** 0x100000). Damit darf OneDrive die Dateien bei Speicherdruck bzw. mit „Speicheroptimierung“ zu Platzhaltern machen.
- Empfehlung: Im Explorer Rechtsklick auf `assets\audio` (und `assets\img`) und dann „Immer auf diesem Gerät behalten“ wählen. Alternativ in PowerShell: `attrib +P -U "C:\Users\bmarn\OneDrive\HTML\reling it\assets\audio" /S /D`. Danach sollte das Attribut der Dateien 0x80000 enthalten.

## Offene Fragen, Risiken, Abweichungen

- **Abweichung „latest“:** Das Release wurde mit `--latest=false` angelegt, GitHub führt es trotzdem als „Latest“ (`gh release list`, `gh api …/releases/latest` → `podcast-2026-10`). Vermutlich liegt das daran, dass es im Repo bisher kein anderes Release gab (der Tag `v0.1.0` hat kein Release). Ich habe nichts geändert: Prerelease wäre eine Abweichung von der Freigabe („normales Release“), ein Hilfsrelease wäre ein weiterer Tag. **Frage an Bernd:** Ist das so in Ordnung, bis ein Software-Release mit `--latest` folgt?
- Die Assets sind öffentlich abrufbar, weil das Repo öffentlich ist. Das entspricht der Bewertung in R23 (Folgen sind ohnehin live), es ist aber ein zweiter Abrufort neben dem Webspace. Ob `datenschutz.html` das erwähnen soll, ist eine Owner-Frage. Technisch ruft die Seite nichts von GitHub ab, sie bindet weiter nur den Webspace ein.
- Die Release-Beschreibung nennt bewusst kein Werkzeug (NotebookLM/Gemini), sondern verweist auf `index.html`/`datenschutz.html`. So bleibt sie unabhängig von R37.
- Freigabe genutzt: genau ein Tag/Release `podcast-2026-10`, fünf Assets. Kein weiterer Tag, kein FTP, keine Veröffentlichung der Seite, OneDrive nur gelesen.

## Vorschläge und Ideen (Claude)

1. Beim nächsten Software-Release (z. B. `v1.38`) `--latest` setzen, dann rückt das Podcast-Release aus der Latest-Position. Dazu einen Hinweis in `publish-release.ps1` bzw. README aufnehmen.
2. R36 könnte `assets/audio/SHA256SUMS.txt` zusätzlich als sechstes Asset an `podcast-2026-10` hängen (eigene Freigabe nötig). Dann ist das Release selbsterklärend prüfbar.
3. Eine kleine Prüfung ohne Download ist möglich: `gh release view podcast-2026-10 --json assets` liefert `digest` je Asset und lässt sich in `ci-check.ps1` oder einem Pester-Test gegen `docs/PODCAST.md` bzw. `SHA256SUMS.txt` vergleichen. So fällt ein Auseinanderlaufen von Doku und Sicherung auf.
4. Die Namenskonvention `podcast-JJJJ-MM` je Neuerzeugung festhalten. Alte Releases bleiben als Stand, dann ist für jede Buchversion der passende Podcast greifbar.
5. Für die externe Sicherung einmal im Quartal die Hash-Prüfschleife oben laufen lassen (Bitrot und versehentliches Überschreiben).

Hygiene: 1 gemergter Remote-Branch übrig (`quelle-pdf-werkzeuge-20261106`, Löschkandidat). Offene PRs: #18 (R35, neu), #17 (R37), #6. Drafts: #9, #10. Der Worktree `C:/dev/wt-r35` bleibt bis zum Merge bestehen.

```yaml
Reifegrad: "Podcast-Dateien dreifach vorhanden: OneDrive-Arbeitsstand, Webspace live, GitHub-Release podcast-2026-10 (unabhängig, hash-geprüft)"
Projektstatus: "R35 umgesetzt; Release angelegt und geprüft, Doku-PR #18 offen mit grüner CI"
Offene_Fragen:
  - "Release wird trotz --latest=false als Latest geführt (einziges Release) – so belassen?"
  - "OneDrive-Ordner assets\\audio auf 'Immer auf diesem Gerät behalten' stellen (aktuell Unpinned)"
  - "Externe Sicherung auf eigenes Medium durch Bernd (Befehle im Bericht)"
  - "Zweiter öffentlicher Abrufort (GitHub) im Datenschutztext erwähnen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schätzung"
```
