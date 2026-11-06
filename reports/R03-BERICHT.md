---
id: R03
titel: 'Buchtext v1.38: Korrekturen k1 bis k3'
status: erledigt
start: 2026-11-06T11:44+01:00
ende: 2026-11-06T11:48+01:00
branch: auftrag-R03-buchtext-v138
pr: https://github.com/Reling-IT/relingit/pull/9 (Draft)
commit: 1f49164
ci: 'erwartet rot: genau 1 Fehler, story/current weicht von source ab (PDF offen)'
pdf: offen
---

# R03 Bericht: Buchtext v1.38

## Ergebnis

- Draft-PR #9 ändert nur `source/fahrt-zum-kunden.html`: drei Klarstellungen und den Versionswechsel auf 1.38 vom 06.11.2026 (Deckblatt, Cover-Hinweis, Versionshistorie). Keine neue Szene, keine neuen Figuren.
- **PDF offen:** `verify_layout.py` und `render_story_pdf.py` fehlen, im Repo, unter `C:\dev` und in `Downloads`. Das PDF ist weiter die Fassung 1.37, `story/current` ist unverändert. Darum ist der PR ein Draft, und die CI meldet genau einen erwarteten Fehler.
- **Kein Podcast:** Der Erzähltext ändert sich nicht wesentlich (Entscheidung q11).
- Nicht gemergt, kein FTP, keine Veröffentlichung.

### Fundstellen und Änderungen

| Zeile (v1.37) | Stelle | k | Vorher → Nachher |
|---|---|---|---|
| 805 | Kaffeeecke | k2 | „bislang nur im Browser, ohne eigenen Server dahinter“ → „bislang teils noch im Browser, die Anbindung an den Server ist erst im Aufbau“ |
| 1346 | Warum Navis und Lumen, Petras Regel | k1 | ergänzt um „– zusammenführen ja, zu Scores verdichten nein.“ |
| 1875 | Woher kommen die Infos | k3 | neu: „Zuständig ist Lumen trotzdem für alle Reports der Report-Familie; gelesen werden sie aber nie direkt, sondern nur über den Hub, und der Hub liest nur Areport.“ |
| 1875 | Woher kommen die Infos | k2 | „noch rein im Browser, ohne Server-Sync“ → „teils noch im Browser: Anmeldung und Rollenprüfung laufen bereits über den Server, einige Module speichern ihre Daten aber noch im Browser, die Anbindung ist im Aufbau“ |
| 1876 | Woher kommen die Infos | k1 | „Der Hub rechnet nichts zusammen.“ → „Technisch zusammengeführt wird an genau einer Stelle – Areport sammelt die vier Fachreports, prüft sie und bringt sie in ein gemeinsames Format. Bewertet oder zu einem Score verdichtet wird dabei nichts, weder in Areport noch im Hub.“ |

Diese Treffer habe ich geprüft und nicht geändert:

- Zeile 755 (Personenliste Lumen „Management-Reports (Hub)“): passt bereits.
- Zeile 1166 („zusammengetragen“): technisches Zusammentragen, also erlaubt.
- Zeile 1873 (Bildunterschrift „Areport, der validiert und integriert“): passt bereits.
- Zeile 2057 (alter Eintrag in der Versionshistorie): bleibt als Historie stehen.

**Zeitbezug k2:**

- Zeile 805 ist die Gegenwart der Erzählung, Zeile 1875 der reale Bezug („Heute“). Beide meinen den heutigen Stand.
- Beleg im Referenz-Klon `sysingdashboard`, Stand `7dc4699d` vom 06.11.2026:
  - `CHANGELOG.md:472-477` (1.39.0 vom 17.07.2026): Supabase-Anmeldung, sitzungsbasierte Identität, `/api/sync` mit serverseitiger Prüfung `has_permission`.
  - `CHANGELOG.md:514-523` (1.34.1 vom 13.07.2026): Die API-Discovery erkennt Auth-Guards an Server-Routen.

