# Lage für den Planer, 16.11.2026, 06:00

> Ersetzt durch `BERICHT-FUER-PLANER-2026-11-16.md` (07:20).

## Nachtrag 07:15: Kurzfassung – wo wir stehen und was als Nächstes kommt

Belegt mit `git fetch` und `gh pr list` am 16.11.2026 um 07:15. Seit 06:00 hat sich am Code nichts geändert, nur die Planung für v1.40.

**Wo wir stehen**

- v1.39 ist fertig und auf `main` (a1b11a8), aber **noch nicht veröffentlicht** und ohne Tag. Das Upload-Paket liegt bereit (CDF23C5F…9218, enthält auch #38 und #39).
- Offene PRs: #38 Trailer (Ready), #39 Link zur Fahrt (Draft), #40 Doku R77 (Draft, CI grün). Das sind 3, die **Grenze ist erreicht**. Alle drei warten auf Sichtung und Merge durch den Product Owner.
- Die Queue (`ops/queue` 0db4198) ist auf diesem Stand: R77 erledigt, R84/R85 `wartet_auf_owner`, R86 (v1.40) angelegt.

**Was wir vorhaben: zwei Stränge, die nicht aufeinander warten**

| Strang | Nächster Schritt | Wer | Blockiert durch |
|---|---|---|---|
| A. Veröffentlichung v1.39 | Sichtung und Merge #38, #39, #40 → Paket mit `main` abgleichen → Upload v1.39 (in rund einer Woche) → R09 Live-Prüfung → R52 Tag → R53 Aufräumen | Product Owner, danach Ausführung | Product Owner |
| B. Vorbereitung v1.40 (R86) | Draft-PR mit V140-1, V140-2, V140-3 → Rendern, Sichtung, G1 bis G8 | Ausführung, Wortlaut Product Owner | freier PR-Platz (also Merge in Strang A) |

Strang B darf **vor** dem Upload v1.39 beginnen (Nachtrag Product Owner, Commit f1a0fe7). Nur der **Upload von v1.40** wartet auf Upload, R09 und Tag v1.39. Die ältere Formulierung „Beginn erst nach Upload und R09“ in der Vormerkung ist jetzt angeglichen; in R86 steht sie im Feld `hinweis_lage_2026_11_16` noch und sollte dort berichtigt werden.

**Neu seit 06:00: V140-3 Handout**

- Der Product Owner hat v1.40 um ein drittes Thema ergänzt: das Workshop-Handout (`story/current/workshop-handout.html` und `.pdf`) auf den aktuellen Stand und den Workshop November bringen.
- Vorgehen (Entscheidung Product Owner): erst eine Stellenliste, dann legt der Product Owner den Umfang fest, dann Einbau im Draft-PR von R86. Die Liste H1 bis H7 steht in `VORMERKUNG-v1.40.md`, Punkt 3.
- Auffällig ist H2: Die Einleitung des Handouts spricht von einem „Vorhersage-Modell“, das im Buchtext nicht vorkommt.

**Bitte an den Planer**

1. Planungsseite mit den zwei Strängen A und B führen, nicht als eine Kette.
2. In R86 den Hinweis zum Beginn berichtigen (siehe oben) und V140-3 als „wartet auf Umfang durch den Product Owner“ kennzeichnen.
3. Erledigt 07:20: Der Product Owner hat „weiter“ entschieden, die Pause bis Jahresende ist verschoben (neuer Termin offen). Eingetragen in `ops/queue` (`hinweis_owner`) und STATUS.yaml. R71 und R72 bitte entsprechend einordnen.

---

Dieser Bericht richtet sich an den Planer (Claude Chat, `ops/queue`). Er beschreibt den Stand seit `ops/queue` 71cfb3d und ist ohne weitere Quellen lesbar. Rollen: Product Owner, Planer, Ausführung (Claude Code). Belegt mit `git fetch` und `gh pr list` am 16.11.2026 gegen 06:00.

## 1. Versionen in einem Satz je Ort

| Ort | Stand | Beleg |
|---|---|---|
| `main` | **v1.39** (14.11.2026, 80 Seiten), Sichtung 56/56, G1 bis G8 erteilt | PR #37, Merge a1b11a8 am 15.11.2026; SICHTUNG-v1.39.md |
| Website (live) | **nicht v1.39**. v1.38 wurde nie hochgeladen (Entscheidung „kein Upload v1.38 vor v1.39“, `ops/queue` 57db401). Welche Fassung live ist, lässt sich im Repository nicht belegen. | – |
| Upload-Paket | `relingit-upload-v1.39-2026-11-15-trailer-ohne-audio.zip`, SHA-256 CDF23C5F...9218, 41 Einträge. Enthält v1.39 **plus** #38 und #39. Nur lokal, nicht in Git. | UPLOAD-CHECKLISTE-v1.39.md (Nachtrag 16.11.) |
| Tag | kein Tag v1.39 | `git tag` |

**Wichtig:** v1.39 ist fertig und gemergt, aber noch nicht veröffentlicht. Den Upload macht der Product Owner selbst, geplant in rund einer Woche. Erst danach folgen R09, R52 und R53.

## 2. Offene Pull Requests (3 = Grenze erreicht)

| PR | Inhalt | Zustand | Head | Auftrag |
|---|---|---|---|---|
| #38 | Stummer Trailer im Hero | Ready, CI grün, CLEAN | 10fb65f | R84 (Queue) = PO-TRAILER (STATUS) |
| #39 | Link „direkt zum Kapitel Aufbruch“ | Draft, CI grün, CLEAN | ba7c909 | R85 (Queue) = PO-LINK-FAHRT (STATUS) |
| #40 | Doku-Nachzüge R77 | Draft, CI läuft | 2c6a93f | R77 |

#38 und #39 hat der Product Owner am 15.11. direkt beauftragt, ohne Eintrag in der Queue. Fertig gebaut sind beide. Was noch fehlt: die Sichtung durch den Product Owner (Video, Safari/iOS, „Bewegung reduzieren“, der Sprung im Browser) und der Merge mit Head-SHA. Beide ändern `index.html`. Nach dem Merge muss das Paket mit `main` abgeglichen werden. Ändern sich die Heads nicht, muss es nicht neu gebaut werden.

Mit #40 sind 3 PRs aus KI-Sitzungen offen. **Neue Code-PRs (R78, R68, R79, R80) erst, wenn einer davon gemergt oder geschlossen ist.**

## 3. Was die Queue 71cfb3d noch nicht weiß

| Auftrag | In der Queue | Tatsächlich | Bitte in `ops/queue` |
|---|---|---|---|
| R77 | bereit, 15.11. = 3 Stunden | ausgeführt, Draft-PR #40. Eingetragen sind **7** Stunden für den 15.11.: 3 am Tag und 4 am Abend, vom Product Owner am 16.11. bestätigt. Summe in PILOT.md: 12 | Status auf `in_arbeit` oder `erledigt` (PR #40), Stundenangabe auf 7 |
| R84 | wartet_auf_voraussetzung, ohne Abhängigkeit | Nacharbeit fertig (10fb65f), wartet nur auf die Sichtung durch den Product Owner | Status `bereit` oder `wartet_auf_owner` |
| R85 | wartet_auf_voraussetzung | PR fertig. Offen ist nur die Prüfung des Sprungs im Browser, danach Ready | Status `bereit` |
| R85, Schritt 2 | „Paket aus main neu bauen“ | Das Paket mit #38 und #39 gibt es schon (CDF23C5F). Nach dem Merge reicht der Abgleich mit `main`. | Schritt anpassen |
| v1.40 | kein Auftrag | Rahmen vom Product Owner festgelegt: kleine Korrekturfassung, kein neuer Erzählstoff. Zwei Themen: V140-1 „der/die Einzige bei Reling IT“ (Kap. 3 Reiner, Kap. 4 Insa) und V140-2 Wegweiser zur Fahrt. Arbeit als Draft-PR erlaubt; Upload erst nach Upload, R09 und Tag v1.39 | Auftrag anlegen, Quelle VORMERKUNG-v1.40.md. Wegen der PR-Grenze startet er erst, wenn ein PR frei ist |
| R09 | abhängig von R01 | hängt tatsächlich am **Upload v1.39 durch den Product Owner** | Abhängigkeit „Upload v1.39 (Owner)“ ergänzen |

## 4. Reihenfolge, wie sie jetzt gilt

1. Der Product Owner sichtet #38, #39 und #40 und merged mit Head-SHA. Bei strict-Branchschutz ändert jeder Merge den Head der anderen PRs (`update-branch`).
2. Danach wird das Paket mit `main` abgeglichen.
3. Upload v1.39 durch den Product Owner, in rund einer Woche.
4. R09 Live-Prüfung, danach R52 Tag v1.39, danach R53 Aufräumen.
5. v1.40: Draft-PR, sobald ein PR-Platz frei ist; Rendern, Sichtung, G1 bis G8, Upload nach dem Tag v1.39.
6. Danach R71 und R72 (Pause), falls der Product Owner bei der Pause bleibt.

## 5. Offen beim Product Owner

- Sichtung und Merge von #38, #39 und #40.
- Upload v1.39.
- Eine Entscheidung „weiter / einfrieren / einstellen“ ist nicht dokumentiert. PILOT.md nennt den 16.11. als Termin und eine Pause bis Jahresende. Die Planung für v1.40 setzt voraus, dass weitergearbeitet wird. Das sollte in der Queue festgehalten werden.

## 6. Was der Planer nicht sehen kann

- Lokale Worktrees unter `C:\dev\wt\relingit\` (link-fahrt, paket-v139, r60, r77, rep, trailer) und die Paketdateien. Beides ist nicht in Git; Hashes und Größen stehen in UPLOAD-CHECKLISTE-v1.39.md.
- Der Worktree `r60` gehört zu einem gemergten Branch und kann nach dem Release über R53 weg.

## Vorschläge und Ideen (Claude)

- In der Queue ein Feld `wartet_auf_owner` getrennt von `wartet_auf_voraussetzung` führen. Dann sieht man, ob ein Auftrag am Product Owner hängt oder an einem anderen Auftrag. R84 und R85 sind heute so ein Fall.
- Direktaufträge des Product Owners (wie PO-TRAILER) sofort mit einer Queue-ID versehen, damit Queue und STATUS dieselbe Liste führen.
- R78 und R68 (beide `freigabe-pruefen.ps1`) in einem PR zusammenfassen, das spart einen der drei Plätze.
