# The following single-line comment enforces use of PowerShell Core.
#requires -PSEdition Core

$currentBranch = [string] (& git rev-parse --abbrev-ref HEAD)

if ($currentBranch -ne 'develop') {
    Write-Host 'Error: Must be on develop branch.';
    exit;
}

if (-Not (Test-Path -Path 'public')) {
    Write-Host -ForegroundColor Red "Error: The folder 'public' does not exist. Have you built the website using the 'npm run build' command?";
    exit;
}

$currentStatus = [string] (& git status -s)

if ($currentStatus -ne [string]::Empty) {
    Write-Host -ForegroundColor Red 'Error: There must be no changes in the branch';
    # exit;
}

(& git branch -D master)
(& git subtree split --prefix public -b master)
(& git add public -f && git commit -m 'Add /public/')
(& git push -f origin master:master)
(& git branch -D master)