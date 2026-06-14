# mediainfo.yazi (fork)

<!--toc:start-->

- [mediainfo.yazi (fork)](#mediainfoyazi-fork)
  - [Preview](#preview)
  - [Installation](#installation)
  - [Configuration:](#configuration)
  - [Custom theme](#custom-theme)
  <!--toc:end-->

This is a Yazi plugin for previewing media files. The preview shows thumbnail
using `ffmpeg` if available and media metadata using `mediainfo`.

> [!IMPORTANT]
> Minimum version: yazi v26.1.22.
> Check it via command `yazi --debug`

## Preview

- Video

  ![video](assets/2025-02-15-09-15-39.png)

- Audio file with cover

  ![audio_with_cover_picture](assets/2025-02-15-09-14-23.png)

- Images

  ![image](assets/2025-02-15-16-52-39.png)

- Subtitle

  ![subrip](assets/2025-02-15-16-51-11.png)

- SVG+XML file doesn't have useful information, so it only show the image preview.
- There are more file extensions which are supported by mediainfo. Just add file's MIME type to `prepend_previewers`, `prepend_preloaders`.
  Use `spotter` to determine File's MIME type. [Default is `<Tab>` key](https://github.com/sxyazi/yazi/blob/1a6abae974370702c8865459344bf256de58359e/yazi-config/preset/keymap-default.toml#L59)

## Installation

- Install mediainfo CLI:
  - [https://mediaarea.net/en/MediaInfo/Download](https://mediaarea.net/en/MediaInfo/Download)
  - Run this command in terminal to check if it's installed correctly:

    ```bash
    mediainfo --version
    ```

    If it output `Not found` then add it to your PATH environment variable. It's better to ask ChatGPT to help you (Prompt: `Add MediaInfo CLI to PATH environment variable in Windows`).

- Install ImageMagick (for linux, you can use your distro package manager to install):
  https://imagemagick.org/script/download.php
- Install this plugin:

  ```bash
  ya pkg add boydaihungst/mediainfo
  ```

## Configuration:

> [!IMPORTANT]
>
> `mediainfo` use built-in video, image, svg, magick plugins behind the scene to render preview image, song cover.
> So you can remove those 4 plugins from `prepend_preloaders` and `prepend_previewers` sections in `yazi.toml`.

If you have cache problem, run this cmd, and follow the tips: `yazi --clear-cache`

Config folder for each OS: https://yazi-rs.github.io/docs/configuration/overview.

Create `.../yazi/yazi.toml` and add:

```toml
[plugin]
  prepend_preloaders = [
    # Replace magick, image, video with mediainfo
    { mime = "{audio,video,image}/*", run = "mediainfo" },
    { mime = "application/subrip", run = "mediainfo" },

    # Adobe Photoshop is image/adobe.photoshop, already handled above
    # Adobe Illustrator
    { mime = "application/postscript", run = "mediainfo" },
    { mime = "application/illustrator", run = "mediainfo" },
    { mime = "application/dvb.ait", run = "mediainfo" },
    { mime = "application/vnd.adobe.illustrator", run = "mediainfo" },
    { mime = "image/x-eps", run = "mediainfo" },
    { mime = "application/eps", run = "mediainfo" },

    # Sometimes AI file is recognized as "application/pdf". Lmao.
    # In this case use file extension instead:
    { url = "*.{ai,eps,ait}", run = "mediainfo" },

    # Hide metadata by default.
    # Example for image mimetype:
    { mime = "{image}/*", run = "mediainfo --no-metadata" },

    # Hide image preview by default.
    # Example for video mimetype:
    { mime = "{video}/*", run = "mediainfo --no-preview" },

    # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
    # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
  ]

  prepend_previewers = [
    # Replace magick, image, video with mediainfo
    { mime = "{audio,video,image}/*", run = "mediainfo"},
    { mime = "application/subrip", run = "mediainfo" },

    # Adobe Photoshop is image/adobe.photoshop, already handled above
    # Adobe Illustrator
    { mime = "application/postscript", run = "mediainfo" },
    { mime = "application/illustrator", run = "mediainfo" },
    { mime = "application/dvb.ait", run = "mediainfo" },
    { mime = "application/vnd.adobe.illustrator", run = "mediainfo" },
    { mime = "image/x-eps", run = "mediainfo" },
    { mime = "application/eps", run = "mediainfo" },

    # Sometimes AI file is recognized as "application/pdf". Lmao.
    # In this case use file extension instead:
    { url = "*.{ai,eps,ait}", run = "mediainfo" },

    # Hide metadata by default.
    # Example for image mimetype:
    { mime = "{image}/*", run = "mediainfo --no-metadata" },

    # Hide image preview by default.
    # Example for video mimetype:
    { mime = "{video}/*", run = "mediainfo --no-preview" },

    # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
    # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
  ]

  # There are more extensions, mime types which are supported by mediainfo.
  # Just add file's MIME type to `previewers`, `preloaders` above.
  # https://mediaarea.net/en/MediaInfo/Support/Formats
  # If it's not working, file an issue at https://github.com/boydaihungst/mediainfo.yazi/issues

# For a large file like Adobe Illustrator, Adobe Photoshop, etc
# you may need to increase the memory limit if no image is rendered.
# https://yazi-rs.github.io/docs/configuration/yazi#tasks
[tasks]
  image_alloc      = 1073741824        # = 1024*1024*1024 = 1024MB

```

## Custom theme

Using the same style with spotter windows. [Read more](https://github.com/sxyazi/yazi/pull/2391)

Edit or add `yazi/theme.toml`:

```toml
[spot]
# Section header style.
# Example: Video, Text, Image,... with green color in preview images above
title = { fg = "green" }

# Value style.
# Example: `Format: FLAC` with blue color in preview images above
tbl_col = { fg = "blue" }
```

## (Optional) Keymaps to toggle/show/hide/reset metadata and preview image

> [!IMPORTANT]
> Use any key you want, but make sure there is no conflicts with [default Keybindings](https://github.com/sxyazi/yazi/blob/main/yazi-config/preset/keymap-default.toml).

Since Yazi prioritizes the first matching key, `prepend_keymap` takes precedence over defaults.
Or you can use `keymap` to replace all other keys

```toml
[mgr]
  prepend_keymap = [
    { on = "<F3>", run = "plugin mediainfo -- toggle-metadata", desc = "Toggle media preview metadata" },
    { on = "<F4>", run = "plugin mediainfo -- toggle-preview", desc = "Toggle media preview image" },

    # Hide and show metadata, image
    { on = "<F6>", run = "plugin mediainfo -- hide-metadata", desc = "Hide media preview metadata" },
    { on = "<F7>", run = "plugin mediainfo -- hide-preview", desc = "Hide media preview image" },

    { on = "<F8>", run = "plugin mediainfo -- show-metadata", desc = "Show media preview metadata" },
    { on = "<F9>", run = "plugin mediainfo -- show-preview", desc = "Show media preview image" },

    # Reset to defautl settings in yazi.toml file
    { on = "<F5>", run = "plugin mediainfo -- reset", desc = "Reset media preview to default settings" },

    # Use multiple actions
    { on = "<F10>", run = "plugin mediainfo -- --toggle-preview --toggle-metadata", desc = "Toggle both media preview image and metadata" },
    { on = "<F11>", run = "plugin mediainfo -- --show-preview --hide-metadata", desc = "Show media preview image and hide metadata" },
    # You can also use all of them together (7 actions above). Priority is reset > toggle > hide > show
    { on = "<F12>", run = "plugin mediainfo -- --show-preview --hide-metadata --reset --show-metadata --hide-preview", desc = "Show media preview image and hide metadata" },
  ]
```
