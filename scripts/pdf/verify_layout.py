#!/usr/bin/env python3
"""Layout-Check fuer die gerenderte PDF (Renderer: render_story_pdf.py).

Abgeleitet von verify_layout.py (Claude-Projekt, Stand 03.09.2026). Logik und Schwellen sind
unveraendert, nur die Pfade kommen jetzt aus Parametern und die Hilfswerkzeuge werden geprueft.

Geprueft werden sieben Fehlerklassen:
  (1) physischer Seitenrand zu klein oder fehlt
  (2) Text sitzt ohne Innenabstand direkt am Kasten- oder Seitenrand
  (3) mitten im Satz umbrochener Absatz beginnt ohne Abstand auf der Folgeseite
  (4) seitenfuehrender oder -abschliessender Kasten beruehrt den Seitenrand
  (5) Seite ist fast leer (verschleppter Hintergrund eines ueberlaufenden Abschnitts)
  (6) erwartete h2-Ueberschrift fehlt im PDF oder steht in anderer Reihenfolge
  (7) kap-* Anker ohne verlinkenden href (Waisen-Check) oder href ohne Ziel
Punkte (1) bis (5) werden pixelgenau auf Seitenbildern (pdftoppm, 100 dpi) geprueft, (6) und (7)
textbasiert. Exit-Code 0 = sauber, 1 = mindestens eine Verletzung.

Voraussetzungen: Python mit numpy, pillow, pypdf, playwright; pdftoppm (Poppler) im PATH.
Aufruf (aus dem Repo-Stamm): python scripts/pdf/verify_layout.py [--source ...] [--pdf ...] [--no-render]
"""
import argparse, html, os, re, shutil, subprocess, sys, tempfile
from pathlib import Path

# Windows: Ausgabe in Datei oder Pipe nutzt sonst cp1252 und bricht bei Zeichen ausserhalb davon ab.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

try:
    import numpy as np
    from PIL import Image
    import pypdf  # noqa: F401  (wird erst spaeter benutzt, hier nur frueh geprueft)
except ModuleNotFoundError as exc:
    print(f"ABBRUCH: Python-Paket fehlt ({exc.name}). Einrichtung: "
          "python -m pip install -r scripts/pdf/requirements.txt  (siehe docs/PDF-ERZEUGEN.md)")
    sys.exit(2)

ROOT = Path(__file__).resolve().parents[2]
HTML = str(ROOT / "source" / "fahrt-zum-kunden.html")
PDF = str(ROOT / "output" / "Die-Fahrt-zum-Kunden.pdf")
RENDER_SCRIPT = str(Path(__file__).resolve().parent / "render_story_pdf.py")

BG = np.array([0x12, 0x3b, 0x4e])          # --bg, wird in main() aus dem Quelltext gelesen (Standard: Meerblau seit v1.3x)
EXPECTED_MARGIN_PX = 86                     # 22mm bei 100dpi
MARGIN_TOL_PX = 6
MIN_GAP_PX = 8                              # Mindest-Luftzone in reiner --bg-Farbe
STRIP = (115, 400)                          # x-Bereich Inhaltsspalte
COLOR_TOL = 10                              # erlaubte Farbabweichung von --bg pro Kanal
MIN_CONTENT_DENSITY_PCT = 6.0               # Mindestanteil Nicht-Hintergrund-Pixel je Seite im Satzspiegel
ORPHAN_ID_EXCEPTIONS = {"kap-personen"}     # bewusst unverlinkte, aber gueltige kap-* IDs


def render():
    subprocess.run([sys.executable, RENDER_SCRIPT, "--source", HTML, "--out", PDF], check=True)


def page_rows(png_path):
    img = Image.open(png_path).convert("RGB")
    return np.array(img)[:, STRIP[0]:STRIP[1], :]


def find_content_bounds(arr):
    """Erste Zeile des dunklen Seiteninhalts und letzte Zeile des zusammenhaengenden dunklen
    Blocks danach (die Fusszeile im weissen Rand wird bewusst nicht mitgezaehlt)."""
    row_mean = arr.mean(axis=(1, 2))
    top = None
    for y in range(len(row_mean)):
        if row_mean[y] < 240:
            top = y
            break
    if top is None:
        return None, None
    bottom = top
    for y in range(top, len(row_mean)):
        if row_mean[y] < 180:
            bottom = y
        elif row_mean[y] > 235:
            break
    return top, bottom


