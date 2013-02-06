#!/usr/bin/env bash

# links
[ -a ~/.bash_aliases ] || ln -s bash_aliases ~/.bash_aliases
[ -a ~/.dircolors ] || ln -s dircolors-solarized ~/.dircolors
[ -a ~/.inputrc ] || ln -s inputrc ~/.inputrc

# copies
[ -a ~/.gitignore ] || cp gitignore ~/.gitignore
[ -a ~/.gitconfig ] || cp gitconfig ~/.gitconfig
[ -a ~/.toprc ] || cp toprc ~/.toprc

# xmonad setup
if [ "x$1" == "x" ]; then
    echo "Skipping XMonad setup, use '$0 xmonad' if that is desired."
else
    if [ -d ~/.xmonad ]; then
        echo "~/.xmonad directory already exists, aborting XMonad setup."
    else
        mkdir ~/.xmonad
        ln -s xmonad/xmonad.hs ~/.xmonad/xmonad.hs
        ln -s xmonad/Xresources ~/.Xresources
        ln -s xmonad/xmobarrc ~/.xmobarrc
        ln -s xmonad/xinitrc ~/.xinitrc
        echo "Creating desktop entry for DWM login, enter sudo creds if prompted..."
        sudo cp xmonad/custom.desktop /usr/share/xsessions

        # for dwm-managed login
        if [ ! -a ~/.xsession ]; then
            ln -s ~/.xinitrc ~/.xsession
        fi

        echo "XMonad setup complete."
    fi
fi
