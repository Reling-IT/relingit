# Gemeinsame, plattformunabhängige Qualitätsprüfung für lokal und GitHub Actions.
$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot
$failures = [System.Collections.Generic.List[string]]::new()

# Diese Dateien bilden die minimale veröffentlichungsfähige Website.
$requiredFiles = @(
    ".htaccess", "index.html", "lesen.html", "anhang.html", "pdf.html", "handout.html", "handout-pdf.html", "admin.html", "impressum.html", "datenschutz.html",
    "story/current/fahrt-zum-kunden.html", "story/current/geschichte.pdf", "story/current/workshop-handout.html", "story/current/workshop-handout.pdf",
    "assets/img/reling-it-logo.svg", "assets/img/favicon.png",
    "assets/css/styles.css", "assets/css/legal.css",
    "assets/js/app.js", "assets/js/admin.js", "assets/js/pdf-viewer.js", "assets/js/story-viewer.js", "assets/js/handout-viewer.js",
    "assets/js/supabase-config.js", "supabase/setup.sql", "supabase/config.toml",
    "supabase/functions/submit-feedback/index.ts", "supabase/tests/security-checks.sql",
    "source/fahrt-zum-kunden.html", "source/Die-Fahrt-zum-Kunden.pdf"
)
foreach ($file in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        $failures.Add("Pflichtdatei fehlt: $file")
    }
}

# Sicherheitsinvarianten: Die folgenden Prüfungen verhindern, dass spätere
# Änderungen MFA, Rate-Limit oder die Viewer-Sandbox unbemerkt abschalten.
$adminText = Get-Content -Raw -LiteralPath "assets/js/admin.js"
$adminHtmlText = Get-Content -Raw -LiteralPath "admin.html"
$feedbackClientText = Get-Content -Raw -LiteralPath "assets/js/app.js"
$setupText = Get-Content -Raw -LiteralPath "supabase/setup.sql"
$edgeText = Get-Content -Raw -LiteralPath "supabase/functions/submit-feedback/index.ts"
$supabaseConfigText = Get-Content -Raw -LiteralPath "supabase/config.toml"
$viewerTexts = @(
    Get-Content -Raw -LiteralPath "lesen.html"
    Get-Content -Raw -LiteralPath "handout.html"
    if (Test-Path -LiteralPath "anhang.html") { Get-Content -Raw -LiteralPath "anhang.html" }
)
if ($adminText -notmatch '/factors/.+/challenge' -or $adminText -notmatch '/factors/.+/verify') {
    $failures.Add("Adminbereich enthält keinen vollständigen MFA-Challenge-/Verify-Ablauf")
}
if ($adminText -notmatch 'authRequest\("/user"\)' -or $adminText -match 'const factors = await authRequest\("/factors"\)') {
    $failures.Add("Adminbereich liest MFA-Faktoren nicht über den unterstützten Benutzer-Endpunkt")
}
if ($adminText -notmatch 'new Blob\(\[qrCode\].+image/svg\+xml') {
    $failures.Add("Adminbereich kann den von Supabase gelieferten SVG-QR-Code nicht sicher anzeigen")
}
if ($adminText -notmatch 'trimStart\(\)\.startsWith\("<"\)') {
    $failures.Add("Adminbereich erkennt keinen SVG-QR-Code mit XML-Deklaration")
}
if ($adminText -notmatch 'factor\.status === "unverified"' -or $adminText -notmatch 'method:\s*"DELETE"') {
    $failures.Add("Adminbereich bereinigt keinen abgebrochenen unbestätigten MFA-Faktor")
}
if ($adminText -notmatch 'issuer:\s*"https://berndmarnau\.de/relingit"') {
    $failures.Add("MFA-Eintrag besitzt keinen eindeutig erkennbaren Reling-IT-Herausgeber")
}
if ($adminText -notmatch 'validateStoryFiles' -or $adminText -notmatch 'Die gewählte HTML-Datei ist der Viewer') {
    $failures.Add("Adminbereich verhindert keinen versehentlichen Viewer-Upload als Geschichte")
}
if ($adminText -notmatch 'aal2') {
    $failures.Add("Adminbereich prüft den AAL2-Status nicht")
}
if ($adminHtmlText -notmatch 'id="reset-request-form"' -or $adminHtmlText -notmatch 'id="reset-password-form"') {
    $failures.Add("Adminbereich enthält keinen vollständigen Passwort-Rücksetzdialog")
}
if ($adminText -notmatch '/recover\?redirect_to=' -or $adminText -notmatch 'method:\s*"PUT"' -or $adminText -notmatch 'recoveryRedirectUrl') {
    $failures.Add("Adminbereich enthält keinen vollständigen Supabase-Passwort-Rücksetzablauf")
}
if ($setupText -notmatch "auth\.jwt\(\)\s*->>\s*'aal'.*'aal2'") {
    $failures.Add("Supabase-RLS erzwingt AAL2 nicht serverseitig")
}
if ($setupText -notmatch 'revoke all on table public\.reader_feedback from anon, authenticated') {
    $failures.Add("Direkter anonymer Feedbackzugriff ist nicht explizit entzogen")
}
if ($feedbackClientText -match '/rest/v1/reader_feedback' -or $feedbackClientText -notmatch '/functions/v1/submit-feedback') {
    $failures.Add("Feedback läuft nicht ausschließlich über die Edge Function")
}
if ($edgeText -notmatch 'FEEDBACK_HASH_SALT' -or $edgeText -notmatch 'submit_reader_feedback') {
    $failures.Add("Edge Function enthält keinen pseudonymen serverseitigen Rate-Limit-Ablauf")
}
if ($supabaseConfigText -notmatch 'verify_jwt\s*=\s*false') {
    $failures.Add("Öffentliche Feedbackfunktion ist nicht korrekt konfiguriert")
}
foreach ($viewerText in $viewerTexts) {
    if ($viewerText -match 'sandbox="[^"]*allow-scripts') {
        $failures.Add("Viewer erlaubt Skriptausführung in eingebetteten Dokumenten")
    }
}

