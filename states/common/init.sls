# common/init.sls — base packages for every machine

common_packages:
  pkg.installed:
    - pkgs:
      - git
      - curl
      - wget
      - unzip
      - ca-certificates
      - gnupg
      - lsb-release
      - software-properties-common
      - build-essential
      - jq
      - ripgrep
      - fd-find
      - bat
      - fzf
      - direnv
      - tree
      - htop
      - tmux
      - xclip

# fd and bat ship under different binary names on Debian/Ubuntu; create symlinks
fd_symlink:
  file.symlink:
    - name: /usr/local/bin/fd
    - target: /usr/bin/fdfind
    - makedirs: True
    - require:
      - pkg: common_packages

bat_symlink:
  file.symlink:
    - name: /usr/local/bin/bat
    - target: /usr/bin/batcat
    - makedirs: True
    - require:
      - pkg: common_packages
