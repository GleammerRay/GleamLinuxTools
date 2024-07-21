#! /bin/bash
export GLEAM_USER=""
if [ $(id -u) = 0 ]; then
  export GLEAM_USER="`logname`"
else
  export GLEAM_USER="$USER"
fi
export GLEAM_HOME="/home/$GLEAM_USER"
export GLEAM_TOOLS="$GLEAM_HOME/.gleamtools"
export GLEAM_TOOLS_BIN="$GLEAM_TOOLS/bin"
export GLEAM_TOOLS_LIB="$GLEAM_TOOLS/lib"
cd "`dirname "$0"`"
if [ "$1" = 'all' ]; then
  exit 0
elif [ "$1" = 'file-actions' ]; then
  if [ "$2" = 'all' ]; then
    exit 0
  fi
elif [ "$1" = 'meta' ]; then
  if [ "$2" = 'krunner' ]; then
    if command -v "kwriteconfig5" &> /dev/null; then
      kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
    elif command -v "kwriteconfig6" &> /dev/null; then
      kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
    fi
    qdbus org.kde.KWin /KWin reconfigure
    exit 0
  elif [ "$2" = 'plasma-drawer' ]; then
    if command -v "kwriteconfig5" &> /dev/null; then
      kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
    elif command -v "kwriteconfig6" &> /dev/null; then
      kwriteconfig6 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
    fi
    qdbus org.kde.KWin /KWin reconfigure
    exit 0
  fi
elif [ "$1" = 'mousepoll' ]; then
  if ! [ $(id -u) = 0 ]; then
     echo "install.sh: mousepoll: The script need to be run as root." >&2
     exit 1
  fi
  if [ "x$2" = 'x' ]; then
    echo "install.sh: mousepoll: Missing polling rate (x)"
    exit 1
  fi
  SCRIPT_FILE="$GLEAM_TOOLS_BIN/setmousepoll.sh"
  SUDOERS_FILE="/etc/sudoers.d/$GLEAM_USER-mousepoll"
  AUTOSTART_DIR="$GLEAM_HOME/.config/autostart"
  AUTOSTART_FILE="$AUTOSTART_DIR/setmousepoll.desktop"
  if [ ! -d "$AUTOSTART_DIR" ]; then
    sudo -u $GLEAM_USER mkdir -p "$AUTOSTART_DIR"
  fi
  if [ ! -d "$GLEAM_TOOLS_BIN" ]; then
    sudo -u $GLEAM_USER mkdir -p "$GLEAM_TOOLS_BIN"
  fi
  sudo echo "ALL ALL=NOPASSWD: /bin/bash $SCRIPT_FILE" > "$SUDOERS_FILE"
  sudo chmod 0440 "$SUDOERS_FILE"
  if [ ! -f "$SCRIPT_FILE" ]; then
    sudo -u $GLEAM_USER touch "$SCRIPT_FILE"
  fi
  echo "#! /bin/bash" > "$SCRIPT_FILE"
  echo "modprobe -r usbhid && modprobe usbhid mousepoll=$2" >> "$SCRIPT_FILE"
  chmod +x "$SCRIPT_FILE"
  "$SCRIPT_FILE"
  if [ ! -f "$AUTOSTART_FILE" ]; then
    sudo -u $GLEAM_USER touch "$AUTOSTART_FILE"
  fi
  printf '%s\n' \
    "[Desktop Entry]" \
    "Type=Application" \
    "Exec=sudo /bin/bash $SCRIPT_FILE" \
    "Hidden=false" \
    "NoDisplay=false" \
    "X-GNOME-Autostart-enabled=true" \
    "Name[en_US]=Set mouse polling rate" \
    "Name=Set mouse polling rate" \
    "Comment[en_US]=" \
    "Comment=" > "$AUTOSTART_FILE"
  echo "Mouse polling rate set to: `cat /sys/module/usbhid/parameters/mousepoll`"
elif [ "$1" = 'applet-window-buttons' ]; then
  if ! [ $(id -u) = 0 ]; then
     echo "install.sh: applet-window-buttons: The script need to be run as root." >&2
     exit 1
  fi
  if [ ! -d "$GLEAM_TOOLS_LIB" ]; then
    sudo -u $GLEAM_USER mkdir -p "$GLEAM_TOOLS_LIB"
  fi
  cd "$GLEAM_TOOLS_LIB"
  sudo -u $GLEAM_USER git clone https://github.com/psifidotos/applet-window-buttons
  if [ -d ./applet-window-buttons ]; then
    rm -rf applet-window-buttons
  fi
  cd applet-window-buttons
  sudo sh install.sh
else
  echo "install.sh: Unknown command: $@"
  exit 1
fi
