#!/bin/bash

echo "Configuring dock ..."

# delete all default items
rm -f ~/.config/plank/dock1/launchers/*.dockitem

header="[PlankDockItemPreferences]"

dock_items="
  org.pantheon.files,
  org.terminal."

for dock_item in ${dock_items//,/ }
do
  cat > ${dock_item}.dockitem << EOF
    ${header}
    file//${dock_item}
EOF
done