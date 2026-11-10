<#
Zweck:
    Zeigt nur lesend als Tabelle, welche Worktrees sauber sind und welche
    lokalen Branches in main enthalten oder per Squash inhaltsgleich sind.
    Grundlage sind die Prüfungen aus dem Aufräumbericht R44. Das Skript löscht
    nichts, pusht nichts und ändert keine Refs; Löschen bleibt Handarbeit.
    Git wird mit GIT_OPTIONAL_LOCKS=0 und --no-optional-locks aufgerufen, damit
    auch git status den Index nicht auffrischt. Nur mit -Fetch wird vorher
    `git fetch --prune origin` ausgeführt (der einzige schreibende Aufruf).

Eingabe:
    -Projekt     Ein beliebiger Worktree des Repositorys (Standard: Ordner über scripts/).
    -Basis       Vergleichsstand (Standard: origin/main).
    -Geschuetzt  Branches, die immer belassen werden (Standard: main, ops/queue, ops/reports).
    -Markdown    Gibt die Tabelle als Markdown aus (für Berichte).
    -Fetch       Holt vorher den Remote-Stand (git fetch --prune origin).

Prüflogik je Zeile:
    sauber    `git status --porcelain` ohne Ausgabe (ignorierte Dateien zählen nicht).
    ignoriert `git status --porcelain --ignored`, Zeilen mit !!. Diese Dateien
              (z. B. output/, reports/) löscht `git worktree remove` mit.
    in main   ja: `git merge-base --is-ancestor <Branch> <Basis>` mit Exit 0.
              Squash-gleich: `git diff --quiet <Branch> <Basis>` (Inhalt identisch)
              oder die Patch-ID des Gesamtdiffs seit der Merge-Basis steckt in
              einem Commit der Basis (`git patch-id --stable`).
              nein: sonst, mit Anzahl eigener Commits und `git diff --shortstat`.
    Empfehlung ist reiner Text; das Skript führt keine der genannten Befehle aus.
#>
param(
    [string]$Projekt = "",
    [string]$Basis = "origin/main",
    [string[]]$Geschuetzt = @("main", "ops/queue", "ops/reports"),
    [switch]$Markdown,
    [switch]$Fetch
)

$ErrorActionPreference = "Stop"
$env:GIT_OPTIONAL_LOCKS = "0"
if (-not $Projekt) { $Projekt = Split-Path -Parent $PSScriptRoot }
$Projekt = (Resolve-Path -LiteralPath $Projekt).Path

# Nur diese Git-Unterbefehle sind erlaubt; alles andere bricht ab.
$erlaubt = @("worktree", "status", "for-each-ref", "merge-base", "diff", "rev-parse", "rev-list", "log", "cat-file")

function Invoke-Git {
    param([string]$Ort, [string[]]$Argumente, [switch]$ExitCode)
    if ($Argumente[0] -notin $erlaubt) { throw "Nicht erlaubter Git-Aufruf: $($Argumente[0])" }
    if ($Argumente[0] -eq "worktree" -and $Argumente[1] -ne "list") { throw "Nur 'git worktree list' ist erlaubt." }
    $vorher = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $ausgabe = & git --no-optional-locks -C $Ort @Argumente 2>$null
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $vorher
    }
    if ($ExitCode) { return $code }
    if ($code -ne 0) { return $null }
    return @($ausgabe)
}

# Patch-IDs (stabil) aus einem Diff-Text; nur lesend über git patch-id.
function Get-PatchIds([string]$Ort, [string[]]$DiffArgumente) {
    $vorher = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $zeilen = & git --no-optional-locks -C $Ort @DiffArgumente 2>$null | & git --no-optional-locks -C $Ort patch-id --stable 2>$null
    } finally {
        $ErrorActionPreference = $vorher
    }
    return @($zeilen | Where-Object { $_ } | ForEach-Object { ($_ -split ' ')[0] })
}

