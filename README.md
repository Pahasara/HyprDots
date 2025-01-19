<h3 align="center">
	<img src="https://github.com/user-attachments/assets/8c6f77b5-5421-4e92-b02c-bca0fd098b94" width="700"/><br/>
</h3>

<p align="center">
    <a href="https://github.com/Pahasara/HyprDots/stargazers"><img src="https://img.shields.io/github/stars/Pahasara/HyprDots?colorA=32302f&colorB=7244b3&style=for-the-badge"></a>
    <a href="https://hyprland.org"><img src="https://img.shields.io/badge/Arch-Hyprland-blue.svg?style=for-the-badge&labelColor=32302f&color=258598"></a> 
    <a href="https://github.com/Pahasara/HyprDots/last-commit"><img src="https://img.shields.io/github/last-commit/Pahasara/HyprDots?colorA=32302f&colorB=05aa57&style=for-the-badge"></a>
    <a href="https://github.com/Pahasara/HyprDots/repo-size"><img src="https://img.shields.io/github/repo-size/Pahasara/HyprDots?colorA=32302f&colorB=b16286&style=for-the-badge"></a> 
</p>

> [!NOTE]
> _Please read the instructions in the sections below carefully._  
> _Also, be aware that the author has an incurable obsession with `black and blue`._
<br>

## Main
![fetch](https://github.com/user-attachments/assets/e2103712-b7e2-40a2-8da2-67992d238567)

| ![Neovim](https://github.com/user-attachments/assets/7c7e2449-a5ce-4685-9a7b-12aafbeb8b76) | ![Zen](https://github.com/user-attachments/assets/296e750d-7424-41b9-8bdf-e2536eb49a18) |
|--|--|

| ![Yazi](https://github.com/user-attachments/assets/6cfa71af-3bae-48f7-a3b7-3ec4768d538d) | ![Hyprlock](https://github.com/user-attachments/assets/96c451da-1ced-466d-8cea-3d11af68be8c) |
|--|--|

> [!IMPORTANT]
> _This setup is designed with a strong emphasis on using keyboard shortcuts for nearly everything, from changing songs to shutting down the computer. Be sure to carefully review the [keybinds.conf](https://github.com/Pahasara/HyprDots/blob/main/.config/hypr/keybinds.conf) file._
<br>

# 📦 Packages/Programs

### 🛠️ _Basic_

| **Category**               | **Package**                                                                                                                                                                     |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Compositor**              | [Hyprland](https://hyprland.org)                                                                                                                                                |
| **Status Bar**              | [Waybar](https://github.com/Alexays/Waybar)                                                                                                                                     |
| **Terminal**                | [Kitty](https://github.com/kovidgoyal/kitty)                                                                                                                                    |
| **Launcher & Menus** | [rofi (wayland-fork)](https://archlinux.org/packages/extra/x86_64/rofi-wayland/)                                                                                                 |
| **Notifications**           | [dunst](https://github.com/dunst-project/dunst)                                                                                                                                 |
| **Screen Locker**           | [hyprlock](https://github.com/hyprwm/hyprlock)                                                                                                                                  |
| **Idle Daemon**             | [hypridle](https://github.com/hyprwm/hypridle)                                                                                                                                  |
| **Fonts**                   | [Caskaydia Mono Nerd Fonts](https://archlinux.org/packages/extra/any/ttf-cascadia-mono-nerd), [JetBrains Mono Nerd Fonts](https://archlinux.org/packages/extra/any/ttf-jetbrains-mono-nerd), [Ubuntu Nerd Fonts](https://archlinux.org/packages/extra/any/ttf-ubuntu-nerd), [Awesome Fonts](https://archlinux.org/packages/extra/any/ttf-font-awesome/) |
<br>

### 🔧 _Necessary_

| **Category**                | **Package**                                                                                                                                                                     |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Shell**                   | [zsh](https://www.zsh.org/)                                                                                                                                                     |
| **Editor**                  | [neovim](https://github.com/neovim/neovim)                                                                                                                                      |
| **Browser**                  | [Zen](https://github.com/zen-browser/desktop)                                                                                                                          |
| **Clipboard Manager**        | [cliphist](https://github.com/sentriz/cliphist)                                                                                                                                 |
| **File Manager**             | [yazi](https://github.com/sxyazi/yazi), [dolphin](https://github.com/KDE/dolphin) (GUI)                                                                                         |
| **Wallpaper Daemon**         | [swww](https://github.com/LGFae/swww)                                                                                                                                           |
| **Media Player**             | [mpv](https://github.com/mpv-player/mpv)                                                                                                                                        |
| **PDF Reader**               | [zathura](https://github.com/pwmt/zathura), [okular](https://github.com/KDE/okular) (GUI)                                                                                                                                     |
| **Music Player**       | [musikcube](https://github.com/clangen/musikcube)                                                                                                                               |
<br>

### 🌟 _Useful Tools_

| **Category**                | **Package**                                                                                                                                                                     |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Download Manager**   | [aria2](https://github.com/aria2/aria2)                                                                                                                                         |
| **Calculator**               | [rofi-calc](https://github.com/svenstaro/rofi-calc)                                                                                                                             |
| **Torrent Client**     | [qBittorrent](https://github.com/qbittorrent/qBittorrent) (GUI)                                                                                                                       |
| **TV Show Manager**    | [ZeroV3](https://github.com/Pahasara/ZeroV3)                                                                                                                                    |
| **System Info**              | [fastfetch](https://github.com/fastfetch-cli/fastfetch)                                                                                                                              |
<br>

### ⚙️ _Other Components_

- _`WhiteSur-Dark`_ - GTK Theme
- _`Vortex-Dark-Icons`_ - Icon Theme
- _`eza`_ - Alternative to _`ls`_ command
- _`xdg-desktop-portal-hyprland`_ - For Better Functionality and Compatibility
- _`polkit-kde-agent`_ - Authentication Agent
- _`brightnessctl`_ - Monitor and Keyboard Brightness Control
- _`pipewire`_ - Audio Playback (pipewire, pipewire-pulse, pipewire-alsa)
- _`wireplumber`_ - Session Manager for Pipewire
- _`nmcli`_ - Connection Manager
- _`vesktop`_ - Discord Client
- _`libreOffice-fresh`_ - Alternative to MSOffice package
- _`grimblast-git`_ _`wl-clipboard`_ - Screenshot Utility
- _`rofi-emoji-git`_ - Emoji selector
- _`udiskie`_ - USB Device Manager
- _[`ianny`](https://github.com/zefr0x/ianny)_ - Save me from myself
<br>

# 📥 Install Instructions

> [!CAUTION]
> **Backup ur current configs before proceeding further. I WILL NOT BE HELD RESPONSIBLE IF U LOSE UR OLD CONFIGS.**

```
git clone https://github.com/Pahasara/HyprDots.git
```

```
cd HyprDots
```

```
cp -r .local/* $HOME/.local
```

```
cp -r .config/* $HOME/.config
```

```
mkdir $HOME/Pictures
```

```
cp -r .walls/* $HOME/Pictures
```
<br>


# ❤️ Thanks for Visiting!
I hope u like my project! If so, don't forget to give it a `star`, as it means a lot.

<h4> <span>· </span> <a href="https://github.com/Pahasara/HyprDots/issues"> Report Bug </a> <span> · </span> <a href="https://github.com/Pahasara/HyprDots/issues"> Request Feature </a> </h4>
