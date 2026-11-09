<#
Zweck:
    Erzeugt die Anhang-Seite story/current/anhang.html aus der Buchquelle
    source/fahrt-zum-kunden.html (Auftrag R07, q12). Der Anhang wird nur an
    einer Stelle gepflegt: im Buch. Diese Datei ist immer ein Erzeugnis und
    wird nie von Hand bearbeitet.

Eingabe:
    -Projekt  Projektordner (Standard: Ordner über scripts/).
    -Quelle   Buchquelle relativ zum Projekt (Standard source/fahrt-zum-kunden.html).
    -Ziel     Erzeugte Seite relativ zum Projekt (Standard story/current/anhang.html).
    -Pruefen  Schreibt nichts. Gibt die Befunde als Text zurück (leer = in Ordnung):
              Anker-Regeln verletzt oder vorhandene Zieldatei nicht aktuell.
              ci-check.ps1 nutzt diesen Modus.
    -Liste    Gibt die Anhang-Blöcke (Zeile, ID, Herkunft der ID, Titel) als Tabelle aus.

Regeln für Anhang-Blöcke (Erkennung wie im Buch-CSS beschrieben):
    - Ein Block ist <div class="box-shell"><section class="appendix" ...> ... </section></div>.
    - Jeder Block hat eine eindeutige, stabile ID: id an der section oder,
      falls dort keine steht, id an der ersten h2 des Blocks. Die ID beginnt mit "kap-".
    - Jeder Block hat eine h2 (Titel für das Inhaltsverzeichnis).
    - Das Skript ergänzt keine Anker im Buch. Fehlt eine ID, bricht es ab.

Ausgabe:
    <head> der Buchquelle unverändert (gleiche Gestaltung, lokale Schriften,
    keine externen Abhängigkeiten), nur mit eigenem Titel; danach ein
    Inhaltsverzeichnis, die Anhang-Blöcke bytegenau wie im Buch und der
    Buch-Fuß. Zeilenenden LF, UTF-8 ohne BOM, kein Zeitstempel: Gleiche
    Quelle ergibt immer dieselbe Datei.
#>
param(
    [string]$Projekt = "",
    [string]$Quelle = "source/fahrt-zum-kunden.html",
    [string]$Ziel = "story/current/anhang.html",
    [switch]$Pruefen,
    [switch]$Liste
)

$ErrorActionPreference = "Stop"
if (-not $Projekt) { $Projekt = Split-Path -Parent $PSScriptRoot }
$quellPfad = Join-Path $Projekt $Quelle
$zielPfad = Join-Path $Projekt $Ziel

function Get-TextOhneTags([string]$markup) {
    $ohneTags = [regex]::Replace($markup, '<[^>]+>', '')
    return ([System.Net.WebUtility]::HtmlDecode($ohneTags) -replace '\s+', ' ').Trim()
}

