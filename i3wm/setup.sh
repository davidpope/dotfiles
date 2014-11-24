#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CFGDIR="$HOME/.config"
I3CFGDIR="$CFGDIR/i3"
I3STATUSCFGDIR="$CFGDIR/i3status"

[[ -e $CFGDIR ]] || mkdir -p $CFGDIR
[[ -e $I3CFGDIR ]] || ln -s $SCRIPT_DIR/i3 $I3CFGDIR
[[ -e $I3STATUSCFGDIR ]] || ln -s $SCRIPT_DIR/i3status $I3STATUSCFGDIR
