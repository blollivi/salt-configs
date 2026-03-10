# salt-configs

Personal [SaltStack](https://saltproject.io/) states for my **Windows WSL2 (Ubuntu)** machine — applied masterless with `salt-call --local`.

## Prerequisites (Windows side)

Before running Salt inside WSL, do these two things on Windows:

1. **Install VS Code** (if not already installed):
   ```powershell
   winget install Microsoft.VisualStudioCode
   ```
2. **Install the WSL extension** — this makes the `code` binary available inside WSL:
   ```powershell
   code --install-extension ms-vscode-remote.remote-wsl
   ```

## What's included

| State | What it configures |
|---|---|
| `wsl` | `/etc/wsl.conf` — systemd, automount options, Windows interop (keeps `code` on PATH) |
| `common` | git, curl, ripgrep, fd, bat, fzf, direnv, tmux, jq, build tools |
| `shell` | zsh + Oh My Zsh + Powerlevel10k + zsh-autosuggestions, zsh-syntax-highlighting, you-should-use |
| `python-dev` | [uv](https://docs.astral.sh/uv/) (Python version & package manager), GitHub CLI, git global config, direnv config, uv zsh completions |
| `editors` | VS Code extensions (installed into WSL via `code` CLI) + WSL-side `settings.json` |
| `fonts` | JetBrainsMono Nerd Font v3 (installed to `~/.local/share/fonts`) |

> **Note:** VS Code itself is installed on Windows. The `editors` state only installs extensions and settings via the `code` binary that the WSL extension exposes inside WSL.

## Quick start

```bash
# 1. Edit your username/email first
nano ~/salt-configs/pillar/windows-wsl.sls

# 2. Install Salt + apply everything
cd ~/salt-configs && make install-salt && make apply
```

Or on a fresh WSL distro:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/blollivi/salt-configs/main/bootstrap.sh)
```

### Dry run (see what would change without applying)

```bash
make apply-dry
```

## After first apply

The `wsl` state updates `/etc/wsl.conf`. Restart WSL to apply those changes:

```powershell
# Run in Windows PowerShell
wsl --shutdown
```

## Customise

Edit **`pillar/windows-wsl.sls`** before applying:

```yaml
user:
  name: yourname        # your WSL username
  home: /home/yourname
  email: you@example.com
  full_name: Your Name

# Add/remove VS Code extensions, oh-my-zsh plugins, etc.
```

## Structure

```
salt-configs/
├── bootstrap.sh               # one-shot setup script
├── Makefile                   # convenience targets
├── minion                     # Salt minion config (masterless)
├── top.sls                    # maps states to hosts
├── pillar/
│   ├── top.sls
│   └── windows-wsl.sls        # ← edit this for your machine
└── states/
    ├── wsl/                   # /etc/wsl.conf + interop
    ├── common/                # base CLI tools
    ├── shell/                 # zsh + oh-my-zsh + plugins
    ├── python-dev/            # uv, gh CLI, git config
    ├── editors/               # VS Code extensions + settings
    └── fonts/                 # Nerd Fonts
```

## Adding new states

1. Create `states/<name>/init.sls`
2. Add it to `top.sls`
3. `make apply`

## License

MIT
