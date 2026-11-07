---
id: R23
titel: 'Podcast-Audio sichern: Ort, Größe, Sicherungsweg (Vorschlag)'
status: abgeschlossen
start: 2026-11-07T05:06+01:00
ende: 2026-11-07T05:13+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
---

## Ergebnis

- Die vier MP3-Dateien (zusammen 74 222 992 Byte, etwa 70,8 MiB) liegen lokal und vollständig unter `C:\Users\bmarn\OneDrive\HTML\reling it\assets\audio`. Es sind keine reinen Online-Platzhalter. Eine bytegleiche Zweitkopie liegt im selben OneDrive unter `output/ftp/…-podcast/`.
- Die Dateien sind weder im Repo noch in einer `.gitignore`. Im OneDrive-Klon gelten sie als unversioniert (`??`).
- **Kernbefund:** Die Live-Seite berndmarnau.de/relingit bindet den Podcast ein und liefert alle vier MP3 aus (HTTP 200). Die Einbindung steht aber nur in **uncommitteten** Änderungen im OneDrive-Klon (index.html, datenschutz.html, styles.css, build-upload.ps1, ci-check.ps1). Auf origin/main und auf allen PR-Branches fehlt sie.
- Folge: Ein FTP-Paket aus origin/main würde `index.html` und `datenschutz.html` ohne Podcast-Abschnitt hochladen. Die Einbindung und der Datenschutzhinweis wären damit live entfernt.
- Empfehlung: Den lokalen Podcast-Stand per PR nach main bringen, die MP3 außerhalb von Git halten und zusätzlich als GitHub-Release-Asset sichern, mit SHA-256 im Repo.

