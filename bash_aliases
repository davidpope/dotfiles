### human-readable ls output

alias ll='ls -lFh'
alias la='ls -AFh'
alias l='ls -CFh'

### git prompt mooched from http://mediadoneright.com/content/ultimate-git-ps1-bash-prompt

#  Customize BASH PS1 prompt to show current GIT repository and branch.
#  by Mike Stewart - http://MediaDoneRight.com

#  SETUP CONSTANTS
#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.
#  I don't remember where I found this.  o_O

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"
Hostname="\h"
Space=" "


# This PS1 snippet was adopted from code for MAC/BSD I saw from: http://allancraig.net/index.php?option=com_content&view=article&id=108:ps1-export-command-for-git&catid=45:general&Itemid=96
# I tweaked it to work on UBUNTU 11.04 & 11.10 plus made it mo' better

if [ -f /etc/bash_completion -a -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion
    . /etc/bash_completion.d/git
fi

if [[ -z `declare -f __git_ps1` ]]; then
  PS1="$IBlack$Time12h$Color_Off$Space$Hostname $Yellow$PathShort$Color_Off"
else
  PS1=$IBlack$Time12h$Color_Off$Space$Hostname'$(git branch &>/dev/null;\
  if [ $? -eq 0 ]; then \
    echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
    if [ "$?" -eq "0" ]; then \
      # @4 - Clean repository - nothing to commit
      echo "'$Green'"$(__git_ps1 " (%s)"); \
    else \
      # @5 - Changes to working tree
      echo "'$IRed'"$(__git_ps1 " {%s}"); \
    fi) '$BYellow$PathShort$Color_Off'"; \
  else \
    # @2 - Prompt when not in GIT repo
    echo " '$Yellow$PathShort$Color_Off'"; \
  fi)'
fi
export PS1=$PS1$NewLine'$(
  if [ $EUID -eq 0 ]; then
    echo "'$IRed'\$'$Color_Off' "
  else
    echo "\\$ "
  fi
)'


### Reapply the title-setting logic from .bashrc that we just stomped

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
xterm*|rxvt*)
    export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS="-X -F -i -j.1 -M -R -w"

# Reference: Solarized color numbers
# Taken from https://github.com/altercation/solarized/tree/master/osx-terminal.app-colors-solarized#the-values
# SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      RGB         HSB
# --------- ------- ---- -------  ----------- ---------- ----------- -----------
# base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
# base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
# base01    #586e75 10/7 brgreen  240 #585858 45 -07 -07  88 110 117 194  25  46
# base00    #657b83 11/7 bryellow 241 #626262 50 -07 -07 101 123 131 195  23  51
# base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
# base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
# base2     #eee8d5  7/7 white    254 #e4e4e4 92 -00  10 238 232 213  44  11  93
# base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
# yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
# orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
# red       #d30102  1/1 red      124 #af0000 45  70  60 211   1   2   0  99  83
# magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
# violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
# blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
# cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
# green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60

# Color LESS output (man pages etc.)
# Taken from http://www.tuxarena.com/2012/04/tutorial-colored-man-pages-how-it-works/
# See dircolors.solarized for explanation of 256-color codes
case "$TERM" in
*256*)
    export LESS_TERMCAP_md=$(printf '\e[38;5;33m') # enter double-bright mode - blue
    export LESS_TERMCAP_so=$(printf '\e[07;38;5;61m') # enter standout mode - reverse violet
    export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode    
    export LESS_TERMCAP_us=$(printf '\e[04;38;5;64m') # enter underline mode - green
    export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
    export LESS_TERMCAP_mb=$(printf '\e[38;5;124m') # enter blinking mode - red
    export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
    ;;
*)
    export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
    export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
    export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode    
    export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan
    export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
    export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
    export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
    ;;
esac

[ -d $HOME/tmp ] || mkdir $HOME/tmp
export TMPDIR=$HOME/tmp

if [ -f $HOME/.bash_aliases.local ]; then
    . $HOME/.bash_aliases.local
fi
