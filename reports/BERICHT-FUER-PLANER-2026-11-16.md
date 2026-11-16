---
titel: 'Bericht für den Planer: Stand, Versionen, PRs, nächste Schritte'
datum: 2026-11-16
stand: '07:20, nach git fetch --prune und gh pr list'
quellen: 'main a1b11a8, ops/queue ea666f2, ops/reports b1a91d6'
---

# Bericht für den Planer, 16.11.2026

> **Nachtrag 08:20 (gilt vor allem anderen in diesem Bericht):** #40, #39, #38 sind gemergt (`main` 907ca58). Upload-Paket v1.39 aus `main`: 476622E7…8AA1 (Inhalt gleich CDF23C5F). v1.40 ist in PR #41 fertig gerendert (80 Seiten) und Ready; es fehlen nur Sichtung und G8 durch den Product Owner. Offene PRs: 1. Queue: R84/R85 erledigt, R86 `wartet_auf_owner`. Reihenfolge: Upload v1.39 → R09 → Tag v1.39 → Merge #41 → Upload v1.40 → R09 → Tag v1.40. Details: TAGESBERICHT-2026-11-16.md (Nachtrag 08:20), R86-BERICHT.md.

Dieser Bericht ersetzt für die Planungsseite die Lage von 06:00 und ihren Nachtrag (`LAGE-FUER-PLANER-2026-11-16.md`). Er ist ohne weitere Quellen lesbar. Rollen: Product Owner, Planer (Claude Chat), Ausführung (Claude Code).

## 1. Kurzfassung

- **v1.39** ist fertig und auf `main`, aber noch **nicht veröffentlicht** und **ohne Tag**.
- **v1.40** ist geplant (Auftrag R86) und darf jetzt als Draft-PR beginnen, sobald ein PR-Platz frei ist.
- **3 PRs offen, Grenze erreicht.** Alle drei sind grün und mergebar und warten nur auf den Product Owner.
- **Entscheidung 16.11.:** weiter, die Pause bis Jahresende ist verschoben (neuer Termin offen).

## 2. Versionen

