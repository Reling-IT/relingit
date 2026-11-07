---
id: R05
titel: 'Hauptdokument der Szenenideen nachziehen (k5, q1, q8)'
status: blockiert
start: 2026-11-07T05:00+01:00
ende: 2026-11-07T05:03+01:00
branch: 'keiner (lokale Dokumente, nichts geändert)'
pr: 'keiner'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle_queue: 'origin/ops/queue 0f77f9f (Autor Claude, Co-Authored-By und Claude-Session-Link vorhanden)'
---

# R05 Bericht: Szenenideen nachziehen

## Ergebnis

- **Blockiert.** Die Voraussetzung ist nicht erfüllt: Beide Dateien (`szenenideen-offene-konzepte.md`, `szenenideen-fortsetzung-2026-11.md`) liegen nicht in `C:\Users\bmarn\OneDrive\HTML\reling it`.
- Wie der Auftrag verlangt, habe ich nichts geändert, keine Sicherungskopie angelegt und nichts gelöscht.

| Punkt | Beobachtung | Beleg |
|---|---|---|
| Ordner vorhanden | ja, enthält eine ältere Arbeitskopie der Webseite (README, index.html, source, story, ideen, tmp) | `ls -la "/c/Users/bmarn/OneDrive/HTML/reling it"` |
| Datei `szenenideen-offene-konzepte.md` | nicht vorhanden | `find . -iname '*szenen*'` im Ordner: kein Treffer |
| Datei `szenenideen-fortsetzung-2026-11.md` | nicht vorhanden | wie oben |
| Suche im ganzen Benutzerprofil | kein Treffer | `find /c/Users/bmarn -maxdepth 6 -iname '*szenenideen*'`: keine Ausgabe (Ende 05:02) |
| Unterordner `ideen/` | nur Bilder und `ideen.txt`, `chatgpt.txt`, `prompt1.txt`, `prompt2.txt`, keine Szenenideen-Datei | `ls ideen` |
| Kopf „Stand 2026-11-06“ der Begleitdatei | nicht prüfbar, die Datei fehlt | – |

## Offene Fragen, Risiken, Abweichungen

- **Frage an Bernd:** Wo liegen die beiden Dateien? Möglich: Sie sind noch nicht aus OneDrive synchronisiert, oder sie liegen in der Cloud-Sitzung bzw. im Claude-Projekt und wurden nicht lokal abgelegt.
- **Abweichung vom Auftrag:** keine. Das Verhalten bei fehlender Voraussetzung (blockiert melden, nichts ändern) steht so im Auftrag.
- **Hinweis:** Der Ordner `OneDrive\HTML\reling it` ist selbst ein Git-Klon (`.git` vorhanden). Eine `.bak`-Datei dort würde als nicht versionierte Datei auftauchen. Sie sollte in dessen `.gitignore` stehen oder neben dem Ordner liegen.

## Vorschläge und Ideen (Claude)

1. Bernd legt die Dateien ab und setzt R05 wieder auf `bereit`. Der nächste Zyklus übernimmt dann.
2. Die Szenenideen könnten dauerhaft in ein eigenes Verzeichnis im Repo wandern (zum Beispiel `docs/ideen/`, nicht öffentlich ausgeliefert). Dann hängt der Auftrag nicht mehr an einer lokalen OneDrive-Ablage, und jede Änderung hat einen Diff in Git.

Hygiene: 0 Remote-Branches in main gemergt (außer main), 5 offene PRs (#6 bis #10), davon 2 Drafts (#9, #10).

```yaml
Reifegrad: "Szenenideen-Dokument unverändert, Stand vor 06.11.2026"
Projektstatus: "R05 blockiert, Eingangsdateien fehlen"
Offene_Fragen:
  - "Wo liegen szenenideen-offene-konzepte.md und szenenideen-fortsetzung-2026-11.md?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind aus R10 übernommen und nicht belegt.
