---
titel: 'Vormerkungen für v1.40 (Buchtext)'
status: umgesetzt in PR #41 (Sichtung offen)
datum: 2026-11-16
art: Merkliste – kein Auftrag, keine Änderung an main; Aufnahme in ops/queue durch den Planer
---

# Vormerkungen für v1.40

Änderungen am Buchtext, die nicht mehr in v1.39 (freigegeben, Paket `6E48827B…1B98`) gehen. Wortlaut legt der Product Owner fest.

**Rahmen (Entscheidung Product Owner, 16.11.2026):** v1.40 bleibt eine kleine Korrekturfassung mit den Punkten unten. Ergänzung Product Owner 16.11.2026: Punkt 3 (Handout). Nachtrag Product Owner 16.11. früh (STATUS.yaml, Commit f1a0fe7): Die Arbeit an v1.40 beginnt als Draft-PR nach dem Paketbau v1.39 (erledigt); nur der Upload von v1.40 kommt erst nach Upload, R09 und Tag v1.39. Kein neuer Erzählstoff (z. B. aus R05) in v1.40.

## 1. Einstieg „Die Freigabegrenze“ (Kapitel 4): Wiederholung auflösen

**Befund (Product Owner, 16.11.2026):** Kapitel 3 und 4 beginnen nach demselben Muster:

- „Der klare Auftrag“: „Reiner Voss ist der Einzige bei Reling IT, dessen Arbeitswoche …“
- „Die Freigabegrenze“: „Insa Brookmann ist, außer Petra selbst, die Einzige bei Reling IT, die sich noch erinnert, wie das Büro aussah, als es noch keins war …“

**Entscheidung (Product Owner, 16.11.2026):** Beide Einstiege werden in v1.40 korrigiert. Für Reiner („der Einzige“, Kapitel 3) gilt der folgende **Entwurf** (vom Product Owner als Entwurf aufgenommen, 16.11.2026; Wortlaut beim Einbau endgültig festlegen):

> Bei Reling IT endet fast jede Arbeitswoche mit dem letzten Ticket. Die von Reiner Voss endet mit einer festen Uhrzeit: seit einer Herzsache vor ein paar Jahren nur noch vormittags, montags bis donnerstags, keine Ausnahmen, auch wenn er selbst gern welche machen würde.

Danach weiter mit „Petra hat ihm das damals nicht angeboten, sondern durchgesetzt …“; beim Einbau prüfen, ob der Anschluss trägt. Quelle: `source/fahrt-zum-kunden.html`, Kapitel `kap-reiner-voss`.

Insas Einstieg (Kapitel 4) wird umgestellt, **Vorschlag 1**:

> Als Reling IT noch Petra allein war, gab es ein Büro, das keins war: ein Schreibtisch im Flur, eine Kladde für Rechnungen, ein Anrufbeantworter, der öfter blinkte, als er sollte. Außer Petra erinnert sich daran nur noch Insa Brookmann.

Danach geht es weiter mit „Sie ist ungefähr zeitgleich mit Petras Wachstum …“; beim Einbau prüfen, ob der Anschluss ohne Anpassung trägt. Quelle: `source/fahrt-zum-kunden.html`, Kapitel `kap-freigabegrenze`.

Nicht geändert (geprüft, geringe Ähnlichkeit): „Der erste Knoten“ (Finn) und „Was hängen bleibt“ (Enno).

## 2. Wegweiser zur Fahrt im Buch

Ergänzt den Startseiten-Link aus PR #39 (die Fahrt beginnt erst mit Kapitel 6 „Aufbruch“, PDF S. 13 in v1.39):

- Kasten „Aufbau in zwei Teilen“: Satz wie „Die Fahrt beginnt mit dem Kapitel ‚Aufbruch‘ (S. 13).“ Seitenzahl nach dem Rendern von v1.40 prüfen.
- Deckblatt-Inhaltsverzeichnis: Teil 1 gliedern, z. B. „Vor der Fahrt“ (Kaffeeecke bis Vor Reling IT) und „Unterwegs“ ab „Aufbruch“. Einteilung ab „Ankunft“ (Rückblenden, zweite Zeitlinie) legt der Product Owner fest.

## 3. Handout: aktueller Stand und Workshop November

**Ergänzung (Product Owner, 16.11.2026):** In v1.40 wird das Workshop-Handout auf den aktuellen Stand und auf den Workshop im November gebracht.

