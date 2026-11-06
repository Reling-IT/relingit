---
id: R04
titel: 'Zuordnung der sieben Standards zu Navis, Lumen und den Apps (nur lesen)'
status: erledigt
start: 2026-11-06T11:09+01:00
ende: 2026-11-06T11:27+01:00
branch: 'keiner (Leseauftrag)'
pr: 'keiner (Leseauftrag)'
commit: 'nur Bericht auf ops/reports'
ci: 'nicht zutreffend'
quelle_queue: 'origin/ops/queue f4a26e6'
---

# R04 Bericht: Die sieben Standards hinter Navis und Lumen

## Ergebnis

- **AQGS** ist der einzige Standard, der in allen sieben App-Repos als Profil (`quality-gates.yaml`) hinterlegt ist. In den sechs Report-Repos steht dabei ausdrücklich `candidate_pass_claim: false`, das Profil ist also keine Aussage, dass die Gates bestanden sind.
- **TDF** wird im Sysingboard angewendet (Artefakt- und Nachweisregister). **ADG** ist dort nur referenziert. **SEC, DSG und AI** kommen in keinem App-Repo vor.
- **LIB** wird in beiden Bibliotheken angewendet: tdfbibliothek mit Konformitätsabgleich (31 erfüllt, 22 teilweise, 10 offen), HI-Bibliothek mit eigenem Abgleich (Stufe 1 noch nicht erreicht). Keiner der beiden Abgleiche ist ein Compliance-Claim.
- Navis kommt real nur in der Planung des Sysingboards vor (Punkt 22, read-only, Mensch in der Schleife). **Lumen kommt in keinem Repo vor.** Die Regeln „Hub liest nur Areport“, „Areport ist einziger Aggregator“ und „keine Scores“ sind in hub und areport belegt.
- **k6:** Das Buch verwendet ADR durchgehend als „Architecture Decision Record“ (Dokumenttyp in TDF), nie als Namen des Standards ai-development-governance. Ein pauschales Ersetzen wäre falsch.

Methode: 16 Repos nur lesend nach `C:\dev\referenz` geklont (Stand 06.11.2026, Commits in Tabelle 1). Die Auswertung lief per Volltextsuche mit vier lesenden Such-Agenten. Die tragenden Belege habe ich selbst stichprobenartig mit `sed -n` an den genannten Zeilen nachgeprüft (ADG `ADR.md:3`, AQGS `README.md:16`, `ableitungsregeln.yaml:28-35`, hub `API.md:44,101`, `REPORTFAMILIE.md:41`, LIB `conformance/tdfbibliothek/README.md:24`, HI `konformitaet/README.md:27`, `AGENTS.md:17`, Buch Zeile 1687). Pfade sind relativ zu `C:\dev\referenz\<repo>`.

### Tabelle 1: Geklonte Repos

| Repo | Commit | Version laut Repo |
|---|---|---|
| bmarnau-standards/ai-development-governance | a354cb3 | ADG 1.6.1-draft (`VERSION.md:3`) |
| bmarnau-standards/AQGS-Application-Quality-Gate-Standard | ba4badd | AQGS 1.10.3-draft (`VERSION.md:3`) |
| bmarnau-standards/technical-documentation-framework | 6144317 | TDF 1.6.0-draft (`framework-manifest.yaml:7-8`) |
| bmarnau-standards/security-standard | 43ba061 | SEC 0.5.10-draft (`VERSION:1`) |
| bmarnau-standards/dsgvo-compliance | b6befa8 | DSG 0.3.8-draft (`VERSION:1`) |
| bmarnau-standards/ai-act-compliance | dc38ecf | AI 0.5.2-draft (`VERSION:1`) |
| bmarnau-standards/Bibliothek | 67b269b | LIB 0.14.11-draft (`CHANGELOG.md:3`) |
| bmarnau/sysingdashboard | 7dc4699d | 1.70.0 (`CHANGELOG.md:16`) |
| bmarnau/hub | e19fe45 | 1.6.6 (`package.json:3`) |
| bmarnau/areport | 11371e7 | 0.18.5 (`package.json:3`) |
| bmarnau/ireport | 861ffdb | 1.10.0 (`package.json:3`) |
| bmarnau/nreport | f14f3b9 | 1.9.5 (`package.json:3`) |
| bmarnau/qreport | cc1a092 | 0.12.8 (`package.json:3`) |
| bmarnau/sreport | 915364e | 1.9.5 (`package.json:3`) |
| LeadOS-Org/HI-Bibliothek | c8692d7 | 0.2.0 (`README.md:5`) |
| bmarnau/tdfbibliothek | c258b4c | 0.5.0-beta.2 (`project.json:5`) |

