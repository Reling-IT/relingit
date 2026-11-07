---
id: R20
titel: Externe Links im Buch prüfen und Video-Angaben ermitteln
status: erledigt
start: 2026-11-07T05:06+01:00
ende: 2026-11-07T05:11+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner (Leseauftrag), Kommentar an #10'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: 'origin/geschichte-veraltete-daten-20261107 @ cfc1f9789de59576465ea34eac27df1608a6060d (cfc1f97, 2026-11-07 04:55 +0100), Datei source/fahrt-zum-kunden.html'
---

# R20 – Externe Links und Video-Angaben

## Ergebnis

- 4 eindeutige externe URLs (http/https), je 1 Vorkommen; 3 stehen schon auf main (n8n-Box), neu auf dem Branch ist nur der YouTube-Link.
- 3 × ok (direkt 200), 1 × Weiterleitung (youtu.be → youtube.com/watch, 303, danach 200; das ist bei Kurzlinks normal), 0 × Fehler.
- Video: „Why do AI Agents Fail“, Kanal „John Savill's Technical Training“ (@NTFAQGuy), veröffentlicht am 26.10.2026, Länge etwa 42:40 Min., englischsprachig.
- Im Buch steht das Video ohne Titel, Kanal und Datum. Ein Vorschlag zum Ergänzen steht unten, am Text wurde nichts geändert.
- PR-Kommentar an #10: https://github.com/Reling-IT/relingit/pull/10#issuecomment-6702074191

Prüfzeitpunkt: 2026-11-07, 05:08:16 bis 05:08:40 +01:00. Für jede URL liefen HEAD und GET mit `-L --max-time 20` und einem generischen Browser-User-Agent; HEAD und GET lieferten jeweils dasselbe Ergebnis.

| URL | Fundstelle | Status | Ziel/Weiterleitung | Bewertung |
|---|---|---|---|---|
| https://n8n.io | `#kap-n8n`, Bildunterschrift, Z. 1960 (1×) | 200 | https://n8n.io/ (keine Weiterleitung, nur abschließender Schrägstrich) | ok |
| https://docs.n8n.io | `#kap-n8n`, Bildunterschrift, Z. 1960 (1×) | 200 | https://docs.n8n.io/ (keine Weiterleitung) | ok |
| https://github.com/n8n-io/n8n | `#kap-n8n`, Bildunterschrift, Z. 1960 (1×) | 200 | keine Weiterleitung | ok |
| https://youtu.be/xKgY5vnzjMQ | `#kap-datenstand`, Definitionsbox „Zum Weiterschauen“, Z. 1979 (1×) | 303 → 200 | https://www.youtube.com/watch?v=xKgY5vnzjMQ&feature=youtu.be (1 Weiterleitung) | ok, die Weiterleitung ist bei youtu.be erwartbar |

### Video-Angaben

Abgerufen am 2026-11-07 um 05:09 +01:00.

| Feld | Wert | Quelle |
|---|---|---|
| Titel | Why do AI Agents Fail | oEmbed `title`, Watch-Seite `og:title` / `meta name="title"` |
| Kanal | John Savill's Technical Training | oEmbed `author_name`, `ownerChannelName`, `itemprop name` |
| Kanal-URL | https://www.youtube.com/@NTFAQGuy (channelId UCpIn7ox7j7bH_OFj7tYouOQ) | oEmbed `author_url`, Watch-Seite |
| Veröffentlicht | 2026-10-26T03:32:51-07:00, also 26.10.2026 | `itemprop datePublished`, `uploadDate`, `publishDate` (alle gleich) |
| Länge | 2559 bis 2560 s, etwa 42:40 Min. | `lengthSeconds` |
| Sprache | Englisch (nach Titel und Beschreibung) | `og:description` |

**So wird das Video im Buch zitiert:** Es steht in der Anhang-Box „Realer Bezug“ mit der Überschrift „Datenstand: was das Sysingboard anzeigt – und was nicht“ (`#kap-datenstand`). Darin sitzt die Definitionsbox „Fehlerklasse ‚schlechter Kontext‘ – wenn die Quelle nicht stimmt“ und dort der Eintrag „Zum Weiterschauen – Empfehlung des Autors“:
> Ein Video zu typischen Fehlerklassen von KI-Agenten: <a href="https://youtu.be/xKgY5vnzjMQ">youtu.be/xKgY5vnzjMQ</a>.

