# Minimal Powerlevel10k config — run `p10k configure` to regenerate interactively.
# This file is only deployed if ~/.p10k.zsh does not already exist.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                   # current directory
    vcs                   # git status
    virtualenv            # python virtualenv
    newline
    prompt_char           # ❯
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                # exit code
    command_execution_time
    python_version        # uv / venv Python version
    time
  )

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='·'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196

  typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=220
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=220

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1

  # Python via uv
  typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=33
  typeset -g POWERLEVEL9K_PYTHON_VERSION_VISUAL_IDENTIFIER_EXPANSION='🐍'
} "$@"

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
