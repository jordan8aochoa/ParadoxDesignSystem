# handoff-to-mac.ps1
#
# Windows side of the Windows->Mac mini handoff loop.
# Stages local changes, commits, pushes, then SSHes the Mac mini to build
# the Playground and pull a screenshot back.
#
# Prereqs:
#   - SSH key from Windows to Mac mini (see docs/HANDOFF.md)
#   - Set $MacHost below (placeholder: jordan@macmini.local)
#   - Mac mini has Scripts/mac-build-playground.sh available in this repo
#
# Usage:
#   pwsh Scripts/handoff-to-mac.ps1 "optional commit message"

param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"

# ---- CONFIGURE -------------------------------------------------------------
$MacHost      = "jordan@macmini.local"      # PLACEHOLDER — change after SSH setup
$MacRepoPath  = "~/code/ParadoxDesignSystem" # PLACEHOLDER — change to actual path on Mac
$ScreenshotsLocal = "$HOME\handoff-screenshots"
# ---------------------------------------------------------------------------

if (-not (Test-Path $ScreenshotsLocal)) {
    New-Item -ItemType Directory -Path $ScreenshotsLocal | Out-Null
}

Write-Host "==> Staging + committing..."
git add -A
$status = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($status)) {
    if ([string]::IsNullOrWhiteSpace($Message)) { $Message = "handoff: WIP" }
    if ($Message -notmatch "^handoff:") { $Message = "handoff: $Message" }
    git commit -m $Message
} else {
    Write-Host "    (nothing to commit)"
}

Write-Host "==> Pushing..."
git push

Write-Host "==> Triggering Mac build on $MacHost..."
$cmd = "cd $MacRepoPath; bash Scripts/mac-build-playground.sh"
ssh $MacHost $cmd
if ($LASTEXITCODE -ne 0) {
    Write-Error "Mac build failed (exit $LASTEXITCODE)"
    exit $LASTEXITCODE
}

Write-Host "==> Fetching screenshot..."
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dest = Join-Path $ScreenshotsLocal "playground-$stamp.png"
scp "${MacHost}:${MacRepoPath}/handoff-screenshots/latest.png" $dest
if ($LASTEXITCODE -eq 0) {
    Write-Host "Saved: $dest"
} else {
    Write-Warning "Screenshot fetch failed; check Mac build output."
}
