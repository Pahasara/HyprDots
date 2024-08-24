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

> [!CAUTION]
> _Please read the instructions in the sections below carefully._
> _Also, be aware that the author has an incurable obsession with `black and blue` themes._

## Nocturne
![Hyprlock](https://github.com/user-attachments/assets/6ebf0368-49b1-4fee-a2de-6e00811dcbe8)
| ![Fetch](https://github.com/user-attachments/assets/6190c118-322b-4264-89cd-427958286beb) | ![yazi](https://github.com/user-attachments/assets/c151fd97-adab-4a42-8474-a1f1d1ce7355) |
|---|---|
| ![Launcher](https://github.com/user-attachments/assets/187af624-7659-40ca-9137-57cb85ffb3c5) | ![Musikcube](https://github.com/user-attachments/assets/a56164f7-c6cf-4265-8d73-535f8b0f8920) |


## HatsuneMiku
![Fetch](https://github.com/user-attachments/assets/47311a00-beec-4445-802c-d22e7455f03b)

| ![Browser](https://github.com/user-attachments/assets/eadb2480-f8fe-4592-879e-a41542f7d296) | ![LockScreen](https://github.com/user-attachments/assets/cf798ec6-f306-4dc8-8c96-54d0c2acaa2d) |
|---|---|
| ![Vesktop](https://github.com/user-attachments/assets/7f9b83c6-1c03-47da-b5a6-4eeb230c1e8f) | ![Spotify](https://github.com/user-attachments/assets/d564219c-3574-4674-b51f-1f78747d4ca4) |
> [!IMPORTANT]
> _This repository also includes custom scripts that I use for various tasks, such as checking updates, displaying the current playing song, changing the playing song, and switching wallpapers in Hyprland using keyboard shortcuts._  
> _To ensure the setup works as intended, make sure to copy the `.scripts` directory to `$HOME/.scripts`._

> [!CAUTION]
> _This setup is designed with a strong emphasis on using keyboard shortcuts for nearly everything, from changing songs to shutting down the computer. Be sure to carefully review the [keybinds.conf](https://github.com/Pahasara/HyprDots/blob/main/Nocturne/.config/hypr/keybinds.conf) file._

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
* PDF Reader - [zathura](https://github.com/pwmt/zathura)
* Browser - [Firefox](https://www.mozilla.org/en-US/firefox/linux/)
* Media Player - [mpv](https://github.com/mpv-player/mpv)
* Music Player _(CLI)_ - [musikcube](https://github.com/clangen/musikcube)
* Download Manager _(CLI)_ - [aria2](https://github.com/aria2/aria2)

### 🌟 _Useful_
* Calculator - [rofi-calc](https://github.com/svenstaro/rofi-calc)
* Wallpaper daemon - [swww](https://github.com/LGFae/swww)
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


# **Install Instructions**

> [!CAUTION] 
> DO BACKUP YOUR CURRENT CONFIGS BEFORE PROCEEDING FURTHER . I WILL NOT BE HELD RESPONSIBLE IF YOU LOSE YOUR OLD CONFIGS .

```
git clone https://github.com/Pahasara/HyprDots.git
```

```
cd HyprDots
```

```
cp -r .scripts $HOME
```

```
cd Nocturne
```
or (only choose desired theme directory [Nocturne or HatsuneMiku])
```
cd HatsuneMiku
```

```
cp -r .config/* $HOME/.config
```

```
mkdir -p $HOME/Pictures/Wallpapers
```

```
cp -r .walls/* $HOME/Pictures/Wallpapers
```

> [!NOTE]
> _This setup is more focused on laptops rather than desktops,so i'm keeping it super simple but yeah you can also use it with desktops._   

# ❤️ Thanks for Visiting !!
I Hope You Like my project, if yes then don't forget to give it a `star` as it means a lot.

<h4> <span>· </span> <a href="https://github.com/Pahasara/HyprDots/issues"> Report Bug </a> <span> · </span> <a href="https://github.com/Pahasara/HyprDots/issues"> Request Feature </a> </h4>
