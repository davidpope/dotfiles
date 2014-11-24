#!/usr/bin/env bash

# from http://stackoverflow.com/questions/59895/
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# keep a private tree in $HOME/local for bin, include, share, lib, etc.
# e.g. use  --prefix=$HOME/local when running configure.sh for downloaded code
[ -d $HOME/local/bin ] || mkdir -p $HOME/local/bin
[ -x $HOME/local/bin/fix_resolution.sh ] || ln -s $SCRIPT_DIR/scripts/fix_resolution.sh $HOME/local/bin

# edits
[ -a $HOME/.profile ] || touch $HOME/.profile
if ! [[ $(grep 'DAVIDPOPE ENVIRONMENT ADJUSTMENTS' $HOME/.profile) ]]; then
    cat >> $HOME/.profile <<-EOF

	# DAVIDPOPE ENVIRONMENT ADJUSTMENTS - INSTALLED BY SCRIPT, DO NOT EDIT BY HAND
	#
	# These are settings that should apply to graphical shells as well as bash.'
	# Graphical shells like GNOME 3 do not normally read the .bash_* files.'
	#
	EOF

    # environment adjustments here
    echo 'export PATH="$HOME/local/bin:$PATH"' >> $HOME/.profile
fi

# links
[ -a $HOME/.bash_aliases ] || ln -s $SCRIPT_DIR/bash_aliases $HOME/.bash_aliases
[ -a $HOME/.dircolors ] || ln -s $SCRIPT_DIR/dircolors-solarized $HOME/.dircolors
[ -a $HOME/.inputrc ] || ln -s $SCRIPT_DIR/inputrc $HOME/.inputrc

# copies
[ -a $HOME/.gitignore ] || cp $SCRIPT_DIR/gitignore $HOME/.gitignore
[ -a $HOME/.gitconfig ] || cp $SCRIPT_DIR/gitconfig $HOME/.gitconfig
[ -a $HOME/.toprc ] || cp $SCRIPT_DIR/toprc $HOME/.toprc
[ -a $HOME/.my.cnf ] || cp $SCRIPT_DIR/my.cnf $HOME/.my.cnf

# vim setup
[ -a $HOME/.vimrc ] || ln -s $SCRIPT_DIR/vim/vimrc $HOME/.vimrc
[ -a $HOME/.gvimrc ] || ln -s $SCRIPT_DIR/vim/gvimrc $HOME/.gvimrc
[ -a $HOME/.vim ] || ln -s $SCRIPT_DIR/vim/vimfiles $HOME/.vim

# window manager setup
if [ "x$1" == "xi3" ]; then
    $SCRIPT_DIR/i3wm/setup.sh
elif [ "x$1" == "xgnome3" ]; then
    $SCRIPT_DIR/gnome3/setup-workspaces.sh
elif [ "x$1" == "xawesome" ]; then
    [ -d $HOME/.config ] || mkdir -p $HOME/.config
    [ -a $HOME/.config/awesome ] || ln -s $SCRIPT_DIR/awesome $HOME/.config/awesome

    [ -a $HOME/.xinitrc ] || ln -s $SCRIPT_DIR/awesome/xinitrc $HOME/.xinitrc
    [ -a $HOME/.xscreensaver ] || ln -s $SCRIPT_DIR/awesome/xscreensaver $HOME/.xscreensaver
    [ -a $HOME/.Xresources ] || ln -s $SCRIPT_DIR/awesome/Xresources $HOME/.Xresources
    [ -a $HOME/.conkyrc ] || ln -s $SCRIPT_DIR/awesome/conkyrc $HOME/.conkyrc

    # for *dm-managed login
    [ -a $HOME/.xsession ] || ln -s $HOME/.xinitrc $HOME/.xsession

    echo "If a *dm entry for a user-defined session does not exist, run the following:"
    echo ""
    echo "    sudo cp $SCRIPT_DIR/custom.desktop /usr/share/xsessions"
    echo ""
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
    echo "Skipping window manager setup, use '$0 i3', '$0 gnome3', '$0 awesome', or '$0 xmonad' if that is desired."
fi