| Version | Stand | Nächster Schritt | Beleg |
|---|---|---|---|
| v1.38 | nie hochgeladen, übersprungen | keiner | Entscheidung „kein Upload v1.38 vor v1.39“ (`ops/queue` 57db401) |
| **v1.39** | auf `main` (PR #37, Merge a1b11a8 am 15.11.), Sichtung 56/56, G1 bis G8 erteilt; Upload-Paket CDF23C5F…9218 enthält zusätzlich #38 und #39; kein Tag | nach Merge von #38/#39 Paket mit `main` abgleichen, dann Upload durch den Product Owner (in rund einer Woche), R09, R52 (Tag), R53 | SICHTUNG-v1.39.md, UPLOAD-CHECKLISTE-v1.39.md, `git tag` (kein v1.39) |
| **v1.40** | Rahmen und Themen festgelegt, Auftrag R86 angelegt, noch kein Code | Draft-PR, sobald ein PR-Platz frei ist; Upload erst nach Upload, R09 und Tag v1.39 | VORMERKUNG-v1.40.md, R86 |

Welche Fassung heute live ist, lässt sich im Repository nicht belegen (unklar).

### Themen v1.40 (kleine Korrekturfassung, kein neuer Erzählstoff)

| ID | Inhalt | Offen beim Product Owner |
|---|---|---|
| V140-1 | Einstiege „der/die Einzige bei Reling IT“ auflösen: Kap. 3 Reiner (Entwurf), Kap. 4 Insa (Vorschlag 1) | endgültiger Wortlaut beim Einbau |
| V140-2 | Wegweiser zur Fahrt: Satz im Kasten „Aufbau in zwei Teilen“, Teil 1 im Inhaltsverzeichnis gliedern („Vor der Fahrt“ / „Unterwegs“) | Einteilung ab „Ankunft“ |
| V140-3 | **neu 16.11.:** Workshop-Handout auf aktuellen Stand und Workshop November | Umfang anhand der Stellenliste H1 bis H7 (VORMERKUNG Punkt 3); auffällig H2: Einleitung nennt ein „Vorhersage-Modell“, das im Buch nicht vorkommt |

## 3. Pull Requests

| PR | Inhalt | Zustand | Head | CI | Auftrag | Wartet auf |
|---|---|---|---|---|---|---|
| #38 | Stummer Trailer im Hero | Ready | 10fb65f | grün, CLEAN | R84 | Sichtung (Video, Safari/iOS, „Bewegung reduzieren“) und Merge |
| #39 | Link „direkt zur Fahrt“ (Kapitel „Aufbruch“) | Draft | ba7c909 | grün, CLEAN | R85 | Prüfung des Sprungs im Browser, Ready, Merge |
| #40 | Doku-Nachzüge R77 (TAGESSTART, PDF-ERZEUGEN, PILOT) | Draft | 2c6a93f | grün, CLEAN | R77 | Sichtung, danach Nachtrag PILOT.md (siehe unten), Merge |

- Gemergt wird nur durch den Product Owner, mit Head-SHA. Wegen des strict-Branchschutzes ändert jeder Merge die Heads der anderen PRs (`update-branch`); die SHAs oben gelten nur bis zum ersten Merge.
- #38 und #39 ändern beide `index.html`. Ändern sich ihre Heads nicht inhaltlich, muss das Paket v1.39 nicht neu gebaut, nur mit `main` abgeglichen werden.
- **Entscheidung Product Owner 16.11.:** Die Zeile „Entscheidung weiter / einfrieren / einstellen“ in `docs/PILOT.md` wird als weiterer Commit in #40 nachgezogen, **erst nach** der Sichtung von #40. Der Head von #40 ändert sich dadurch; der Merge braucht dann den neuen SHA.

**Folge der PR-Grenze:** Bis einer der drei PRs gemergt oder geschlossen ist, startet kein neuer Code-PR. Das betrifft R86 (v1.40), R78, R68, R79, R80.

## 4. Nächste Schritte

Zwei Stränge, die nicht aufeinander warten. Verbunden sind sie nur über die PR-Grenze.

**Strang A: Veröffentlichung v1.39**

1. Product Owner sichtet #38, #39, #40 und merged mit Head-SHA (vorher bei #40 den PILOT-Nachtrag).
2. Ausführung gleicht das Upload-Paket mit `main` ab.
3. Product Owner lädt v1.39 hoch (in rund einer Woche).
4. R09 Live-Prüfung → R52 Tag v1.39 → R53 Aufräumen.

**Strang B: v1.40 (R86)**

1. Sobald ein PR-Platz frei ist: Draft-PR mit V140-1 und V140-2.
2. V140-3: Product Owner legt den Umfang anhand H1 bis H7 fest, Einbau im selben Draft-PR, Handout-PDF neu rendern.
3. Rendern, Sichtung, G1 bis G8.
4. Upload v1.40 erst nach Upload, R09 und Tag v1.39.

## 5. Queue (`ops/queue` ea666f2), offene Aufträge

| Status | Aufträge |
|---|---|
| bereit | R29 (Tagesabschluss-Prüfung, wiederkehrend) |
| wartet_auf_owner | R84 (#38), R85 (#39) |
| wartet_auf_voraussetzung | R86 (v1.40, PR-Platz); R78, R68 (PR-Platz); R09, R52, R53 (Upload v1.39); R42 |
| geplant | R12, R70, R71, R72, R79, R80, R81, R82, R83 |
| blockiert | R05 (Szenenideen; ausdrücklich nicht für v1.40) |

## 6. Bitte an den Planer

1. Planungsseite mit den Strängen A und B führen, nicht als eine Kette.
2. R86: Feld `hinweis_lage_2026_11_16` berichtigen. Dort steht noch „Beginn erst nach Upload und Live-Prüfung“. Es gilt: Beginn als Draft-PR, sobald ein PR-Platz frei ist (Nachtrag Product Owner, `ops/reports` f1a0fe7). V140-3 als „wartet auf Umfang durch den Product Owner“ kennzeichnen.
3. R71 (Pausen-Check) und R72 (Wiederaufnahme-Checkliste) nach der Entscheidung „weiter, Pause verschoben“ neu einordnen; der neue Termin der Pause ist offen.
4. In `STATUS.yaml` steht unter `queue_bereit` noch der Stand `ops/queue 71cfb3d`; bei der nächsten Planung auf ea666f2 ziehen.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Merge-Reihenfolge #40 → #39 → #38: #40 ist reine Doku und gibt am schnellsten einen PR-Platz für R86 frei; #38 zuletzt, weil seine Sichtung (Safari/iOS) am längsten dauert.
- R78 und R68 (beide `freigabe-pruefen.ps1`) in einem PR bündeln, das spart einen PR-Platz.
- Die Stellenliste H1 bis H7 vor dem Workshop-Termin entscheiden, damit das Handout nicht an v1.40 hängt, falls sich v1.40 verzögert.
