#!/usr/bin/env sh

set -e

PACKAGES=(
    qtile-wayland
    rofi-wayland
    stow
    zsh
    mako
    fastfetch
    emacs

    # For Jellyfin TUI
    mpv-devel


)

update_system() {
    echo ">>> Updating system..."
    sudo dnf upgrade --refresh -y
}

install_packages() {
    echo ">>> Installing packages..."
    sudo dnf install -y "${PACKAGES[@]}"
    sudo dnf install -y https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203_110809_5046fc22-1.fedora39.x86_64.rpm
    sudo dnf copr enable thechilledbuffalo/floorp
    sudo dnf install floorp
}

clone_repo () {
    cd
    git clone https://gitlab.com/lxde/dotfiles.git
    cd dotfiles
    stow .
}

setup_doom_emacs () {
    echo "cloning doom emacs"
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    echo "installing doom emacs"
    ~/.config/emacs/bin/doom install
}

update_system
install_packages
clone_repo
setup_doom_emacs

echo ">>> All done! Reboot to start using your new setup."