### Belege

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| Ersetzungen | `python -I r03edit.py` (jede Ersetzung muss genau einmal treffen) | `OK 8 Ersetzungen` |
| Reste | `grep "1\.37\|05\.09\.2026"` außerhalb der Versionshistorie | keine Treffer |
| ci-check im Repo | `pwsh -File scripts/ci-check.ps1` | 1 Fehler: `story/current/fahrt-zum-kunden.html weicht von source/fahrt-zum-kunden.html ab` (erwartet) |
| Vollständigkeit, Links, IDs | Kopie mit R02-Stand, neue Quelle, `publish-release.ps1` | `OK: Version 1.38 vom 6. November 2026 mit 69 Seiten veröffentlicht und paketiert.`, ci-check darin grün |
| Whitespace | `git diff --check` | ohne Befund |
| Konflikte | `git merge-tree` gegen PR #6 und PR #8 | keine |
| Layout | `verify_layout.py` | nicht vorhanden |

## Vorschläge und Ideen (Claude)

1. **PDF-Version prüfen:** Im Probelauf hat `publish-release.ps1` das alte PDF (v1.37) zur HTML-Fassung 1.38 ohne Warnung akzeptiert. Geprüft wird nur die Seitenzahl. Vorschlag: In `ci-check` per `pdftotext` die Versionsnummer im PDF mit dem Deckblatt vergleichen. Das sind wenige Zeilen, `pdfinfo` ist schon im Einsatz.
2. **PDF-Werkzeuge ins Repo:** Liegen `render_story_pdf.py` und `verify_layout.py` nur im Claude-Projekt, kann keine andere Sitzung ein PDF erzeugen. Vorschlag: beide unter `scripts/` ablegen und in `docs/NEUE-GESCHICHTE.md`, Schritt 2, mit Befehl aufnehmen.
3. **Reihenfolge der Merges:** zuerst PR #8 (R02), dann PR #9 nach dem PDF. So läuft der neue Vollständigkeits-Check schon über v1.38. PR #6 (Avatare) ändert die Personenliste konfliktfrei. Merged der Owner ihn vor dem Release, ist v1.38 ein gemeinsames Release mit den Avataren, und R11 kann folgen.
4. **Cover-Hinweis sachlich gehalten:** „Drei sachliche Klarstellungen zu Hub, Areport, Lumen und Sysingboard“. Wenn der Owner eine erzählerischere Form will, ist das eine Zeile.
5. **Beleg 1.34.1 ist schwächer als im Auftrag:** Der Eintrag beschreibt die Erkennung von Auth-Guards durch die API-Discovery, nicht ausdrücklich deren Einführung. Der tragende Beleg ist 1.39.0.

## Offene Fragen, Risiken, Abweichungen

- **PDF offen:** Ohne die Werkzeuge kann ich kein PDF mit geprüftem Layout erzeugen. Die Seitenzahl bleibt bis dahin 69. Das ist für das neue PDF zu prüfen, weil die zusätzlichen Sätze und die Zeile in der Versionshistorie die Seitenzahl ändern können.
- **CI rot im Draft:** genau ein erwarteter Fehler, er verschwindet mit dem `publish-release`-Lauf.
- **Datum:** Laut Auftrag „Datum des Tages“, also 06.11.2026. Wird das PDF erst später erzeugt, muss das Datum eventuell nachgezogen werden, und zwar in Deckblatt und Versionshistorie gemeinsam.

Hygiene: offen sind PR #6 (nicht aus dieser Sitzung), #7, #8 und Draft #9. Keine weiteren Drafts.

```yaml
Reifegrad: "Buchtext v1.38 inhaltlich fertig, PDF und Veröffentlichung offen"
Projektstatus: "R03 erledigt als Draft-PR #9; alle bereiten Aufträge abgearbeitet; R11 wartet auf PR #6"
Offene_Fragen:
  - "Wo liegen verify_layout.py und render_story_pdf.py, oder wer erzeugt das PDF v1.38?"
  - "Soll v1.38 gemeinsam mit den Avataren aus PR #6 erscheinen?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
