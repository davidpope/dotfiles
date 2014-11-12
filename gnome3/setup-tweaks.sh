# Don't waste CPU/GPU cycles on frippery
gsettings set org.gnome.desktop.interface enable-animations false

# Dragging is a stupid way to trigger tiling
gsettings set org.gnome.shell.overrides edge-tiling false
