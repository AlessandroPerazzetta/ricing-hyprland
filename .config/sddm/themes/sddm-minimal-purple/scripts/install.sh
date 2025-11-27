#!/bin/bash
SDDM_CONF_DIR="/etc/sddm.conf.d"
SDDM_THEMES_DIR="/usr/share/sddm/themes"
THEME_DIR="$SDDM_THEMES_DIR/sddm-minimal-purple2"

if [ "$EUID" -ne 0 ]
  then echo "Note: This script requires sudo privileges to copy files to system directories."
  exit
fi

read -p "Press Enter to continue or Ctrl+C to cancel..."
echo "Installing SDDM Minimal Purple Theme ..."

# "Checking if sddm is installed ..."
if ! command -v sddm &> /dev/null
then
    echo "sddm could not be found. Please install it first."
    exit 1
fi

# "Checking if sddm-greeter-qt6 is installed ..."
if ! command -v sddm-greeter-qt6 &> /dev/null
then
    echo "sddm-greeter-qt6 could not be found. Please install it first."
    exit 1
fi

echo "Copying theme to $THEME_DIR"
mkdir -p $SDDM_THEMES_DIR
cp -R "$(dirname "$(realpath "$0")")/.." $THEME_DIR
echo "Creating directory $SDDM_CONF_DIR/ if it does not exist"
mkdir -p $SDDM_CONF_DIR/
echo "Creating sddm.conf file in $SDDM_CONF_DIR/sddm.conf"
bash -c 'cat > $SDDM_CONF_DIR/sddm.conf <<EOF
[Theme]
Current=sddm-minimal-purple
EOF'
echo ""
echo "Installation complete. You can change the theme later by editing $SDDM_CONF_DIR/sddm.conf"
echo "To test the theme, run: sddm-greeter-qt6 --test-mode --theme $THEME_DIR"
echo "To apply the theme, restart SDDM or reboot your system."