[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# colors
$cyan = "`e[38;2;0;255;255m"
$pink = "`e[38;2;255;20;147m"
$purple = "`e[38;2;138;43;226m"
$gold = "`e[38;2;255;215;0m"
$red = "`e[38;2;255;50;50m"
$green = "`e[38;2;50;255;50m"
$orange = "`e[38;2;255;165;0m"
$blue = "`e[38;2;70;130;200m"
$white = "`e[38;2;230;230;230m"
$gray = "`e[38;2;128;128;128m"
$reset = "`e[0m"

Write-Host @"
${cyan}
╔════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                    ║
║    ██████╗ ██╗     ███████╗███████╗███████╗███████╗██████╗                                         ║
║    ██╔══██╗██║     ██╔════╝██╔════╝██╔════╝██╔════╝██╔══██╗                                        ║
║    ██████╔╝██║     █████╗  ███████╗███████╗█████╗  ██║  ██║                                        ║
║    ██╔══██╗██║     ██╔══╝  ╚════██║╚════██║██╔══╝  ██║  ██║                                        ║
║    ██████╔╝███████╗███████╗███████║███████║███████╗██████╔╝                                        ║
║    ╚═════╝ ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚═════╝                                         ║
║                                                                                                    ║
║    ███╗   ███╗ ██████╗ ██████╗      █████╗ ███╗   ██╗ █████╗ ██╗  ██╗   ██╗███████╗███████╗██████╗ ║
║    ████╗ ████║██╔═══██╗██╔══██╗    ██╔══██╗████╗  ██║██╔══██╗██║  ╚██╗ ██╔╝╚══███╔╝██╔════╝██╔══██╗║
║    ██╔████╔██║██║   ██║██║  ██║    ███████║██╔██╗ ██║███████║██║   ╚████╔╝   ███╔╝ █████╗  ██████╔╝║
║    ██║╚██╔╝██║██║   ██║██║  ██║    ██╔══██║██║╚██╗██║██╔══██║██║    ╚██╔╝   ███╔╝  ██╔══╝  ██╔══██╗║
║    ██║ ╚═╝ ██║╚██████╔╝██████╔╝    ██║  ██║██║ ╚████║██║  ██║███████╗██║   ███████╗███████╗██║  ██║║
║    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝║
║                                                                                                    ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════╝
${reset}
"@

Write-Host "${gray}                          made by Blessed | discord: 8j0w${reset}"
Write-Host ""
Write-Host "${cyan}════════════════════════════════════════════════════════════════════════════${reset}"
Write-Host ""

# folder selection
Write-Host "${cyan}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
Write-Host "${cyan}│${white}  MODS FOLDER SELECTION                                                 ${cyan}│${reset}"
Write-Host "${cyan}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
Write-Host "${cyan}│${gray}  Enter path to your mods folder                                          ${cyan}│${reset}"
Write-Host "${cyan}│${gray}  (press Enter for default)                                              ${cyan}│${reset}"
Write-Host "${cyan}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
Write-Host ""

$mods = Read-Host "${gold}  ➤${white} PATH${reset}"

if (-not $mods) {
    $mods = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
    Write-Host "`n${green}  ✓ using: ${white}$mods${reset}"
}
if (-not (Test-Path $mods -PathType Container)) { 
    Write-Host "`n${red}  ✗ invalid folder${reset}"
    Start-Sleep -Seconds 2
    exit 1 
}

# check running minecraft
$process = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $process) { $process = Get-Process java -ErrorAction SilentlyContinue }
if ($process) {
    $elapsed = (Get-Date) - $process.StartTime
    Write-Host "`n${cyan}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
    Write-Host "${cyan}│${green}  ✓ MINECRAFT RUNNING                                                  ${cyan}│${reset}"
    Write-Host "${cyan}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
    Write-Host "${cyan}│${gray}  process: ${white}$($process.Name) (PID: $($process.Id))${reset}"
    Write-Host "${cyan}│${gray}  uptime:  ${white}$($elapsed.Hours)h $($elapsed.Minutes)m $($elapsed.Seconds)s${reset}"
    Write-Host "${cyan}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
Write-Host ""

# detect minecraft version
Write-Host "${cyan}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
Write-Host "${cyan}│${white}  DETECTING MINECRAFT VERSION                                           ${cyan}│${reset}"
Write-Host "${cyan}└─────────────────────────────────────────────────────────────────────────────┘${reset}"

$jarFiles = Get-ChildItem -Path $mods -Filter *.jar
$totalMods = $jarFiles.Count
$mcVersions = @{}
$modsScanned = 0

for ($i = 0; $i -lt $jarFiles.Count; $i++) {
    $file = $jarFiles[$i]
    Write-Host "`r  scanning mods... ${$i+1}/$totalMods" -NoNewline
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
        $fmj = $zip.Entries | Where-Object { $_.Name -eq 'fabric.mod.json' } | Select-Object -First 1
        if ($fmj) {
            $r = New-Object System.IO.StreamReader($fmj.Open())
            $fd = $r.ReadToEnd() | ConvertFrom-Json -ErrorAction SilentlyContinue
            $r.Close()
            if ($fd.depends.minecraft) {
                $s = $fd.depends.minecraft
                $ver = if ($s -match '>=\s*(\d+\.\d+(?:\.\d+)?).*<=\s*(\d+\.\d+(?:\.\d+)?)') { $matches[2] }
                      elseif ($s -match '[><=~\^]+\s*(\d+\.\d+(?:\.\d+)?)') { $matches[1] }
                      elseif ($s -match '^(\d+\.\d+(?:\.\d+)?)$') { $matches[1] }
                      elseif ($s -match '(\d+\.\d+(?:\.\d+)?)') { $matches[1] }
                if ($ver -match '^\d+\.\d+(?:\.\d+)?$') { 
                    if (-not $mcVersions[$ver]) { $mcVersions[$ver] = 0 }
                    $mcVersions[$ver]++
                    $modsScanned++
                }
            }
        }
        $mtoml = $zip.Entries | Where-Object { $_.FullName -eq 'META-INF/mods.toml' } | Select-Object -First 1
        if ($mtoml) {
            $r = New-Object System.IO.StreamReader($mtoml.Open())
            $tc = $r.ReadToEnd()
            $r.Close()
            if ($tc -match 'modId\s*=\s*"minecraft"[\s\S]{0,200}versionRange\s*=\s*"([^"]+)"') {
                $vr = $matches[1]
                $ver = if ($vr -match '\[(\d+\.\d+(?:\.\d+)?),') { $matches[1] }
                       elseif ($vr -match '\[(\d+\.\d+(?:\.\d+)?)\]') { $matches[1] }
                       elseif ($vr -match '(\d+\.\d+(?:\.\d+)?)') { $matches[1] }
                if ($ver) { 
                    if (-not $mcVersions[$ver]) { $mcVersions[$ver] = 0 }
                    $mcVersions[$ver]++
                    $modsScanned++
                }
            }
        }
        $zip.Dispose()
    } catch { continue }
}
Write-Host ""

