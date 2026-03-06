#!/bin/bash
# Checks if the branding has already been applied for this user
if [ -f "$HOME/.config/zypher-branded" ]; then
  exit 0
fi

exec >"$HOME/zypher-branding.log" 2>&1
echo "Waiting for Plasma DBus to initialize..."

until qdbus6 org.kde.plasmashell /PlasmaShell >/dev/null 2>&1; do
  sleep 2
done

echo "DBus found. Waiting 5s for Wayland desktop rendering..."
sleep 5

echo "Applying Wallpaper..."
plasma-apply-wallpaperimage "/usr/share/zypheros/branding/wallpaper.png"

echo "Applying Launcher Icon..."
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var p = panels();
    for (var i=0; i<p.length; ++i) {
        var w = p[i].widgets();
        for (var j=0; j<w.length; ++j) {
            if (w[j].type === 'org.kde.plasma.kickoff') {
                w[j].currentConfigGroup = ['General'];
                w[j].writeConfig('icon', '/usr/share/zypheros/branding/icon.png');
            }
        }
    }
"

echo "Success! Marking as applied..."
touch "$HOME/.config/zypher-branded"
