# editors/init.sls — VS Code via Microsoft apt repo

{% set user = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}

vscode_keyring:
  cmd.run:
    - name: |
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
          | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
        chmod go+r /usr/share/keyrings/microsoft.gpg
    - unless: test -f /usr/share/keyrings/microsoft.gpg

vscode_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/vscode.list
    - contents: |
        deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft.gpg]
        https://packages.microsoft.com/repos/code stable main
    - require:
      - cmd: vscode_keyring

vscode:
  pkg.installed:
    - name: code
    - refresh: True
    - require:
      - file: vscode_repo

# ── VS Code extensions ────────────────────────────────────────
{% for ext in salt['pillar.get']('vscode:extensions', []) %}
vscode_ext_{{ ext | replace('.', '_') | replace('-', '_') }}:
  cmd.run:
    - name: code --install-extension {{ ext }} --force
    - runas: {{ user }}
    - env:
      - HOME: {{ home }}
      - DISPLAY: ':0'
    - require:
      - pkg: vscode
{% endfor %}

# ── VS Code user settings ─────────────────────────────────────
vscode_settings_dir:
  file.directory:
    - name: {{ home }}/.config/Code/User
    - user: {{ user }}
    - makedirs: True

vscode_settings:
  file.managed:
    - name: {{ home }}/.config/Code/User/settings.json
    - source: salt://editors/files/settings.json
    - user: {{ user }}
    - mode: '0644'
    - replace: False   # don't overwrite user's customisations
    - require:
      - file: vscode_settings_dir
