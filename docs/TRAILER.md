# Trailer im Hero der Startseite

Der Hero von `index.html` zeigt einen stummen Trailer in Schleife: Nachtfahrt über die Landstraße, Navis (Cyan) und Lumen (Gold) kommen als Lichter dazu, Ankunft im Morgenlicht vor einem erleuchteten Haus.

## Dateien

| Zweck | Pfad | Hinweis |
|---|---|---|
| Video | `assets/video/fahrt-zum-kunden-trailer.mp4` | 1080 × 1080, 24 Bilder/s, 480 Bilder (20 Sekunden), H.264, ohne Tonspur, 2 105 919 Byte (rund 2,1 MB) |
| Standbild | `assets/img/trailer-poster.jpg` | Bild 400 der Szene (neu gerendert nach der Schattenkorrektur), JPEG, 47 497 Byte, Qualität 85; erscheint vor dem Laden und bei „Bewegung reduzieren“ |
| Szene | `scripts/trailer/trailer.py` | Blender-Python-Skript, erzeugt Szene, Bewegung und Ausgabe |

Erzeugt am 15.11.2026 mit Blender 5.3.0 (EEVEE) in einer KI-Sitzung. Die Szene ist vollständig im Skript beschrieben; es gibt keine `.blend`-Datei und keine fremden Bilder oder Modelle.

## Einbindung

- `index.html`: `<video class="hero-video" aria-hidden="true" muted loop playsinline>` in `.hero-art`, über der gezeichneten Grafik. Lädt weder Video noch Standbild, bleibt die Grafik sichtbar. Das Video ist rein dekorativ und für Hilfstechnik ausgeblendet (auch `.hero-art` trägt `aria-hidden`).
- `assets/css/styles.css`: Auf dem Desktop ist `.hero-art` 520 px hoch, das Video füllt die Fläche mit `object-fit: cover`. Unter 800 px Breite ist `.hero-art` quadratisch (`height: auto; aspect-ratio: 1`), so wird der quadratische Trailer auf dem Handy nicht oben und unten beschnitten (vorher feste 380 px Höhe). Unter 520 px Breite stehen die Signale Navis und Lumen der Rückfallgrafik bei 40 % statt 57 % Höhe, damit sie im kleineren Quadrat das Auto nicht überdecken.
- `assets/js/app.js`: startet das Video, außer das System meldet `prefers-reduced-motion: reduce`. Ohne JavaScript bleibt das Standbild stehen.
- `scripts/build-upload.ps1`: Video und Standbild stehen in `$publicFiles` und gehen mit dem FTP-Paket auf den Webspace.
- Die Content-Security-Policy in `.htaccess` braucht keine Änderung (`default-src 'self'` gilt auch für Medien).
- `scripts/vorschau.ps1` liest die Dateiliste aus `build-upload.ps1`; die lokale Vorschau zeigt den Trailer also mit.
- `scripts/publish-release.ps1` meldet Änderungen unter `assets/video` als „Hinweis: weitere öffentliche Dateien geändert“.

## Hochladen

Der Trailer geht nur per FTP live, nicht über den Admin-Bereich ([FTP-Fall in docs/NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md#ftp-fall)). Mit dem Trailer gehören fünf Dateien zusammen und werden in einem Durchgang übertragen:

| Datei | Änderung |
|---|---|
| `assets/video/fahrt-zum-kunden-trailer.mp4` | neu, neuer Ordner auf dem Webspace |
| `assets/img/trailer-poster.jpg` | neu |
| `index.html` | `<video>` im Hero |
| `assets/css/styles.css` | Regel `.hero-video` |
| `assets/js/app.js` | Start des Videos |

Das Paket wird wie jedes andere mit `scripts/build-upload.ps1` gebaut. Für v1.39 mit Trailer: `./scripts/build-upload.ps1 -OhneAudio -Suffix trailer`, damit es sich im Namen vom freigegebenen Paket ohne Trailer unterscheidet. Ohne Trailer zurück: diese fünf Dateien aus dem Vorgängerpaket zurückspielen; Video und Standbild dürfen auf dem Webspace stehen bleiben, die alte `index.html` verweist nicht darauf.

## Neu erzeugen

Voraussetzung ist Blender 5.3 oder neuer. Im Projektordner:

```powershell
$blender = "C:\Program Files\Blender Foundation\Blender 5.3\blender.exe"

# Video (rund 10 Minuten auf einer integrierten Grafikkarte)
& $blender -b -P scripts/trailer/trailer.py -- --out "$PWD\output\trailer\fahrt-zum-kunden-trailer.mp4"

# Einzelbilder zur Kontrolle oder als Standbild (PNG)
& $blender -b -P scripts/trailer/trailer.py -- --out "$PWD\output\trailer\bild" --stills 100,230,400
```

Die Ausgabe landet in `output/` (nicht versioniert). Nach der Sichtung das Video nach `assets/video/` kopieren und das Standbild als JPG nach `assets/img/trailer-poster.jpg` legen (bisher Bild 400, mit Pillow als JPEG Qualität 85, 1080 × 1080).

## Bekannte Punkte

- Schatten im Morgenlicht (behoben am 15.11.2026). Im ersten Standbild lagen unten rechts eine große, hart begrenzte dunkle Fläche und vor dem Haus ein dunkles Rechteck. Eingegrenzt mit Einzelbildern (100, 230, 400, 470), in denen jeweils ein Teil abgeschaltet war:
  - Die große Fläche war der Schatten von Haus und Dach im Licht „Morgenlicht“. Die Sonne stand nur rund 12 Grad über dem Horizont und gegenüber der Kamera; das Haus warf so einen rund 30 m langen Schatten über den Vordergrund. Ohne Schatten der Sonne oder ohne Schattenwurf von Haus und Dach war die Fläche weg, ohne Mondschatten, ohne Blende und ohne Schatten der Punkt- und Spotlichter blieb sie.
  - Das Rechteck war der Weg: ein Quader im Strassenmaterial, 5,5 m vor der Hausfront, ohne Anschluss an die Tür, der zum Teil mit der Strasse überlappte. Ohne ihn war das Rechteck weg.
  - Behebung in `scripts/trailer/trailer.py`: Die Morgensonne steht jetzt links hinter der Kamera, rund 25 Grad hoch (`rot=(65°, 0, -30°)`, Winkel 4 Grad), die Schatten fallen kurz und von der Kamera weg. Der Weg besteht aus zwei flachen Flächen in eigenem Material (`#60768a`) von der Strasse bis zur Tür, ohne Schattenwurf. Navis und Lumen werfen keinen Schatten mehr (vorher ein dunkler Fleck am Boden neben dem Auto).
- „Shadow buffer full“: Auch das korrigierte Video meldet die Zeile einmal, ganz am Ende des Laufs über alle 480 Bilder (nach „FERTIG“). Einzelbilder und Teilläufe (Bilder 1–160, 160–320, 320–480) melden sie nicht. Die Bilder 100, 230, 400 und 470 aus dem fertigen Video weichen von den einzeln gerenderten Kontrollbildern im Mittel um rund 1 von 255 je Farbkanal ab (Kompression); fehlende Schatten sind nicht zu sehen. Die Ursache der Meldung ist unklar; die Schattenfehler im ersten Standbild hingen nicht an ihr (siehe oben).
- Farben und Ablauf stehen als Konstanten im Skript (Abschnitte „Materialien“ und „Bewegung“).