# Jedes interne Inhaltsverzeichnisziel der Geschichte muss tatsächlich als ID
# existieren. So wird kein Paket mit scheinbar anklickbaren, aber wirkungslosen
# Kapitellinks veröffentlicht.
$storyHtmlText = Get-Content -Raw -LiteralPath "story/current/fahrt-zum-kunden.html"
$storyIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
[regex]::Matches($storyHtmlText, '\sid\s*=\s*["''](?<id>[^"'']+)["'']', 'IgnoreCase') | ForEach-Object {
    [void]$storyIds.Add([System.Net.WebUtility]::HtmlDecode($_.Groups['id'].Value))
}
$storyInternalLinks = [regex]::Matches($storyHtmlText, 'href\s*=\s*["'']#(?<target>[^"'']*)["'']', 'IgnoreCase')
foreach ($link in $storyInternalLinks) {
    $target = [uri]::UnescapeDataString([System.Net.WebUtility]::HtmlDecode($link.Groups['target'].Value))
    if ($target -and -not $storyIds.Contains($target)) {
        $failures.Add("Interner Story-Link hat kein Ziel: #$target")
    }
}
if ($storyInternalLinks.Count -eq 0) {
    $failures.Add("Geschichte enthält keine prüfbaren internen Inhaltsverzeichnis-Links")
}

# Anhang-Seite (R07, R46): anhang.html schneidet die Blöcke section.appendix im
# Browser aus der Buchfassung heraus und baut daraus ihr Inhaltsverzeichnis.
# Dafür braucht jeder Block eine Überschrift (h2) und eine eindeutige, stabile
# ID: an der section oder, falls dort keine steht, an ihrer ersten h2. Die ID
# hat die Form kap-<name> und kommt im ganzen Buch genau einmal vor. Geprüft
# wird nur die Buchquelle; eine erzeugte Datei gibt es nicht.
function Test-AppendixAnchors([string]$text, [string]$label) {
    $found = [System.Collections.Generic.List[string]]::new()
    $blocks = [regex]::Matches($text, '<section\s+class="appendix"(?<attr>[^>]*)>(?<inhalt>[\s\S]*?)</section>')
    if ($blocks.Count -eq 0) { $found.Add("${label}: keine Anhang-Blöcke (section.appendix)") }
    $seen = @{}
    foreach ($block in $blocks) {
        $line = ([regex]::Matches($text.Substring(0, $block.Index), "`n")).Count + 1
        $heading = [regex]::Match($block.Groups['inhalt'].Value, '<h2(?<attr>[^>]*)>(?<titel>[\s\S]*?)</h2>')
        $title = if ($heading.Success) {
            ([System.Net.WebUtility]::HtmlDecode([regex]::Replace($heading.Groups['titel'].Value, '<[^>]+>', '')) -replace '\s+', ' ').Trim()
        } else { "" }
        if (-not $title) { $found.Add("${label}: Anhang-Block in Zeile ${line} ohne Überschrift (h2) für das Inhaltsverzeichnis") }
        $sectionId = [regex]::Match($block.Groups['attr'].Value, '\sid="(?<id>[^"]*)"')
        $headingId = if ($heading.Success) { [regex]::Match($heading.Groups['attr'].Value, '\sid="(?<id>[^"]*)"') } else { [System.Text.RegularExpressions.Match]::Empty }
        $id = if ($sectionId.Success) { $sectionId.Groups['id'].Value } elseif ($headingId.Success) { $headingId.Groups['id'].Value } else { "" }
        if (-not $id) {
            $found.Add("${label}: Anhang-Block in Zeile $line ('$title') ohne ID an section.appendix oder an der ersten h2")
        } elseif ($id -notmatch '^kap-[a-z0-9]+(?:-[a-z0-9]+)*$') {
            $found.Add("${label}: Anhang-Block in Zeile $line ('$title'): ID '$id' entspricht nicht dem Muster kap-<name>")
        } elseif ($seen.ContainsKey($id)) {
            $found.Add("${label}: Anhang-Block in Zeile $line ('$title'): ID '$id' schon in Zeile $($seen[$id]) vergeben")
        } else {
            $seen[$id] = $line
            $count = [regex]::Matches($text, '\sid="' + [regex]::Escape($id) + '"').Count
            if ($count -ne 1) { $found.Add("${label}: Anhang-Block in Zeile $line ('$title'): ID '$id' kommt im Buch $count-mal vor") }
        }
    }
    return $found
}

