# Trailer im Hero der Startseite

Der Hero von `index.html` zeigt einen stummen Trailer in Schleife: Nachtfahrt über die Landstraße, Navis (Cyan) und Lumen (Gold) kommen als Lichter dazu, Ankunft im Morgenlicht vor einem erleuchteten Haus.

## Dateien

| Zweck | Pfad | Hinweis |
|---|---|---|
| Video | `assets/video/fahrt-zum-kunden-trailer.mp4` | 1080 × 1080, 24 Bilder/s, 480 Bilder (20 Sekunden), H.264, ohne Tonspur |
| Standbild | `assets/img/trailer-poster.jpg` | Bild 400 der Szene; erscheint vor dem Laden und bei „Bewegung reduzieren“ |
| Szene | `scripts/trailer/trailer.py` | Blender-Python-Skript, erzeugt Szene, Bewegung und Ausgabe |

Erzeugt am 15.11.2026 mit Blender 5.3.0 (EEVEE) in einer KI-Sitzung. Die Szene ist vollständig im Skript beschrieben; es gibt keine `.blend`-Datei und keine fremden Bilder oder Modelle.

## Einbindung

- `index.html`: `<video class="hero-video" muted loop playsinline>` in `.hero-art`, über der gezeichneten Grafik. Lädt weder Video noch Standbild, bleibt die Grafik sichtbar.
- `assets/js/app.js`: startet das Video, außer das System meldet `prefers-reduced-motion: reduce`. Ohne JavaScript bleibt das Standbild stehen.
- `scripts/build-upload.ps1`: Video und Standbild stehen in `$publicFiles` und gehen mit dem FTP-Paket auf den Webspace.
- Die Content-Security-Policy in `.htaccess` braucht keine Änderung (`default-src 'self'` gilt auch für Medien).

## Neu erzeugen

Voraussetzung ist Blender 5.3 oder neuer. Im Projektordner:

```powershell
$blender = "C:\Program Files\Blender Foundation\Blender 5.3\blender.exe"

# Video (rund 10 Minuten auf einer integrierten Grafikkarte)
& $blender -b -P scripts/trailer/trailer.py -- --out "$PWD\output\trailer\fahrt-zum-kunden-trailer.mp4"

# Einzelbilder zur Kontrolle oder als Standbild (PNG)
& $blender -b -P scripts/trailer/trailer.py -- --out "$PWD\output\trailer\bild" --stills 100,230,400
```

Die Ausgabe landet in `output/` (nicht versioniert). Nach der Sichtung das Video nach `assets/video/` kopieren und das Standbild als JPG nach `assets/img/trailer-poster.jpg` legen.

## Bekannte Punkte

- Beim Rendern meldet Blender vereinzelt „Shadow buffer full“. Dann können in einzelnen Bildern Schatten fehlen.
- Farben und Ablauf stehen als Konstanten im Skript (Abschnitte „Materialien“ und „Bewegung“).