Titel, Kanal, Datum, Sprache und Länge fehlen. Die Zeilen 848 und 849 erwähnen YouTube nur innerhalb der Geschichte (Nora); das ist kein Link und kein Verweis auf dieses Video.

## Offene Fragen, Risiken, Abweichungen

- **Inhalt nicht geprüft:** Ob das Video die Fehlerklasse „schlechter Kontext“ wirklich behandelt, ließ sich nicht prüfen, weil das Video nicht angesehen wurde. Titel und Beschreibung („Why do AI agents really fail? Is it all the models fault?“) passen zur Aussage im Buch. Eine Bestätigung durch den Autor steht noch aus.
- **Gedrucktes PDF:** Dort ist nur „youtu.be/xKgY5vnzjMQ“ zu lesen. Wird das Video gelöscht oder auf privat gestellt, kann niemand mehr feststellen, was gemeint war.
- **Sprache:** Das Video ist englisch, das Buch deutsch. Im Buch steht dazu kein Hinweis.
- **Momentaufnahme:** Die Linkprüfung gilt nur für den Prüfzeitpunkt. Ob YouTube oder GitHub aus anderen Netzen oder ohne Browser-User-Agent anders antworten, wurde nicht getestet.
- Keine Abweichung vom Auftrag. Nichts committet, nichts gepusht, Buchtext unverändert. Einzige Schreibaktion ist der PR-Kommentar an #10.

## Vorschläge und Ideen (Claude)

1. **Anhang-Box Datenstand: Titel und Kanal nennen (Empfehlung: ja).** Die Box „Datenstand“ verlangt genau das, nämlich die Quelle samt Stand zu nennen, statt sie zu verschweigen. Der eigene Videoverweis sollte das ebenfalls tun. Der Text bleibt unverändert, das hier ist nur ein Vorschlag.
   - **Alt:** `<p>Ein Video zu typischen Fehlerklassen von KI-Agenten: <a href="https://youtu.be/xKgY5vnzjMQ">youtu.be/xKgY5vnzjMQ</a>.</p>`
   - **Neu (Vorschlag):** `<p>Ein Video zu typischen Fehlerklassen von KI-Agenten: John Savill&rsquo;s Technical Training, &bdquo;Why do AI Agents Fail&ldquo; (YouTube, englisch, 26.10.2026, ca. 43 Min.): <a href="https://youtu.be/xKgY5vnzjMQ">youtu.be/xKgY5vnzjMQ</a>.</p>`
   - Kürzere Variante: `… KI-Agenten: &bdquo;Why do AI Agents Fail&ldquo; von John Savill (englisch, 2026): <a …>youtu.be/xKgY5vnzjMQ</a>.`
2. Einen Hinweis „abgerufen am …“ braucht es nicht, solange das Buch einen Datenstand im Impressum oder Anhang führt. Andernfalls „(abgerufen 07.11.2026)“ ergänzen.
3. Die Linkprüfung als optionalen Schritt in `ci-check` aufnehmen: hrefs extrahieren und HEAD mit Timeout abfragen, nur als Warnung, damit ein Netzproblem den Build nicht stoppt. Bei vier Links ist der Aufwand klein.
4. Die n8n-Links sind gesund. Weil sie seit main unverändert sind, genügt künftig eine Prüfung je Release.

Hygiene: gemergte Remote-Branches außer main: keine (`git branch -r --merged origin/main` liefert nur origin/main und origin/HEAD). Offene PRs: 5 (#10 Draft, #9 Draft, #8, #7, #6), davon 2 Drafts.

```yaml
Reifegrad: Entwurf (Geschichte „Die veralteten Daten“ als Draft-PR #10, v1.38); Links technisch in Ordnung
Projektstatus: Buch in Erweiterung; 5 offene PRs (2 Drafts); R20-Linkprüfung ohne Fehler
Offene_Fragen:
  - Soll der Videoverweis in der Box „Datenstand“ Titel, Kanal, Datum und Sprache nennen? (Vorschlag: ja)
  - Behandelt das Video die Fehlerklasse „schlechter Kontext“ tatsächlich? (Bestätigung durch den Autor)
  - Linkprüfung als optionale Warnung in ci-check aufnehmen?
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
  Hinweis: unbelegte Schätzung
```
