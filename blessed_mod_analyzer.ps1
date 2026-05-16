[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

$cyan = "`e[36m"
$green = "`e[32m"
$red = "`e[31m"
$yellow = "`e[33m"
$white = "`e[37m"
$gray = "`e[90m"
$reset = "`e[0m"

Write-Host @"
$cyan
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
$reset
"@

Write-Host "$gray                          made by Blessed | discord: 8j0w$reset`n"

# get mods folder
Write-Host "$cyan[?] enter mods folder path (press enter for default):$reset"
$mods = Read-Host "  path"

if (-not $mods) {
    $mods = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
}
if (-not (Test-Path $mods)) {
    Write-Host "$red[!] folder not found$reset"
    Start-Sleep -Seconds 2
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$jarFiles = Get-ChildItem -Path $mods -Filter *.jar
$total = $jarFiles.Count

Write-Host "$green[$cyan+$green] found $total mod files$reset`n"

# detect minecraft version
Write-Host "$cyan[+] detecting minecraft version...$reset"

$versions = @{}
foreach ($file in $jarFiles) {
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
        $fmj = $zip.Entries | Where-Object { $_.Name -eq 'fabric.mod.json' } | Select-Object -First 1
        if ($fmj) {
            $reader = New-Object System.IO.StreamReader($fmj.Open())
            $json = $reader.ReadToEnd() | ConvertFrom-Json
            $reader.Close()
            if ($json.depends.minecraft) {
                $ver = $json.depends.minecraft -replace '[^0-9.]', ''
                if ($ver -match '\d+\.\d+(\.\d+)?') {
                    $versions[$ver]++
                }
            }
        }
        $zip.Dispose()
    } catch {}
}

$mcVer = $null
if ($versions.Count -gt 0) {
    $mcVer = ($versions.GetEnumerator() | Sort-Object Value -Descending)[0].Key
    Write-Host "$green[+] detected: $mcVer$reset`n"
} else {
    Write-Host "$yellow[!] could not detect, enter manually:$reset"
    $mcVer = Read-Host "  version"
    Write-Host ""
}

# functions
function Get-Hash($f) { (Get-FileHash $f -Algorithm SHA1).Hash }

function Get-Modrinth($hash) {
    try {
        $resp = Invoke-RestMethod "https://api.modrinth.com/v2/version_file/$hash" -UseBasicParsing
        if ($resp.project_id) {
            $proj = Invoke-RestMethod "https://api.modrinth.com/v2/project/$($resp.project_id)" -UseBasicParsing
            return @{
                name = $proj.title
                url = "https://modrinth.com/mod/$($proj.slug)"
                size = $resp.files[0].size
                version = $resp.version_number
            }
        }
    } catch {}
    return $null
}

function Get-JarInfo($f) {
    $info = @{ id = ""; name = ""; ver = ""; loader = "" }
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($f)
        $entry = $zip.Entries | Where-Object { $_.Name -eq 'fabric.mod.json' } | Select-Object -First 1
        if ($entry) {
            $reader = New-Object System.IO.StreamReader($entry.Open())
            $json = $reader.ReadToEnd() | ConvertFrom-Json
            $reader.Close()
            $info.id = $json.id
            $info.name = $json.name
            $info.ver = $json.version
            $info.loader = "Fabric"
        } else {
            $entry = $zip.Entries | Where-Object { $_.FullName -eq 'META-INF/mods.toml' } | Select-Object -First 1
            if ($entry) {
                $reader = New-Object System.IO.StreamReader($entry.Open())
                $toml = $reader.ReadToEnd()
                $reader.Close()
                if ($toml -match 'modId\s*=\s*"([^"]+)"') { $info.id = $matches[1] }
                if ($toml -match 'displayName\s*=\s*"([^"]+)"') { $info.name = $matches[1] }
                if ($toml -match 'version\s*=\s*"([^"]+)"') { $info.ver = $matches[1] }
                $info.loader = "Forge"
            }
        }
        $zip.Dispose()
    } catch {}
    return $info
}

# cheat strings
$cheatPatterns = @(
    "autocrystal", "autototem", "autoanchor", "autopot", "autoarmor",
    "aimassist", "triggerbot", "fakelag", "pingspoof", "freecam",
    "killaura", "speedmine", "scaffold", "flyhack", "nofall",
    "dqrkis", "CwskKkUfHQYB"
)

# scan each mod
$verified = @()
$unknown = @()
$cheats = @()
$tampered = @()

Write-Host "$cyan[+] scanning mods...$reset`n"

