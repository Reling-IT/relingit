---
titel: 'Upload-Checkliste v1.39 (nur lesen, Bericht)'
status: erledigt
datum: 2026-11-15
basis: origin/main a1b11a8 (Merge #37, inhaltsgleich mit Head a470a41; `git diff a470a41 a1b11a8` ohne Unterschied)
art: lesen – kein Commit im Code, kein Upload, kein FTP, kein Tag, keine Live-Abfrage
vorlage: reports/UPLOAD-CHECKLISTE-v1.38.md (R51)
---

# Upload-Checkliste v1.39

## Ziel

Der Product Owner lädt v1.39 hoch, ohne etwas raten zu müssen. Je Datei: Zielweg, SHA-256, ob sie sich gegenüber v1.37 und v1.38 geändert hat. Dazu Reihenfolge, Admin-Bereich, Handschritte, Rückfall und Kurzabnahme. Freigabe G1 bis G8 liegt vor (`SICHTUNG-v1.39.md`, PR-Kommentar auf #37). Welcher Stand live ist, wurde nicht geprüft (siehe „Offene Fragen“).

## Das richtige Paket

| | Wert |
|---|---|
| Datei | `C:\dev\wt\relingit\r60\output\ftp\relingit-upload-v1.39-2026-11-15-ohne-audio.zip` |
| SHA-256 | **`6E48827B3C69CC57C7CF20531327EAC7645E0A62587F16C469189205C75C1B98`** (gleich G8-Freigabe) |
| Größe / Einträge | 4 727 966 Byte, **39 Einträge** (38 Nutzdateien + `UPLOAD-MANIFEST.txt`) |
| Manifest | Version 1.39, Veröffentlichungsdatum 15. November 2026, erstellt 2026-11-15 17:10:52 +01:00, „Ohne Audio“; 38 Prüfsummen gleich dem ZIP-Inhalt (`pruefe-paket.ps1`, Exit 0) |
| entpackter Ordner | daneben, `…\output\ftp\relingit-upload-v1.39-2026-11-15-ohne-audio\` |

Vergleichspakete: v1.38 `archive\ftp-packages\20261109-060211-000\relingit-upload-v1.38-2026-11-07-ohne-audio.zip` (SHA-256 `A906DDF4…205A`, inhaltsgleich mit dem freigegebenen `76692313…984C`); v1.37 `archive\ftp-packages\20261110-052115-235\relingit-upload-v1.37-2026-09-05.zip` (SHA-256 `A710D248…747A`), beide im Arbeitsklon `C:\dev\relingit`.

## 1. Tabelle der 39 Einträge

Alle Paketdateien gehen per FTP nach `relingit/` mit derselben Ordnerstruktur (`docs/DOMAINFACTORY-DEPLOYMENT.md`). Prüfsummen selbst berechnet je ZIP-Eintrag.

| Nr. | Datei | SHA-256 | Byte | ggü. v1.37 | ggü. v1.38 |
|---|---|---|---|---|---|
| 1 | `assets/css/legal.css` | `926068456D3F01F5FF1F27B69866AF74988560D45F19CCCC738EFC8EA472EFEF` | 1 299 | nein | nein |
| 2 | `assets/css/styles.css` | `AECECABB20129BE1B65B126A694FE83A51F10762E538A3D2E98E8BB57C1D8607` | 14 568 | **ja** | **ja** |
| 3 | `assets/fonts/Fraunces-OFL.txt` | `BDF4C22802EAF804F998195871C6B8938AAC2AC14B2D78A8BD66A6F1ECED833B` | 4 391 | **neu** | nein |
| 4 | `assets/fonts/Fraunces-Variable.woff2` | `E6638EA113D0027354A08F957A4068975C8066395A0D0F7BB7861F6409621BE3` | 205 500 | **neu** | nein |
| 5 | `assets/fonts/HERKUNFT.txt` | `141EF6B73695F60FBDF45F7FEB0C4E3A61E35A76282B35533EF7EDA97F114332` | 2 754 | **neu** | nein |
| 6 | `assets/fonts/IBMPlexMono-Italic.woff2` | `2024BF2B08027DCD6D09091385756E327744BBE26B782C411381DFFC40FFC622` | 53 408 | **neu** | nein |
| 7 | `assets/fonts/IBMPlexMono-Medium.woff2` | `33FAF307FA6031FB4062276D7320A6D632DE890CBB347576FD80CFA01077BC25` | 50 400 | **neu** | nein |
| 8 | `assets/fonts/IBMPlexMono-OFL.txt` | `7E6B2818EDBD8F6A01AE80641CC8F16A51080D08FB4E532BE3A0B6F74ADB07DA` | 4 456 | **neu** | nein |
| 9 | `assets/fonts/IBMPlexMono-Regular.woff2` | `BA204497F16B6D334CEE9D1E963A831B73E3A56E1D6300A8489D18DF7214B350` | 49 248 | **neu** | nein |
| 10 | `assets/fonts/WorkSans-Bold.woff2` | `B8426840585AB1093CE262D35AA03291F59719C38605D0B6ECBE2032924917A9` | 76 284 | **neu** | nein |
| 11 | `assets/fonts/WorkSans-Italic.woff2` | `21F75B620A355FC62E286EA0570E0A25186DA16D1973C2B7E9C0239BF1408169` | 66 376 | **neu** | nein |
| 12 | `assets/fonts/WorkSans-OFL.txt` | `749ACA05078664CE682DCE1B1B10096AC397CB088C1A6DF4E1BB56F0092A9272` | 4 396 | **neu** | nein |
| 13 | `assets/fonts/WorkSans-Regular.woff2` | `495EC293F0E79AD3D77BCFCF4C4ADFFB2FE8BD993C6C3800E4528850A3634108` | 71 988 | **neu** | nein |
| 14 | `assets/img/favicon.png` | `E0D207AE2B5DA813D5B0CEA3F1320B19C06BB98AD1DA71514390008D4E2DC772` | 6 752 | nein | nein |
| 15 | `assets/img/reling-it-logo.svg` | `38820DB3A92BF698759B9A0AF1803C273D697BE12906BC15E46D2867FA3A5126` | 8 423 | nein | nein |
| 16 | `assets/img/reling-it-podcast-cover.png` | `6068294EA84E215E20D265D949B32D01F024CD4D9A7CBFEE832B9D4BE28D9EDD` | 1 005 947 | **neu** im Paket (laut R17 live schon gleich) | nein |
| 17 | `assets/img/avatare/lumen.svg` | `3CEA17141293FBBF6B05AEF158B2D63887965901CEC8D4F3F4D7794DB3FA8F29` | 2 433 | **neu** | **neu** |
| 18 | `assets/img/avatare/navis.svg` | `ECBB7D8A7011B6DEB591DDE8B064119DB5B28987746CDAF56C6AFE433F64F53F` | 4 087 | **neu** | **neu** |
| 19 | `assets/js/admin.js` | `36DFB2F5E3942473AD4FD58E34663DAD59ACD20689013792E124D985ED4D9A81` | 18 682 | nein | nein |
| 20 | `assets/js/app.js` | `6DB1C65EB198611EBEEB3C2B19ECD486772D5601E076DBED34CBDD998BE43AAD` | 4 183 | **ja** | **ja** |
| 21 | `assets/js/handout-viewer.js` | `8DAADC660CAE0C61DD7E5E7661FD91EAD08DB59DD649CCA7531D4A8323E5C965` | 4 040 | **ja** | nein |
| 22 | `assets/js/pdf-viewer.js` | `F00DBB0F1DD02DD7E3D7E9E56E655923AA0DB9462F344B2F0AC0B9409C92E265` | 668 | nein | nein |
| 23 | `assets/js/story-viewer.js` | `A0D7558BF71AF9E242EA0CD18A9176633EA62C5D3D7FAAF852481305FCF96CCC` | 13 822 | **ja** | **ja** |
| 24 | `assets/js/supabase-config.js` | `7A6B95FE0A046254ABBBC1FE69FA82D4DADBA478AD218C02BA9CF4905D52F57F` | 246 | nein | nein |
| 25 | `story/current/fahrt-zum-kunden.html` | `2DD79803A900448C46BD6AF62F559D35551BB7422B38BBA380872A6D7BE9CA3A` | 1 624 124 | **ja** | **ja** |
| 26 | `story/current/geschichte.pdf` | `6713E7B629C883B48420A581F6701AE436F8E4EC962F860B698B4837924AF8FC` | 2 077 741 | **ja** | **ja** |
| 27 | `story/current/workshop-handout.html` | `7F845C24986DFD50647C8E6B9EAF538A5DDEC8FD373DB41F5A4ADE5627FC7D2D` | 7 187 | **ja** | **ja** |
| 28 | `story/current/workshop-handout.pdf` | `6D574EF8C6E26D295F1A6BFD43A2856FF37C6E4AD1F7CCD5C357F1F7C0001846` | 217 069 | **ja** | **ja** |
| 29 | `.htaccess` | `2D20FD1BFDA1008048F9E0E6DD6AD503F3E42B579444E5ADB91A68F5268A3468` | 939 | nein | nein |
| 30 | `admin.html` | `DEF5249F3DE1883C1A334DF67454F5FC7A8E61442EB276C0B15740F6FF1DB410` | 6 426 | nein | nein |
| 31 | `anhang.html` | `854774C9397ACD6011D1751FD27C185296D401174493A51E2F0D3DCD9E65093C` | 2 561 | **neu** | **neu** |
| 32 | `datenschutz.html` | `2F9146FB37348BC81CE13C5CCC8D889F808273EDCD0ED09119B7F594F23D10BC` | 6 861 | **ja** (laut R17 live schon gleich) | nein |
| 33 | `handout-pdf.html` | `D4B3EBB2764A95840160A45413467AF7CC00F80B933E331BE10D0F8E88ADF61B` | 1 392 | nein | nein |
| 34 | `handout.html` | `59A52429054C4C82E90F1D8EDA5A8BD21D6A4D2DB9AF0D6CCFFC1361DB5A7F3A` | 2 023 | **ja** | **ja** |
| 35 | `impressum.html` | `3D783AA8B8C3C3877FB5B417AEA4AACA94DA8A540B7952878DF0057118063554` | 1 886 | nein | nein |
| 36 | `index.html` | `68D6C2249566E77C72EF389CC8627CDCA24FB51AFAB84A288E424CCA03033022` | 12 635 | **ja** | **ja** |
| 37 | `lesen.html` | `578C1DD3F438E747DA2DC4DA7E8BB129812CDEEA4E668D9D780B713864D890DA` | 2 209 | **ja** | **ja** |
| 38 | `pdf.html` | `1771E0255E51C07AA225808474348FF2C603748037528C1561A0BF1C214FF507` | 1 387 | nein | nein |
| 39 | `UPLOAD-MANIFEST.txt` | `8DC4B5412E646F9CBF4BDCD8F5F5C8FAD05AC33C9793530C5CE9B054F69BFFCA` | 3 776 | – | – |

Zählung der 38 Nutzdateien: gegenüber **v1.38** 10 geändert, 3 neu, 25 unverändert, 0 entfallen; gegenüber **v1.37** 12 geändert, 15 neu, 11 unverändert, 0 entfallen.

**Empfehlung:** das ganze Paket ohne Manifest übertragen und überschreiben. Weil nicht belegt ist, ob live v1.37 oder v1.38 steht, deckt nur das ganze Paket beide Fälle ab.

## 2. Reihenfolge

1. **Vorab lokal:** ZIP-Hash prüfen: `Get-FileHash C:\dev\wt\relingit\r60\output\ftp\relingit-upload-v1.39-2026-11-15-ohne-audio.zip` muss `6E48827B…1B98` ergeben. Optional `./scripts/pruefe-podcast-live.ps1` (erwartet 4× OK).
2. **Admin-Bereich zuerst** (Abschnitt 3), **mit Handout**.
3. **FTP, Block 1 – neue und abhängige Dateien:** `assets/fonts/` (11), `assets/img/` (ganzer Ordner, auch `avatare/`), `assets/css/styles.css`.
4. **FTP, Block 2 – in einem Durchgang:** `index.html` mit `assets/js/app.js`, dazu `story-viewer.js` und `handout-viewer.js`.
5. **FTP, Block 3:** `lesen.html`, `anhang.html` (neu), `handout.html`, `datenschutz.html`.
6. **FTP, Block 4:** `story/current/` (Buch HTML und PDF, Handout HTML und PDF, Rückfallfassung).
7. **FTP, Block 5 – unverändert, zur Sicherheit überschreiben:** `.htaccess`, `admin.html`, `impressum.html`, `pdf.html`, `handout-pdf.html`, `legal.css`, `admin.js`, `pdf-viewer.js`, `supabase-config.js`, `favicon.png`, `reling-it-logo.svg`.
8. Kurzabnahme (Abschnitt 6), danach R09.

## 3. Admin-Bereich (Standardweg)

| Feld | Eintrag |
|---|---|
| Version | **1.39** |
| Angezeigtes Datum | **15. November 2026** |
| Seitenzahl | **80** |
| HTML-Lesefassung | `C:\dev\relingit\source\fahrt-zum-kunden.html` – SHA-256 `2DD79803…CA3A`, 1 624 124 Byte, gleich Paket Nr. 25 |
| PDF | `C:\dev\relingit\source\Die-Fahrt-zum-Kunden.pdf` – SHA-256 `6713E7B6…F8FC`, 2 077 741 Byte, `pdfinfo` 80 Seiten, gleich Paket Nr. 26 |
| Handout | **auswählen, als Paar:** `story/current/workshop-handout.html` (Nr. 27) und `story/current/workshop-handout.pdf` (Nr. 28) aus dem Arbeitsklon `C:\dev\relingit` |

**Achtung Handout:** Die letzte Ausgabe von `publish-release.ps1` meldet „Handout geändert: nein“, weil das Skript nur mit dem vorigen Commit vergleicht. Gegenüber v1.37 und v1.38 ist das Handout geändert (Datum „Ende November 2026“, R65). Deshalb im Admin-Bereich auswählen (`docs/NEUE-GESCHICHTE.md`, Schritt 5; `docs/DOMAINFACTORY-DEPLOYMENT.md`, Schritt 6).

Handschritte: `admin.html` öffnen, mit dem Administratorkonto und Authenticator-Code anmelden, Werte eintragen, die vier Dateien wählen, veröffentlichen.

## 4. Nicht hochladen, nicht löschen

- **Live-MP3 unter `relingit/assets/audio/` nicht löschen**; keine Synchronisation mit „Löschen auf dem Ziel“, nur hochladen und überschreiben.
- `UPLOAD-MANIFEST.txt` nicht übertragen.
- Nichts außerhalb des Pakets (kein `archive/`, `source/`, `docs/`, `scripts/`, `tests/`, `.git`).
- Keine Dateien auf dem Server löschen.
- **Ältere Pakete nicht verwenden:** `relingit-upload-v1.39-2026-11-14-ohne-audio.zip` (`67E30FE4…E00E`) und `…-2026-11-14-sichtung1-ohne-audio.zip` (`EB53AEA1…EB46`) in `r60\archive\ftp-packages\` sind durch die Korrekturen der Sichtung überholt; ebenso `relingit-upload-v1.39-2026-11-09-ohne-audio.zip` (entfernt mit dem Worktree `wt-r06`). Nur `6E48827B…1B98` ist richtig.

## 5. Handschritte und Hinweise

- Im FTP-Programm versteckte Dateien anzeigen, damit `.htaccess` mitkommt.
- Header-Prüfung nach dem Upload wie in `UPLOAD-CHECKLISTE-v1.38.md`, Abschnitt 5 (`.htaccess` unverändert).
- In einem privaten Browserfenster prüfen; notfalls ohne Cache neu laden.

## 6. Kurzabnahme nach dem Upload (Erwartungen, nicht live geprüft)

| Nr. | Adresse | erwartet |
|---|---|---|
| 1 | Startseite `/relingit/` | „Version 1.39“, „80 Seiten · … · aktualisiert am 15. November 2026“; Bildmarken Navis und Lumen im Kopf und unter „Worum es geht“; Begleitmaterial „Ende November 2026“ |
| 2 | `/relingit/lesen.html` | „Version 1.39 · 15. November 2026“; Inhaltsverzeichnis mit „Die neun Standards hinter Navis und Lumen“ |
| 3 | `/relingit/anhang.html` (neu) | Anhang lädt, Box „Die neun Standards“ mit IAM und REST |
| 4 | `/relingit/pdf.html` | Deckblatt „Version 1.39“, „15.11.2026“, 80 Seiten |
| 5 | `/relingit/handout.html` | Kopf „Workshop-Handout · Ende November 2026“ |
| 6 | `/relingit/assets/img/avatare/navis.svg` | HTTP 200 |

Zusatz: `./scripts/pruefe-podcast-live.ps1` weiter 4× OK. Danach R09 (Live-Prüfung je Datei) und Tag v1.39 auf a1b11a8.

## 7. Rückfall (nur beschrieben)

- Zurück auf den vorher live laufenden Stand: v1.38-Paket `A906DDF4…205A` oder v1.37-Paket `A710D248…747A` (siehe oben), je nachdem, was live war. Im Admin-Bereich die Werte des Rückfallstands eintragen; Einzelheiten zu v1.37 in `UPLOAD-CHECKLISTE-v1.38.md`, Abschnitt 6.
- Neue Dateien (`anhang.html`, `assets/img/avatare/`, bei v1.37 auch `assets/fonts/`) können stehen bleiben; die alten Seiten verweisen nicht darauf.
- `index.html` und `app.js` immer gemeinsam zurückspielen. Live-MP3 nicht löschen.

## Offene Fragen und Abweichungen

- **Live-Stand unklar:** Laut Berichten wurde v1.38 freigegeben, ein Upload ist in den Berichten nicht belegt. Deshalb Vergleich gegen v1.37 und v1.38 und Empfehlung „ganzes Paket“.
- **Handout:** siehe Abschnitt 3; ohne Auswahl im Admin-Bereich liefert Supabase weiter das alte Handout.
- **Paketablage:** Das Paket liegt im Worktree `r60` (Branch auf GitHub gelöscht). `r60` erst nach dem Upload entfernen.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- `publish-release.ps1` „Handout geändert“ und „FTP-Upload nötig“ gegen den letzten veröffentlichten Stand (Tag oder Paket) vergleichen lassen statt gegen den vorigen Commit (wie in R60 vorgeschlagen, Schalter `-VergleichMit`).
- Nach dem Upload den Paket-Hash im R09-Bericht festhalten; dann ist der Live-Stand künftig belegt.
- Die Tabelle dieser Checkliste per Skript aus ZIP und Vergleichspaketen erzeugen (heute so entstanden), damit sie bei jedem Release gleich aussieht.

## Nachtrag 16.11.2026, 05:15: Paket mit Trailer (PR #38) und Startseiten-Link (PR #39)

Ersetzt den Nachtrag vom 15.11. (Paket `EE872316…1F48`, **überholt**, verschoben nach `C:\dev\wtelingit	railerrchivetp-packages61116-051344\`; nicht verwenden).

Buchfassung, Version, Datum, Seitenzahl und Handout bleiben gleich; Abschnitt 3 (Admin-Bereich) gilt unverändert.

| | Wert |
|---|---|
| Datei | `C:\dev\wtelingit\paket-v139\outputtpelingit-upload-v1.39-2026-11-15-trailer-ohne-audio.zip` |
| SHA-256 | **`CDF23C5FFFE56850DC41791B3439F3BA4FC79A9B21E6EF8A082B28F1C4779218`** |
| Größe / Einträge | 6 876 486 Byte, **41 Einträge** (40 Nutzdateien + `UPLOAD-MANIFEST.txt`), Manifest erstellt 2026-11-16 05:13:30 +01:00 |
| Gebaut aus | Kreuzprüfung: `origin/main` a1b11a8 + #38 (Head `10fb65f`) + #39 (Head `ba7c909`), lokal nachgestellt gemergt (a39d2a1, ohne Konflikt); `./scripts/build-upload.ps1 -OhneAudio -Suffix trailer`; `pruefe-paket.ps1 -ErwartetHash` Exit 0 |

Gegenüber dem freigegebenen Paket `6E48827B…1B98`: 3 geändert, 2 neu, 35 unverändert, 0 entfallen.

| Datei | SHA-256 | Byte | ggü. `6E48827B…` |
|---|---|---|---|
| `index.html` | `070B9B3DA878A541504423C5090476BCE914029280DA06EB16D02A07A33E4D4A` | 13 074 | **geändert** (Trailer, Link „Aufbruch“) |
| `assets/css/styles.css` | `6B4458FCBCEF88EB8DC97D540FB51574DDBAA84DBF22EAA6E5E2D15910BDA882` | 15 072 | **geändert** |
| `assets/js/app.js` | `C8EE58A9A6808568E272A273C28AA79872783635E7C2BE0ADE5AAC5C3811ACD3` | 4 511 | **geändert** |
| `assets/img/trailer-poster.jpg` | `ACB4B16D3657938EBDF4BE31A87C698C49E25ADE106D3EB0112D460780BDB41B` | 47 497 | **neu** |
| `assets/video/fahrt-zum-kunden-trailer.mp4` | `787A5B0B6A21E5C8E83D4066C5BD8722753C1B92F032530E951EDCE82B9C980B` | 2 105 919 | **neu** (neuer Ordner) |

Änderungen an der Reihenfolge (Abschnitt 2), nur wenn dieses Paket hochgeladen wird:

- Block 1 zusätzlich: `assets/video/` (ganzer Ordner, neu) und `assets/img/trailer-poster.jpg`, jeweils **vor** `index.html`.
- Block 2 unverändert: `index.html` mit `assets/js/app.js` in einem Durchgang; `styles.css` liegt schon in Block 1.
- Kurzabnahme zusätzlich: Hero zeigt den Trailer (stumm, Schleife), bei „Bewegung reduzieren“ nur das Standbild; Handy unter 800 px: Hero quadratisch; unter „Worum es geht“ Link „direkt zum Kapitel ‚Aufbruch‘“ springt in `lesen.html` zum Kapitel; `/relingit/assets/video/fahrt-zum-kunden-trailer.mp4` liefert HTTP 200.
- Rückfall auf das Paket ohne Trailer: `index.html`, `styles.css`, `app.js` aus `6E48827B…` zurückspielen; Video und Standbild können stehen bleiben.

**Nach dem Merge:** #38 und #39 durch den Product Owner mergen (Head-SHAs oben). Danach `main` gegen dieses Paket abgleichen: gleicher Inhalt erwartet (40 Nutzdateien gleich); neu gebaut ändert sich nur der ZIP-Hash (Zeitstempel im Manifest).

**Freigabe offen:** G8 vom 15.11.2026 gilt für `6E48827B…1B98`. Für dieses Paket: Sichtung Trailer und Link (G3 bis G5) und G8 mit Hash `CDF23C5F…9218` durch den Product Owner. Nicht geprüft: Safari/iOS, „Bewegung reduzieren“ auf echten Geräten.
