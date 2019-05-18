#!/bin/bash

echo "Configuring basic stuff in elementary os ..."

# configure files
gsettings set org.pantheon.files.preferences show-hiddenfiles true
gsettings set io.elementary.files.preferences single-click false

# add minimize button
gsettings set org.gnome.desktop.wm.preferences action-right-click-titlebar 'minimize'
