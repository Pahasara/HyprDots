--- @since 25.5.31

local skip_labels = {
	["Complete name"] = true,
	["CompleteName_Last"] = true,
	["Unique ID"] = true,
	["File size"] = true,
	["Format/Info"] = true,
	["Codec ID/Info"] = true,
	["MD5 of the unencoded content"] = true,
}

local ENTRY_ACTION = {
	toggle_metadata = "toggle-metadata",
}

local STATE_KEY = {
	units = "units",
	hide_metadata = "hide_metadata",
	prev_metadata_area = "prev_metadata_area",
	prev_peek_data = "prev_peek_data",
}

local magick_image_mimes = {
	avif = true,
	hei = true,
	heic = true,
	heif = true,
	["heif-sequence"] = true,
	["heic-sequence"] = true,
	jxl = true,
	xml = true,
	["svg+xml"] = true,
	["canon-cr2"] = true,
}

local seekable_mimes = {
	["application/postscript"] = true,
	["image/adobe.photoshop"] = true,
}

local M = {}
local suffix = "_mediainfo"
local SHELL = os.getenv("SHELL") or ""

local function is_valid_utf8(str)
	return utf8.len(str) ~= nil
end

local function path_quote(path)
	if not path or tostring(path) == "" then
		return path
	end
	local result = "'" .. string.gsub(tostring(path), "'", "'\\''") .. "'"
	return result
end

local function read_mediainfo_cached_file(file_path)
	-- Open the file in read mode
	local file = io.open(file_path, "r")

	if file then
		-- Read the entire file content
		local content = file:read("*all")
		file:close()
		return content
	end
end

local set_state = ya.sync(function(state, key, value)
	state[key] = value
end)

local get_state = ya.sync(function(state, key)
	return state[key]
end)

local force_render = ya.sync(function(_, _)
	(ui.render or ya.render)()
end)

local function image_layer_count(job)
	local cache = ya.file_cache({ file = job.file, skip = 0 })
	if not cache then
		return 0
	end
	local layer_count = get_state("f" .. tostring(cache))
	if layer_count then
		return layer_count
	end
	local output, err = Command("identify")
		:arg({ tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url) })
		:output()
	if err then
		return 0
	end
	layer_count = 0
	for line in output.stdout:gmatch("[^\r\n]+") do
		if line:match("%S") then
			layer_count = layer_count + 1
		end
	end
	set_state("f" .. tostring(cache), layer_count)
	return layer_count
end

