#!/usr/bin/env bash
#
# BlackGuard Buzz — one-command setup
#
#   curl -fsSL https://raw.githubusercontent.com/D-ops47/buzz-onboarding/main/setup.sh | bash
#
# Installs:
#   1. The Buzz desktop app (macOS)
#   2. Claude Code CLI   (runs Fable + the Claude-based agents)
#   3. Codex CLI         (runs the Codex agent)
#
# Then prints the next steps (create identity, get your org access, log in).
#
set -euo pipefail

log()  { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }

# ---- Which Mac are we on? -------------------------------------------------
ARCH="$(uname -m)"
case "$ARCH" in
  arm64) BUZZ_SUFFIX="aarch64" ;;
  x86_64) BUZZ_SUFFIX="x64" ;;
  *) warn "Unrecognized architecture '$ARCH' — Buzz install skipped. You can install it manually."; BUZZ_SUFFIX="" ;;
esac

# ---- 1. Install the Buzz desktop app -------------------------------------
if [ -d "/Applications/Buzz.app" ]; then
  log "Buzz.app already installed — skipping."
else
  if [ -n "$BUZZ_SUFFIX" ]; then
    log "Finding the latest Buzz release..."
    # Resolve the newest version + matching .dmg asset straight from GitHub.
    READ_JSON=$(python3 - <<'PY'
import json, urllib.request
with urllib.request.urlopen("https://api.github.com/repos/block/buzz/releases/latest", timeout=30) as r:
    rel = json.load(r)
ver = rel["tag_name"].replace("desktop-v", "").replace("v", "")
suffix = __import__("os").environ.get("BUZZ_SUFFIX", "aarch64")
asset = f"Buzz_{ver}_{suffix}.dmg"
print(f"{ver}\t{asset}")
PY
)
    VERSION="${READ_JSON%%$'\t'*}"
    ASSET="${READ_JSON##*$'\t'}"
    URL="https://github.com/block/buzz/releases/download/desktop-v${VERSION}/${ASSET}"

    log "Downloading Buzz ${VERSION} (${ASSET})..."
    TMPDIR_X="$(mktemp -d)"
    curl -fL --progress-bar "$URL" -o "$TMPDIR_X/$ASSET"

    log "Installing Buzz..."
    hdiutil attach -nobrowse -quiet "$TMPDIR_X/$ASSET"
    APP_VOL="/Volumes/$(ls /Volumes | grep -i buzz | head -1)"
    cp -R "$APP_VOL/Buzz.app" /Applications/
    hdiutil detach -quiet "$APP_VOL" || true
    rm -rf "$TMPDIR_X"
    log "Buzz installed to /Applications/Buzz.app"
  else
    warn "Buzz not installed (couldn't detect your Mac type). Install from https://github.com/block/buzz/releases"
  fi
fi

# ---- 2. Install Claude Code ----------------------------------------------
log "Installing Claude Code..."
if command -v claude >/dev/null 2>&1; then
  warn "claude already installed (v$(claude --version 2>/dev/null)) — skipping."
else
  curl -fsSL https://claude.ai/install.sh | bash
fi

# ---- 3. Install Codex -----------------------------------------------------
log "Installing Codex..."
if command -v codex >/dev/null 2>&1; then
  warn "codex already installed (v$(codex --version 2>/dev/null)) — skipping."
else
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

# ---- 4. Next steps ---------------------------------------------------------
cat <<'EOF'

============================================================
  Buzz setup complete. Next steps:
============================================================
  1) Open the Buzz app  →  it creates your identity on first launch.
  2) BACK IT UP immediately (no account recovery if you lose it).
  3) Copy your PUBLIC KEY from your profile and send it to the admin
     so they can add you to the BlackGuard community.
  4) Sign in to the tools with your ORG-PROVIDED accounts:
       claude      (first run opens a browser — use your org account)
       codex login (same — org account)
  5) Restart Buzz. You should now see Fable, Codex, Gemini, Grok
     and the Welcome Team (Fizz, Honey, Bumble).

  Full guide:  https://github.com/D-ops47/buzz-onboarding
============================================================
EOF
