# Die Fahrt zum Kunden

Landingpage, Online-Lesefassung und Workshop-Handout zur fortlaufenden Kurzgeschichte von Bernd Marnau.

Die öffentliche Landingpage wird manuell per FTP bei DomainFactory gehostet. GitHub dient als Quellcode-Repository und CI-Plattform, führt aber kein Deployment aus. Supabase übernimmt Leserfeedback, Versionsmetadaten sowie die jeweils aktuelle HTML- und PDF-Fassung.

## Projektstruktur

- `assets/css`: gemeinsame Gestaltung und Rechtseiten-Stile
- `assets/audio`: lokal ausgelieferter, KI-generierter Podcast (MP3 nicht im Repository, versioniert ist nur `SHA256SUMS.txt`, siehe `docs/PODCAST.md`)
- `assets/img`: RelingIT-Logo, Browser-Symbol und Podcast-Cover
- `assets/js`: öffentliche Logik, PDF-Ansicht, Administration und Supabase-Konfiguration
- `archive`: ausschließlich lokales Archiv für nicht mehr aktive Dateien
- `story/current`: aktuell veröffentlichte lokale Rückfallfassung; entspricht dem Supabase-Pfad `story/current`
- `docs`: redaktionelle, Supabase- und FTP-Anleitungen; Repo-Struktur und Release-Ablauf als Diagramme in [docs/ABLAUF.md](docs/ABLAUF.md)
- `docs/vorlagen`: Kapitel-Vorlage und Einbau-Checkliste für neue Geschichten
- `scripts`: lokale und CI-Prüfungen, Freigabeprüfung (`freigabe-pruefen.ps1`) und lokale Vorschau (`vorschau.ps1`), siehe [docs/FREIGABE.md](docs/FREIGABE.md)
- `scripts/pdf`: freiwillige Werkzeuge zum Erzeugen und Prüfen der PDF (siehe [docs/PDF-ERZEUGEN.md](docs/PDF-ERZEUGEN.md))
- `source`: ursprüngliche Quelldateien, die nicht veröffentlicht werden
- `supabase`: Datenbank, RLS, Edge Function und Sicherheitsprüfungen
- `tests`: Pester-Tests für `ci-check.ps1`, `publish-release.ps1`, `build-upload.ps1`, `freigabe-pruefen.ps1` und `vorschau.ps1`
- Projektstamm: öffentlich aufrufbare Seiten mit `.htaccess`, README, Lizenz, Wartungsskript sowie `.gitignore` und `.gitattributes`

Inhalte unter `archive/` werden nicht zu GitHub übertragen und dürfen nicht auf den DomainFactory-Webspace kopiert werden. Die genaue Ablageregel steht in `archive/README.md`.

## Neue Version veröffentlichen