if ((Invoke-Git $Projekt @("rev-parse", "--git-dir") -ExitCode) -ne 0) { throw "Kein Git-Repository: $Projekt" }

if ($Fetch) {
    Write-Host "Hole Remote-Stand: git fetch --prune origin"
    & git -C $Projekt fetch --prune origin
    if ($LASTEXITCODE -ne 0) { throw "git fetch ist fehlgeschlagen (Exit $LASTEXITCODE)." }
}

$basisSha = Invoke-Git $Projekt @("rev-parse", "--verify", "--quiet", "$Basis^{commit}")
if (-not $basisSha) { throw "Basis '$Basis' nicht gefunden. Gegebenenfalls mit -Fetch aufrufen." }
$basisSha = @($basisSha)[0]

# --- Worktrees aus git worktree list --porcelain -----------------------------
$worktrees = [System.Collections.Generic.List[object]]::new()
$aktuell = $null
foreach ($zeile in (Invoke-Git $Projekt @("worktree", "list", "--porcelain"))) {
    if ($zeile -match '^worktree (.+)$') {
        $aktuell = [ordered]@{ Pfad = $Matches[1]; Sha = ""; Branch = ""; Losgeloest = $false; Bare = $false; Gesperrt = $false; Prunable = $false }
        $worktrees.Add($aktuell)
    } elseif ($aktuell) {
        if ($zeile -match '^HEAD ([0-9a-f]+)') { $aktuell.Sha = $Matches[1] }
        elseif ($zeile -match '^branch refs/heads/(.+)$') { $aktuell.Branch = $Matches[1] }
        elseif ($zeile -eq 'detached') { $aktuell.Losgeloest = $true }
        elseif ($zeile -eq 'bare') { $aktuell.Bare = $true }
        elseif ($zeile -match '^locked') { $aktuell.Gesperrt = $true }
        elseif ($zeile -match '^prunable') { $aktuell.Prunable = $true }
    }
}
$hauptPfad = if ($worktrees.Count -gt 0) { $worktrees[0].Pfad } else { $Projekt }

# --- Lokale Branches mit Upstream ---------------------------------------------
$branches = [ordered]@{}
foreach ($zeile in (Invoke-Git $Projekt @("for-each-ref", "--format=%(refname:short)|%(objectname)|%(upstream:short)|%(upstream:track)", "refs/heads"))) {
    $teile = $zeile -split '\|', 4
    $branches[$teile[0]] = [pscustomobject]@{ Name = $teile[0]; Sha = $teile[1]; Upstream = $teile[2]; Track = $teile[3] }
}

function Get-Remote($Info) {
    if (-not $Info -or -not $Info.Upstream) { return "–" }
    if ($Info.Track -match 'gone') { return "$($Info.Upstream) gelöscht" }
    if ($Info.Track) { return "$($Info.Upstream) $($Info.Track -replace '[\[\]]', '')" }
    return $Info.Upstream
}

