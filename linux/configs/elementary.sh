#!/bin/bash

echo "Configuring basic stuff in elementary os ..."

# show hidden files
gsettings set org.pantheon.files.preferences show-hiddenfiles true

# add minimize button
gsettings set org.gnome.desktop.wm.preferences action-right-click-titlebar 'minimize'