# Versionsnummer und Veröffentlichungsdatum müssen in Landingpage-Logik,
# Leseansicht und eigentlicher Geschichte denselben Stand ausweisen.
$appText = Get-Content -Raw -LiteralPath "assets/js/app.js"
$readerText = Get-Content -Raw -LiteralPath "lesen.html"
$storyText = Get-Content -Raw -LiteralPath "story/current/fahrt-zum-kunden.html"
$sourceStoryText = Get-Content -Raw -LiteralPath "source/fahrt-zum-kunden.html"

$appRelease = [regex]::Match(
    $appText,
    'fallbackRelease\s*=\s*\{[\s\S]*?version:\s*"(?<version>[^"]+)"[\s\S]*?date:\s*"(?<date>[^"]+)"'
)
$readerRelease = [regex]::Match(
    $readerText,
    'id="story-release"[^>]*>\s*Version\s+(?<version>[^<·]+?)\s*·\s*(?<date>[^<]+?)\s*</strong>'
)
$storyMeta = [regex]::Match(
    $storyText,
    '<div\s+class="cover-meta">(?<content>[\s\S]*?)</div>'
)
$storyDateMatch = if ($storyMeta.Success) {
    [regex]::Match($storyMeta.Groups['content'].Value, '<span>\s*(?<date>\d{2}\.\d{2}\.\d{4})\s*</span>')
} else { [System.Text.RegularExpressions.Match]::Empty }
$storyVersionMatch = if ($storyMeta.Success) {
    [regex]::Match($storyMeta.Groups['content'].Value, '<span>\s*Version\s+(?<version>[^<]+?)\s*</span>')
} else { [System.Text.RegularExpressions.Match]::Empty }

if (-not $appRelease.Success) { $failures.Add("Versionsangabe in assets/js/app.js nicht lesbar") }
if (-not $readerRelease.Success) { $failures.Add("Versionsangabe in lesen.html nicht lesbar") }
# Die Anhang-Seite trägt denselben Rückfallstand wie lesen.html; publish-release.ps1 setzt beide.
if (Test-Path -LiteralPath "anhang.html") {
    $anhangViewerText = Get-Content -Raw -LiteralPath "anhang.html"
    $anhangRelease = [regex]::Match(
        $anhangViewerText,
        'id="story-release"[^>]*>\s*Version\s+(?<version>[^<·]+?)\s*·\s*(?<date>[^<]+?)\s*</strong>'
    )
    if (-not $anhangRelease.Success) {
        $failures.Add("Versionsangabe in anhang.html nicht lesbar")
    } elseif ($readerRelease.Success -and (
        $anhangRelease.Groups['version'].Value.Trim() -ne $readerRelease.Groups['version'].Value.Trim() -or
        $anhangRelease.Groups['date'].Value.Trim() -ne $readerRelease.Groups['date'].Value.Trim())) {
        $failures.Add("Versionsangabe in anhang.html weicht von lesen.html ab")
    }
}
if (-not $storyDateMatch.Success -or -not $storyVersionMatch.Success) {
    $failures.Add("Version oder Datum in der HTML-Geschichte nicht lesbar")
}

if ($appRelease.Success -and $readerRelease.Success -and $storyDateMatch.Success -and $storyVersionMatch.Success) {
    $versions = @(
        $appRelease.Groups['version'].Value.Trim(),
        $readerRelease.Groups['version'].Value.Trim(),
        $storyVersionMatch.Groups['version'].Value.Trim()
    ) | Select-Object -Unique
    if ($versions.Count -ne 1) {
        $failures.Add("Versionsnummern widersprechen sich: $($versions -join ', ')")
    }

    $culture = [System.Globalization.CultureInfo]::GetCultureInfo('de-DE')
    $storyDate = [datetime]::ParseExact(
        $storyDateMatch.Groups['date'].Value,
        'dd.MM.yyyy',
        $culture
    ).ToString('d. MMMM yyyy', $culture)
    $dates = @(
        $appRelease.Groups['date'].Value.Trim(),
        $readerRelease.Groups['date'].Value.Trim(),
        $storyDate
    ) | Select-Object -Unique
    if ($dates.Count -ne 1) {
        $failures.Add("Veröffentlichungsdaten widersprechen sich: $($dates -join ', ')")
    }
}