# Ergebnis der Inhaltsprüfung gegen die Basis.
function Get-InMain([string]$Sha) {
    if ($Sha -eq $basisSha) { return [pscustomobject]@{ Wert = "ja"; Detail = "gleich Basis, keine eigenen Commits"; Gleich = $true } }
    if ((Invoke-Git $Projekt @("merge-base", "--is-ancestor", $Sha, $basisSha) -ExitCode) -eq 0) {
        return [pscustomobject]@{ Wert = "ja"; Detail = "Vorfahre der Basis"; Gleich = $false }
    }
    if ((Invoke-Git $Projekt @("diff", "--quiet", $Sha, $basisSha) -ExitCode) -eq 0) {
        return [pscustomobject]@{ Wert = "Squash-gleich"; Detail = "Inhalt identisch (git diff leer)"; Gleich = $false }
    }
    $mb = Invoke-Git $Projekt @("merge-base", $basisSha, $Sha)
    if ($mb) {
        $mb = @($mb)[0]
        $eigen = @(Get-PatchIds $Projekt @("diff", $mb, $Sha))
        if ($eigen.Count -gt 0) {
            $inBasis = @(Get-PatchIds $Projekt @("log", "-p", "--no-merges", "--format=commit %H", "$mb..$basisSha"))
            if ($inBasis -contains $eigen[0]) {
                return [pscustomobject]@{ Wert = "Squash-gleich"; Detail = "Gesamtdiff als Commit in der Basis (patch-id)"; Gleich = $false }
            }
        }
        $anzahl = @(Invoke-Git $Projekt @("rev-list", "--count", "$basisSha..$Sha"))[0]
        $stat = (Invoke-Git $Projekt @("diff", "--shortstat", $mb, $Sha)) -join " "
        return [pscustomobject]@{ Wert = "nein"; Detail = "$anzahl eigene Commits; $($stat.Trim())"; Gleich = $false }
    }
    return [pscustomobject]@{ Wert = "nein"; Detail = "keine gemeinsame Basis"; Gleich = $false }
}

function Get-Ignoriert([string]$Pfad) {
    $zeilen = @(Invoke-Git $Pfad @("status", "--porcelain", "--ignored") | Where-Object { $_ -like '!! *' } | ForEach-Object { $_.Substring(3) })
    if ($zeilen.Count -eq 0) { return "–" }
    $kurz = @($zeilen | Select-Object -First 4)
    $text = $kurz -join ", "
    if ($zeilen.Count -gt 4) { $text += " (+$($zeilen.Count - 4) weitere)" }
    return $text
}

$zeilenListe = [System.Collections.Generic.List[object]]::new()
$imWorktree = @{}

