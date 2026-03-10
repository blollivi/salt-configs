# Pillar data for Windows WSL2 Ubuntu machine
# Adjust these values to match your system

user:
  name: brendan           # your Linux username
  home: /home/brendan
  email: blollivi@example.com   # used for git config
  full_name: Brendan

git:
  default_branch: main
  editor: code --wait

vscode:
  extensions:
    # Python
    - ms-python.python
    - ms-python.pylance
    - ms-python.debugpy
    - charliermarsh.ruff
    # Git
    - eamodio.gitlens
    - mhutchie.git-graph
    # Editor UX
    - vscodevim.vim
    - usernamehw.errorlens
    - gruntfuggly.todo-tree
    - streetsidesoftware.code-spell-checker
    # Containers / infra
    - ms-azuretools.vscode-docker
    - saltstack.vscode-salt
    # Themes / icons
    - PKief.material-icon-theme
    - GitHub.github-vscode-theme

oh_my_zsh:
  theme: powerlevel10k/powerlevel10k
  plugins:
    - git
    - uv
    - direnv
    - docker
    - fzf
    - zsh-autosuggestions
    - zsh-syntax-highlighting
    - you-should-use