# Die statische Seitenzahl der Landingpage muss dem Rückfallwert entsprechen.
$landingText = Get-Content -Raw -LiteralPath "index.html"
$appPageCount = [regex]::Match($appText, 'fallbackRelease\s*=\s*\{[\s\S]*?pageCount:\s*(?<count>\d+)')
$landingPageCounts = [regex]::Matches($landingText, '<span\s+data-page-count>(?<count>\d+)</span>')
if (-not $appPageCount.Success) {
    $failures.Add("Seitenzahl in assets/js/app.js nicht lesbar")
} elseif ($landingPageCounts.Count -ne 1) {
    $failures.Add("Seitenzahl in index.html nicht eindeutig lesbar (<span data-page-count>)")
} elseif ($landingPageCounts[0].Groups['count'].Value -ne $appPageCount.Groups['count'].Value) {
    $failures.Add("Seitenzahlen widersprechen sich: index.html $($landingPageCounts[0].Groups['count'].Value), app.js $($appPageCount.Groups['count'].Value)")
}

# Vollständigkeit der Buchquelle: Jede Pflichtstelle wird mit Namen gemeldet,
# wenn sie fehlt oder dem Deckblatt widerspricht. Erkennungsregeln siehe
# docs/NEUE-GESCHICHTE.md und docs/vorlagen/EINBAU-CHECKLISTE.md.
function Test-StoryCompleteness([string]$text, [string]$label) {
    $found = [System.Collections.Generic.List[string]]::new()

    # Deckblatt: div.cover-meta mit "Version X.YY" und Datum TT.MM.JJJJ.
    $cover = [regex]::Match($text, '<div\s+class="cover-meta">(?<c>[\s\S]*?)</div>')
    $coverVersion = $null
    $coverDate = $null
    if (-not $cover.Success) {
        $found.Add("${label}: Deckblatt (div.cover-meta) fehlt")
    } else {
        $v = [regex]::Match($cover.Groups['c'].Value, '<span>\s*Version\s+(?<v>\d+\.\d+)\s*</span>')
        $d = [regex]::Match($cover.Groups['c'].Value, '<span>\s*(?<d>\d{2}\.\d{2}\.\d{4})\s*</span>')
        if ($v.Success) { $coverVersion = $v.Groups['v'].Value } else { $found.Add("${label}: Deckblatt ohne Version (<span>Version X.YY</span>)") }
        if ($d.Success) { $coverDate = $d.Groups['d'].Value } else { $found.Add("${label}: Deckblatt ohne Datum (<span>TT.MM.JJJJ</span>)") }
    }

    # Cover-Hinweis: p.cover-whatsnew mit "Neu in vX.YY" passend zum Deckblatt.
    $whatsNew = [regex]::Match($text, '<p\s+class="cover-whatsnew">\s*<span\s+class="tag">\s*Neu in v(?<v>\d+\.\d+)\s*</span>')
    if (-not $whatsNew.Success) {
        $found.Add("${label}: Cover-Hinweis (p.cover-whatsnew mit 'Neu in vX.YY') fehlt")
    } elseif ($coverVersion -and $whatsNew.Groups['v'].Value -ne $coverVersion) {
        $found.Add("${label}: Cover-Hinweis nennt v$($whatsNew.Groups['v'].Value), Deckblatt Version $coverVersion")
    }

    # Drei Deckblatt-Boxen, jeweils genau einmal und in box-shell gehüllt.
    foreach ($box in @(
        @{ name = "Zur Einordnung"; pattern = '<div\s+class="box-shell">\s*<p\s+class="disclaimer">\s*<b>Zur Einordnung:</b>' },
        @{ name = "Aufbau in zwei Teilen"; pattern = '<div\s+class="box-shell">\s*<p\s+class="disclaimer">\s*<b>Aufbau in zwei Teilen:</b>' },
        @{ name = "Ausgangslage"; pattern = '<div\s+class="box-shell">\s*<div\s+class="intro">\s*<p>\s*<b>Ausgangslage:</b>' }
    )) {
        $count = [regex]::Matches($text, $box.pattern).Count
        if ($count -ne 1) {
            $found.Add("${label}: Deckblatt-Box '$($box.name)' ist $count-mal vorhanden (erwartet genau einmal, in div.box-shell)")
        }
    }

    # Personenliste: #kap-personen mit vollständigen Einträgen, Navis und Lumen dabei.
    # Der Block endet nach dem letzten Eintrag (tenure und person), danach schließen table-people und intro.
    $people = [regex]::Match($text, 'id="kap-personen"[\s\S]*?<div\s+class="table-people">(?<p>[\s\S]*?</div>\s*</div>)\s*</div>\s*</div>')
    if (-not $people.Success) {
        $found.Add("${label}: Personenliste (#kap-personen .table-people) fehlt")
    } else {
        $entries = @($people.Groups['p'].Value -split '<div\s+class="person">' | Select-Object -Skip 1)
        if ($entries.Count -eq 0) { $found.Add("${label}: Personenliste ohne Einträge") }
        $names = @()
        foreach ($entry in $entries) {
            $name = [regex]::Match($entry, '<div\s+class="name">(?<v>[^<]*)</div>').Groups['v'].Value.Trim()
            $names += $name
            foreach ($field in @("badge", "name", "role", "tenure")) {
                $filled = [regex]::IsMatch($entry, "<div\s+class=""$field[^""]*"">\s*[^<\s][^<]*</div>")
                # Bildmarke statt Kürzel (PR #6): Das Badge gilt als gefüllt, wenn es ein Bild mit nicht leerem alt-Text enthält.
                if (-not $filled -and $field -eq "badge") {
                    $filled = [regex]::IsMatch($entry, '<div\s+class="badge[^"]*">\s*<img\s[^>]*\balt="[^"\s][^"]*"[^>]*>\s*</div>')
                }
                if (-not $filled) {
                    $found.Add("${label}: Personenliste, Eintrag '$name': Feld '$field' fehlt oder ist leer")
                }
            }
        }
        foreach ($required in @("Navis", "Lumen")) {
            if ($required -notin $names) { $found.Add("${label}: Personenliste ohne '$required'") }
        }
    }

    # Mini-Inhaltsverzeichnis: drei Gruppen, jedes Kapitel und jeder Anhang mit ID verlinkt.
    $toc = [regex]::Match($text, '<nav\s+class="cover-toc"[\s\S]*?</nav>')
    if (-not $toc.Success) {
        $found.Add("${label}: Mini-Inhaltsverzeichnis (nav.cover-toc) fehlt")
    } else {
        $tocLabels = @([regex]::Matches($toc.Value, 'class="cover-toc-label">(?<l>[^<]*)</span>') | ForEach-Object {
            [System.Net.WebUtility]::HtmlDecode($_.Groups['l'].Value) -replace '\s+', ' '
        })
        foreach ($group in @("Teil 1", "Teil 2", "Anhang")) {
            if (-not ($tocLabels | Where-Object { $_ -like "$group*" })) {
                $found.Add("${label}: Mini-Inhaltsverzeichnis ohne Gruppe '$group'")
            }
        }
        $tocTargets = @([regex]::Matches($toc.Value, 'href="#(?<t>[^"]+)"') | ForEach-Object { $_.Groups['t'].Value })
        $chapterIds = @(
            [regex]::Matches($text, '<h2\s+id="(?<id>kap-[^"]+)"') | ForEach-Object { $_.Groups['id'].Value }
            [regex]::Matches($text, '<section\s+class="appendix"\s+id="(?<id>kap-[^"]+)"') | ForEach-Object { $_.Groups['id'].Value }
        )
        foreach ($id in $chapterIds) {
            if ($id -notin $tocTargets) { $found.Add("${label}: Kapitel #$id fehlt im Mini-Inhaltsverzeichnis") }
        }
    }

    # Versionshistorie: jede Zeile mit Version und Datum, aufsteigend, letzte Zeile = Deckblatt.
    $history = [regex]::Match($text, 'id="kap-versionen"[\s\S]*?<table\s+class="vtable">[\s\S]*?<tbody>(?<b>[\s\S]*?)</tbody>')
    if (-not $history.Success) {
        $found.Add("${label}: Versionshistorie (#kap-versionen table.vtable) fehlt")
    } else {
        $rowCount = [regex]::Matches($history.Groups['b'].Value, '<tr>').Count
        $rows = @([regex]::Matches($history.Groups['b'].Value, '<tr>\s*<td>(?<v>\d+\.\d+)</td>\s*<td>(?<d>\d{2}\.\d{2}\.\d{4})</td>'))
        if ($rows.Count -ne $rowCount) {
            $found.Add("${label}: Versionshistorie: $($rowCount - $rows.Count) von $rowCount Zeilen ohne lesbare Version (X.YY) oder Datum (TT.MM.JJJJ)")
        }
        for ($i = 1; $i -lt $rows.Count; $i++) {
            if ([version]$rows[$i].Groups['v'].Value -le [version]$rows[$i - 1].Groups['v'].Value) {
                $found.Add("${label}: Versionshistorie nicht aufsteigend: $($rows[$i - 1].Groups['v'].Value) vor $($rows[$i].Groups['v'].Value)")
            }
        }
        if ($rows.Count -gt 0 -and $coverVersion -and $coverDate) {
            $last = $rows[$rows.Count - 1]
            if ($last.Groups['v'].Value -ne $coverVersion -or $last.Groups['d'].Value -ne $coverDate) {
                $found.Add("${label}: Letzter Eintrag der Versionshistorie ($($last.Groups['v'].Value), $($last.Groups['d'].Value)) passt nicht zum Deckblatt ($coverVersion, $coverDate)")
            }
        }
    }
    return $found
}
foreach ($finding in (Test-StoryCompleteness $sourceStoryText "source/fahrt-zum-kunden.html")) {
    $failures.Add($finding)
}
foreach ($finding in (Test-AppendixAnchors $sourceStoryText "source/fahrt-zum-kunden.html")) {
    $failures.Add("Anhang: $finding")
}

