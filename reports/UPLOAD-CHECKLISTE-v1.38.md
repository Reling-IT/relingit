---
id: R51
titel: 'Upload-Checkliste v1.38 (nur lesen, Bericht)'
status: erledigt
start: 2026-11-10 06:16:24
ende: 2026-11-10 06:24:56
basis: origin/main 8abe213 (Arbeitsklon C:\dev\relingit, sauber)
art: lesen – kein Commit im Code, kein Upload, kein FTP, kein Tag, kein Merge, keine Live-Abfrage
---

# Upload-Checkliste v1.38

## Ziel

Der Product Owner lädt v1.38 hoch, ohne etwas raten zu müssen. Die Liste nennt je Datei:
- den Zielweg (Admin-Bereich oder FTP),
- die SHA-256-Prüfsumme,
- ob sich die Datei gegenüber v1.37 geändert hat.

Dazu kommen Reihenfolge, Handschritte, der Rückfallweg und eine Kurzabnahme. In diesem Auftrag wurde nichts hochgeladen und keine Live-Adresse abgerufen. R09 ist noch nicht bereit.

## Das richtige Paket

| | Wert |
|---|---|
| Datei | `C:\dev\relingit\output\ftp\relingit-upload-v1.38-2026-11-07-ohne-audio.zip` |
| SHA-256 | **`766923139AD9955DCBAB3678783DBCEC96FFA91E0CDA2F8CF945D554542C984C`** (selbst berechnet, `sha256sum`) |
| Größe / Einträge | 4 666 884 Byte, **36 Einträge** (35 Nutzdateien + `UPLOAD-MANIFEST.txt`) |
| Manifest | Version 1.38, Veröffentlichungsdatum 7. November 2026, erstellt 2026-11-10 05:21:18 +01:00, „Ohne Audio“ |
| entpackter Ordner | `C:\dev\relingit\output\ftp\relingit-upload-v1.38-2026-11-07-ohne-audio\` – gleich dem ZIP (`diff -r` ohne Befund) |
| inhaltsgleich | `C:\dev\relingit\archive\ftp-packages\20261109-060211-000\relingit-upload-v1.38-2026-11-07-ohne-audio.zip`, SHA-256 `A906DDF477C7B980E3AB1D5AD4867E2222FECA4B2EACEF29D2DC714B7E10205A` (R50). Nutzdateien bytegleich (`diff -r -x UPLOAD-MANIFEST.txt` ohne Befund). Im Manifest weicht nur die Zeile `Erstellt:` ab (09.11. 06:02:11 statt 10.11. 05:21:18). |

**Manifest-Abgleich:** Alle 36 Einträge wurden entpackt und je Datei mit `sha256sum` berechnet. Die 35 Prüfsummen im Manifest stimmen genau mit den berechneten überein (`diff` ohne Befund, 35 = 35 Zeilen).

## 1. Tabelle der 36 Einträge

Spalten:
- **v1.37:** Ich habe die SHA-256 je Datei mit dem Paket `archive\ftp-packages\20261110-052115-235\relingit-upload-v1.37-2026-09-05.zip` verglichen (24 Einträge, SHA-256 des ZIP `A710D248…747A`).
- **Zielweg:** nach R17 und `docs/DOMAINFACTORY-DEPLOYMENT.md` bzw. `docs/NEUE-GESCHICHTE.md` (FTP-Fall). Alle Paketdateien gehen per FTP ins Verzeichnis `relingit/` auf dem Webspace, mit derselben Ordnerstruktur.
- **Admin-Bereich:** Die Buchfassung geht zusätzlich über den Admin-Bereich (siehe Abschnitt 3). Das betrifft nur die Werte und die beiden Dateien aus `source/`, keine Paketdatei.

| Nr. | Datei | SHA-256 | Byte | geändert ggü. v1.37 | Zielweg |
|---|---|---|---|---|---|
| 1 | `.htaccess` | `2D20FD1BFDA1008048F9E0E6DD6AD503F3E42B579444E5ADB91A68F5268A3468` | 939 | nein | FTP `relingit/.htaccess` (versteckte Datei) |
| 2 | `admin.html` | `DEF5249F3DE1883C1A334DF67454F5FC7A8E61442EB276C0B15740F6FF1DB410` | 6 426 | nein | FTP `relingit/` |
| 3 | `datenschutz.html` | `2F9146FB37348BC81CE13C5CCC8D889F808273EDCD0ED09119B7F594F23D10BC` | 6 861 | **ja** | FTP `relingit/` |
| 4 | `handout-pdf.html` | `D4B3EBB2764A95840160A45413467AF7CC00F80B933E331BE10D0F8E88ADF61B` | 1 392 | nein | FTP `relingit/` |
| 5 | `handout.html` | `D698260CB00A96508DB04D03608DF25194601E02B693B84A1B644A437516CB81` | 2 019 | **ja** | FTP `relingit/` |
| 6 | `impressum.html` | `3D783AA8B8C3C3877FB5B417AEA4AACA94DA8A540B7952878DF0057118063554` | 1 886 | nein | FTP `relingit/` |
| 7 | `index.html` | `7CA72F83DBB214CBE18BDDCF8021308D3B47666BB6734D41F3DF970BB3D1021C` | 12 249 | **ja** | FTP `relingit/` |
| 8 | `lesen.html` | `DA178566CDCE75FF7458D083EF9DC04008DC596CEE1C39F60740CE87AD9E8D5F` | 2 143 | **ja** | FTP `relingit/` |
| 9 | `pdf.html` | `1771E0255E51C07AA225808474348FF2C603748037528C1561A0BF1C214FF507` | 1 387 | nein | FTP `relingit/` |
| 10 | `assets/css/legal.css` | `926068456D3F01F5FF1F27B69866AF74988560D45F19CCCC738EFC8EA472EFEF` | 1 299 | nein | FTP `relingit/assets/css/` |
| 11 | `assets/css/styles.css` | `E63EE8D8AFB07D1B84F2992B1B1CDC78293BBDE1B64A1895CA155BB7C9BF031D` | 14 181 | **ja** | FTP `relingit/assets/css/` |
| 12 | `assets/fonts/Fraunces-Variable.woff2` | `E6638EA113D0027354A08F957A4068975C8066395A0D0F7BB7861F6409621BE3` | 205 500 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 13 | `assets/fonts/WorkSans-Regular.woff2` | `495EC293F0E79AD3D77BCFCF4C4ADFFB2FE8BD993C6C3800E4528850A3634108` | 71 988 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 14 | `assets/fonts/WorkSans-Italic.woff2` | `21F75B620A355FC62E286EA0570E0A25186DA16D1973C2B7E9C0239BF1408169` | 66 376 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 15 | `assets/fonts/WorkSans-Bold.woff2` | `B8426840585AB1093CE262D35AA03291F59719C38605D0B6ECBE2032924917A9` | 76 284 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 16 | `assets/fonts/IBMPlexMono-Regular.woff2` | `BA204497F16B6D334CEE9D1E963A831B73E3A56E1D6300A8489D18DF7214B350` | 49 248 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 17 | `assets/fonts/IBMPlexMono-Italic.woff2` | `2024BF2B08027DCD6D09091385756E327744BBE26B782C411381DFFC40FFC622` | 53 408 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 18 | `assets/fonts/IBMPlexMono-Medium.woff2` | `33FAF307FA6031FB4062276D7320A6D632DE890CBB347576FD80CFA01077BC25` | 50 400 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 19 | `assets/fonts/Fraunces-OFL.txt` | `BDF4C22802EAF804F998195871C6B8938AAC2AC14B2D78A8BD66A6F1ECED833B` | 4 391 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 20 | `assets/fonts/WorkSans-OFL.txt` | `749ACA05078664CE682DCE1B1B10096AC397CB088C1A6DF4E1BB56F0092A9272` | 4 396 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 21 | `assets/fonts/IBMPlexMono-OFL.txt` | `7E6B2818EDBD8F6A01AE80641CC8F16A51080D08FB4E532BE3A0B6F74ADB07DA` | 4 456 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 22 | `assets/fonts/HERKUNFT.txt` | `141EF6B73695F60FBDF45F7FEB0C4E3A61E35A76282B35533EF7EDA97F114332` | 2 754 | **ja (neu)** | FTP `relingit/assets/fonts/` |
| 23 | `assets/img/favicon.png` | `E0D207AE2B5DA813D5B0CEA3F1320B19C06BB98AD1DA71514390008D4E2DC772` | 6 752 | nein | FTP `relingit/assets/img/` |
| 24 | `assets/img/reling-it-logo.svg` | `38820DB3A92BF698759B9A0AF1803C273D697BE12906BC15E46D2867FA3A5126` | 8 423 | nein | FTP `relingit/assets/img/` |
| 25 | `assets/img/reling-it-podcast-cover.png` | `6068294EA84E215E20D265D949B32D01F024CD4D9A7CBFEE832B9D4BE28D9EDD` | 1 005 947 | **ja (neu im Paket)**; laut R17 live bereits gleich | FTP `relingit/assets/img/` |
| 26 | `assets/js/admin.js` | `36DFB2F5E3942473AD4FD58E34663DAD59ACD20689013792E124D985ED4D9A81` | 18 682 | nein | FTP `relingit/assets/js/` |
| 27 | `assets/js/app.js` | `6B7696E8E08BE38B980F86EFA0FF4457559A7C545063F81DCD18BF170BD020D5` | 4 182 | **ja** | FTP `relingit/assets/js/` |
| 28 | `assets/js/handout-viewer.js` | `8DAADC660CAE0C61DD7E5E7661FD91EAD08DB59DD649CCA7531D4A8323E5C965` | 4 040 | **ja** | FTP `relingit/assets/js/` |
| 29 | `assets/js/pdf-viewer.js` | `F00DBB0F1DD02DD7E3D7E9E56E655923AA0DB9462F344B2F0AC0B9409C92E265` | 668 | nein | FTP `relingit/assets/js/` |
| 30 | `assets/js/story-viewer.js` | `6E555C7A988913D2558B7B1E38DBA40E09C9C253460C6A8ECEAB047C0B10E1E9` | 7 586 | **ja** | FTP `relingit/assets/js/` |
| 31 | `assets/js/supabase-config.js` | `7A6B95FE0A046254ABBBC1FE69FA82D4DADBA478AD218C02BA9CF4905D52F57F` | 246 | nein | FTP `relingit/assets/js/` |
| 32 | `story/current/fahrt-zum-kunden.html` | `75270361F3BBF008DAB0E25C8A934CBD20FC2D13C82A0ECEC84E8B03542EDC28` | 1 617 434 | **ja** | FTP `relingit/story/current/` (lokale Rückfallfassung; die Buchfassung selbst geht über den Admin-Bereich) |
| 33 | `story/current/geschichte.pdf` | `FB7889E50C1F3A13B0F52206D7240EAB97FA293680E64B5C5FB9A26CC3E0E6F3` | 2 065 170 | **ja** | FTP `relingit/story/current/` (Rückfallfassung, wie Nr. 32) |
| 34 | `story/current/workshop-handout.html` | `6DD3F0D37052823A19A72C333A011F4644988868A5BA111FFC2FD87A01726222` | 7 183 | nein | FTP `relingit/story/current/`; Handout im Admin-Bereich **nicht** auswählen |
| 35 | `story/current/workshop-handout.pdf` | `8EB1B90372633917FDC0403DF7FE28A9927A30D32CDB4D27F566E2885E5734D6` | 105 494 | nein | wie Nr. 34 |
| 36 | `UPLOAD-MANIFEST.txt` | `3B618BE62C7315C75FC1CA37ECCC68558BBB1E66B8D29A3912BE436E1DB26ED4` | 3 504 | ja (Erstellzeit) | **nicht übertragen**, nur zur lokalen Kontrolle |

**Zählung der 35 Nutzdateien gegenüber v1.37**

22 Dateien sind geändert oder neu:
- 4 HTML-Seiten: `index`, `lesen`, `handout`, `datenschutz`
- `styles.css`
- 11 Dateien in `assets/fonts`, alle neu
- das Podcast-Cover, neu im Paket
- 3 JS-Dateien: `app`, `story-viewer`, `handout-viewer`
- 2 Dateien in `story/current`: Buch als HTML und PDF

13 Dateien sind unverändert:
- `.htaccess`
- 5 HTML-Seiten: `admin`, `impressum`, `pdf`, `handout-pdf`
- `legal.css`
- 3 JS-Dateien: `admin`, `pdf-viewer`, `supabase-config`
- `favicon.png` und `reling-it-logo.svg`
- das Handout als HTML und PDF

**Was die Doku vorsieht**
- `docs/DOMAINFACTORY-DEPLOYMENT.md` (FTP-Paket hochladen, Schritt 3) sieht vor, den **gesamten Paketinhalt** hochzuladen.
- README und NEUE-GESCHICHTE sagen, per FTP gingen „nur geänderte Dateien“.
- Beides ist mit dem Paket erfüllt.

**Empfehlung (wie R17):** das ganze Paket ohne Manifest übertragen und vorhandene Dateien überschreiben. Die 13 unveränderten Dateien sind hashgleich mit v1.37; laut R17 waren sie am 08.11. live gleich main. Wer nur Geänderte überträgt, muss mindestens die 22 Dateien mit „ja“ übertragen. Das Podcast-Cover darf dabei fehlen, weil es live bereits gleich ist (R17).

## 2. Reihenfolge des Uploads

1. **Vorab lokal:** Den ZIP-Hash erneut prüfen und mit dem Sollwert oben vergleichen:
   `Get-FileHash output\ftp\relingit-upload-v1.38-2026-11-07-ohne-audio.zip -Algorithm SHA256`
   Optional `./scripts/pruefe-podcast-live.ps1` laufen lassen, erwartet 4× OK.
2. **Admin-Bereich zuerst:** Werte und Buchfassung eintragen (Abschnitt 3). Die Startseite zeigt danach auch mit der alten `app.js` die Version 1.38 (R17).
3. **FTP, Block 1 – neue und abhängige Dateien:**
   - `assets/fonts/` (11 Dateien)
   - `assets/css/styles.css`
   - `assets/img/` (ganzer Ordner, darin auch das Podcast-Cover)
4. **FTP, Block 2 – in einem Durchgang:**
   - `index.html` zusammen mit `assets/js/app.js`. Die neue `app.js` setzt die Seitenzahl über `data-page-count`, und das gibt es erst in der neuen `index.html` (R17, Schritt 10).
   - im selben Durchgang die übrigen JS-Dateien `story-viewer.js` und `handout-viewer.js`
5. **FTP, Block 3:**
   - `lesen.html` und `handout.html` (sie gehören zu `story-viewer.js` bzw. `handout-viewer.js`, siehe R40)
   - `datenschutz.html`
6. **FTP, Block 4:** `story/current/fahrt-zum-kunden.html` und `story/current/geschichte.pdf` (Rückfallfassung)
7. **FTP, Block 5 – unverändert, zur Sicherheit überschreiben:**
   - `.htaccess`, `admin.html`, `impressum.html`, `pdf.html`, `handout-pdf.html`
   - `legal.css`, `admin.js`, `pdf-viewer.js`, `supabase-config.js`
   - `story/current/workshop-handout.*`
8. Danach die Kurzabnahme (Abschnitt 7) durchgehen und anschließend R09 auf `bereit` setzen.

## 3. Admin-Bereich (Standardweg für die Buchfassung)

| Feld | Eintrag |
|---|---|
| Version | **1.38** |
| Angezeigtes Datum | **7. November 2026** |
| Seitenzahl | **77** |
| HTML-Lesefassung | `C:\dev\relingit\source\fahrt-zum-kunden.html` – SHA-256 `75270361…EDC28`, 1 617 434 Byte, gleich Paket Nr. 32 |
| PDF | `C:\dev\relingit\source\Die-Fahrt-zum-Kunden.pdf` – SHA-256 `FB7889E5…E6F3`, 2 065 170 Byte, `pdfinfo`: 77 Seiten, gleich Paket Nr. 33 |
| Handout | **nicht auswählen**: gegenüber v1.37 unverändert (Nr. 34/35 hashgleich) |

Handschritte:
1. `admin.html` auf der veröffentlichten Website öffnen.
2. Mit dem Administratorkonto anmelden und den Code der Authenticator-App bestätigen.
3. Die Werte aus der Tabelle eintragen.
4. Die beiden Dateien auswählen.
5. Veröffentlichen.

`admin.html` und `admin.js` haben sich nicht geändert. Deshalb ist für den Admin-Bereich selbst kein Upload nötig. Das Paket überschreibt sie trotzdem mit identischem Inhalt, das schadet nicht.

## 4. Nicht hochladen, nicht löschen

- **Live-MP3 unter `relingit/assets/audio/` nicht löschen.** Das Paket ist ohne Audio gebaut (Manifest: „Die Live-Dateien unter assets/audio bleiben unverändert“).
  - Keine Spiegel- oder Synchronisationsfunktion mit „Löschen auf dem Ziel“ verwenden, nur hochladen und überschreiben.
- **`UPLOAD-MANIFEST.txt` nicht übertragen.**
- Nichts außerhalb des Pakets hochladen, also nichts aus `archive/`, `output/` selbst, `source/`, `docs/`, `scripts/`, `supabase/` oder `tests/`, keine README, kein `.git`.
- Keine Dateien auf dem Server löschen. Nach R17 lagen dort keine Dateien, die entfernt werden müssten. Die Avatar-Bilder aus `assets/img/avatare/` sind nicht im Paket und werden nicht gebraucht.
- `admin.html` und `admin.js` sind laut Paket **nicht geändert**. Ein Upload ist nicht nötig, aber unschädlich.
- **Das alte Paket nicht verwenden** (siehe Abschnitt 8).

## 5. Handschritte

1. **Versteckte Dateien:** Im FTP-Programm die Anzeige versteckter Dateien einschalten, damit `.htaccess` mitkommt.
2. **R40-Dateien per FTP:** Die sechs Dateien der Barrierefreiheit gehen nur per FTP live, nicht über den Admin-Bereich. Alle sechs sind im Paket und als „geändert“ markiert:
   - `index.html`
   - `lesen.html`
   - `handout.html`
   - `assets/css/styles.css`
   - `assets/js/story-viewer.js`
   - `assets/js/handout-viewer.js`
3. **`.htaccess`-Header nach dem Upload prüfen:** Mit einem Header-Prüfwerkzeug oder per `curl -sI` auf die Startseite prüfen, ob die sechs Header ausgeliefert werden:
   - `Strict-Transport-Security`
   - `X-Content-Type-Options`
   - `Referrer-Policy`
   - `X-Frame-Options`
   - `Permissions-Policy`
   - `Content-Security-Policy`

   Alle sechs stehen als `Header always set` in der Paket-`.htaccess`. Ergebnis nicht hier, sondern direkt an den Product Owner melden.
4. **Browser-Cache:** In einem privaten Fenster prüfen. `lesen.html` lädt `story-viewer.js?v=20261108-1`. Bei `index.html` und `handout.html` gibt es keine Kennung, notfalls neu laden ohne Cache.
5. **Prüfsummen auf dem Server:** Das FTP-Programm kann meist keine SHA-256 berechnen. Die Kontrolle läuft lokal vor dem Upload (Schritt 2.1) und danach über R09.

## 6. Rückfall auf v1.37 (nur beschrieben, nichts ausgeführt)

- **Paket:** `C:\dev\relingit\archive\ftp-packages\20261110-052115-235\relingit-upload-v1.37-2026-09-05.zip`
  - SHA-256 `A710D2486DAAC169B552FBE52E00FBE7B66A4FCCED16092F6BA18C4ACE26747A`
  - 24 Einträge; Manifest: Version 1.37, 5. September 2026
  - Der entpackte Ordner liegt daneben.
- **Weg zurück:**
  1. **Admin-Bereich:** Version 1.37 und Datum 5. September 2026 eintragen, dazu die Buchfassung v1.37 aus dem Paket (`story/current/fahrt-zum-kunden.html`, SHA-256 `9E9F43F6…C2259`, und `story/current/geschichte.pdf`, SHA-256 `BBFD1991…446F`). Der Admin-Bereich verlangt die Dateinamen `fahrt-zum-kunden.html` und `Die-Fahrt-zum-Kunden.pdf`. Die PDF muss also unter dem passenden Namen ausgewählt werden.
     - **Seitenzahl:** `app.js` in v1.37 nennt 69, Supabase meldete live 64 (R17). Vorher entscheiden, welcher Wert gilt.
  2. **FTP:** Den Inhalt des v1.37-Pakets ohne Manifest über den Stand v1.38 legen.
  3. **Neue Dateien:** Die 11 Dateien in `assets/fonts/` und das Podcast-Cover gibt es in v1.37 nicht. Sie können stehen bleiben, die alten Seiten verweisen nicht auf sie. Löschen ist nicht nötig.
  4. Live-MP3 auch beim Rückfall **nicht** löschen.
- **Teil-Rückfall:** Wenn nur die Webseite Fehler zeigt, die Buchfassung aber stimmt, genügt es, die 10 geänderten Web-Dateien aus v1.37 zurückzuspielen:
  - `index.html`, `lesen.html`, `handout.html`, `datenschutz.html`
  - `styles.css`
  - `app.js`, `story-viewer.js`, `handout-viewer.js`
  - die zwei Dateien in `story/current`

  Achtung: Die alte `index.html` braucht die alte `app.js`, also beide gemeinsam zurückspielen.

## 7. Kurzabnahme nach dem Upload (Erwartungen, nicht live geprüft)

Alle Adressen in einem privaten Browserfenster öffnen. Basis ist die öffentliche Website unter `/relingit/`.

| Nr. | Adresse | erwarteter Inhalt |
|---|---|---|
| 1 | `https://berndmarnau.de/relingit/` (Startseite) | Kopfzeile „Fortlaufende Kurzgeschichte · Version 1.38“. Metazeile „**77** Seiten · … · aktualisiert am 7. November 2026“. Fußzeile mit Link „Quellcode“ auf **`https://github.com/Reling-IT/relingit`**, nicht mehr `bmarnau/relingit`. Neue Gestaltung (styles.css), Marken-Link für Screenreader „Reling IT / Geschichte – zur Startseite“. |
| 2 | `…/relingit/lesen.html` | Kopf „Version 1.38 · 7. November 2026“. Deckblatt „Neu in v1.38“, Kapitel „Die veralteten Daten“. Im Kapitel „Warum Navis und Lumen“ steht „ein kleines Systemhaus mit einer Kaffeeecke“ (R50). Die Buchschriften werden geladen: `story-viewer.js` schreibt die Schriftpfade auf `assets/fonts/` neben `lesen.html` um. Zoom-Knopf „100 %“. |
| 3 | `…/relingit/pdf.html` | Die PDF wird angezeigt, Deckblatt „Version 1.38“ und „07.11.2026“, **77** Seiten. |
| 4 | `…/relingit/handout.html` | Das Handout wird angezeigt, inhaltlich unverändert. Zoom-Knopf „100 %“ mit Namen „100 % – Originalgröße wiederherstellen“ (R40). |
| 5 | `…/relingit/datenschutz.html` | Die Seite lädt, Abschnitt „8. Stand“: 20. Oktober 2026. Fußzeilenfarbe nach R40. |
| 6 | `…/relingit/assets/fonts/WorkSans-Regular.woff2` | HTTP 200 statt bisher 404 (R17). Damit sind die Schriften da. |

