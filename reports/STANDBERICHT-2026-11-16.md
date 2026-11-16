# Standbericht 16.11.2026, 05:50

Rollen: Product Owner, Planer (Claude, ops/queue), Ausführung (Claude Code). Quellen: `origin/main` a1b11a8, `origin/ops/queue` 71cfb3d, `origin/ops/reports` 58046bc, `gh pr list`, nach `git fetch --prune`.

## Kurz

- v1.39 liegt auf `main` (PR #37, Merge a1b11a8 am 15.11.2026). Sichtung 56/56, G1 bis G8 erteilt. Hochgeladen ist sie noch nicht, ein Tag fehlt auch.
- Das Upload-Paket mit Trailer und Link ist gebaut: `relingit-upload-v1.39-2026-11-15-trailer-ohne-audio.zip`, SHA-256 CDF23C5F...9218, 41 Einträge. Es enthält #38 und #39 schon, beide sind aber noch nicht auf `main` (Beleg: UPLOAD-CHECKLISTE-v1.39.md, Nachtrag 16.11.).
- Offene PRs: 2 (#38 Trailer: Ready, CI grün, Head 10fb65f; #39 Link zur Fahrt: Draft, CI grün, Head ba7c909).
- Den Rahmen für v1.40 hat der Product Owner festgelegt: eine kleine Korrekturfassung (Vormerkung VORMERKUNG-v1.40.md). Einen Auftrag in `ops/queue` gibt es dafür noch nicht.

## Warteschlange (ops/queue 71cfb3d)

| Status | Anzahl | Aufträge |
|---|---|---|
| erledigt | 65 | darunter R60, R67, R76 (neu erledigt) |
| bereit | 4 | R77 Doku-PR, R78 Sichtungsliste und `freigabe-pruefen.ps1`, R68 G2/G7 auf main, R29 Tagesabschluss-Prüfung |
| wartet | 6 | R84 (#38), R85 (#39), R09 Live-Prüfung, R52 Tag, R53 Aufräumen, R42 Transkripte |
| geplant | 9 | R12, R70 Teil 2, R71, R72, R79, R80, R81, R82, R83 |
| blockiert | 1 | R05 (Eingangsdateien fehlen) |

## Reihenfolge bis v1.40

1. Der Product Owner sichtet #38 und #39 und merged sie mit Head-SHA. Danach wird das Paket mit `main` abgeglichen.
2. Der Product Owner lädt v1.39 hoch, geplant in rund einer Woche. Danach folgen R09, R52 (Tag v1.39) und R53.
3. v1.40: Der Planer legt den Auftrag an, die Umsetzung kommt als Draft-PR, danach Rendern, Sichtung, G1 bis G8. Der Upload von v1.40 kommt erst nach dem Tag v1.39.

## Was ich in Git geändert habe

- `reports/STATUS.yaml`: neuer Stand. Ich habe den Warteschlangen-Stand 71cfb3d eingetragen, die Aufträge #38 und #39 mit R84 und R85 verknüpft, die Reihenfolge erneuert und die bereiten Aufträge samt PR-Grenze eingetragen. Die Abweichung bei den Stunden habe ich vermerkt.
- Diesen Bericht.

## Befunde

1. **Stunden 15.11.:** Laut R77 sollen für den 15.11.2026 3 Stunden in `docs/PILOT.md` eingetragen werden. Der Product Owner hat aber 7 bestätigt (TAGESBERICHT-2026-11-15.md, TA-09, Commit faf9338). Das sollte vor R77 richtiggestellt werden.
2. **PILOT.md ist veraltet:** Die Datei steht auf dem 12.11. und nennt v1.38 als Stand von `main`. Nach dem Steckbrief fällt am 16.11. die Entscheidung „weiter / einfrieren / einstellen“, und danach ist eine Pause bis Jahresende geplant. Die Planung für v1.40 passt dazu nur, wenn die Pause verschoben wird. Ob sie verschoben ist, lässt sich im Repository nicht belegen.
3. **PR-Grenze:** Höchstens 3 offene PRs aus KI-Sitzungen. Offen sind 2. Die drei bereiten Code-Aufträge R77, R78 und R68 haben also nicht gleichzeitig Platz.
4. **Lokale Reste:** Der Worktree `C:\dev\wt\relingit\r60` hängt an einem gemergten Branch, der auf GitHub gelöscht ist. Der lokale Branch `ops/queue` liegt 30 Commits hinter `origin`. Löschen geht nur über R13/R53 mit Freigabe.

## Vorschläge und Ideen (Claude)

- Vor dem Paketabgleich zuerst #38 und #39 mergen. Dann stimmt das Paket CDF23C5F mit `main` überein und muss nicht neu gebaut werden, wenn sich am Head nichts ändert.
- Von den bereiten Aufträgen R77 zuerst bearbeiten, mit 7 Stunden für den 15.11. R79 und R80 hängen daran. R78 und R68 betreffen beide `freigabe-pruefen.ps1` und könnten in einem PR zusammengefasst werden. Das spart einen PR-Platz, ist aber eine Entscheidung des Planers.
- Den Planer bitten, den Auftrag für v1.40 jetzt anzulegen, auch wenn er bis zum Tag v1.39 wartet. Dann ist die Vormerkung in `ops/queue` nachvollziehbar.
- Den Status in `docs/PILOT.md` im selben Doku-PR (R77) auf v1.39 und die Entscheidung vom 16.11. bringen.

## Fragen an den Product Owner

Die erste Frage: Sollen für den 15.11. 7 Stunden in `docs/PILOT.md` eingetragen werden statt der 3 aus R77? Meine Empfehlung: ja, 7, wie im Tagesabschluss bestätigt.

**Antwort des Product Owners (16.11.2026):** 7 Stunden am 15.11. R77 trägt 7 ein, nicht 3. Den Auftragstext in `ops/queue` korrigiert der Planer.
