#!/bin/bash

echo "Configuring basic stuff in elementary os ..."

# configure files
gsettings set org.pantheon.files.preferences show-hiddenfiles true
gsettings set io.elementary.files.preferences single-click false

# minimize window on right-click
gsettings set org.gnome.desktop.wm.preferences action-right-click-titlebar 'minimize'
