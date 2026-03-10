# shell/zsh.sls — install zsh and make it the default shell

zsh:
  pkg.installed: []

{% set user = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}

zsh_default_shell:
  user.present:
    - name: {{ user }}
    - shell: /bin/zsh
    - require:
      - pkg: zsh