def rows_match_bg(arr, y0, y1):
    for y in range(y0, y1):
        row = arr[y].astype(int)
        dist = np.abs(row - BG).max(axis=1)
        if (dist > COLOR_TOL).any():
            return False, y
    return True, None


def check_page(png_path, page_no, violations, total_pages=None):
    arr = page_rows(png_path)
    top, bottom = find_content_bounds(arr)
    if top is None:
        return
    # (1) physischer Rand
    if abs(top - EXPECTED_MARGIN_PX) > MARGIN_TOL_PX:
        violations.append(f"Seite {page_no}: physischer Rand oben={top}px, erwartet~{EXPECTED_MARGIN_PX}px")
    if bottom is not None:
        h = arr.shape[0]
        bottom_margin = h - 1 - bottom
        if abs(bottom_margin - EXPECTED_MARGIN_PX) > MARGIN_TOL_PX:
            violations.append(f"Seite {page_no}: physischer Rand unten={bottom_margin}px, erwartet~{EXPECTED_MARGIN_PX}px")
    # (2)/(4) Luftzone direkt nach dem physischen Rand
    ok, bad_y = rows_match_bg(arr, top, top + MIN_GAP_PX)
    if not ok:
        violations.append(f"Seite {page_no}: kein Abstand oben - Kasten/Text beruehrt Rand bei y={bad_y} (Soll: >= {MIN_GAP_PX}px reine Hintergrundfarbe)")
    if bottom is not None:
        ok, bad_y = rows_match_bg(arr, bottom - MIN_GAP_PX + 1, bottom + 1)
        if not ok:
            violations.append(f"Seite {page_no}: kein Abstand unten - Kasten/Text beruehrt Rand bei y={bad_y}")
    # (5) Fast-leere Seite, gemessen nur innerhalb des Satzspiegels. Die letzte Seite wird nicht
    # geprueft: ein kurzer Schlussabsatz allein auf der letzten Seite ist legitim und verschiebt nichts.
    if total_pages is not None and page_no == total_pages:
        return
    full_arr = np.array(Image.open(png_path).convert("RGB"))
    h, w = full_arr.shape[:2]
    left_margin_px = round(EXPECTED_MARGIN_PX * 16 / 22)   # 16mm links/rechts
    y0, y1 = top, (bottom + 1 if bottom is not None else h - EXPECTED_MARGIN_PX)
    x0, x1 = left_margin_px, w - left_margin_px
    inner = full_arr[y0:y1, x0:x1]
    dist_inner = np.abs(inner.astype(int) - BG).max(axis=2)
    density_pct = float((dist_inner > COLOR_TOL).mean() * 100) if inner.size else 0.0
    if density_pct < MIN_CONTENT_DENSITY_PCT:
        violations.append(
            f"Seite {page_no}: nur {density_pct:.2f}% Nicht-Hintergrund-Pixel (Schwelle {MIN_CONTENT_DENSITY_PCT}%) "
            f"- Verdacht auf fast-leere Seite (verschleppter Hintergrund eines ueberlaufenden Abschnitts?)"
        )


STRUCTURAL_CHECKS = [
    ("box-shell hat padding-top", r"\.box-shell\{[^}]*padding-top:\s*\d"),
    ("box-shell hat padding-bottom", r"\.box-shell\{[^}]*padding-bottom:\s*\d"),
    ("box-shell hat break-inside:avoid (Kaesten brechen nie um, daher gilt die Rand-Luftzone unten immer)",
     r"\.box-shell\{[^}]*break-inside:\s*avoid"),
    ("p/h2 haben box-decoration-break:clone (Fix fuer mitten im Satz umbrochene Absaetze)",
     r"p,\s*h2\{[^}]*box-decoration-break:\s*clone"),
]


def check_structure(violations):
    with open(HTML, encoding="utf-8") as f:
        css = f.read()
    for desc, pattern in STRUCTURAL_CHECKS:
        if not re.search(pattern, css):
            violations.append(f"STRUKTUR: {desc} - Regel nicht gefunden/entfernt!")


def _fingerprint(text):
    """Text auf Buchstaben/Ziffern reduzieren (robust gegen Entities, Tags, Whitespace und die
    von pypdf manchmal eingefuegten Leerzeichen)."""
    text = html.unescape(text)
    text = re.sub(r"<[^>]+>", "", text)
    text = text.lower()
    return re.sub(r"[^0-9a-zäöüß]", "", text)