# Die freigegebene Rückfallfassung darf niemals hinter dem eindeutigen Eingang
# unter source zurückbleiben. HTML und PDF müssen bytegenau identisch sein.
foreach ($pair in @(
    @("source/fahrt-zum-kunden.html", "story/current/fahrt-zum-kunden.html"),
    @("source/Die-Fahrt-zum-Kunden.pdf", "story/current/geschichte.pdf")
)) {
    if ((Test-Path -LiteralPath $pair[0]) -and (Test-Path -LiteralPath $pair[1])) {
        $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $pair[0]).Hash
        $publishedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $pair[1]).Hash
        if ($sourceHash -ne $publishedHash) {
            $failures.Add("Veröffentlichungsfassung ist nicht aktuell: $($pair[1]) weicht von $($pair[0]) ab")
        }
    }
}

# Der letzte Eintrag der Versionshistorie muss Deckblatt-Version und -Datum
# entsprechen. So wird eine neue Datei mit altem Deckblatt sofort abgewiesen.
$historyRows = [regex]::Matches(
    $storyText,
    '<tr>\s*<td>(?<version>\d+\.\d+)</td>\s*<td>(?<date>\d{2}\.\d{2}\.\d{4})</td>',
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)
if ($historyRows.Count -eq 0) {
    $failures.Add("Versionshistorie in der HTML-Geschichte nicht lesbar")
} elseif ($storyDateMatch.Success -and $storyVersionMatch.Success) {
    $latestHistory = $historyRows[$historyRows.Count - 1]
    if ($latestHistory.Groups['version'].Value -ne $storyVersionMatch.Groups['version'].Value.Trim()) {
        $failures.Add("Deckblatt-Version stimmt nicht mit letztem Historieneintrag überein")
    }
    if ($latestHistory.Groups['date'].Value -ne $storyDateMatch.Groups['date'].Value) {
        $failures.Add("Deckblatt-Datum stimmt nicht mit letztem Historieneintrag überein")
    }
}

