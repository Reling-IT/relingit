---
id: R45
titel: 'OneDrive-Aufräumen Phase 3: L18 bis L26 prüfen und einzeln vorlegen (nur lesen)'
status: erledigt (nur gelesen, Entscheidung je Kandidat liegt bei Bernd)
datum: 2026-11-09
ordner: C:\Users\bmarn\OneDrive\HTML\reling it\archive\ftp-packages
grundlage: reports/R13-LISTE.md (Block D), reports/R13-BERICHT.md
---

## Ergebnis

- Alle neun Kandidaten L18–L26 sind noch vorhanden und unverändert gegenüber R13-LISTE (Dateianzahl und Byte-Summen stimmen exakt).
- **Keine Cloud-Platzhalter** in L18–L26: alle 250 Dateien sind lokal vorhanden (kein Offline-, RecallOnDataAccess- oder RecallOnOpen-Bit). Es wurde nichts hydriert. Die Ordner tragen nur die üblichen OneDrive-Attribute (ReparsePoint 0x400, Unpinned 0x100000), `LinkType` ist bei keinem Eintrag gesetzt.
- **Referenzen:** Die Paketnamen (Zeitstempel) kommen in `origin/main`, im Arbeitsbaum `C:\dev\relingit`, auf `origin/ops/queue` und in allen anderen Remote-Branches nicht vor. Sie erscheinen nur in `reports/R13-LISTE.md` (ops/reports). Auf `main` gibt es nur den allgemeinen Hinweis, dass `publish-release.ps1` alte Pakete nach `archive/ftp-packages/<Zeitstempel>` verschiebt (docs/ABLAUF.md Z. 101, scripts/publish-release.ps1 Z. 162). Kein Skript liest aus diesem Ordner.
- **Inhalt in Git gesichert:** Die meisten Paketdateien liegen als Blob in der Git-Historie von `C:\dev\relingit` (Vergleich per `git hash-object`, mit und ohne CRLF). Ausnahmen: die Admin-Zwischenstände in L22–L26 (admin.html, admin.js) und drei Dateien in L19. Davon liegen alle bis auf zwei im lokalen Git des OneDrive-Klons (Branch `codex/fix-admin-password-recovery`, Upstream „gone“, HEAD `b671d7c` nicht in `C:\dev\relingit`). Einmalig sind nur `datenschutz.html` aus L19 (security-pending) und `fahrt-zum-kunden.html` aus L26 (ersetzt durch das geschützte Paket `20260905-193924-327`).
- **Empfehlung:** L18, L19, L20, L21, L22, L23, L24, L26 → Papierkorb (58 459 633 Byte, 55,75 MiB). **L25 behalten**, bis der Branch des OneDrive-Klons gesichert ist (letzter v1.32-Admin-Stand).

**Löschen erst nach Freigabe je Kandidat durch Bernd.** L12–L15 (Cloud-Platzhalter) wurden nicht angefasst.

## Methode (Befehle)

Alles nur lesend, ohne eigene Skriptdateien, nur Inline-Befehle.