Zusatz: `./scripts/pruefe-podcast-live.ps1` sollte weiter 4× OK melden. Danach R09 auf `bereit` setzen; R09 übernimmt die eigentliche Live-Prüfung je Datei.

## 8. Warnung: altes Paket NICHT hochladen

> **NICHT HOCHLADEN:** `C:\dev\relingit\archive\ftp-packages\20261110-052115-235\relingit-upload-v1.38-2026-11-07-ohne-audio.zip`
> SHA-256 **`7118198F87CF602C68C3E6EB7992C87EA95302D5D6A1EEB291C143C0A762FAE4`**, 4 666 966 Byte, gebaut am 09.11. **vor R50**.
> Es trägt denselben Dateinamen wie das richtige Paket. Unterschiede laut `diff -rq` gegen das richtige Paket: `story/current/fahrt-zum-kunden.html`, `story/current/geschichte.pdf` (noch mit „ein Systemhaus mit zehn Köpfen und einer Kaffeeecke“) und `UPLOAD-MANIFEST.txt`.
> Erkennung: Vor dem Upload immer den ZIP-Hash prüfen. Nur `76692313…984C` (oder das inhaltsgleiche `A906DDF4…205A`) ist richtig.

## Offene Fragen und Abweichungen

- **Live-Stand nicht geprüft:** R09 ist noch nicht bereit. Ob unveränderte Dateien live wirklich dem Stand v1.37 entsprechen, stützt sich auf R17 (Stand 08.11.).
- **Datenschutz-Seite:** `datenschutz.html` ist gegenüber dem v1.37-Paket geändert. Laut R17 ist sie live aber schon auf dem neuen Stand. Der Upload ist unschädlich.
- **Freigabetore:** Laut Tagesbericht vom 10.11. sind G3 bis G5 noch offen und G8 ist gesperrt. Nach `docs/FREIGABE.md` gibt es ohne bestandene Tore keinen Upload. Diese Checkliste ersetzt die Freigabe nicht.

