[CmdletBinding()]
param(
    [switch]$TrustPSGallery
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-PrereqStatus {
    $psVersion = $PSVersionTable.PSVersion
    $nugetProvider = Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending |
        Select-Object -First 1
    $pesterModules = Get-Module -ListAvailable -Name Pester |
        Sort-Object Version -Descending
    $latestPester = $pesterModules | Select-Object -First 1

    return [pscustomobject]@{
        PowerShellVersion      = $psVersion
        IsPwsh7OrHigher        = $psVersion.Major -ge 7
        NuGetProvider          = $nugetProvider
        LatestPester           = $latestPester
        HasPester5OrHigher     = ($null -ne $latestPester -and $latestPester.Version.Major -ge 5)
    }
}

$installedAnything = $false

$status = Get-PrereqStatus

if (-not $status.IsPwsh7OrHigher) {
    Write-Warning 'PowerShell 7+ (pwsh) is recommended. Current session is below 7.'
} else {
    Write-Host ("PowerShell version is compatible: {0}" -f $status.PowerShellVersion)
}

if ($null -eq $status.NuGetProvider) {
    Write-Host 'Installing NuGet package provider...'
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser | Out-Null
    $installedAnything = $true
} else {
    Write-Host ("NuGet provider already available: {0}" -f $status.NuGetProvider.Version)
}

if ($TrustPSGallery) {
    Write-Host 'Setting PSGallery installation policy to Trusted...'
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

if (-not $status.HasPester5OrHigher) {
    Write-Host 'Installing Pester 5+ for current user...'
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        $installedAnything = $true
    } catch {
        throw "Failed to install Pester. If prompted trust behavior blocked installation, rerun with -TrustPSGallery. Original error: $($_.Exception.Message)"
    }
} else {
    Write-Host ("Pester 5+ already available: {0}" -f $status.LatestPester.Version)
}

if (-not $installedAnything) {
    Write-Host 'No prerequisite installation needed. All required components are already available.'
}

Write-Host ''
Write-Host 'Verifying current prerequisite state...'
$status = Get-PrereqStatus

$verification = [pscustomobject]@{
    PowerShellVersion      = $status.PowerShellVersion.ToString()
    IsPwsh7OrHigher        = $status.IsPwsh7OrHigher
    NuGetProviderAvailable = ($null -ne $status.NuGetProvider)
    NuGetProviderVersion   = if ($null -ne $status.NuGetProvider) { $status.NuGetProvider.Version.ToString() } else { $null }
    LatestPesterVersion    = if ($null -ne $status.LatestPester) { $status.LatestPester.Version.ToString() } else { $null }
    HasPester5OrHigher     = $status.HasPester5OrHigher
}

$verification | Format-List | Out-Host

$missing = @()
if (-not $status.IsPwsh7OrHigher) { $missing += 'PowerShell 7+' }
if ($null -eq $status.NuGetProvider) { $missing += 'NuGet provider' }
if (-not $status.HasPester5OrHigher) { $missing += 'Pester 5+' }

if ($missing.Count -gt 0) {
    throw ("Missing prerequisites after ensure attempt: {0}" -f ($missing -join ', '))
}

Write-Host 'Prerequisite check: OK'
