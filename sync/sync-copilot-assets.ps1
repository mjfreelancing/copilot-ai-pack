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

$resolvedTargetRoot = (Resolve-Path $TargetRepo).Path.TrimEnd('\\')

if (-not (Test-Path $packsRoot)) {
    throw "Packs directory not found: $packsRoot"
}

function Convert-PathToPosix {
    param(
        [string]$PathValue
    )

    return $PathValue.Replace('\', '/')
}

function Convert-GlobToRegex {
    param(
        [string]$Pattern
    )

    if ([string]::IsNullOrWhiteSpace($Pattern)) {
        throw 'Manifest contains an empty include/exclude pattern.'
    }

    $normalizedPattern = (Convert-PathToPosix -PathValue $Pattern).Trim()
    $builder = New-Object System.Text.StringBuilder
    [void]$builder.Append('^')

    for ($index = 0; $index -lt $normalizedPattern.Length; $index++) {
        $char = $normalizedPattern[$index]

        if ($char -eq '*') {
            $isDoubleStar = $index + 1 -lt $normalizedPattern.Length -and $normalizedPattern[$index + 1] -eq '*'

            if ($isDoubleStar) {
                [void]$builder.Append('.*')
                $index++
            }
            else {
                [void]$builder.Append('[^/]*')
            }

            continue
        }

        if ($char -eq '?') {
            [void]$builder.Append('[^/]')
            continue
        }

        if ($char -eq '/') {
            [void]$builder.Append('/')
            continue
        }

        [void]$builder.Append([System.Text.RegularExpressions.Regex]::Escape([string]$char))
    }

    [void]$builder.Append('$')

    return $builder.ToString()
}

function Get-IncludedFiles {
    param(
        [string]$SourcePath,
        [string]$ManifestPath,
        [string]$PackName
    )

    if (-not (Test-Path $SourcePath)) {
        return @()
    }

    if (-not (Test-Path $ManifestPath)) {
        throw "Manifest file not found for pack '$PackName': $ManifestPath"
    }

    $manifest = Get-Content -Raw -Path $ManifestPath | ConvertFrom-Json -AsHashtable

    if (-not $manifest.ContainsKey('include')) {
        throw "Manifest for pack '$PackName' must define an 'include' array: $ManifestPath"
    }

    $includePatterns = @(@($manifest.include) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })

    if ($includePatterns.Count -eq 0) {
        throw "Manifest for pack '$PackName' has no include patterns: $ManifestPath"
    }

    $excludePatterns = @()

    if ($manifest.ContainsKey('exclude')) {
        $excludePatterns = @(@($manifest.exclude) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
    }

    $includeRegexes = @($includePatterns | ForEach-Object { Convert-GlobToRegex -Pattern ([string]$_) })
    $excludeRegexes = @($excludePatterns | ForEach-Object { Convert-GlobToRegex -Pattern ([string]$_) })

    $allFiles = Get-ChildItem -Path $SourcePath -Recurse -File | Sort-Object -Property FullName -Unique
    $resolvedRoot = (Resolve-Path $SourcePath).Path.TrimEnd('\\')
    $selectedFiles = New-Object System.Collections.Generic.List[object]

    foreach ($file in $allFiles) {
        $relativePath = $file.FullName.Substring($resolvedRoot.Length).TrimStart('\\')
        $relativePosixPath = Convert-PathToPosix -PathValue $relativePath

        $isIncluded = $false

        foreach ($includeRegex in $includeRegexes) {
            if ($relativePosixPath -match $includeRegex) {
                $isIncluded = $true
                break
            }
        }

        if (-not $isIncluded) {
            continue
        }

        $isExcluded = $false

        foreach ($excludeRegex in $excludeRegexes) {
            if ($relativePosixPath -match $excludeRegex) {
                $isExcluded = $true
                break
            }
        }

        if (-not $isExcluded) {
            $selectedFiles.Add($file) | Out-Null
        }
    }

    return $selectedFiles
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
        $token = '{{' + $entry.Key + '}}'
        $value = [string]$entry.Value
        $resolved = $resolved.Replace($token, $value)
    }

    return $resolved
}

function Get-RelativeTargetPath {
    param(
        [string]$FullTargetPath,
        [string]$ResolvedTargetRoot
    )

    $prefix = $ResolvedTargetRoot + '\\'

    if ($FullTargetPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $FullTargetPath.Substring($prefix.Length)
    }

    return $FullTargetPath
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
    $errorLines = New-Object System.Collections.Generic.List[string]
    $errorLines.Add('No packs selected.') | Out-Null
    $errorLines.Add("Available packs: $($availablePacks -join ', ')") | Out-Null

    if ($profileMap.Count -gt 0) {
        $errorLines.Add("Available profiles: $($profileMap.Keys -join ', ')") | Out-Null
    }

    throw ($errorLines -join [Environment]::NewLine)
}

