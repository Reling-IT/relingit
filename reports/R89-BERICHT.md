---
titel: 'R89 Live-Prüfung Paketdateien und Sicherheits-Header v1.40 (nur lesend)'
datum: 2026-11-23
auftrag: R89
pruefstand_main: f7c59daa04be8114439626ed5be4ec70bfe2a31f
paket: relingit-upload-v1.40-2026-11-16-ohne-audio.zip, SHA-256 C41075866B3F824E3B45EFB7B792B74FFBACC3D8DAFACF0C3A73FD5FBDC87537
abruf_dateien: 2026-11-23T15:21:50Z
abruf_header: 2026-11-23T15:22:09Z
ergebnis: bestanden
---

# R89 Live-Prüfung Paketdateien und Sicherheits-Header

Nur lesende Abrufe ohne Anmeldung. Kein FTP, kein Supabase, keine Korrektur. `origin/main` f7c59da unterscheidet sich von 84ae342 (Tag v1.40, Paketstand) nur in Doku-Dateien, die nicht im Paket sind.

## 1. Paketdateien gegen Server und `origin/main`

Liste: alle 41 Einträge des ZIP (`System.IO.Compression.ZipFile`), ohne `UPLOAD-MANIFEST.txt` 40 Nutzdateien. Abruf je Datei: `Invoke-WebRequest https://berndmarnau.de/relingit/<pfad>?nc=<zeit>` mit `Cache-Control: no-cache`. Vergleich mit `git show origin/main:<pfad>`, zuerst byteweise, sonst nach CRLF zu LF. Spalten Soll und Ist: die ersten 12 Zeichen des SHA-256 nach LF-Normalisierung.

**Ergebnis:** 29 byte-gleich, 10 gleich ohne CR (Server mit CRLF), 0 abweichend, 1 nicht abrufbar (`.htaccess`, 403, so vorgesehen).

| Datei | HTTP | Soll | Ist | Ergebnis |
|---|---|---|---|---|
| .htaccess | 403 | d1ad6b020dc8 | – | gesperrt, wie vorgesehen (Wirkung siehe Abschnitt 2) |
| admin.html | 200 | a0fa6d1f29a6 | a0fa6d1f29a6 | byte-gleich |
| anhang.html | 200 | df9bfa629d3a | df9bfa629d3a | byte-gleich |
| datenschutz.html | 200 | a451aac17faf | a451aac17faf | byte-gleich |
| handout-pdf.html | 200 | 9bf054ded0a0 | 9bf054ded0a0 | byte-gleich |
| **handout.html** (R40) | 200 | 66299e9ad35b | 66299e9ad35b | byte-gleich |
| impressum.html | 200 | 85b4fe7ff83d | 85b4fe7ff83d | byte-gleich |
| **index.html** (R40) | 200 | 5f01013b77f7 | 5f01013b77f7 | byte-gleich |
| **lesen.html** (R40) | 200 | ff2da79c7dd7 | ff2da79c7dd7 | byte-gleich |
| pdf.html | 200 | 607313cd393a | 607313cd393a | byte-gleich |
| **assets/css/legal.css** (R40) | 200 | 267b4dcefb98 | 267b4dcefb98 | byte-gleich |
| **assets/css/styles.css** (R40) | 200 | a4f2af98bce0 | a4f2af98bce0 | byte-gleich |
| **assets/js/admin.js** (R40) | 200 | 7bb9b368e662 | 7bb9b368e662 | gleich ohne CR |
| **assets/js/app.js** (R40) | 200 | e3d40d181091 | e3d40d181091 | gleich ohne CR |
| **assets/js/handout-viewer.js** (R40) | 200 | 7b7201323c41 | 7b7201323c41 | gleich ohne CR |
| **assets/js/pdf-viewer.js** (R40) | 200 | 758a3afe8b0d | 758a3afe8b0d | gleich ohne CR |
| **assets/js/story-viewer.js** (R40) | 200 | 73e3338e58fb | 73e3338e58fb | gleich ohne CR |
| **assets/js/supabase-config.js** (R40) | 200 | 3fbd6e3f6ef2 | 3fbd6e3f6ef2 | gleich ohne CR |
| assets/fonts/Fraunces-OFL.txt | 200 | bdf4c22802ea | bdf4c22802ea | byte-gleich |
| assets/fonts/Fraunces-Variable.woff2 | 200 | 719b4d648362 | 719b4d648362 | byte-gleich |
| assets/fonts/HERKUNFT.txt | 200 | 9b826b18c694 | 9b826b18c694 | byte-gleich |
| assets/fonts/IBMPlexMono-Italic.woff2 | 200 | 2024bf2b0802 | 2024bf2b0802 | byte-gleich |
| assets/fonts/IBMPlexMono-Medium.woff2 | 200 | ea87ff8d3709 | ea87ff8d3709 | byte-gleich |
| assets/fonts/IBMPlexMono-OFL.txt | 200 | 37784b44044a | 37784b44044a | gleich ohne CR |
| assets/fonts/IBMPlexMono-Regular.woff2 | 200 | ba204497f16b | ba204497f16b | byte-gleich |
| assets/fonts/WorkSans-Bold.woff2 | 200 | b8426840585a | b8426840585a | byte-gleich |
| assets/fonts/WorkSans-Italic.woff2 | 200 | b7c68f42d26f | b7c68f42d26f | byte-gleich |
| assets/fonts/WorkSans-OFL.txt | 200 | 749aca050786 | 749aca050786 | byte-gleich |
| assets/fonts/WorkSans-Regular.woff2 | 200 | 79486cf5cc5e | 79486cf5cc5e | byte-gleich |
| assets/img/favicon.png | 200 | 9d89837fbbb9 | 9d89837fbbb9 | byte-gleich |
| assets/img/reling-it-logo.svg | 200 | 7ca5b49a081b | 7ca5b49a081b | gleich ohne CR |
| assets/img/reling-it-podcast-cover.png | 200 | 649ee372c9fa | 649ee372c9fa | byte-gleich |
| assets/img/trailer-poster.jpg | 200 | acb4b16d3657 | acb4b16d3657 | byte-gleich |
| assets/img/avatare/lumen.svg | 200 | 85d507343ca0 | 85d507343ca0 | gleich ohne CR |
| assets/img/avatare/navis.svg | 200 | 878f4ed36ec2 | 878f4ed36ec2 | gleich ohne CR |
| assets/video/fahrt-zum-kunden-trailer.mp4 | 200 | 4df39473c741 | 4df39473c741 | byte-gleich |
| story/current/fahrt-zum-kunden.html | 200 | ef71ab34fb0e | ef71ab34fb0e | byte-gleich |
| story/current/geschichte.pdf | 200 | a442b4405fa5 | a442b4405fa5 | byte-gleich |
| story/current/workshop-handout.html | 200 | a75c8e4c859f | a75c8e4c859f | byte-gleich |
| story/current/workshop-handout.pdf | 200 | daa49d613806 | daa49d613806 | byte-gleich |

