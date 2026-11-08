# Neue Geschichte veröffentlichen

Diese Anleitung beschreibt den vollständigen Weg von einer neuen Fortsetzung bis zur Live-Seite. Standardweg ist der Admin-Bereich `admin.html` mit Supabase (Entscheidung des Owners vom 06.11.2026). Für die Buchfassung selbst wird FTP nicht benötigt; FTP ist nur für die im [FTP-Fall](#ftp-fall) genannten Dateien nötig.

Das Repository liegt kanonisch unter `Reling-IT/relingit`. Unter dem persönlichen Konto `bmarnau` darf kein Repository `relingit` neu angelegt werden.

## 1. Schreiben

Die Fortsetzung wird direkt in `source/fahrt-zum-kunden.html` geschrieben. Aufbau, Platzhalter und Pflichtstellen stehen in `docs/vorlagen/KAPITEL-VORLAGE.html.txt` und `docs/vorlagen/EINBAU-CHECKLISTE.md`.

Pflicht bei jeder neuen Version:

- Version und Datum in `div.cover-meta` erhöhen.
- `p.cover-whatsnew` auf „Neu in vX.YY“ der neuen Version setzen.
- Neues Kapitel in `nav.cover-toc` eintragen.
- Neue Zeile am Ende der Versionshistorie (`#kap-versionen`) mit derselben Version und demselben Datum.

Erwartetes Ergebnis: Die Datei öffnet im Browser ohne Fehler, das neue Kapitel ist über das Inhaltsverzeichnis erreichbar.

## 2. Einbauen und PDF erzeugen

Die passende PDF wird aus der HTML-Datei erzeugt und als `source/Die-Fahrt-zum-Kunden.pdf` abgelegt. Keine Dateien von Hand nach `story/current` kopieren.

```powershell
python scripts/pdf/render_story_pdf.py --out source/Die-Fahrt-zum-Kunden.pdf
```

Einrichtung, Layoutprüfung und Stolpersteine stehen in [docs/PDF-ERZEUGEN.md](PDF-ERZEUGEN.md). Für Schritt 3 muss Poppler installiert sein (`pdfinfo` für die Seitenzahl, `pdftotext` für die PDF-Version), siehe dort Schritt 4.

Erwartetes Ergebnis: In `source/` liegen genau die neue HTML-Datei und die dazu passende PDF.

## 3. Bauen und prüfen

```powershell
./scripts/publish-release.ps1
```

Das Skript prüft die Buchquelle (Version, Datum, Versionshistorie, Inhaltsverzeichnis, Personenliste, Deckblatt-Boxen), liest die Seitenzahl aus der PDF, prüft die Version auf dem PDF-Deckblatt gegen die HTML-Quelle, aktualisiert `story/current` und die Rückfallwerte, ruft `scripts/ci-check.ps1` auf und baut das FTP-Paket unter `output/ftp`.

Erwartetes Ergebnis: Die Ausgabe endet mit

```text
OK: Version X.YY vom <Datum> mit <N> Seiten veröffentlicht und paketiert.

=== Übergabe an den Admin-Bereich (admin.html, Standardweg) ===
Versionsnummer:    X.YY
Angezeigtes Datum: <Datum>
Seitenzahl:        <N>
HTML-Lesefassung:  ...\source\fahrt-zum-kunden.html
PDF:               ...\source\Die-Fahrt-zum-Kunden.pdf
Vergleichsstand:   <Commit des letzten Releases>
Handout geändert:  ja/nein
FTP-Upload nötig:  ja/nein
```

Je nach Stand kommen weitere Zeilen hinzu:

```text
Handout geändert:  ja. Im Admin-Bereich beide Dateien als Paar auswählen:
                   ...\story\current\workshop-handout.html
                   ...\story\current\workshop-handout.pdf
FTP-Upload nötig:  ja, geändert: <Dateien>
                   Paket: output/ftp (siehe oben). Upload erfolgt von Hand.
Nur Rückfallwerte: <Dateien> (Version, Datum, Seitenzahl).
Hinweis:           weitere öffentliche Dateien geändert: <Dateien>. ...
```

- „Nur Rückfallwerte“: Die Dateien unterscheiden sich nur in den Werten, die das Skript selbst setzt. Die Live-Seite liest diese Werte aus Supabase; ein FTP-Upload ist dafür nicht nötig.
- „Hinweis: weitere öffentliche Dateien geändert“: Diese Dateien gehen nicht über den Admin-Bereich und müssen ebenfalls per FTP hochgeladen werden (siehe [FTP-Fall](#ftp-fall)).

**PDF-Version:** Vor dem Kopieren nach `story/current` liest das Skript mit `pdftotext` (Poppler) die erste Seite von `source/Die-Fahrt-zum-Kunden.pdf` und vergleicht die dort stehende „Version X.YY“ mit dem Deckblatt der HTML-Quelle. Weichen beide ab, bricht es ab und nennt beide Versionen, zum Beispiel `PDF passt nicht zur HTML-Quelle: source/Die-Fahrt-zum-Kunden.pdf trägt Version 1.37, source/fahrt-zum-kunden.html Version 1.38`. Dann die PDF aus der aktuellen HTML neu erzeugen (`docs/PDF-ERZEUGEN.md`). Fehlt `pdftotext`, bricht das Skript ebenfalls ab. Nur im Notfall lässt der Schalter `-OhnePdfVersionspruefung` den Lauf mit Warnung weiterlaufen; das PDF-Deckblatt ist dann von Hand zu prüfen.

Diese Werte werden in Schritt 5 gebraucht. Bricht das Skript mit einer roten Fehlermeldung ab (bei `ci-check.ps1`: Liste der Fehler, danach „CI-Prüfung mit N Fehler(n) abgebrochen“), die genannte Stelle in der Buchquelle korrigieren und erneut starten.

Der Vergleich für Handout und FTP läuft standardmäßig gegen den letzten Commit, der `story/current/fahrt-zum-kunden.html` geändert hat. Ein anderer Stand lässt sich mit `-VergleichMit <Commit oder Tag>` angeben.

## 4. Per Branch und Pull Request veröffentlichen

```powershell
git switch -c geschichte-vX.YY
git add source story/current assets/js/app.js lesen.html index.html
git commit -m "Geschichte vX.YY"
git push -u origin geschichte-vX.YY
gh pr create --repo Reling-IT/relingit --base main
```

Erwartetes Ergebnis: Der Pull Request zeigt die Prüfung „Website prüfen“ grün. Gemergt wird nur durch den Owner. Nie direkt auf `main` pushen.

## 5. Über den Admin-Bereich hochladen

1. Auf der veröffentlichten Website `admin.html` öffnen.
2. Mit dem Supabase-Administratorkonto anmelden und den Code der Authenticator-App bestätigen.
3. Versionsnummer, angezeigtes Datum und Seitenzahl aus der Ausgabe von Schritt 3 eintragen.
4. HTML-Lesefassung `source/fahrt-zum-kunden.html` und PDF `source/Die-Fahrt-zum-Kunden.pdf` auswählen. Andere Dateinamen lehnt der Admin-Bereich ab.
5. Nur wenn die Ausgabe „Handout geändert: ja“ meldet: `story/current/workshop-handout.html` und `story/current/workshop-handout.pdf` als Paar auswählen.
6. Veröffentlichen.

Erwartetes Ergebnis: Die öffentliche Landingpage zeigt in einem privaten Browserfenster die neue Version, das neue Datum und die neue Seitenzahl; `lesen.html` zeigt das neue Kapitel.

### FTP-Fall

Über den Admin-Bereich gehen nur die Buchfassung (HTML und PDF), das Handout und die Versionsangaben. Alle anderen geänderten öffentlichen Dateien kommen nur per FTP live: `index.html`, `assets/js`, `assets/css`, `assets/fonts` (sobald vorhanden), `impressum.html`, `datenschutz.html` und weitere Seiten und Dateien, die nicht über den Admin-Bereich gehen (`lesen.html`, `pdf.html`, `handout.html`, `handout-pdf.html`, `admin.html`, `.htaccess`, `assets/img`, `assets/audio`).

Schritt 3 meldet Änderungen an `index.html`, `assets/js`, `impressum.html` und `datenschutz.html` als „FTP-Upload nötig: ja“, die übrigen als „Hinweis: weitere öffentliche Dateien geändert“. In beiden Fällen zusätzlich das Paket aus `output/ftp` nach [docs/DOMAINFACTORY-DEPLOYMENT.md](DOMAINFACTORY-DEPLOYMENT.md#ftp-paket-hochladen) hochladen.

## 6. Podcast

Nur wenn sich der Erzähltext geändert hat: Die Podcast-Fassung mit Google Gemini neu erzeugen. Bei reinen Korrekturen an Metadaten, Versionshistorie oder Layout entfällt dieser Schritt.

Erwartetes Ergebnis: Die neue Podcast-Fassung gibt den aktuellen Erzähltext wieder.