foreach ($packName in $selectedPacks) {
    if (-not $availablePacks.Contains($packName)) {
        throw "Pack '$packName' not found. Available packs: $($availablePacks -join ', ')"
    }
}

$syncPlan = New-Object System.Collections.Generic.List[object]
$plannedByTarget = @{}
$collisionMap = @{}

foreach ($packName in $selectedPacks) {
    $packRoot = Join-Path $packsRoot $packName
    $manifestPath = Join-Path $packRoot 'pack.manifest.json'
    $files = Get-IncludedFiles -SourcePath $packRoot -ManifestPath $manifestPath -PackName $packName
    $resolvedPackRoot = (Resolve-Path $packRoot).Path.TrimEnd('\\')

    foreach ($file in $files) {
        $relativePath = $file.FullName.Substring($resolvedPackRoot.Length).TrimStart('\\')
        $destination = Join-Path $TargetRepo $relativePath
        $isTextFile = $file.Extension -in @('.md', '.txt', '.json', '.yml', '.yaml', '.ps1')
        $targetKey = $destination.ToLowerInvariant()

        $planEntry = [PSCustomObject]@{
            Pack = $packName
            Source = $file.FullName
            Target = $destination
            IsTextFile = $isTextFile
        }

        $syncPlan.Add($planEntry) | Out-Null

        if ($plannedByTarget.ContainsKey($targetKey)) {
            if (-not $collisionMap.ContainsKey($targetKey)) {
                $collisionEntries = New-Object System.Collections.Generic.List[object]
                $collisionEntries.Add($plannedByTarget[$targetKey]) | Out-Null
                $collisionMap[$targetKey] = $collisionEntries
            }

            $collisionMap[$targetKey].Add($planEntry) | Out-Null
        }
        else {
            $plannedByTarget[$targetKey] = $planEntry
        }
    }
}

$collisionCount = $collisionMap.Count

if ($collisionCount -gt 0) {
    $maxCollisionsToShow = 20
    $collisionMessages = New-Object System.Collections.Generic.List[string]

    foreach ($collisionKey in ($collisionMap.Keys | Sort-Object)) {
        $entries = $collisionMap[$collisionKey]
        $targetRelative = Get-RelativeTargetPath -FullTargetPath $entries[0].Target -ResolvedTargetRoot $resolvedTargetRoot
        $sources = $entries | Select-Object -ExpandProperty Source | Sort-Object -Unique
        $sourceLines = ($sources | ForEach-Object { "    - $_" }) -join [Environment]::NewLine
        $collisionMessages.Add("Collision at target '$targetRelative':$([Environment]::NewLine)$sourceLines") | Out-Null

        if ($collisionMessages.Count -ge $maxCollisionsToShow) {
            break
        }
    }

    $additionalMessage = ''

    if ($collisionCount -gt $maxCollisionsToShow) {
        $remainingCount = $collisionCount - $maxCollisionsToShow
        $additionalMessage = "`n`n...and $remainingCount additional collision(s)."
    }

    throw "Detected destination path collisions across selected packs. No files were written.`n`n$($collisionMessages -join "`n`n")$additionalMessage"
}

$changes = New-Object System.Collections.Generic.List[object]

foreach ($entry in $syncPlan) {
    if ($DryRun) {
        $changes.Add([PSCustomObject]@{
            Mode = 'DRYRUN'
            Pack = $entry.Pack
            Source = $entry.Source
            Target = $entry.Target
        }) | Out-Null
        continue
    }

    $destinationDir = Split-Path -Parent $entry.Target

    if (-not (Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }

    if ($entry.IsTextFile -and $tokenMap.Count -gt 0) {
        $content = Get-Content -Raw -Path $entry.Source
        $resolved = Resolve-Tokens -Text $content -Tokens $tokenMap
        Set-Content -Path $entry.Target -Value $resolved -NoNewline
    }
    else {
        Copy-Item -Path $entry.Source -Destination $entry.Target -Force
    }

    $changes.Add([PSCustomObject]@{
        Mode = 'APPLY'
        Pack = $entry.Pack
        Source = $entry.Source
        Target = $entry.Target
    }) | Out-Null
}

if ($changes.Count -eq 0) {
    Write-Host 'No files selected for sync.'
    exit 0
}

$changes | Select-Object Mode, Pack, @{Name='Target'; Expression={ Get-RelativeTargetPath -FullTargetPath $_.Target -ResolvedTargetRoot $resolvedTargetRoot }} |
    Format-Table -AutoSize

Write-Host "Processed $($changes.Count) file(s)."
