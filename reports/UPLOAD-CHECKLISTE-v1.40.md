---
titel: 'Upload-Checkliste v1.40'
datum: 2026-11-16
---

# Upload-Checkliste v1.40

**Reihenfolge:** erst Upload v1.39 (Paket 476622E7, siehe UPLOAD-CHECKLISTE-v1.39.md), R09 Live-Prüfung und Tag v1.39 auf **907ca58** (nicht auf `main`, dort liegt seit 84ae342 v1.40). Danach dieses Paket.

| Feld | Wert |
|---|---|
| Datei | `output/ftp/relingit-upload-v1.40-2026-11-16-ohne-audio.zip` im Arbeitsklon `C:\dev\relingit` (nicht in Git) |
| SHA-256 | `C41075866B3F824E3B45EFB7B792B74FFBACC3D8DAFACF0C3A73FD5FBDC87537` |
| Größe | 6878484 Byte, 41 Einträge (40 Nutzdateien + Manifest) |
| Gebaut aus | `main` 84ae342 (Merge #41); `./scripts/build-upload.ps1 -OhneAudio`, Exit 0 |
| Prüfung | `pruefe-paket.ps1` Exit 0. Gegen das Prüfpaket D6396E99 (Worktree r86) 4 Dateien „geändert“: lesen.html, anhang.html, story/current/fahrt-zum-kunden.html, story/current/workshop-handout.html; Ursache nur Zeilenenden (Prüfpaket LF, `main`-Checkout CRLF), Inhalt ohne CR gleich (sha256 verglichen) |
| Freigabe | Sichtung 32/32 Ja, G8 v1.40 als Kommentar an PR #41 (Product Owner, 16.11.2026) |

- Gegenüber v1.39 geändert (geprüft 16.11.2026 mit `pruefe-paket.ps1 -Vorgaenger <Paket 476622E7> -ErwartetHash C4107586…`, Exit 0): genau 7 Nutzdateien – `story/current/fahrt-zum-kunden.html`, `story/current/geschichte.pdf`, `story/current/workshop-handout.html`, `story/current/workshop-handout.pdf`, `lesen.html`, `anhang.html`, `assets/js/app.js`; 33 unverändert, 0 entfallen. `ci-check` auf `main` 84ae342 Exit 0.
- Wer nur die Änderungen hochladen will: diese 7 Dateien genügen, wenn v1.39 (476622E7) vorher vollständig live ist.
- Beim Upload die Live-MP3 nicht löschen (Paket ohne Audio).
- Nach dem Upload: R09 für v1.40, Tag v1.40 auf 84ae342.
