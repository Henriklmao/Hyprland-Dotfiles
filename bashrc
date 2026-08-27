# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Auto-launch fish shell if in interactive bash
if command -v fish &>/dev/null; then
  if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
    shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
    exec fish $LOGIN_OPTION
  fi
fi

# All the default Omarchy aliases and functions
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

export QT_STYLE_OVERRIDE=adwaita-dark
export PATH="$PATH:/home/henrik/.local/bin/wb-headsetcontrol"
export PATH="$PATH:/home/henrik/.local/bin"
unset BROWSER
export BROWSER="org.qutebrowser.qutebrowser.desktop"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/henrik/.lmstudio/bin"
# End of LM Studio CLI section

. "$HOME/.local/share/../bin/env"

# BEGIN tirith-hook v1
eval "$(tirith init)"
# END tirith-hook
