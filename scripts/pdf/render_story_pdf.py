#!/usr/bin/env python3
"""Rendert source/fahrt-zum-kunden.html zu einer PDF-Datei (A4, getaggt).

Abgeleitet von render_story_pdf.py (Claude-Projekt, Stand 27.08.2026). Unterschiede:
- Pfade per Parameter (kein fester Cloud-Pfad), Standard relativ zum Repo.
- Der Renderstand auf dem Deckblatt (#render-stamp) nutzt die echte Zeitzone Europe/Berlin
  und beschriftet sie korrekt als MEZ oder MESZ (vorher fest MESZ).
- Chromium wird von Playwright selbst gefunden (kein fester Browserpfad).
- Profil "handout" rendert story/current/workshop-handout.html mit eigener Fusszeile und
  eigenen Metadaten (gleiche Seitenraender, gleiches Format wie die Geschichte).
Aufruf (aus dem Repo-Stamm): python scripts/pdf/render_story_pdf.py [--profil geschichte|handout]
                                                                    [--source ...] [--out ...]
"""
import argparse
import sys
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

# Windows: Ausgabe in Datei oder Pipe nutzt sonst cp1252 und bricht bei Zeichen ausserhalb davon ab.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SETUP_HINT = "Einrichtung siehe docs/PDF-ERZEUGEN.md"

ROOT = Path(__file__).resolve().parents[2]

# Je Profil: Standardpfade, Text links in der Fusszeile und PDF-Metadaten.
# Der Anlass (Monat und Jahr des Workshops) steht nur hier.
ANLASS = "Ende November 2026"
PROFILE = {
    "geschichte": {
        "source": ROOT / "source" / "fahrt-zum-kunden.html",
        "out": ROOT / "output" / "Die-Fahrt-zum-Kunden.pdf",
        "footer": "Die Fahrt zum Kunden &middot; frei erfunden",
        "meta": {
            "/Title": "Die Fahrt zum Kunden - Navis & Lumen",
            "/Author": "Bernd Marnau",
            "/Subject": "Frei erfundene Kurzgeschichte - Vorbereitungsmaterial Workshop " + ANLASS,
            "/Keywords": "Navis, Lumen, KI-Zentrale, KI-Strategie, Sysingboard, Report-Familie",
            "/Creator": "Bernd Marnau mit KI-gestuetzter Ausarbeitung (Claude, Anthropic)",
        },
    },
    "handout": {
        "source": ROOT / "story" / "current" / "workshop-handout.html",
        "out": ROOT / "output" / "workshop-handout.pdf",
        "footer": "Der Reling-IT-Transfer &middot; frei erfunden",
        "meta": {
            "/Title": "Der Reling-IT-Transfer - Workshop-Handout",
            "/Author": "Bernd Marnau",
            "/Subject": "Begleitmaterial zu 'Die Fahrt zum Kunden' - Workshop-Vorbereitung " + ANLASS,
            "/Keywords": "Navis, Lumen, Sysingboard, Report-Familie, Workshop, Manoeverkritik",
            "/Creator": "Bernd Marnau mit KI-gestuetzter Ausarbeitung (Claude, Anthropic)",
        },
    },
}


def stamp_text():
    try:
        tz = ZoneInfo("Europe/Berlin")
    except ZoneInfoNotFoundError:
        # Windows hat keine IANA-Zeitzonendatenbank; sie kommt dort aus dem Paket tzdata.
        sys.exit("ABBRUCH: Zeitzone Europe/Berlin unbekannt. python -m pip install tzdata  (" + SETUP_HINT + ")")
    now = datetime.now(tz)
    zone = "MESZ" if now.dst() else "MEZ"
    return "Renderstand: " + now.strftime("%d.%m.%Y, %H:%M Uhr") + f" ({zone})"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--profil", choices=sorted(PROFILE), default="geschichte",
                    help="geschichte (Standard) oder handout: Fusszeile, Metadaten und Standardpfade")
    ap.add_argument("--source", default=None, help="HTML-Quelle (Standard je Profil)")
    ap.add_argument("--out", default=None, help="Ziel-PDF (Standard je Profil, unter output/)")
    a = ap.parse_args()
    profil = PROFILE[a.profil]
    src = Path(a.source or profil["source"]).resolve()
    out = Path(a.out or profil["out"]).resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    stamp = stamp_text()

    if not src.is_file():
        sys.exit(f"ABBRUCH: Quelle nicht gefunden: {src}")
    try:
        from playwright.sync_api import sync_playwright, Error as PlaywrightError
        from pypdf import PdfReader, PdfWriter
    except ModuleNotFoundError as exc:
        sys.exit(f"ABBRUCH: Python-Paket fehlt ({exc.name}). "
                 "python -m pip install -r scripts/pdf/requirements.txt  (" + SETUP_HINT + ")")
    with sync_playwright() as p:
        try:
            browser = p.chromium.launch()
        except PlaywrightError as exc:
            if "Executable doesn't exist" in str(exc):
                sys.exit("ABBRUCH: Chromium fuer Playwright fehlt. python -m playwright install chromium  ("
                         + SETUP_HINT + ")")
            raise
        page = browser.new_page()
        page.goto(src.as_uri())
        page.wait_for_timeout(400)  # Webfonts setzen lassen
        page.eval_on_selector("#render-stamp", "(el, s) => { el.textContent = s; }", stamp)
        page.pdf(
            path=str(out),
            tagged=True,
            format="A4",
            print_background=True,
            # top/bottom bewusst groesser als links/rechts: Chromium kappt beim PDF-Druck den
            # margin-top/-bottom einzelner Boxen an Seitenumbruechen. Der physische Seitenrand
            # wirkt garantiert auf jedes Element (siehe @media print im Quelltext).
            margin={"top": "22mm", "bottom": "22mm", "left": "16mm", "right": "16mm"},
            display_header_footer=True,
            header_template="<div></div>",
            footer_template='<div style="font-size:7pt; color:#8a94ab; width:100%; padding:0 16mm; display:grid; grid-template-columns:1fr auto 1fr; align-items:center; font-family:Arial,sans-serif;"><span style="text-align:left;">' + profil["footer"] + '</span><span style="text-align:center;"><span class="pageNumber"></span></span><span></span></div>',
        )
        browser.close()

    reader = PdfReader(str(out))
    writer = PdfWriter()
    writer.append(reader)
    writer.add_metadata(profil["meta"])
    with open(out, "wb") as f:
        writer.write(f)
    print("OK ->", out, "| Seiten:", len(reader.pages), "|", stamp)


if __name__ == "__main__":
    main()
