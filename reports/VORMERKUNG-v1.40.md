---
titel: 'Vormerkungen für v1.40 (Buchtext)'
status: vorgemerkt
datum: 2026-11-16
art: Merkliste – kein Auftrag, keine Änderung an main; Aufnahme in ops/queue durch den Planer
---

# Vormerkungen für v1.40

Änderungen am Buchtext, die nicht mehr in v1.39 (freigegeben, Paket `6E48827B…1B98`) gehen. Wortlaut legt der Product Owner fest.

## 1. Einstieg „Die Freigabegrenze“ (Kapitel 4): Wiederholung auflösen

**Befund (Product Owner, 16.11.2026):** Kapitel 3 und 4 beginnen nach demselben Muster:

- „Der klare Auftrag“: „Reiner Voss ist der Einzige bei Reling IT, dessen Arbeitswoche …“
- „Die Freigabegrenze“: „Insa Brookmann ist, außer Petra selbst, die Einzige bei Reling IT, die sich noch erinnert, wie das Büro aussah, als es noch keins war …“

**Entscheidung:** Reiners Einstieg bleibt (dort trägt „der Einzige“ den Kern des Kapitels). Insas Einstieg wird umgestellt, **Vorschlag 1** (vom Product Owner gewählt, 16.11.2026):

> Als Reling IT noch Petra allein war, gab es ein Büro, das keins war: ein Schreibtisch im Flur, eine Kladde für Rechnungen, ein Anrufbeantworter, der öfter blinkte, als er sollte. Außer Petra erinnert sich daran nur noch Insa Brookmann.

Danach geht es weiter mit „Sie ist ungefähr zeitgleich mit Petras Wachstum …“; beim Einbau prüfen, ob der Anschluss ohne Anpassung trägt. Quelle: `source/fahrt-zum-kunden.html`, Kapitel `kap-freigabegrenze`.

Nicht geändert (geprüft, geringe Ähnlichkeit): „Der erste Knoten“ (Finn) und „Was hängen bleibt“ (Enno).

## 2. Wegweiser zur Fahrt im Buch

Ergänzt den Startseiten-Link aus PR #39 (die Fahrt beginnt erst mit Kapitel 6 „Aufbruch“, PDF S. 13 in v1.39):

- Kasten „Aufbau in zwei Teilen“: Satz wie „Die Fahrt beginnt mit dem Kapitel ‚Aufbruch‘ (S. 13).“ Seitenzahl nach dem Rendern von v1.40 prüfen.
- Deckblatt-Inhaltsverzeichnis: Teil 1 gliedern, z. B. „Vor der Fahrt“ (Kaffeeecke bis Vor Reling IT) und „Unterwegs“ ab „Aufbruch“. Einteilung ab „Ankunft“ (Rückblenden, zweite Zeitlinie) legt der Product Owner fest.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- Beim Einbau von v1.40 die Kapitelanfänge von Teil 1 einmal nebeneinander lesen (erste Sätze je Kapitel); so fallen weitere wiederkehrende Formeln auf.
- Nach Punkt 2 prüfen, ob `ci-check.ps1` die neue Gliederung des Inhaltsverzeichnisses noch als vollständig erkennt (Prüfung der TOC-Ziele).
