# PDF der Geschichte erzeugen und Layout prüfen

Zwei Skripte unter `scripts/pdf/` erzeugen aus `source/fahrt-zum-kunden.html` die PDF und prüfen sie:

- `render_story_pdf.py` rendert die HTML-Datei mit Chromium (Playwright) zu einer getaggten A4-PDF, setzt den Renderstand auf dem Deckblatt (Zeitzone Europe/Berlin, MEZ/MESZ) und schreibt die PDF-Metadaten.
- `verify_layout.py` prüft die PDF auf sieben Fehlerklassen: Seitenrand, Luftzone an Kasten- und Seitenrand, umbrochene Absätze, fast leere Seiten, Reihenfolge der Kapitelüberschriften und Kapitel-Verlinkung. Ohne `--no-render` rendert es vorher selbst neu.

Die Werkzeuge sind freiwillig. `scripts/ci-check.ps1` und die GitHub-CI brauchen sie nicht.

## Einmal-Einrichtung unter Windows

Alle Befehle in PowerShell, im Repo-Stamm.

1. **Python 3.11 oder neuer** (python.org oder `winget install Python.Python.3.11`). Prüfen:
   ```powershell
   python --version
   python -m pip --version
   ```
2. **Python-Pakete** (playwright, pypdf, numpy, pillow, unter Windows zusätzlich tzdata):
   ```powershell
   python -m pip install -r scripts/pdf/requirements.txt
   ```
3. **Chromium für Playwright** (wird in `%LOCALAPPDATA%\ms-playwright` abgelegt):
   ```powershell
   python -m playwright install chromium
   ```
4. **Poppler** für `pdftoppm` (Seitenbilder für die Pixelprüfung). Poppler liefert auch `pdfinfo` und `pdftotext`, die `scripts/publish-release.ps1` für Seitenzahl und PDF-Version braucht:
   ```powershell
   winget install oschwartz10612.Poppler
   ```
   Danach ein neues Terminal öffnen, damit `pdftoppm` im PATH ist.

Kontrolle, ob alles da ist:

```powershell
python -c "import playwright, pypdf, numpy, PIL, tzdata; print('Pakete ok')"
where.exe pdftoppm
Get-ChildItem "$env:LOCALAPPDATA\ms-playwright"
```

## Rendern und prüfen

Vor jedem Rendern prüfen, ob der Chromium-Build zur installierten Playwright-Version vorhanden ist: `python -c "from playwright.sync_api import sync_playwright as s; p=s().start(); b=p.chromium.launch(); print(b.version); b.close(); p.stop()"` muss eine Versionsnummer ausgeben, sonst zuerst `python -m playwright install chromium` (am 12.11.2026 fehlte der Build einmal ohne belegte Ursache). Die Versionen von playwright und pypdf sind in `requirements.txt` gepinnt (1.64.0 passt zu Chromium-Build 1248).

Die Ausgabe landet in `output/`. Der Ordner ist in `.gitignore` eingetragen, die erzeugte PDF wird nicht committet.

```powershell
# nur rendern
python scripts/pdf/render_story_pdf.py --source source/fahrt-zum-kunden.html --out output/Die-Fahrt-zum-Kunden.pdf

# rendern und prüfen (rendert selbst neu)
python scripts/pdf/verify_layout.py --source source/fahrt-zum-kunden.html --pdf output/Die-Fahrt-zum-Kunden.pdf

# vorhandene PDF prüfen, ohne neu zu rendern
python scripts/pdf/verify_layout.py --pdf output/Die-Fahrt-zum-Kunden.pdf --no-render

# Seitenzahl kontrollieren
pdfinfo output/Die-Fahrt-zum-Kunden.pdf
```

Ohne Parameter gelten genau diese Standardpfade.

## Handout rendern

Dasselbe Skript rendert mit `--profil handout` das Workshop-Handout aus `story/current/workshop-handout.html`: gleiche Seitenränder und gleiches Format wie die Geschichte, eigene Fußzeile („Der Reling-IT-Transfer · frei erfunden“) und eigene PDF-Metadaten. Der Renderstand wird in die Fußzeile des Handouts geschrieben.

