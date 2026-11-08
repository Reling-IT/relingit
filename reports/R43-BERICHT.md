---
id: R43
titel: 'Qualitätssicherung vor jeder Freigabe: FREIGABE.md, freigabe.yaml, freigabe-pruefen.ps1, lokale Vorschau und Sichtungsliste'
status: erledigt (PR offen, CI grün, nicht gemergt)
datum: 2026-11-08
branch: auftrag-r43-freigabe
pr: https://github.com/Reling-IT/relingit/pull/22
commit: 6df732b
ci: grün (Website prüfen, Lauf 42451359763)
---

## Ziel
Jede neue Version läuft vor der Freigabe durch die Tore G1 Code, G2 Kommentare, G3 Layout, G4 UI, G5 Inhalt, G6 Lokal, G7 Git und G8 Freigabe Bernd (Entscheidung Bernd 08.11.). Bernd kann die Version vor der Freigabe lokal selbst sichten.

## Dateien
| Datei | Inhalt |
|---|---|
| docs/FREIGABE.md | Prozess, Regel (kein Merge, Tag oder Upload bei offenem Tor), Tore-Tabelle, Rollen, Mermaid-Ablauf, Bedienung der Skripte |
| docs/freigabe.yaml | Tore maschinenlesbar, mit PyYAML 6.0.3 geprüft (`yaml.safe_load` liefert G1 bis G8) |
| scripts/freigabe-pruefen.ps1 | Kopfkommentar mit Zweck, Eingabe und Ausgabe. Automatisch geprüft werden G1, G2, G6 und G7. Schreibt reports/FREIGABE-vX.YY.md und legt reports/SICHTUNG-vX.YY.md an; eine vorhandene Sichtungsliste wird ausgewertet und nie überschrieben |
| scripts/vorschau.ps1 | Kopie der öffentlichen Dateien (`$publicFiles` aus build-upload.ps1, per AST gelesen) ins Temp-Verzeichnis. In der Kopie ist Supabase abgeschaltet. Server `python -m http.server --bind 127.0.0.1`, optional `-Pdf`, `-OhneBrowser`, `-NurBauen` |
| tests/freigabe-pruefen.Tests.ps1 | 5 Tests freigabe-pruefen (Mini-Projekt mit Bare-Repository als origin), 1 Test vorschau -NurBauen |
| tests/TestHelfer.ps1 | Platzhalter für die 11 Schriftdateien aus v1.38. Ohne sie schlugen nach dem Merge von #10 vier build-upload-Tests auch auf main fehl |
| .gitignore | `reports/` (lokale Ausgabe der Skripte) |
| README.md, docs/ABLAUF.md | Links; in ABLAUF neuer Schritt T „Freigabe G1 bis G8“ vor dem Merge, mit Belegzeilen |

ci-check.ps1 und build-upload.ps1 sind unverändert. Die Pflichtdateiliste verlangt die neuen Dateien nicht.