# Externe Google-Fonts sind aus Datenschutzgründen nicht zulässig.
$publicMarkupFiles = Get-ChildItem -Path $projectRoot -Recurse -File |
    Where-Object {
        $_.Extension -in '.html','.css' -and
        $_.FullName -notmatch '[\\/](?:archive|output|tmp)[\\/]'
    }
foreach ($file in $publicMarkupFiles) {
    $text = Get-Content -Raw -LiteralPath $file.FullName
    if ($text -match 'fonts\.(?:googleapis|gstatic)\.com') {
        $failures.Add("Extern geladene Google-Schriftart in $($file.FullName.Substring($projectRoot.Length + 1))")
    }
}

# Podcast: Die vier MP3 liegen bewusst nicht im Repository (Größe, siehe
# docs/PODCAST.md und .gitignore). Sie werden nur lokal vor dem Paketbau
# abgelegt. Fehlen sie, ist das hier kein Fehler, weil GitHub Actions sie nie
# besitzt; build-upload.ps1 bricht in diesem Fall ab (außer mit -OhneAudio).
# Das Cover ist seit R36 versioniert und damit Pflicht. Sind die MP3 vorhanden,
# werden Dateikennung und Größe geprüft; die SHA-256-Prüfung übernimmt
# build-upload.ps1. Die Ausnahme in der Verweisprüfung unten gilt nur für genau
# die fehlenden MP3 und nur in index.html.
$podcastAudioFiles = @(
    "assets/audio/ki-als-beifahrer-im-it-systemhaus.mp3",
    "assets/audio/vom-logbuch-zum-ki-ticketsystem.mp3",
    "assets/audio/warum-ki-nicht-lenken-darf.mp3",
    "assets/audio/roman-als-ki-blaupause.mp3"
)
$podcastCoverFile = "assets/img/reling-it-podcast-cover.png"
$podcastExternalFiles = @($podcastAudioFiles) + $podcastCoverFile
$podcastMissing = @($podcastAudioFiles | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
if (-not (Test-Path -LiteralPath $podcastCoverFile -PathType Leaf)) {
    $failures.Add("Podcast-Cover fehlt im Repository: $podcastCoverFile")
    $podcastMissing += $podcastCoverFile
}

# assets/audio/SHA256SUMS.txt ist versioniert und muss genau die vier MP3 mit
# Prüfsumme und Größe in Byte nennen (Format siehe Datei). Diese Prüfung läuft
# auch in CI ohne MP3.
$podcastSumsFile = "assets/audio/SHA256SUMS.txt"
$podcastSizes = @{}
if (-not (Test-Path -LiteralPath $podcastSumsFile -PathType Leaf)) {
    $failures.Add("Podcast-Prüfsummen fehlen: $podcastSumsFile")
} else {
    $podcastHashes = @{}
    foreach ($sumLine in (Get-Content -LiteralPath $podcastSumsFile -Encoding utf8)) {
        $sumMatch = [regex]::Match($sumLine, '^(?<hash>[0-9a-fA-F]{64}) [ *](?<name>\S+)$')
        if ($sumMatch.Success) { $podcastHashes[$sumMatch.Groups['name'].Value] = $sumMatch.Groups['hash'].Value; continue }
        $sizeMatch = [regex]::Match($sumLine, '^#\s*groesse\s+(?<bytes>\d+)\s+(?<name>\S+)\s*$')
        if ($sizeMatch.Success) { $podcastSizes[$sizeMatch.Groups['name'].Value] = [long]$sizeMatch.Groups['bytes'].Value }
    }
    $podcastNames = @($podcastAudioFiles | ForEach-Object { Split-Path -Leaf $_ })
    foreach ($podcastName in $podcastNames) {
        if (-not $podcastHashes.ContainsKey($podcastName)) { $failures.Add("${podcastSumsFile}: Prüfsumme fehlt für $podcastName") }
        if (-not $podcastSizes.ContainsKey($podcastName)) { $failures.Add("${podcastSumsFile}: Größe (# groesse <Byte> <Datei>) fehlt für $podcastName") }
    }
    foreach ($listedName in @(@($podcastHashes.Keys) + @($podcastSizes.Keys) | Sort-Object -Unique)) {
        if ($listedName -notin $podcastNames) { $failures.Add("${podcastSumsFile}: unbekannte Datei $listedName, Liste in ci-check.ps1 anpassen") }
    }
}
foreach ($podcastFile in $podcastExternalFiles) {
    if (-not $landingText.Contains("""$podcastFile""")) {
        $failures.Add("Podcast-Datei wird in index.html nicht mehr verwendet, Liste in ci-check.ps1 anpassen: $podcastFile")
    }
    if ($podcastFile -in $podcastMissing) { continue }
    $podcastStream = [System.IO.File]::OpenRead((Resolve-Path $podcastFile))
    try {
        $podcastHeader = New-Object byte[] 4
        [void]$podcastStream.Read($podcastHeader, 0, 4)
    } finally { $podcastStream.Dispose() }
    if ($podcastFile -eq $podcastCoverFile) {
        if ($podcastHeader[0] -ne 0x89 -or [System.Text.Encoding]::ASCII.GetString($podcastHeader, 1, 3) -ne "PNG") {
            $failures.Add("Podcast-Cover besitzt keine gültige PNG-Kennung: $podcastFile")
        }
    } else {
        if ([System.Text.Encoding]::ASCII.GetString($podcastHeader, 0, 3) -ne "ID3" -and $podcastHeader[0] -ne 0xFF) {
            $failures.Add("Podcast besitzt keine gültige MP3-Kennung: $podcastFile")
        }
        $podcastName = Split-Path -Leaf $podcastFile
        $podcastLength = (Get-Item -LiteralPath $podcastFile).Length
        if ($podcastSizes.ContainsKey($podcastName) -and $podcastSizes[$podcastName] -ne $podcastLength) {
            $failures.Add("Podcast-Größe weicht von ${podcastSumsFile} ab: $podcastFile hat $podcastLength Byte, erwartet $($podcastSizes[$podcastName])")
        }
    }
}
# Die sichtbare Quellenangabe bleibt Pflicht, auch ohne Audiodateien.
if ($landingText -notmatch 'Google NotebookLM' -or $landingText -notmatch 'KI-generiert') {
    $failures.Add("Podcast enthält keine sichtbare Google-NotebookLM- und KI-Quellenangabe")
}

# Prüft lokale Verweise und doppelte IDs in sämtlichen HTML-Dateien des Repos.
# Lokal erzeugte, git-ignorierte Ordner (FTP-Paket unter output/, archive/, tmp/)
# zählen nicht mit: Ihre Kopien würden doppelt gezählt und relative Verweise
# dort falsch auflösen. Gleiche Ausnahme wie bei Google-Fonts und Secret-Schutz.
$htmlFiles = Get-ChildItem -Path $projectRoot -Filter "*.html" -File -Recurse |
    Where-Object { $_.FullName.Substring($projectRoot.Length + 1) -notmatch '^(?:archive|output|tmp)[\\/]' }
foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content -Raw -LiteralPath $htmlFile.FullName
    $relativeHtmlPath = $htmlFile.FullName.Substring($projectRoot.Length + 1)

    $ids = [regex]::Matches($content, '\bid\s*=\s*["'']([^"'']+)["'']') |
        ForEach-Object { $_.Groups[1].Value }
    $duplicates = $ids | Group-Object | Where-Object Count -gt 1
    foreach ($duplicate in $duplicates) {
        $failures.Add("Doppelte ID '$($duplicate.Name)' in $relativeHtmlPath")
    }

    $references = [regex]::Matches($content, '\b(?:href|src)\s*=\s*["'']([^"'']+)["'']')
    foreach ($match in $references) {
        $reference = $match.Groups[1].Value
        if ($reference -match '^(?:https?:|mailto:|tel:|data:|#|javascript:)') { continue }
        $cleanReference = ($reference -split '[?#]')[0]
        if ([string]::IsNullOrWhiteSpace($cleanReference)) { continue }
        # Nur die bekannten, bewusst nicht versionierten Podcast-Dateien (siehe oben).
        if ($relativeHtmlPath -eq "index.html" -and $cleanReference -in $podcastMissing) { continue }
        $resolved = Join-Path -Path $htmlFile.DirectoryName -ChildPath $cleanReference
        if (-not (Test-Path -LiteralPath $resolved)) {
            $failures.Add("Fehlender lokaler Verweis in ${relativeHtmlPath}: $reference")
        }
    }
}