Die Familie der sieben ist vollständig nur in `AQGS…/risk-profile/ableitungsregeln.yaml:28-35` aufgeführt (adg, aqgs, tdf, lib, sec, dsg, ai mit Repo-Namen). Laut Dateikopf ist das die Quelle für `bmarnau-standards/uebersicht`. Dieses Repo habe ich nicht geklont.

### Tabelle 2: Standard, Anwendungsort, Beleg, Stand

| Standard | Anwendungsort | Beleg | Stand |
|---|---|---|---|
| ADG | sysingdashboard: referenziert (Branch-/PR-Hygiene, PR 15 gemergt) | `docs/ENTWICKLUNGSTAGEBUCH.md:237`, `docs/BACKLOG.md:301` | kein Profil, kein CI-Gate |
| ADG | tdfbibliothek: angewendet, Version 1.1.0, „binding“ | `project.json:30-32`, `policy/standards-register.json:21-28`, `docs/adr/ADR-TLB-0001_ai-development-governance.md:13` | gepinnt auf 1.1.0 (aktuell 1.6.1-draft) |
| ADG | HI-Bibliothek: im Register, Version 1.6.0 | `docs/compliance/standards-register.md:8` | Register nennt Repo `bmarnau/ai-development-governance` (außerhalb der Organisation) |
| ADG | report-family-platform: „einziger bekannter Konsument“, Pin 1.0.0 | ADG `risk-register/risks.yaml:86-89` | report-family-platform selbst nicht geprüft |
| AQGS | sysingdashboard: Profil „security-data“, AQGS 1.0.0-draft, erste Referenzumsetzung | `quality-gates.yaml:2-4,9`; AQGS `README.md:16` | Pilot A gemergt (AQGS `docs/pilot-findings.md:5-10`) |
| AQGS | hub, areport, nreport: Profil „standard“; ireport, qreport, sreport: „security_data“ | jeweils `quality-gates.yaml:2-4,10` | `candidate_pass_claim: false` (z. B. hub `:39`) |
| AQGS | tdfbibliothek: 1.7.0-draft, Profil standard, „adopted-draft“ | `project.json:37-44`, `policy/standards-register.json:35-43` | Draft lokal eingeführt |
| AQGS | HI-Bibliothek: 1.9.0-draft | `docs/compliance/standards-register.md:10` | nicht in der CI gepinnt (`:15`) |
| TDF | sysingdashboard: angewendet (Artefakt- und Nachweisregister, Dateinamen) | `docs/ARTEFAKTE.yaml:2`, `docs/NACHWEISE.yaml:1`, `src/lib/report/filename.ts:4` | angewendet |
| TDF | hub, areport: nur Kürzel „TDF“ | hub `VERSION.md:111`, areport `VERSION.md:151` | Bedeutung im Repo nicht aufgelöst |
| TDF | tdfbibliothek: Release-Gate „final TDF PASS“ | `project.json:140-147`, `docs/13_TDF_REGELMATRIX.md:4` | binding |
| TDF | HI-Bibliothek: 1.5.0-draft | `docs/compliance/standards-register.md:9` | im Register |
| SEC | in keinem App-Repo; tdfbibliothek „guidance-only“, „work_in_progress“; HI-Bibliothek 0.5.0-draft | tdfbibliothek `project.json:67-71`; HI `standards-register.md:11` | Apps: nicht ermittelbar |
| DSG | in keinem App-Repo; tdfbibliothek „guidance-only“; HI-Bibliothek 0.2.1-draft | tdfbibliothek `project.json:60-64`; HI `standards-register.md:12` | Apps: nicht ermittelbar |
| AI | in keinem App-Repo; tdfbibliothek „guidance-only“; HI-Bibliothek 0.2.1-draft | tdfbibliothek `project.json:53-57`; HI `standards-register.md:13` | Apps: nicht ermittelbar |
| LIB | tdfbibliothek: Konformitätsabgleich im Standard-Repo (Profil LIB-TRN) | Bibliothek `conformance/tdfbibliothek/README.md:4,24`, `report.json:5` („claim“: „none“) | 68 Einträge: 31 erfüllt, 22 teilweise, 10 offen, 5 n. a.; formale Übernahme offen (Befund C-11) |
| LIB | HI-Bibliothek: Steckbrief Profil LIB-INS, eigener Abgleich | `library.yaml:1,5,10`; `konformitaet/README.md:17-27` | Stufe 1 nicht erreicht (8 von 20); 73 Einträge: 21 erfüllt, 15 teilweise, 37 offen; Pilot H zurückgestellt (Bibliothek `docs/design/2026-10-14-bibliothek-gesamtdesign.md:480`) |

### Tabelle 3: Regeln für Navis und Lumen, Buch gegen Repos

