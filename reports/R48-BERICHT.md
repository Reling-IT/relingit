# R48 – OneDrive-Aufräumen Phase 3b: L18 bis L24 und L26 in den Papierkorb

Stand: 2026-11-09, 05:16 bis 05:19 (Ortszeit, mit `date` geprüft). Ausgeführt vom Koordinator (Claude Code CLI). Freigabe Bernd 09.11.2026: L18, L19, L20, L21, L22, L23, L24, L26 frei; L25 und Paket 20260905-193924-327 bleiben; L12 bis L15 unberührt.

## Ergebnis
Erledigt. Alle acht freigegebenen Ordner hatten denselben Ordner-Hash wie in R45 und liegen jetzt im Windows-Papierkorb (nicht endgültig gelöscht). 225 Dateien, 58 459 633 Byte (55,75 MiB). Kein Kandidat ausgelassen, keine Cloud-Platzhalter.

## Verfahren
1. Platzhalter-Prüfung je Datei: `[int]$_.Attributes -band (0x400000 -bor 0x40000 -bor 0x1000)`; Treffer 0 in allen neun Ordnern, nichts hydriert.
2. Ordner-Hash nach der R45-Methode: Dateien `Sort-Object FullName`, Zeile `<SHA-256 groß>  <relativer Pfad mit \>`, Verbindung mit LF ohne Schluss-LF, UTF-8, SHA-256 im Speicher. Vergleich mit der Tabelle in reports/R45-BERICHT.md.
3. Nur bei Gleichheit und nur bei freigegebenen Ordnern: `[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory(<pfad>, 'OnlyErrorDialogs', 'SendToRecycleBin')`. Schutz-Regex im Skript zusätzlich: `^(20260905-193924-327|20260905-192045-642)$`.
4. Nachkontrolle: `Test-Path` je Ordner (weg), Liste des Ordners ftp-packages, Inhalt des Papierkorbs über `Shell.Application` (Namespace 10) mit Originalpfad.

Hinweis zur Durchführung: Der erste Trockenlauf (05:16) hat bei allen neun Ordnern einen anderen Hash ergeben, obwohl Dateianzahl und Bytes genau stimmten. Ursache: Ich hatte nach der fertigen Zeile sortiert, R45 nach dem vollen Pfad. Der R45-Agent hat seinen wörtlichen Befehl nachgereicht. Damit ergab der zweite Trockenlauf (05:17) Gleichheit für alle neun. Erst danach wurde verschoben. Im ersten Lauf wurde nichts verändert.

## Ergebnis je Kandidat

| Nr. | Ordner | Dateien | Byte | Ordner-Hash neu = R45 | Aktion |
|---|---|---:|---:|---|---|
| L18 | 20260904-070529-752 | 25 | 6 408 859 | ja (`B41A5DD6…F85D`) | in Papierkorb verschoben |
| L19 | 20260904-184557-555 | 50 | 12 826 353 | ja (`7CC70338…3A4E`) | in Papierkorb verschoben |
| L20 | 20260904-185157-249 | 25 | 6 525 556 | ja (`D6398136…2D54`) | in Papierkorb verschoben |
| L21 | 20260905-115310-734 | 25 | 6 528 710 | ja (`90359F45…33D6`) | in Papierkorb verschoben |
| L22 | 20260905-115912-216 | 25 | 6 536 015 | ja (`14880438…60DA`) | in Papierkorb verschoben |
| L23 | 20260905-121137-035 | 25 | 6 536 184 | ja (`13ED4D02…64E1`) | in Papierkorb verschoben |
| L24 | 20260905-123424-410 | 25 | 6 537 277 | ja (`85E5F873…1334`) | in Papierkorb verschoben |
| L25 | 20260905-192045-642 | 25 | 6 538 559 | ja (`B6EB7A44…B13E`) | geschützt, nicht angefasst (siehe R47) |
| L26 | 20260905-192135-924 | 25 | 6 560 679 | ja (`CCE92C0C…8A99`) | in Papierkorb verschoben |
| **Summe verschoben** | 8 Ordner | **225** | **58 459 633** | | |

## Stand danach
`archive\ftp-packages` enthält noch: `20260905-192045-642` (L25), `20260905-193924-327` (geschützt), `20260905-195306-580` (kein Kandidat dieser Phase, unberührt). L12 bis L15 nicht angefasst.

Papierkorb (Auszug `Shell.Application`): alle acht Ordnernamen mit Originalpfad `C:\Users\bmarn\OneDrive\HTML\reling it\archive\ftp-packages`. Wiederherstellen ist über den Papierkorb möglich. Speicher wird lokal erst nach Leeren des Papierkorbs frei, in OneDrive erst nach Leeren des Online-Papierkorbs.

## Vorschläge und Ideen (Claude)
- Die Ordner-Hash-Methode als kleines Skript ins Repo aufnehmen (z. B. `scripts/ordner-hash.ps1`, nur lesend), damit Inventur und Löschlauf denselben Code nutzen. Der heutige Fehlstart hätte sich so vermeiden lassen.
- In der Methodenbeschreibung künftiger Inventurberichte die Sortierung ausdrücklich nennen („Sort-Object FullName, kulturabhängig“).
- Nach der Entscheidung zu L25 (R47) den Papierkorb erst leeren, wenn Bernd die Webseite und das Release v1.38 geprüft hat; bis dahin ist alles wiederherstellbar.

Hygiene: keine Branch-Löschung, keine Remote-Änderung; offene PRs: Drafts #25, #26, #27; nur die acht freigegebenen Ordner bewegt, nichts endgültig gelöscht.

```yaml
Reifegrad: OneDrive-Archiv Phase 3b abgeschlossen; Verfahren mit Hash-Gegenprobe belegt
Projektstatus: 8 Ordner im Papierkorb (58459633 Byte), L25 wartet auf Freigabe nach R47
Offene_Fragen:
  - Freigabe L25 nach Sicherung per Bundle (R47)?
  - Wann darf der Papierkorb geleert werden?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schaetzung
```