```powershell
# nach output/workshop-handout.pdf rendern und kontrollieren (erwartet: 2 Seiten)
python scripts/pdf/render_story_pdf.py --profil handout
pdfinfo output/workshop-handout.pdf

# erst nach der Kontrolle als Paar zur HTML-Fassung ablegen
Copy-Item output/workshop-handout.pdf story/current/workshop-handout.pdf
```

HTML und PDF des Handouts gehören zusammen: Wer das Datum oder den Text in `workshop-handout.html` ändert, rendert das PDF neu. Der Anlass (Monat und Jahr des Workshops) für die Metadaten beider PDFs steht im Skript in der Konstante `ANLASS`. `verify_layout.py` prüft nur die Geschichte, nicht das Handout.

## Erwartete Ausgabe

Render-Skript:

```text
OK -> C:\...\output\Die-Fahrt-zum-Kunden.pdf | Seiten: <n> | Renderstand: TT.MM.JJJJ, HH:MM Uhr (MEZ)
```

Prüfskript bei sauberem Layout (Exit-Code 0):

```text
Hintergrundfarbe aus dem Quelltext: #123b4e
Struktur-Check OK - alle vier Fix-Mechanismen sind im CSS vorhanden.
OK -> ... | Seiten: <n> | ...
Geprueft: <n> Seiten (Rand/Luftzone/Fast-leer-Check)
Geprueft: Ueberschriften-Reihenfolge + Kapitel-Verlinkung (Inhalt-Check)
OK - alle Seiten erfuellen den Layout-Check UND den Inhalt-Praesenz-/Positions-Check.
```

Exit-Codes von `verify_layout.py`: 0 = sauber, 1 = mindestens eine Verletzung (Liste folgt), 2 = Werkzeug fehlt (Meldung nennt den Installationsbefehl).

Bezugswert: `story/current/geschichte.pdf` (v1.37) hat 69 Seiten. Sie wurde unter Linux mit den Ersatzschriften DejaVu Sans Mono, Liberation Serif und Liberation Sans gerendert (`pdffonts story/current/geschichte.pdf`).

## Bekannte Stolpersteine

- **Seitenzahl hängt von den installierten Schriften ab.** Die Quelle verlangt Fraunces, Work Sans und IBM Plex Mono, lädt sie aber nicht als Webfonts. Chromium nimmt die erste installierte Schrift aus der Liste: unter Windows meist Georgia, Segoe UI und Consolas, unter Linux Liberation und DejaVu. Andere Schriften ergeben andere Umbrüche und damit eine andere Seitenzahl (in der Cloud zum Beispiel 70 statt 69). Vor dem Veröffentlichen die Seitenzahl mit `pdfinfo` prüfen. `publish-release.ps1` übernimmt die Seitenzahl aus der PDF.
- **Randhinweise des Prüfskripts** (zum Beispiel „kein Abstand unten“ auf einzelnen Seiten) können ebenfalls von den Ersatzschriften kommen. Sie sind ernst zu nehmen. Die Schwellenwerte im Skript bitte nicht lockern, sondern die Ursache in der Quelle oder in der Schriftumgebung suchen.
- **`ZoneInfoNotFoundError` / „Zeitzone Europe/Berlin unbekannt“:** Windows hat keine IANA-Zeitzonendatenbank. Abhilfe: `python -m pip install tzdata` (steht in `requirements.txt`).
- **„Executable doesn't exist“ / „Chromium fuer Playwright fehlt“:** `python -m playwright install chromium` fehlt oder wurde für eine andere Playwright-Version ausgeführt. Nach einem Update von playwright den Befehl erneut ausführen.
- **„pdftoppm (Poppler) fehlt im PATH“:** Poppler installieren und ein neues Terminal öffnen. winget legt `pdftoppm.exe` unter `%LOCALAPPDATA%\Microsoft\WinGet\Packages\...\poppler-*\Library\bin` ab.
- **Mehrere Python-Installationen:** `python` kann auf den Microsoft-Store-Platzhalter zeigen. `where.exe python` zeigt die Reihenfolge. Pakete immer mit `python -m pip` für genau das Python installieren, das auch die Skripte ausführt.
- **Zeichenkodierung:** Beide Skripte schreiben ihre Ausgabe als UTF-8, auch wenn sie in eine Datei oder Pipe umgeleitet wird.
