# R47 – Sicherung des Branches codex/fix-admin-password-recovery (git bundle)

Stand: 2026-11-09, 05:17 (Ortszeit, mit `date` geprüft). Ausgeführt vom Koordinator (Claude Code CLI). Grundlage: queue/R47.yaml, Freigabe Bernd 09.11.2026.

## Ergebnis
Erledigt. Der Branch ist als git bundle gesichert, `git bundle verify` meldet „okay“ und „complete history“. Die Admin-Dateien aus L25 liegen nachweislich im Bundle. Nichts gelöscht, kein Push, kein Force.

## Bundle
- Klon: `C:\Users\bmarn\OneDrive\HTML\reling it` (Branch `codex/fix-admin-password-recovery`, Upstream „gone“)
- Datei: `C:\Users\bmarn\OneDrive\HTML\reling it\archive\codex-fix-admin-password-recovery-b671d7c-2026-11-09.bundle`
  - `archive/` ist im Klon per `archive/.gitignore` (Zeile 2: `*`) ausgenommen; das Bundle kommt also nicht ins Git des Klons.
- Größe: 4 961 178 Byte
- SHA-256: `39340105fb167f5a5d1ed269b1b590a04fb719a037cf91b58d5a1cedbc769b64`
- Inhalt: Ref `refs/heads/codex/fix-admin-password-recovery` → `b671d7c5638a4cd081ee541a9c46d2b66f33a195` („Prevent invalid story HTML uploads“), 36 Commits.

## Belege
```
$ git rev-parse --short codex/fix-admin-password-recovery
b671d7c
$ git bundle create archive/codex-fix-admin-password-recovery-b671d7c-2026-11-09.bundle codex/fix-admin-password-recovery
$ git bundle verify archive/codex-fix-admin-password-recovery-b671d7c-2026-11-09.bundle
... is okay
The bundle contains this ref:
b671d7c5638a4cd081ee541a9c46d2b66f33a195 refs/heads/codex/fix-admin-password-recovery
The bundle records a complete history.
The bundle uses this hash algorithm: sha1
exit=0
$ sha256sum archive/codex-fix-admin-password-recovery-b671d7c-2026-11-09.bundle
39340105fb167f5a5d1ed269b1b590a04fb719a037cf91b58d5a1cedbc769b64
```
Gegenprobe: Bundle in einen Wegwerf-Ordner im Scratchpad geklont (Hinweis „remote HEAD refers to nonexistent ref“ ist erwartet, weil das Bundle nur den Branch enthält). Dann für L25 `git hash-object` (mit und ohne CR) und `git cat-file -e`:
- `relingit-upload-v1.32-2026-09-04-admin-mfa-final/admin.html` → im Bundle: ja
- `relingit-upload-v1.32-2026-09-04-admin-mfa-final/assets/js/admin.js` → im Bundle: ja

## Beobachtung
Der Arbeitsbaum des Klons hat (laut erstem, gekürztem Blick) zwei uncommittete Änderungen – korrigiert im Nachtrag unten: (`README.md`, `assets/css/styles.css`). Sie sind **nicht** im Bundle (ein Bundle sichert nur Commits). Ich habe sie nicht angefasst. Außerdem meldet `git count-objects` 11,39 MiB „garbage“ (`.git/objects/96/tmp_obj_…`, Rest eines abgebrochenen Git-Laufs); ebenfalls nicht angefasst.