| Regel im Buch | Realer Beleg | Bewertung |
|---|---|---|
| Navis liest nur das Sysingboard | sysingdashboard `docs/GESAMTPLAN-SYSING-DASHBOARD.md:476-498` (BSF-10: „klar kontrollierte read-only Quellen“, „Human-in-the-loop“); `docs/BSF-CURRENT-PRIORITIES.md:155` (Punkt 22) | nur geplant, im Code (`src/`) keine Navis-Anbindung |
| Navis schreibt nie | ebd. „keine autonomen produktiven Aktionen“ | geplant, nicht gebaut |
| Lumen liest nur über den Hub | kein Treffer in allen 16 Repos | nicht belegbar, rein erzählerisch |
| Der Hub liest nur Areport | hub `API.md:44` „Der Hub liest ausschließlich Areport.“ | belegt |
| Areport ist einziger technischer Aggregator | hub `REPORTFAMILIE.md:41`; areport `REPORTFAMILIE.md:17-18` | belegt |
| Keine Scores | hub `API.md:101`; areport `README.md:55` | belegt für hub und areport |

## Vorschlag: je ein Satz für die Anhang-Box (Idee 19, nicht eingebaut)

- **ADG:** „Wer bei der Entwicklung von Navis und Lumen was entscheiden darf, Mensch oder KI, regelt die AI Development Governance. Bisher wird sie im Projekt eher als Haltung gelebt als als festes Prüftor.“
- **AQGS:** „Ob eine Funktion fertig ist, misst der Application Quality Gate Standard. Das Sysingboard war seine erste Referenzumsetzung, alle Report-Apps führen ein eigenes Profil, ohne damit schon ein ‚bestanden‘ zu behaupten.“
- **TDF:** „Das Technical Documentation Framework gibt Dokumenten und Nachweisen ihre Ordnung, im Sysingboard etwa im Artefakt- und Nachweisregister.“
- **SEC:** „Der Sicherheitsstandard liefert die Basisanforderungen. In den Apps hinter Navis und Lumen ist er bisher noch nicht ausdrücklich verankert.“
- **DSG:** „Die DSGVO-Anforderungen liegen als eigener Standard vor. Ein ausdrücklicher Bezug in den Apps fehlt noch.“
- **AI:** „Was die EU-KI-Verordnung von Navis und Lumen verlangt, ist als Standard beschrieben. Angewendet wird er bisher nur in den Bibliotheken, als Leitlinie.“
- **LIB:** „Wie eine Bibliothek Wissen prüft und freigibt, legt der Bibliothek-Standard fest. Ennos TDF-Bibliothek ist dagegen abgeglichen, die Institutsbibliothek für Horsts geplante KI steht noch am Anfang.“

Hinweis: Die Sätze zu SEC, DSG und AI beschreiben eine Lücke. Ob das Buch eine Lücke so offen nennen soll, entscheidet der Owner (Idee 19).

## Zusatzfrage k6: ADR im Buch

- **Wortlaut im Buch** (`source/fahrt-zum-kunden.html`):
  - Zeile 1687, Begriff: „ADR – Architecture Decision Record (früher ADF)“
  - Zeile 1688: „Anders als ein gewöhnlicher TDF-Eintrag wird ein ADR nach Verabschiedung nicht mehr verändert, sondern bei Bedarf durch einen neuen, verweisenden Eintrag abgelöst.“ und „Ein ADR beantwortet ‚Warum wurde so entschieden, und was haben wir stattdessen verworfen?‘“
  - Zeile 1711: „… versioniert im selben Repository wie TDF und ADR …“
- **Im Repo:** ai-development-governance `ADR.md:3`: „`ADR` ist ein veralteter Such- und Kompatibilitaetsalias fuer dieses Repository; er endet am 2027-06-30“. Neuer Kurzname ADG (`README.md:5`).
- **Bewertung:** Das Buch meint den Dokumenttyp ADR, den es real gibt (tdfbibliothek führt ihn getrennt als „ADRS – Architecture Decision Records“, `policy/standards-register.json:49-50`). Es meint nicht den Alias des Governance-Repos. ADR im Buch darf deshalb nicht durch ADG ersetzt werden.
- **Vorschlag für einen klärenden Satz** (nach Zeile 1688, nicht eingebaut): „Nicht zu verwechseln mit ADG, der AI Development Governance: Deren Repository war früher auch unter dem Kürzel ADR zu finden, dieser Alias läuft am 30.06.2027 aus.“

## Vorschläge und Ideen (Claude)