def check_headings_and_links(pdf_text, violations):
    """(6) Ueberschriften-Praesenz und -Reihenfolge; (7) Waisen-Check und tote Links fuer kap-* IDs."""
    with open(HTML, encoding="utf-8") as f:
        content = f.read()
    body = content.split("</style>", 1)[-1]

    headings = re.findall(r"<h2[^>]*>(.*?)</h2>", body, flags=re.S)
    full_fp = _fingerprint(pdf_text)
    cursor = 0
    for raw in headings:
        heading_fp = _fingerprint(raw)
        if not heading_fp:
            continue
        idx = full_fp.find(heading_fp, cursor)
        if idx == -1:
            idx_anywhere = full_fp.find(heading_fp)
            plain = html.unescape(re.sub(r"<[^>]+>", "", raw)).strip()
            if idx_anywhere == -1:
                violations.append(f'UEBERSCHRIFT FEHLT im PDF-Text: "{plain}"')
            else:
                violations.append(
                    f'UEBERSCHRIFT AUSSER REIHENFOLGE: "{plain}" erscheint im PDF vor einer '
                    f"Ueberschrift, die im HTML vor ihr steht - Kapitel evtl. verschoben/vertauscht."
                )
        else:
            cursor = idx + len(heading_fp)

    ids = set(re.findall(r'id="(kap-[^"]+)"', body))
    hrefs = set(re.findall(r'href="#(kap-[^"]+)"', body))
    for i in sorted(ids - hrefs - ORPHAN_ID_EXCEPTIONS):
        violations.append(f'WAISE: id="{i}" wird von keinem href="#{i}" verlinkt (Kapitel evtl. aus Verzeichnis gefallen?)')
    for h in sorted(hrefs - ids):
        violations.append(f'TOTER LINK: href="#{h}" verweist auf keine vorhandene id="{h}"')


def main():
    global HTML, PDF
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--source", default=HTML)
    ap.add_argument("--pdf", default=PDF)
    ap.add_argument("--no-render", action="store_true", help="vorhandene PDF pruefen, nicht neu rendern")
    a = ap.parse_args()
    HTML, PDF = str(Path(a.source).resolve()), str(Path(a.pdf).resolve())
    global BG
    with open(HTML, encoding="utf-8") as f:
        m = re.search(r"--bg:\s*#([0-9a-fA-F]{6})", f.read())
    if m:
        hx = m.group(1)
        BG = np.array([int(hx[0:2], 16), int(hx[2:4], 16), int(hx[4:6], 16)])
        print(f"Hintergrundfarbe aus dem Quelltext: #{hx}")
    else:
        print("HINWEIS: --bg nicht im Quelltext gefunden, Standardfarbe wird verwendet.")

    if not shutil.which("pdftoppm"):
        print("ABBRUCH: pdftoppm (Poppler) fehlt im PATH. Windows: winget install oschwartz10612.Poppler "
              "(danach neues Terminal; siehe docs/PDF-ERZEUGEN.md)")
        sys.exit(2)

    structure = []
    check_structure(structure)
    if structure:
        print("STRUKTUR-CHECK FEHLGESCHLAGEN (vor dem Rendern abgebrochen):")
        for v in structure:
            print(" -", v)
        sys.exit(1)
    print("Struktur-Check OK - alle vier Fix-Mechanismen sind im CSS vorhanden.")

    if not a.no_render:
        render()
    with tempfile.TemporaryDirectory() as tmp:
        prefix = os.path.join(tmp, "chk")
        subprocess.run(["pdftoppm", "-png", "-r", "100", PDF, prefix], check=True)
        pages = sorted(f for f in os.listdir(tmp) if f.endswith(".png"))
        violations = []
        for i, fname in enumerate(pages, start=1):
            check_page(os.path.join(tmp, fname), i, violations, total_pages=len(pages))
        print(f"Geprueft: {len(pages)} Seiten (Rand/Luftzone/Fast-leer-Check)")

        from pypdf import PdfReader
        reader = PdfReader(PDF)
        pdf_text = "\n".join((p.extract_text() or "") for p in reader.pages)
        check_headings_and_links(pdf_text, violations)
        print("Geprueft: Ueberschriften-Reihenfolge + Kapitel-Verlinkung (Inhalt-Check)")

        if violations:
            print(f"FEHLGESCHLAGEN - {len(violations)} Verletzung(en):")
            for v in violations:
                print(" -", v)
            sys.exit(1)
        print("OK - alle Seiten erfuellen den Layout-Check UND den Inhalt-Praesenz-/Positions-Check.")
        sys.exit(0)


if __name__ == "__main__":
    main()