function ConvertTo-HtmlText([string]$text) {
    # Nur die HTML-Sonderzeichen; Umlaute und Anführungszeichen bleiben als UTF-8 lesbar.
    return $text.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

# Liest alle Anhang-Blöcke und prüft die Anker-Regeln.
function Get-AnhangBloecke([string]$text) {
    $befunde = [System.Collections.Generic.List[string]]::new()
    $bloecke = [System.Collections.Generic.List[object]]::new()

    $alleAppendix = [regex]::Matches($text, '<section\s+class="appendix"').Count
    $treffer = [regex]::Matches($text, '<div\s+class="box-shell"><section\s+class="appendix"(?<attr>[^>]*)>(?<inhalt>[\s\S]*?)</section></div>')
    if ($treffer.Count -eq 0) { $befunde.Add("Keine Anhang-Blöcke (div.box-shell > section.appendix) in $Quelle gefunden") }
    if ($alleAppendix -ne $treffer.Count) {
        $befunde.Add("$alleAppendix section.appendix in $Quelle, davon nur $($treffer.Count) in der Form <div class=""box-shell""><section class=""appendix"" ...> ... </section></div>")
    }

    $gesehen = @{}
    foreach ($t in $treffer) {
        $zeile = ([regex]::Matches($text.Substring(0, $t.Index), "`n")).Count + 1
        $inhalt = $t.Groups['inhalt'].Value
        if ($inhalt -match '<section[\s>]') { $befunde.Add("Anhang-Block in Zeile ${zeile}: verschachtelte section wird nicht unterstützt") }

        $h2 = [regex]::Match($inhalt, '<h2(?<attr>[^>]*)>(?<titel>[\s\S]*?)</h2>')
        $titel = if ($h2.Success) { Get-TextOhneTags $h2.Groups['titel'].Value } else { "" }
        if (-not $titel) { $befunde.Add("Anhang-Block in Zeile ${zeile}: keine Überschrift (h2) für das Inhaltsverzeichnis") }

        $sectionId = [regex]::Match($t.Groups['attr'].Value, '\sid="(?<id>[^"]*)"')
        $h2Id = if ($h2.Success) { [regex]::Match($h2.Groups['attr'].Value, '\sid="(?<id>[^"]*)"') } else { [System.Text.RegularExpressions.Match]::Empty }
        if ($sectionId.Success) { $id = $sectionId.Groups['id'].Value; $herkunft = "section" }
        elseif ($h2Id.Success) { $id = $h2Id.Groups['id'].Value; $herkunft = "h2" }
        else { $id = ""; $herkunft = "fehlt" }

        if (-not $id) {
            $befunde.Add("Anhang-Block in Zeile $zeile ('$titel'): keine ID an section.appendix oder an der ersten h2 (Anker im Buch ergänzen, nicht in der erzeugten Seite)")
        } elseif ($id -notmatch '^kap-[a-z0-9]+(?:-[a-z0-9]+)*$') {
            $befunde.Add("Anhang-Block in Zeile $zeile ('$titel'): ID '$id' entspricht nicht dem Muster kap-<name> (Kleinbuchstaben, Ziffern, Bindestriche)")
        } elseif ($gesehen.ContainsKey($id)) {
            $befunde.Add("Anhang-Block in Zeile $zeile ('$titel'): ID '$id' ist bereits in Zeile $($gesehen[$id]) vergeben")
        } else {
            $gesehen[$id] = $zeile
            # Die ID muss im ganzen Buch eindeutig sein, sonst springt der Anker an die falsche Stelle.
            $vorkommen = [regex]::Matches($text, '\sid="' + [regex]::Escape($id) + '"').Count
            if ($vorkommen -ne 1) { $befunde.Add("Anhang-Block in Zeile $zeile ('$titel'): ID '$id' kommt im Buch $vorkommen-mal vor") }
        }

        $bloecke.Add([pscustomobject]@{
            Zeile    = $zeile
            Id       = $id
            Herkunft = $herkunft
            Titel    = $titel
            Markup   = $t.Value
        })
    }

    # Interne Links aus dem Anhang auf Ziele außerhalb des Anhangs: Die Seite
    # funktioniert trotzdem (der Viewer leitet sie auf lesen.html um), sie
    # werden hier nur gemeldet.
    $anhangIds = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($b in $bloecke) {
        [regex]::Matches($b.Markup, '\sid="(?<id>[^"]+)"') | ForEach-Object { [void]$anhangIds.Add($_.Groups['id'].Value) }
    }
    $externeZiele = @($bloecke | ForEach-Object { [regex]::Matches($_.Markup, 'href="#(?<t>[^"]+)"') } |
        ForEach-Object { $_.Groups['t'].Value } | Where-Object { -not $anhangIds.Contains($_) } | Select-Object -Unique)

    return [pscustomobject]@{ Bloecke = $bloecke; Befunde = $befunde; ExterneZiele = $externeZiele }
}

function New-AnhangSeite([string]$text, $bloecke) {
    $head = [regex]::Match($text, '<head>[\s\S]*?</head>')
    if (-not $head.Success) { throw "Kein <head> in $Quelle gefunden." }
    $cover = [regex]::Match($text, '<div\s+class="cover-meta">(?<c>[\s\S]*?)</div>')
    $version = [regex]::Match($cover.Groups['c'].Value, '<span>\s*Version\s+(?<v>\d+\.\d+)\s*</span>').Groups['v'].Value
    $datum = [regex]::Match($cover.Groups['c'].Value, '<span>\s*(?<d>\d{2}\.\d{2}\.\d{4})\s*</span>').Groups['d'].Value
    $stand = if ($version -and $datum) { "Version $version vom $datum" } else { "Stand unbekannt" }

    $kopf = $head.Value
    $titelMuster = '<title>[\s\S]*?</title>'
    $neuerTitel = '<title>Anhang | Die Fahrt zum Kunden</title>'
    if ($kopf -match $titelMuster) { $kopf = [regex]::Replace($kopf, $titelMuster, $neuerTitel, 1) }
    else { $kopf = $kopf.Replace('</head>', "$neuerTitel`n</head>") }

    $nl = "`n"
    $teile = [System.Collections.Generic.List[string]]::new()
    $teile.Add('<!DOCTYPE html>')
    $teile.Add("<!-- Erzeugt von scripts/build-anhang.ps1 aus $Quelle ($stand). Nicht von Hand bearbeiten. -->")
    $teile.Add('<html lang="de">')
    $teile.Add($kopf)
    $teile.Add('<body>')
    $teile.Add('')
    $teile.Add('<div class="wrap">')
    $teile.Add('')
    $teile.Add('  <nav class="cover-toc" id="anhang-inhalt" aria-label="Inhaltsverzeichnis des Anhangs">')
    $teile.Add('    <div class="cover-toc-title">Anhang &middot; Inhalt</div>')
    $teile.Add("    <div class=""cover-toc-group""><span class=""cover-toc-label"">Die Fahrt zum Kunden &middot; $(ConvertTo-HtmlText $stand)</span></div>")
    foreach ($b in $bloecke) {
        $teile.Add("    <div class=""cover-toc-group""><a href=""#$($b.Id)"">$(ConvertTo-HtmlText $b.Titel)</a></div>")
    }
    $teile.Add('  </nav>')
    $teile.Add('')
    foreach ($b in $bloecke) {
        $teile.Add("  $($b.Markup -replace "`r`n", "`n")")
        $teile.Add('')
    }
    $fuss = [regex]::Match($text, '<div\s+class="box-shell"><footer>[\s\S]*?</footer></div>')
    if ($fuss.Success) {
        $teile.Add("  $($fuss.Value -replace "`r`n", "`n")")
        $teile.Add('')
    }
    $teile.Add('</div>')
    $teile.Add('</body>')
    $teile.Add('</html>')
    return (($teile -join $nl) -replace "`r`n", "`n") + $nl
}

if (-not (Test-Path -LiteralPath $quellPfad -PathType Leaf)) {
    $meldung = "Buchquelle fehlt: $Quelle"
    if ($Pruefen) { return @($meldung) }
    throw $meldung
}
$text = [System.IO.File]::ReadAllText($quellPfad, [System.Text.Encoding]::UTF8)
$ergebnis = Get-AnhangBloecke $text

if ($Liste) {
    $ergebnis.Bloecke | Select-Object Zeile, Id, Herkunft, Titel | Format-Table -AutoSize | Out-String -Width 400 | Write-Host
}
if ($ergebnis.ExterneZiele.Count -gt 0) {
    Write-Host "Hinweis: Anhang verlinkt auf Stellen außerhalb des Anhangs ($($ergebnis.ExterneZiele -join ', ')); anhang.html leitet diese auf lesen.html um."
}

if ($Pruefen) {
    $befunde = [System.Collections.Generic.List[string]]::new()
    foreach ($befund in $ergebnis.Befunde) { $befunde.Add($befund) }
    if ($befunde.Count -eq 0) {
        $erwartet = New-AnhangSeite $text $ergebnis.Bloecke
        if (-not (Test-Path -LiteralPath $zielPfad -PathType Leaf)) {
            $befunde.Add("Anhang-Seite fehlt: $Ziel (mit scripts/build-anhang.ps1 erzeugen)")
        } else {
            $vorhanden = [System.IO.File]::ReadAllText($zielPfad, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
            if ($vorhanden -cne $erwartet) {
                $befunde.Add("Anhang-Seite ist nicht aktuell: $Ziel entspricht nicht $Quelle (mit scripts/build-anhang.ps1 neu erzeugen, nicht von Hand bearbeiten)")
            }
        }
    }
    return @($befunde)
}

if ($ergebnis.Befunde.Count -gt 0) {
    throw "Anhang-Seite nicht erzeugt: $($ergebnis.Befunde -join '; ')"
}
$seite = New-AnhangSeite $text $ergebnis.Bloecke
$zielOrdner = Split-Path -Parent $zielPfad
if ($zielOrdner -and -not (Test-Path -LiteralPath $zielOrdner)) { New-Item -ItemType Directory -Path $zielOrdner -Force | Out-Null }
[System.IO.File]::WriteAllText($zielPfad, $seite, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "OK: $Ziel aus $Quelle erzeugt ($($ergebnis.Bloecke.Count) Anhang-Blöcke: $(@($ergebnis.Bloecke | ForEach-Object Id) -join ', '))."
