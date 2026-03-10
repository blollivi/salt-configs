# common/init.sls — minimal base packages required by other states

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
      - direnv
