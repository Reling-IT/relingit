---
id: R55
titel: 'scripts/ordner-hash.ps1: Ordner-Hash nur lesend, mit Test'
status: erledigt (Draft-PR offen, CI grün, nicht gemergt)
datum: 2026-11-10
zeit: 06:16:28 bis 06:38:13 (Ortszeit, mit date geprüft)
branch: auftrag-R55-ordner-hash (von origin/main 8abe213)
pr: https://github.com/Reling-IT/relingit/pull/30
commit: 586404f91ca7e2dd775d3ac56af6c323a2e8fed3 (signiert, Signatur „G“)
ci: grün (Website prüfen, Lauf 42762861276)
---

## Ergebnis
Erledigt. `scripts/ordner-hash.ps1` berechnet den Ordner-Hash nach der Methode R45/R48. Das Skript liest nur. Es schreibt, verschiebt und löscht nichts, und es hydriert keine Platzhalter. Mit `-Erwartet` vergleicht es das Ergebnis mit einem Referenz-Hash. Damit können Inventur und Löschlauf künftig denselben Code nutzen. Der Fehlstart aus R48 (falsche Sortierung) ist dann ausgeschlossen.

Exit-Codes:
- 0: Hash berechnet (und gleich `-Erwartet`)
- 1: Abweichung von `-Erwartet`
- 2: Abbruch ohne Hash (Ordner fehlt, Ordner leer oder Cloud-Platzhalter)

## Änderungen
| Datei | Inhalt |
|---|---|
| scripts/ordner-hash.ps1 | neu. Kopfkommentar mit Zweck, Methode, Eingabe und Ausgabe. Parameter `-Pfad`, `-Erwartet`, `-Sortierung Kultur\|Ordinal` (Standard Kultur), `-Kultur` (Standard de-DE), `-Zeilen` |
| tests/ordner-hash.Tests.ps1 | neu, 5 Tests mit einem kleinen Testordner im TestDrive |
| docs/ABLAUF.md | eigener Abschnitt „Ordner-Hash für Archivpakete (scripts/ordner-hash.ps1, Auftrag R55)“ vor der Belegtabelle. Diagramme und Belegtabelle sind nicht geändert, wegen R56 |

## Methode
1. Alle Dateien unter `-Pfad` werden erfasst, rekursiv und mit `-Force`, also auch versteckte. Das Skript rekursiert selbst: Ein Unterordner wird erst gelesen, nachdem seine Attribute geprüft sind.
2. **Cloud-Platzhalter:** Vor dem ersten Lesen eines Inhalts liest das Skript nur `[int]Attributes -band (0x400000 -bor 0x40000 -bor 0x1000)`. Das sind RecallOnDataAccess, RecallOnOpen und Offline, dieselbe Maske wie in R45/R48. Bei einem Treffer listet es die Einträge mit ihren Attributen und bricht mit Exit 2 ab, ohne Hash. Es wird nichts hydriert. ReparsePoint 0x400 und Unpinned allein gelten nicht als Platzhalter (wie R45).
3. **Sortierung:** `Sort-Object FullName -Culture de-DE`. Das ist kulturabhängig und ohne Beachtung der Groß-/Kleinschreibung, der Standard von Sort-Object. Ordinal (`[string]::CompareOrdinal`) gibt es nur zum Vergleich.
4. Je Datei eine Zeile: `<SHA-256 groß>` + zwei Leerzeichen + Pfad relativ zu `-Pfad` mit `\`.
5. Die Zeilen werden mit LF verbunden, ohne LF am Ende, als UTF-8 ohne BOM kodiert und mit SHA-256 gehasht. Ausgabe in Großbuchstaben ohne Bindestriche.

### Sortierentscheidung: kulturabhängig, nicht ordinal (Beleg)
R45 (Methode, Punkt 4) nennt „Sort-Object FullName (PowerShell 7, kulturabhängig, nicht ordinal)“. Gegenprobe vor der Implementierung mit Inline-Befehlen, nur lesend, am noch vorhandenen Paket `20260905-195306-580`. Umgebung: pwsh 7.6.9, Kultur de-DE, 25 Dateien, 0 Platzhalter.

| Sortierung | Ordner-Hash |
|---|---|
| `Sort-Object FullName` (de-DE, Standard) | `D80F6E06D3C4EEAC3E87E07C89E8B1A32E0A5F00FDE39B1D996B4DE79E106618` (= R49) |
| `Sort-Object FullName -Culture ''` (invariant) | `D80F6E06…6618` (gleich) |
| `Sort-Object FullName -Culture en-US` | `D80F6E06…6618` (gleich) |
| ordinal (`[string]::CompareOrdinal`) | `9E518AC9E41DA7AA9342577462425F24D0CAEC10FA7BA8781C9938183C5F0EA4` (abweichend) |

Ursache der Abweichung: Ordinal steht `…\UPLOAD-MANIFEST.txt` (U = 0x55) direkt nach `.htaccess` und vor `admin.html` (a = 0x61). Kulturabhängig steht es am Ende. Die ZIP-Datei steht in beiden Verfahren vor dem gleichnamigen Ordner.

Gewählt ist deshalb die kulturabhängige Sortierung. Damit sie nicht von der Spracheinstellung des Rechners abhängt, ist die Kultur fest auf de-DE gesetzt, die Kultur der Inventur R45.

## Reproduktion eines Referenz-Hashes
- R45 enthält volle Ordner-Hashes nur für L18 bis L26. Diese Ordner liegen seit R48 im Papierkorb. Sie wurden nicht angefasst und nicht wiederhergestellt.
- Für ein noch vorhandenes Paket belegt einen vollen Hash nur R49 (Zusatz-Inventur, Methode R45/R48): `20260905-195306-580` → `D80F6E06…6618`.
- Für `20260905-193924-327` steht in R45, R49 und allen anderen Berichten auf ops/reports kein Ordner-Hash. Geprüft mit `git grep -nE "[0-9A-F]{64}" origin/ops/reports -- reports`.

```
PS C:\dev\wt-r55> ./scripts/ordner-hash.ps1 -Pfad 'C:\Users\bmarn\OneDrive\HTML\reling it\archive\ftp-packages\20260905-195306-580' -Erwartet D80F6E06D3C4EEAC3E87E07C89E8B1A32E0A5F00FDE39B1D996B4DE79E106618
Ordner: C:\Users\bmarn\OneDrive\HTML\reling it\archive\ftp-packages\20260905-195306-580
Dateien: 25, Byte: 6561975
Cloud-Platzhalter: 0
Sortierung: Kultur de-DE (Sort-Object FullName -Culture de-DE, ohne Groß-/Kleinschreibung), Methode R45
Ordner-Hash: D80F6E06D3C4EEAC3E87E07C89E8B1A32E0A5F00FDE39B1D996B4DE79E106618
Vergleich: gleich -Erwartet
exit 0