## Vorschläge und Ideen (Claude)

- **Hash-Prüfung als Skript:** `scripts/pruefe-paket.ps1 -Zip <Pfad>` prüft das ZIP gegen sein Manifest und vergleicht mit einem Vorgänger-Paket. Die Ausgabe wäre diese Tabelle als Markdown. Damit wäre die Checkliste bei jedem Release reproduzierbar.
- **Eindeutige Paketnamen:** Die Erstellzeit oder den Commit in den ZIP-Namen aufnehmen (z. B. `…-ohne-audio-8abe213.zip`). Gleichnamige Pakete wie bei `7118198F…` könnten dann nicht verwechselt werden.
- **Nur-Geänderte-Ordner:** `build-upload.ps1` könnte zusätzlich `nur-geaendert/` mit den 22 Dateien gegenüber einem Vergleichspaket erzeugen. Das ist ein bequemer Weg für einen schnellen FTP-Upload.
- **Live-Stand festhalten:** Nach dem Upload den Paket-Hash und den Commit (8abe213) im Bericht von R09 festhalten. Dann gibt es künftig einen belegten Vergleichsstand „live“, siehe Vorschlag aus R17.
- **Cache-Kennung:** Für `app.js`, `handout-viewer.js` und `styles.css` ebenfalls `?v=` setzen, damit Browser nach dem Upload sicher neu laden.

Hygiene: gemergte Remote-Branches 0 (`git branch -r --merged origin/main` ohne Treffer außer main); offene PRs 4: #25, #26, #27, #28, alle Draft (`gh pr list --state open`); Drafts 4, dieselben.

```yaml
Reifegrad: "v1.38-Paket 76692313…984C geprüft: 36 Einträge, 35 Prüfsummen gleich Manifest, inhaltsgleich mit R50 (A906DDF4…205A); 22 Dateien ggü. v1.37 geändert/neu, 13 unverändert"
Projektstatus: "R51 erledigt (Checkliste). Upload v1.38 durch den Product Owner offen (Admin 1.38/7. November 2026/77, danach FTP-Paket ohne Audio); dann R09. Tore G3–G5 offen, G8 beim Product Owner"
Offene_Fragen:
  - "Werden G3 bis G5 (Sichtung) vor dem Upload abgeschlossen und G8 erteilt?"
  - "Ganzes Paket oder nur die 22 geänderten Dateien per FTP?"
  - "Welche Seitenzahl gilt bei einem Rückfall auf v1.37 (69 laut Repo, 64 laut Supabase live)?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: "unbelegte Schaetzung"
```
