# Supabase im Betrieb

Diese Anleitung ergänzt [SUPABASE-ANLEITUNG.md](SUPABASE-ANLEITUNG.md) (Einrichtung) und [NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md) (Veröffentlichung). Sie beschreibt, was Supabase auf der Live-Seite steuert, wie man den Stand prüft und was bei Ausfall, Pausierung oder Verlust zu tun ist. Zugangsdaten stehen nie in diesem Repository (siehe [SICHERHEIT.md](SICHERHEIT.md)).

## Was wo steht

| Ort | Inhalt | Wirkung auf der Seite |
|---|---|---|
| FTP (Domainfactory) | `index.html`, `lesen.html`, `anhang.html`, `assets/js`, `assets/css`, `assets/fonts`, `assets/video`, Impressum, Datenschutz | Aussehen, Trailer, Rückfallwerte in `assets/js/app.js` |
| Supabase-Tabelle `story_release` (Zeile `id = current`) | `version`, `display_date`, `page_count` | Zeile „N Seiten · Bernd Marnau · aktualisiert am …“ und Versionsanzeige |
| Supabase-Speicher, Bucket `story`, Ordner `current` | `geschichte.pdf`, `fahrt-zum-kunden.html`, `workshop-handout.pdf`, `workshop-handout.html` | Links „PDF ansehen“, „PDF herunterladen“, Lesefassung, Handout |

Ein FTP-Upload ändert weder `story_release` noch den Speicher. Die Rückfallwerte in `assets/js/app.js` greifen nur, wenn Supabase nicht antwortet; sie ersetzen den Eintrag nicht.

## Prüfung nach jedem Upload (nur lesen)

1. Startseite im privaten Browserfenster öffnen (oder hart neu laden): Version, Seitenzahl und Datum müssen den Werten aus der Ausgabe von `publish-release.ps1` entsprechen.
2. Links „PDF ansehen“, „PDF herunterladen“ und Handout öffnen: Fassung und Seitenzahl prüfen.
3. Im Supabase-Dashboard (Table Editor) `story_release` und im Speicher `story/current` ansehen. Hash, Größe und Änderungsdatum der vier Dateien müssen zu den Dateien auf `main` passen.
4. `index.html` und `assets/js/app.js` auf dem Server gegen `main` vergleichen. Zeilenenden vorher auf LF normalisieren, sonst meldet ein Hash-Vergleich eine falsche Abweichung.

Zeigt die Seite Altes, zuerst privates Fenster und hartes Neuladen, dann Supabase prüfen.

## Tarif

Seit dem 23.11.2026 liegt das Projekt in einer Organisation mit Pro-Tarif (Angabe des Owners). Der Tarif hängt an der Organisation, nicht am Konto: Nach einem Wechsel oder einer Neuanlage zuerst prüfen, in welcher Organisation das Projekt liegt (Dashboard, Organisation, Billing). Leistungen und Fristen des Tarifs (Pausierung, Backups, Aufbewahrung) stehen in der aktuellen Supabase-Dokumentation und im Dashboard; diese Anleitung nennt sie nicht verbindlich.

## Projekt pausiert oder nicht erreichbar

Projekte im kostenlosen Tarif werden nach etwa sieben Tagen ohne Aktivität pausiert (Stand November 2026; Bedingungen im Dashboard prüfen); im Pro-Tarif ist das laut Supabase nicht der Fall. Ist die Seite trotzdem nicht erreichbar, im Dashboard den Status lesen: Bei „Project paused“ steht die Schaltfläche **Restore** bereit. Eine Wiederherstellung ist für einen begrenzten Zeitraum möglich (etwa 90 Tage laut Dashboard-Hinweis); danach nicht mehr.

1. Dashboard öffnen und den Status lesen (aktiv, pausiert, gelöscht, Anmeldeproblem).
2. Pausiert: **Restore** und warten, bis das Projekt wieder „Active“ zeigt. Daten und Speicherdateien bleiben erhalten.
3. Danach Startseite im privaten Fenster, Admin-Anmeldung und Prüfung (oben) durchführen.

## Neuanlage nach Verlust

Nur wenn das Projekt gelöscht oder nicht wiederherstellbar ist:

1. Neues Projekt anlegen und `supabase/setup.sql` im SQL Editor ausführen (legt `story_release`, `reader_feedback`, `admin_users`, den Bucket `story` und die Zugriffsregeln an), danach `supabase/tests/security-checks.sql` (erwartet: **Success. No rows returned**).
2. Administratorkonto und Authenticator-Code einrichten ([SUPABASE-ANLEITUNG.md](SUPABASE-ANLEITUNG.md), Abschnitt B), Edge Function `submit-feedback` und ihr Secret neu setzen (Abschnitt H).
3. Neue Projekt-URL und neuen Publishable Key in `assets/js/supabase-config.js` eintragen (Pull Request, grüne CI) und die Datei per FTP hochladen. Nie einen Secret- oder Service-Role-Key eintragen.
4. Im Admin-Bereich Versionsangaben, HTML, PDF und Handout aus `story/current` auf `main` neu hochladen ([NEUE-GESCHICHTE.md](NEUE-GESCHICHTE.md), Abschnitt 5).

Verloren gehen bei einer Neuanlage: der Eintrag `story_release` (neu setzen), die Speicherdateien (aus dem Repository wiederherstellbar), bisheriges Leser-Feedback (nur mit Export wiederherstellbar) und das Administratorkonto.

## Sicherung

- Im Pro-Tarif legt Supabase tägliche Backups der Datenbank an. Laut Supabase-Dokumentation ([Database Backups](https://supabase.com/docs/guides/platform/backups), abgerufen am 24.11.2026) sind im Pro-Tarif die Backups der letzten 7 Tage abrufbar. Am 23.11.2026 zeigte das Dashboard (Database, Backups) acht tägliche Backups vom 16. bis 23.11. (Auftrag R92). Den aktuellen Stand im Dashboard prüfen.
- Die Datenbank-Backups enthalten keine Dateien aus dem Speicher (Storage), nur deren Metadaten. Ein wiederhergestelltes Backup bringt gelöschte Speicher-Dateien nicht zurück (gleiche Quelle). Für den Bucket `story` liegt das Original im Repository (`story/current`, siehe nächster Punkt). Die Backups ersetzen keinen eigenen Export für Daten, die nur in Supabase liegen.
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