## Tore
| Tor | Name | Automatik | Prüfung im Skript | Ergebnis möglich |
|---|---|---|---|---|
| G1 | Code | ja | ci-check.ps1, node --check assets/js/*.js, Invoke-Pester -Path tests | bestanden / nicht bestanden / offen |
| G2 | Kommentare | ja | Kommentar in den ersten 10 Zeilen jedes scripts/*.ps1/*.py; PR-Review nicht CHANGES_REQUESTED (gh) | bestanden / nicht bestanden / offen |
| G3 | Layout | nein | Sichtung PDF (6 Punkte) | nur offen |
| G4 | UI | nein | Sichtung 6 Seiten × 390/768/1280 px (18 Punkte) | nur offen |
| G5 | Inhalt | nein | Sichtung Inhalt (2 Punkte, Ergänzung) | nur offen |
| G6 | Lokal | ja | Podcast-MP3 gegen SHA256SUMS.txt; vorschau.ps1 und Python vorhanden | bestanden / nicht bestanden / offen |
| G7 | Git | ja | git status sauber; Feature-Branch = origin; offener PR gegen main, kein Draft, Checks grün, mergeable (gh) | bestanden / nicht bestanden / offen |
| G8 | Freigabe Bernd | nein | gesperrt, solange G1/G2/G6/G7 nicht bestanden oder die Sichtung Nein- bzw. leere Punkte hat | offen / gesperrt, nie bestanden |

## Probelauf auf dem Release-Zweig
Temporärer Worktree `git worktree add --detach C:/dev/wt-r43-probe origin/geschichte-veraltete-daten-20261107` (ba5a23c). Aufruf: `pwsh -File C:/dev/wt-r43/scripts/freigabe-pruefen.ps1 -Projekt C:/dev/wt-r43-probe -AusgabeOrdner <Scratchpad>/probe`. Ergebnis: Exit 1 nach 81 s. `git status --porcelain` im Probe-Worktree war danach leer. Den Worktree habe ich mit `git worktree remove` entfernt.

Konsole:
```
G1 Code            bestanden
G2 Kommentare      offen
G3 Layout          offen
G4 UI              offen
G5 Inhalt          offen
G6 Lokal           nicht bestanden
G7 Git             nicht bestanden
G8 Freigabe Bernd  gesperrt
Ergebnis: 2 automatische Prüfung(en) nicht bestanden.
```

Auszug FREIGABE-v1.38.md (Einzelprüfungen):
```
| G1 | ci-check.ps1 | bestanden | Exit 0; OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, ... geprüft. |
| G1 | node --check | bestanden | 6 Dateien ohne Fehler: admin.js, app.js, handout-viewer.js, pdf-viewer.js, story-viewer.js, supabase-config.js |
| G1 | Pester-Tests | bestanden | Invoke-Pester -Path tests: 8 bestanden, 0 fehlgeschlagen |
| G2 | Review ohne Änderungswunsch | offen | kein offener Pull Request |
| G2 | Kopfkommentar je Skript | bestanden | 5 Skripte unter scripts/ mit Kommentar in den ersten zehn Zeilen |
| G3 | Sichtung PDF | offen | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 6 leer von 6 |
| G4 | Sichtung Webseiten in 390, 768 und 1280 px | offen | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 18 leer von 18 |
| G5 | Inhalt gelesen | offen | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 2 leer von 2 |
| G6 | Podcast-MP3 gegen SHA256SUMS.txt | nicht bestanden | assets/audio/SHA256SUMS.txt fehlt |
| G6 | Lokale Vorschau möglich | bestanden | scripts/vorschau.ps1 vorhanden, Python: ...\Python311\python.exe |
| G7 | git status sauber | bestanden | git status --porcelain ohne Ausgabe |
| G7 | Feature-Branch, gleich Upstream | bestanden | Branch geschichte-veraltete-daten-20261107 (losgelöster Stand), HEAD ba5a23c = origin/...; Hinweis: 16 Commit(s) hinter origin/main |
| G7 | Pull Request offen, kein Draft, Checks grün | nicht bestanden | kein offener Pull Request für geschichte-veraltete-daten-20261107 |
| G8 | Freigabe durch Bernd | gesperrt | Voraussetzungen fehlen: G2 offen; G6 nicht bestanden; G7 nicht bestanden; G3/G4/G5 Sichtung unvollständig |
```
Zur Einordnung: Auf dem Stand ba5a23c gibt es SHA256SUMS.txt noch nicht (sie kam mit R36). PR #10 wurde während des Auftrags gemergt (81849d9), deshalb gibt es keinen offenen PR. Beide Befunde stimmen.

Auszug SICHTUNG-v1.38.md:
```
| Nr | Tor | Bereich | Prüfpunkt | Breite | Ergebnis (Ja/Nein) | Bemerkung |
|---|---|---|---|---|---|---|
| W01 | G4 | Startseite | index.html: Kopf, Version, Datum und Seitenzahl, Navigation, kein waagrechter Bildlauf | 390 px |  |  |
| W02 | G4 | Startseite | ... | 768 px |  |  |
...
| P01 | G3 | PDF: Deckblatt | Version 1.38, Datum und Hinweis Neu in v1.38 stimmen | - |  |  |
| P06 | G3 | PDF: Seitenzahl | Seitenzahl der PDF entspricht der Angabe auf der Startseite (77) | - |  |  |
| I01 | G5 | Neue Szene gelesen | neue Szene vollständig gelesen, keine inhaltlichen oder sprachlichen Fehler | - |  |  |
```
Insgesamt 26 Punkte: W01 bis W18, P01 bis P06, I01 bis I02.

Vorschau auf demselben Stand (`vorschau.ps1 -Projekt <probe> -NurBauen`): Der erste Versuch brach ab, weil `assets/img/reling-it-podcast-cover.png` dort noch nicht versioniert ist. Fix in 7f98d17: Fehlende Dateien werden mit Hinweis übersprungen, abgebrochen wird nur ohne index.html. Danach: 34 Dateien kopiert, 5 übersprungen (4 MP3, Cover), Kopie gelöscht.

## Vorschau-Beleg (Branch auftrag-r43-freigabe)
`vorschau.ps1 -OhneBrowser -Port 8044`:
- `Invoke-WebRequest http://127.0.0.1:8044/index.html` → HTTP 200; `story/current/geschichte.pdf` (HEAD) → HTTP 200
- Server-Kommandozeile: `python.exe -m http.server 8044 --bind 127.0.0.1 --directory "C:\Users\bmarn\AppData\Local\Temp\relingit-vorschau-…"`
- `Get-NetTCPConnection -LocalPort 8044 -State Listen` → LocalAddress 127.0.0.1, Port 8044 (kein 0.0.0.0, kein ::)
- Aufruf über die LAN-Adresse 172.18.224.1:8044 → Verbindung verweigert
- Ausgelieferte supabase-config.js ist leer (`url: "", publishableKey: ""`). Die Seiten zeigen also die lokale Rückfallfassung.
- Nach dem Ende des Serverprozesses meldet das Skript „Server wurde beendet. Vorschau beendet, temporäre Kopie gelöscht.“; Temp-Ordner geprüft: nicht mehr vorhanden.
- Strg+C selbst habe ich nicht automatisiert getestet. Die Aufräumlogik steht im `finally` und läuft bei Strg+C genauso.

## Tests
- `Invoke-Pester -Path tests` (Pester 3.4.0, pwsh 7): 21 bestanden, 0 fehlgeschlagen, 253 s.
- Vor dem Fix in TestHelfer: 16/5. Vier build-upload-Tests schlugen wegen der Schriften aus v1.38 fehl (Fehler schon auf main), dazu ein eigenes Testmuster.
- `pwsh -File scripts/ci-check.ps1`: „OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.“
- `git diff --check origin/main HEAD`: ohne Befund.

## CI
PR #22, Job „Website prüfen“: pass (8 s), https://github.com/Reling-IT/relingit/actions/runs/42451359763. Ergebnis als PR-Kommentar: https://github.com/Reling-IT/relingit/pull/22#issuecomment-6717799350. Gegenprobe mit dem Skript auf dem eigenen Branch: G7 bestanden (PR #22, MERGEABLE, 1/1 Check grün), G2 bestanden.

## PR
https://github.com/Reling-IT/relingit/pull/22 (offen, kein Draft, nicht gemergt)

## Offene Fragen, Abweichungen
- Abweichung: Einen Entwurf freigabe.yaml oder einen Reiter „Freigabe“ der Abstimmungsseite habe ich nicht gefunden (main, ops/queue und ops/reports durchsucht). Die Tore sind aus dem Auftrag abgeleitet. Bitte mit dem Entwurf abgleichen, falls er außerhalb des Repos liegt.
- Ergänzung: Die Sichtungsliste hat einen Abschnitt „Inhalt (G5)“ mit 2 Punkten, weil der Auftrag für G5 keine eigenen Punkte nennt.
- Abweichung: Der Bericht liegt im Scratchpad und nicht als reports/R43-BERICHT.md im Repo. Grund: reports/ ist in main jetzt per .gitignore ausgenommen; der Bericht gehört auf ops/reports.
- Zusatzänderung: tests/TestHelfer.ps1 (Schrift-Platzhalter), um bestehende Fehler auf main zu beheben. build-upload.ps1 ist unverändert.
- G8 ist bewusst streng: G8 bleibt auch dann gesperrt, wenn G1, G2, G6 oder G7 nur „offen“ sind (z. B. ohne lokale MP3). Bernd sollte entscheiden, ob ein Paket mit -OhneAudio G6 als „nicht zutreffend“ gelten lassen darf.
- Die Fixture-Repositories der Tests setzen lokal `commit.gpgsign false`. Das gilt nur im Wegwerf-Repository unter TestDrive, weil global Signieren aktiv ist.
- Laufzeit der neuen Tests: rund 30 s je Fall.

## Vorschläge und Ideen (Claude)
- Torliste aus docs/freigabe.yaml lesen lassen statt im Skript festzuschreiben, z. B. mit einem kleinen Python-Helfer, weil pwsh keinen YAML-Parser mitbringt. Ein Pester-Test könnte die Gleichheit beider Listen prüfen.
- G8 per gh nachweisen: einen PR-Kommentar „Freigabe G8 vX.YY: ja“ von Bernds Konto suchen und dann „erteilt (Link)“ ausgeben, als eigener Ergebniswert.
- publish-release.ps1 könnte vor dem Paketbau einen Freigabebericht ohne „nicht bestanden“ verlangen (eigener Auftrag, weil das Skript sich ändert).
- Option `-OhneAudio` auch in freigabe-pruefen.ps1, damit G6 bei Textkorrekturen ohne MP3 „nicht zutreffend“ statt „offen“ meldet.
- Hilfe für G4: Playwright-Screenshots in 390, 768 und 1280 px gegen 127.0.0.1 in die Sichtungsliste verlinken. Die Sichtung bleibt trotzdem bei Bernd.
- Testlaufzeit senken, indem ein Mini-Projekt für mehrere Fälle wiederverwendet wird.

Hygiene: 7 gemergte Remote-Branches noch vorhanden (auftrag-R35, R36, R37, r39, r40, avatare-buch-und-seite-20261106, geschichte-veraltete-daten-20261107). Offene PRs: nur #22, keine Drafts. Worktree C:\dev\wt-r43 bleibt bestehen (Branch gepusht, sauber). Den temporären Worktree C:\dev\wt-r43-probe habe ich zweimal angelegt und jeweils entfernt. Nichts installiert, nichts gemergt, kein Tag, keine Änderung an Workflows, Deployment, Supabase oder Admin-Konten.

```yaml
Reifegrad: Freigabeprozess dokumentiert und skriptgestützt; G3 bis G5 und G8 manuell, im Probelauf belegt
Projektstatus: R43 als PR #22 offen, CI grün, wartet auf Review und Merge durch Bernd
Offene_Fragen:
  - Gibt es einen Entwurf freigabe.yaml oder den Reiter Freigabe außerhalb des Repos, mit dem abgeglichen werden soll?
  - Soll G6 bei Paketen mit -OhneAudio als nicht zutreffend gelten?
  - Soll publish-release.ps1 künftig einen Freigabebericht ohne Befund verlangen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