1. **„Offen bleibt offen“ aus echtem Material erzählen:** Die Report-Apps führen ihr AQGS-Profil mit `candidate_pass_claim: false`, haben also ein Prüfprofil, ohne „bestanden“ zu behaupten. Das ist ein reales, gut erzählbares Beispiel für die Haltung des Buchs. Es passt in die Anhang-Box zu Idee 19 oder als Detail, wenn Lumen am Konferenztisch einen Wert erklärt.
2. **Lumen ehrlich einordnen:** „Lumen liest nur über den Hub“ steht in keinem Repo, Lumen gibt es real noch nicht. Vorschlag für R06: im Anhang ein halber Satz wie „Lumen ist bisher ein Zielbild; gebaut ist die Seite, die Lumen lesen soll: der Hub, der nur Areport liest.“ So bleibt die Grenze zwischen Erzählung und Realität sichtbar.
3. **Mögliche Korrektur k7 für den Planer:** Zeile 1974 nennt AEAS einen „TDF-Standard“. In tdfbibliothek ist AEAS ein eigenes Familienglied neben TDF. Vorschlag: Der Planer nimmt das als eigene Korrektur auf, nicht unter k1 bis k3.
4. **Lücken schließen per Folgeauftrag:** Ein kleiner Leseauftrag „report-family-platform und uebersicht“ würde klären, ob die Report-Apps ADG und TDF zentral über die Plattform beziehen. Dann wäre die Tabelle für ADG vollständig, und die Anhang-Box müsste weniger „nicht ermittelbar“ sagen.
5. **AQGS-Versionsstand als Hinweis an den Owner:** Das Sysingboard pinnt AQGS 1.0.0-draft, die Report-Apps 1.2.0-draft, aktuell ist 1.10.3-draft. Kein Fehler, aber für das Buch gilt: keine konkrete AQGS-Version nennen, sonst veraltet der Text schnell.
6. **Einfaches Bild für die Anhang-Box:** Statt einer Tabelle sieben kurze Zeilen nach dem Muster „Standard – wofür – wo schon angewendet“. Daneben ein Mermaid-Diagramm mit drei Spalten: Standards, Apps, Bibliotheken, die Linien nur dort, wo Tabelle 2 einen Beleg hat.

## Offene Fragen, Risiken, Abweichungen

- **Abweichung Quelle:** Commit `08ec617` („x“) auf `ops/queue` stammt vom verifizierten Konto `claude`, hat aber weder `Co-Authored-By` noch Claude-Session-Link. Inhalt unauffällig, ausgeführt auf ausdrückliche Anweisung des Owners vom 06.11.2026.
- **Abweichung Arbeitsweise:** Die Recherche für R04 und R10 lief parallel, beide nur lesend. Berichte und Status habe ich in der Reihenfolge der INDEX geschrieben.
- **Nicht geprüft:** `bmarnau-standards/uebersicht`, `bmarnau/report-family-platform` und `bmarnau/ai-development-governance` (von der HI-Bibliothek genannt) standen nicht auf der Klonliste. Ob die Report-Apps ADG oder TDF über report-family-platform beziehen, ist deshalb offen.
- **Unstimmigkeiten in den Quell-Repos** (nur gemeldet, nicht geändert):
  - tdfbibliothek `project.json:5` Version 0.5.0-beta.2 gegen `:10` Tag v0.5.0-beta.1.
  - HI-Bibliothek `docs/adr/ADR-HI-0001_standards-anwenden.md:11` nennt Bibliothek 0.13.0-draft, Register und `library.yaml` nennen 0.14.0-draft.
  - Bibliothek `conformance/tdfbibliothek/befunde.md:5` nennt den alten Stand (67/31/20/8), Zeile 59 den aktuellen (68/31/22/10/5).
  - sysingdashboard `README.md:8` nennt 1.69.0, das CHANGELOG 1.70.0.
- **Hinweis für das Buch:** Zeile 1974 nennt AEAS einen „TDF-Standard“. tdfbibliothek führt AEAS getrennt von TDF (`project.json:46-49`). Das ist eine mögliche weitere Korrektur, nicht Teil von k1 bis k3.
- **Gerätemarker:** In `C:\dev\referenz\tdfbibliothek\.claude\` liegen nur `hooks/` und `settings.json`. `device.local.json` habe ich weder angelegt noch geändert (`ls -la` belegt).

Hygiene: keine gemergten offenen Feature-Branches neu, keine offenen PRs, keine Drafts. Die Referenz-Klone unter `C:\dev\referenz` bleiben für R10 und R03 liegen.

```yaml
Reifegrad: "Belegte Zuordnung der sieben Standards; AQGS breit verankert, SEC/DSG/AI in den Apps nicht"
Projektstatus: "R04 erledigt (Leseauftrag); Grundlage für Idee 19 und k6 liegt vor"
Offene_Fragen:
  - "Idee 19: Soll die Anhang-Box die Lücke bei SEC, DSG und AI offen nennen?"
  - "k6: Klärender Satz zu ADR gegen ADG nach Zeile 1688 übernehmen?"
  - "Soll report-family-platform für die ADG-Zuordnung der Reports nachgeprüft werden?"
Roadmap:
  Sprints_bis_BSF: 1
  Sprints_bis_MVP: 2
```

Die Sprint-Zahlen sind eine Schätzung und nicht belegt.
