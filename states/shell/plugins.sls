# shell/plugins.sls — community oh-my-zsh plugins

{% set user = salt['pillar.get']('user:name', 'brendan') %}
{% set home  = salt['pillar.get']('user:home', '/home/' ~ user) %}
{% set omz   = home ~ '/.oh-my-zsh/custom/plugins' %}

zsh_autosuggestions:
  git.cloned:
    - name: https://github.com/zsh-users/zsh-autosuggestions.git
    - target: {{ omz }}/zsh-autosuggestions
    - depth: 1
    - user: {{ user }}
    - unless: test -d {{ omz }}/zsh-autosuggestions

zsh_syntax_highlighting:
  git.cloned:
    - name: https://github.com/zsh-users/zsh-syntax-highlighting.git
    - target: {{ omz }}/zsh-syntax-highlighting
    - depth: 1
    - user: {{ user }}
    - unless: test -d {{ omz }}/zsh-syntax-highlighting

you_should_use:
  git.cloned:
    - name: https://github.com/MichaelAquilina/zsh-you-should-use.git
    - target: {{ omz }}/you-should-use
    - depth: 1
    - user: {{ user }}
    - unless: test -d {{ omz }}/you-should-use
