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
Der Arbeitsbaum des Klons hat zwei uncommittete Änderungen (`README.md`, `assets/css/styles.css`). Sie sind **nicht** im Bundle (ein Bundle sichert nur Commits). Ich habe sie nicht angefasst. Außerdem meldet `git count-objects` 11,39 MiB „garbage“ (`.git/objects/96/tmp_obj_…`, Rest eines abgebrochenen Git-Laufs); ebenfalls nicht angefasst.

## L25 erneut zur Entscheidung (Bernd)
| Nr. | Ordner | Größe | Stand | Empfehlung |
|---|---|---:|---|---|
| L25 | `archive\ftp-packages\20260905-192045-642\` (v1.32 admin-mfa-final) | 6 538 559 Byte, 25 Dateien | Admin-Dateien jetzt im Bundle gesichert (Gegenprobe ja) | **Papierkorb möglich**, nach deiner Freigabe |

Die Freigabe für L25 fehlt noch. Bis dahin bleibt L25 unberührt. Das geschützte Paket `20260905-193924-327` bleibt in jedem Fall.

## Vorschläge und Ideen (Claude)
- Das Bundle zusätzlich außerhalb von OneDrive ablegen (z. B. als Asset am GitHub-Release `podcast-2026-10` oder einem eigenen Archiv-Release), damit es nicht an einem einzigen Speicherort hängt. Eigener Auftrag, weil das eine Veröffentlichung ist.
- Die zwei uncommitteten Änderungen im Klon kurz sichten: Sind sie überholt, kann der Klon später ganz entfallen; sonst als Patch (`git diff > archive\…patch`) mit sichern.
- Wiederherstellung ist einfach: `git clone <bundle> <ziel>` oder in einem bestehenden Repo `git fetch <bundle> codex/fix-admin-password-recovery:archiv/admin-recovery`.

Hygiene: Remote-Branches unverändert (keine Branch-Löschung); offene PRs: Drafts #25, #26, #27; kein Push aus dem Klon, nichts gelöscht.

```yaml
Reifegrad: Admin-Zwischenstand v1.32 per git bundle gesichert und verifiziert
Projektstatus: L25 kann nach Freigabe in den Papierkorb; Bundle liegt nur im OneDrive-Klon
Offene_Fragen:
  - Gibt Bernd L25 jetzt zum Verschieben in den Papierkorb frei?
  - Soll das Bundle zusaetzlich ausserhalb von OneDrive gesichert werden?
  - Was soll mit den zwei uncommitteten Aenderungen im Klon (README.md, styles.css) geschehen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schaetzung
```
