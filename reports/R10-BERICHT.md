---
id: R10
titel: 'Sachgrundlage fuer Idee 13 A "Die veralteten Daten" (nur lesen)'
status: erledigt
start: 2026-11-06T11:27+01:00
ende: 2026-11-06T11:45+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner (Leseauftrag)'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle: 'bmarnau/sysingdashboard, Referenz-Klon C:\dev\referenz\sysingdashboard, HEAD 7dc4699d (06.11.2026), Version 1.70.0'
---

# R10 Bericht: Wie das Sysingboard Datenstand, Aktualität und Verantwortung abbildet

## Ergebnis

- Das Sysingboard zeigt einen **„Datenstand“**, aber je nach Ansicht bedeutet das etwas anderes: den Zeitpunkt der letzten **Veröffentlichung ans Team** (Kiosk, Leistungsnachweis), den **Abfragetag** (Arbeitssicht, Cockpit) oder die **letzte Änderung** eines AVKK-Vorgangs. Ein „zuletzt inhaltlich geändert“ für Projekte, Arbeitspakete und Tätigkeiten gibt es nicht.
- Für veraltete Daten gibt es **eine fachliche Markierung**: Im Managementcockpit gilt ein Projekt nach **mehr als 7 Tagen** ohne Veröffentlichung als „Veröffentlichungsstand prüfen“ (`DATA_STALE`). Erinnerungen, Benachrichtigungen oder automatische Jobs gibt es nicht.
- Verantwortung ist **personenbezogen** abgebildet (Owner und Stellvertretung je Arbeitspaket, eine aktive Kundenverantwortung je Kunde). Zuständig sein gibt **keinen** Zugriff.
- Projekte, Arbeitspakete und Tätigkeiten liegen **noch im Browser-Speicher** und kommen nur durch manuelles „An Team veröffentlichen“ in die gemeinsame Datenbank. BSF-04 (zentrale Datenhaltung) ist geplant.
- **Navis gibt es im Code nicht.** Navis ist nur geplant (Punkt 22, BSF-10 mit read-only und Mensch in der Schleife). Wie Navis den Datenstand lesen soll, legt das Repo nicht fest.

Methode: Recherche durch einen lesenden Such-Agenten, die tragenden Belege habe ich selbst mit `sed -n` an den genannten Zeilen nachgeprüft. Zwei Zeilenangaben des Agenten habe ich dabei korrigiert (Freshness-Vertrag `:12` und `:45-46`, Cache `:15`). `git status --porcelain` im Klon ist leer, es wurde nichts verändert. Pfade sind relativ zum Repo.

### Tabelle 1: Antworten mit Fundstellen