R40-Dateien: index.html, lesen.html, handout.html, assets/css (2 Dateien) und assets/js (6 Dateien) sind alle gleich `main`.

Hinweis: Bei Binärdateien ist der LF-normalisierte Hash nicht der Datei-Hash (z. B. `geschichte.pdf`: Datei-SHA-256 `c421ed71…26ae1`). Der Vergleich ist trotzdem gültig, weil beide Seiten gleich behandelt und Binärdateien zusätzlich byteweise geprüft wurden („byte-gleich“).

## 2. Sicherheits-Header gegen `.htaccess` auf `main`

Befehl: `curl -sS -I -A relingit-r89/1.0 -H 'Cache-Control: no-cache' <url>?nc=<zeit>` für die Startseite `/relingit/`, `lesen.html` und `assets/css/styles.css`. Alle drei liefern HTTP 200 und identische Header.

| Header | Soll (`.htaccess`) | Ist (alle drei Abrufe) | Ergebnis |
|---|---|---|---|
| Strict-Transport-Security | `max-age=31536000` | `max-age=31536000` | OK |
| X-Content-Type-Options | `nosniff` | `nosniff` | OK |
| Referrer-Policy | `strict-origin-when-cross-origin` | gleich | OK |
| X-Frame-Options | `SAMEORIGIN` | `SAMEORIGIN` | OK |
| Permissions-Policy | `camera=(), microphone=(), geolocation=()` | gleich | OK |
| Content-Security-Policy | Zeile 14 der `.htaccess` | wortgleich | OK |
| HTTP zu HTTPS | `RewriteRule … [R=301]` | `curl -I http://berndmarnau.de/relingit/index.html`: 301, `Location: https://berndmarnau.de/relingit/index.html` | OK |
| Verzeichnislisten | `Options -Indexes` | `assets/`, `assets/js/`, `assets/img/`, `story/current/`: je 403, keine Liste im Inhalt | OK |
| Inhaltstypen | – | Startseite und lesen.html `text/html`, styles.css `text/css` | Hinweis: ohne `charset`; die Seiten deklarieren UTF-8 im HTML |

## Ergebnis

Bestanden. Alle abrufbaren Paketdateien entsprechen `main`, die Header der `.htaccess` wirken auf HTML- und Asset-Dateien. Keine Abweichung, nichts korrigiert.
