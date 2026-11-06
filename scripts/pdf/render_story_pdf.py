#!/usr/bin/env python3
"""Rendert source/fahrt-zum-kunden.html zu einer PDF-Datei (A4, getaggt).

Abgeleitet von render_story_pdf.py (Claude-Projekt, Stand 27.08.2026). Unterschiede:
- Pfade per Parameter (kein fester Cloud-Pfad), Standard relativ zum Repo.
- Der Renderstand auf dem Deckblatt (#render-stamp) nutzt die echte Zeitzone Europe/Berlin
  und beschriftet sie korrekt als MEZ oder MESZ (vorher fest MESZ).
- Chromium wird von Playwright selbst gefunden (kein fester Browserpfad).
Aufruf (aus dem Repo-Stamm): python scripts/pdf/render_story_pdf.py [--source ...] [--out ...]
"""
import argparse
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[2]


def stamp_text():
    now = datetime.now(ZoneInfo("Europe/Berlin"))
    zone = "MESZ" if now.dst() else "MEZ"
    return "Renderstand: " + now.strftime("%d.%m.%Y, %H:%M Uhr") + f" ({zone})"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--source", default=str(ROOT / "source" / "fahrt-zum-kunden.html"))
    ap.add_argument("--out", default=str(ROOT / "output" / "Die-Fahrt-zum-Kunden.pdf"))
    a = ap.parse_args()
    src, out = Path(a.source).resolve(), Path(a.out).resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    stamp = stamp_text()

    from playwright.sync_api import sync_playwright
    with sync_playwright() as p:
        browser = p.chromium.launch()
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
            footer_template='<div style="font-size:7pt; color:#8a94ab; width:100%; padding:0 16mm; display:grid; grid-template-columns:1fr auto 1fr; align-items:center; font-family:Arial,sans-serif;"><span style="text-align:left;">Die Fahrt zum Kunden &middot; frei erfunden</span><span style="text-align:center;"><span class="pageNumber"></span></span><span></span></div>',
        )
        browser.close()

    from pypdf import PdfReader, PdfWriter
    reader = PdfReader(str(out))
    writer = PdfWriter()
    writer.append(reader)
    writer.add_metadata({
        "/Title": "Die Fahrt zum Kunden - Navis & Lumen",
        "/Author": "Bernd Marnau",
        "/Subject": "Frei erfundene Kurzgeschichte - Vorbereitungsmaterial Workshop September 2026",
        "/Keywords": "Navis, Lumen, KI-Zentrale, KI-Strategie, Sysingboard, Report-Familie",
        "/Creator": "Bernd Marnau mit KI-gestuetzter Ausarbeitung (Claude, Anthropic)",
    })
    with open(out, "wb") as f:
        writer.write(f)
    print("OK ->", out, "| Seiten:", len(reader.pages), "|", stamp)


if __name__ == "__main__":
    main()
