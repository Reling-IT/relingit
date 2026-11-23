# Supabase im Betrieb

Diese Anleitung ergänzt [SUPABASE-ANLEITUNG.md](SUPABASE-ANLEITUNG.md) (Einrichtung) und [NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md) (Veröffentlichung). Sie beschreibt, was Supabase auf der Live-Seite steuert, wie man den Stand prüft und was bei Ausfall, Pausierung oder Verlust zu tun ist. Zugangsdaten stehen nie in diesem Repository (siehe [SICHERHEIT.md](SICHERHEIT.md)).

## Was wo steht

| Ort | Inhalt | Wirkung auf der Seite |
|---|---|---|
| FTP (Domainfactory) | `index.html`, `lesen.html`, `anhang.html`, `assets/js`, `assets/css`, `assets/fonts`, `assets/video`, Impressum, Datenschutz | Aussehen, Trailer, Rückfallwerte in `assets/js/app.js` |
| Supabase-Tabelle `story_release` (Zeile `id = current`) | `version`, `display_date`, `page_count` | Zeile „N Seiten · Bernd Marnau · aktualisiert am …“ und Versionsanzeige auf Startseite, `lesen.html` und `anhang.html` |
| Supabase-Speicher, Bucket `story`, Ordner `current` | `geschichte.pdf`, `fahrt-zum-kunden.html`, `workshop-handout.pdf`, `workshop-handout.html` | Links „PDF ansehen“, „PDF herunterladen“, Lesefassung, Handout |

Ein FTP-Upload ändert weder `story_release` noch den Speicher. Die Rückfallwerte in `assets/js/app.js` greifen nur, wenn Supabase nicht antwortet; sie ersetzen den Eintrag nicht.

## Prüfung nach jedem Upload (nur lesen)

Im Arbeitsklon auf dem Stand von `main`:

```powershell
./scripts/publish-release.ps1 -NurPruefen
```

Das Skript (`scripts/live-pruefen.ps1`) liest mit dem öffentlichen Schlüssel aus `assets/js/supabase-config.js` und ohne Cache: `story_release` (Version, Datum, Seitenzahl), die vier Dateien im Speicher `story/current` (SHA-256) und `index.html` sowie `assets/js/app.js` auf dem Webspace. Es vergleicht mit dem lokalen Stand, HTML und JavaScript nach Normalisierung der Zeilenenden (CRLF zu LF). `index.html` und `app.js` werden ohne die Rückfallwerte verglichen (Version, Datum, Seitenzahl), weil ein Release, das nur die Buchfassung ändert, keinen FTP-Upload braucht. Das Skript warnt, wenn der lokale Stand nicht `origin/main` ist oder lokale Änderungen hat. Ausgabe ist eine Tabelle Soll, Ist, Ergebnis. Exit 0 heißt alles gleich, 1 Abweichung, 2 nicht abrufbar oder Sollwerte widersprüchlich. Es schreibt nichts.

Die Sollwerte für die Upload-Checkliste gibt `./scripts/live-pruefen.ps1 -NurSollwerte` ohne Netz als Markdown aus; `publish-release.ps1` hängt sie an seine Ausgabe an. Vorlage: [vorlagen/UPLOAD-CHECKLISTE.md](vorlagen/UPLOAD-CHECKLISTE.md).

Von Hand ergänzend:

1. Startseite im privaten Browserfenster öffnen (oder hart neu laden): Version, Seitenzahl und Datum sichten.
2. Links „PDF ansehen“, „PDF herunterladen“ und Handout öffnen: Fassung und Seitenzahl sichten.

Das Supabase-Dashboard zeigt im Speicher Größe und Änderungsdatum, aber keinen SHA-256; für den Inhaltsvergleich gilt die Ausgabe von `-NurPruefen`.

Zeigt die Seite Altes, zuerst privates Fenster und hartes Neuladen, dann Supabase prüfen.

## Schreibweg

Standardweg ist der Admin-Bereich (`admin.html`) durch den Product Owner: Anmeldung mit Administratorkonto und Authenticator-Code, dann Versionsangaben und Dateien ([NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md), Abschnitt 5). Die Skripte im Repository schreiben nicht nach Supabase.

Ausnahme, nur nach ausdrücklicher Freigabe des Product Owners für den einzelnen Fall: Schreiben mit einem Secret Key aus einer lokalen Sitzung (Regeln im Abschnitt „Zugangsdaten für KI-Sitzungen und Skripte“). Ablauf: `-NurPruefen` und Tabelle alt/neu vorlegen, Freigabe abwarten, unmittelbar vorher prüfen, dass der Ist-Stand noch der vorgelegte ist, schreiben (nur `story_release` id=current und die vier Dateien, Inhaltstypen wie `assets/js/admin.js`), danach `-NurPruefen` und Ergebnis mit Zeitstempel im Protokoll. Ein Schreibmodus im Skript ist bewusst nicht vorgesehen.