for ($i = 0; $i -lt $total; $i++) {
    $file = $jarFiles[$i]
    Write-Host "  [$($i+1)/$total] $($file.Name)" -NoNewline
    
    $hash = Get-Hash $file.FullName
    $size = [math]::Round($file.Length / 1KB, 2)
    $modrinth = Get-Modrinth $hash
    $jarInfo = Get-JarInfo $file.FullName
    
    # check for cheats
    $isCheat = $false
    $found = @()
    try {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $text = [System.Text.Encoding]::UTF8.GetString($bytes).ToLower()
        foreach ($pattern in $cheatPatterns) {
            if ($text -match $pattern) {
                $isCheat = $true
                $found += $pattern
            }
        }
    } catch {}
    
    # check obfuscation
    $obfuscated = $false
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
        $classes = @()
        foreach ($entry in $zip.Entries | Where-Object { $_.FullName -match '\.class$' }) {
            $classes += [System.IO.Path]::GetFileNameWithoutExtension($entry.Name)
        }
        $zip.Dispose()
        $single = ($classes | Where-Object { $_.Length -eq 1 }).Count
        if ($classes.Count -gt 20 -and ($single / $classes.Count) -gt 0.4) {
            $obfuscated = $true
        }
    } catch {}
    
    $mod = @{
        file = $file.Name
        size = $size
        loader = $jarInfo.loader
        name = $modrinth.name
        url = $modrinth.url
        expected = if ($modrinth.size) { [math]::Round($modrinth.size / 1KB, 2) } else { 0 }
        internalId = $jarInfo.id
        internalName = $jarInfo.name
        isCheat = $isCheat
        cheatStrings = $found
        obfuscated = $obfuscated
    }
    
    if ($isCheat) {
        $cheats += $mod
        Write-Host " $red[!] CHEAT DETECTED$reset"
    } elseif ($modrinth.name) {
        if ($obfuscated) {
            $tampered += $mod
            Write-Host " $yellow[!] TAMPERED$reset"
        } else {
            $verified += $mod
            Write-Host " $green[✓]$reset"
        }
    } else {
        $unknown += $mod
        Write-Host " $yellow[?]$reset"
    }
}

Write-Host "`n$green[+] scan complete$reset`n"

# show results
Write-Host "$cyan════════════════════════════════════════════════════════════════════$reset"
Write-Host "$white  SUMMARY$reset"
Write-Host "$cyan════════════════════════════════════════════════════════════════════$reset"
Write-Host ""
Write-Host "  total: $total"
Write-Host "  $green✓ verified:$reset $($verified.Count)"
Write-Host "  $yellow? unknown:$reset $($unknown.Count)"
Write-Host "  $red💀 cheats:$reset $($cheats.Count)"
Write-Host "  $orange⚠ tampered:$reset $($tampered.Count)"
Write-Host ""

# verified mods
if ($verified.Count -gt 0) {
    Write-Host "$green──────────────────────────────────────────────────────────────────$reset"
    Write-Host "$green✓ VERIFIED MODS ($($verified.Count))$reset"
    Write-Host "$green──────────────────────────────────────────────────────────────────$reset"
    foreach ($mod in $verified | Select-Object -First 15) {
        Write-Host ""
        Write-Host "  $($mod.name)"
        Write-Host "    file: $($mod.file)"
        Write-Host "    size: $($mod.size) KB | loader: $($mod.loader)"
        if ($mod.url) { Write-Host "    link: $($mod.url)" }
    }
    if ($verified.Count -gt 15) {
        Write-Host "`n    ... and $($verified.Count - 15) more"
    }
    Write-Host ""
}

# unknown mods
if ($unknown.Count -gt 0) {
    Write-Host "$yellow──────────────────────────────────────────────────────────────────$reset"
    Write-Host "$yellow? UNKNOWN MODS ($($unknown.Count))$reset"
    Write-Host "$yellow──────────────────────────────────────────────────────────────────$reset"
    foreach ($mod in $unknown) {
        Write-Host ""
        Write-Host "  $($mod.file)"
        Write-Host "    size: $($mod.size) KB | loader: $($mod.loader)"
        if ($mod.internalId) { Write-Host "    internal id: $($mod.internalId)" }
    }
    Write-Host ""
}

# tampered mods
if ($tampered.Count -gt 0) {
    Write-Host "$yellow──────────────────────────────────────────────────────────────────$reset"
    Write-Host "$yellow⚠ TAMPERED MODS ($($tampered.Count))$reset"
    Write-Host "$yellow──────────────────────────────────────────────────────────────────$reset"
    foreach ($mod in $tampered) {
        $diff = $mod.size - $mod.expected
        $sign = if ($diff -gt 0) { "+" } else { "" }
        Write-Host ""
        Write-Host "  $($mod.name)"
        Write-Host "    file: $($mod.file)"
        Write-Host "    expected: $($mod.expected) KB | actual: $($mod.size) KB | diff: $sign$diff KB"
    }
    Write-Host ""
}

# cheat mods
if ($cheats.Count -gt 0) {
    Write-Host "$red──────────────────────────────────────────────────────────────────$reset"
    Write-Host "$red💀 CHEAT MODS DETECTED ($($cheats.Count))$reset"
    Write-Host "$red──────────────────────────────────────────────────────────────────$reset"
    foreach ($mod in $cheats) {
        Write-Host ""
        Write-Host "  $($mod.file)"
        if ($mod.name) { Write-Host "    identified as: $($mod.name)" }
        Write-Host "    detected strings:"
        foreach ($str in ($mod.cheatStrings | Select-Object -First 5)) {
            Write-Host "      - $str"
        }
        if ($mod.cheatStrings.Count -gt 5) {
            Write-Host "      ... and $($mod.cheatStrings.Count - 5) more"
        }
    }
    Write-Host ""
}

# final
Write-Host "$cyan════════════════════════════════════════════════════════════════════$reset"
if ($cheats.Count -eq 0) {
    Write-Host "$green[✓] no cheats found$reset"
} else {
    Write-Host "$red[!] remove cheat mods before playing$reset"
}
Write-Host "$cyan════════════════════════════════════════════════════════════════════$reset"

Write-Host "`n$gray press any key to exit$reset"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
