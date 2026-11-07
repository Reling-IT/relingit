---
id: R30
titel: Sicherheits- und Konfigurationsprüfung vor v1.38 live
status: erledigt
start: 2026-11-07T06:31+01:00
ende: 2026-11-07T06:52+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
---

# R30 – Sicherheits- und Konfigurationsprüfung

Prüfstand: origin/main `44898de` (Merge PR #13) und alle Remote-Branches. PR #14 wurde während der Prüfung (05:40 UTC) gemergt und ist im Prüfstand nicht enthalten. Es wurden keine Dateien geändert und keine Zugangsdaten verwendet. Live-Prüfung nur mit anonymen HTTP-Anfragen.

## Ergebnis

- Kein Befund „hoch“: In 117 Commits auf allen Branches gibt es kein Geheimnis (kein Secret-/Service-Role-Key, kein JWT, kein Token, kein privater Schlüssel, keine FTP-Zugangsdaten).
- Im Repo ist nur der öffentliche Publishable Key vorhanden (`assets/js/supabase-config.js`, außerdem in `docs/SUPABASE-ANLEITUNG.md`). Es gibt keine HIER_-Platzhalter mehr.
- RLS, AAL2-Prüfung und Edge-Function-Weg passen zu den Zugriffen der Seite.
- **Mittel:** Die Live-Seite liefert keine der Sicherheitsheader aus `.htaccess` und leitet HTTP nicht auf HTTPS um. `admin.html` ist auch über HTTP erreichbar.
- **Mittel:** GitHub Secret Scanning und Push Protection sind deaktiviert. `docs/SICHERHEIT.md` nennt Push Protection aber als Schutzschicht.

| Fundstelle | Befund | Schweregrad | Vorschlag |
|---|---|---|---|
| Live: `https://berndmarnau.de/relingit/` (Repo: `.htaccess` Z. 2–17) | Am 7.11.2026 fehlen in der Antwort HSTS, CSP, X-Content-Type-Options, Referrer-Policy, X-Frame-Options und Permissions-Policy. `http://…/relingit/` und `http://…/relingit/admin.html` antworten mit 200 statt mit einer Weiterleitung. Die Regeln aus `.htaccess` wirken also nicht: Die Datei ist entweder nicht hochgeladen oder mod_headers/mod_rewrite bzw. AllowOverride sind nicht aktiv. | mittel | Mit versteckten Dateien im FTP-Programm prüfen, ob `.htaccess` in `/relingit` liegt. Danach die Header kontrollieren (SICHERHEIT.md, Schritte 8–9). Wenn sie weiter fehlen, bei DomainFactory nachfragen. Bis dahin Admin nur über `https://` aufrufen. |
| GitHub-Repo-Einstellungen (security_and_analysis) | Secret Scanning, Push Protection und Dependabot-Sicherheitsupdates sind deaktiviert, obwohl das Repo öffentlich ist. | mittel | In den Repo-Einstellungen Secret Scanning und Push Protection einschalten (für öffentliche Repos kostenlos). |
| `.github/workflows/ci.yml` Z. 47–52 | Die Historienprüfung findet sb_secret_, SUPABASE_SERVICE_ROLE=, ghp_, github_pat_, private Schlüssel und AKIA. JWT-Muster (Legacy-Keys `eyJ…`, auch service_role) erkennt sie nicht. | niedrig | Ein JWT-Muster ergänzen, z. B. zwei aufeinanderfolgende `eyJ`-Segmente. |
| `supabase/setup.sql` Z. 154–163 | Die Storage-Policies erlauben Admins (AAL2 und Allowlist) Lesen, Hochladen und Ersetzen im ganzen Bucket `story`, nicht nur unter `current/`. `admin.js` Z. 216 schreibt nur nach `story/current/`. Eine Delete-Policy fehlt, was Absicht ist. | niedrig | Optional `(storage.foldername(name))[1] = 'current'` in die Policies aufnehmen. |
| `supabase/setup.sql` Z. 117–124 | `is_story_admin()` ist `security definer` mit `search_path = public`. Die Feedback-Funktion nutzt `pg_catalog, public`. | niedrig | Einheitlich `set search_path = pg_catalog, public` (oder leer mit voll qualifizierten Namen) verwenden. |
| `supabase/functions/submit-feedback/index.ts` Z. 70–71 | Das Rate-Limit verwendet den ersten Eintrag von `x-forwarded-for`. Ob der Supabase-Gateway diesen Wert vom Client übernimmt (Umgehung durch gefälschte Header), ist nicht belegt. | niedrig (zu prüfen) | Bei Supabase klären, welcher Header die echte Client-Adresse enthält, und gegebenenfalls den letzten oder einen vertrauenswürdigen Eintrag verwenden. |
| `scripts/build-upload.ps1` (ZIP enthält `UPLOAD-MANIFEST.txt`); live erreichbar | `UPLOAD-MANIFEST.txt` wird mit hochgeladen und ist öffentlich abrufbar (Version, Erstellzeit, Prüfsummen, Dateiliste). Geheim ist darin nichts. | niedrig | Manifest außerhalb des ZIP-Nutzordners ablegen oder nicht hochladen, alternativ per `.htaccess` sperren. |
| `.htaccess` | Es gibt keine Sperre für Dotfiles, `*.md`, `*.ps1`, `*.txt`, `supabase/`, `docs/` und `source/`. Live liefern `README.md`, `docs/…`, `supabase/…`, `scripts/…` und `source/…` 404 (nicht hochgeladen). `.git/HEAD` und `.htaccess` liefern 403. | Hinweis | Das Paket enthält nur eine Positivliste öffentlicher Dateien (28 + Manifest), das schützt ausreichend. Optional eine Sperre `<FilesMatch "^\.|\.(md|ps1|sql|toml|txt)$">` ergänzen, falls künftig von Hand mehr hochgeladen wird. Klären, ob auf dem Webspace ein `.git`-Ordner liegt (403 statt 404). |
| `.htaccess` Z. 10, 15 | HSTS ohne `includeSubDomains`. CSP mit `style-src 'unsafe-inline'`. `media-src` fehlt, wird aber über `default-src 'self'` abgedeckt (Audio aus dem eigenen Ordner). | Hinweis | Passt für den Unterordner. Erst nach funktionierender Auslieferung feinjustieren. |
| `.gitignore` (main) | Abgedeckt sind `output/`, `tmp/`, `archive/*`, `ideen/`, `.env*`, `*.pem/*.key/*.pfx/*.p12`, `supabase/.temp/`, `assets/audio/*.mp3` und das Podcast-Cover. Nicht abgedeckt: FTP-Client-Dateien (`*.ppk`, `.ftpconfig`, `sftp.json`, `WinSCP.ini`, `sitemanager.xml`), Python-Reste (`__pycache__/`, `.venv/`) aus `scripts/pdf/`, OS-Dateien. `.claude/` wird nur lokal ignoriert (nicht über die versionierte `.gitignore`). | niedrig | Muster ergänzen. MP3 und Cover waren nie in der Historie. |
| Lokaler Klon `C:\dev\relingit` | Ausgecheckt ist der alte Branch `auftrag-R02-veroeffentlichung`, dessen `.gitignore` die MP3-Regel noch nicht enthält. | Hinweis | Vor dem Paketbau auf aktuellen main wechseln, sonst könnten MP3s versehentlich gestaged werden. |
| `reports/R23-BERICHT.md` (ops/reports) | Lokaler Windows-Pfad mit Benutzername in einem öffentlichen Bericht. | Hinweis | In künftigen Berichten Pfade relativ oder neutral angeben. |
| `assets/js/supabase-config.js` Z. 3–4, `docs/SUPABASE-ANLEITUNG.md` | Projekt-URL und öffentlicher Schlüssel sind vorhanden (Publishable, kein Secret). | Hinweis | Keine Änderung nötig. |

### Geprüft und in Ordnung

- `reader_feedback` und `feedback_rate_limits`: RLS aktiv, alle Rechte für anon und authenticated entzogen. Geschrieben wird nur über die Edge Function mit dem serverseitigen Service-Role-Key aus der Umgebung, nicht aus dem Repo (`index.ts` Z. 72–74). Die RPC ist nur für service_role ausführbar.
- `verify_jwt = false` ist bewusst gesetzt und begründet (`config.toml`). Origin-Positivliste, Größenlimit, Honeypot, Kategorien-, Längen- und Versionsprüfung sowie Rate-Limit mit Advisory-Lock sind vorhanden. Ein stündlicher Cron-Job räumt auf.
- `admin_users`: RLS aktiv, kein Client-Zugriff. `is_story_admin()` verlangt `aal2` und einen Allowlist-Eintrag. `story_release`: Alle dürfen lesen, ändern dürfen nur Admins.
- Bucket `story` ist öffentlich lesbar (beabsichtigt). Schreiben ist nur Admins erlaubt. SELECT gibt es nur für Admins, öffentliches Listing ist also nicht möglich.
- `admin.js`: Das Token liegt nur im sessionStorage. Das Recovery-Token wird aus der Adresse entfernt. Das Formular erscheint erst nach AAL2, maßgeblich bleibt die Prüfung auf dem Server.
- Story und Handout laufen im iframe mit `sandbox="allow-same-origin"` ohne `allow-scripts`, mit `referrerpolicy="no-referrer"`. In den Seiten gibt es keine Inline-Skripte (verträglich mit CSP `script-src 'self'`).
- CI: `contents: read`, Actions auf SHA fixiert, `fetch-depth: 0` (die Historienprüfung ist wirksam). Branch-Schutz main: Prüfung „Website prüfen“ ist Pflicht, Force-Push und Löschen sind gesperrt.
- `supabase/tests/security-checks.sql` prüft die wesentlichen Invarianten in einer Transaktion mit Rollback.

## Abgleich SICHERHEIT.md

| Aussage in docs/SICHERHEIT.md | Ist-Stand | Abweichung |
|---|---|---|
| Nur Publishable Key im Browser | stimmt | – |
| „GitHub Push Protection bildet eine zusätzliche Schutzschicht“ | Push Protection und Secret Scanning sind deaktiviert | **ja**, entweder einschalten oder den Satz korrigieren |
| CI sucht Geheimnismuster | stimmt, aber ohne JWT-Muster | gering |
| Admin: Passwort + TOTP (aal2) + Allowlist, serverseitig per RLS | stimmt (`setup.sql`, `admin.js`) | – |
| Token nur im Session Storage, Recovery-Token wird entfernt | stimmt | – |
| Feedback nur über Edge Function, alle Prüfungen wie beschrieben | stimmt | – |
| Sandbox-iframe ohne Skripte, no-referrer | stimmt | – |
| DomainFactory setzt per `.htaccess` HTTPS, HSTS, CSP … | in `.htaccess` vorhanden, **live nicht wirksam** (wie schon am 4.9. vermerkt) | **ja**, weiter offen |
| main geschützt, Force-Push/Löschen untersagt, Workflow nur lesend, Actions fixiert | stimmt | – |
| „Stand: 4. September 2026“ | Seitdem kamen Podcast-Dateien, `UPLOAD-MANIFEST.txt`, Positivliste im Paketbau und das Release-Skript hinzu; nicht erwähnt | Stand aktualisieren |
| 2FA am persönlichen GitHub-Konto | nicht prüfbar | – |

## Offene Fragen, Risiken, Abweichungen

- Ist `.htaccess` auf dem Webspace vorhanden? Erlaubt der Tarif mod_headers und mod_rewrite? Solange nicht, läuft die Admin-Anmeldung ohne erzwungenes HTTPS und ohne CSP. Ein aktiver Angreifer im Netz könnte eine über `http://` geladene Admin-Seite manipulieren. Die Anmeldedaten gehen zwar per HTTPS an Supabase, aber das Skript der Seite wäre austauschbar.
- Warum liefert `.git/HEAD` auf dem Webspace 403 statt 404? Das ist harmlos, wenn es eine allgemeine Dotfile-Sperre des Hosters ist. Klären, ob ein `.git`-Ordner hochgeladen wurde.
- Nicht belegt: Verhalten von `x-forwarded-for` im Supabase-Gateway.
- Ob `setup.sql` in der aktuellen Fassung in der Live-Datenbank ausgeführt ist, lässt sich ohne Zugang nicht prüfen. Empfohlen: `security-checks.sql` vor v1.38 erneut laufen lassen.
- PR #14 wurde während der Prüfung gemergt. Sein Diff (R15, ci-check/output) ist hier nicht sicherheitsgeprüft.

## Vorschläge und Ideen (Claude)

- Vor v1.38 live: Kurzer „Header-Check“ als Schritt in `publish-release.ps1` oder als eigenes Skript: `curl -sI` auf die Live-URL, Abbruch oder Warnung, wenn HSTS oder CSP fehlen oder HTTP nicht weiterleitet.
- Secret Scanning und Push Protection einschalten. Das sind zwei Klicks und sie decken auch Supabase-Schlüsselformate ab.
- Positivliste in `build-upload.ps1` beibehalten. Optional eine Gegenprüfung im ZIP auf verbotene Endungen (`.md`, `.ps1`, `.sql`, `.toml`, `.env`) als zweite Sicherung.
- `SICHERHEIT.md` um einen Abschnitt „Webspace-Inhalt“ ergänzen: was hochgeladen wird, was nie, und wie man das prüft.
- `.gitignore` um FTP-Client- und Python-Artefakte erweitern.

Hygiene: Gemergter Remote-Branch `quelle-pdf-werkzeuge-20261106` kann gelöscht werden. Die Branches von R15 und R28 sind bereits entfernt. Offene PRs: #6 (Avatare, kein Draft), Drafts #9 (R03 Buchtext v1.38) und #10 (Geschichte „Die veralteten Daten“). PR #14 wurde während der Prüfung gemergt. Der lokale Klon steht auf dem alten Branch `auftrag-R02-veroeffentlichung`.

```yaml
Reifegrad:
  Repo_Geheimnisse: sauber (keine Funde in der Historie)
  Datenbank_RLS: gut (Feedback nur über Edge Function, Admin AAL2 und Allowlist)
  Webspace_Header: unwirksam (live keine Sicherheitsheader, keine HTTPS-Weiterleitung)
  GitHub_Schutz: teilweise (Branch-Schutz ja, Secret Scanning/Push Protection nein)
Projektstatus: v1.38 vorbereitet; aus Sicherheitssicht kein Blocker "hoch", Header-Auslieferung vor oder mit Livegang klären
Offene_Fragen:
  - .htaccess auf dem Webspace vorhanden und wirksam?
  - .git-Ordner auf dem Webspace?
  - x-forwarded-for im Supabase-Gateway vertrauenswürdig?
  - setup.sql/security-checks.sql in der Live-Datenbank aktuell?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