## Projekt pausiert oder nicht erreichbar

Kostenlose Supabase-Projekte werden nach etwa sieben Tagen ohne Aktivität pausiert (Stand November 2026; Bedingungen im Supabase-Dashboard prüfen). Im Dashboard steht dann „Project paused“ mit der Schaltfläche **Restore**. Eine Wiederherstellung ist für einen begrenzten Zeitraum möglich (etwa 90 Tage laut Dashboard-Hinweis); danach nicht mehr.

1. Dashboard öffnen und den Status lesen (aktiv, pausiert, gelöscht, Anmeldeproblem).
2. Pausiert: **Restore** und warten, bis das Projekt wieder „Active“ zeigt. Daten und Speicherdateien bleiben erhalten.
3. Danach Startseite im privaten Fenster, Admin-Anmeldung und Prüfung (oben) durchführen.

## Neuanlage nach Verlust

Nur wenn das Projekt gelöscht oder nicht wiederherstellbar ist:

1. Neues Projekt anlegen und `supabase/setup.sql` im SQL Editor ausführen (legt `story_release`, `reader_feedback`, `feedback_rate_limits`, `admin_users`, den Bucket `story` und die Zugriffsregeln an), danach `supabase/tests/security-checks.sql` (erwartet: **Success. No rows returned**).
2. Administratorkonto und Authenticator-Code einrichten ([SUPABASE-ANLEITUNG.md](SUPABASE-ANLEITUNG.md), Abschnitt B), Edge Function `submit-feedback` und ihr Secret neu setzen (Abschnitt H).
3. Neue Projekt-URL und neuen Publishable Key in `assets/js/supabase-config.js` eintragen (Pull Request, grüne CI) und die Datei per FTP hochladen. Nie einen Secret- oder Service-Role-Key eintragen.
4. Im Admin-Bereich Versionsangaben, HTML, PDF und Handout aus `story/current` auf `main` neu hochladen ([NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md), Abschnitt 5).

Verloren gehen bei einer Neuanlage: der Eintrag `story_release` (neu setzen), die Speicherdateien (aus dem Repository wiederherstellbar), bisheriges Leser-Feedback (nur mit Export wiederherstellbar) und das Administratorkonto.

## Sicherung

- Buchfassungen liegen im Repository (`story/current`, `source/`) und sind dort wiederherstellbar.
- Leser-Feedback (`reader_feedback`) liegt nur in Supabase. Bei Bedarf im Table Editor als CSV exportieren und außerhalb des Repositorys ablegen (enthält Texte von Lesenden).
- Den Stand von `story_release` (Version, Datum, Seitenzahl) nennt jede Upload-Checkliste.

## Wer darf was

- Lesen: jeder (`story_release` ist öffentlich lesbar, der Speicher-Bucket `story` ist öffentlich).
- Schreiben in `story_release` und in den Speicher: nur angemeldete Administratoren (Row Level Security, `is_story_admin()`). Der Admin-Bereich verlangt zusätzlich den Authenticator-Code.
- Ein Secret- oder Service-Role-Key umgeht diese Regeln. Er darf nur kurzzeitig und nur lokal verwendet werden (siehe unten) und wird danach gedreht.

## Zugangsdaten für KI-Sitzungen und Skripte

- Zugangsdaten gehören nie in Chat, Dateien, Berichte, Commits oder Protokolle. Cloud-Sitzungen erhalten keine Zugangsdaten.
- Für einen lokalen Lauf (Claude Code auf dem Rechner des Owners): Key nur als Umgebungsvariable in der PowerShell-Sitzung setzen, aus der gestartet wird, z. B. mit `Read-Host -AsSecureString`, nie in `$PROFILE` oder einer `.env` im Repository.
- Skripte lesen den Wert nur aus der Umgebung, geben ihn nie aus (auch nicht gekürzt) und stoppen mit einer Meldung, wenn er fehlt.
- Schreiben in Produktion nur nach ausdrücklicher Freigabe des Owners im Auftrag, begrenzt auf `story_release` (`id = current`) und die vier Dateien in `story/current`; vorher lesen und eine Tabelle alt/neu zeigen, nachher erneut lesen. Nichts löschen.
- Danach Variable entfernen (`Remove-Item Env:<NAME>`) und den Schlüssel im Dashboard drehen oder löschen.
