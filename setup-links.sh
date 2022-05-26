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
else
    echo "Skipping window manager setup, use '$0 i3' or '$0 gnome3' if that is desired."
fi
