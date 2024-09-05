<h3 align="center">
	<img src="https://github.com/user-attachments/assets/cd622df3-ff30-4df9-8696-2d82e443585b" width="700"/><br/>
</h3>

<p align="center">
    <a href="https://github.com/Pahasara/HyprDots/stargazers"><img src="https://img.shields.io/github/stars/Pahasara/HyprDots?colorA=32302f&colorB=ee5025&style=for-the-badge"></a>
    <a = href="https://hyprland.org">
            <img src="https://img.shields.io/badge/Arch-Hyprland-blue.svg?style=for-the-badge&labelColor=32302f&logo=&logoColor=black&color=258598"></a> 
    <a href="https://github.com/Pahasara/HyprDots/issues"><img src="https://img.shields.io/github/issues/Pahasara/HyprDots?colorA=32302f&colorB=05aa57&style=for-the-badge"></a>
    <a href="https://github.com/Pahasara/HyprDots/blob/main/LICENSE">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=32302f&colorB=b16286&logo=unlicense&logoColor=b16286&"/></a> 
</p>

> [!NOTE]
> _Please read the instructions in the sections below carefully._
> _Also, be aware that the author has an incurable obsession with `black and blue`._

## Azure
![Hyprlock](https://github.com/user-attachments/assets/bfec38cb-6b7e-442e-b269-6d9a0d015f0d)
| ![Multitask](https://github.com/user-attachments/assets/d411f77f-120a-4104-b9e3-51c0ac847706) | ![Yazi](https://github.com/user-attachments/assets/9b235f55-8732-4241-b912-6c420691778a) |
|--|--|

> [!IMPORTANT]
> _This repository also includes custom scripts that I use for various tasks, such as checking updates, displaying the current playing song, changing the playing song, and switching wallpapers in Hyprland using keyboard shortcuts._  
> _To ensure the setup works as intended, make sure to copy the `.local/bin` directory to `$HOME/.local/bin`._

> [!NOTE]
> _This setup is designed with a strong emphasis on using keyboard shortcuts for nearly everything, from changing songs to shutting down the computer. Be sure to carefully review the [keybinds.conf](https://github.com/Pahasara/HyprDots/blob/main/.config/hypr/keybinds.conf) file._

# 📦 Packages/Programs

### 🛠️ _Basic_
* Compositor - [hyprland](https://hyprland.org)
* Bar - [Waybar](https://github.com/Alexays/Waybar)
* Shell - [zsh](https://www.zsh.org/)
* Terminal - [kitty](https://github.com/kovidgoyal/kitty)
* Launcher/Wifi-menu/Powermenu - [rofi(wayland-fork)](https://archlinux.org/packages/extra/x86_64/rofi-wayland/)
* Notifications - [dunst](https://github.com/dunst-project/dunst)
* Screen Locker - [Hyprlock](https://github.com/hyprwm/hyprlock)
* Idle daemon - [Hypridle](https://github.com/hyprwm/hypridle)

### 🔧 _Necessary_
* Editor _(CLI)_ - [neovim](https://github.com/neovim/neovim)
* Clipboard Manager - [cliphist](https://github.com/sentriz/cliphist)
* File Manager _(CLI)_ - [yazi](https://github.com/sxyazi/yazi)
* Wallpaper daemon - [swww](https://github.com/LGFae/swww)
* PDF Reader - [zathura](https://github.com/pwmt/zathura)
* Browser - [Firefox](https://www.mozilla.org/en-US/firefox/linux/)
* Media Player - [mpv](https://github.com/mpv-player/mpv)
* Music Player _(CLI)_ - [musikcube](https://github.com/clangen/musikcube)

### 🌟 _Useful_
* Download Manager _(CLI)_ - [aria2](https://github.com/aria2/aria2)
* Calculator - [rofi-calc](https://github.com/svenstaro/rofi-calc)
* GUI File Manager - [nemo](https://github.com/linuxmint/nemo)
* GUI Torrent Client - [qBittorrent](https://github.com/qbittorrent/qBittorrent)
* TV Show Manager _(CLI)_ - [ZeroV3](https://github.com/Pahasara/ZeroV3)
* System Info - [neofetch](https://github.com/dylanaraps/neofetch)

### ⚙️ _Other Components_

- _`Fonts`_ - Caskaydia Mono Nerd Fonts, JetBrains Mono Nerd Fonts, Ubuntu Nerd Fonts, and Awesome Fonts
- _`vesktop`_ - Discord Client
- _`spicetify`_ - Spotify Customizer
- _`LibreOffice`_ - Alternative to MSOffice package
- _`xdg-desktop-portal-hyprland`_ - For Better Functionality and Compatibility
- _`Polkit-Gnome`_ - Authentication Agent
- _`papirus-dark`_ - Icon Theme
- _`Grimblast-git`_ _`wl-clipboard`_ - Screenshot Utility
- _`Brightnessctl`_ - Monitor and Keyboard Brightness Control
- _`Pipewire`_ - Audio Playback (pipewire, pipewire-pulse, pipewire-alsa)
- _`Wireplumber`_ - Session Manager for Pipewire
- _`nmcli`_ - Connection Manager
- _`Eza`_ - Alternative to _`ls`_ command
- _`rofi-emoji-git`_ - Emoji selector
- _`ianny`_ - Save me from myself


# 📥 Install Instructions

> [!CAUTION] 
> DO BACKUP YOUR CURRENT CONFIGS BEFORE PROCEEDING FURTHER . I WILL NOT BE HELD RESPONSIBLE IF YOU LOSE YOUR OLD CONFIGS .

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

## Nocturne
![Fetch](https://github.com/user-attachments/assets/6190c118-322b-4264-89cd-427958286beb)

## HatsuneMiku
![Fetch](https://github.com/user-attachments/assets/47311a00-beec-4445-802c-d22e7455f03b)

> [!NOTE]
> _If u like to use other than Azure (theme), follow these steps. Replace 'theme_name' with ur desired theme (Nocturne or HatsuneMiku)_   

```
cd theme_name
```
```
cp -r .config/* $HOME/.config
```
```
cp -r .walls/* $HOME/Pictures
```

# ❤️ Thanks for Visiting !!
I Hope You Like my project, if yes then don't forget to give it a `star` as it means a lot.

<h4> <span>· </span> <a href="https://github.com/Pahasara/HyprDots/issues"> Report Bug </a> <span> · </span> <a href="https://github.com/Pahasara/HyprDots/issues"> Request Feature </a> </h4>