$minecraftVersion = $null
if ($mcVersions.Count -gt 0) {
    $best = $mcVersions.GetEnumerator() | Sort-Object -Property @{E={$_.Value};D=$true},@{E={$_.Key};D=$true} | Select-Object -First 1
    Write-Host "${green}  ✓ version: ${white}$($best.Key)${reset} ${gray}(from $($best.Value) mods)${reset}"
    $minecraftVersion = $best.Key
} else {
    Write-Host "${yellow}  ⚠ could not detect version${reset}"
    $minecraftVersion = Read-Host "${gold}  ➤${white} enter minecraft version${reset} ${gray}(1.21, 1.20.1, etc)${reset}"
}
Write-Host ""

# functions
function Get-SHA1($p) { return (Get-FileHash -Path $p -Algorithm SHA1).Hash }

function Get-ZoneIdentifier($p) {
    try {
        $raw = Get-Content -Raw -Stream Zone.Identifier $p -ErrorAction SilentlyContinue
        if ($raw -match "HostUrl=(.+)") {
            $url = $matches[1]
            $src = switch -regex ($url) { "modrinth\.com"{"Modrinth"} "curseforge\.com"{"CurseForge"} "github\.com"{"GitHub"} default{"Other"} }
            return @{ Source=$src; URL=$url; IsModrinth=$url -match "modrinth\.com" }
        }
    } catch {}
    return @{ Source="Unknown"; URL=""; IsModrinth=$false }
}

