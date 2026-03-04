[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [string[]]$Packs,

    [string]$AssetProfile,

    [string]$ProfilesPath = "sync/pack-profiles.json",

    [string]$TokenFile,

    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$assetRoot = Resolve-Path (Join-Path $scriptRoot '..')
$packsRoot = Join-Path $assetRoot 'packs'

if (-not (Test-Path $TargetRepo)) {
    throw "TargetRepo does not exist: $TargetRepo"
}

if (-not (Test-Path $packsRoot)) {
    throw "Packs directory not found: $packsRoot"
}

function Get-IncludedFiles {
    param(
        [string]$SourcePath
    )

    if (-not (Test-Path $SourcePath)) {
        return @()
    }

    return Get-ChildItem -Path $SourcePath -Recurse -File | Sort-Object -Property FullName -Unique
}

function Resolve-Tokens {
    param(
        [string]$Text,
        [hashtable]$Tokens
    )

    if (-not $Tokens -or $Tokens.Count -eq 0) {
        return $Text
    }

    $resolved = $Text

    foreach ($entry in $Tokens.GetEnumerator()) {
        $token = "{{{0}}}" -f $entry.Key
        $value = [string]$entry.Value
        $resolved = $resolved.Replace($token, $value)
    }

    return $resolved
}

$profileMap = @{}

$profilesFullPath = if ([System.IO.Path]::IsPathRooted($ProfilesPath)) {
    $ProfilesPath
}
else {
    Join-Path $assetRoot $ProfilesPath
}

if (Test-Path $profilesFullPath) {
    $profilesJson = Get-Content -Raw -Path $profilesFullPath | ConvertFrom-Json -AsHashtable
    if ($profilesJson.ContainsKey('profiles')) {
        $profileMap = $profilesJson.profiles
    }
}

$tokenMap = @{}

if ($TokenFile) {
    $tokenFullPath = if ([System.IO.Path]::IsPathRooted($TokenFile)) {
        $TokenFile
    }
    else {
        Join-Path $assetRoot $TokenFile
    }

    if (-not (Test-Path $tokenFullPath)) {
        throw "Token file not found: $tokenFullPath"
    }

    $json = Get-Content -Raw -Path $tokenFullPath | ConvertFrom-Json -AsHashtable

    foreach ($key in $json.Keys) {
        $tokenMap[$key] = [string]$json[$key]
    }
}

$availablePacks = Get-ChildItem -Path $packsRoot -Directory | Select-Object -ExpandProperty Name | Sort-Object
$selectedPacks = New-Object System.Collections.Generic.List[string]

if ($AssetProfile) {
    if (-not $profileMap.ContainsKey($AssetProfile)) {
        throw "Profile '$AssetProfile' not found in $profilesFullPath"
    }

    foreach ($packName in $profileMap[$AssetProfile]) {
        if (-not [string]::IsNullOrWhiteSpace([string]$packName) -and -not $selectedPacks.Contains([string]$packName)) {
            $selectedPacks.Add([string]$packName)
        }
    }
}

if ($Packs) {
    foreach ($packName in $Packs) {
        if (-not [string]::IsNullOrWhiteSpace($packName) -and -not $selectedPacks.Contains($packName)) {
            $selectedPacks.Add($packName)
        }
    }
}

if ($selectedPacks.Count -eq 0) {
    Write-Host "No packs selected."
    Write-Host "Available packs: $($availablePacks -join ', ')"
    if ($profileMap.Count -gt 0) {
        Write-Host "Available profiles: $($profileMap.Keys -join ', ')"
    }
    exit 1
}

foreach ($packName in $selectedPacks) {
    if (-not $availablePacks.Contains($packName)) {
        throw "Pack '$packName' not found. Available packs: $($availablePacks -join ', ')"
    }
}

$changes = New-Object System.Collections.Generic.List[object]

foreach ($packName in $selectedPacks) {
    $packRoot = Join-Path $packsRoot $packName
    $files = Get-IncludedFiles -SourcePath $packRoot
    $resolvedPackRoot = (Resolve-Path $packRoot).Path.TrimEnd('\\')

    foreach ($file in $files) {
        $relativePath = $file.FullName.Substring($resolvedPackRoot.Length).TrimStart('\\')
        $destination = Join-Path $TargetRepo $relativePath
        $destinationDir = Split-Path -Parent $destination

        $isTextFile = $file.Extension -in @('.md', '.txt', '.json', '.yml', '.yaml', '.ps1')

        if ($DryRun) {
            $changes.Add([PSCustomObject]@{
                Mode = 'DRYRUN'
                Pack = $packName
                Source = $file.FullName
                Target = $destination
            }) | Out-Null
            continue
        }

        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }

        if ($isTextFile -and $tokenMap.Count -gt 0) {
            $content = Get-Content -Raw -Path $file.FullName
            $resolved = Resolve-Tokens -Text $content -Tokens $tokenMap
            Set-Content -Path $destination -Value $resolved -NoNewline
        }
        else {
            Copy-Item -Path $file.FullName -Destination $destination -Force
        }

        $changes.Add([PSCustomObject]@{
            Mode = 'APPLY'
            Pack = $packName
            Source = $file.FullName
            Target = $destination
        }) | Out-Null
    }
}

if ($changes.Count -eq 0) {
    Write-Host 'No files matched the manifest.'
    exit 0
}

$changes | Select-Object Mode, Pack, @{Name='Target'; Expression={ $_.Target.Replace((Resolve-Path $TargetRepo).Path.TrimEnd('\\') + '\\','') }} |
    Format-Table -AutoSize

Write-Host "Processed $($changes.Count) file(s)."
