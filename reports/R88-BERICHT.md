---
titel: 'R88 Tag v1.40 auf 84ae342'
datum: 2026-11-23
auftrag: R88
tag: v1.40
tag_objekt: 48f17ce033ec060ac6e850b300251c7909ff9289
commit: 84ae3427ea0e81dfb084d326f3da8547ef84c3ac
ergebnis: gesetzt
---

# R88 Tag v1.40

Freigabe: Product Owner im Chat am 23.11.2026 („R88 Tag v1.40 auf 84ae342“). Nur dieser Tag, kein Tag v1.39.

## Prüfung vor dem Tag

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| R09 bestanden | `reports/R09-NACHPRUEFUNG-v1.40.md` | bestanden (14:52 UTC, Wiederholung 14:56 UTC unverändert) |
| Paket = 84ae342 | `Get-FileHash output/ftp/relingit-upload-v1.40-2026-11-16-ohne-audio.zip` | `C41075866B3F824E3B45EFB7B792B74FFBACC3D8DAFACF0C3A73FD5FBDC87537`, wie UPLOAD-CHECKLISTE-v1.40.md |
| Inhalt Paket gegen Commit | jede Nutzdatei im ZIP gegen `git show 84ae342:<pfad>`, CRLF zu LF | 40 Dateien, 0 Abweichungen; Manifest: Version 1.40, 16. November 2026, ohne Audio |
| Tag noch nicht vorhanden | `git ls-remote --tags origin 'v1.4*'` | kein Treffer |

## Tag

```
git tag -s v1.40 84ae3427ea0e81dfb084d326f3da8547ef84c3ac -F <tagtext>
git push origin refs/tags/v1.40
```

Annotiert und signiert (SSH-Signatur), kein Force-Push. Tagtext:

```
Version 1.40

Datum: 16. November 2026
Seiten: 80
Paket: relingit-upload-v1.40-2026-11-16-ohne-audio.zip, SHA-256 C41075866B3F824E3B45EFB7B792B74FFBACC3D8DAFACF0C3A73FD5FBDC87537
Live-Prüfung: R09 bestanden (reports/R09-NACHPRUEFUNG-v1.40.md auf ops/reports)
Freigabe: Product Owner im Chat, 23.11.2026 (R88)
```

Ergebnis `git ls-remote --tags origin v1.40*`:

```
48f17ce033ec060ac6e850b300251c7909ff9289	refs/tags/v1.40
84ae3427ea0e81dfb084d326f3da8547ef84c3ac	refs/tags/v1.40^{}
```

Hinweis: Auf `origin` gibt es außer `v1.40` nur die Tags `v0.1.0` und `podcast-2026-10`; frühere Buchversionen sind nicht getaggt.