# Eine schnelle Signaturprüfung erkennt beschädigte oder falsch benannte PDFs.
foreach ($pdfName in @("story/current/geschichte.pdf", "story/current/workshop-handout.pdf", "source/Die-Fahrt-zum-Kunden.pdf")) {
    if (-not (Test-Path -LiteralPath $pdfName)) { continue }
    $stream = [System.IO.File]::OpenRead((Resolve-Path $pdfName))
    try {
        $header = New-Object byte[] 5
        [void]$stream.Read($header, 0, 5)
        if ([System.Text.Encoding]::ASCII.GetString($header) -ne "%PDF-") {
            $failures.Add("Keine gültige PDF-Kennung: $pdfName")
        }
    } finally { $stream.Dispose() }
}

# Öffentliche Publishable Keys sind erlaubt; Secret- und Service-Role-Keys nicht.
$secretPatterns = @(
    'sb_secret_[A-Za-z0-9_-]+',
    'service_role["'']?\s*[:=]\s*["''][^"'']+',
    'ghp_[A-Za-z0-9]{20,}',
    'github_pat_[A-Za-z0-9_]{20,}',
    'AKIA[0-9A-Z]{16}',
    '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'
)
$scanFiles = Get-ChildItem -Path $projectRoot -Recurse -File |
    Where-Object {
        $_.FullName -notmatch '[\\/](?:\.git|archive|output|tmp)[\\/]' -and
        $_.Extension -in '.js','.html','.md','.sql','.json','.yml','.yaml','.toml'
    }
