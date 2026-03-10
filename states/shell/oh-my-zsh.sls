# shell/oh-my-zsh.sls — install Oh My Zsh + Powerlevel10k theme

{% set user  = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}
{% set theme = salt['pillar.get']('oh_my_zsh:theme', 'robbyrussell') %}

oh_my_zsh_install:
  cmd.run:
    - name: >
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        "" --unattended
    - runas: {{ user }}
    - unless: test -d {{ home }}/.oh-my-zsh
    - require:
      - pkg: zsh

powerlevel10k:
  git.cloned:
    - name: https://github.com/romkatv/powerlevel10k.git
    - target: {{ home }}/.oh-my-zsh/custom/themes/powerlevel10k
    - depth: 1
    - user: {{ user }}
    - unless: test -d {{ home }}/.oh-my-zsh/custom/themes/powerlevel10k
    - require:
      - cmd: oh_my_zsh_install

# Drop a minimal .p10k.zsh if none exists so the prompt works out-of-the-box.
# Users can re-run `p10k configure` to customise it.
p10k_config:
  file.managed:
    - name: {{ home }}/.p10k.zsh
    - source: salt://shell/files/p10k.zsh
    - user: {{ user }}
    - mode: '0644'
    - replace: False   # don't overwrite if user has customised
    - require:
      - git: powerlevel10k

zshrc_managed:
  file.managed:
    - name: {{ home }}/.zshrc
    - source: salt://shell/files/zshrc.j2
    - template: jinja
    - user: {{ user }}
    - mode: '0644'
    - defaults:
        user: {{ user }}
        home: {{ home }}
        theme: {{ theme }}
        plugins: {{ salt['pillar.get']('oh_my_zsh:plugins', ['git']) | join(' ') }}
    - require:
      - cmd: oh_my_zsh_install

# Ensure direnv hook is active (used by many states below)
direnv_hook:
  file.blockreplace:
    - name: {{ home }}/.zshrc
    - marker_start: "# >>> direnv hook >>>"
    - marker_end: "# <<< direnv hook <<<"
    - content: 'eval "$(direnv hook zsh)"'
    - append_if_not_found: True
    - require:
      - file: zshrc_managed
