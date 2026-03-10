# fonts/init.sls — JetBrainsMono Nerd Font (for terminal + VS Code)

{% set user  = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}
{% set font_dir = home ~ '/.local/share/fonts/NerdFonts' %}
{% set version  = '3.2.1' %}
{% set archive  = 'JetBrainsMono.zip' %}
{% set url      = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v' ~ version ~ '/' ~ archive %}

fonts_dir:
  file.directory:
    - name: {{ font_dir }}
    - user: {{ user }}
    - makedirs: True

jetbrainsmono_nerd_font_download:
  cmd.run:
    - name: |
        curl -fsSL {{ url }} -o /tmp/{{ archive }}
        unzip -o /tmp/{{ archive }} '*.ttf' -d {{ font_dir }}
        rm -f /tmp/{{ archive }}
    - runas: {{ user }}
    - env:
      - HOME: {{ home }}
    - unless: test -n "$(ls {{ font_dir }}/*.ttf 2>/dev/null)"
    - require:
      - file: fonts_dir

fc_cache:
  cmd.run:
    - name: fc-cache -fv {{ font_dir }}
    - runas: {{ user }}
    - onchanges:
      - cmd: jetbrainsmono_nerd_font_download
