# BlackGuard Buzz — one-command setup for Windows (PowerShell)
#
#   irm https://raw.githubusercontent.com/D-ops47/buzz-onboarding/main/setup.ps1 | iex
#
# Installs/launches:
#   1. The Buzz desktop app (Windows)
#   2. Claude Code CLI   (runs Fable + the Claude-based agents)
#   3. Codex CLI         (runs the Codex agent)
#
# Note: Buzz for Windows is still an unsigned "alpha" build, so the installer
# may be flagged by Windows. Choose "More info" > "Run anyway" when prompted.
$ErrorActionPreference = 'Stop'

function Step($m) { Write-Host "`n==> $m" -ForegroundColor Green }
function Note($m)  { Write-Host "!! $m" -ForegroundColor Yellow }

# ---- 1. Buzz desktop app (Windows) ----------------------------------------
Step "Buzz desktop app"
if (Test-Path "$env:LOCALAPPDATA\Programs" -and (Get-ChildItem "$env:LOCALAPPDATA\Programs" -Filter '*Buzz*' -ErrorAction SilentlyContinue)) {
    Note "Buzz appears installed - skipping."
} else {
    Step "Finding the latest Buzz release..."
    $rel = Invoke-RestMethod -Uri "https://api.github.com/repos/block/buzz/releases/latest" -Headers @{ 'User-Agent' = 'BlackGuard-setup' }
    $tag = $rel.tag_name
    $ver = ($tag -replace 'desktop-v', '') -replace 'v', ''
    $assetName = "Buzz_${ver}_x64-setup_alpha-unsigned.exe"
    $url = "https://github.com/block/buzz/releases/download/${tag}/${assetName}"

    Step "Downloading $assetName ..."
    $exe = Join-Path $env:TEMP $assetName
    Invoke-WebRequest -Uri $url -OutFile $exe

    Step "Launching the Buzz installer..."
    Write-Host "  Windows may flag this as an unknown app (it's an unsigned alpha build)."
    Write-Host "  In the dialog: choose  More info  >  Run anyway."
    Start-Process -FilePath $exe
}

# ---- 2. Claude Code --------------------------------------------------------
Step "Claude Code"
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Note "claude already installed - skipping."
} else {
    irm https://claude.ai/install.ps1 | iex
}

# ---- 3. Codex --------------------------------------------------------------
Step "Codex"
if (Get-Command codex -ErrorAction SilentlyContinue) {
    Note "codex already installed - skipping."
} else {
    $env:CODEX_INSTALLER_USE_RELEASES_OPENAI_COM = 'false'
    irm https://chatgpt.com/codex/install.ps1 | iex
}

# ---- 4. Next steps ---------------------------------------------------------
@"

============================================================
  Buzz setup complete. Next steps:
============================================================
  1) Finish the Buzz installer if the window is still open.
  2) Open the Buzz app. It creates your identity on first launch.
  3) BACK IT UP right away (no account recovery on Buzz).
  4) Copy your PUBLIC KEY (starts with npub...) and send it to
     the admin so they can add you to BlackGuard. Never share
     the nsec... one.
  5) The admin will send you an invite link. Open it in Buzz and
     click join to finish.
  6) Sign in to the tools with your ORG-PROVIDED accounts:
       claude      (first run opens a browser - use your org account)
       codex login (same - org account)
  7) Restart Buzz. You should see Fable, Codex, Gemini, Grok and
     the Welcome Team (Fizz, Honey, Bumble).

  Full guide:  https://github.com/D-ops47/buzz-onboarding
============================================================
"@
