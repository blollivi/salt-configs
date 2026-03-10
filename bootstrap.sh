#!/usr/bin/env bash
# bootstrap.sh — One-shot bootstrap: installs Salt then applies all states.
# Usage: curl -fsSL https://raw.githubusercontent.com/blollivi/salt-configs/main/bootstrap.sh | bash
# Or locally: bash bootstrap.sh

set -euo pipefail

REPO_URL="https://github.com/blollivi/salt-configs"
SALT_DIR="/srv/salt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
ok()    { echo -e "\033[1;32m[ OK ]\033[0m $*"; }
die()   { echo -e "\033[1;31m[ERR ]\033[0m $*" >&2; exit 1; }

# ── 0. Requirements ──────────────────────────────────────────────────────────
[[ $EUID -ne 0 ]] || die "Run this script as your normal user (not root). sudo will be used internally."
command -v curl >/dev/null || die "curl is required. Install with: sudo apt install curl"

# ── 1. Clone repo (if running via curl) ──────────────────────────────────────
if [[ ! -f "$SCRIPT_DIR/top.sls" ]]; then
  info "Cloning salt-configs..."
  git clone "$REPO_URL" ~/salt-configs
  cd ~/salt-configs
else
  cd "$SCRIPT_DIR"
fi

# ── 2. Install Salt ───────────────────────────────────────────────────────────
if ! command -v salt-call >/dev/null 2>&1; then
  info "Installing Salt..."
  curl -fsSL https://bootstrap.saltproject.io | sudo sh -s -- -X stable
  ok "Salt installed"
else
  ok "Salt already installed: $(salt-call --version)"
fi

# ── 3. Configure Salt (masterless) ───────────────────────────────────────────
info "Configuring Salt..."
sudo mkdir -p "$SALT_DIR/states" "$SALT_DIR/pillar"
sudo cp minion /etc/salt/minion

# ── 4. Sync states & pillar ──────────────────────────────────────────────────
info "Syncing states and pillar..."
sudo rsync -av --delete states/ "$SALT_DIR/states/"
sudo rsync -av --delete pillar/ "$SALT_DIR/pillar/"
sudo cp top.sls "$SALT_DIR/states/top.sls"

# ── 5. Apply! ────────────────────────────────────────────────────────────────
info "Applying Salt states (this may take a while on first run)..."
sudo salt-call --local state.apply

ok "Done! Open a new terminal or run: exec zsh"
