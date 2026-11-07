# Einbau-Checkliste für ein neues Kapitel

Gilt für jede neue Geschichte und jede neue Anhang-Box in `source/fahrt-zum-kunden.html`. Die Bausteine stehen in [KAPITEL-VORLAGE.html.txt](KAPITEL-VORLAGE.html.txt).

Arbeitsweise: ein Kapitel einbauen, prüfen, erst dann das nächste.

## 1. Kapitel selbst

- [ ] Ein Geschichten-Kapitel steht als `<section class="scene">` innerhalb von `<div class="road">`, an der richtigen Stelle der Handlung.
- [ ] Die Szenen-Illustration steht zuerst, als `<div class="box-shell"><figure class="scene-fig">` mit `aria-label` und `figcaption`.
- [ ] Die Überschrift ist `<h2 id="kap-…">`, und die ID gibt es im Dokument genau einmal.
- [ ] Jede Box mit eigenem Rahmen oder Hintergrund (`.voice`, `.drafttasks`, `.defbox`, `.scene-fig`, `aside.real`, `.appendix`) steht in `<div class="box-shell">`.
- [ ] `<div class="box-shell-flow">` nur dann, wenn der Abschnitt länger als eine Seite ist und direkt nach einer anderen Box beginnt.
- [ ] Übergänge stimmen: Zeitlinie, Ort und Figuren schließen an das vorige und das folgende Kapitel an.

## 2. Anhang-Box (Teil 2 „Realer Bezug“ oder Anhang)

- [ ] Wenn die Szene Technik berührt, gibt es eine Anhang-Box (`aside.real` mit Eyebrow „Realer Bezug“ oder `section.appendix`).
- [ ] Die Box behauptet über echte Repos nur Belegtes (Version, Funktion, Stand). Geplantes ist als geplant gekennzeichnet.
- [ ] Rückverweis: Die Box verlinkt auf die Szene (`href="#kap-…"`), und die Szene oder das Mini-Inhaltsverzeichnis führt zur Box.

## 3. Pflichtstellen bei jeder neuen Version

- [ ] **Version:** `div.cover-meta` enthält `<span>Version X.YY</span>`.
- [ ] **Datum:** `div.cover-meta` enthält das Datum als `<span>TT.MM.JJJJ</span>`.
- [ ] **Cover-Hinweis:** `p.cover-whatsnew` nennt „Neu in vX.YY“ und die Neuerung in einem Satz.
- [ ] **Personenliste:** Neue Figuren stehen in `#kap-personen .table-people` (Badge, Name, Rolle, seit wann). Im Haus sind acht Menschen plus Navis und Lumen, Externe (z. B. Horst Wolbers) sind kenntlich.
- [ ] **Mini-Inhaltsverzeichnis:** `nav.cover-toc` hat den neuen Eintrag in der richtigen Gruppe (Teil 1 Geschichten, Teil 2 Realer Bezug, Anhang), und `href` zeigt auf die neue ID.
- [ ] **Drei Deckblatt-Boxen** sind vorhanden und aktuell: „Zur Einordnung“ (`p.disclaimer`), „Aufbau in zwei Teilen“ (`p.disclaimer`), „Ausgangslage“ (`div.intro`).
- [ ] **Versionshistorie:** Am Ende von `#kap-versionen table.vtable tbody` steht eine neue Zeile mit derselben Version und demselben Datum wie in `div.cover-meta`.
- [ ] **Anker:** Jeder neue `href="#…"` hat ein Ziel (ci-check meldet sonst „Interner Story-Link hat kein Ziel“).

## 4. Prüfen

- [ ] `verify_layout.py` läuft ohne Befund. Das Werkzeug liegt im Claude-Projekt, nicht im Repo.
- [ ] Link-Check: `./scripts/ci-check.ps1` meldet OK. Die Prüfung umfasst interne Anker, lokale Verweise und doppelte IDs.
- [ ] PDF mit `render_story_pdf.py` neu erzeugt und als `source/Die-Fahrt-zum-Kunden.pdf` abgelegt.
- [ ] `./scripts/publish-release.ps1` läuft durch: Version, Datum und Seitenzahl werden übernommen, das Paket wird gebaut.

## 5. Stimmigkeit mit den Regeln für Navis und Lumen

So stehen die Regeln im Buch (Stand v1.37):

- [ ] **Navis liest nur das Sysingboard.** „Navis liest ausschliesslich aus dem, was im Sysingboard ohnehin schon zusammenläuft. Nichts Neues wird erfunden“ (Kapitel „Navis meldet sich“, Zeile 1030).
- [ ] **Navis schreibt nie selbst.** Entwürfe von Navis erscheinen als `.drafttasks` „wartet auf Freigabe“. Angelegt wird erst nach dem menschlichen „So anlegen.“ (Kapitel „Am Konferenztisch“, Zeilen 1251–1267). Navis empfiehlt und entscheidet nicht: „Navis navigiert, Mira steuert &ndash; nie umgekehrt“ (Kapitel „Warum Navis und Lumen“, Zeile 1346).
- [ ] **Lumen liest nur über den Hub.** „Lumen selbst wertet dabei keinen der vier Fachreports einzeln aus, sondern fragt ausschließlich beim Hub an“ (Zeile 1875).
- [ ] **Keine Scores.** „Es gibt bewusst keine Gesamtampel und keinen Reifegrad-Score, der all das in eine einzige Zahl presst“ (Zeile 1876).
- [ ] **Offen bleibt offen.** Offene Punkte werden nicht zu einem Ergebnis verdichtet. Was noch nicht geklärt ist, bleibt im Text ausdrücklich offen, zum Beispiel „Sechs bleibt offen, bis Ihre Rückmeldung da ist“ (Zeile 1309).
- [ ] **Keine neue Fähigkeit:** Die neue Szene schreibt Navis oder Lumen keine Fähigkeit zu, die im Buch oder im realen Repo nicht belegt ist.

## 6. Abschluss

- [ ] Podcast nur neu erzeugen, wenn sich der Erzähltext geändert hat (Google Gemini).
- [ ] Änderung auf einem Feature-Branch, Pull Request, kein Merge durch Claude.