function Get-Mod-Info-From-Jar($jarPath) {
    $mi = @{ ModId=""; Name=""; Version=""; ModLoader="" }
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($jarPath)
        $e = $zip.Entries | Where-Object { $_.Name -eq 'fabric.mod.json' } | Select-Object -First 1
        if ($e) {
            $r = New-Object System.IO.StreamReader($e.Open(), [System.Text.Encoding]::UTF8)
            $fd = $r.ReadToEnd() | ConvertFrom-Json
            $r.Close()
            $mi.ModId = $fd.id
            $mi.Name = $fd.name
            $mi.Version = $fd.version
            $mi.ModLoader = "Fabric"
            $zip.Dispose()
            return $mi
        }
        $e = $zip.Entries | Where-Object { $_.FullName -eq 'META-INF/mods.toml' } | Select-Object -First 1
        if ($e) {
            $r = New-Object System.IO.StreamReader($e.Open(), [System.Text.Encoding]::UTF8)
            $tc = $r.ReadToEnd()
            $r.Close()
            if ($tc -match 'modId\s*=\s*"([^"]+)"') { $mi.ModId = $matches[1] }
            if ($tc -match 'displayName\s*=\s*"([^"]+)"') { $mi.Name = $matches[1] }
            if ($tc -match 'version\s*=\s*"([^"]+)"') { $mi.Version = $matches[1] }
            $mi.ModLoader = "Forge"
            $zip.Dispose()
            return $mi
        }
        $zip.Dispose()
    } catch {}
    return $mi
}

function Find-Closest-Version($localVersion, $availableVersions, $preferredLoader, $minecraftVersion) {
    if (-not $localVersion -or -not $availableVersions) { return $null }
    $fv = $availableVersions | Where-Object { ($_.loaders -contains $preferredLoader.ToLower()) -and ((-not $minecraftVersion) -or ($_.game_versions -contains $minecraftVersion)) }
    if (-not $fv) { $fv = $availableVersions | Where-Object { $_.game_versions -contains $minecraftVersion } }
    if (-not $fv) { $fv = $availableVersions | Where-Object { $_.loaders -contains $preferredLoader.ToLower() } }
    if (-not $fv) { $fv = $availableVersions }
    $exact = $fv | Where-Object { $_.version_number -eq $localVersion } | Select-Object -First 1
    if ($exact) { return $exact }
    return $fv | Select-Object -First 1
}

function Build-ModrinthResult($proj, $ver, $versions, $matchType="") {
    $file = $ver.files[0]
    $loader = if ($ver.loaders -contains "fabric") {"Fabric"} elseif ($ver.loaders -contains "forge") {"Forge"} else {$ver.loaders[0]}
    return @{ 
        Name = $proj.title; Slug = $proj.slug; ExpectedSize = $file.size; VersionNumber = $ver.version_number
        FileName = $file.filename; ModrinthUrl = "https://modrinth.com/mod/$($proj.slug)/version/$($ver.id)"
        ExactMatch = ($matchType -eq "Exact Version" -or $matchType -eq "Exact Filename")
        MatchType = $matchType; LoaderType = $loader
    }
}

