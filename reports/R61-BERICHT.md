---
id: R61
titel: Tor-Check G1 bis G7 gegen das Upload-Paket v1.38 (nur lesen)
status: erledigt
start: 2026-11-11T05:58+01:00
ende: 2026-11-11T06:10+01:00
branch: 'keiner (nur ops/reports)'
quelle_queue: 'origin/ops/queue 25506ea (Planer Claude, Commit nicht signiert)'
---

# R61 Bericht: Freigabetore v1.38 gegen das Upload-Paket

## Ergebnis

G8 kann noch nicht erteilt werden. Automatisch ist alles belegt, was sich belegen lässt. Es fehlt die Sichtung durch den Product Owner (G3 bis G5, 26 Punkte, alle leer).

| Tor | Stand 11.11. | Beleg |
|---|---|---|
| G1 Code | **erfüllt** | `freigabe-pruefen.ps1` auf main 8abe213 (06:04): ci-check Exit 0, node --check 6 Dateien, Pester 21/21; CI auf main grün (Lauf 42598348169) |
| G2 Kommentare | **erfüllt** (über R50) | Auf main nicht prüfbar („kein Feature-Branch“). Auf dem R50-Branch b1cbea1 bestanden (reports/R50-FREIGABE-v1.38.md); `git diff --quiet b1cbea1 8abe213` → gleicher Baum. Kopfkommentare heute: 8 Skripte bestanden |
| G3 Layout | **offen** | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 6 leer |
| G4 UI | **offen** | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 18 leer |
| G5 Inhalt | **offen** | SICHTUNG-v1.38.md: 0 Ja, 0 Nein, 2 leer |
| G6 Lokal | **nicht zutreffend** (Entscheidung Product Owner 09.11., Paket ohne Audio) | Skript auf main meldet „offen“ (0 von 4 MP3 lokal), weil R54 (Draft #31) noch nicht auf main ist; lokale Vorschau möglich: bestanden |
| G7 Git | **erfüllt** (über R50) | Auf main „nicht bestanden“, weil das Tor einen Feature-Branch vor dem Merge prüft. Auf b1cbea1 bestanden (PR #29 offen, kein Draft, Checks grün); gleicher Baum wie main; git status heute sauber |
| G8 Freigabe | **gesperrt** | Sperrgründe laut Skript: G3 bis G5 unvollständig; G2, G6, G7 nur wegen main-Lauf (siehe oben) |

## Paket gegen main

| Prüfung | Ergebnis |
|---|---|
| Datei | `output/ftp/relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, SHA-256 `76692313…984C`, 36 Einträge |
| Manifest | Version 1.38, 7. November 2026, erstellt 2026-11-10 05:21, ohne Audio |
| 35 Nutzdateien gegen den Arbeitsklon (main 8abe213, sauber) | 35 bytegleich, 0 abweichend |
| 35 Nutzdateien gegen `git show 8abe213:<Datei>` ohne CR | 0 abweichend; die Bytes unterscheiden sich nur durch CRLF (`core.autocrlf true`) |

## Befunde

| Nr | Fundstelle | Befund | Vorschlag | Schweregrad |
|---|---|---|---|---|
| F1 | queue/R61.yaml, Schritt 1 | `freigabe-pruefen.ps1` hat keinen Schalter `-Paket`; das Paket wurde deshalb getrennt gegen main geprüft (Tabelle oben) | R62 (`pruefe-paket.ps1`, läuft) deckt das ab; später in freigabe-pruefen einbinden | sollte |
| F2 | freigabe-pruefen.ps1 auf main | G2 und G7 sind auf main strukturell nicht bestehbar, G6 ohne R54 nicht „nicht zutreffend“; der Lauf auf main zeigt deshalb vier Sperrgründe, die keine sind | Wie im Tagesbericht 10.11. vorgeschlagen: auf main G2/G7 „nicht zutreffend“ mit Verweis auf den gemergten PR; #31 mergen | sollte |
| F3 | Sichtungslisten | Lokale Liste (Arbeitsklon, 09.11. 04:43, Commit 01defe7) und R50-Liste (b1cbea1) sind beide unausgefüllt; die lokale stammt von vor R50 | Die Sichtung auf main 8abe213 machen und in `reports/SICHTUNG-v1.38.md` (ops/reports) eintragen | muss (für G8) |
| F4 | Paketinhalt | Textdateien im Paket mit CRLF (aus dem Arbeitsklon); Inhalt sonst gleich main | Kein Handlungsbedarf für v1.38; bei R62 Vergleich zeilenendenneutral oder gegen den Arbeitsklon machen | kann |

## Empfehlung für G8

1. Vorschau auf main starten (`./scripts/vorschau.ps1`, für die PDF `-Pdf`) und die 26 Punkte in `reports/SICHTUNG-v1.38.md` abhaken (G3 6, G4 18, G5 2).
2. G6 gilt als nicht zutreffend (Paket ohne Audio, Entscheidung 09.11.); G2 und G7 gelten über den R50-Lauf auf identischem Baum.
3. Sind alle 26 Punkte Ja, kann G8 für das Paket `76692313…984C` erteilt werden; danach Upload nach UPLOAD-CHECKLISTE-v1.38.md und R09.

## Vorschläge und Ideen (Claude)

- Die Sichtung in einer kurzen Sitzung mit Vorschau-Link und Liste nebeneinander erledigen; ich kann die Liste vorher mit den Seitenadressen der Vorschau ergänzen.
- `freigabe-pruefen.ps1 -Paket <zip>`: Hash, Eintragszahl und Vergleich mit dem Baum des Commits in den Freigabebericht übernehmen (nach R62).

Hygiene: gemergte Remote-Branches 0; offene PRs 8 (#25 bis #28, #30 bis #33), alle Draft.

```yaml
Reifegrad: Paket v1.38 entspricht main 8abe213; G1, G2, G7 belegt, G6 nicht zutreffend; G3 bis G5 ungesichtet
Projektstatus: G8 gesperrt bis zur Sichtung durch den Product Owner; danach Upload und R09
Offene_Fragen:
  - Wann findet die Sichtung G3 bis G5 statt (26 Punkte)?
  - Sollen G2 und G7 auf main kuenftig als nicht zutreffend gelten (Skriptaenderung)?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schaetzung
```
