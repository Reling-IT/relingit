/**
 * Renders the current HTML story inside the site's own viewer.
 *
 * Supabase may serve uploaded HTML as text/plain for security reasons. Fetching
 * the trusted release as text and assigning it to iframe.srcdoc preserves the
 * intended design without depending on the storage response's MIME type.
 *
 * Der Viewer dient lesen.html (ganze Geschichte) und anhang.html (nur der
 * Anhang). Beide laden dieselbe Buchfassung (Supabase, sonst lokal); es gibt
 * keinen zweiten Upload (Entscheidung q15, R46). Unterschiede stehen als
 * data-Attribute am iframe:
 *   data-extract           "anhang" = nur die Bloecke section.appendix aus der
 *                          Buchfassung zeigen, mit eigenem Inhaltsverzeichnis
 *   data-top-label         erster Eintrag im Inhaltsverzeichnis
 *   data-outside-target    Seite fuer interne Links, deren Ziel nicht im
 *                          geladenen Dokument steht (z. B. lesen.html)
 *   data-status-text       Statustext nach erfolgreichem Laden
 */
const config = window.SUPABASE_CONFIG ?? {};
const frame = document.querySelector("#story-frame");
const statusNode = document.querySelector("#story-status");
const releaseNode = document.querySelector("#story-release");
const errorNode = document.querySelector("#story-error");
const chapterSelect = document.querySelector("#chapter-select");
const currentSectionNode = document.querySelector("#current-section");
const zoomOutButton = document.querySelector("#zoom-out");
const zoomResetButton = document.querySelector("#zoom-reset");
const zoomInButton = document.querySelector("#zoom-in");
const localStoryUrl = "story/current/fahrt-zum-kunden.html";
const extractAppendixOnly = frame.dataset.extract === "anhang";
const topLabel = frame.dataset.topLabel || "Anfang der Geschichte";
const outsideTargetPage = frame.dataset.outsideTarget || "";
const loadedStatusText = frame.dataset.statusText || "";
const minimumZoom = 0.7;
const maximumZoom = 1.6;
const zoomStep = 0.1;

let zoomLevel = 1;
let storyChapters = [];

function hasSupabaseConfig() {
  return Boolean(
    config.url &&
      config.publishableKey &&
      !config.publishableKey.includes("HIER_"),
  );
}

async function fetchStory(url) {
  const controller = new AbortController();
  const timeout = window.setTimeout(() => controller.abort(), 15000);
  const separator = url.includes("?") ? "&" : "?";

  let response;
  try {
    response = await fetch(`${url}${separator}viewer=${Date.now()}`, {
      cache: "no-store",
      signal: controller.signal,
    });
  } finally {
    window.clearTimeout(timeout);
  }
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return withAbsoluteFontUrls(await response.text());
}

/**
 * In srcdoc gelten relative Pfade gegenueber lesen.html, nicht gegenueber
 * story/current/. Die Buchquelle verweist mit ../assets/fonts/ bzw.
 * ../../assets/fonts/ auf die Schriften; ohne Umschreiben landen diese
 * Pfade ausserhalb des Seitenordners (404). Deshalb werden sie hier auf
 * den assets/fonts/-Ordner neben lesen.html abgebildet.
 */
