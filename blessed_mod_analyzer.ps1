[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::ForegroundColor = [ConsoleColor]::Cyan
Clear-Host

# Custom color scheme
$c = @{
    cyan    = "`e[38;2;0;255;255m"
    pink    = "`e[38;2;255;105;180m"
    purple  = "`e[38;2;156;0;255m"
    gold    = "`e[38;2;255;215;0m"
    red     = "`e[38;2;255;50;50m"
    green   = "`e[38;2;50;255;50m"
    orange  = "`e[38;2;255;165;0m"
    blue    = "`e[38;2;100;150;255m"
    white   = "`e[38;2;220;220;220m"
    gray    = "`e[38;2;128;128;128m"
    reset   = "`e[0m"
}

# ULTRA ASCII ART - GLOW EFFECT
Write-Host @"
${c.purple}                                                                              
${c.purple}    ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
${c.purple}   ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
${c.purple}   ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
${c.purple}   ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌
${c.cyan}   ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░▌       ▐░▌
${c.cyan}   ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
${c.cyan}   ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
${c.green}   ▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
${c.green}   ▐░▌       ▐░▌▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
${c.green}   ▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
${c.green}    ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 
${c.reset}
"@

Write-Host "`n${c.purple}═══════════════════════════════════════════════════════════════════════════════════════════════${c.reset}"
Write-Host "${c.cyan}                                  ✨ BLESSED MOD ANALYZER v3.0 ✨${c.reset}"
Write-Host "${c.purple}═══════════════════════════════════════════════════════════════════════════════════════════════${c.reset}"
Write-Host ""
Write-Host "${c.gray}                         made with ${c.red}❤${c.gray} by Blessed | discord: 8j0w${c.reset}"
Write-Host ""

# Cool loading animation
function Show-Loading {
    param($msg, $color)
    $chars = @('█', '▓', '▒', '░')
    for ($i = 0; $i -lt 20; $i++) {
        Write-Host "`r${c.cyan}  ╭─${c.reset} $msg ${c.gray}[$($chars[$i % 4])$($chars[($i+1)%4])$($chars[($i+2)%4])$($chars[($i+3)%4])]${c.reset}" -NoNewline
        Start-Sleep -Milliseconds 30
    }
    Write-Host "`r${c.green}  ╰─✓ $msg ${c.gray}[DONE]${c.reset}                    "
}

Show-Loading -msg "Initializing Quantum Scanner" -color green
Start-Sleep -Milliseconds 100

Write-Host ""
Write-Host "${c.cyan}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
Write-Host "${c.cyan}│${c.white}  📁 MODS FOLDER SELECTION                                                     ${c.cyan}│${c.reset}"
Write-Host "${c.cyan}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
Write-Host "${c.cyan}│${c.gray}  Enter path to your mods folder (or press Enter for default)                 ${c.cyan}│${c.reset}"
Write-Host "${c.cyan}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
Write-Host ""

$mods = Read-Host "${c.gold}  ➤${c.white} PATH${c.reset}"

if (-not $mods) {
    $mods = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
    Write-Host "`n${c.green}  ✓ Using default path: ${c.white}$mods${c.reset}"
    Write-Host ""
}
if (-not (Test-Path $mods -PathType Container)) { 
    Write-Host "`n${c.red}  ❌ ERROR: Invalid folder path!${c.reset}"
    Write-Host ""
    pause
    exit 1 
}

# Check running Minecraft instance
$process = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $process) { $process = Get-Process java -ErrorAction SilentlyContinue }
if ($process) {
    try {
        $elapsed = (Get-Date) - $process.StartTime
        Write-Host "${c.cyan}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
        Write-Host "${c.cyan}│${c.purple}  🎮 MINECRAFT RUNTIME DETECTED                                          ${c.cyan}│${c.reset}"
        Write-Host "${c.cyan}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
        Write-Host "${c.cyan}│${c.green}  Status: ${c.white}RUNNING ✓                                                  ${c.cyan}│${c.reset}"
        Write-Host "${c.cyan}│${c.gray}  Process: ${c.white}$($process.Name) (PID: $($process.Id))                                                  ${c.cyan}│${c.reset}"
        Write-Host "${c.cyan}│${c.gray}  Uptime:  ${c.white}$($elapsed.Hours)h $($elapsed.Minutes)m $($elapsed.Seconds)s                                                    ${c.cyan}│${c.reset}"
        Write-Host "${c.cyan}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
        Write-Host ""
    } catch {}
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

# VERSION DETECTION
Write-Host "${c.cyan}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
Write-Host "${c.cyan}│${c.blue}  🔍 ANALYZING MODS FOR MINECRAFT VERSION                                   ${c.cyan}│${c.reset}"
Write-Host "${c.cyan}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
Write-Host ""

$jarFiles = Get-ChildItem -Path $mods -Filter *.jar
$totalMods = $jarFiles.Count

# Progress bar function
function Show-Progress {
    param($current, $total, $message)
    $percent = [math]::Round(($current / $total) * 100)
    $barLength = 40
    $filled = [math]::Round(($percent / 100) * $barLength)
    $empty = $barLength - $filled
    $bar = "${c.green}$('█' * $filled)${c.gray}$('░' * $empty)${c.reset}"
    Write-Host "`r${c.cyan}  ╭─${c.reset} $message ${c.white}[$current/$total]${c.reset} $bar ${c.white}$percent%${c.reset}" -NoNewline
}

# Version detection loop
$mcVersions = @{}
$modsScanned = 0
for ($i = 0; $i -lt $jarFiles.Count; $i++) {
    $file = $jarFiles[$i]
    Show-Progress -current ($i+1) -total $totalMods -message "Scanning mods for version info"
    
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
    Write-Host "${c.green}  ✓ Detected Minecraft version: ${c.white}$($best.Key)${c.reset} ${c.gray}(from $($best.Value) mods)${c.reset}"
    Write-Host ""
    $minecraftVersion = $best.Key
} else {
    Write-Host "${c.yellow}  ⚠ Could not auto-detect version${c.reset}"
    $minecraftVersion = Read-Host "${c.gold}  ➤${c.white} Enter your Minecraft version${c.reset} ${c.gray}(e.g., 1.21, 1.20.1)${c.reset}"
    Write-Host ""
}

# Function definitions
function Get-SHA1($p) { return (Get-FileHash -Path $p -Algorithm SHA1).Hash }

function Get-ZoneIdentifier($p) {
    try {
        $raw = Get-Content -Raw -Stream Zone.Identifier $p -ErrorAction SilentlyContinue
        if ($raw -match "HostUrl=(.+)") {
            $url = $matches[1]
            $src = switch -regex ($url) { "modrinth\.com"{"Modrinth"} "curseforge\.com"{"CurseForge"} "github\.com"{"GitHub"} "discord"{"Discord"} default{"Other"} }
            return @{ Source=$src; URL=$url; IsModrinth=$url -match "modrinth\.com" }
        }
    } catch {}
    return @{ Source="Unknown"; URL=""; IsModrinth=$false }
}

function Get-Mod-Info-From-Jar($jarPath) {
    $mi = @{ ModId=""; Name=""; Version=""; Authors=@(); ModLoader="" }
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
            $mi.ModLoader = "Forge/NeoForge"
            $zip.Dispose()
            return $mi
        }
        $zip.Dispose()
    } catch {}
    return $mi
}