function Get-ModrinthVersions($id) { return Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$id/version" -UseBasicParsing }
function Get-ModrinthProject($id) { return Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$id" -UseBasicParsing }

function Fetch-Modrinth-By-Hash($hash) {
    try {
        $resp = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$hash" -UseBasicParsing
        if ($resp.project_id) {
            $proj = Get-ModrinthProject $resp.project_id
            return @{ Name=$proj.title; ExpectedSize=$resp.files[0].size; VersionNumber=$resp.version_number
                      ModrinthUrl="https://modrinth.com/mod/$($proj.slug)/version/$($resp.id)"
                      MatchType="hash match"; LoaderType="Unknown" }
        }
    } catch {}
    return $null
}

function Fetch-Modrinth-By-ModId($modId, $version, $preferredLoader) {
    try {
        $proj = Get-ModrinthProject $modId
        $versions = Get-ModrinthVersions $modId
        $matched = Find-Closest-Version $version $versions $preferredLoader $minecraftVersion
        if ($matched) { return Build-ModrinthResult $proj $matched $versions -matchType (if ($matched.version_number -eq $version){"exact version"} else {"close version"}) }
        return Build-ModrinthResult $proj $versions[0] $versions -matchType "latest version"
    } catch { return $null }
}

function Fetch-Modrinth-By-Filename($filename, $preferredLoader) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($filename) -replace '[-_][\d\.]+$','' -replace '(?i)-fabric$|-forge$',''
    try {
        $proj = Get-ModrinthProject $base.ToLower()
        $versions = Get-ModrinthVersions $base.ToLower()
        $matched = Find-Closest-Version "" $versions $preferredLoader $minecraftVersion
        if ($matched) { return Build-ModrinthResult $proj $matched $versions -matchType "best match" }
    } catch {
        try {
            $search = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/search?query=`"$base`"&limit=3" -UseBasicParsing
            if ($search.hits.Count -gt 0) {
                $proj = Get-ModrinthProject $search.hits[0].project_id
                $versions = Get-ModrinthVersions $search.hits[0].project_id
                return Build-ModrinthResult $proj $versions[0] $versions -matchType "search match"
            }
        } catch {}
    }
    return $null
}

# cheat strings
$cheatStrings = @(
    "autocrystal","autototem","autoanchor","autopot","autoarmor","aimassist","triggerbot","fakelag","pingspoof","freecam",
    "clickSimulation","switchDelay","placeChance","explodeDelay","explodeSlot","antiWeakness","damageTick",
    "AutoCrystal","AutoTotem","AutoAnchor","AutoPot","AutoArmor","AimAssist","Freecam","FakeLag",
    "crystalpvp","crystalaura","killaura","speedmine","scaffold","flyhack","nofall","antikb",
    "dqrkis","CwskKkUfHQYB","HgsCDQ49KkUfHQYB","DhsnbQ0LDg0MDA","OhYHBQcOHw"
)

# scan everything in one pass
$verified = @()
$unknown = @()
$cheats = @()
$tampered = @()

Write-Host "${cyan}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
Write-Host "${cyan}│${white}  SCANNING MODS                                                         ${cyan}│${reset}"
Write-Host "${cyan}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
Write-Host ""

for ($i = 0; $i -lt $jarFiles.Count; $i++) {
    $file = $jarFiles[$i]
    Write-Host "`r  [$($i+1)/$totalMods] ${gray}$($file.Name)${reset}" -NoNewline
    
    $hash = Get-SHA1 $file.FullName
    $actualSize = $file.Length
    $actualSizeKB = [math]::Round($actualSize/1KB, 2)
    $zone = Get-ZoneIdentifier $file.FullName
    $jarInfo = Get-Mod-Info-From-Jar $file.FullName
    $loader = if ($file.Name -match 'fabric') {"Fabric"} elseif ($file.Name -match 'forge') {"Forge"} else {"Fabric"}
    
    # check modrinth
    $info = Fetch-Modrinth-By-Hash $hash
    if (-not $info -and $jarInfo.ModId) { $info = Fetch-Modrinth-By-ModId $jarInfo.ModId $jarInfo.Version $loader }
    if (-not $info) { $info = Fetch-Modrinth-By-Filename $file.Name $loader }
    
    # check for cheats
    $isCheat = $false
    $foundStrings = @()
    try {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $text = [System.Text.Encoding]::UTF8.GetString($bytes).ToLower()
        foreach ($str in $cheatStrings) {
            if ($text -match $str.ToLower()) {
                $isCheat = $true
                $foundStrings += $str
            }
        }
    } catch {}
    
    # check obfuscation
    $obfuscated = $false
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
        $classes = ($zip.Entries | Where-Object { $_.FullName -match '\.class$' }).Count
        $singleChars = 0
        foreach ($entry in ($zip.Entries | Where-Object { $_.FullName -match '\.class$' })) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($entry.Name)
            if ($name.Length -eq 1) { $singleChars++ }
        }
        $zip.Dispose()
        if ($classes -gt 20 -and ($singleChars / $classes) -gt 0.5) { $obfuscated = $true }
    } catch {}
    
    $modObj = [PSCustomObject]@{
        Name = if ($info) { $info.Name } else { $null }
        FileName = $file.Name
        SizeKB = $actualSizeKB
        ExpectedSizeKB = if ($info -and $info.ExpectedSize) { [math]::Round($info.ExpectedSize/1KB, 2) } else { 0 }
        Loader = $loader
        Source = $zone.Source
        Url = if ($info) { $info.ModrinthUrl } else { $null }
        ModId = $jarInfo.ModId
        InternalName = $jarInfo.Name
        IsCheat = $isCheat
        CheatStrings = $foundStrings
        IsObfuscated = $obfuscated
        MatchType = if ($info) { $info.MatchType } else { "none" }
    }
    
    if ($isCheat) {
        $cheats += $modObj
    } elseif ($info -and $info.Name -and -not $obfuscated) {
        $verified += $modObj
    } elseif ($info -and $info.Name -and $obfuscated) {
        $tampered += $modObj
    } else {
        $unknown += $modObj
    }
}
Write-Host "`n"

