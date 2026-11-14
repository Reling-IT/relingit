# R60: v1.39 rendern (14.11.2026)

Rolle: KI-Sitzung (Claude Code) auf dem Rechner des Product Owners. Auftrag `queue/R60.yaml`, Aufbau nach den Entscheidungen des Product Owners vom 12.11. (ein PR auf main plus #33 und #35) und 14.11. (#27 ebenfalls aufnehmen, Weg A). Ergebnis: Draft-PR #37, Head e31c893, CI grün, CLEAN.

## Aufbau

Worktree `C:\dev\wt\relingit\r60`, Branch `auftrag-R60-v139` von main 69cae23. Nacheinander `git merge --no-ff` (signiert): #27 (fb83613), #33 (ecfbebb), #35 (6cf48a8). Keine Konflikte.

## Nachzüge

| Nr | Stelle | Nachzug | Grundlage |
| --- | --- | --- | --- |
| 1 | Deckblatt, Historienzeile 1.39 | 09.11.2026 → 14.11.2026; `lesen.html`, `anhang.html`, `app.js` per `publish-release.ps1` | Entscheidung 11.11. (Renderdatum) |
| 2 | Begriffsliste „(früher ADF)“ | `color:var(--ink-soft)` statt `opacity:.6` | Entscheidung 12.11. |
| 3 | Versionshistorie 1.39 | zwei Sätze (Sammeleintrag, Kontraste) im bestätigten Wortlaut | Entscheidungen 12.11. |
| 4 | `anhang.html` meta description | „Die sieben Standards“ ergänzt | C2 |
| 5 | `scripts/pdf/requirements.txt` | `playwright==1.64.0`, `pypdf==6.21.0` | Entscheidung 12.11. |
| 6 | `docs/PDF-ERZEUGEN.md` | Prüfschritt Chromium vor dem Rendern | Entscheidung 14.11. |

## Renderumgebung

- `C:\dev\venv-pdf` (vorhanden): Playwright von 1.64.1 auf 1.64.0 gesetzt (Pin); pypdf 6.21.0, numpy 2.4.6, pillow 13.0.0, tzdata 2026.5.
- Chromium vor und nach dem Paketwechsel: Ordner `chromium-1248`, `chromium_headless_shell-1248`, `ffmpeg-1013`, `winldd-1007` unverändert; Startprobe Chromium 156.0.8078.4.
- Im System-Python fehlen Playwright und numpy (am 12.11. als „vorhandene Umgebung“ beschrieben; gemeint war offenbar `venv-pdf`). Nur gemeldet.

## Ergebnis

| Prüfung | Ergebnis |
| --- | --- |
| Render | 80 Seiten, Renderstand 14.11.2026, 09:51 Uhr (MEZ), PDF 1.4 |
| `verify_layout.py --no-render` | OK, alle Seiten |
| `publish-release.ps1 -OhneAudio` | Exit 0; Version 1.39, 14. November 2026, 80 Seiten; Handout geändert: ja (Paar aus #35) |
| `ci-check.ps1` | Exit 0 |
| Pester | 54/54 |
| `pruefe-paket.ps1` gegen v1.38 (2026-11-07) | Exit 0; 38/38 gleich Manifest; 10 geändert, 3 neu, 25 unverändert, 0 entfallen; Hash gleich |
| CI auf #37 | Website prüfen SUCCESS, CLEAN |

Seitenzahl-Tabelle:

| Stelle | Wert |
| --- | --- |
| PDF (`pdfinfo`) | 80 |
| Deckblatt / Startseite / `app.js` (über `publish-release.ps1`) | 80 |
| Bezug R63 (12.11.) | 80 |

Paket (nicht hochgeladen, liegt nur im Worktree unter `output/ftp`): `relingit-upload-v1.39-2026-11-14-ohne-audio.zip`, 4 725 759 Byte, SHA-256 `67E30FE4CE7590E40717E816A95401679B1A91CCFABA5283B1062B8C91FEE00E`. Nicht reproduzierbar (Renderstand, Manifestzeit).

PDF der Geschichte: 2 075 889 Byte, SHA-256 `B776FA4684296D9588BA7F97180E629EB3969250F8821DA698285E2583297202`.

## Hinweise

- `publish-release.ps1` vergleicht für „FTP-Upload nötig“ gegen den letzten Commit, der die Geschichte geändert hat (8ea4c62), nicht gegen den Live-Stand v1.38. Maßgeblich für den Upload ist der Paketvergleich mit `pruefe-paket.ps1` gegen v1.38 (oben).
- Nicht gemacht: Vorher/Nachher-Bilder der Box und der Kontraste (Schritt 3 des Auftrags). Sie sind Teil der Sichtung nach `SICHTUNG-v1.39.md`.
- #27, #33, #35 tragen einen Kommentar „aufgenommen in #37“. Schließen nur mit Freigabe.

## Vorschläge und Ideen (Claude)

Empfehlungen, keine Fakten:

- `publish-release.ps1` einen Schalter `-VergleichMit <Tag v1.38>` beim nächsten Release nutzen lassen, sobald R52 den Tag gesetzt hat; dann stimmt die Liste „FTP-Upload nötig“ mit dem Live-Stand überein.
- `C:\dev\venv-pdf` liegt direkt im Wurzelordner `C:\dev`. Ein fester Ort (z. B. im Benutzerprofil) und ein Hinweis in `docs/PDF-ERZEUGEN.md` würden die Frage „welche Umgebung?“ beantworten.
- Vorher/Nachher-Bilder als kleinen eigenen Schritt der Sichtung führen, mit Seitenangaben aus dem gerenderten PDF.