| Frage | Beobachtung | Beleg |
|---|---|---|
| Zeigt das Board das Alter eines Datensatzes? | AVKK-Management-Tabelle: Spalte „Letzte Änderung“ (`updated_at`) | `src/components/avkk/management/ManagementTable.tsx:115-116,161`; `src/lib/avkk/adapter.ts:92` |
|  | Leistungsnachweis: „Datenstand“ = letzte Veröffentlichung, Bestätigung „Ich bestätige, dass ich den angezeigten Datenstand geprüft habe.“ | `src/components/performance-statement/PerformanceStatementView.tsx:314-316,340` |
|  | Info-Kiosk: „Datenstand“ je Bereich, sonst „unbekannt“; Refresh alle 60 s | `src/components/kiosk/KioskWallboardSections.tsx:29,91`; `src/lib/kiosk/kiosk-contract.ts:10` |
|  | Arbeitssicht und Cockpit: „Datenstand“ bzw. „Stichtag“ ist der Berliner Kalendertag **der Abfrage**, kein Datensatzalter | `src/components/avkk/work/WorkPackageWorkView.tsx:32`; `src/lib/avkk-runtime/work-package-work-view.functions.ts:57` (`new Date().toISOString()`) |
|  | Lokale Projekte, Arbeitspakete, Tätigkeiten haben kein `createdAt`/`updatedAt` | `src/lib/dashboard-data.ts:8-64` |
|  | Grundsatz: „Ein UI-Renderzeitpunkt oder ein Server-Request-Zeitpunkt ist **kein** belastbarer Datenstand.“; „ein unbekannter Datenstand bleibt unbekannt.“ | `docs/BSF-03A-FRESHNESS-CONTRACT.md:12,45-46` |
|  | `published_at` wird bei **jeder** Veröffentlichung auf `now()` gesetzt, auch ohne Inhaltsänderung; nur `source_revision` steigt bei Änderung | `supabase/migrations/20260929053733_bsf03e_p3b_due_projection.sql:144-145` |
| Wer pflegt, wer ist zuständig? | Acht Rollen (systemadministrator bis kiosk), Rechte über `has_permission`, RLS auf allen Fachtabellen | `docs/RBAC-MATRIX.md:9-20,31-33` |
|  | Arbeitspaket: Owner und Deputy mit Gültigkeit (`avkk_responsibility`), Anzeige „UNASSIGNED“ möglich | `docs/BSF-03E-DESIGN.md:47-54`; `src/lib/avkk/work-package-work-view.types.ts:35-36` |
|  | Kunde: höchstens eine aktive Verantwortung, „seit …“ sichtbar | `supabase/migrations/20260908032151_…sql:4-17,26-29`; `src/components/customers/CustomerDetailView.tsx:225` |
|  | „Eine Responsibility erteilt weder automatisch Lese- noch Schreibzugriff.“ | `docs/DATA-SCHEMA.md:208-209` |
|  | Wer veröffentlicht hat (`published_by`); fremde Einträge nicht überschreibbar | `supabase/migrations/20260929053733_…sql:137-138` |
| Was passiert bei veralteten Daten? | Cockpit: `DATA_STALE` ab mehr als 7 Tagen seit letzter Veröffentlichung, Anzeige „Veröffentlichungsstand prüfen“ | `src/lib/management-cockpit/compose.ts:20,208-210` |
|  | Leistungsnachweis: Hinweis „Veraltete Review-Entscheidung“; Finalisieren gesperrt bei geändertem Stand | `PerformanceStatementView.tsx:248-250`; `supabase/migrations/20260921095742_bsf03b_performance_statement.sql:583-584` |
|  | Katalog-Cache nach 24 h „stale“, bleibt nutzbar; Demodaten nach 3 Tagen | `src/lib/reference-data/cache.ts:7,15`; `src/lib/demo-data/seed.ts:73` |
|  | Keine Erinnerung, keine Benachrichtigung, kein Zeitjob, kein Ablaufdatum | Suche nach „Erinnerung“, „reminder“, „benachrichtig“ in `src/` und `cron`/`notify` in `supabase/` ohne Treffer (außer Tests) |
| Wie liest Navis den Stand? | Im Code keine Navis-Anbindung | `grep -rni navis src` → 0 Treffer |
|  | Geplant als Punkt 22 „danach externe Integrationen/MCP/Agenten/NAVIS“ | `docs/BSF-CURRENT-PRIORITIES.md:155` |
|  | Aktuell ausgeschlossen: „kein NAVIS-/Agenten-Zugriff“ | `docs/BSF-INTERNAL-KIOSK-FIRST-ROADMAP.md:20` |
|  | Zielbild BSF-10: read-only Quellen, Human-in-the-loop, keine autonomen Aktionen | `docs/GESAMTPLAN-SYSING-DASHBOARD.md:476-498` |
| Supabase oder Browser? | Projekte, Arbeitspakete, Tätigkeiten im localStorage (`northbit-dashboard-v2`) | `src/lib/store/dashboard-persistence.ts:35` |
|  | „Einige persönliche bzw. noch nicht zentralisierte Module verwenden weiterhin benutzerbezogenen Browser-Speicher. … Datenhaltungsumbau ist als BSF-04 geplant.“ | `README.md:34-37` |
| Version | 1.70.0 vom 04.11.2026 (README nennt noch 1.69.0) | `CHANGELOG.md:16`; `README.md:8` |

### Tabelle 2: Was die Geschichte sagen darf

| Nr. | Erlaubte Sachaussage | Beleg |
|---|---|---|
| E1 | Das Sysingboard zeigt an, wann etwas zuletzt ans Team veröffentlicht wurde, und ein unbekannter Stand bleibt als „unbekannt“ stehen. | Kiosk `KioskWallboardSections.tsx:29,91`; `BSF-03A-FRESHNESS-CONTRACT.md:45-46` |
| E2 | Nach mehr als sieben Tagen ohne Veröffentlichung markiert das Managementcockpit ein Projekt mit „Veröffentlichungsstand prüfen“. | `compose.ts:20,208-210` |
| E3 | Wer einen Leistungsnachweis abschließt, muss ausdrücklich bestätigen, dass er den angezeigten Datenstand geprüft hat. Hat sich der Stand inzwischen geändert, lässt das System das Abschließen nicht zu. | `PerformanceStatementView.tsx:340`; Migration `…bsf03b…sql:583-584` |
| E4 | Jedes Arbeitspaket hat eine verantwortliche Person und eine Vertretung, oder es steht sichtbar als „nicht zugeordnet“ da. | `work-package-work-view.types.ts:35-36` |
| E5 | Ein Teil der Daten liegt noch im Browser der jeweiligen Person und kommt erst durch „An Team veröffentlichen“ bei allen an. | `dashboard-persistence.ts:35`; `README.md:34-37` |

| Nr. | Unzulässige Aussage | Warum nicht | Beleg |
|---|---|---|---|
| U1 | „Das Sysingboard hat Mira erinnert, dass die Daten veraltet sind.“ | Es gibt keine Erinnerungen oder Benachrichtigungen. | Suche ohne Treffer (Tabelle 1) |
| U2 | „Navis hat bemerkt, dass der Eintrag drei Wochen alt ist.“ (als realer Bezug) | Navis gibt es im Code nicht, und lokale Arbeitspakete haben keinen Änderungszeitstempel. | `grep navis src` → 0; `dashboard-data.ts:8-64` |
| U3 | „Der Datenstand zeigt, wann jemand zuletzt etwas geändert hat.“ | Meist ist es der Veröffentlichungszeitpunkt oder der Abfragetag. `published_at` wird auch ohne Inhaltsänderung neu gesetzt. | Migration `…bsf03e…sql:144-145`; `work-package-work-view.functions.ts:57` |
| U4 | „Wer zuständig ist, sieht automatisch alle Daten des Kunden.“ | Verantwortung gibt keinen Zugriff. | `DATA-SCHEMA.md:208-209` |
| U5 | „Alle Daten liegen zentral auf dem Server.“ | Projekte, Arbeitspakete und Tätigkeiten liegen noch im Browser, BSF-04 ist erst geplant. | `README.md:34-37` |

