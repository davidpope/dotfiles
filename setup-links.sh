#!/usr/bin/env bash

# from http://stackoverflow.com/questions/59895/
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# links
[ -a $HOME/.bash_aliases ] || ln -s $SCRIPT_DIR/bash_aliases $HOME/.bash_aliases
[ -a $HOME/.dircolors ] || ln -s $SCRIPT_DIR/dircolors-solarized $HOME/.dircolors
[ -a $HOME/.inputrc ] || ln -s $SCRIPT_DIR/inputrc $HOME/.inputrc

# copies
[ -a $HOME/.gitignore ] || cp $SCRIPT_DIR/gitignore $HOME/.gitignore
[ -a $HOME/.gitconfig ] || cp $SCRIPT_DIR/gitconfig $HOME/.gitconfig
[ -a $HOME/.toprc ] || cp $SCRIPT_DIR/toprc $HOME/.toprc

# window manager setup
if [ "x$1" == "xawesome" ]; then
    mkdir -p $HOME/.config/awesome
    [ -a $HOME/.config/awesome/rc.lua ] || ln -s $SCRIPT_DIR/awesomewm/rc.lua $HOME/.config/awesome/rc.lua
    [ -a $HOME/.xinitrc ] || ln -s $SCRIPT_DIR/awesomewm/xinitrc $HOME/.xinitrc

    # for *dm-managed login
    [ -a $HOME/.xsession ] || ln -s $HOME/.xinitrc $HOME/.xsession

    echo "If a *dm entry for a user-defined session does not exist, run the following:"
    echo "    sudo cp $SCRIPT_DIR/custom.desktop /usr/share/xsessions"
    echo "Awesome-WM setup complete."
elif [ "x$1" == "xxmonad" ]; then
    if [ -d $HOME/.xmonad ]; then
        echo "$HOME/.xmonad directory already exists, aborting XMonad setup."
    else
        mkdir $HOME/.xmonad
        [ -a $HOME/.xmonad/xmonad.hs ] || ln -s $SCRIPT_DIR/xmonad/xmonad.hs $HOME/.xmonad/xmonad.hs
        [ -a $HOME/.Xresources ] || ln -s $SCRIPT_DIR/xmonad/Xresources $HOME/.Xresources
        [ -a $HOME/.xmobarrc ] || ln -s $SCRIPT_DIR/xmonad/xmobarrc $HOME/.xmobarrc
        [ -a $HOME/.xinitrc ] || ln -s $SCRIPT_DIR/xmonad/xinitrc $HOME/.xinitrc
        echo "If a *dm entry for a user-defined session does not exist, run the following:"
        echo "    sudo cp $SCRIPT_DIR/custom.desktop /usr/share/xsessions"

        # for *dm-managed login
        [ -a $HOME/.xsession ] || ln -s $HOME/.xinitrc $HOME/.xsession

        echo "XMonad setup complete."
    fi
else
    echo "Skipping window manager setup, use '$0 awesome' or '$0 xmonad' if that is desired."
fi
