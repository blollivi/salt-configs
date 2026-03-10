# wsl/init.sls — WSL2-specific configuration

# /etc/wsl.conf controls WSL2 behaviour at the distro level
wsl_conf:
  file.managed:
    - name: /etc/wsl.conf
    - mode: '0644'
    - contents: |
        [boot]
        systemd = true

        [automount]
        enabled = true
        root = /mnt/
        options = "metadata,umask=22,fmask=11"
        mountFsTab = true

        [interop]
        # Keep Windows PATH available (needed for `code` CLI from WSL)
        enabled = true
        appendWindowsPath = true

        [network]
        generateHosts = true
        generateResolvConf = true

# Reminder: after changing wsl.conf, restart the distro:
#   wsl --shutdown   (run in PowerShell/CMD on Windows)
wsl_conf_notice:
  test.show_notification:
    - text: "wsl.conf updated. Run 'wsl --shutdown' in Windows PowerShell then reopen WSL to apply changes."
    - require:
      - file: wsl_conf
