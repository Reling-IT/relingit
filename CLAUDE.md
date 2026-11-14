# Hinweise für KI-Sitzungen (Claude Code)

Diese Datei ist knapp und verweist auf die vorhandenen Regeln. Sie ersetzt keine davon.

## Maßgebliche Regeln

- [README.md](README.md): Projektstruktur, Veröffentlichung, CI und lokale Arbeitskopie.
- [docs/FREIGABE.md](docs/FREIGABE.md): Freigabetore G1 bis G8. Ohne bestandene Tore kein Merge, kein Tag, kein Upload.
- [docs/SICHERHEIT.md](docs/SICHERHEIT.md): Supabase, Schlüssel und Restrisiken. Das Repository ist öffentlich: keine Zugangsdaten, keine Secret- oder Service-Role-Keys.
- Aufträge und gemeinsame Regeln: `queue/INDEX.yaml` auf dem Branch `ops/queue`. Berichte und Status: `reports/` auf dem Branch `ops/reports`.
- `main` wird nur über einen Pull Request mit grüner CI geändert. Gemergt wird nicht von einer KI-Sitzung.

## Tagesstart und Tagesabschluss

Die Sitzungsroutine folgt ADG `SITZUNGSROUTINE.md` (bmarnau-standards/ai-development-governance, Entwurf). Der Tagesstart ist in [docs/TAGESSTART.md](docs/TAGESSTART.md) beschrieben, der Tagesabschluss im claude.ai-Skill `tagesabschluss-reling-it`. Die Protokolle liegen als signierte Commits auf `ops/reports`. Weil dieses Repository öffentlich ist, gilt TP-09: im Protokoll nur Rollen, keine Kosten, Vertrags- oder Entscheidungsinterna und keine Hinweise auf Sicherheitslücken.

```yaml
sitzungsroutine:
  standard: bmarnau-standards/ai-development-governance, SITZUNGSROUTINE.md
  repos: [Reling-IT/relingit]
  arbeitsklon: C:\dev\relingit
  aufgaben: ops/queue, queue/INDEX.yaml (vorher git fetch)
  plan: ops/reports, reports/STATUS.yaml
  wiederanlauf:
    - README.md
    - scripts/publish-release.ps1
    - scripts/ci-check.ps1
    - ops/reports, reports/STATUS.yaml
    - ops/reports, letzter reports/TAGESBERICHT-JJJJ-MM-TT.md
  ziel: offen            # keine Ziel- oder Meilensteindatei im Repository; Hinweis: YAML-Felder Projektstatus und Roadmap im letzten Tagesbericht
  steckbrief: docs/PILOT.md
  geschuetzt: [main, ops/queue, ops/reports]
  protokoll:
    repo: Reling-IT/relingit
    branch: ops/reports
    ort: reports/
    weg: direkt          # signierter Commit auf ops/reports
    sichtbarkeit: oeffentlich
    datei_start: TAGESSTART-JJJJ-MM-TT.md       # Ausnahme nach TP-01
    datei_abschluss: TAGESBERICHT-JJJJ-MM-TT.md # vorhandene Ablage, künftig mit TA-01 bis TA-07
  zusatz:
    - docs/TAGESSTART.md (Runbook Tagesstart)
    - claude.ai-Skill tagesabschluss-reling-it (Tagesabschluss, Teile A bis D)
    - claude/tagesabschluss.md (Langfassung im Claude-Projekt, nicht im Repository)
    - Auftrag R29 in ops/queue (Tagesabschluss-Prüfung); lokale Löschungen nur über Auftrag R13
    - repo-aktualisieren.ps1 (Arbeitskopie per Fast-Forward aktualisieren, siehe README.md)
```
