--- @since 26.5.6

local M = {}
local const = require(".const")
local utils = require(".utils")

local function get_cover_layers(job)
	local cache = ya.file_cache({ file = job.file, skip = 0 })
	if not cache then
		return {}
	end
	local covers = utils.get_state("f" .. tostring(cache))
	if covers and type(covers) == "table" then
		return covers
	end
	local output, err = Command("ffprobe"):arg({
		"-v",
		"error",
		"-select_streams",
		"v",
		"-show_entries",
		"stream=index:stream_disposition=attached_pic",
		"-of",
		"json",
		tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url),
	}):output()
	if err or not output then
		return {}
	end
	covers = {}
	local data = ya.json_decode(output.stdout)
	if type(data.streams) == "table" then
		for _, stream in ipairs(data.streams) do
			if stream.disposition and stream.disposition.attached_pic then
				covers[#covers + 1] = stream.index
			end
		end
	end
	utils.set_state("f" .. tostring(cache), covers)
	return covers
end

function M:peek(job)
	local preload_status, preload_err = self:preload(job)
	-- Stop if preload failed
	if not preload_status then
		return
	end

	local cache_img_url = ya.file_cache(job)

	local cache_img_url_no_skip = ya.file_cache({ file = job.file, skip = 0 })

	local no_metadata = job.args.no_metadata
	local mediainfo_job_skip = job.skip
	::recalc_mediainfo_job_skip::
	local mediainfo_height = 0
	local lines = {}
	local limit = job.area.h
	local last_line = 0
	local EOF_mediainfo = true
	local is_wrap = rt.preview.wrap == "yes" or rt.preview.wrap == ui.Wrap.YES

	if not no_metadata then
		local cache_mediainfo_path = tostring(cache_img_url_no_skip) .. const.suffix
		local output = utils.read_mediainfo_cached_file(cache_mediainfo_path)
		if output then
			local max_width = math.max(1, job.area.w)
			if output:match("^Error:") then
				job.args.force_reload_mediainfo = true
				preload_status, preload_err = self:preload(job)
				if not preload_status or preload_err then
					return
				end
				output = utils.read_mediainfo_cached_file(cache_mediainfo_path)
			end

			output = output:gsub("\n+$", "")

			local iter = output:gmatch("[^\n]*")
			local str = iter()
			local opt = { ansi = true, tab_size = rt.preview.tab_size, wrap = rt.preview.wrap, width = max_width }
			while str ~= nil do
				local next_str = iter()
				local label, value = str:match("(.*[^ ])  +: (.*)")

				local line
				if label then
					if not const.skip_labels[label] then
						line = label .. ": " .. value
					end
				elseif str ~= "General" then
					line = str
				end

				if line then
					local wrapped = ui.lines(line, opt)
					local line_height = #wrapped
					local from = 1
					local to = math.min(line_height, mediainfo_job_skip + limit - last_line)

					local total_rendered_text_len = 1
					local total_label_rendered_len = 1
					local label_total_len = label and utf8.len(label .. ": ") or 0
					for j = from, to do
						local current_line_components = {}
						local wrapped_line_len = wrapped[j]:width() or 0
						local wrapped_raw =
							utils.utf8_sub(line, total_rendered_text_len, total_rendered_text_len + wrapped_line_len)
						wrapped_line_len = utf8.len(wrapped_raw)
						total_rendered_text_len = total_rendered_text_len + wrapped_line_len

						if last_line + 1 > mediainfo_job_skip then
							local label_raw = label_total_len - total_label_rendered_len <= 0 and ""
								or utils.utf8_sub(wrapped_raw, 1, label_total_len - total_label_rendered_len)
							local label_raw_len = utf8.len(label_raw)
							if label_raw_len > 0 then
								table.insert(
									current_line_components,
									ui.Span(label_raw):style(ui.Style():fg("reset"):bold())
								)
								total_label_rendered_len = total_label_rendered_len + label_raw_len
								wrapped_raw = wrapped_raw:gsub("^" .. utils.is_literal_string(label_raw), "", 1)
							end
							if total_label_rendered_len >= label_total_len then
								local value_raw = wrapped_raw
								table.insert(
									current_line_components,
									ui.Span(value_raw or ""):style(
										label and (th.spot.tbl_col or ui.Style():fg("blue"))
											or (th.spot.title or ui.Style():fg("green"))
									)
								)
							end
							table.insert(lines, ui.Line(current_line_components))
							-- last_line = last_line + 1
						else
							total_label_rendered_len = total_label_rendered_len + total_rendered_text_len
						end
						last_line = last_line + 1
						if next_str == nil and not wrapped[j + 1] then
							EOF_mediainfo = true
						end
						if last_line >= mediainfo_job_skip + limit then
							last_line = mediainfo_job_skip + limit
							EOF_mediainfo = false
							break
						end
					end
				end
				str = next_str
			end
		end
		mediainfo_height = math.min(limit, last_line)
	end

	if not no_metadata then
		if EOF_mediainfo and #lines == 0 and mediainfo_job_skip > 0 then
			local covers = get_cover_layers(job)
			local cover_index = math.floor(
				math.max(
					1,
					utils.get_state(const.STATE_KEY.units)
							and (math.abs(job.skip / utils.get_state(const.STATE_KEY.units)))
						or 0
				)
			)

			if not covers[cover_index] then
				ya.emit("peek", {
					math.max(0, (job.skip - (utils.get_state(const.STATE_KEY.units) or 0))),
					only_if = job.file.url,
					upper_bound = true,
				})
				return
			else
				-- NOTE: Recalculate mediainfo using cached latest valid skip value when reach the end of mediainfo output
				local last_valid_mediainfo_skip = utils.get_state(const.STATE_KEY.last_valid_mediainfo_skip)
				mediainfo_job_skip = last_valid_mediainfo_skip
						and last_valid_mediainfo_skip[tostring(cache_img_url_no_skip)]
					or math.max(0, mediainfo_job_skip - (utils.get_state(const.STATE_KEY.units) or 0))

				goto recalc_mediainfo_job_skip
			end
		else
			utils.set_state(
				const.STATE_KEY.last_valid_mediainfo_skip,
				{ [tostring(cache_img_url_no_skip)] = mediainfo_job_skip }
			)
		end
	end

	-- NOTE: Hacky way to prevent image overlap with old metadata area
	if utils.get_state(const.STATE_KEY.prev_metadata_area) then
		local old_metadata_area = utils.get_state(const.STATE_KEY.prev_metadata_area)
		if
			old_metadata_area.win_x == job.area.x
			and old_metadata_area.win_y == job.area.y
			and old_metadata_area.win_w == job.area.w
			and old_metadata_area.win_h == job.area.h
		then
			ya.preview_widget(job, {
				ui.Clear(ui.Rect({
					x = old_metadata_area.x,
					y = old_metadata_area.y,
					w = old_metadata_area.w,
					h = old_metadata_area.h,
				})),
			})
		end
	end
	utils.force_render()

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
	utils.set_state(const.STATE_KEY.prev_metadata_area, not no_metadata and {
		x = job.area.x,
		y = job.area.y + image_height,
		w = job.area.w,
		h = job.area.h - image_height,
		win_x = job.area.x,
		win_y = job.area.y,
		win_w = job.area.w,
		win_h = job.area.h,
	} or nil)
end

function M:preload(job)
	local cmd = "mediainfo"
	local err_msg = ""
	local is_valid_utf8_path = utils.is_valid_utf8(tostring(job.file.path or job.file.cache or job.file.url))

	-- NOTE: Preload image

	local cache_img_url = ya.file_cache(job)
	local cache_img_url_cha = cache_img_url and fs.cha(cache_img_url)

	-- NOTE: Only generate preview image when cache image is not exist
	if cache_img_url and (not cache_img_url_cha or cache_img_url_cha.len <= 0) then
		local units = utils.get_state(const.STATE_KEY.units)
		local covers = get_cover_layers(job)
		local cover_index = covers[1] or 0
		if units ~= nil then
			cover_index = math.floor(math.max(1, math.abs(job.skip / units)))
			if not covers[cover_index] then
				cover_index = math.max(0, #covers - 1)
			end
		end
		local qv = 31 - math.floor(rt.preview.image_quality * 0.3)
		local audio_preload_output, audio_preload_err = Command("ffmpeg"):arg({
			"-v",
			"error",
			"-threads",
			1,
			"-i",
			tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url),
			"-map",
			string.format("0:v:%d?", cover_index),
			"-an",
			"-sn",
			"-dn",
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
		if audio_preload_err then
			ya.dbg("mediainfo", audio_preload_err)
			err_msg = err_msg
				.. string.format(
					"Failed to start `%s`.\n Error: %s\n",
					"ffmpeg",
					tostring(audio_preload_err or (audio_preload_output and audio_preload_output.stderr or ""))
				)
		elseif
			audio_preload_output
			and type(audio_preload_output.stderr) == "string"
			and audio_preload_output.stderr:find("does not contain any stream")
		then
			ya.dbg("mediainfo", audio_preload_output and audio_preload_output.stderr)
			cache_img_url_cha, _ = fs.cha(cache_img_url)
			if cache_img_url_cha then
				fs.remove("file", Url(cache_img_url))
			end
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
				(audio_preload_output and audio_preload_output.stderr ~= nil and audio_preload_output.stderr ~= "")
				or audio_preload_err
			then
				ya.dbg("mediainfo", audio_preload_err or (audio_preload_output and audio_preload_output.stderr))
				err_msg = err_msg
					.. string.format(
						"Failed to start `%s`.\n Error: %s\n",
						"magick",
						tostring(audio_preload_err or (audio_preload_output and audio_preload_output.stderr or ""))
					)
			end
		end
	end

	-- NOTE: Get mediainfo and save to cache folder
	local cache_mediainfo_url = Url(tostring(ya.file_cache({ file = job.file, skip = 0 })) .. const.suffix)
	local cache_mediainfo_cha = fs.cha(cache_mediainfo_url)
	-- Case peek function called preload to refetch mediainfo
	if cache_mediainfo_cha and not job.args.force_reload_mediainfo then
		return true, err_msg ~= "" and ("Error: " .. err_msg) or nil
	end

	local output, err
	if is_valid_utf8_path then
		output, err = Command(cmd)
			:arg({ tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url) })
			:output()
	else
		cmd = "cd "
			.. utils.path_quote(tostring((job.file.path or job.file.cache or job.file.url.path or job.file.url).parent))
			.. " && "
			.. cmd
			.. " "
			.. utils.path_quote(tostring((job.file.path or job.file.cache or job.file.url).name))
		output, err = Command(const.SHELL):arg({ "-c", cmd }):output()
	end
	if err then
		ya.dbg("mediainfo", tostring(err))
		err_msg = err_msg .. string.format("Failed to start `%s`. \n Do you have `%s` installed?\n", cmd, cmd)
	end

	return fs.write(
		cache_mediainfo_url,
		(err_msg ~= "" and ("Error: " .. err_msg) or "") .. (output and output.stdout or "")
	)
end

return M
