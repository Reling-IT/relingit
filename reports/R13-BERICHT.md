# R13 Phase 2 – Bericht Löschung in den Papierkorb

- Ordner: `C:\Users\bmarn\OneDrive\HTML\reling it` (Branch `codex/fix-admin-password-recovery`)
- Datum: 2026-11-08, Löschzeit 05:38–05:39 (laut Papierkorb)
- Grundlage: `R13-LISTE.md` (Phase 1). Bernd hat L01–L17 am 08.11.2026 im Chat der Sitzung freigegeben, übermittelt durch die Koordinator-Session. **L18–L26 waren nicht freigegeben und wurden nicht angefasst** (archive\ftp-packages hat weiterhin 11 Pakete).
- Methode: ausschließlich `[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory/DeleteFile` mit `UIOption.OnlyErrorDialogs` und `RecycleOption.SendToRecycleBin`. Kein endgültiges Löschen, kein Git-Schreibbefehl, kein Commit.
- Skript: `C:\Users\bmarn\AppData\Local\Temp\claude\6631df4e69bbac2f\aa0f098d-a69a-4a60-a5a5-ca27c838f603\scratchpad\phase2.ps1` (ohne Schalter = Trockenlauf, mit `-Ausfuehren` = Papierkorb). Protokoll: `…\scratchpad\phase2-log.txt`.

## 1. Freigegebene Liste

L01–L17 aus R13-LISTE.md (Block A `archive\_aufgeraeumt-2026-11-06` und Block B `output\image`), zusammen 61 Dateien, 29 050 205 Byte.

## 2. Prüfungen vor dem Löschen (Trockenlauf)