## L25 erneut zur Entscheidung (Bernd)
| Nr. | Ordner | Größe | Stand | Empfehlung |
|---|---|---:|---|---|
| L25 | `archive\ftp-packages\20260905-192045-642\` (v1.32 admin-mfa-final) | 6 538 559 Byte, 25 Dateien | Admin-Dateien jetzt im Bundle gesichert (Gegenprobe ja) | **Papierkorb möglich**, nach deiner Freigabe |

Die Freigabe für L25 fehlt noch. Bis dahin bleibt L25 unberührt. Das geschützte Paket `20260905-193924-327` bleibt in jedem Fall.

## Nachtrag 09.11.2026: Patch der Änderungen ohne Commit, Korrektur

Stand 06:05 (Ortszeit). Auftrag Bernd: die zwei Änderungen ohne Commit (README.md, assets/css/styles.css) als .patch neben das Bundle legen. Der Klon wird nicht verändert, das Bundle bleibt nur im OneDrive-Ordner.

- Datei: `C:\Users\bmarn\OneDrive\HTML\reling it\archive\codex-fix-admin-password-recovery-b671d7c-2026-11-09-uncommitted.patch`
- Größe: 4 832 Byte. Umfang: README.md +1 Zeile, assets/css/styles.css +171 Zeilen.
- **SHA-256: `07a7786b3a48ba65cf464864a9c980b78dc1aaa9fb89c5440a2fe112e2bdf0ce`**
- Befehl: `git --no-optional-locks diff --binary HEAD -- README.md assets/css/styles.css`. Die Option `--no-optional-locks` verhindert, dass Git die Index-Datei des Klons auffrischt. Gegenprobe: Die Prüfsumme von `.git/index` ist vor und nach dem Lauf gleich (`d09ee40ad9e4…`), `git status` ist unverändert.
- Gegenprobe Inhalt: Bundle in einen Wegwerf-Ordner geklont und b671d7c ausgecheckt. `git apply --check` passt. Nach `git apply` sind beide Dateien (ohne CR) gleich dem Stand im Klon. Den Wegwerf-Ordner habe ich danach entfernt.

**Korrektur zur Beobachtung oben:** Im Klon gibt es nicht nur zwei, sondern sechs geänderte Dateien ohne Commit sowie zwei unversionierte Einträge. Der Fehler entstand, weil ich die Ausgabe von `git status` beim ersten Lesen auf drei Zeilen gekürzt hatte. Vollständiger Stand (`git --no-optional-locks status --porcelain`):

| Datei | Status | Inhalt anderswo gesichert? | Im Patch |
|---|---|---|---|
| README.md | geändert | nein | ja |
| assets/css/styles.css | geändert | ja, Blob in C:\dev\relingit (4df31e8, R28) | ja |
| datenschutz.html | geändert | ja, Blob in C:\dev\relingit (4df31e8, R28) | nein |
| index.html | geändert | **nein** | nein |
| scripts/build-upload.ps1 | geändert | **nein** | nein |
| scripts/ci-check.ps1 | geändert | **nein** | nein |
| assets/audio/ (4 MP3, 74 222 992 Byte) | unversioniert | ja, Release-Asset podcast-2026-10 (R35) | nein |
| assets/img/reling-it-podcast-cover.png | unversioniert | ja, Blob in C:\dev\relingit (11d41da, R36) | nein |

Noch nicht gesichert sind damit index.html, scripts/build-upload.ps1 und scripts/ci-check.ps1 in ihrer Fassung im Klon. Vermutlich sind es Vorstufen der Podcast-Einbindung, die R28 in main übernommen und angepasst hat; belegt ist das nicht. Bernd entscheidet, ob der Patch um diese drei Dateien (oder alle sechs) erweitert wird.

## Vorschläge und Ideen (Claude)
- Das Bundle zusätzlich außerhalb von OneDrive ablegen (z. B. als Asset am GitHub-Release `podcast-2026-10` oder einem eigenen Archiv-Release), damit es nicht an einem einzigen Speicherort hängt. Eigener Auftrag, weil das eine Veröffentlichung ist.
- Die zwei uncommitteten Änderungen im Klon kurz sichten: Sind sie überholt, kann der Klon später ganz entfallen; sonst als Patch (`git diff > archive\…patch`) mit sichern.
- Wiederherstellung ist einfach: `git clone <bundle> <ziel>` oder in einem bestehenden Repo `git fetch <bundle> codex/fix-admin-password-recovery:archiv/admin-recovery`.

Hygiene: Remote-Branches unverändert (keine Branch-Löschung); offene PRs: Drafts #25, #26, #27; kein Push aus dem Klon, nichts gelöscht.

```yaml
Reifegrad: Admin-Zwischenstand v1.32 per git bundle gesichert und verifiziert
Projektstatus: L25 kann nach Freigabe in den Papierkorb; Bundle liegt nur im OneDrive-Klon
Offene_Fragen:
  - L25 freigegeben und verschoben (R48-Nachtrag)
  - Bundle bleibt nur im OneDrive-Ordner (Entscheidung Bernd 09.11.)
  - Soll der Patch um index.html, scripts/build-upload.ps1 und scripts/ci-check.ps1 aus dem Klon erweitert werden?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schaetzung
