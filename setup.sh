#!/usr/bin/env bash

# Install script for Hyprland ricing

# Define source and target directories
SRC_DIR="$(pwd)"
TARGET_DIR="$HOME/.config"
BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"
# List of config directories to symlink
CONFIG_DIRS=("alacritty" "copyq" "htop" "hypr" "kitty" "sddm" "sys64" "tmux" "waybar" "wofi")
# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Backup directory created at $BACKUP_DIR"
tar -czf "$BACKUP_DIR/configs_backup.tar.gz" -C "$TARGET_DIR" "${CONFIG_DIRS[@]}"
echo "Existing configurations backed up to $BACKUP_DIR/configs_backup.tar.gz"

# Copy new config from source to target
for dir in "${CONFIG_DIRS[@]}"; do
    SRC_PATH="$SRC_DIR/.config/$dir"
    TARGET_PATH="$TARGET_DIR/$dir"
    if [ -d "$SRC_PATH" ]; then
        # Remove existing config if it exists
        if [ -e "$TARGET_PATH" ] || [ -L "$TARGET_PATH" ]; then
            rm -rf "$TARGET_PATH"
            echo "Removed existing configuration at $TARGET_PATH"
        fi
        # Copy new config
        cp -r "$SRC_PATH" "$TARGET_PATH"
        echo "Copied $SRC_PATH to $TARGET_PATH"
    else
        echo "Source directory $SRC_PATH does not exist. Skipping."
    fi
done


# Install necessary packages
echo "Installing necessary packages..."

# List of pacman packages to install
pacman_packages=(
    "alacritty"
    "blueman"
    "nvidia-utils"
    "w3m"
    "gzip"
    "lynx"
    "sensors"
    "xsensors"
    "pamixer"
    "hyprpolkitagent"
    "waybar"
    "dunst"
    "hyprpaer"
    "copyq"
    "ttf-nerd-fonts-symbols"
    "ttf-jetbrains-mono-nerd"
    "hypridle"
    "hyprlock"
    "hyprpaper"
    "hyprpicker"
    "fancontrol"
    "htop"
)

# Update system and install packages
echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing pacman packages..."
for package in "${pacman_packages[@]}"; do
    echo "Installing $package..."
    sudo pacman -S --noconfirm "$package"
done

# List of yay packages to install
yay_packages=(
    "pw-volume"
)

if ! command -v yay &> /dev/null; then
    echo "yay not found, installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd - || exit
    rm -rf /tmp/yay
fi

echo "Installing yay packages..."
for package in "${yay_packages[@]}"; do
    echo "Installing $package..."
    sudo yay -S --noconfirm "$package"
done

echo "All packages installed successfully!"

# Install exras

# Ask user if they want to install extras dolphin context menu
read -p "Do you want to install extras (Dolphin context menu)? (y/n): " install_extras_dolphin
if [[ ! "$install_extras_dolphin" = "y" && ! "$install_extras_dolphin" = "Y" ]]; then
    echo "Skipping extras installation."
    exit 0
else
    # Copy dolphin context menu (open with xed)
    echo "Setting up Dolphin context menu..."
    CONTEXT_MENU_DIR="$HOME/.local/share/kio/servicemenus/"
    mkdir -p "$CONTEXT_MENU_DIR"
    cp "$SRC_DIR/extras/openwithxed.desktop" "$CONTEXT_MENU_DIR"
    echo "Dolphin context menu installed."
fi

# Ask user if they want to install extras fancontrol service
read -p "Do you want to install extras (fancontrol systemd service)? (y/n): " install_extras_fancontrol
if [[ ! "$install_extras_fancontrol" = "y" && ! "$install_extras_fancontrol" = "Y" ]]; then
    echo "Skipping fancontrol service installation."
    exit 0
else
    # Install fancontrol restart systemd service
    echo "Setting up fancontrol systemd service..."
    sudo cp "$SRC_DIR/extras/fancontrol-restart.service" /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable fancontrol-restart.service
    sudo systemctl start fancontrol-restart.service
    echo "fancontrol systemd service installed and started."
fi