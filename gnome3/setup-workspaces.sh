#!/bin/bash
#
# Mooched and adapted from http://jeffbastian.blogspot.com/2012/06/static-workspaces-and-keyboard.html
#
# Disable dynamic workspaces and set 9 fixed workspaces, and set the
# hot-keys for switching and moving windows to the workspaces.
#
# The Gnome 3.x (<= 3.12) Shell keyboard settings GUI only exposes hot-key configuration
# for workspaces 1-4 so you have to use the command line for spaces 5+.

echo "Disabling dynamic workspaces"
gsettings set org.gnome.shell.overrides dynamic-workspaces false

echo "Setting 12 fixed workspaces"
gsettings set org.gnome.desktop.wm.preferences num-workspaces 12

declare -A WORKSPACE_BINDINGS
WORKSPACE_BINDINGS=(
  ['1']='1'
  ['2']='2'
  ['3']='3'
  ['4']='4'
  ['5']='5'
  ['6']='6'
  ['7']='7'
  ['8']='8'
  ['9']='9'
  ['10']='0'
  ['11']='minus'
  ['12']='equal'
)
WORKSPACES=${!WORKSPACE_BINDINGS[@]}

for x in $WORKSPACES; do
    KEY=${WORKSPACE_BINDINGS[$x]}
    echo "Setting hotkeys for workspace $x ($KEY)"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$x "[\"<Super>$KEY\"]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$x "[\"<Shift><Super>$KEY\"]"
done

# key names can be found at https://git.gnome.org/browse/gtk+/tree/gdk/gdkkeysyms.h

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[\"<Super>bracketleft\"]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[\"<Super>bracketright\"]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "[\"<Shift><Super>bracketleft\"]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "[\"<Shift><Super>bracketright\"]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[]"

#gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[\"<Super>Down\"]"
#gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[\"<Super>Up\"]"
#gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[\"<Super>Left\"]"
#gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[\"<Super>Right\"]"
#
#gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "[\"<Shift><Super>Down\"]"
#gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "[\"<Shift><Super>Up\"]"
#gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[\"<Shift><Super>Left\"]"
#gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[\"<Shift><Super>Right\"]"

echo "Done"
echo "~~~~"
echo "Verify Settings:"
gsettings list-recursively org.gnome.shell.overrides | grep dynamic-workspaces
gsettings list-recursively org.gnome.desktop.wm.preferences | grep num-workspaces
gsettings list-recursively org.gnome.desktop.wm.keybindings | grep to-workspace | sort -n