# second pass for unknown
for ($i = 0; $i -lt $unknown.Count; $i++) {
    $mod = $unknown[$i]
    Write-Host "`r  identifying unknowns... $($i+1)/$($unknown.Count)" -NoNewline
    if ($mod.ModId) {
        $info = Fetch-Modrinth-By-ModId $mod.ModId $null $mod.Loader
        if ($info -and $info.Name) {
            $mod.Name = $info.Name
            $mod.Url = $info.ModrinthUrl
            $mod.ExpectedSizeKB = [math]::Round($info.ExpectedSize/1KB, 2)
            $mod.MatchType = $info.MatchType
            $verified += $mod
            $unknown = $unknown | Where-Object { $_.FileName -ne $mod.FileName }
        }
    }
}
Write-Host "`n"

# disallowed mods
$disallowed = @{
    "xeros-minimap" = "Xero's Minimap"
    "freecam" = "Freecam"
    "health-indicators" = "Health Indicators"
    "clickcrystals" = "ClickCrystals"
    "mousetweaks" = "Mouse Tweaks"
    "itemscroller" = "Item Scroller"
    "tweakeroo" = "Tweakeroo"
}
$disallowedFound = @()
foreach ($mod in $verified + $unknown) {
    foreach ($bad in $disallowed.Keys) {
        if ($mod.Name -and $mod.Name.ToLower() -match $bad) {
            $disallowedFound += $mod
        }
    }
}

# show results
Clear-Host

# banner again
Write-Host @"
${cyan}
╔════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                    ║
║    ██████╗ ██╗     ███████╗███████╗███████╗███████╗██████╗                                         ║
║    ██╔══██╗██║     ██╔════╝██╔════╝██╔════╝██╔════╝██╔══██╗                                        ║
║    ██████╔╝██║     █████╗  ███████╗███████╗█████╗  ██║  ██║                                        ║
║    ██╔══██╗██║     ██╔══╝  ╚════██║╚════██║██╔══╝  ██║  ██║                                        ║
║    ██████╔╝███████╗███████╗███████║███████║███████╗██████╔╝                                        ║
║    ╚═════╝ ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚═════╝                                         ║
║                                                                                                    ║
║    ███╗   ███╗ ██████╗ ██████╗      █████╗ ███╗   ██╗ █████╗ ██╗  ██╗   ██╗███████╗███████╗██████╗ ║
║    ████╗ ████║██╔═══██╗██╔══██╗    ██╔══██╗████╗  ██║██╔══██╗██║  ╚██╗ ██╔╝╚══███╔╝██╔════╝██╔══██╗║
║    ██╔████╔██║██║   ██║██║  ██║    ███████║██╔██╗ ██║███████║██║   ╚████╔╝   ███╔╝ █████╗  ██████╔╝║
║    ██║╚██╔╝██║██║   ██║██║  ██║    ██╔══██║██║╚██╗██║██╔══██║██║    ╚██╔╝   ███╔╝  ██╔══╝  ██╔══██╗║
║    ██║ ╚═╝ ██║╚██████╔╝██████╔╝    ██║  ██║██║ ╚████║██║  ██║███████╗██║   ███████╗███████╗██║  ██║║
║    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝║
║                                                                                                    ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════╝
${reset}
"@

Write-Host "${cyan}════════════════════════════════════════════════════════════════════════════${reset}"
Write-Host "${white}                          SCAN RESULTS${reset}"
Write-Host "${cyan}════════════════════════════════════════════════════════════════════════════${reset}"
Write-Host ""

# stats
$total = $verified.Count + $unknown.Count + $cheats.Count + $tampered.Count
Write-Host "${gray}  total mods: ${white}$total${reset}  |  ${green}verified: $($verified.Count)${reset}  |  ${yellow}unknown: $($unknown.Count)${reset}  |  ${red}cheats: $($cheats.Count)${reset}  |  ${orange}tampered: $($tampered.Count)${reset}"
Write-Host ""

# verified
if ($verified.Count -gt 0) {
    Write-Host "${green}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
    Write-Host "${green}│${white}  ✓ VERIFIED MODS ($($verified.Count))                                          ${green}│${reset}"
    Write-Host "${green}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
    foreach ($mod in $verified | Select-Object -First 20) {
        Write-Host "${green}│${reset}  ${green}✓${reset} ${white}$($mod.Name)${reset}"
        Write-Host "${green}│${reset}    ${gray}$($mod.FileName) │ $($mod.SizeKB) KB │ $($mod.Loader)${reset}"
        if ($mod.Url) { Write-Host "${green}│${reset}    ${blue}$($mod.Url)${reset}" }
        Write-Host "${green}│${reset}"
    }
    if ($verified.Count -gt 20) {
        Write-Host "${green}│${reset}  ${gray}... and $($verified.Count - 20) more${reset}"
        Write-Host "${green}│${reset}"
    }
    Write-Host "${green}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
    Write-Host ""
}