PS> … dasselbe mit -Sortierung Ordinal
Ordner-Hash: 9E518AC9E41DA7AA9342577462425F24D0CAEC10FA7BA8781C9938183C5F0EA4
Vergleich: ABWEICHUNG, erwartet D80F6E06D3C4EEAC3E87E07C89E8B1A32E0A5F00FDE39B1D996B4DE79E106618
exit 1
```

Die Dateianzahl (25) und die Bytezahl (6 561 975) stimmen mit dem Steckbrief in R49 überein.

Zusätzlich, ohne Referenz und nur als neuer Wert für eine spätere Gegenprobe: `20260905-193924-327` hat 25 Dateien, 6 560 675 Byte, 0 Platzhalter und den Ordner-Hash `2C946BEC94974CD7B4ACE1C5C67A26EE61B9B3329A6F6E517F383D19431BD7C9`.

## Prüfbelege (Worktree C:\dev\wt-r55)
```
PS> git diff --check                                  -> exit 0
PS> ./scripts/ci-check.ps1
Hinweis: 4 von 4 Podcast-MP3 liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). ...
OK: 11 HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft.
ci-check exit 0
PS> Invoke-Pester -Path tests/ordner-hash.Tests.ps1 -PassThru -Quiet   (Pester 3.4.0 unter pwsh 7.6.9)
Passed 5 Failed 0 Skipped 0 Total 5
Passed  berechnet den Hash nach der Methode R45 (kulturabhängige Sortierung, LF ohne Schluss-LF)
Passed  ordinal sortiert ergibt einen anderen Hash (Fehlstart R48) und meldet die Abweichung mit Exit 1
Passed  schreibt, verschiebt und löscht nichts im Ordner
Passed  bricht bei einem Cloud-Platzhalter ab, ohne zu hashen (Attribut Offline)
Passed  bricht bei fehlendem oder leerem Ordner mit Exit 2 ab
PS> Invoke-Pester -Path tests -PassThru -Quiet
Passed 26 Failed 0 Skipped 0 Total 26      (21 bisherige + 5 neue)
freigabe-pruefen.ps1 -OhnePester -OhneGh: G2 „Kopfkommentar je Skript: bestanden, 9 Skripte unter scripts/“
git diff origin/main HEAD | grep -ciE '<CI-Suchmuster>'  -> 0
gh pr checks 30 -> Website prüfen: pass (Lauf 42762861276, headSha 586404f91ca7e2dd775d3ac56af6c323a2e8fed3)
git merge-tree --write-tree gegen origin/auftrag-R49-aufbewahrung (#28) und origin/auftrag-R07-anhang-seite (#26) -> je exit 0, kein Konflikt
```

Hinweise zu den Tests:
- Nach dem Pester-Lauf steht `$LASTEXITCODE` der Shell auf 1 (wie in R49 beschrieben). Pester selbst meldet 0 Fehler.
- Der Erwartungswert in Test 1 entsteht unabhängig vom Skript, aus einer von Hand festgelegten Reihenfolge.
- Der Platzhalter-Test setzt im TestDrive das Attribut Offline. RecallOnDataAccess lässt sich nicht künstlich setzen. Unter Nicht-Windows wird der Test übersprungen.
- Die Tests starten das Skript mit `pwsh -File`, nicht über `Invoke-MiniSkript`. Grund: `pwsh -Command` liefert nur 0 oder 1 zurück, Exit 2 käme also nicht an. TestHelfer.ps1 ist deshalb unverändert, wegen R56.
- Die Pester-Tests laufen weiter nur lokal. CI führt sie nicht aus.

## PR
https://github.com/Reling-IT/relingit/pull/30 (Draft, Basis main, CI grün, Head 586404f)

## Abweichungen
- Der Bericht wurde vom Agenten an den Koordinator übergeben; abgelegt hat ihn der Koordinator.
- Ein Referenz-Hash aus R45 selbst ließ sich nicht reproduzieren, weil L18 bis L26 im Papierkorb liegen. Reproduziert ist der R49-Hash, der mit derselben Methode berechnet wurde.
- README.md wurde nicht geändert (Projektstruktur, Liste der Tests), um Konflikte mit #26 und R56 zu vermeiden.

## Vorschläge und Ideen (Claude)
- Ein künftiger Löschlauf (Nachfolger von R13 `phase2.ps1`) sollte `scripts/ordner-hash.ps1 -Erwartet <Hash>` aufrufen und nur bei Exit 0 verschieben. Exit 1 und Exit 2 bedeuten: nicht anfassen.
- Den neuen Wert für `20260905-193924-327` (`2C946BEC…D7C9`) bei der nächsten Inventur in einen Bericht übernehmen, damit es für das geschützte Paket einen Referenz-Hash gibt.
- Nach dem Merge in README.md, Abschnitt Projektstruktur und Tests-Zeile, `ordner-hash.ps1` ergänzen und im ABLAUF-Diagramm den Knoten `scripts` erweitern. Das wäre ein kleiner Folgeauftrag nach R56 und #26.
- Optional einen Schalter `-OhneVerknuepfungen` oder eine Meldung für LinkType-Einträge einbauen. R45 hat Links geprüft. Das Skript folgt Ordner-Verknüpfungen heute ungeprüft. Im Archiv gab es bisher keine.
- Werden die Pester-Tests später in CI aufgenommen, müsste der Platzhalter-Test dort übersprungen werden (ubuntu, kein Offline-Attribut). Das ist schon über `-Skip` vorbereitet.

Hygiene: gemergte Remote-Branches außer main: keine. Offene PRs: Drafts #25, #26, #27, #28 und neu #30. Nichts gemergt, getaggt, hochgeladen oder gelöscht, kein Force-Push. Im OneDrive-Archiv wurde nur gelesen, nichts hydriert, der Papierkorb blieb unberührt. Worktree C:\dev\wt-r55 entfernt (sauber, gepusht). Keine Zugangsdaten oder Schlüsselmuster im Diff oder Bericht.

```yaml
Reifegrad: R55 umgesetzt als Draft-PR #30; Skript nur lesend, 5 neue Tests grün, CI grün, Referenz-Hash aus R49 reproduziert
Projektstatus: Ordner-Hash als wiederverwendbares Skript bereit; wirksam nach Merge (Freigabe Bernd); kulturabhängige Sortierung (de-DE) festgelegt und belegt
Offene_Fragen:
  - Soll der neue Ordner-Hash von 20260905-193924-327 (2C946BEC…D7C9) als Referenz in einen Bericht übernommen werden?
  - Soll ein künftiger Löschlauf verbindlich ordner-hash.ps1 -Erwartet nutzen (Folgeauftrag zu R13 phase2.ps1)?
  - README-Ergänzung (Projektstruktur, Tests) als Folgeauftrag nach R56 und #26?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 1
  Hinweis: unbelegte Schaetzung
```
