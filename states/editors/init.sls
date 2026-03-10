# editors/init.sls — VS Code extensions + settings for WSL
#
# VS Code itself must be installed on WINDOWS with the "WSL" extension
# (ms-vscode-remote.remote-wsl). That extension makes the `code` binary
# available inside WSL, which is what we use below.
#
# Windows install one-liner (run in PowerShell as admin):
#   winget install Microsoft.VisualStudioCode
#   code --install-extension ms-vscode-remote.remote-wsl

{% set user = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}

# Guard: skip extension install if `code` is not on PATH (WSL extension not set up yet)
vscode_check:
  cmd.run:
    - name: which code
    - onfail_stop: True

# ── VS Code extensions (installed into WSL via `code` tunnel) ─
{% for ext in salt['pillar.get']('vscode:extensions', []) %}
vscode_ext_{{ ext | replace('.', '_') | replace('-', '_') }}:
  cmd.run:
    - name: code --install-extension {{ ext }} --force
    - runas: {{ user }}
    - env:
      - HOME: {{ home }}
    - require:
      - cmd: vscode_check
{% endfor %}

# ── VS Code user settings (WSL-side path used by Remote-WSL) ──
vscode_settings_dir:
  file.directory:
    - name: {{ home }}/.vscode-server/data/Machine
    - user: {{ user }}
    - makedirs: True

vscode_settings:
  file.managed:
    - name: {{ home }}/.vscode-server/data/Machine/settings.json
    - source: salt://editors/files/settings.json
    - user: {{ user }}
    - mode: '0644'
    - replace: False   # don't overwrite user's customisations
    - require:
      - file: vscode_settings_dir