foreach ($file in $scanFiles) {
    $text = Get-Content -Raw -LiteralPath $file.FullName
    # Große eingebettete Bilder können zufällig wie Schlüsselpräfixe aussehen.
    $text = [regex]::Replace($text, 'data:[^"'']+', '[embedded-data-removed]')
    foreach ($pattern in $secretPatterns) {
        if ($text -match $pattern) {
            $failures.Add("Möglicher Supabase-Secret-Key in $($file.FullName.Substring($projectRoot.Length + 1))")
        }
    }
}

$podcastAudioMissing = @($podcastMissing | Where-Object { $_ -in $podcastAudioFiles })
if ($podcastAudioMissing.Count -gt 0) {
    Write-Host "Hinweis: $($podcastAudioMissing.Count) von $($podcastAudioFiles.Count) Podcast-MP3 liegen nicht vor (in CI erwartet, nicht im Repo; siehe docs/PODCAST.md). build-upload.ps1 baut ohne sie nur mit -OhneAudio ein Paket."
} else {
    Write-Host "OK: $($podcastAudioFiles.Count) Podcast-MP3 lokal vorhanden, Dateikennungen und Größen geprüft."
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    throw "CI-Prüfung mit $($failures.Count) Fehler(n) abgebrochen."
}

Write-Host "OK: $($htmlFiles.Count) HTML-Dateien, Version/Datum/Seitenzahl, Vollständigkeit der Buchquelle, lokale Links, PDFs und Secret-Schutz geprüft."
