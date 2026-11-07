---
id: R21
titel: 'Nachprüfung E1 bis E5 und U1 bis U5 gegen den aktuellen Sysingboard-Stand (nur lesen)'
status: erledigt
start: 2026-11-07T05:06+01:00
ende: 2026-11-07T05:11+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner, Kommentar an #10'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: 'bmarnau/sysingdashboard, Referenz-Klon C:\dev\referenz\sysingdashboard; alter HEAD 7dc4699d (R10, 06.11.2026), neuer HEAD origin/main = 7dc4699d (unverändert, git fetch am 07.11.2026 05:07)'
---

# R21 Bericht: E1 bis E5 und U1 bis U5 am Stand vom 07.11.2026

## Ergebnis

- `origin/main` (= `origin/HEAD`) steht nach `git fetch` weiter auf `7dc4699d`. Seit R10 gibt es **keinen neuen Commit** auf dem Hauptbranch, `git diff 7dc4699d origin/main --stat` ist leer.
- Alle fünf erlaubten Aussagen E1 bis E5 **gelten weiter**, die Zeilen sind unverändert. Alle fünf unzulässigen Aussagen U1 bis U5 bleiben unzulässig.
- BSF-04 ist weiter nur geplant. Eine Erinnerungs- oder Benachrichtigungsfunktion gibt es nicht. Szene und Anhang-Box „Datenstand“ in PR #10 müssen deshalb nicht angepasst werden.
- Neu sind nur Nebenbranches (`docs/2026-11-06-tagesbuendel`, `lovable-sync-1793985842`). Keiner von beiden berührt die belegten Dateien.

Methode: Jede Fundstelle habe ich mit `git show origin/main:<pfad> | sed -n` am Remote-Stand gelesen, nicht im Arbeitsbaum. Die offenen PRs im Sysingboard habe ich per `gh pr view --json files` auf die belegten Dateien geprüft.

| Aussage | Ergebnis | Fundstelle neu (origin/main 7dc4699d) | Beleg (Diff) |
|---|---|---|---|
| E1 Veröffentlichungsstand sichtbar, unbekannt bleibt „unbekannt“ | gilt weiter | `src/components/kiosk/KioskWallboardSections.tsx:29` (`return "unbekannt"`), `:91` (`Datenstand: …`); `docs/BSF-03A-FRESHNESS-CONTRACT.md:45-46` | kein Diff, gleicher Commit |
| E2 mehr als 7 Tage ergibt „Veröffentlichungsstand prüfen“ | gilt weiter | `src/lib/management-cockpit/compose.ts:20` (`DEFAULT_STALE_AFTER_DAYS = 7`), `:208-210` (`DATA_STALE`) | kein Diff |
| E3 Bestätigung Datenstand, Abschluss bei geändertem Stand gesperrt | gilt weiter | `src/components/performance-statement/PerformanceStatementView.tsx:340`; `supabase/migrations/20260921095742_bsf03b_performance_statement.sql:583-584` (`stale review fingerprint`) | kein Diff |
| E4 Owner und Vertretung oder „nicht zugeordnet“ | gilt weiter | `src/lib/avkk/work-package-work-view.types.ts:35-36` (`owner: … \| "UNASSIGNED"`, `deputies`) | kein Diff |
| E5 Teil der Daten im Browser, erst „An Team veröffentlichen“ bringt sie zu allen | gilt weiter | `src/lib/store/dashboard-persistence.ts:35` (`northbit-dashboard-v2`); `README.md:34-37` | kein Diff |
| U1 Erinnerung durch das Sysingboard | bleibt unzulässig | keine Erinnerungsfunktion, siehe Abschnitt BSF-04 | kein Diff |
| U2 Navis bemerkt Alter (real) | bleibt unzulässig | `git grep -i navis origin/main -- src`: 0 Treffer; `src/lib/dashboard-data.ts:8-64` ohne Zeitstempel | kein Diff |
| U3 Datenstand = letzte inhaltliche Änderung | bleibt unzulässig | `supabase/migrations/20260929053733_bsf03e_p3b_due_projection.sql:144-145`; `src/lib/avkk-runtime/work-package-work-view.functions.ts:57` | kein Diff |
| U4 Zuständigkeit gibt Zugriff | bleibt unzulässig | `docs/DATA-SCHEMA.md:208-209` | kein Diff |
| U5 alle Daten zentral auf dem Server | bleibt unzulässig | `README.md:37` („Datenhaltungsumbau ist als BSF-04 geplant.“) | kein Diff |

## BSF-04 und Erinnerungen

