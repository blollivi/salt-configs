# salt-configs

Personal [SaltStack](https://saltproject.io/) states for my Linux (Ubuntu/Debian) machine — applied masterless with `salt-call --local`.

## What's included

| State | What it configures |
|---|---|
| `common` | git, curl, ripgrep, fd, bat, fzf, direnv, tmux, jq, build tools |
| `shell` | zsh + Oh My Zsh + Powerlevel10k theme + zsh-autosuggestions, zsh-syntax-highlighting, you-should-use |
| `python-dev` | [uv](https://docs.astral.sh/uv/) (Python version & package manager), GitHub CLI, git global config, direnv config, uv shell completions |
| `editors` | VS Code via Microsoft apt repo, curated extension list, opinionated `settings.json` |
| `fonts` | JetBrainsMono Nerd Font v3 (installed to `~/.local/share/fonts`) |

## Quick start

### One-liner (clone + bootstrap)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/blollivi/salt-configs/main/bootstrap.sh)
```

### Manual

```bash
git clone https://github.com/blollivi/salt-configs ~/salt-configs
cd ~/salt-configs

make install-salt   # install Salt & configure masterless mode
make apply          # sync states/pillar then run salt-call
```

### Dry run (see what would change without applying)

```bash
make apply-dry
```

## Customise

Edit **`pillar/desktop.sls`** before applying:

```yaml
user:
  name: yourname        # your Linux username
  home: /home/yourname
  email: you@example.com
  full_name: Your Name

# Add/remove VS Code extensions, oh-my-zsh plugins, etc.
```

## Structure

```
salt-configs/
├── bootstrap.sh          # one-shot setup script
├── Makefile              # convenience targets
├── minion                # Salt minion config (masterless)
├── top.sls               # maps states to hosts
├── pillar/
│   ├── top.sls
│   └── desktop.sls       # ← edit this for your machine
└── states/
    ├── common/           # base CLI tools
    ├── shell/            # zsh + oh-my-zsh + plugins
    ├── python-dev/       # uv, gh CLI, git config
    ├── editors/          # VS Code
    └── fonts/            # Nerd Fonts
```

## Adding new states

1. Create `states/<name>/init.sls`
2. Add it to `top.sls`
3. `make apply`

## License

MIT
