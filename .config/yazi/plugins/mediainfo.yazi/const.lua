--- @since 26.1.22

local M = {}

M.skip_labels = {
	["Complete name"] = true,
	["CompleteName_Last"] = true,
	["Unique ID"] = true,
	["File size"] = true,
	["Format/Info"] = true,
	["Codec ID/Info"] = true,
	["MD5 of the unencoded content"] = true,
}

M.ENTRY_ACTION = {
	toggle_metadata = "toggle-metadata",
	toggle_preview = "toggle-preview",
	hide_metadata = "hide-metadata",
	hide_preview = "hide-preview",
	show_metadata = "show-metadata",
	show_preview = "show-preview",
	reset = "reset",
}

M.STATE_KEY = {
	units = "units",
	no_metadata = "no_metadata",
	no_preview = "no_preview",
	prev_metadata_area = "prev_metadata_area",
	prev_image_height = "prev_image_height",
	last_valid_mediainfo_skip = "last_valid_mediainfo_skip",
	cached_mediainfo = "cached_mediainfo",
	cached_job_args = "cached_job_args",
}

M.magick_image_mimes = {
	avif = true,
	hei = true,
	heic = true,
	heif = true,
	["heif-sequence"] = true,
	["heic-sequence"] = true,
	jxl = true,
	tiff = true,
	xml = true,
	-- ["svg+xml"] = true,
	["canon-cr2"] = true,
}

M.seekable_mimes = {
	-- NOTE: Adobe illustrator photoshop mimetypes
	["application/postscript"] = true,
	["application/dvb.ait"] = true,
	["application/illustrator"] = true,
	["application/vnd.adobe.illustrator"] = true,
	["image/x-eps"] = true,
	["application/eps"] = true,
	["application/pdf"] = true,

	["image/adobe.photoshop"] = true,
}

M.suffix = "_mediainfo"
M.SHELL = os.getenv("SHELL") or ""

return M