Für jeden Pfad geprüft (Abbruch bei Verstoß, es gab keinen):
- Schutz-Regex (u. a. `.git`, `.github`, `assets\`, `podcast`, `ideen`, `archive\README.md`, `output\pdf`, `output\ftp`, `archive\ftp-packages`): kein Treffer.
- Vollständiger Pfad liegt innerhalb von `C:\Users\bmarn\OneDrive\HTML\reling it\`: ja, bei allen.
- `LinkType` des Eintrags und aller enthaltenen Einträge: bei keinem gesetzt (keine Junction, kein Symlink).
- `git ls-files -- <pfad>` und `git status --porcelain -- <pfad>`: jeweils leer.
- OneDrive-Platzhalter (Attribute Offline, RecallOnDataAccess oder RecallOnOpen): in L12–L14 gefunden, deshalb ausgelassen.

Ausgabe des Trockenlaufs (gekürzt auf die Kopfzeilen):

```
AUSGELASSEN (Platzhalter 4) L12 -> …\archive\_aufgeraeumt-2026-11-06\tmp\pdf-review
AUSGELASSEN (Platzhalter 3) L13 -> …\archive\_aufgeraeumt-2026-11-06\tmp\pdf-review-v124
AUSGELASSEN (Platzhalter 3) L14 -> …\archive\_aufgeraeumt-2026-11-06\tmp\pdfs
AUSGELASSEN (Bedingung)     L15 -> …\archive\_aufgeraeumt-2026-11-06\WAS-WURDE-VERSCHOBEN.txt
TROCKENLAUF L01 … L11, L16, L17  (17 Pfade)
SUMME 27767437 Byte in 50 Dateien
```

## 3. Gelöschte Einträge (im Papierkorb)

| Nr. | Pfad (relativ) | Dateien | Byte |
|---|---|---:|---:|
| L01 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-08-30-version-1-10\` | 2 | 1 644 662 |
| L02 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-v1.11\` | 2 | 1 645 986 |
| L03 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-input-v1.18\` | 4 | 3 424 697 |
| L04 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-v1.18\` | 2 | 3 311 828 |
| L05 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-input-v1.24\` | 2 | 3 351 862 |
| L06 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\2026-09-03-version-1-25-input\` | 2 | 3 351 862 |
| L07 | `archive\_aufgeraeumt-2026-11-06\alte-buchstaende\import-v1.24-2026-09-03\` | 2 | 3 351 862 |
| L08 | `archive\_aufgeraeumt-2026-11-06\flyer\flyer-before-links-2026-09-04\` | 1 | 20 786 |
| L09 | `archive\_aufgeraeumt-2026-11-06\flyer\flyer-portrait-linked-2026-09-04\` | 1 | 21 169 |
| L10 | `archive\_aufgeraeumt-2026-11-06\ftp-pakete-alt\ftp-packages-before-v1.29\` | 25 | 6 393 778 |
| L11 | `archive\_aufgeraeumt-2026-11-06\tmp\embedded-0.jpeg` … `embedded-4.jpeg` | 5 | 1 024 319 |
| L16 | `output\image\flyer-die-fahrt-zum-kunden.png` | 1 | 106 822 |
| L17 | `output\image\flyer-die-fahrt-zum-kunden-700x700.png` | 1 | 117 804 |
| **Summe** | 13 Einträge, 17 Papierkorb-Objekte | **50** | **27 767 437** |

Nach jedem Aufruf wurde mit `Test-Path` geprüft, dass der Pfad nicht mehr existiert. Es gab keinen Fehler.

## 4. Ausgelassene Einträge (freigegeben, aber nicht gelöscht)

| Nr. | Pfad | Byte | Grund |
|---|---|---:|---|
| L12 | `archive\_aufgeraeumt-2026-11-06\tmp\pdf-review\` | 585 712 | 4 OneDrive-Platzhalter (nur in der Cloud). Es ist nicht sicher, dass sie im lokalen Papierkorb landen (Vorgabe der Koordinator-Session) |
| L13 | `archive\_aufgeraeumt-2026-11-06\tmp\pdf-review-v124\` | 395 769 | 3 Platzhalter, wie L12 |
| L14 | `archive\_aufgeraeumt-2026-11-06\tmp\pdfs\` | 300 576 | 3 Platzhalter, wie L12 |
| L15 | `archive\_aufgeraeumt-2026-11-06\WAS-WURDE-VERSCHOBEN.txt` | 711 | Laut Liste nur sinnvoll, wenn L01–L14 vollständig gelöscht sind. Das ist wegen L12–L14 nicht der Fall, und die Datei beschreibt die verbliebenen Reste |

Summe ausgelassen: 1 282 768 Byte. Zurückgeblieben sind außerdem die nun leeren Elternordner `alte-buchstaende\`, `flyer\` und `ftp-pakete-alt\`. Sie standen nicht als eigene Einträge auf der Liste und wurden deshalb nicht entfernt.

## 5. git status vorher und nachher

Vorher (identisch mit dem Referenzstand aus R13-LISTE.md):

```
 M README.md
 M assets/css/styles.css
 M datenschutz.html
 M index.html
 M scripts/build-upload.ps1
 M scripts/ci-check.ps1
?? assets/audio/
?? assets/img/reling-it-podcast-cover.png
```

Nachher: zeilengleich. Der Abgleich `Compare-Object vorher nachher` ergab „git status identisch“.

## 6. Freigewordener Speicher

- Lokal aus dem Ordner entfernt: **27 767 437 Byte (26,48 MiB)** in 50 Dateien.
- Der Platz auf Laufwerk C: wird erst frei, wenn der Windows-Papierkorb geleert wird. Der Platz in OneDrive wird erst frei, wenn auch der OneDrive-Online-Papierkorb geleert wird. Beides wurde bewusst nicht getan.

## 7. Papierkorb-Beleg

Nur lesend mit `(New-Object -ComObject Shell.Application).Namespace(10).Items()`:

- Vorher: 0 Objekte. Nachher: **17 Objekte**, nämlich 10 Ordner (L01–L10) + 5 JPEG (L11) + 2 PNG (L16, L17). Das entspricht genau den gelöschten Pfaden.
- Alle Objekte haben den Ursprung im Ordner `C:\Users\bmarn\OneDrive\HTML\reling it\…` und die Löschzeit 08.11.2026 05:38–05:39. Beispiele:
  - `2026-08-30-version-1-10`, Ursprung `…\archive\_aufgeraeumt-2026-11-06\alte-buchstaende`
  - `ftp-packages-before-v1.29`, Ursprung `…\archive\_aufgeraeumt-2026-11-06\ftp-pakete-alt`
  - `embedded-0.jpeg` (341 864 Byte), Ursprung `…\archive\_aufgeraeumt-2026-11-06\tmp`
  - `flyer-die-fahrt-zum-kunden-700x700.png` (117 804 Byte), Ursprung `…\output\image`
- Wiederherstellung: im Explorer im Papierkorb „Wiederherstellen“ wählen, das Objekt kehrt an seinen Ursprung zurück.

## Vorschläge und Ideen (Claude)

- L12–L14 (1,28 MB, nur in der Cloud) kann Bernd am einfachsten selbst im Explorer oder auf onedrive.com löschen. Dort landen sie sicher im OneDrive-Online-Papierkorb. Danach können die leeren Elternordner und L15 in einem kleinen Nachauftrag mit entfernt werden.
- Den Windows-Papierkorb erst leeren, wenn ein paar Tage lang niemand etwas vermisst hat.
- Block D (L18–L26, 62 MiB) erst nach Entscheidung zu R34/R35 erneut vorlegen.
- Das Skript `phase2.ps1` mit Trockenlauf-Standard, Schutz-Regex und Platzhalter-Erkennung eignet sich als Vorlage für künftige Aufräumaufträge (ggf. ins Repo unter `scripts/` übernehmen, mit Pester-Test).

Hygiene: nur freigegebene Einträge gelöscht, nur in den Papierkorb; keine Git-Änderung (Status identisch); keine Links betreten; keine Platzhalter heruntergeladen oder gelöscht; keine Zugangsdaten oder Schlüsselmuster im Bericht; nichts committet.

```yaml
Reifegrad: R13 Phase 2 für L01–L17 durchgeführt (13 von 17 Einträgen gelöscht, 4 begründet ausgelassen)
Projektstatus: 27 767 437 Byte in den Papierkorb verschoben, git status unverändert, 17 Objekte im Papierkorb belegt
Offene_Fragen:
  - L12–L14 (Cloud-Platzhalter) manuell über OneDrive löschen oder per Nachauftrag?
  - Sollen L15 und die leeren Elternordner danach entfernt werden?
  - Block D (L18–L26) nach R34/R35 erneut vorlegen?
  - Wann darf der Papierkorb geleert werden?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schätzung
```