function Find-Closest-Version($localVersion, $availableVersions, $preferredLoader="Fabric", $minecraftVersion) {
    if (-not $localVersion -or -not $availableVersions) { return $null }
    $fv = $availableVersions | Where-Object { ($_.loaders -contains $preferredLoader.ToLower()) -and ((-not $minecraftVersion) -or ($_.game_versions -contains $minecraftVersion)) }
    if (-not $fv) { $fv = $availableVersions | Where-Object { $_.game_versions -contains $minecraftVersion } }
    if (-not $fv) { $fv = $availableVersions | Where-Object { $_.loaders -contains $preferredLoader.ToLower() } }
    if (-not $fv) { $fv = $availableVersions }
    $exact = $fv | Where-Object { $_.version_number -eq $localVersion } | Select-Object -First 1
    if ($exact) { return $exact }
    try {
        if ($localVersion -match '(\d+)\.(\d+)\.(\d+)') {
            $ma = [int]$matches[1]; $mi2 = [int]$matches[2]; $pa = [int]$matches[3]
            $best = $null; $bestD = [double]::MaxValue
            foreach ($v in $fv) {
                if ($v.version_number -match '(\d+)\.(\d+)\.(\d+)') {
                    $d = [math]::Sqrt([math]::Pow($ma-[int]$matches[1],2)*100 + [math]::Pow($mi2-[int]$matches[2],2)*10 + [math]::Pow($pa-[int]$matches[3],2))
                    if ($d -lt $bestD) { $bestD = $d; $best = $v }
                }
            }
            if ($best -and $bestD -lt 10) { return $best }
        }
        if ($localVersion -match '(\d+)\.(\d+)') {
            $ma = [int]$matches[1]; $mi2 = [int]$matches[2]
            $best = $null; $bestD = [double]::MaxValue
            foreach ($v in $fv) {
                if ($v.version_number -match '(\d+)\.(\d+)') {
                    $d = [math]::Sqrt([math]::Pow($ma-[int]$matches[1],2)*10 + [math]::Pow($mi2-[int]$matches[2],2))
                    if ($d -lt $bestD) { $bestD = $d; $best = $v }
                }
            }
            if ($best -and $bestD -lt 5) { return $best }
        }
    } catch {}
    return $fv | Where-Object { $_.version_number -match [regex]::Escape($localVersion) } | Select-Object -First 1
}