| Datei | Größe | SHA-256 | im Repo/ignoriert | referenziert in |
|---|---|---|---|---|
| ki-als-beifahrer-im-it-systemhaus.mp3 | 11 262 465 B (10,7 MiB) | 4098a1416ca256dbc518c7786b0909b1bc63be9ab63ebdbfbe8150d2029accff | nein / nein (unversioniert) | index.html Z. 76/79 nur lokal und live; build-upload.ps1 und ci-check.ps1 nur lokal |
| vom-logbuch-zum-ki-ticketsystem.mp3 | 18 608 515 B (17,7 MiB) | 9e4e409963d969474096da0f236b2c6094b15284a45da43277dff62895df2bad | nein / nein | index.html Z. 87/90 (lokal, live) |
| warum-ki-nicht-lenken-darf.mp3 | 22 233 475 B (21,2 MiB) | 63091782bf2d8c62020fc69a2746887cdb7fbb136b1c4006be23f2f793ade844 | nein / nein | index.html Z. 98/101 (lokal, live) |
| roman-als-ki-blaupause.mp3 | 22 118 537 B (21,1 MiB) | 816100ff810bcbcef4dd965f0ceb1bcecd1f8de12064f7c02d25968a6b2d9f30 | nein / nein | index.html Z. 109/112 (lokal, live) |
| (dazu) assets/img/reling-it-podcast-cover.png | 1 005 947 B | 6068294ea84e215e20d265d949b32d01f024cd4d9a7cbfee832b9d4be28d9edd | nein / nein | index.html Z. 62 (lokal, live) |

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Platzhalter-Status | Die Attribute aller Dateien sind 0x420 (Archiv + ReparsePoint). RecallOnDataAccess (0x400000) und Offline (0x1000) fehlen, die Dateien sind also lokal vorhanden. Die Prüfsummen haben keinen Download ausgelöst, die Attribute danach sind unverändert. | `[int]$_.Attributes`, `attrib` vor und nach `Get-FileHash` |
| Zweitkopie | Die vier MP3 unter `output/ftp/relingit-upload-v1.37-2026-09-05-podcast/assets/audio` sind hash-gleich. Dazu kommt das ZIP (72 922 306 B). Beides liegt im selben OneDrive und ist damit keine unabhängige Sicherung. | Get-FileHash |
| .gitignore C:\dev\relingit (origin/main) | Kein Eintrag für audio/mp3. Ein Hinzufügen würde also nicht verhindert. | `git show origin/main:.gitignore` |
| .gitignore OneDrive-Klon | Inhalt wie auf main. `output/` ist ignoriert, `assets/audio` nicht. | `git check-ignore` ohne Treffer, `git status`: `?? assets/audio/*.mp3` |
| OneDrive-Klon | Steht auf Branch `codex/fix-admin-password-recovery` (Remote-Branch gelöscht, „gone“), Stand b671d7c vom 05.09.2026. Sechs Dateien sind geändert, fünf Dateien unversioniert. Remote `bmarnau/relingit` leitet auf Reling-IT/relingit um. | `git status -sb`, `gh repo view` |
| Referenzen origin/main | Keine Podcast-Einbindung. Die Treffer für „audio“ stammen nur aus dem Erzähltext („Audio (Anruf)“) und aus Base64. | `git grep` über alle Remote-Branches |
| Referenzen PR-Branches | Nur Doku: `docs/NEUE-GESCHICHTE.md` §6 (PR #8) und `docs/vorlagen/EINBAU-CHECKLISTE.md` (PR #7) nennen „Podcast mit Google Gemini neu erzeugen“. Eine Einbindung gibt es dort nicht. | `git grep` je Branch |
| Erwartung der Seite | `index.html` (lokal und live) nutzt `<audio controls preload="metadata"><source src="assets/audio/<name>.mp3" type="audio/mpeg">` mit relativem Pfad und Download-Link. Die Größenangaben 10,7/17,7/21,2/21,1 MB entsprechen den MiB-Werten. | index.html Z. 60–119 (OneDrive) |
| Live-Seite | Die live ausgelieferte `index.html` ist bytegleich mit der lokalen Arbeitskopie (SHA-256 612941de…) und weicht von origin/main ab (10f9242b…). Die MP3 sind live, Last-Modified 20.10.2026 18:36 GMT, Längen identisch. `datenschutz.html` live enthält §4 „Lokal bereitgestellter Podcast“. | `curl -I`, `curl … \| sha256sum` (nur HTTP-Lesezugriff, kein FTP) |
| FTP-Paketbau origin/main | `$publicFiles` enthält weder Audio noch Cover. Das ZIP wird gegen genau diese Liste geprüft, zusätzliche Dateien führen zum Abbruch. | `git show origin/main:scripts/build-upload.ps1` Z. 38–49 |
| FTP-Paketbau lokal | Der uncommittete Diff ergänzt 4 MP3 und das Cover in `$publicFiles`. `ci-check.ps1` verlangt die Dateien, prüft die MP3-Kennung (ID3/0xFF) und den sichtbaren Hinweis „Google NotebookLM“/„KI-generiert“ in index.html. | `git diff` im OneDrive-Klon |
| CSP | `default-src 'self'` ohne eigenes `media-src`. Für Audio vom eigenen Webspace genügt das. Für Audio von Supabase oder GitHub müsste die CSP erweitert werden. | origin/main `.htaccess` Z. 14 |
| Supabase heute | Öffentlicher Bucket `story`. Der Admin-Upload nimmt nur feste Namen an (fahrt-zum-kunden.html, geschichte.pdf, Handout). | `supabase/setup.sql` Z. 149ff., `admin.js` Z. 237–245, 500–505 |
| Offener PR zur Einbindung | Keiner. Deshalb kein PR-Kommentar. | `gh pr list` (#6–#10) |

## Entscheidungsvorlage für Bernd

Ausgangslage: Es gibt rund 71 MiB in 4 Dateien, jede Datei hat höchstens 22 MB. Neue Folgen entstehen selten, nur wenn sich der Erzähltext ändert (Entscheidung q11 laut R03). Ausgeliefert werden die Dateien heute über den DomainFactory-Webspace per FTP.

| Option | Vorteile | Nachteile |
|---|---|---|
| A. Außerhalb des Repos lassen (OneDrive) und zusätzlich eine unabhängige Sicherung (z. B. externe Platte oder zweiter Cloud-Ort). Die Prüfsummenliste kommt ins Repo. | Kein Git-Ballast, keine Kontingentfrage. Die Auslieferung bleibt wie heute, der Datenschutztext stimmt weiter. | Die Sicherung ist ein Handschritt. OneDrive ist ein Sync- und kein Backup-Dienst (Löschungen werden mitsynchronisiert, die Papierkorb-Frist ist begrenzt, zu prüfen). Andere Rechner bzw. CI haben die Dateien nicht, ci-check schlägt dort fehl, wenn die Dateien Pflicht sind. |
| B. Git LFS im Repo | Die Dateien sind versioniert und mit Code und Paketbau gekoppelt. Ein frischer Klon ist vollständig. | Das LFS-Freikontingent für Speicher und Bandbreite ist **zu prüfen** (nicht belegt). Jeder Klon bzw. CI-Lauf mit LFS-Pull verbraucht Bandbreite. Das Repo ist öffentlich, die Dateien wären damit zusätzlich öffentlich über GitHub abrufbar. LFS muss lokal installiert sein. Eine einmal eingespielte LFS-Datei lässt sich kaum spurlos entfernen. |
| C. GitHub-Release-Asset (z. B. Release `podcast-2026-10`) und SHA-256-Liste im Repo | Eine kostenlose, von OneDrive unabhängige Kopie bei GitHub, die Git selbst nicht belastet. Eine neue Folge heißt neues Release oder neues Asset. Die Dateigrenze pro Asset ist **zu prüfen**, liegt nach meinem Kenntnisstand weit über 22 MB. | Die Assets sind öffentlich, weil das Repo öffentlich ist. Inhaltlich ist das unkritisch, die Folgen sind ohnehin öffentlich, aber es wäre ein zweiter Abrufort neben dem Webspace. Ausgeliefert wird weiter per FTP. Das Hochladen ist ein Handschritt (`gh release upload`). |
| D. Supabase Storage (wie die Buch-PDF) und Auslieferung von dort | Die Ablage liegt zentral und lässt sich über den Admin-Bereich pflegen. | Speicherkontingent und Dateigrößengrenze im Free-Tarif sind **zu prüfen**. Dafür sind eine CSP-Änderung (`media-src` für supabase.co) und Änderungen an `admin.js` (feste Dateinamen) nötig. Der Datenschutztext („ausschließlich über den Webspace bei DomainFactory … keine Verbindung zu Google“) müsste umgeschrieben werden, weil dann ein Drittanbieter-Abruf mit IP-Übertragung zu Supabase stattfindet. Das ist der höchste Aufwand. |

**Empfehlung: A + C, vorher den Podcast-Stand nach main bringen.**

1. Zuerst die uncommitteten Podcast-Änderungen aus dem OneDrive-Klon (index.html, datenschutz.html, styles.css, README.md, build-upload.ps1, ci-check.ps1, dazu das Cover-PNG, rund 1 MB) als PR nach main bringen. Das ist dringend, sonst entfernt der nächste reguläre Upload den Podcast von der Live-Seite.
2. Die MP3 dabei **nicht** committen. Stattdessen `assets/audio/*.mp3` in `.gitignore` aufnehmen und eine Datei `assets/audio/SHA256SUMS.txt` mit den vier Prüfsummen oben versionieren. `ci-check.ps1` sollte bei fehlenden Dateien nicht in CI scheitern (heute bricht es dann ab) und lokal vor dem Paketbau gegen SHA256SUMS prüfen.
3. Die vier MP3 als Assets eines GitHub-Release hochladen. Das ist die unabhängige Sicherung außerhalb von OneDrive, ohne Kontingentrisiko und ohne Änderung an Auslieferung und Datenschutztext.

Begründung: Die Auslieferung über den eigenen Webspace bleibt unverändert, ebenso der Datenschutztext. Git bleibt schlank. Eine neue Folge kostet drei Handgriffe: Datei ablegen, Prüfsumme eintragen, Release-Asset hochladen. LFS (B) bringt bei 4 selten geänderten Dateien kaum Nutzen und hat eine ungeklärte Kontingentfrage. Supabase (D) verschiebt die Auslieferung zu einem Dritten und erfordert Änderungen an CSP und Datenschutz.

## Offene Fragen, Risiken, Abweichungen

- **Risiko (hoch):** Die Live-Seite stammt aus einem uncommitteten lokalen Stand. Ein FTP-Paket aus main oder aus den PR-Branches #6–#10 entfernt den Podcast-Abschnitt und den Datenschutz-§4. Die MP3 blieben dann verwaist auf dem Server.
- **Abweichung zu R01/Tagesbericht 06.11.:** Dort heißt es „Podcast auf der Webseite nicht eingebunden“. Das gilt nur für das Repo, die Live-Seite enthält den Podcast.
- **Widerspruch zum Werkzeug:** `datenschutz.html` (live) und `ci-check.ps1` (lokal) nennen **Google NotebookLM**. `docs/NEUE-GESCHICHTE.md` (PR #8) und die Einbau-Checkliste (PR #7) nennen **Google Gemini**. Bernd sollte klären, welches Werkzeug gilt. Dafür kein PR-Kommentar, weil kein offener PR die Einbindung betrifft.
- Der OneDrive-Klon steht auf einem gelöschten Branch (`codex/fix-admin-password-recovery`, Stand 05.09.) und ist damit gegenüber main veraltet. Beim Übertragen nach main die Datei-Diffs gegen den aktuellen main-Stand abgleichen, nicht den alten Branch mergen.
- Wenn ci-check die MP3 als Pflichtdateien verlangt, scheitert CI auf GitHub, solange die Dateien nicht im Repo sind.
- Kontingente für GitHub LFS, Release-Asset-Grenzen und Supabase Free sind nicht belegt und als „zu prüfen“ markiert.
- Für die Live-Prüfung wurden nur HTTP-HEAD- und GET-Anfragen auf öffentliche Seiten gestellt, kein FTP und keine Zugangsdaten.

## Vorschläge und Ideen (Claude)

- Im `UPLOAD-MANIFEST.txt` des Paketbaus stehen die SHA-256 der MP3 schon heute. Die gleiche Liste als `SHA256SUMS.txt` im Repo macht Sicherung, Release-Asset und Webspace gegeneinander prüfbar.
- Optional einen kleinen Prüfschritt ergänzen, der per HTTP HEAD die `Content-Length` der Live-MP3 mit `SHA256SUMS.txt` bzw. den Größen vergleicht, ohne Download.
- `build-upload.ps1` könnte einen Schalter `-OhneAudio` bekommen. Dann lassen sich Textkorrekturen hochladen, ohne die 71 MiB jedes Mal neu zu übertragen. Die Audiodateien liegen ja schon auf dem Server.
- Die Größenangaben auf der Seite („10,7 MB“) sind MiB-Werte. Entweder „MiB“ schreiben oder in MB (11,3/18,6/22,2/22,1) umrechnen.
- Für OneDrive prüfen, ob „Immer auf diesem Gerät behalten“ für `assets/audio` gesetzt werden soll. Heute sind die Dateien lokal, aber nicht angeheftet (kein Pinned-Bit), und können bei Speicherplatzmangel zu Platzhaltern werden.

Hygiene: Reling-IT/relingit hat keine gemergten Remote-Branches außer main. Die Branches der PRs #1–#5 sind entfernt. Offen sind 5 PRs: #6, #7, #8 bereit sowie #9 und #10 als Draft. Remote-Branch `quelle-pdf-werkzeuge-20261106` (4a88f92, 06.11.) hat keinen PR und ist nicht gemergt. `ops/queue` und `ops/reports` sind Betriebsbranches.

```yaml
Reifegrad: 'Podcast live und funktionsfähig, aber nicht versioniert; Sicherung nur über OneDrive (eine Quelle)'
Projektstatus: 'Risiko Regression bei nächstem FTP-Upload aus main; Entscheidung zu Sicherungsweg offen'
Offene_Fragen:
  - 'Lokalen Podcast-Stand (index, datenschutz, styles, Skripte, Cover) per PR nach main übernehmen?'
  - 'Sicherungsweg A+C (OneDrive + GitHub-Release-Asset, SHA256SUMS im Repo) freigeben?'
  - 'Werkzeug für Podcast: Google NotebookLM (Datenschutz, ci-check) oder Google Gemini (NEUE-GESCHICHTE, Checkliste)?'
  - 'Kontingente GitHub LFS / Release-Assets / Supabase Free nur bei Bedarf prüfen'
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: 'unbelegte Schätzung'
```
