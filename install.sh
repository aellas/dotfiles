#!/usr/bin/env sh

set -e

if [[ $(id -u) != 0 ]]; then
    echo "Please run setup as 'root'"
    exit 1
fi

if [ -n "${SUDO_USER:-}" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

echo -e "\nRemoving bloatware ..."

cd bloatremover
dnf remove $(grep "^[^#]" fedora.txt)

PACKAGES=(
    niri
    rofi-wayland
    stow
    zsh
    mako
    fastfetch
    emacs
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

nerd_fonts () {
  curl -o /tmp/Iosevka.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip
  curl -o /tmp/Iosevka-term.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/IosevkaTerm.zip
  curl -o /tmp/Ubuntu.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Ubuntu.zip
  unzip /tmp/Iosevka.zip -d /usr/local/share/fonts/
  unzip /tmp/Iosevka-term.zip -d /usr/local/share/fonts/
  unzip /tmp/Ubuntu.zip -d /usr/local/share/fonts/
  fc-cache -vf /usr/local/share/fonts/
  echo "cleanup"
  sudo rm -rf /tmp/Iosevka.zip
  sudo rm -rf /tmp/Iosevka-term.zip
  sudo rm -rf /tmp/Ubuntu.zip
  echo "cleanup finished"
}

updated_system
install_packages
clone_repo
setup_theme
nerd_fonts
setup_doom_emacs

echo ">>> All done! Reboot to start using your new setup."

