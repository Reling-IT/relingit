---
titel: 'Upload-Checkliste vX.YY'
datum: JJJJ-MM-TT
---

# Upload-Checkliste vX.YY

Vorlage (R87). Die ausgefüllte Checkliste liegt als `reports/UPLOAD-CHECKLISTE-vX.YY.md` auf `ops/reports`. Werte nicht von Hand abschreiben: Paketangaben aus `scripts/build-upload.ps1` und `scripts/pruefe-paket.ps1`, Sollwerte für Supabase aus `./scripts/live-pruefen.ps1 -NurSollwerte` (auch am Ende der Ausgabe von `publish-release.ps1`).

## FTP-Paket

| Feld | Wert |
|---|---|
| Datei | `output/ftp/relingit-upload-vX.YY-JJJJ-MM-TT[-ohne-audio].zip` (nicht in Git) |
| SHA-256 | aus `build-upload.ps1` |
| Größe | Byte, Anzahl Einträge |
| Gebaut aus | `main` Commit, Befehl, Exit-Code |
| Prüfung | `pruefe-paket.ps1` Exit-Code, geänderte Dateien gegenüber dem Vorgänger |
| Freigabe | Sichtung, G8 als PR-Kommentar |

FTP ist nötig, wenn sich Startseite, JavaScript, Impressum, Datenschutz oder weitere Webspace-Dateien geändert haben (Ausgabe von `publish-release.ps1`, „FTP-Upload nötig“). Beim Upload die Live-MP3 nicht löschen, wenn das Paket ohne Audio gebaut ist.

<!-- Hier die Ausgabe von ./scripts/live-pruefen.ps1 -NurSollwerte einfügen.
     Sie beginnt mit "## Supabase und Speicher" und enthält Reihenfolge,
     Sollwerte für story_release und Größe und SHA-256 der vier Dateien. -->

## Nach dem Upload

- [ ] 1. FTP-Paket hochgeladen (falls nötig)
- [ ] 2. Admin-Bereich: Eintrag `story_release` (Version, Datum, Seitenzahl wie oben)
- [ ] 3. Admin-Bereich: Dateien in `story/current` (Buchfassung HTML und PDF, Handout nur bei Änderung als Paar)
- [ ] 4. `./scripts/publish-release.ps1 -NurPruefen` mit Exit 0, Ausgabe mit Zeitstempel im R09-Bericht
- [ ] 5. Startseite im privaten Fenster gesichtet
- [ ] 6. Danach Tag vX.YY auf den Commit, aus dem das Paket gebaut wurde (nur mit Freigabe)
