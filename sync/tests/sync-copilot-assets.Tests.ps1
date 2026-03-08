# Pester test suite for sync-copilot-assets.ps1.
#
# Each test uses a temporary folder to avoid mutating real repository files.
Describe 'sync-copilot-assets behavior' {
    # Non-happy path: two packs produce the same destination file.
    # Expected: script throws and writes zero files.
    It 'fails fast when two selected packs map to the same target path and writes no files' {
        # Arrange: create isolated fixture folders (fake asset repo + fake target repo).
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $packAFileDir = Join-Path $packsDir 'pack-a\.github\instructions'
            $packBFileDir = Join-Path $packsDir 'pack-b\.github\instructions'

            New-Item -ItemType Directory -Path $packAFileDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packBFileDir -Force | Out-Null

            Set-Content -Path (Join-Path $packAFileDir 'shared.instructions.md') -Value 'A' -NoNewline
            Set-Content -Path (Join-Path $packBFileDir 'shared.instructions.md') -Value 'B' -NoNewline

            # Act: run script and capture thrown error text for assertions.
            $errorMessage = $null

            try {
                & $testScript -TargetRepo $targetRepo -Packs @('pack-a', 'pack-b')
            }
            catch {
                $errorMessage = $_.Exception.Message
            }

            # Assert: collision is reported and no writes occur.
            $errorMessage | Should -Not -BeNullOrEmpty
            $errorMessage | Should -Match 'Detected destination path collisions'
            $errorMessage | Should -Match 'Collision at target'
            $errorMessage | Should -Match 'shared\.instructions\.md'

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Happy path: no collisions, dry-run stays read-only, apply writes files.
    # Also verifies token replacement using {{TOKEN}} format.
    It 'copies non-colliding files, leaves dry-run write-free, and resolves tokens on apply' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $packAFileDir = Join-Path $packsDir 'pack-a\.github\instructions'
            $packBFileDir = Join-Path $packsDir 'pack-b\.github\prompts'

            New-Item -ItemType Directory -Path $packAFileDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packBFileDir -Force | Out-Null

            Set-Content -Path (Join-Path $packAFileDir 'alpha.instructions.md') -Value 'Root={{SERVER_ROOT}}' -NoNewline
            Set-Content -Path (Join-Path $packBFileDir 'beta.prompt.md') -Value 'Prompt file' -NoNewline

            $tokenFilePath = Join-Path $assetRepo 'tokens.json'
            @{
                SERVER_ROOT = 'Source/Server'
            } | ConvertTo-Json | Set-Content -Path $tokenFilePath -NoNewline

            # Act 1 (dry-run): plan only, no file writes.
            & $testScript -TargetRepo $targetRepo -Packs @('pack-a', 'pack-b') -TokenFile $tokenFilePath -DryRun

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0

            # Act 2 (apply): now write files.
            & $testScript -TargetRepo $targetRepo -Packs @('pack-a', 'pack-b') -TokenFile $tokenFilePath

            $targetAlpha = Join-Path $targetRepo '.github\instructions\alpha.instructions.md'
            $targetBeta = Join-Path $targetRepo '.github\prompts\beta.prompt.md'

            # Assert: both files exist and token value is resolved.
            (Test-Path $targetAlpha) | Should -BeTrue
            (Test-Path $targetBeta) | Should -BeTrue
            (Get-Content -Raw -Path $targetAlpha) | Should -Be 'Root=Source/Server'
            (Get-Content -Raw -Path $targetBeta) | Should -Be 'Prompt file'
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Mixed path: some files are unique, but at least one destination collides.
    # Expected: fail-fast prevents all writes (not partial writes).
    It 'fails without writing any files when a mixed set contains collisions and unique files' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $packAInstructions = Join-Path $packsDir 'pack-a\.github\instructions'
            $packAPrompts = Join-Path $packsDir 'pack-a\.github\prompts'
            $packBInstructions = Join-Path $packsDir 'pack-b\.github\instructions'
            $packBPrompts = Join-Path $packsDir 'pack-b\.github\prompts'

            New-Item -ItemType Directory -Path $packAInstructions -Force | Out-Null
            New-Item -ItemType Directory -Path $packAPrompts -Force | Out-Null
            New-Item -ItemType Directory -Path $packBInstructions -Force | Out-Null
            New-Item -ItemType Directory -Path $packBPrompts -Force | Out-Null

            Set-Content -Path (Join-Path $packAInstructions 'shared.instructions.md') -Value 'A-shared' -NoNewline
            Set-Content -Path (Join-Path $packAInstructions 'unique-a.instructions.md') -Value 'A-unique' -NoNewline
            Set-Content -Path (Join-Path $packAPrompts 'only-a.prompt.md') -Value 'A-prompt' -NoNewline

            Set-Content -Path (Join-Path $packBInstructions 'shared.instructions.md') -Value 'B-shared' -NoNewline
            Set-Content -Path (Join-Path $packBInstructions 'unique-b.instructions.md') -Value 'B-unique' -NoNewline
            Set-Content -Path (Join-Path $packBPrompts 'only-b.prompt.md') -Value 'B-prompt' -NoNewline

            # Act + Assert: throw on collision, then verify write count stays zero.
            { & $testScript -TargetRepo $targetRepo -Packs @('pack-a', 'pack-b') } | Should -Throw

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Windows-specific behavior: path comparisons are case-insensitive.
    # Expected: Case.instructions.md and case.instructions.md collide.
    It 'treats destination collisions as case-insensitive on Windows-style paths and writes no files' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $packAFileDir = Join-Path $packsDir 'pack-a\.github\instructions'
            $packBFileDir = Join-Path $packsDir 'pack-b\.github\instructions'

            New-Item -ItemType Directory -Path $packAFileDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packBFileDir -Force | Out-Null

            Set-Content -Path (Join-Path $packAFileDir 'Case.instructions.md') -Value 'A' -NoNewline
            Set-Content -Path (Join-Path $packBFileDir 'case.instructions.md') -Value 'B' -NoNewline

            $errorMessage = $null

            try {
                & $testScript -TargetRepo $targetRepo -Packs @('pack-a', 'pack-b')
            }
            catch {
                $errorMessage = $_.Exception.Message
            }

            # Assert: collision references case-variant filename and no writes occurred.
            $errorMessage | Should -Not -BeNullOrEmpty
            $errorMessage | Should -Match 'Detected destination path collisions'
            $errorMessage | Should -Match '[Cc]ase\.instructions\.md'

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Input validation: target repo path must already exist.
    It 'fails when target repo does not exist' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $packAFileDir = Join-Path $packsDir 'pack-a\.github\instructions'
            New-Item -ItemType Directory -Path $packAFileDir -Force | Out-Null
            Set-Content -Path (Join-Path $packAFileDir 'alpha.instructions.md') -Value 'alpha' -NoNewline

            $missingTarget = Join-Path $tempRoot 'missing-target-repo'

            # Assert: throws a clear path validation error.
            { & $testScript -TargetRepo $missingTarget -Packs @('pack-a') } | Should -Throw -ExpectedMessage '*TargetRepo does not exist*'
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Input validation: token file path must exist when -TokenFile is used.
    It 'fails when token file does not exist' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $packAFileDir = Join-Path $packsDir 'pack-a\.github\instructions'
            New-Item -ItemType Directory -Path $packAFileDir -Force | Out-Null
            Set-Content -Path (Join-Path $packAFileDir 'alpha.instructions.md') -Value 'alpha' -NoNewline

            $missingTokenFile = Join-Path $tempRoot 'missing.tokens.json'

            # Assert: throws a clear missing-token-file error.
            { & $testScript -TargetRepo $targetRepo -Packs @('pack-a') -TokenFile $missingTokenFile } | Should -Throw -ExpectedMessage '*Token file not found*'
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Input validation: every selected pack name must exist under /packs.
    It 'fails when a selected pack does not exist' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $existingPackDir = Join-Path $packsDir 'pack-a\.github\instructions'
            New-Item -ItemType Directory -Path $existingPackDir -Force | Out-Null
            Set-Content -Path (Join-Path $existingPackDir 'alpha.instructions.md') -Value 'alpha' -NoNewline

            # Act + Assert: requesting an unknown pack should fail immediately.
            { & $testScript -TargetRepo $targetRepo -Packs @('missing-pack') } | Should -Throw -ExpectedMessage "*Pack 'missing-pack' not found*"

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Input validation: named profile must exist in profile config.
    It 'fails when asset profile does not exist' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $profilesPath = Join-Path $syncDir 'pack-profiles.json'
            @{
                profiles = @{
                    known = @('pack-a')
                }
            } | ConvertTo-Json -Depth 5 | Set-Content -Path $profilesPath -NoNewline

            # Act + Assert: unknown profile fails with clear error.
            { & $testScript -TargetRepo $targetRepo -AssetProfile missing-profile -ProfilesPath $profilesPath } | Should -Throw -ExpectedMessage "*Profile 'missing-profile' not found*"

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }

    # Input validation: at least one pack source must be selected.
    # This test launches pwsh as a child process to verify process exit code and stderr text.
    It 'fails with a terminating error when no packs or profile are selected' {
        $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-assets-test-{0}" -f ([System.Guid]::NewGuid().ToString('N')))
        $assetRepo = Join-Path $tempRoot 'asset-repo'
        $syncDir = Join-Path $assetRepo 'sync'
        $packsDir = Join-Path $assetRepo 'packs'
        $targetRepo = Join-Path $tempRoot 'target-repo'

        try {
            New-Item -ItemType Directory -Path $syncDir -Force | Out-Null
            New-Item -ItemType Directory -Path $packsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $targetRepo -Force | Out-Null

            $sourceScript = Join-Path $PSScriptRoot '..\sync-copilot-assets.ps1'
            $testScript = Join-Path $syncDir 'sync-copilot-assets.ps1'
            Copy-Item -Path $sourceScript -Destination $testScript -Force

            $stdoutPath = Join-Path $tempRoot 'stdout.txt'
            $stderrPath = Join-Path $tempRoot 'stderr.txt'

            $argumentList = @(
                '-NoProfile'
                '-ExecutionPolicy', 'Bypass'
                '-File', $testScript
                '-TargetRepo', $targetRepo
            )

            $process = Start-Process -FilePath 'pwsh' -ArgumentList $argumentList -NoNewWindow -Wait -PassThru -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath

            $stderr = if (Test-Path $stderrPath) { Get-Content -Raw -Path $stderrPath } else { '' }

            # Assert: process fails and includes the selection error message.
            $process.ExitCode | Should -Be 1
            $stderr | Should -Match 'No packs selected'

            (Get-ChildItem -Path $targetRepo -Recurse -File | Measure-Object).Count | Should -Be 0
        }
        finally {
            if (Test-Path $tempRoot) {
                Remove-Item -Path $tempRoot -Recurse -Force
            }
        }
    }
}