Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$exampleDirs = @("office", "timer", "intersection", "drone")
$requiredRootFiles = @(
    "README.md",
    "CONTRIBUTING.md",
    "LICENSE",
    "CODE_OF_CONDUCT.md",
    "SECURITY.md",
    ".editorconfig"
)

function Assert-Exists {
    param(
        [string]$Path,
        [string]$Message
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw $Message
    }
}

foreach ($file in $requiredRootFiles) {
    Assert-Exists (Join-Path $root $file) "Missing required root file: $file"
}

foreach ($dir in $exampleDirs) {
    $fullDir = Join-Path $root $dir
    Assert-Exists $fullDir "Missing example directory: $dir"

    $readme = Join-Path $fullDir "README.md"
    Assert-Exists $readme "Missing README for example: $dir"

    $sysmlFiles = @(Get-ChildItem -LiteralPath $fullDir -Filter *.sysml -File)
    if ($sysmlFiles.Count -ne 1) {
        throw "Expected exactly one .sysml file in $dir, found $($sysmlFiles.Count)"
    }
}

$markdownFiles = Get-ChildItem -Path $root -Recurse -Include *.md -File
foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $matches = [regex]::Matches($content, '\[[^\]]+\]\((?!https?://|mailto:|#)([^)]+)\)')
    foreach ($match in $matches) {
        $relativeTarget = $match.Groups[1].Value
        if ([string]::IsNullOrWhiteSpace($relativeTarget)) {
            continue
        }

        $resolved = Join-Path $file.DirectoryName $relativeTarget
        if (-not (Test-Path -LiteralPath $resolved)) {
            throw "Broken relative link '$relativeTarget' in $($file.FullName)"
        }
    }
}

Write-Host "Repository layout and Markdown link checks passed."
