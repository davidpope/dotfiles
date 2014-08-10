#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# See "Quickly Setting up Awesome with GNOME" at
# http://awesome.naquadah.org/wiki/Quickly_Setting_up_Awesome_with_Gnome

SESSION_FILE=/usr/share/gnome-session/sessions/awesome.session
AWESOME_DESKTOP_FILE=/usr/share/applications/awesome.desktop
AWESOME_GNOME_DESKTOP_FILE=/usr/share/xsessions/awesome-gnome.desktop

[[ "$UID" -ne 0 ]] && echo "Please run as root" && exit

if ! [ -e $SESSION_FILE ]; then
    sudo cp $SCRIPT_DIR/awesome.session $SESSION_FILE
    echo $SESSION_FILE created.
fi

if ! [ -e $AWESOME_DESKTOP_FILE ]; then
    sudo cp $SCRIPT_DIR/awesome.desktop $AWESOME_DESKTOP_FILE
    echo $AWESOME_DESKTOP_FILE created.
fi

if ! [ -e $AWESOME_GNOME_DESKTOP_FILE ]; then
    sudo cp $SCRIPT_DIR/awesome-gnome.desktop $AWESOME_GNOME_DESKTOP_FILE
    echo $AWESOME_GNOME_DESKTOP_FILE created.
fi


USER_AUTOSTART_DIR=$HOME/.config/autostart

mkdir -p $USER_AUTOSTART_DIR

# Add local autostarts
cp $SCRIPT_DIR/autostart-*.desktop $USER_AUTOSTART_DIR

# Copy and modify system autostarts so they run in the Awesome session
for F in $(grep -l -e "^OnlyShowIn=.*GNOME.*" /etc/xdg/autostart/*.desktop); do
    OUTFILE=$USER_AUTOSTART_DIR/$(basename $F)
    sed -f ./update-OnlyShowIn.sed < $F > $OUTFILE
    echo $OUTFILE created.
done;