# unknown
if ($unknown.Count -gt 0) {
    Write-Host "${yellow}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
    Write-Host "${yellow}│${white}  ? UNKNOWN MODS ($($unknown.Count))                                            ${yellow}│${reset}"
    Write-Host "${yellow}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
    foreach ($mod in $unknown) {
        Write-Host "${yellow}│${reset}  ${yellow}?${reset} ${white}$($mod.FileName)${reset}"
        Write-Host "${yellow}│${reset}    ${gray}size: $($mod.SizeKB) KB | loader: $($mod.Loader)${reset}"
        if ($mod.ModId) { Write-Host "${yellow}│${reset}    ${gray}internal id: $($mod.ModId)${reset}" }
        Write-Host "${yellow}│${reset}"
    }
    Write-Host "${yellow}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
    Write-Host ""
}

# tampered
if ($tampered.Count -gt 0) {
    Write-Host "${orange}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
    Write-Host "${orange}│${white}  ⚠ TAMPERED MODS ($($tampered.Count))                                           ${orange}│${reset}"
    Write-Host "${orange}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
    foreach ($mod in $tampered) {
        $diff = $mod.SizeKB - $mod.ExpectedSizeKB
        $sign = if ($diff -gt 0) {"+"} else {""}
        Write-Host "${orange}│${reset}  ${orange}⚠${reset} ${white}$($mod.Name)${reset}"
        Write-Host "${orange}│${reset}    ${gray}$($mod.FileName)${reset}"
        Write-Host "${orange}│${reset}    ${gray}expected: ${green}$($mod.ExpectedSizeKB) KB${reset} ${gray}| actual: ${red}$($mod.SizeKB) KB${reset} ${gray}| diff: ${red}$sign$($diff) KB${reset}"
        Write-Host "${orange}│${reset}"
    }
    Write-Host "${orange}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
    Write-Host ""
}

# cheats
if ($cheats.Count -gt 0) {
    Write-Host "${red}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
    Write-Host "${red}│${white}  💀 CHEAT MODS DETECTED ($($cheats.Count))                                      ${red}│${reset}"
    Write-Host "${red}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
    foreach ($mod in $cheats) {
        Write-Host "${red}│${reset}  ${red}💀${reset} ${white}$($mod.FileName)${reset}"
        if ($mod.Name) { Write-Host "${red}│${reset}    ${gray}identified as: ${white}$($mod.Name)${reset}" }
        Write-Host "${red}│${reset}    ${gray}detected strings:${reset}"
        foreach ($str in ($mod.CheatStrings | Select-Object -First 4)) {
            Write-Host "${red}│${reset}      ${pink}$str${reset}"
        }
        if ($mod.CheatStrings.Count -gt 4) {
            Write-Host "${red}│${reset}      ${gray}... and $($mod.CheatStrings.Count - 4) more${reset}"
        }
        Write-Host "${red}│${reset}"
    }
    Write-Host "${red}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
    Write-Host ""
}

# disallowed
if ($disallowedFound.Count -gt 0) {
    Write-Host "${red}┌─────────────────────────────────────────────────────────────────────────────┐${reset}"
    Write-Host "${red}│${white}  🚫 DISALLOWED MODS ($($disallowedFound.Count))                                  ${red}│${reset}"
    Write-Host "${red}├─────────────────────────────────────────────────────────────────────────────┤${reset}"
    foreach ($mod in $disallowedFound) {
        Write-Host "${red}│${reset}  ${red}⛔${reset} ${white}$($mod.FileName)${reset}"
        Write-Host "${red}│${reset}"
    }
    Write-Host "${red}└─────────────────────────────────────────────────────────────────────────────┘${reset}"
    Write-Host ""
}

# final message
Write-Host "${cyan}════════════════════════════════════════════════════════════════════════════${reset}"
if ($cheats.Count -eq 0 -and $disallowedFound.Count -eq 0) {
    Write-Host "${green}  ✓ clean folder - no cheats found${reset}"
} else {
    Write-Host "${red}  ✗ remove the mods above before playing${reset}"
}
Write-Host "${cyan}════════════════════════════════════════════════════════════════════════════${reset}"
Write-Host ""

Write-Host "${gray}press any key to exit...${reset}"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
