# Daily Automated Commit Script (PowerShell)
# Updates DAILY_ACTIVITY.md, commits, and pushes to git

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $PSScriptRoot
Set-Location -Path $RepoDir

$LogFile = Join-Path $RepoDir "DAILY_ACTIVITY.md"
$UtcTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
$UtcDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")

if (-not (Test-Path -Path $LogFile)) {
    "# Daily Activity Log`n`nThis document tracks automated daily commits and updates for the Flexibudget-UG repository.`n`n## Update Records`n`n| Date (UTC) | Timestamp | Source | Details |`n| ---------- | --------- | ------ | ------- |" | Out-File -FilePath $LogFile -Encoding utf8
}

"| $UtcDate | $UtcTime | Local Script | Daily Automated Commit |" | Out-File -FilePath $LogFile -Encoding utf8 -Append

git add DAILY_ACTIVITY.md

$status = git status --porcelain
if ($status) {
    git commit -m "chore(auto): daily repository update [$UtcDate]"
    git push origin main
    Write-Host "Daily commit pushed successfully!" -ForegroundColor Green
} else {
    Write-Host "No changes to commit." -ForegroundColor Yellow
}
