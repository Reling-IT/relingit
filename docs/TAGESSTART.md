# Tagesstart (Runbook)

Kurzer Ablauf für die erste KI-Sitzung des Tages. Grundlage ist ADG `SITZUNGSROUTINE.md`, Tagesstart TS-01 bis TS-07 (bmarnau-standards/ai-development-governance, Entwurf). Das Projektprofil steht in [CLAUDE.md](../CLAUDE.md).

Der Tagesstart liest nur. Er wechselt keine Branches, löscht nichts und räumt nicht auf. Einzige Schreibaktion ist das Protokoll (Schritt 7). Ein Schritt ohne Beleg gilt als nicht erledigt; ist er nicht prüfbar, steht im Protokoll `nicht geprüft` mit Grund.

## Schritte

| Schritt | Was | Befehl oder Quelle | Beleg im Protokoll |
| --- | --- | --- | --- |
| 1 (TS-01) | Umgebung: Arbeitsklon, Git, GitHub-CLI mit Anmeldung, PowerShell 7; für Prüfungen Pester, für Releases Poppler (`pdfinfo`, `pdftotext`) | `git --version`, `gh auth status`, `$PSVersionTable.PSVersion` | „Umgebung: ok“ oder Liste `[fehlt]` |
| 2 (TS-02) | Warteschlange lesen, **immer nach `git fetch`** (am 08.11.2026 war die lokale Warteschlange veraltet und ein Auftrag wurde doppelt gestartet) | `git fetch origin`, dann `git show origin/ops/queue:queue/INDEX.yaml` | Anzahl je Status, die nächsten drei Aufträge mit `status: bereit` |
| 3 (TS-03) | Git und Worktrees: Branch, HEAD gegen `origin/main`, ungesicherte Änderungen, Worktrees (z. B. `C:\dev\wt-*`), Remote-Branches außer `main` und `ops/*` | `git status -sb`, `git worktree list`, `git branch -r --merged origin/main` | Eine Zeile; nur melden, nicht aufräumen |
| 4 (TS-04) | Status und Doku: Stand von `reports/STATUS.yaml` gegen Warteschlange und Git (z. B. „erledigt“ ohne gemergten PR) | `git show origin/ops/reports:reports/STATUS.yaml` | Abweichungen oder „keine“ |
| 5 (TS-05) | Zielbezug: Profilfeld `ziel` ist `offen` (keine Ziel- oder Meilensteindatei im Repository). Hilfsweise die YAML-Felder `Projektstatus` und `Roadmap` im letzten Tagesbericht | `git show origin/ops/reports:reports/TAGESBERICHT-<Datum>.md` | Je Auftrag der Zielbezug in einem Halbsatz; ohne Zielbezug als Frage |
| 6 (TS-06) | Offene PRs mit Head-SHA, CI und Mergefähigkeit; Drafts; offene Fragen aus dem letzten Tagesbericht | `gh pr list -R Reling-IT/relingit --state open --json number,headRefOid,isDraft,mergeable,statusCheckRollup` | Liste „Wartet auf den Product Owner“ |
| 7 (TS-07) | Protokoll ablegen | siehe unten | Pfad und Commit |

## Protokoll

- Ablage: Branch `ops/reports`, Ordner `reports/`, signierter Commit direkt auf diesen Branch (Weg `direkt`, TP-04). Den Branch nie löschen oder umschreiben, kein Force-Push.
- Dateinamen (Ausnahme nach TP-01): `reports/TAGESSTART-JJJJ-MM-TT.md` für den Tagesstart, der vorhandene `reports/TAGESBERICHT-JJJJ-MM-TT.md` für den Tagesabschluss. Der Tagesbericht enthält künftig die Abschnitte TA-01 bis TA-07, darunter „Erreicht“, „Nächste Aufgaben“ und „Arbeitspaket nächste Sitzung, ca. 2 Stunden“.
- Vorlage: ADG `vorlagen/tagesprotokoll.md`. Abschluss mit dem üblichen YAML-Block (`Reifegrad`, `Projektstatus`, `Offene_Fragen`, `Roadmap`).
- Commit-Nachricht: `Tagesprotokoll JJJJ-MM-TT: Tagesstart` (TP-06).
- Das Repository ist öffentlich (TP-09): nur Rollen statt Personennamen, keine Kosten, Vertrags- oder Entscheidungsinterna, keine Hinweise auf Sicherheitslücken.
- Nicht verwechseln: Auf `main` ist `reports/` in `.gitignore` eingetragen und nimmt nur die lokale Ausgabe von `scripts/freigabe-pruefen.ps1` auf. Protokolle gehören nicht dorthin.