- Betroffen: `story/current/workshop-handout.html` und das daraus gerenderte `story/current/workshop-handout.pdf` (Profil `handout`, siehe `docs/PDF-ERZEUGEN.md`).
- Stand auf `main` (a1b11a8): Kopfzeile „Workshop-Vorbereitungsmaterial · Ende November 2026“, zuletzt in v1.39 gerendert.
- Was „aktueller Stand“ inhaltlich umfasst (z. B. Bezug auf v1.40, Termin, Übungen), ist unklar und wird vom Product Owner festgelegt. Wortlaut legt der Product Owner fest.

**Vorgehen (Entscheidung Product Owner, 16.11.2026):** Erst die Stellenliste unten, dann legt der Product Owner den Umfang fest, danach Einbau im Draft-PR von R86.

Stellenliste (Stand `main` a1b11a8, Abgleich mit `source/fahrt-zum-kunden.html` per Textsuche):

| Nr. | Stelle im Handout | Befund | Festzulegen |
|---|---|---|---|
| H1 | Kopfzeile „Workshop-Vorbereitungsmaterial · Ende November 2026“ | allgemeine Zeitangabe, kein konkreter Termin | konkretes Datum oder Anlass des Workshops nennen? |
| H2 | Einleitung „In der Geschichte: Ein automatisiertes Vorhersage-Modell übernimmt Routineberechnungen …“ | „Vorhersage“ kommt im Buchtext nicht vor (0 Treffer); der Satz passt vermutlich zu einer älteren Geschichte | Einleitung auf die heutige Geschichte (Navis, Lumen, Sysingboard) umschreiben? |
| H3 | Kasten Navis (Wochendurchlauf, Teamrunde, Sysingboard) | Begriffe kommen im Buch vor (Navis 184, Sysingboard 67, Wochendurchlauf 2 Treffer) | Inhalt gegen v1.39/v1.40 nur gegenlesen |
| H4 | Kasten Lumen (Management-Report, Kundensicht) | Begriffe kommen im Buch vor (Lumen 157, Management-Report 1 Treffer) | wie H3 |
| H5 | Übung „Manöverkritik“ (3 × 5 Minuten) | ohne Bezug auf eine Buchfassung | für den Workshop November ändern oder lassen? |
| H6 | Fußzeile „Begleitmaterial zu ‚Die Fahrt zum Kunden‘ · frei erfunden“ | keine Fassungsangabe | Fassung (v1.40) oder Hinweis auf den Einstieg „Aufbruch“ ergänzen? |
| H7 | „Renderstand“ | wird beim Rendern gesetzt (`render_story_pdf.py`) | nichts, nur neu rendern |

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Beim Einbau von v1.40 die Kapitelanfänge von Teil 1 einmal nebeneinander lesen (erste Sätze je Kapitel); so fallen weitere wiederkehrende Formeln auf.
- Nach Punkt 2 prüfen, ob `ci-check.ps1` die neue Gliederung des Inhaltsverzeichnisses noch als vollständig erkennt (Prüfung der TOC-Ziele).
- Zu Punkt 3: H2 ist aus Sicht von Claude der wichtigste Punkt, weil das Handout dort eine Geschichte beschreibt, die das Buch so nicht (mehr) erzählt.

## Umsetzung (16.11.2026, PR #41)

- Punkt 1: beide Einstiege wie vorgemerkt (Reiner: Entwurf, Insa: Vorschlag 1); Anschlüsse tragen ohne Anpassung.
- Punkt 2: Satz mit Link statt Seitenzahl („Die Fahrt beginnt mit dem Kapitel ‚Aufbruch‘.“, Ziel PDF S. 13). Inhaltsverzeichnis Teil 1: „Vor der Fahrt“, „Unterwegs“, „Am Ziel“ (Ankunft, Am Konferenztisch, Warum Navis und Lumen), „Danach“ (Kurz vor neun bis Ankunft, noch einmal). Die Einteilung ab „Ankunft“ ist ein Vorschlag von Claude nach Lektüre der Kapitelanfänge (Auftrag PO: selbständig umsetzen); Prüfung in Sichtungspunkt V03.
- Punkt 3: H2 neu, H6 mit „(Fassung 1.40)“; H1 unverändert, weil kein konkreter Workshop-Termin belegt ist; H3 bis H5 unverändert.
- Gerendert: Buch 80 Seiten, verify_layout OK; Handout 2 Seiten. Sichtungsliste: SICHTUNG-v1.40.md (V01 bis V06 ergänzt).
- Kapitelanfänge von Teil 1 nebeneinander gelesen: „Der erste Knoten“ (Finn Reimers ist seit vier Wochen … bei Reling IT) und „Was hängen bleibt“ (Enno Feddersen ist seit ein paar Wochen bei Reling IT) folgen einem ähnlichen Muster; laut Befund PO geringe Ähnlichkeit, nicht geändert.

