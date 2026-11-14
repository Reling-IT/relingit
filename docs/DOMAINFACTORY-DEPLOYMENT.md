# Manueller Upload zu DomainFactory

Die Landingpage wird bewusst manuell per FTP auf den DomainFactory-Webspace kopiert. GitHub führt nur die automatischen Qualitätsprüfungen aus und nimmt kein Deployment vor.

Die Datei `.htaccess` muss ebenfalls in das Verzeichnis `relingit` übertragen werden. Sie erzwingt HTTPS, verhindert Verzeichnislisten und setzt die Sicherheitsheader der Website.

## Einmaliger Erst-Upload

Folgende Dateien und Ordner in das Zielverzeichnis der Domain kopieren:

- `index.html`
- `.htaccess`
- `lesen.html`
- `anhang.html`
- `handout.html`
- `handout-pdf.html`
- den vollständigen Ordner `assets`
- den vollständigen Ordner `story`
- `pdf.html`
- `admin.html`
- `impressum.html`
- `datenschutz.html`

Nicht auf den Webspace gehören `.git`, `.github`, `archive`, `docs`, `ideen`, `output`, `scripts`, `source`, `supabase`, `tests`, `tmp`, `README.md`, `LICENSE`, `.gitignore`, `.gitattributes` und `repo-aktualisieren.ps1`. Am sichersten ist es, nur den Inhalt des FTP-Pakets zu übertragen (siehe [FTP-Paket hochladen](#ftp-paket-hochladen)).

Die vier Podcast-MP3 unter `assets/audio` liegen nicht im Repository (das Cover ist seit R36 versioniert). Vor dem Paketbau aus der lokalen Ablage kopieren, sonst bricht `scripts/build-upload.ps1` ab; alternativ für Textkorrekturen mit `-OhneAudio` bauen und die Live-MP3 beim Upload stehen lassen (siehe `docs/PODCAST.md`).

## Vor dem FTP-Upload

1. Die lokale Arbeitskopie mit `repo-aktualisieren.ps1` aktualisieren.
2. Prüfen, dass die CI auf GitHub grün ist.
3. Nach Sicherheitsänderungen zuerst sämtliche Aktivierungsschritte in
   `docs/SICHERHEIT.md` und `docs/SUPABASE-ANLEITUNG.md` abschließen.
4. In `assets/js/supabase-config.js` kontrollieren, dass Project URL und Publishable Key eingetragen sind.
5. Alle orange markierten Pflichtfelder in Impressum und Datenschutz ersetzen.
6. Die Landingpage lokal testen.
7. Im FTP-Programm die Anzeige versteckter Dateien aktivieren.
8. Die oben genannten Dateien einschließlich `.htaccess` per FTP übertragen, im Regelfall als Inhalt des FTP-Pakets (siehe [FTP-Paket hochladen](#ftp-paket-hochladen)).
9. Die öffentliche Domain in einem privaten Browserfenster prüfen.
10. Mit einem Header-Prüfwerkzeug kontrollieren, dass HSTS, CSP, `nosniff`,
    Referrer-, Frame- und Permissions-Policy tatsächlich ausgeliefert werden.

Bei den Kontrollen am 4. September 2026 und am 8. November 2026 (`curl -sI https://berndmarnau.de/relingit/`) fehlten diese Header auf der Live-Seite.
Wenn `.htaccess` auf dem Server vorhanden ist, bitte DomainFactory nach der
Freischaltung von `mod_headers` beziehungsweise erlaubten Headerdirektiven
fragen.

## FTP-Paket hochladen

`./scripts/publish-release.ps1` (oder `./scripts/build-upload.ps1` ohne neue Buchfassung) legt unter `output/ftp` ein geprüftes Paket `relingit-upload-v<Version>-<Datum>` als Ordner und als ZIP ab.

1. Den Paketordner verwenden oder das ZIP entpacken.
2. Im FTP-Programm die Anzeige versteckter Dateien aktivieren, damit `.htaccess` mitkommt.
3. Den Inhalt des Pakets mit seiner Ordnerstruktur in das Verzeichnis `relingit` des Webspace übertragen. `UPLOAD-MANIFEST.txt` dient nur der lokalen Kontrolle (Version, Datum, SHA-256) und muss nicht übertragen werden.
4. Keine Dateien außerhalb des Pakets hochladen, insbesondere nichts aus `archive` oder `output` selbst.
5. Die öffentliche Domain in einem privaten Browserfenster prüfen.

## Neue Fortsetzung veröffentlichen

Standardweg für eine neue Buchfassung ist der Admin-Bereich (Entscheidung des Owners vom 06.11.2026). Für die Buchfassung selbst ist kein weiterer FTP-Upload erforderlich. Den vollständigen Ablauf mit Befehlen beschreibt `docs/NEUE-GESCHICHTE.md`; die Werte und Dateien für die folgenden Schritte gibt `./scripts/publish-release.ps1` am Ende aus.

1. Auf der veröffentlichten Website `admin.html` öffnen.
2. Mit dem Supabase-Administratorkonto anmelden.
3. Den Code der Authenticator-App bestätigen.
4. Version, Datum und Seitenzahl eintragen.
5. Neue HTML-Lesefassung und PDF auswählen.
6. Falls geändert, das Handout als zusammengehöriges HTML/PDF-Paar auswählen.
7. Veröffentlichen und die öffentliche Landingpage prüfen.

Supabase ersetzt dabei die Dateien unter stabilen Adressen. Ein erneuter FTP-Upload ist nur für geänderte Dateien nötig, die nicht über den Admin-Bereich gehen: `index.html`, `assets/js`, `assets/css`, `assets/fonts` (sobald vorhanden), `impressum.html`, `datenschutz.html` und weitere Seiten. Die vollständige Regel steht im [FTP-Fall in docs/NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md#ftp-fall). `publish-release.ps1` meldet die ersten vier Pfade aus Entscheidung q15 als „FTP-Upload nötig: ja“ und die übrigen als „Hinweis: weitere öffentliche Dateien geändert“; in beiden Fällen das Paket hochladen.

Das Repository liegt kanonisch unter `Reling-IT/relingit`. Unter dem persönlichen Konto `bmarnau` darf kein Repository `relingit` neu angelegt werden.