```

## Nachtrag 10.11.2026: Patch der drei übrigen Dateien

Stand 05:10 bis 05:11 (Ortszeit, mit `date` geprüft). Ausgeführt von einem Agenten (Claude Code CLI) im Auftrag des Koordinators. Grundlage: Freigabe des Product Owners, Tagesbericht 09.11.2026. Methode wie im Nachtrag vom 09.11.: Im Klon wurde nur gelesen und immer `git --no-optional-locks` verwendet. Es wurde nichts committet, gepusht oder gelöscht und kein Branch gewechselt.

- Datei: `C:\Users\bmarn\OneDrive\HTML\reling it\archive\codex-fix-admin-password-recovery-b671d7c-2026-11-10-uncommitted-2.patch` (neu, keine vorhandene Datei überschrieben)
  - Ausnahme geprüft: `git check-ignore -v` meldet `archive/.gitignore:2:*` für den Patchpfad.
- Größe: 9 804 Byte. Umfang: index.html +85 Zeilen, scripts/build-upload.ps1 +5 Zeilen, scripts/ci-check.ps1 +29 Zeilen, jeweils 0 Zeilen entfernt (`git diff --numstat`).
- **SHA-256: `4749dd34a26b0f9d7fcae1e1b04bb12d17d040444be2e18ec158659ff7f6fd7b`**
- Befehl: `git --no-optional-locks diff --binary HEAD -- index.html scripts/build-upload.ps1 scripts/ci-check.ps1`. Klon auf Branch `codex/fix-admin-password-recovery`, HEAD `b671d7c`.
- Klon unverändert: Die Prüfsumme von `.git/index` ist vor und nach dem Lauf gleich (`f0013402e859…`). Die Ausgabe von `git status --porcelain` (6 Dateien ` M`, 2 Einträge `??`) ist vorher und nachher Zeile für Zeile gleich (Vergleich per `diff`).
- Bundle und Patch vom 09.11. sind unverändert: SHA-256 `39340105fb16…` bzw. `07a7786b3a48…`.

Gegenprobe:
```
$ git clone <bundle> r47-probe        # Hinweis "remote HEAD refers to nonexistent ref" erwartet
$ git checkout b671d7c                # HEAD b671d7c5638a4cd081ee541a9c46d2b66f33a195
$ git apply --check <patch-2>         # check=0
$ git apply <patch-2>                 # apply=0
index.html                ohne CR: Probe = Klon (612941de58e5…)
scripts/build-upload.ps1  ohne CR: Probe = Klon (39ba7a139e37…)
scripts/ci-check.ps1      ohne CR: Probe = Klon (4751897805ff…)
$ git checkout -- .
$ git apply --check <patch-1> <patch-2>   # check_beide=0
$ git apply <patch-1> <patch-2>           # apply_beide=0
README.md, assets/css/styles.css, index.html, scripts/build-upload.ps1, scripts/ci-check.ps1: gleich (ohne CR)
```
Der Vergleich lief ohne CR, weil die Probe mit `core.autocrlf=true` CRLF schreibt. Der Wegwerf-Ordner unter dem Scratchpad wurde danach entfernt (geprüft).

Abweichungen:
- Die Prüfsumme von `.git/index` ist heute `f0013402e859…`, am 09.11. war sie `d09ee40ad9e4…`. Die Index-Datei hat sich zwischen den beiden Läufen geändert, nicht in diesem Lauf. Die Ursache ist nicht belegt (möglich: ein anderer Git-Lauf ohne `--no-optional-locks`, eine Editor-Integration oder OneDrive). `git status` und HEAD sind gegenüber dem 09.11. unverändert.
- In `scripts/ci-check.ps1` des Klons haben 225 von 309 Zeilen CRLF, die übrigen nur LF. Der Patch enthält wegen `core.autocrlf=true` normalisierte LF-Zeilen. Er stellt den Inhalt vollständig wieder her, die gemischten Zeilenenden aber nicht byte-genau.

Einordnung (Vergleich mit origin/main `8abe213`):
- Die 85 neuen Zeilen in index.html stimmen Zeile für Zeile mit dem überein, was R28 (`4df31e8`) in main eingefügt hat. Auf main kamen danach weitere Änderungen hinzu (MP3-Größenangaben, `data-page-count`, ein `aria-label`, Repo-Link).
- build-upload.ps1 und ci-check.ps1 enthalten dieselben Podcast-Dateilisten und Prüfungen wie main; R28 (`9b46859`) und R36 (`11d41da`) haben das in main deutlich erweitert (`-OhneAudio`, `SHA256SUMS.txt`, Größenprüfung, PNG-Kennung).
- Keiner der drei Dateistände des Klons kommt als Blob in der Historie von relingit vor.
- Die drei Dateien sind damit belegbar überholte Vorstufen der Podcast-Einbindung; für index.html Zeile für Zeile geprüft, für die Skripte über Dateilisten und Prüfungen.

Damit sind alle sechs geänderten Dateien des Klons gesichert: README.md und styles.css im Patch vom 09.11., datenschutz.html über R28 in main, die übrigen drei in diesem Patch. Die unversionierten Einträge sind laut Tabelle oben gesichert (R35, R36).

### Vorschläge und Ideen (Claude), 10.11.
- Der Klon hat keinen ungesicherten Inhalt mehr. Der Product Owner kann in einem eigenen Auftrag über R13 entscheiden, ob der OneDrive-Klon ganz entfallen kann.
- In `archive/` eine Datei `SHA256SUMS-R47.txt` mit den Prüfsummen von Bundle und beiden Patches ablegen, damit eine spätere Prüfung ohne den Bericht auskommt.
- Wird der Klon weiter benutzt, dort nur mit `--no-optional-locks` arbeiten; ein per OneDrive synchronisierter `.git`-Ordner ist anfällig.