function Build-ModrinthResult($proj, $ver, $versions, $byHash=$false, $matchType="") {
    $file = $ver.files[0]
    $loader = if ($ver.loaders -contains "fabric") {"Fabric"} elseif ($ver.loaders -contains "forge") {"Forge"} else {$ver.loaders[0]}
    return @{ 
        Name = $proj.title; Slug = $proj.slug; ExpectedSize = $file.size; VersionNumber = $ver.version_number
        FileName = $file.filename; ModrinthUrl = "https://modrinth.com/mod/$($proj.slug)/version/$($ver.id)"
        FoundByHash = $byHash; ExactMatch = ($byHash -or $matchType -eq "Exact Version" -or $matchType -eq "Exact Filename")
        IsLatestVersion = ($versions[0].id -eq $ver.id); MatchType = $matchType; LoaderType = $loader
    }
}

function Get-ModrinthVersions($id) { return Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$id/version" -UseBasicParsing }
function Get-ModrinthProject($id) { return Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$id" -UseBasicParsing }

function Fetch-Modrinth-By-Hash($hash) {
    try {
        $resp = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$hash" -UseBasicParsing
        if ($resp.project_id) {
            $proj = Get-ModrinthProject $resp.project_id
            return @{ Name=$proj.title; Slug=$proj.slug; ExpectedSize=$resp.files[0].size; VersionNumber=$resp.version_number
                      FileName=$resp.files[0].filename; ModrinthUrl="https://modrinth.com/mod/$($proj.slug)/version/$($resp.id)"
                      FoundByHash=$true; ExactMatch=$true; IsLatestVersion=$false; MatchType="Exact Hash"
                      LoaderType=if ($resp.loaders -contains "fabric"){"Fabric"} elseif ($resp.loaders -contains "forge"){"Forge"} else{"Unknown"} }
        }
    } catch {}
    return @{ Name=""; Slug=""; ExpectedSize=0; VersionNumber=""; FileName=""; FoundByHash=$false; ExactMatch=$false; IsLatestVersion=$false; LoaderType="Unknown" }
}

function Fetch-By-ProjectId($id, $version, $preferredLoader) {
    try {
        $proj = Get-ModrinthProject $id; $versions = Get-ModrinthVersions $id
        $matched = Find-Closest-Version $version $versions $preferredLoader $minecraftVersion
        if ($matched) { return Build-ModrinthResult $proj $matched $versions -matchType (if ($matched.version_number -eq $version){"Exact Version"} else {"Closest Version"}) }
        $fallback = $versions | Where-Object { ($_.loaders -contains $preferredLoader.ToLower()) -and ((-not $minecraftVersion) -or ($_.game_versions -contains $minecraftVersion)) } | Select-Object -First 1
        if (-not $fallback) { $fallback = $versions[0] }
        if ($fallback) { return Build-ModrinthResult $proj $fallback $versions -matchType "Latest Version" }
    } catch {}
    return $null
}

function Fetch-Modrinth-By-ModId($modId, $version, $preferredLoader="Fabric") {
    $result = Fetch-By-ProjectId $modId $version $preferredLoader
    if ($result) { return $result }
    try {
        $search = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/search?query=`"$modId`"&facets=`"[[`"project_type:mod`"]]`"&limit=5" -UseBasicParsing
        if ($search.hits.Count -gt 0) {
            $best = $search.hits | Sort-Object { if ($_.slug -eq $modId){100} elseif ($_.title -eq $modId){80} elseif ($_.title -match $modId){50} else{0} } -Descending | Select-Object -First 1
            if ($best) { $r = Fetch-By-ProjectId $best.project_id $version $preferredLoader; if ($r) { return $r } }
        }
    } catch {}
    return @{ Name=""; Slug=""; ExpectedSize=0; VersionNumber=""; FileName=""; FoundByHash=$false; ExactMatch=$false; IsLatestVersion=$false; MatchType="No Match"; LoaderType="Unknown" }
}

function Fetch-Modrinth-By-Filename($filename, $preferredLoader="Fabric") {
    $clean = $filename -replace '\.temp\.jar$|\.tmp\.jar$|_1\.jar$','.jar'
    $base = [System.IO.Path]::GetFileNameWithoutExtension($clean)
    if ($filename -match '(?i)fabric') { $preferredLoader="Fabric" } elseif ($filename -match '(?i)forge') { $preferredLoader="Forge" }
    $localVer = ""; $baseName = $base
    if ($base -match '[-_](v?[\d\.]+(?:-[a-zA-Z0-9]+)?)$') { $localVer=$matches[1]; $baseName=$base -replace '[-_](v?[\d\.]+(?:-[a-zA-Z0-9]+)?)$','' }
    $baseName = $baseName -replace '(?i)-fabric$|-forge$',''

    foreach ($slug in @($baseName.ToLower(), $base.ToLower())) {
        try {
            $proj = Get-ModrinthProject $slug; $versions = Get-ModrinthVersions $slug
            $exactFile = $versions | ForEach-Object { $v=$_; $_.files | Where-Object { $_.filename -eq $clean -or $_.filename -eq $filename } | ForEach-Object { @{ver=$v;file=$_} } } | Select-Object -First 1
            if ($exactFile) { return Build-ModrinthResult $proj $exactFile.ver $versions -matchType "Exact Filename" }
            $matched = Find-Closest-Version $localVer $versions $preferredLoader $minecraftVersion
            if ($matched) { return Build-ModrinthResult $proj $matched $versions -matchType (if ($matched.version_number -eq $localVer){"Exact Version"} else {"Closest Version"}) }
            $fallback = $versions | Where-Object { ($_.loaders -contains $preferredLoader.ToLower()) -and ((-not $minecraftVersion) -or ($_.game_versions -contains $minecraftVersion)) } | Select-Object -First 1
            if (-not $fallback) { $fallback = $versions[0] }
            if ($fallback) { return Build-ModrinthResult $proj $fallback $versions -matchType "Latest Version" }
        } catch { continue }
    }
    try {
        $search = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/search?query=`"$baseName`"&facets=`"[[`"project_type:mod`"]]`"&limit=5" -UseBasicParsing
        if ($search.hits.Count -gt 0) {
            $hit = $search.hits[0]; $versions = Get-ModrinthVersions $hit.project_id
            $exactFile = $versions | ForEach-Object { $v=$_; $_.files | Where-Object { $_.filename -eq $clean -or $_.filename -eq $filename } | ForEach-Object { @{ver=$v;file=$_} } } | Select-Object -First 1
            if ($exactFile) { return Build-ModrinthResult $hit $exactFile.ver $versions -matchType "Exact Filename" }
            if ($versions.Count -gt 0) { return Build-ModrinthResult $hit $versions[0] $versions -matchType "Latest Version" }
        }
    } catch {}
    return @{ Name=""; Slug=""; ExpectedSize=0; VersionNumber=""; FileName=""; FoundByHash=$false; ExactMatch=$false; IsLatestVersion=$false; MatchType="No Match"; LoaderType="Unknown" }
}

$cheatStrings = @(
    "clickSimulation","switchDelay","switchChance","placeChance","glowstoneDelay","glowstoneChance","explodeDelay","explodeChance","explodeSlot","antiWeakness","damageTick","breakChance","breakDelay",
    "stopOnCrystal","processCrystal","swapToWeapon","isObsidianOrBedrock","isValidCrystalPosition","processAnchorPvP","isValidAnchorPosition",
    "AutoCrystal","autocrystal","auto crystal","AutoHitCrystal","autohitcrystal","dontPlaceCrystal","dontBreakCrystal","canPlaceCrystalServer","autoCrystalPlaceClock",
    "AutoAnchor","autoanchor","auto anchor","DoubleAnchor","safe anchor","safeanchor","anchortweaks","anchor macro",
    "AutoTotem","autototem","auto totem","InventoryTotem","inventorytotem","HoverTotem","hover totem","legittotem",
    "AutoPot","autopot","auto pot","speedPotSlot","strengthPotSlot","AutoArmor","autoarmor","auto armor","preventSwordBlockBreaking","preventSwordBlockAttack",
    "AutoDoubleHand","autodoublehand","auto double hand","AutoClicker","AimAssist","aimassist","aim assist","triggerbot","trigger bot",
    "shieldbreaker","shield breaker","axespam","axe spam","findKnockbackSword","attackRegisteredThisClick","FakeLag","pingspoof","ping spoof","freecam","Freecam","FakeInv",
    "pushOutOfBlocks","onPushOutOfBlocks","webmacro","web macro","JumpReset","Donut","setBlockBreakingCooldown","getBlockBreakingCooldown","setItemUseCooldown",
    "onBlockBreaking","invokeDoAttack","invokeDoItemUse","setSelectedSlot","getSelectedSlot","swapBackToOriginalSlot","blockBreakingCooldown","invokeOnMouseButton",
    "onSwapLastAttackedTicksReset","getVisualAttackCooldownProgressPerTick","getHandSwingDuration","onBeginRenderTick","PlayerMoveC2SPacketAccessor","redirectSelectedSlot","hookCancelBlockBreaking",
    "EndCrystalItemMixin","endcrystalitemmixin","WalksyCrystalOptimizerMod","arrayOfString","lvstrng","dqrkis","StringObfuscator","POT_CHEATS","onShouldRenderBlockOutline","predictCrystals","noOffhandTotem","getNearByCrystals",
    "slotExplode","needToPlaceRails","findTotemSlot","activateOnRightClick","crystalPlaceClock","isDeadBodyNearby","CrystalTwiceClock","mainHandStack","attackInAir","attackOnJump","onDestruct",
    "getGlowstoneChance","isAutoCharge","getPlaceChance","getSwitchDelay","getGlowstoneDelay","getExplodeDelay","getExplodeSlotIndex","getPlaceDelayTicks","getBreakDelayTicks","getBreakChance",
    "isSpawnersEnabled","isShulkersEnabled","onModuleDisabled","switchToBestTool","switchToBestWeapon","isLootProtect","getMinHunger","isTracersEnabled","getSelectedBlocks","isChestsEnabled",
    "inventoryToMenuSlot","throwPearl","isLeftHoldOnly","Automatically switches to sword when hitting with totem","Failed to switch to mace after axe!","Breaking shield with axe...","TrilliumSolutions",
    "selfdestruct","self destruct","CwskKkUfHQYB","HgsCDQ49KkUfHQYB","DhsnbQ0LDg0MDA","OhYHBQcOHw","EgQKDiUqRR8WChk","KjoFWRcEAx0M","Hx0GAVkcChwdDA","HSw7RQQIAQQ","BR0sFBcOGg4a","Oh0yWR0MCA"
)

# SCANNING MAIN LOOP - SINGLE PASS
$verifiedMods = [System.Collections.Generic.List[object]]::new()
$unknownMods  = [System.Collections.Generic.List[object]]::new()
$cheatMods    = [System.Collections.Generic.List[object]]::new()
$tamperedMods = [System.Collections.Generic.List[object]]::new()
$allModsInfo  = [System.Collections.Generic.List[object]]::new()

Write-Host "${c.cyan}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
Write-Host "${c.cyan}│${c.purple}  🚀 QUANTUM SCANNING ENGINE ACTIVE                                       ${c.cyan}│${c.reset}"
Write-Host "${c.cyan}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
Write-Host ""

for ($i = 0; $i -lt $jarFiles.Count; $i++) {
    $file = $jarFiles[$i]
    $percent = [math]::Round(($i+1)/$totalMods*100)
    Show-Progress -current ($i+1) -total $totalMods -message "Quantum scanning"
    
    $hash = Get-SHA1 $file.FullName
    $actualSize = $file.Length
    $actualSizeKB = [math]::Round($actualSize/1KB, 2)
    $zone = Get-ZoneIdentifier $file.FullName
    $jarInfo = Get-Mod-Info-From-Jar $file.FullName
    $loader = if ($file.Name -match '(?i)fabric'){"Fabric"} elseif ($file.Name -match '(?i)forge'){"Forge"} elseif ($jarInfo.ModLoader -eq "Fabric"){"Fabric"} elseif ($jarInfo.ModLoader -eq "Forge/NeoForge"){"Forge"} else {"Fabric"}

    # Check Modrinth
    $md = Fetch-Modrinth-By-Hash $hash
    if (-not $md.Name -and $jarInfo.ModId) { $md = Fetch-Modrinth-By-ModId $jarInfo.ModId $jarInfo.Version $loader }
    if (-not $md.Name) { $md = Fetch-Modrinth-By-Filename $file.Name $loader }

    # Check for cheat strings in same pass
    $hasCheatStrings = $false
    $foundStrings = @()
    try {
        $raw = [System.Text.Encoding]::UTF8.GetString([System.IO.File]::ReadAllBytes($file.FullName)).ToLower()
        foreach ($s in $cheatStrings) { 
            if ($raw -match [regex]::Escape($s.ToLower())) { 
                $hasCheatStrings = $true
                $foundStrings += $s
            } 
        }
    } catch {}
    
    # Check for obfuscation
    $obfuscated = $false
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
        $classCount = 0
        $singleCharClasses = 0
        $numericClasses = 0
        foreach ($entry in ($zip.Entries | Where-Object { $_.FullName -match '\.class$' })) {
            $classCount++
            $cn = [System.IO.Path]::GetFileNameWithoutExtension($entry.Name)
            if ($cn -match '^[a-zA-Z]$') { $singleCharClasses++ }
            if ($cn -match '^\d+$') { $numericClasses++ }
        }
        $zip.Dispose()
        if ($classCount -gt 10 -and (($singleCharClasses/$classCount*100) -gt 40 -or ($numericClasses/$classCount*100) -gt 30)) {
            $obfuscated = $true
        }
    } catch {}

    $entry = [PSCustomObject]@{
        ModName = $md.Name; FileName = $file.Name; Version = $md.VersionNumber
        ExpectedSize = $md.ExpectedSize; ExpectedSizeKB = if($md.ExpectedSize -gt 0){[math]::Round($md.ExpectedSize/1KB,2)} else {0}
        ActualSize = $actualSize; ActualSizeKB = $actualSizeKB
        SizeDiff = ($actualSize - $md.ExpectedSize); SizeDiffKB = [math]::Round(($actualSize - $md.ExpectedSize)/1KB,2)
        DownloadSource = $zone.Source; SourceURL = $zone.URL; IsModrinthDownload = $zone.IsModrinth
        ModrinthUrl = $md.ModrinthUrl; IsVerified = ($md.Name -ne "")
        MatchType = $md.MatchType; ExactMatch = $md.ExactMatch; IsLatestVersion = $md.IsLatestVersion
        LoaderType = $md.LoaderType; PreferredLoader = $loader; FilePath = $file.FullName
        FileSizeKB = $actualSizeKB; JarModId = $jarInfo.ModId; JarName = $jarInfo.Name
        JarVersion = $jarInfo.Version; JarModLoader = $jarInfo.ModLoader
        ZoneId = $zone.URL; FileSize = $actualSize; Hash = $hash
        HasCheatStrings = $hasCheatStrings; FoundCheatStrings = $foundStrings
        IsObfuscated = $obfuscated
    }

    if ($hasCheatStrings) {
        $cheatMods.Add($entry)
    } elseif ($md.Name -and -not $obfuscated) {
        $verifiedMods.Add($entry)
    } elseif ($md.Name -and $obfuscated) {
        $tamperedMods.Add($entry)
    } else {
        $unknownMods.Add($entry)
    }
    $allModsInfo.Add($entry)
}
Write-Host ""

# Second pass for unknowns trying to identify them
for ($i = 0; $i -lt $unknownMods.Count; $i++) {
    $mod = $unknownMods[$i]
    Show-Progress -current ($i+1) -total $unknownMods.Count -message "Second pass identification"
    
    $mr = if ($mod.JarModId) { Fetch-Modrinth-By-ModId $mod.JarModId $mod.JarVersion $mod.PreferredLoader } else { $null }
    if (-not $mr -or -not $mr.Name) { $mr = Fetch-Modrinth-By-Filename $mod.FileName $mod.PreferredLoader }
    if ($mr -and $mr.Name -and $mr.ExpectedSize -gt 0) {
        $mod.ModName = $mr.Name; $mod.ExpectedSize = $mr.ExpectedSize; $mod.ExpectedSizeKB = [math]::Round($mr.ExpectedSize/1KB,2)
        $mod.SizeDiff = $mod.FileSize - $mr.ExpectedSize; $mod.SizeDiffKB = [math]::Round(($mod.FileSize - $mr.ExpectedSize)/1KB,2)
        $mod.ModrinthUrl = $mr.ModrinthUrl; $mod.MatchType = $mr.MatchType; $mod.ExactMatch = $mr.ExactMatch
        $mod.IsLatestVersion = $mr.IsLatestVersion; $mod.LoaderType = $mr.LoaderType; $mod.IsVerified = $true
        $mod.Version = $mr.VersionNumber
        $verifiedMods.Add($mod)
        $null = $unknownMods.RemoveAll([Predicate[object]]{ param($x) $x.FileName -eq $mod.FileName })
    }
}
Write-Host ""

# Disallowed mods check
$disallowedMods = @{
    "xeros-minimap" = @{Names=@("Xero's Minimap","Xeros Minimap","xeros-minimap")}
    "freecam" = @{Names=@("Freecam","freecam","FreeCam")}
    "health-indicators" = @{Names=@("Health Indicators","health indicators")}
    "clickcrystals" = @{Names=@("ClickCrystals","clickcrystals")}
    "mousetweaks" = @{Names=@("Mouse Tweaks","mousetweaks")}
    "itemscroller" = @{Names=@("Item Scroller","itemscroller")}
    "tweakeroo" = @{Names=@("Tweakeroo","tweakeroo")}
}

$disallowedFound = @()
foreach ($file in $jarFiles) {
    $fn = $file.Name.ToLower()
    $ji = Get-Mod-Info-From-Jar $file.FullName
    foreach ($slug in $disallowedMods.Keys) {
        $md2 = $disallowedMods[$slug]; $hit = $false
        foreach ($name in $md2.Names) {
            if ($fn -match [regex]::Escape($name.ToLower())) { $hit=$true; break }
        }
        if (-not $hit -and $ji.ModId -and $ji.ModId.ToLower() -match $slug.ToLower()) { $hit=$true }
        if (-not $hit -and $ji.Name -and $ji.Name.ToLower() -match $slug.ToLower()) { $hit=$true }
        if ($hit) { $disallowedFound += [PSCustomObject]@{ FileName=$file.Name; ModName=$md2.Names[0] }; break }
    }
}

# RESULTS DISPLAY - BEAUTIFUL AND CLEAN
Clear-Host

# Re-display banner
Write-Host @"
${c.purple}                                                                              
${c.purple}    ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
${c.purple}   ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
${c.purple}   ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
${c.purple}   ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌
${c.cyan}   ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░▌       ▐░▌
${c.cyan}   ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
${c.cyan}   ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
${c.green}   ▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
${c.green}   ▐░▌       ▐░▌▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
${c.green}   ▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
${c.green}    ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 
${c.reset}
"@

Write-Host ""
Write-Host "${c.purple}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${c.reset}"
Write-Host "${c.gold}                                   📊 SCAN RESULTS${c.reset}"
Write-Host "${c.purple}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${c.reset}"
Write-Host ""

# STATS BAR
$totalModsCount = $verifiedMods.Count + $unknownMods.Count + $cheatMods.Count + $tamperedMods.Count
Write-Host "${c.cyan}  ╭───────────────────────────────────────────────────────────────────────────────╮${c.reset}"
Write-Host "${c.cyan}  │${c.white}  TOTAL MODS: ${c.green}$totalModsCount ${c.white}| VERIFIED: ${c.green}$($verifiedMods.Count) ${c.white}| UNKNOWN: ${c.yellow}$($unknownMods.Count) ${c.white}| CHEATS: ${c.red}$($cheatMods.Count) ${c.white}| TAMPERED: ${c.orange}$($tamperedMods.Count)${c.reset}"
Write-Host "${c.cyan}  ╰───────────────────────────────────────────────────────────────────────────────╯${c.reset}"
Write-Host ""

# VERIFIED MODS SECTION
if ($verifiedMods.Count -gt 0) {
    Write-Host "${c.green}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
    Write-Host "${c.green}│${c.white}  ✅ VERIFIED MODS (${c.green}$($verifiedMods.Count)${c.white})                                                           ${c.green}│${c.reset}"
    Write-Host "${c.green}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
    foreach ($mod in $verifiedMods | Select-Object -First 15) {
        $sizeColor = if ($mod.SizeDiffKB -eq 0) { "${c.green}" } elseif ($mod.SizeDiffKB -gt 0) { "${c.red}" } else { "${c.orange}" }
        Write-Host "${c.green}│${c.reset}  ${c.green}✓${c.reset} ${c.white}$($mod.ModName)${c.reset}"
        Write-Host "${c.green}│${c.reset}    📦 ${c.gray}$($mod.FileName)${c.reset} ${c.gray}| ${c.cyan}$($mod.ActualSizeKB) KB${c.reset} ${c.gray}| ${c.purple}$($mod.LoaderType)${c.reset}"
        Write-Host "${c.green}│${c.reset}    🔗 ${c.blue}$($mod.ModrinthUrl)${c.reset}"
        Write-Host "${c.green}│${c.reset}"
    }
    if ($verifiedMods.Count -gt 15) {
        Write-Host "${c.green}│${c.reset}  ${c.gray}... and $($verifiedMods.Count - 15) more mods${c.reset}"
        Write-Host "${c.green}│${c.reset}"
    }
    Write-Host "${c.green}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
    Write-Host ""
}

# UNKNOWN MODS SECTION
if ($unknownMods.Count -gt 0) {
    Write-Host "${c.yellow}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
    Write-Host "${c.yellow}│${c.white}  ❓ UNKNOWN MODS (${c.yellow}$($unknownMods.Count)${c.white}) - Couldn't verify against Modrinth                           ${c.yellow}│${c.reset}"
    Write-Host "${c.yellow}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
    foreach ($mod in $unknownMods) {
        Write-Host "${c.yellow}│${c.reset}  ${c.yellow}?${c.reset} ${c.white}$($mod.FileName)${c.reset}"
        Write-Host "${c.yellow}│${c.reset}    💾 ${c.gray}$($mod.ActualSizeKB) KB${c.reset}"
        if ($mod.JarModId) { Write-Host "${c.yellow}│${c.reset}    🆔 Internal ID: ${c.cyan}$($mod.JarModId)${c.reset}" }
        Write-Host "${c.yellow}│${c.reset}"
    }
    Write-Host "${c.yellow}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
    Write-Host ""
}

# TAMPERED MODS SECTION
if ($tamperedMods.Count -gt 0) {
    Write-Host "${c.orange}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
    Write-Host "${c.orange}│${c.white}  ⚠️  TAMPERED MODS (${c.orange}$($tamperedMods.Count)${c.white}) - Size mismatch or obfuscation detected                     ${c.orange}│${c.reset}"
    Write-Host "${c.orange}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
    foreach ($mod in $tamperedMods) {
        $sign = if ($mod.SizeDiffKB -gt 0) {"+"} else {""}
        Write-Host "${c.orange}│${c.reset}  ${c.orange}⚠${c.reset} ${c.white}$($mod.ModName)${c.reset} ${c.gray}($($mod.FileName))${c.reset}"
        Write-Host "${c.orange}│${c.reset}    📏 Expected: ${c.green}$($mod.ExpectedSizeKB) KB${c.reset} | Actual: ${c.red}$($mod.ActualSizeKB) KB${c.reset} | Diff: ${c.red}$sign$($mod.SizeDiffKB) KB${c.reset}"
        Write-Host "${c.orange}│${c.reset}"
    }
    Write-Host "${c.orange}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
    Write-Host ""
}

# CHEAT MODS SECTION
if ($cheatMods.Count -gt 0) {
    Write-Host "${c.red}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
    Write-Host "${c.red}│${c.white}  🚨 CHEAT MODS DETECTED (${c.red}$($cheatMods.Count)${c.white}) - Remove immediately!                                   ${c.red}│${c.reset}"
    Write-Host "${c.red}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
    foreach ($mod in $cheatMods) {
        Write-Host "${c.red}│${c.reset}  ${c.red}💀${c.reset} ${c.white}$($mod.FileName)${c.reset}"
        if ($mod.ModName) { Write-Host "${c.red}│${c.reset}    🔧 Identified as: ${c.purple}$($mod.ModName)${c.reset}" }
        Write-Host "${c.red}│${c.reset}    🔍 Detected strings:"
        foreach ($str in ($mod.FoundCheatStrings | Select-Object -First 5)) {
            Write-Host "${c.red}│${c.reset}      ${c.magenta}• $str${c.reset}"
        }
        if ($mod.FoundCheatStrings.Count -gt 5) {
            Write-Host "${c.red}│${c.reset}      ${c.gray}... and $($mod.FoundCheatStrings.Count - 5) more${c.reset}"
        }
        Write-Host "${c.red}│${c.reset}"
    }
    Write-Host "${c.red}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
    Write-Host ""
}

# DISALLOWED MODS SECTION
if ($disallowedFound.Count -gt 0) {
    Write-Host "${c.red}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
    Write-Host "${c.red}│${c.white}  🚫 DISALLOWED MODS (${c.red}$($disallowedFound.Count)${c.white}) - Not allowed on this server                              ${c.red}│${c.reset}"
    Write-Host "${c.red}├─────────────────────────────────────────────────────────────────────────────────┤${c.reset}"
    foreach ($mod in $disallowedFound) {
        Write-Host "${c.red}│${c.reset}  ${c.red}⛔${c.reset} ${c.white}$($mod.FileName)${c.reset} ${c.gray}→ ${c.yellow}$($mod.ModName)${c.reset}"
        Write-Host "${c.red}│${c.reset}"
    }
    Write-Host "${c.red}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
    Write-Host ""
}

# SUMMARY BOX
Write-Host "${c.purple}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${c.reset}"

if ($cheatMods.Count -eq 0 -and $disallowedFound.Count -eq 0 -and $tamperedMods.Count -eq 0) {
    Write-Host "${c.green}  ✨ ALL CLEAN! Your mods folder looks good! ✨${c.reset}"
} elseif ($cheatMods.Count -gt 0) {
    Write-Host "${c.red}  ⚠️  WARNING: ${c.white}Cheat mods detected! Remove them to play safely.${c.reset}"
} elseif ($disallowedFound.Count -gt 0) {
    Write-Host "${c.red}  ⚠️  WARNING: ${c.white}Disallowed mods detected! Remove them before playing.${c.reset}"
} elseif ($tamperedMods.Count -gt 0) {
    Write-Host "${c.orange}  ⚠️  CAUTION: ${c.white}Tampered mods detected! They may be unsafe.${c.reset}"
}

Write-Host "${c.purple}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${c.reset}"
Write-Host ""

Write-Host "${c.cyan}┌─────────────────────────────────────────────────────────────────────────────────┐${c.reset}"
Write-Host "${c.cyan}│${c.gold}  ✨ Scan complete! Press any key to exit...                                    ${c.cyan}│${c.reset}"
Write-Host "${c.cyan}└─────────────────────────────────────────────────────────────────────────────────┘${c.reset}"
Write-Host ""

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