### Offen, nicht belegbar

- Wie Navis konkret lesen würde (Schnittstelle, Rolle, Rechte): im Repo nicht festgelegt.
- Eine ausdrückliche Regel „Navis bewertet nicht“: nicht festgelegt. Am nächsten kommt der Ausschluss von Personenranking und automatischer Leistungsbewertung im Cockpit (`docs/BSF-07-MANAGEMENT-COCKPIT-DESIGN.md:34`).
- Ob die 7-Tage-Schwelle fachlich abgenommen ist: nicht ermittelbar.
- Das Managementcockpit liegt auf `main`, steht aber in keinem CHANGELOG-Eintrag, und laut `docs/CURRENT-STATUS.md` gilt „Publish bleibt No-Go“. Im Buch daher als „in Erprobung“ einordnen.

## Vorschläge und Ideen (Claude)

1. **Kern der Geschichte „Die veralteten Daten“:** Der Konflikt muss nicht technisch sein. Das Board zeigt korrekt „Datenstand: vor neun Tagen veröffentlicht“, aber Reiner hat seit einer Woche lokal Notizen im Browser, die nie veröffentlicht wurden (E5). Navis kann nur sagen, was veröffentlicht ist. Die Lösung ist menschlich: veröffentlichen oder nachfragen. Das trägt die Grundregel „Navis navigiert, Mira steuert“ und bleibt bei der Realität.
2. **Ein echtes Detail als Aufhänger:** Der Haken „Ich bestätige, dass ich den angezeigten Datenstand geprüft habe“ (E3) ist erzählerisch stark: Eine Person muss aktiv bestätigen, dass sie hingeschaut hat. Das passt in eine kurze Szene mit Petra oder einer Teamleitung.
3. **„Unbekannt bleibt unbekannt“ als Satz für die Anhang-Box:** Der Freshness-Vertrag (`BSF-03A-FRESHNESS-CONTRACT.md:45-46`) ist fast wörtlich die Haltung des Buchs („Offen bleibt offen“). Vorschlag: Die Anhang-Box zitiert ihn sinngemäß und schlägt so die Brücke zu Lumen und den Reports.
4. **Navis im Konjunktiv:** Weil Navis real noch nicht gebaut ist, sollte die Anhang-Box sagen: „Wenn Navis angebunden ist, soll er genau diesen Datenstand lesen, nicht schätzen.“ So bleibt die Geschichte ehrlich und baut auf den Plan (BSF-10, read-only) auf.
5. **Hinweis an den Owner zum Sysingboard (kein Auftrag hier):** `README.md:8` nennt noch Version 1.69.0, das CHANGELOG 1.70.0. Außerdem fehlt dem Cockpit ein CHANGELOG-Eintrag. Beides wäre ein kleiner Pflegepunkt im Repo sysingdashboard.
6. **Prüfauftrag für den Planer:** Vor dem Schreiben der Geschichte E1 bis E5 und U1 bis U5 als Checkliste in R08 bzw. die Einbau-Checkliste übernehmen („Behauptet die Szene etwas aus U1 bis U5?“).

## Offene Fragen, Risiken, Abweichungen

- **Abweichung Arbeitsweise:** Die Recherche lief parallel zu R04, beide nur lesend.
- **Abweichung Quelle:** wie bei R04, Commit `08ec617` ohne Trailer (siehe STATUS.yaml).
- **Risiko:** Der Stand gilt für 06.11.2026 (HEAD `7dc4699d`). Das Sysingboard entwickelt sich schnell. Vor dem Einbau der Geschichte sollten E1 bis E5 kurz gegen den dann aktuellen Stand geprüft werden.
- Keine Änderung in sysingdashboard oder anderen Repos, kein Buchtext geändert.

Hygiene: keine offenen PRs, keine Drafts; Referenz-Klone bleiben für R03 liegen.

```yaml
Reifegrad: "Belegte Sachgrundlage für Idee 13 A mit 5 erlaubten und 5 unzulässigen Aussagen"
Projektstatus: "R10 erledigt (Leseauftrag); Geschichte 'Die veralteten Daten' kann auf E1 bis E5 aufbauen"
Offene_Fragen:
  - "Soll die Geschichte den Unterschied 'lokal notiert' gegen 'veröffentlicht' als Kern nehmen (Vorschlag 1)?"
  - "Darf die Anhang-Box das Managementcockpit nennen, obwohl es noch 'Publish No-Go' ist?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