function M:peek(job)
	local start = os.clock()
	local cache_img_url_no_skip = ya.file_cache({ file = job.file, skip = 0 })
	if not job.mime then
		return
	end
	set_state(STATE_KEY.prev_peek_data, {
		file = tostring(job.file.path or job.file.cache or job.file.url),
		mime = job.mime,
		area = {
			x = job.area.x,
			y = job.area.y,
			w = job.area.w,
			h = job.area.h,
		},
		args = job.args,
		skip = job.skip,
	})
	local is_video = string.find(job.mime, "^video/")
	local is_audio = string.find(job.mime, "^audio/")
	local is_image = string.find(job.mime, "^image/")
	local is_seekable = seekable_mimes[job.mime] or is_video
	local cache_img_url = (is_audio or is_image) and cache_img_url_no_skip

	if is_seekable then
		cache_img_url = ya.file_cache(job)
	end
	local preload_status, preload_err = self:preload(job)
	if not preload_status then
		return
	end
	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	local hide_metadata = get_state(STATE_KEY.hide_metadata)
	local mediainfo_height = 0
	local lines = {}
	local limit = job.area.h
	local last_line = 0
	local is_wrap = rt.preview.wrap == "yes"
	if not hide_metadata then
		local cache_mediainfo_path = tostring(cache_img_url_no_skip) .. suffix
		local output = read_mediainfo_cached_file(cache_mediainfo_path)
		if output then
			local max_width = math.max(1, job.area.w)
			if output:match("^Error:") then
				job.args.force_reload_mediainfo = true
				preload_status, preload_err = self:preload(job)
				if not preload_status or preload_err then
					return
				end
				output = read_mediainfo_cached_file(cache_mediainfo_path)
			end

			for str in output:gsub("\n+$", ""):gmatch("[^\n]*") do
				local label, value = str:match("(.*[^ ])  +: (.*)")
				local line
				if label then
					if not skip_labels[label] then
						line = ui.Line({
							ui.Span(label .. ": "):style(ui.Style():fg("reset"):bold()),
							ui.Span(value):style(th.spot.tbl_col or ui.Style():fg("blue")),
						})
					end
				elseif str ~= "General" then
					line = ui.Line({ ui.Span(str):style(th.spot.title or ui.Style():fg("green")) })
				end

				if line then
					local line_height = math.max(1, is_wrap and math.ceil(ui.width(line) / max_width) or 1)
					if (last_line + line_height) > job.skip then
						table.insert(lines, line)
					end
					if (last_line + line_height) >= job.skip + limit then
						last_line = job.skip + limit
						break
					end
					last_line = last_line + line_height
				end
			end
		end
		mediainfo_height = math.min(limit, last_line)
	end

	if
		(job.skip > 0 and #lines == 0 and not hide_metadata)
		and (
			not is_seekable
			or (is_video and job.skip >= 90)
			or (
				(job.mime == "image/adobe.photoshop" or job.mime == "application/postscript")
				and image_layer_count(job)
					< (1 + math.floor(
						math.max(0, get_state(STATE_KEY.units) and (job.skip / get_state(STATE_KEY.units)) or 0)
					))
			)
		)
	then
		ya.emit("peek", {
			math.max(0, job.skip - (get_state(STATE_KEY.units) or limit)),
			only_if = job.file.url,
			upper_bound = true,
		})
		return
	end
	force_render()
	-- NOTE: Hacky way to prevent image overlap with old metadata area
	if hide_metadata and get_state(STATE_KEY.prev_metadata_area) then
		ya.preview_widget(job, {
			ui.Clear(ui.Rect(get_state(STATE_KEY.prev_metadata_area))),
		})
	end
	local rendered_img_rect = cache_img_url
			and fs.cha(cache_img_url)
			and ya.image_show(
				cache_img_url,
				ui.Rect({
					x = job.area.x,
					y = job.area.y,
					w = job.area.w,
					h = mediainfo_height > 0 and math.max(job.area.h - mediainfo_height, job.area.h / 2) or job.area.h,
				})
			)
		or nil
	local image_height = rendered_img_rect and rendered_img_rect.h or 0

	-- NOTE: Workaround case audio has no cover image. Prevent regenerate preview image
	if is_audio and image_height == 1 then
		local info = ya.image_info(cache_img_url)
		if not info or (info.w == 1 and info.h == 1) then
			image_height = 0
		end
	end

	-- NOTE: Workaround case video.lua doesn't doesn't generate preview image because of `skip` overflow video duration
	if is_video and not rendered_img_rect then
		image_height = math.max(job.area.h - mediainfo_height, 0)
	end

	-- Handle image preload error
	if preload_err then
		table.insert(lines, ui.Line(tostring(preload_err)):style(th.spot.title or ui.Style():fg("red")))
	end

	ya.preview_widget(job, {
		ui.Text(lines)
			:area(ui.Rect({
				x = job.area.x,
				y = job.area.y + image_height,
				w = job.area.w,
				h = job.area.h - image_height,
			}))
			:wrap(is_wrap and ui.Wrap.YES or ui.Wrap.NO),
	})
	-- NOTE: Hacky way to prevent image overlap with old metadata area
	if not hide_metadata then
		set_state(STATE_KEY.prev_metadata_area, {
			x = job.area.x,
			y = job.area.y + image_height,
			w = job.area.w,
			h = job.area.h - image_height,
		})
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		set_state(STATE_KEY.units, job.units)
		ya.emit("peek", {
			math.max(0, cx.active.preview.skip + job.units),
			only_if = job.file.url,
		})
	end
end

function M:re_peek()
	local prev_peek_data = get_state(STATE_KEY.prev_peek_data)
	if prev_peek_data then
		prev_peek_data.file = File({
			url = Url(prev_peek_data.file),
			cha = fs.cha(Url(prev_peek_data.file)),
		})
		prev_peek_data.area = ui.area and ui.area("preview") or ui.Rect(prev_peek_data.area)

		self:peek(prev_peek_data)
	end
end

function M:preload(job)
	local cache_img_url = ya.file_cache({ file = job.file, skip = 0 })
	if not cache_img_url then
		return true
	end
	local cache_mediainfo_url = Url(tostring(cache_img_url) .. suffix)
	cache_img_url = seekable_mimes[job.mime] and ya.file_cache(job) or cache_img_url
	local cache_img_url_cha = cache_img_url and fs.cha(cache_img_url)
	local err_msg = ""
	local is_valid_utf8_path = is_valid_utf8(tostring(job.file.path or job.file.cache or job.file.url))
	-- video mimetype
	if job.mime then
		if string.find(job.mime, "^video/") then
			local cache_img_status, video_preload_err = require("video"):preload(job)
			if not cache_img_status and video_preload_err then
				err_msg = err_msg
					.. string.format("Failed to start `%s`, Do you have `%s` installed?\n", "ffmpeg", "ffmpeg")
			end
		-- audo and image mimetype
		elseif cache_img_url and (not cache_img_url_cha or cache_img_url_cha.len <= 0) then
			-- audio
			if string.find(job.mime, "^audio/") then
				local qv = 31 - math.floor(rt.preview.image_quality * 0.3)
				local audio_preload_output, audio_preload_err = Command("ffmpeg"):arg({
					"-v",
					"error",
					"-threads",
					1,
					"-skip_frame",
					"nokey",
					"-an",
					"-sn",
					"-dn",
					"-i",
					tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url),
					"-vframes",
					1,
					"-q:v",
					qv,
					"-vf",
					string.format("scale=-1:'min(%d,ih)':flags=fast_bilinear", rt.preview.max_height / 2),
					"-f",
					"image2",
					"-y",
					tostring(cache_img_url),
				}):output()
				-- NOTE: Some audio types doesn't have cover image -> error ""
				if
					(audio_preload_output and audio_preload_output.stderr ~= nil and audio_preload_output.stderr ~= "")
					or audio_preload_err
				then
					err_msg = err_msg
						.. string.format("Failed to start `%s`, Do you have `%s` installed?\n", "ffmpeg", "ffmpeg")
				else
					cache_img_url_cha, _ = fs.cha(cache_img_url)
					if not cache_img_url_cha then
						-- NOTE: Workaround case audio has no cover image. Prevent regenerate preview image
						audio_preload_output, audio_preload_err = require("magick")
							.with_limit()
							:arg({
								"-size",
								"1x1",
								"canvas:none",
								string.format("PNG32:%s", cache_img_url),
							})
							:output()
						if
							(audio_preload_output.stderr ~= nil and audio_preload_output.stderr ~= "")
							or audio_preload_err
						then
							err_msg = err_msg
								.. string.format(
									"Failed to start `%s`, Do you have `%s` installed?\n",
									"magick",
									"magick"
								)
						end
					end
				end
			-- image
			elseif string.find(job.mime, "^image/") or job.mime == "application/postscript" then
				local svg_plugin_ok, svg_plugin = pcall(require, "svg")
				local _, magick_plugin = pcall(require, "magick")
				local mime = job.mime:match(".*/(.*)$")

				local image_plugin = magick_image_mimes[mime]
						and ((mime == "svg+xml" and svg_plugin_ok) and svg_plugin or magick_plugin)
					or require("image")

				local cache_img_status, image_preload_err
				-- psd, ai, eps
				if mime == "adobe.photoshop" or job.mime == "application/postscript" then
					local layer_index = 0
					local units = get_state(STATE_KEY.units)
					if units ~= nil then
						local max_layer = image_layer_count(job)
						layer_index = math.floor(math.max(0, job.skip / units))
						if layer_index + 1 > max_layer then
							layer_index = max_layer - 1
						end
					end
					local cache_img_url_tmp = Url(cache_img_url .. ".tmp")
					if fs.cha(cache_img_url_tmp) then
						fs.remove("file", cache_img_url_tmp)
					end
					local tmp_file_path, _ = fs.unique_name(cache_img_url_tmp)
					cache_img_status, image_preload_err = magick_plugin
						.with_limit()
						:arg({
							"-background",
							"none",
							tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url)
								.. "["
								.. tostring(layer_index)
								.. "]",
							"-auto-orient",
							"-strip",
							"-resize",
							string.format("%dx%d>", rt.preview.max_width, rt.preview.max_height),
							"-quality",
							rt.preview.image_quality,
							string.format("PNG32:%s", tostring(tmp_file_path)),
						})
						:status()
					if cache_img_status then
						os.rename(tostring(tmp_file_path), tostring(cache_img_url))
					end
				elseif mime == "svg+xml" and not is_valid_utf8_path then
					local cache_img_url_tmp = Url(cache_img_url .. ".tmp")
					if fs.cha(cache_img_url_tmp) then
						fs.remove("file", cache_img_url_tmp)
					end
					local tmp_file_path, _ = fs.unique_name(cache_img_url_tmp)
					-- svg under invalid utf8 path
					cache_img_status, image_preload_err = magick_plugin
						.with_limit()
						:arg({
							"-background",
							"none",
							tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url),
							"-auto-orient",
							"-strip",
							"-flatten",
							"-resize",
							string.format("%dx%d>", rt.preview.max_width, rt.preview.max_height),
							"-quality",
							rt.preview.image_quality,
							string.format("PNG32:%s", tostring(tmp_file_path)),
						})
						:status()
					if cache_img_status then
						os.rename(tostring(tmp_file_path), tostring(cache_img_url))
					end
				else
					-- other image
					local no_skip_job = { skip = 0, file = job.file, args = {} }
					cache_img_status, image_preload_err = image_plugin:preload(no_skip_job)
				end
				if not cache_img_status then
					err_msg = err_msg .. (image_preload_err and (tostring(image_preload_err)) or "")
				end
			end
		end
	end
	local cache_mediainfo_cha = fs.cha(cache_mediainfo_url)
	if cache_mediainfo_cha and not job.args.force_reload_mediainfo then
		return true, err_msg ~= "" and ("Error: " .. err_msg) or nil
	end
	local cmd = "mediainfo"
	local output, err
	if is_valid_utf8_path then
		output, err = Command(cmd)
			:arg({ tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url) })
			:output()
	else
		cmd = "cd "
			.. path_quote(job.file.path or job.file.cache or (job.file.url.path or job.file.url).parent)
			.. " && "
			.. cmd
			.. " "
			.. path_quote(tostring(job.file.path or job.file.cache or job.file.url.name))
		output, err = Command(SHELL)
			:arg({ "-c", cmd })
			:arg({ tostring(job.file.path or job.file.cache or (job.file.url.path or job.file.url)) })
			:output()
	end
	if err then
		err_msg = err_msg .. string.format("Failed to start `%s`, Do you have `%s` installed?\n", cmd, cmd)
	end
	return fs.write(
		cache_mediainfo_url,
		(err_msg ~= "" and ("Error: " .. err_msg) or "") .. (output and output.stdout or "")
	)
end

function M:entry(job)
	local action = job.args[1]

	if action == ENTRY_ACTION.toggle_metadata then
		set_state(STATE_KEY.hide_metadata, not get_state(STATE_KEY.hide_metadata))
		M:re_peek()
	end
end

return M