1. Auftrag und Vorgänger: `git show origin/ops/queue:queue/R45.yaml`, `…:queue/R13.yaml`, `git show origin/ops/reports:reports/R13-LISTE.md`, `…/R13-BERICHT.md`.
2. Attribute vor jedem Hash (PowerShell): `[int](Get-Item -Force $p).Attributes -band (0x400000 -bor 0x40000 -bor 0x1000)`. Nur Dateien mit dem Ergebnis 0 wurden mit `Get-FileHash -Algorithm SHA256` gehasht. Treffer: 0 von 250. Das geschützte Paket `20260905-193924-327` wurde für den Vergleich mit L26 genauso geprüft: auch dort 0 Platzhalter.
3. Größe, Anzahl, neueste Datei: `Get-ChildItem -Force -Recurse -File | Measure-Object Length -Sum`, `LastWriteTime -Maximum`. Links: `Where-Object LinkType` (0 Treffer).
4. Ordner-Hash (Spalte „SHA-256 Ordner“): je Datei (inkl. ZIP) eine Zeile `<SHA-256 groß>` + zwei Leerzeichen + Pfad relativ zum Zeitstempel-Ordner mit `\`; Reihenfolge `Sort-Object FullName` (PowerShell 7, kulturabhängig, nicht ordinal); Zeilen mit `-join "`n"` verbunden, ohne Schlusszeilenumbruch; `[Text.Encoding]::UTF8.GetBytes` (ohne BOM) → `[Security.Cryptography.SHA256]::Create().ComputeHash` → `BitConverter`, Bindestriche entfernt. Damit lässt sich später prüfen, ob sich ein Ordner vor dem Löschen verändert hat. Zusätzlich der SHA-256 der ZIP-Datei(en).
5. Inhaltsvergleich: `Compare-Object` über die Paare (relativer Pfad, SHA-256) zwischen L18 und L19, zwischen aufeinanderfolgenden Paketen und zwischen L26 und dem geschützten Paket `20260905-193924-327`.
6. Referenzsuche: `git grep -E "<9 Zeitstempel>"` im Arbeitsbaum, in `origin/main`, `origin/ops/reports`, `origin/ops/queue` und in jedem Branch aus `git branch -r`. Außerdem `git grep "ftp-packages|security-final|final-main|admin-recovery|admin-mfa…" origin/main`.
7. Git-Abdeckung: je Datei `git hash-object --no-filters <datei>` und `tr -d '\r' < <datei> | git hash-object --stdin` (beides ohne `-w`, also ohne Schreiben), dann `git cat-file -e` in `C:\dev\relingit` und im OneDrive-Klon. Herkunft im Klon: `git log --all --find-object=<blob>`, `git branch -a --contains`.
8. Hygiene: `gh pr list --state open`, `git branch -r`, `git branch -r --merged origin/main`.

## Tabelle

Pfade relativ zu `C:\Users\bmarn\OneDrive\HTML\reling it\archive\ftp-packages\`. „Datum“: Änderungsdatum des Ordners / neueste enthaltene Datei. „Git“: Dateien ohne UPLOAD-MANIFEST.txt, deren Inhalt als Blob in `C:\dev\relingit` liegt.

| Nr. | Pfad | Inhalt | Dateien | Größe (Byte) | Datum (Ordner / neueste Datei) | SHA-256 Ordner | Referenzen | Git | Empfehlung |
|---|---|---|---:|---:|---|---|---|---|---|
| L18 | `20260904-070529-752\` | v1.29 | 25 | 6 408 859 | 2026-09-04 07:07 / 07:02 | `B41A5DD6F35F9AE3551E9157B35DF2A14F58783ADABDF35DAE7C8F00A25AF85D` | nur R13-LISTE | 23/23 | **Papierkorb**: inhaltsgleich mit dem v1.29-Ordner in L19 (nur das Manifest weicht ab), alles in Git (Commit 8eeb2a6 „Publish story v1.29“) |
| L19 | `20260904-184557-555\` | v1.29 (erneut) + v1.29 security-pending-supabase | 50 | 12 826 353 | 2026-09-05 06:46 / 2026-09-04 13:28 | `7CC703385CF7A3BD71F20562F284CFF9E813C6CCDEF2651C1D9ACBCC98003A4E` | nur R13-LISTE | 23/23 + 20/23 | **Papierkorb**: v1.29 doppelt; der Zwischenstand „security-pending“ wurde durch L20 (security-final) ersetzt. Einmalig ist nur dessen datenschutz.html |
| L20 | `20260904-185157-249\` | v1.32 security-final | 25 | 6 525 556 | 2026-09-05 06:49 / 2026-09-04 18:45 | `D639813629220E6875375C3E37AF6255B601AC1C68E075BD341AF2A82E1A2D54` | nur R13-LISTE | 23/23 | **Papierkorb**: vollständig in Git |
| L21 | `20260905-115310-734\` | v1.32 final-main | 25 | 6 528 710 | 2026-09-05 13:39 / 2026-09-04 18:51 | `90359F453505AD62F243A60BC176E96C05D286A961182B00DE358511D03C33D6` | nur R13-LISTE | 23/23 | **Papierkorb**: vollständig in Git |
| L22 | `20260905-115912-216\` | v1.32 admin-recovery | 25 | 6 536 015 | 2026-09-05 13:45 / 11:53 | `14880438E268FE3C370929AEFDEC31D58AE7A2E94F2E741A37D92FB48B4A60DA` | nur R13-LISTE | 21/23 | **Papierkorb**: admin.html und admin.js liegen im Klon-Git (Commit 13da399); Zwischenstand |
| L23 | `20260905-121137-035\` | v1.32 admin-mfa | 25 | 6 536 184 | 2026-09-05 13:45 / 11:59 | `13ED4D022062E06255B4F2A53DC2B57B84908A6F8F72F205420E455A9DF664E1` | nur R13-LISTE | 21/23 | **Papierkorb**: Zwischenstand, Admin-Dateien im Klon-Git |
| L24 | `20260905-123424-410\` | v1.32 admin-mfa-qr-fix | 25 | 6 537 277 | 2026-09-05 13:45 / 12:11 | `85E5F8738E908F8ED380622F8FFA61A7BCE1C69C2ED83D994426527D4BBF1334` | nur R13-LISTE | 21/23 | **Papierkorb**: Zwischenstand, Admin-Dateien im Klon-Git |
| L25 | `20260905-192045-642\` | v1.32 admin-mfa-final | 25 | 6 538 559 | 2026-09-05 19:22 / 12:34 | `B6EB7A443E4010F6C7776DF7190C746A83300EAEBD0941C750C5382B3914B13E` | nur R13-LISTE | 21/23 | **Behalten**: letzter v1.32-Admin-Stand. admin.html und admin.js gibt es außer hier nur im Klon-Git (Commit b671d7c, Upstream „gone“, nicht in C:\dev\relingit) |
| L26 | `20260905-192135-924\` | v1.37 korrekturen (erster Lauf) | 25 | 6 560 679 | 2026-09-05 19:23 / 19:20 | `CCE92C0CB2CE24041B9331091B77632B31FB4E532187377E6494B94F6D098A99` | nur R13-LISTE | 19/23 | **Papierkorb**: weicht vom geschützten `20260905-193924-327` (18 min später) nur in UPLOAD-MANIFEST.txt und story/current/fahrt-zum-kunden.html ab; das geschützte Paket ist der korrigierte Stand |
| **Summe** | | | **250** | **64 998 192** | | | | | Papierkorb: 8 Einträge, 225 Dateien, **58 459 633 Byte (55,75 MiB)**; behalten: L25, 25 Dateien, 6 538 559 Byte |

Cloud-Platzhalter, nicht gehasht: keine in L18–L26.

## Hinweise je Kandidat

- **L18**: ZIP `relingit-upload-v1.29-2026-09-04.zip` (2 860 549 Byte), SHA-256 `D9662B8A8B813C3C121FA9539EFFFFB5B4F829BB3E3A0ECF38B01DF1F03D3FEF`. Die 24 Dateien im Ordner sind gleich mit dem v1.29-Ordner in L19, nur UPLOAD-MANIFEST.txt weicht ab (Erstellzeit 07:02 gegen 07:05). Die ZIPs sind wegen der Zeitstempel nicht bytegleich.
- **L19**: zwei ZIPs: `…v1.29-2026-09-04.zip` (`774B42409AFC11290F9C3D5ED8805FA2B1BDBE2DCC207EFAD32942BA55D97E37`) und `…v1.29-2026-09-04-security-pending-supabase.zip` (`1CEA0F39E1D3799B4FA5199BC26541FED51495B0E4A2C9F28CCDC7BC93BDD659`). Der security-pending-Stand weicht von v1.29 in admin.html, datenschutz.html, handout.html, lesen.html, legal.css, admin.js und app.js ab. app.js und lesen.html liegen im Klon-Git. Nur datenschutz.html (security-pending) ist nirgends sonst gesichert. Das ist ein Zwischenstand, den L20 ablöst.
- **L20**: ZIP `…v1.32-2026-09-04-security-final.zip`, `959D04524AAAA1EC8682FAA649EA4F67BC351F12824A9618E96ED7ADB7260F16`. Alle Dateien in Git.
- **L21**: ZIP `…v1.32-2026-09-04-final-main.zip`, `5284A82A63CB5CB1F47628B35C37FE3A0B2E317A4C6088814F3B074F930CF758`. Alle Dateien in Git.
- **L22**: ZIP `…admin-recovery.zip`, `7A78A6CAF5811FCC836BE30335BE29C8404BC9DC99B00FAADD389DD90D73E031`. Gegenüber L21 geändert: admin.html, admin.js.
- **L23**: ZIP `…admin-mfa.zip`, `5A23859B2838B68AF6A8D4CF3C21A2C7555CDA60F6E5D702D680117D59453E41`. Gegenüber L22 geändert: admin.html.
- **L24**: ZIP `…admin-mfa-qr-fix.zip`, `EB9CD69663E54690F5DA1D9DF4EF38FF05E7D2EBF10ECC1D6971AE70CED8F695`. Gegenüber L23 geändert: admin.html, admin.js.
- **L25**: ZIP `…admin-mfa-final.zip`, `C162E677F732BF423549C4458A4FD78D13E25D69A1CEED19C26817CDFEEFB4E2`. Gegenüber L24 geändert: admin.html, admin.js. In `main` steckt die Wiederherstellung über PR #2 (f96ab5d), aber mit anderem Inhalt der Admin-Dateien. Der genaue Stand „admin-mfa-final“ ist außer hier nur im lokalen Klon-Git gesichert. Behalten, bis Punkt 1 der Vorschläge erledigt ist; danach ebenfalls Papierkorb.
- **L26**: ZIP `…v1.37-2026-09-05-korrekturen.zip`, `1F6DF9A74CF9E4D8EF1E8A85221F21FFCA82E883C2FFB0DC4DCAEA3B21CCE710`. Gegenüber dem geschützten gleichnamigen Paket in `20260905-193924-327` weichen nur das Manifest und fahrt-zum-kunden.html ab (R13: „fast gleich“). Das geschützte Paket ist der spätere, korrigierte Lauf.
- Die Vorbedingung aus R13 („Block D erst nach R34/R35 erneut vorlegen“) ist laut queue/INDEX.yaml erfüllt (R34 und R35: erledigt; R35 hat das Release podcast-2026-10 angelegt). Block D enthält ohnehin keine Podcast-Dateien.
- Speicher: Lokal wird der Platz erst nach dem Leeren des Windows-Papierkorbs frei, in OneDrive erst nach dem Leeren des Online-Papierkorbs (wie in R13).

**Löschen erst nach Freigabe je Kandidat durch Bernd.**

## Vorschläge und Ideen (Claude)

- Vor dem endgültigen Ende des OneDrive-Klons den lokalen Branch `codex/fix-admin-password-recovery` sichern. Er hat keinen Upstream mehr („gone“), und sein HEAD fehlt in `C:\dev\relingit`. Möglich ist z. B. `git bundle` in einen Sicherungsordner oder ein Push als Archiv-Branch, beides als eigener Auftrag mit Freigabe. Danach kann auch L25 in den Papierkorb, und alle Admin-Zwischenstände bleiben trotzdem nachvollziehbar.
- Für die Freigabe genügt eine Zeile wie „R45: L18, L19, L20, L21, L22, L23, L24, L26 frei“. Phase 2 sollte vor dem Löschen den Ordner-Hash aus der Tabelle erneut berechnen und nur bei Gleichheit löschen. Das Verfahren kann das R13-Skript `phase2.ps1` übernehmen (Trockenlauf, Schutz-Regex, Platzhalter-Prüfung).
- `publish-release.ps1` legt bei jedem Lauf ein neues Archivpaket an. Eine Aufbewahrungsregel (z. B. die letzten drei Pakete behalten, ältere nur melden) in `docs/ABLAUF.md` würde künftige Aufräumaufträge ersetzen. Das wäre ein eigener Auftrag, weil sich das Skript ändert.
- Die zwei einmaligen Dateien (datenschutz.html aus L19, fahrt-zum-kunden.html aus L26) sind überholte Zwischenstände. Wer sie als Nachweis will, kann vorher nur diese zwei Dateien (zusammen etwa 1,6 MB) in `archive\` ablegen, statt ganze Pakete zu behalten.

Hygiene: gemergte Remote-Branches außer main: keine (`git branch -r` zeigt nur auftrag-R11-avatare-webseite, main, ops/queue, ops/reports). Offene PRs: nur #25 (R11, Draft). Nichts gelöscht, verschoben oder umbenannt, keine Platzhalter hydriert, keine Git-Schreibbefehle (hash-object ohne -w), keine Zugangsdaten oder Schlüsselmuster im Bericht.

```yaml
Reifegrad: R45 abgeschlossen (nur lesen); Block D vollständig inventarisiert, gehasht und gegen Git abgeglichen
Projektstatus: 9 Kandidaten L18-L26 mit 64 998 192 Byte vorgelegt; Empfehlung 8 x Papierkorb (58 459 633 Byte), L25 behalten; nichts verändert
Offene_Fragen:
  - Welche der Kandidaten L18-L26 gibt Bernd einzeln frei (Empfehlung L18-L24 und L26)?
  - Soll der lokale Branch codex/fix-admin-password-recovery des OneDrive-Klons per Bundle oder Archiv-Branch gesichert werden, damit auch L25 entfallen kann?
  - Soll eine Aufbewahrungsregel für archive/ftp-packages in ABLAUF.md bzw. publish-release.ps1 aufgenommen werden?
  - L12-L15 (Cloud-Platzhalter) weiterhin manuell über OneDrive oder per Nachauftrag?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schätzung
```
