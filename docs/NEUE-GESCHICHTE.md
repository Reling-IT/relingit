# Neue Geschichte veröffentlichen

Diese Anleitung beschreibt den vollständigen Weg von einer neuen Fortsetzung bis zur Live-Seite. Standardweg ist der Admin-Bereich `admin.html` mit Supabase (Entscheidung des Owners vom 06.11.2026). FTP wird für eine neue Buchfassung nicht benötigt.

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

Erwartetes Ergebnis: In `source/` liegen genau die neue HTML-Datei und die dazu passende PDF.

## 3. Bauen und prüfen

```powershell
./scripts/publish-release.ps1
```

Das Skript prüft die Buchquelle (Version, Datum, Versionshistorie, Inhaltsverzeichnis, Personenliste, Deckblatt-Boxen), liest die Seitenzahl aus der PDF, aktualisiert `story/current` und die Rückfallwerte, ruft `scripts/ci-check.ps1` auf und baut das FTP-Paket unter `output/ftp`.

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

Diese Werte werden in Schritt 5 gebraucht. Bricht das Skript mit `FEHLER:` ab, die genannte Stelle in der Buchquelle korrigieren und erneut starten.

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

**FTP-Fall:** Nur wenn Schritt 3 „FTP-Upload nötig: ja“ meldet (geändert sind `index.html`, `assets/js`, `impressum.html` oder `datenschutz.html`), zusätzlich das Paket aus `output/ftp` nach `docs/DOMAINFACTORY-DEPLOYMENT.md` hochladen.

## 6. Podcast

Nur wenn sich der Erzähltext geändert hat: Die Podcast-Fassung mit Google Gemini neu erzeugen. Bei reinen Korrekturen an Metadaten, Versionshistorie oder Layout entfällt dieser Schritt.

Erwartetes Ergebnis: Die neue Podcast-Fassung gibt den aktuellen Erzähltext wieder.
