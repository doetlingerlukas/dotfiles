#!/bin/bash

echo "Configuring dock ..."

# delete all default items
rm -f ~/.config/plank/dock1/launchers/*.dockitem

header="[PlankDockItemPreferences]"

dock_items="
  code_code,
  firefox_firefox,
  gitkraken_gitkraken,
  telegram-desktop_telegramdesktop,
  io.elementary.code,
  io.elementary.files,
  io.elementary.terminal
  "

for dock_item in ${dock_items//,/ }
do
  touch ${dock_item}.dockitem

  if [[ $dock_item == "io.elementary*" ]]
  then
    cat > ${dock_item}.dockitem << EOF
      ${header}
      Launcher=file:///usr/share/applications/${dock_item}.desktop
EOF
  else
    cat > ${dock_item}.dockitem << EOF
      ${header}
      Launcher=file:///var/lib/snapd/desktop/applications/${dock_item}.desktop
EOF
  fi

  mv -f ${dock_item}.dockitem ~/.config/plank/dock1/launchers/
done