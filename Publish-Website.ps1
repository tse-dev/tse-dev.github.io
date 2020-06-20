# The following single-line comment enforces use of PowerShell Core.
#requires -PSEdition Core

$currentBranch = [string] (& git rev-parse --abbrev-ref HEAD)

if ($currentBranch -ne 'develop') {
    Write-Host 'Error: Must be on develop branch.';
    exit;
}

# if (-Not (Test-Path -Path 'public')) {
#     Write-Host -ForegroundColor Red "Error: The folder 'public' does not exist. Have you built the website using the 'npm run build' command?";
#     exit;
# }

$currentStatus = [string] (& git status -s)

if (-Not ([string]::IsNullOrWhiteSpace($currentStatus))) {
    Write-Host -ForegroundColor Red 'Error: There must be no changes in the branch';
    exit;
}

# Remove local branches if they exist; we'll re-cut them from current HEAD
(& git branch -D master >$null 2>&1)
(& git branch -D build >$null 2>&1)

# Checkout build branch, clean, build, add /public/ to version control
(& git checkout -b build >$null 2>&1)
(& npm run clean)
(& npm run build)
(& git add public -f >$null 2>&1)
(& git commit -m 'Add website build files in /public/' >$null 2>&1)

(& git subtree split --prefix public -b master >$null 2>&1)

(& git push -f origin master:master >$null 2>&1)

(& git checkout develop >$null 2>&1)

# Final cleanup of branches facilitating build and publish
(& git branch -D master >$null 2>&1)
(& git branch -D build >$null 2>&1)
