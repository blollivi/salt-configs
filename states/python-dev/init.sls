# python-dev/init.sls — modern Python development toolchain

{% set user = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}

# ── uv — fast Python package/project/version manager ─────────
uv_install:
  cmd.run:
    - name: curl -LsSf https://astral.sh/uv/install.sh | sh
    - runas: {{ user }}
    - env:
      - HOME: {{ home }}
    - unless: test -f {{ home }}/.local/bin/uv

# Ensure ~/.local/bin is on PATH for Salt states that call uv
uv_path_env:
  environ.setenv:
    - name: PATH
    - value: {{ home }}/.local/bin:{{ salt['environ.get']('PATH') }}
    - update_minion: True
    - require:
      - cmd: uv_install

# ── GitHub CLI ────────────────────────────────────────────────
gh_cli_keyring:
  cmd.run:
    - name: |
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
          | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    - unless: test -f /usr/share/keyrings/githubcli-archive-keyring.gpg

gh_cli_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/github-cli.list
    - contents: "deb [arch={{ grains['osarch'] }} signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"
    - require:
      - cmd: gh_cli_keyring

gh_cli:
  pkg.installed:
    - name: gh
    - refresh: True
    - require:
      - file: gh_cli_repo

# ── Git global config ─────────────────────────────────────────
git_user_name:
  git.config_set:
    - name: user.name
    - value: {{ salt['pillar.get']('user:full_name', user) }}
    - user: {{ user }}
    - global: True

git_user_email:
  git.config_set:
    - name: user.email
    - value: {{ salt['pillar.get']('user:email', user ~ '@localhost') }}
    - user: {{ user }}
    - global: True

git_default_branch:
  git.config_set:
    - name: init.defaultBranch
    - value: {{ salt['pillar.get']('git:default_branch', 'main') }}
    - user: {{ user }}
    - global: True

git_editor:
  git.config_set:
    - name: core.editor
    - value: {{ salt['pillar.get']('git:editor', 'nano') }}
    - user: {{ user }}
    - global: True

git_pull_rebase:
  git.config_set:
    - name: pull.rebase
    - value: 'true'
    - user: {{ user }}
    - global: True

git_push_default:
  git.config_set:
    - name: push.default
    - value: current
    - user: {{ user }}
    - global: True

# ── direnv — per-directory environment vars ───────────────────
# pkg installed via common; just ensure the hook config is present
direnv_toml_dir:
  file.directory:
    - name: {{ home }}/.config/direnv
    - user: {{ user }}
    - makedirs: True

direnv_config:
  file.managed:
    - name: {{ home }}/.config/direnv/direnv.toml
    - user: {{ user }}
    - mode: '0644'
    - contents: |
        [global]
        warn_timeout = "5s"
        hide_env_diff = true
    - require:
      - file: direnv_toml_dir

# ── uv shell completions ──────────────────────────────────────
uv_zsh_completions_dir:
  file.directory:
    - name: {{ home }}/.zfunc
    - user: {{ user }}
    - makedirs: True

uv_zsh_completions:
  cmd.run:
    - name: {{ home }}/.local/bin/uv generate-shell-completion zsh > {{ home }}/.zfunc/_uv
    - runas: {{ user }}
    - env:
      - HOME: {{ home }}
    - onchanges:
      - cmd: uv_install
    - require:
      - file: uv_zsh_completions_dir
