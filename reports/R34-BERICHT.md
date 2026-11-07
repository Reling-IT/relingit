---
id: R34
titel: 'Podcast-Einbindung nach main bringen (Regressionsschutz vor dem naechsten Upload), MP3 nicht committen'
status: blockiert
start: 2026-11-07T07:02+01:00
ende: 2026-11-07T07:06+01:00
branch: 'keiner (nicht begonnen)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle_queue: 'origin/ops/queue ab9e873 (Autor Claude, Co-Authored-By und Claude-Session-Link)'
---

# R34 Bericht: Podcast nach main – Überschneidung mit R28

## Ergebnis

- **Blockiert, Rückfrage an Planer und Owner.** Der Kern von R34 ist schon erledigt: R28 hat die Podcast-Einbindung als PR #13 nach main gebracht, gemergt um 06:11 (main 44898de, heute 002f079). Der Regressionsschutz vor dem nächsten Upload besteht damit.
- R34 verlangt in zwei Punkten etwas anderes als der gemergte Stand. Laut Betriebsprompt („Aufträge widersprechen sich“) führe ich das nicht eigenmächtig aus.
- Nichts geändert, kein Branch angelegt.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Podcast-Abschnitt, Datenschutz §4, CSS auf main | vorhanden (R28) | PR #13 gemergt, `git log origin/main` 44898de; reports/R28-BERICHT.md |
| `.gitignore` | enthält `assets/audio/*.mp3` **und** `assets/img/reling-it-podcast-cover.png` | `git show origin/main:.gitignore` Z. 20–21 |
| **Widerspruch 1: Cover** | R34: „Das Cover-PNG (ca. 1 MB) wird committet.“ R28 (Auftrag: „MP3-Dateien und das Cover nicht ins Repo legen“) hat es ausgeschlossen. | queue/R28.yaml Schritt 4; queue/R34.yaml Schritt 4 |
| **Widerspruch 2: Prüfsummen** | R34: `assets/audio/SHA256SUMS.txt` versionieren, ci-check prüft lokal Hashes. R28 (Auftrag: „docs/PODCAST.md … SHA-256“) hat die Prüfsummen in `docs/PODCAST.md` abgelegt, ci-check prüft keine Hashes. | `git ls-tree origin/main`: `docs/PODCAST.md` vorhanden, keine `SHA256SUMS.txt`; ci-check ohne Podcast-Hash-Prüfung |
| ci-check auf GitHub ohne MP3 | grün (fehlende MP3 nur Hinweis) | R28-Bericht, CI auf PR #13 |
| NotebookLM/Gemini | weiter offen, Live-Text (NotebookLM) unverändert | docs/PODCAST.md, R28-Bericht |

## Offene Fragen, Risiken, Abweichungen

- **Frage an den Planer:** Soll R34 als Ergänzung zu R28 laufen (Cover committen, `.gitignore`-Zeile 21 entfernen, `assets/audio/SHA256SUMS.txt` anlegen, lokale Hash-Prüfung in ci-check bzw. build-upload)? Dann bitte R34 entsprechend umformulieren („auf main aufbauen, R28-Stand erweitern“). Oder ist R34 durch R28 erledigt?
- **Abhängige Aufträge:** R13, R35 und R36 hängen von R34 ab. R36 („nach Merge R34“) und der Hinweis „R16 wartet auf den Merge dieses PR“ sind mit PR #13 eigentlich schon erfüllt. Der Planer sollte die Abhängigkeiten auf R28 umstellen.
- **Abweichung:** keine Ausführung, nur dieser Bericht.

## Vorschläge und Ideen (Claude)

1. Ich würde R34 als erledigt durch R28 führen und die beiden Delta-Punkte in R36 aufnehmen. R36 fasst `build-upload.ps1` ohnehin an (Schalter `-OhneAudio`), dort passt eine lokale Hash-Prüfung gegen `SHA256SUMS.txt` dazu.
2. Für das Cover spricht: Es ist klein (ca. 1 MB) und gehört zur Seite. Wird es committet, braucht der FTP-Paketbau keine lokale Sonderdatei mehr. Die Entscheidung liegt bei Bernd.

Hygiene: 1 gemergter Remote-Branch übrig (`quelle-pdf-werkzeuge-20261106`, Löschkandidat), offene PRs #6, #9 (Draft), #10 (Draft).

```yaml
Reifegrad: "Podcast seit PR #13 in main versioniert; Cover und Prüfsummendatei nach R28-Regel außerhalb bzw. in docs/PODCAST.md"
Projektstatus: "R34 blockiert wegen Widerspruch zu R28 (Cover, SHA256SUMS.txt)"
Offene_Fragen:
  - "R34 durch R28 erledigt oder als Ergänzung umformulieren?"
  - "Cover-PNG committen (R34) oder ausgeschlossen lassen (R28)?"
  - "Abhängigkeiten R13, R35, R36, R16 auf R28 umstellen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