foreach ($wt in $worktrees) {
    $name = if ($wt.Branch) { $wt.Branch } elseif ($wt.Bare) { "(bare)" } else { "(losgelöst $($wt.Sha.Substring(0, [Math]::Min(7, $wt.Sha.Length))))" }
    if ($wt.Branch) { $imWorktree[$wt.Branch] = $true }
    $info = if ($wt.Branch) { $branches[$wt.Branch] } else { $null }
    $istHaupt = $wt.Pfad -eq $hauptPfad

    if ($wt.Prunable -or -not (Test-Path -LiteralPath $wt.Pfad)) {
        $zeilenListe.Add([pscustomobject]@{ Name = $name; Pfad = $wt.Pfad; Sauber = "fehlt"; Ignoriert = "–"; InMain = "–"; Remote = (Get-Remote $info)
            Empfehlung = "Verzeichnis fehlt; Verwaltungseintrag mit 'git worktree prune' entfernen" })
        continue
    }
    $status = @(Invoke-Git $wt.Pfad @("status", "--porcelain"))
    $sauber = if ($status.Count -eq 0) { "ja" } else { "nein ($($status.Count))" }
    $ignoriert = Get-Ignoriert $wt.Pfad
    $pruefung = if ($wt.Sha) { Get-InMain $wt.Sha } else { [pscustomobject]@{ Wert = "–"; Detail = ""; Gleich = $false } }

    $empfehlung = if ($istHaupt) { "Arbeitsklon, belassen" }
    elseif ($wt.Gesperrt) { "gesperrt, belassen" }
    elseif ($wt.Branch -and $wt.Branch -in $Geschuetzt) { "geschützter Branch, belassen" }
    elseif ($status.Count -gt 0) { "belassen: ungesicherte Änderungen" }
    elseif ($pruefung.Wert -eq "nein") { "belassen: Inhalt nicht in $Basis" }
    elseif ($pruefung.Gleich) { "keine eigenen Commits (neu oder aktiv?); erst nach Abschluss des Auftrags entfernen" }
    else {
        $loeschen = if (-not $wt.Branch) { "" } elseif ($pruefung.Wert -eq "ja") { ", dann git branch -d $($wt.Branch)" } else { ", dann git branch -D $($wt.Branch)" }
        if ($ignoriert -ne "–") { "erst ignorierte Dateien sichern (worktree remove löscht sie mit), dann git worktree remove$loeschen" }
        else { "entfernbar: git worktree remove `"$($wt.Pfad)`"$loeschen" }
    }
    if ($wt.Losgeloest -and $pruefung.Wert -eq "nein") {
        $enthalten = @(Invoke-Git $Projekt @("for-each-ref", "--contains", $wt.Sha, "--format=%(refname:short)", "refs/heads", "refs/remotes") | Where-Object { $_ -notmatch '/HEAD$' })
        if ($enthalten.Count -gt 0) { $empfehlung += "; Stand enthalten in $(@($enthalten | Select-Object -First 3) -join ', ')" }
    }
    $inMain = if ($pruefung.Wert -eq "nein") { "nein ($($pruefung.Detail))" } else { $pruefung.Wert }
    $zeilenListe.Add([pscustomobject]@{ Name = $name; Pfad = $wt.Pfad; Sauber = $sauber; Ignoriert = $ignoriert; InMain = $inMain; Remote = (Get-Remote $info); Empfehlung = $empfehlung })
}

foreach ($info in $branches.Values) {
    if ($imWorktree.ContainsKey($info.Name)) { continue }
    $pruefung = Get-InMain $info.Sha
    $empfehlung = if ($info.Name -in $Geschuetzt) {
        if ($info.Track -match 'behind') { "geschützter Branch, belassen; lokal veraltet ($($info.Track -replace '[\[\]]', ''))" } else { "geschützter Branch, belassen" }
    }
    elseif ($pruefung.Wert -eq "ja") { "löschbar: git branch -d $($info.Name)" }
    elseif ($pruefung.Wert -eq "Squash-gleich") { "löschbar nach Sichtprüfung: git branch -D $($info.Name) (Squash, kein Vorfahre)" }
    else { "belassen: Inhalt nicht in $Basis" }
    if ($info.Name -notin $Geschuetzt -and $pruefung.Wert -ne "nein" -and $info.Upstream -and $info.Track -notmatch 'gone') {
        $empfehlung += "; Remote-Branch besteht noch"
    }
    $inMain = if ($pruefung.Wert -eq "nein") { "nein ($($pruefung.Detail))" } else { $pruefung.Wert }
    $zeilenListe.Add([pscustomobject]@{ Name = $info.Name; Pfad = "–"; Sauber = "–"; Ignoriert = "–"; InMain = $inMain; Remote = (Get-Remote $info); Empfehlung = $empfehlung })
}

$basisKurz = $basisSha.Substring(0, 7)
Write-Output "Aufräumen prüfen (nur lesend): $Projekt"
Write-Output "Basis: $Basis $basisKurz; $($worktrees.Count) Worktrees, $($branches.Count) lokale Branches"
Write-Output ""
if ($Markdown) {
    $spalten = @("Name", "Pfad", "Sauber", "Ignoriert", "InMain", "Remote", "Empfehlung")
    Write-Output ("| " + (@("Name", "Pfad", "sauber", "ignorierte Dateien", "in $Basis", "Remote", "Empfehlung") -join " | ") + " |")
    Write-Output ("|" + ("---|" * $spalten.Count))
    foreach ($z in $zeilenListe) {
        Write-Output ("| " + (($spalten | ForEach-Object { "$($z.$_)" -replace '\|', '/' }) -join " | ") + " |")
    }
} else {
    $zeilenListe | Format-Table -AutoSize -Wrap -Property Name, Pfad, Sauber, Ignoriert, InMain, Remote, Empfehlung | Out-String -Width 400 | Write-Output
}
Write-Output ""
Write-Output "Hinweis: Das Skript hat nichts gelöscht, nichts gepusht und keine Refs geändert. Ignorierte Dateien löscht 'git worktree remove' mit."
