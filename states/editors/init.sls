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

# ── VS Code extensions (skip silently if `code` not on PATH yet) ─
{% for ext in salt['pillar.get']('vscode:extensions', []) %}
vscode_ext_{{ ext | replace('.', '_') | replace('-', '_') }}:
  cmd.run:
    - name: code --install-extension {{ ext }} --force
    - runas: {{ user }}
    - env:
      - HOME: {{ home }}
    - unless: "! which code"
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
    - replace: False
    - require:
      - file: vscode_settings_dir
