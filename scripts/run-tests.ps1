[CmdletBinding()]
param(
    [string]$Path = '.\\sync\\tests'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module Pester -MinimumVersion 5.0.0 -Force
$result = Invoke-Pester -Path $Path -PassThru

if ($result.FailedCount -gt 0 -or $result.Result -ne 'Passed') {
    exit 1
}

exit 0