function withAbsoluteFontUrls(markup) {
  const fontBase = new URL("assets/fonts/", document.baseURI).href;
  return markup.replace(
    /url\((["']?)(?:\.\.\/)+assets\/fonts\//g,
    (_match, quote) => `url(${quote}${fontBase}`,
  );
}

/**
 * Entfernt alles Ausfuehrbare aus einem Teilbaum: Skripte, eingebettete
 * Dokumente, Formulare, Event-Handler-Attribute und javascript:-Adressen.
 * Die Sandbox des iframes (ohne allow-scripts) verhindert Skripte ohnehin;
 * das hier ist die zweite Sicherung fuer den Anhang.
 */
function removeExecutableContent(root) {
  root
    .querySelectorAll("script, noscript, iframe, frame, object, embed, form, link, meta, base")
    .forEach((node) => node.remove());
  root.querySelectorAll("*").forEach((element) => {
    Array.from(element.attributes).forEach((attribute) => {
      const name = attribute.name.toLowerCase();
      const value = attribute.value.replace(/[\s\u0000-\u001f]+/g, "").toLowerCase();
      const isUrlAttribute = ["href", "src", "xlink:href", "action", "formaction", "srcset"].includes(name);
      if (
        name.startsWith("on") ||
        (isUrlAttribute && (value.startsWith("javascript:") || value.startsWith("vbscript:")))
      ) {
        element.removeAttribute(attribute.name);
      }
    });
  });
}

/**
 * Baut aus der Buchfassung ein eigenes Dokument nur mit dem Anhang:
 * Stylesheets der Buchfassung (gleiche Gestaltung, Schriften bereits auf
 * assets/fonts/ umgeschrieben), Inhaltsverzeichnis, alle Bloecke
 * section.appendix samt ihrer box-shell-Huelle und der Buch-Fuss.
 * DOMParser fuehrt keine Skripte aus und laedt keine Ressourcen.
 */
function extractAppendix(markup) {
  const book = new DOMParser().parseFromString(markup, "text/html");
  const sections = Array.from(book.querySelectorAll("section.appendix"));
  if (sections.length === 0) throw new Error("Keine Anhang-Bloecke in der Buchfassung");

  const appendix = document.implementation.createHTMLDocument("Anhang | Die Fahrt zum Kunden");
  const charset = appendix.createElement("meta");
  charset.setAttribute("charset", "utf-8");
  appendix.head.prepend(charset);
  book.querySelectorAll("head style").forEach((style) => {
    appendix.head.append(appendix.importNode(style, true));
  });

  const wrap = appendix.createElement("div");
  wrap.className = "wrap";
  const toc = appendix.createElement("nav");
  toc.className = "cover-toc";
  toc.id = "anhang-inhalt";
  toc.setAttribute("aria-label", "Inhaltsverzeichnis des Anhangs");
  const tocTitle = appendix.createElement("div");
  tocTitle.className = "cover-toc-title";
  tocTitle.textContent = "Anhang \u00b7 Inhalt";
  toc.append(tocTitle);
  const coverSpans = Array.from(book.querySelectorAll(".cover-meta span"))
    .map((span) => span.textContent.trim());
  const version = coverSpans.find((text) => /^Version\s+\d+\.\d+$/.test(text));
  const date = coverSpans.find((text) => /^\d{2}\.\d{2}\.\d{4}$/.test(text));
  if (version) {
    const stand = appendix.createElement("div");
    stand.className = "cover-toc-group";
    const label = appendix.createElement("span");
    label.className = "cover-toc-label";
    label.textContent = `Die Fahrt zum Kunden \u00b7 ${version}${date ? ` vom ${date}` : ""}`;
    stand.append(label);
    toc.append(stand);
  }
  wrap.append(toc);

  sections.forEach((section) => {
    const heading = section.querySelector("h2");
    const id = section.id || heading?.id || "";
    const title = heading?.textContent.replace(/\s+/g, " ").trim() || "";
    const shell = section.parentElement;
    const block =
      shell?.classList.contains("box-shell") && shell.children.length === 1 ? shell : section;
    wrap.append(appendix.importNode(block, true));
    if (!id || !title) return;

    const group = appendix.createElement("div");
    group.className = "cover-toc-group";
    const link = appendix.createElement("a");
    link.href = `#${id}`;
    link.textContent = title;
    group.append(link);
    toc.append(group);
  });

  const footer = book.querySelector("footer");
  if (footer) {
    const footerShell = footer.parentElement?.classList.contains("box-shell")
      ? footer.parentElement
      : footer;
    wrap.append(appendix.importNode(footerShell, true));
  }

  appendix.body.append(wrap);
  removeExecutableContent(appendix.body);
  return `<!DOCTYPE html>\n${appendix.documentElement.outerHTML}`;
}

function prepareMarkup(markup) {
  return extractAppendixOnly ? extractAppendix(markup) : markup;
}

function applyZoom() {
  const storyDocument = frame.contentDocument;
  if (!storyDocument) return;

  storyDocument.documentElement.style.zoom = String(zoomLevel);
  const zoomPercent = `${Math.round(zoomLevel * 100)} %`;
  zoomResetButton.textContent = zoomPercent;
  zoomResetButton.setAttribute("aria-label", `${zoomPercent} – Originalgröße wiederherstellen`);
  zoomOutButton.disabled = zoomLevel <= minimumZoom;
  zoomInButton.disabled = zoomLevel >= maximumZoom;
  updateCurrentSection();
}

function changeZoom(change) {
  zoomLevel = Math.min(
    maximumZoom,
    Math.max(minimumZoom, Number((zoomLevel + change).toFixed(1))),
  );
  applyZoom();
}

function updateCurrentSection() {
  const storyWindow = frame.contentWindow;
  if (!storyWindow || storyChapters.length === 0) return;

  const readingLine = storyWindow.scrollY + 140;
  let currentIndex = -1;

  storyChapters.forEach((chapter, index) => {
    const chapterTop =
      chapter.heading.getBoundingClientRect().top + storyWindow.scrollY;
    if (chapterTop <= readingLine) currentIndex = index;
  });

  if (currentIndex < 0) {
    chapterSelect.value = "__top";
    currentSectionNode.textContent = "Anfang";
    return;
  }

  const current = storyChapters[currentIndex];
  chapterSelect.value = current.id;
  currentSectionNode.textContent =
    `Abschnitt ${currentIndex + 1} von ${storyChapters.length}: ${current.title}`;
}

function buildChapterNavigation() {
  const storyDocument = frame.contentDocument;
  const storyWindow = frame.contentWindow;
  if (!storyDocument || !storyWindow) return;

  storyChapters = Array.from(storyDocument.querySelectorAll("h2"))
    .map((heading, index) => {
      const existingId = heading.id || heading.closest("[id]")?.id;
      const id = existingId || `leseabschnitt-${index + 1}`;
      if (!existingId) heading.id = id;
      return { id, title: heading.textContent.trim(), heading };
    })
    .filter((chapter) => chapter.title);

  chapterSelect.replaceChildren();
  chapterSelect.add(new Option(topLabel, "__top"));
  storyChapters.forEach((chapter) => {
    chapterSelect.add(new Option(chapter.title, chapter.id));
  });
  chapterSelect.disabled = storyChapters.length === 0;

  storyWindow.addEventListener("scroll", updateCurrentSection, {
    passive: true,
  });
  updateCurrentSection();
}

function enableInternalStoryLinks() {
  const storyDocument = frame.contentDocument;
  if (!storyDocument) return;

  storyDocument.querySelectorAll('a[href^="#"]').forEach((link) => {
    link.addEventListener("click", (event) => {
      const fragment = link.getAttribute("href").slice(1);
      if (!fragment) return;

      const targetId = decodeURIComponent(fragment);
      const target = storyDocument.getElementById(targetId);
      if (!target) {
        // Ziel liegt ausserhalb des geladenen Dokuments (Anhang verweist auf
        // ein Kapitel): im Hauptfenster auf der Lesefassung oeffnen.
        if (outsideTargetPage) {
          event.preventDefault();
          window.location.assign(`${outsideTargetPage}#${encodeURIComponent(targetId)}`);
        }
        return;
      }

      event.preventDefault();
      target.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  });
}

/**
 * Springt nach dem Laden zu einem Anker aus der Adresse (z. B.
 * lesen.html#kap-umweg oder anhang.html#kap-versionen).
 */
function scrollToLocationHash() {
  const storyDocument = frame.contentDocument;
  const fragment = window.location.hash.slice(1);
  if (!storyDocument || !fragment) return;

  let targetId;
  try {
    targetId = decodeURIComponent(fragment);
  } catch {
    return;
  }
  storyDocument.getElementById(targetId)?.scrollIntoView({ block: "start" });
}

async function loadReleaseInfo() {
  if (!hasSupabaseConfig()) return;

  try {
    const endpoint =
      `${config.url}/rest/v1/story_release` +
      "?id=eq.current&select=version,display_date";
    const response = await fetch(endpoint, {
      headers: { apikey: config.publishableKey },
    });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);

    const [release] = await response.json();
    if (release) {
      releaseNode.textContent =
        `Version ${release.version} · ${release.display_date}`;
    }
  } catch (error) {
    console.warn("Release metadata could not be loaded", error);
  }
}

async function loadStory() {
  const remoteStoryUrl = hasSupabaseConfig()
    ? `${config.url}/storage/v1/object/public/story/current/fahrt-zum-kunden.html`
    : localStoryUrl;

  try {
    frame.srcdoc = prepareMarkup(await fetchStory(remoteStoryUrl));
    statusNode.textContent = loadedStatusText || "Aktuelle HTML-Lesefassung";
  } catch (remoteError) {
    try {
      frame.srcdoc = prepareMarkup(await fetchStory(localStoryUrl));
      statusNode.textContent = loadedStatusText || "Lokale HTML-Lesefassung";
    } catch (localError) {
      statusNode.textContent = "Laden fehlgeschlagen";
      errorNode.hidden = false;
      console.error("Story loading failed", remoteError, localError);
    }
  }
}

loadReleaseInfo();
loadStory();

frame.addEventListener("load", () => {
  buildChapterNavigation();
  enableInternalStoryLinks();
  applyZoom();
  scrollToLocationHash();
});
chapterSelect.addEventListener("change", () => {
  const storyDocument = frame.contentDocument;
  const storyWindow = frame.contentWindow;
  if (!storyDocument || !storyWindow) return;

  if (chapterSelect.value === "__top") {
    storyWindow.scrollTo({ top: 0, behavior: "smooth" });
    return;
  }

  storyDocument
    .getElementById(chapterSelect.value)
    ?.scrollIntoView({ behavior: "smooth", block: "start" });
});
zoomOutButton.addEventListener("click", () => changeZoom(-zoomStep));
zoomInButton.addEventListener("click", () => changeZoom(zoomStep));
zoomResetButton.addEventListener("click", () => {
  zoomLevel = 1;
  applyZoom();
});