- **git log seit 7dc4699d:** `git log 7dc4699d..origin/main` ist leer. Auf allen Branches gibt es seitdem nur Doku-, Queue- und Report-Commits sowie einen Lovable-Sync (`436ce690`, `7db1d87f`, `ee33db74`). Der Lovable-Sync fügt nur `.lovable/north-star/north-star.md` und fünf Zeilen `__InternalSupabase` in `src/integrations/supabase/types.ts` hinzu. Das ist keine Datenhaltung und keine Benachrichtigung.
- **BSF-04:** 30 Dateien am neuen Stand nennen BSF-04. Alle beschreiben es als künftig, z. B. `README.md:37`, `docs/ADR/0032-bsf-02c-shared-projection.md:23` („Die Local-First-Arbeitskopie bleibt bis BSF-04 …“) und `:152` („BSF-04 bleibt notwendig“). Eine serverseitige Ablage von Projekten, Arbeitspaketen und Tätigkeiten gibt es **nicht**.
- **Erinnerung, reminder, benachrichtig:** in `src/` und `supabase/` keine Treffer außerhalb von Tests. `notify` trifft nur technische Ereignisse im Browser: `src/hooks/useExportDialog.ts:51` (`notifyDownloadsChanged`), `src/hooks/useIdleLogout.ts:80`, `src/lib/session/idle-monitor.ts:32` (`notifyActivity`), `src/lib/refresh/refresh-coordinator.ts:53`. Diese Treffer gab es schon bei R10. Keiner davon erinnert eine Person an veraltete Daten.
- **Befund:** Es gibt keinen Grund, die Szene oder die Anhang-Box „Datenstand“ anzupassen.

## Offene Fragen, Risiken, Abweichungen

- **Abweichung:** Weil der Hauptbranch unverändert ist, gab es keine vollen Diffs zu lesen. Die Prüfung beschränkte sich auf das erneute Lesen der Zeilen und die Nebenbranches.
- **Risiko:** Der Doku-Branch `docs/2026-11-06-tagesbuendel` (Draft-PR #286 im Sysingboard) bestätigt „Publish bleibt No-Go“ (A21, 16 von 22 Gates offen). Das Managementcockpit (E2) sollte im Buch deshalb weiter als „in Erprobung“ gelten. Draft-PR #282 (Handbuch Managementcockpit, CHANGELOG 1.70.0) ist noch nicht gemergt und berührt keine belegte Datei.
- **Risiko:** Draft-PR #283 (QS6-5, Exporte) und die Kiosk-Pakete nach dem Publish (Doku-Branch, A18 und F-KK-01 zu `KioskView.tsx`, nicht `KioskWallboardSections.tsx`) könnten später die Kiosk-Anzeige ändern. Vor dem Merge von PR #10 genügt diese Prüfung. Vor einer späteren Neuauflage sollte man E1 erneut prüfen.
- `README.md:8` nennt weiter Version 1.69.0 (R10-Vorschlag 5 ist offen).
- Im Sysingboard wurde nichts verändert. `git status --porcelain` ist vor und nach der Prüfung leer, der lokale HEAD steht weiter auf `7dc4699d`. Nur `git fetch` hat die Remote-Referenzen aktualisiert.

## Vorschläge und Ideen (Claude)

1. **PR #10 kann bei E1 bis E5 so bleiben.** Im PR-Text sollte ein Satz stehen: „Sachstand geprüft am 07.11.2026 gegen 7dc4699d (R21)“. Dann ist der Prüfstand im Buch nachvollziehbar.
2. **Prüfstand in die Anhang-Box:** Eine Fußzeile „Stand Sysingboard: 1.70.0, 07.11.2026“ macht die Box selbst zu einem Beispiel für „Datenstand sichtbar“. Das wäre eine kleine, passende Selbstanwendung des Themas.
3. **Wiederholbare Prüfung:** Die Befehle aus R21 (fetch, diff --stat auf die zitierten Dateien, Fundstellen per `git show | sed -n`) lassen sich als kleines Skript für die Einbau-Checkliste aus R08 festhalten. So kostet die Nachprüfung vor jeder Ausgabe nur Minuten.
4. **Leitstern als möglicher Aufhänger:** Der Lovable-Sync legt einen Leitstern an: „Finalisierte Leistungsnachweise pro Monat“ (`.lovable/north-star/north-star.md`, nur auf dem Nebenbranch). Das passt zu E3. Im Buch sollte er erst stehen, wenn er auf `main` liegt.

## Hygiene

Hygiene: Reling-IT/relingit hat keine Remote-Branches gemergter PRs mehr (nach `git fetch --prune` geprüft). Offen sind fünf PRs: #6, #7 und #8 bereit, #9 und #10 als Draft.

```yaml
Reifegrad: "E1 bis E5 und U1 bis U5 am Stand 07.11.2026 bestätigt (main unverändert 7dc4699d)"
Projektstatus: "R21 erledigt (Leseauftrag); PR #10 kann ohne sachliche Anpassung weiterlaufen"
Offene_Fragen:
  - "Soll der Prüfstand (7dc4699d, 07.11.2026) im PR-Text oder in der Anhang-Box von PR #10 genannt werden?"
  - "Soll die Nachprüfung als Skript in die Einbau-Checkliste (R08) aufgenommen werden?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
