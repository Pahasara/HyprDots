# mediainfo.yazi

<!--toc:start-->

- [mediainfo.yazi](#mediainfo-yazi)
  - [Installation](#installation)
  <!--toc:end-->

This is a Yazi plugin for previewing media files. The preview shows thumbnail
using `ffmpeg` if available and media metadata using `mediainfo`.

> [!IMPORTANT]
> Minimum version: yazi v25.2.7.

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
- There are more extensions which are supported by mediainfo. Just add file's MIME type to `previewers`, `preloaders`.

## Installation

Install mediainfo CLI:

- [https://mediaarea.net/en/MediaInfo/Download](https://mediaarea.net/en/MediaInfo/Download)
- Run this command in terminal to check if it's installed correctly:

  ```bash
  mediainfo --version
  ```

- If it output `Not found` then add it to your PATH environment variable. It's better to ask ChatGPT to help you (Prompt: `Add MediaInfo CLI to PATH environment variable in Windows`).

Install + config this plugin:

> [!IMPORTANT] 
> `mediainfo` use video, image, svg, magick built-in plugins behind the scene to render preview image, song cover.
> So you can remove those 3 plugins from `preloaders` and `previewers` sections in `yazi.toml`.

If you have cache problem, run this cmd, and follow the tips: `yazi --clear-cache`

```bash
ya pack -a boydaihungst/mediainfo
```

Config folder for each OS: https://yazi-rs.github.io/docs/configuration/overview
Create `.../yazi/yazi.toml` and add:

```toml
[plugin]
  prepend_preloaders = [
    # Replace magick, image, video with mediainfo
    { mime = "{audio,video,image}/*", run = "mediainfo" },
    { mime = "application/subrip", run = "mediainfo" },
  ]
  prepend_previewers = [
    # Replace magick, image, video with mediainfo
    { mime = "{audio,video,image}/*", run = "mediainfo"},
    { mime = "application/subrip", run = "mediainfo" },
  ]
  # There are more extensions which are supported by mediainfo.
  # Just add file's MIME type to `previewers`, `preloaders` above.
  # https://mediaarea.net/en/MediaInfo/Support/Formats

```

## Custom theme

Using the same style with spotter
Read more: https://github.com/sxyazi/yazi/pull/2391

Edit or add `yazi/theme.toml`:

```toml
[spot]
# Section header style.
# Example: Video, Text, Image,... with green color in preview images above
title = { fg = "green" }

# Value style. Currently only support nightly.
# Example: Format: FLAC with blue color in preview images above
tbl_col = { fg = "blue" }
```