Standardweg für eine neue Buchfassung ist der Admin-Bereich `admin.html` mit Supabase. FTP ist nur für Dateien nötig, die nicht über den Admin-Bereich gehen: `index.html`, `assets/js`, `assets/css`, `assets/fonts` (sobald vorhanden), `impressum.html`, `datenschutz.html` und weitere Seiten (vollständige Regel: [FTP-Fall in docs/NEUE-GESCHICHTE.md](docs/NEUE-GESCHICHTE.md#ftp-fall)). Der vollständige Ablauf mit Befehlen und erwarteten Ergebnissen steht in `docs/NEUE-GESCHICHTE.md`.

Vor jeder Freigabe durchläuft die Version die Tore G1 Code bis G8 Freigabe Bernd. Ohne bestandene bzw. von Bernd erteilte Tore gibt es keinen Merge, keinen Tag und keinen Upload. Prozess, Tore und Nachweise: [docs/FREIGABE.md](docs/FREIGABE.md) (maschinenlesbar: [docs/freigabe.yaml](docs/freigabe.yaml)); Prüfung mit `./scripts/freigabe-pruefen.ps1`.

Das Repository liegt kanonisch unter `Reling-IT/relingit`. Unter dem persönlichen Konto `bmarnau` darf kein Repository `relingit` neu angelegt werden.

### Empfohlener lokaler Ablauf

1. Die neue HTML-Datei immer als `source/fahrt-zum-kunden.html` ablegen.
2. Die passende PDF immer als `source/Die-Fahrt-zum-Kunden.pdf` ablegen.
3. Keine Dateien manuell nach `story/current` kopieren und kein ZIP von Hand bauen.
4. Im Projektordner nur diesen Befehl ausführen:

```powershell
./scripts/publish-release.ps1
```

Das Skript übernimmt Version und Datum aus der HTML-Datei, verlangt den gleichen
Stand im letzten Eintrag der Versionshistorie, liest die Seitenzahl automatisch
aus der PDF, aktualisiert die lokale LP (Rückfallwert in `app.js`, `lesen.html` und die Seitenzahl in `index.html`) und
erstellt anschließend das geprüfte FTP-Paket. `source` und `story/current`
müssen danach für HTML und PDF bytegenau übereinstimmen. Bei einer Abweichung
wird die Veröffentlichung abgebrochen. Bereits vorhandene FTP-Pakete werden
vorher automatisch ins lokale Archiv verschoben; in `output/ftp` bleibt damit
immer nur die aktuelle Ausgabe. Am Ende gibt das Skript Version, Datum,
Seitenzahl und die im Admin-Bereich auszuwählenden Dateien aus und meldet, ob
das Handout geändert ist und ob ein FTP-Upload nötig ist.

Die PDF lässt sich lokal aus der HTML-Quelle erzeugen und auf Layoutfehler prüfen
(`scripts/pdf/render_story_pdf.py`, `scripts/pdf/verify_layout.py`). Einrichtung,
Befehle und bekannte Stolpersteine stehen in [docs/PDF-ERZEUGEN.md](docs/PDF-ERZEUGEN.md).
Diese Werkzeuge sind freiwillig und keine Voraussetzung für `ci-check.ps1`.
`publish-release.ps1` braucht dagegen `pdfinfo` und `pdftotext` aus Poppler
(Einrichtung: [docs/PDF-ERZEUGEN.md](docs/PDF-ERZEUGEN.md), Schritt 4).

Die Pester-Tests für `ci-check.ps1`, `publish-release.ps1`, `build-upload.ps1`, `freigabe-pruefen.ps1` und `vorschau.ps1` laufen im Projektordner mit `Invoke-Pester -Path tests` (Zielversion Pester 5, läuft auch mit dem in Windows mitgelieferten Pester 3.4; die PDF-Tests brauchen `pdftotext`). Sie nutzen nur kleine Fixtures unter `tests/fixtures` in einem temporären Mini-Projekt.

### Veröffentlichung über Supabase

1. Den geschützten Bereich `admin.html` aufrufen und mit dem Supabase-Administratorkonto anmelden.
2. Den sechsstelligen Code der Authenticator-App bestätigen.
3. Version, Datum und Seitenzahl eintragen.
4. Neue PDF und HTML-Lesefassung auswählen.
5. Falls geändert, das Handout zusätzlich als HTML und PDF auswählen.
6. Veröffentlichen und anschließend die öffentliche Landingpage prüfen.

`publish-release.ps1` baut das FTP-Paket bereits mit. `build-upload.ps1` ist nur
nötig, wenn ohne neue Buchfassung ein Paket gebaut werden soll (zum Beispiel nach
einer Änderung am Impressum). Dazu im Projektordner ausführen:

```powershell
./scripts/build-upload.ps1
```

Der Paketbau prüft verbindlich, dass Versionsnummer und Datum in der lokalen
Fallback-Konfiguration, der Leseansicht und der HTML-Geschichte übereinstimmen.
Das ZIP enthält außerdem `UPLOAD-MANIFEST.txt` mit Version, Datum und
SHA-256-Prüfsummen. Nach dem Packen wird das ZIP erneut geöffnet und jede
enthaltene Nutzdatei bytegenau mit ihrer aktuellen Quelle verglichen. Ein
bereits vorhandenes Paket wird nicht überschrieben;
für eine weitere Ausgabe kann beispielsweise `-Suffix r2` verwendet werden.
Für Textkorrekturen ohne neue Podcast-Folgen baut `./scripts/build-upload.ps1 -OhneAudio`
ein Paket ohne die rund 74 MB MP3 (Name endet auf `-ohne-audio`, Live-MP3 beim
Upload nicht löschen). Ohne den Schalter müssen die MP3 lokal vorliegen und zu
`assets/audio/SHA256SUMS.txt` passen. Die Live-MP3 lassen sich ohne Download mit
`./scripts/pruefe-podcast-live.ps1` prüfen (HTTP HEAD, siehe `docs/PODCAST.md`).

Supabase ersetzt die Dateien unter stabilen Adressen und aktualisiert die Versionsangaben. Das Handout liegt dauerhaft unter `workshop-handout.html` und `workshop-handout.pdf`. Für eine neue Fortsetzung ist deshalb kein DomainFactory-Upload nötig. Per FTP zu DomainFactory gehen nur geänderte Dateien, die nicht über den Admin-Bereich laufen (siehe [Neue Version veröffentlichen](#neue-version-veröffentlichen)).

## Rückmeldungen mit Supabase

1. Im Supabase-Dashboard den SQL Editor öffnen und `supabase/setup.sql` ausführen.
2. In `assets/js/supabase-config.js` die Project URL und den öffentlichen Publishable Key eintragen.
3. Niemals einen Secret- oder Service-Role-Key in diese Website eintragen.

Anonyme Besucher dürfen keine Feedbacktabellen direkt verwenden. Rückmeldungen
laufen ausschließlich über eine Supabase Edge Function mit Plausibilitäts- und
Rate-Limit-Prüfung. Leser können vorhandene Einträge weder lesen noch ändern
oder löschen. Das Formular fragt keine Kontaktdaten ab. Einrichtung und
Restrisiken stehen in [docs/SICHERHEIT.md](docs/SICHERHEIT.md).

## Lokale Vorschau

Die Website ist statisch und kann mit jedem lokalen Webserver ausgeliefert werden. Einstiegspunkt ist `index.html`.

Für die Sichtung vor einer Freigabe startet `./scripts/vorschau.ps1` eine Kopie der öffentlichen Dateien aus dem aktuellen Zweig in einem temporären Ordner außerhalb des Repositorys, mit einem Webserver nur auf `127.0.0.1` und ohne Supabase-Zugriff (Beenden mit Strg+C). Details: [docs/FREIGABE.md](docs/FREIGABE.md#2-lokale-vorschau).

## Lokale Arbeitskopie aktuell halten

Dieses Verzeichnis verfolgt `origin/main` des GitHub-Repositorys. Vor der Arbeit `repo-aktualisieren.ps1` per Rechtsklick **Mit PowerShell ausführen** starten. Das Skript verwendet nur einen Fast-Forward-Pull und stoppt bei lokalen, noch nicht gesicherten Änderungen, damit nichts überschrieben wird.

Nach eigenen Änderungen werden diese zuerst committed und anschließend zu GitHub gepusht. Erst nach dem ersten Commit der hier neu erstellten Dateien ist die Arbeitskopie wieder vollständig sauber und kann mit dem Aktualisierungsskript synchronisiert werden.

## Continuous Integration

GitHub Actions führt bei jedem Push auf `main`, bei Pull Requests und manuell die Workflow-Datei `.github/workflows/ci.yml` aus. Der Job heißt „Website prüfen“ im Workflow „Website CI“. Geprüft werden Pflichtdateien, die Übereinstimmung von Versionsnummer, Veröffentlichungsdatum und Seitenzahl, die Vollständigkeit der Buchquelle (Deckblatt, Inhaltsverzeichnis, Personenliste, Versionshistorie), Podcast-Dateien und Quellenangabe, lokale HTML-Verweise, doppelte IDs, PDF-Kennung, JavaScript-Syntax, Git-Whitespace, Geheimnismuster sowie wesentliche MFA-, RLS- und Rate-Limit-Invarianten. Der öffentliche Publishable Key ist zulässig; Secret- und Service-Role-Keys sind es nicht. `main` darf nur über einen Pull Request mit erfolgreicher CI geändert werden.
