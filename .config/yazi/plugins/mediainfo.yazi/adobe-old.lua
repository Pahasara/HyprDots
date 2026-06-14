--- @since 26.1.22

local M = {}
local const = require(".const")
local utils = require(".utils")

local function image_layer_count(job)
	local cache = ya.file_cache({ file = job.file, skip = 0 })
	if not cache then
		return 0
	end
	local layer_count = utils.get_state("f" .. tostring(cache))
	if layer_count then
		return layer_count
	end
	local output, err = Command("identify")
		:arg({ tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url) })
		:output()
	if err or not output then
		return 0
	end
	layer_count = 0
	for line in output.stdout:gmatch("[^\r\n]+") do
		if line:match("%S") then
			layer_count = layer_count + 1
		end
	end
	utils.set_state("f" .. tostring(cache), layer_count)
	return layer_count
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

			while str ~= nil do
				local next_str = iter()
				local label, value = str:match("(.*[^ ])  +: (.*)")
				local line
				if label then
					if not const.skip_labels[label] then
						line = ui.Line({
							ui.Span(label .. ": "):style(ui.Style():fg("reset"):bold()),
							ui.Span(value):style(th.spot.tbl_col or ui.Style():fg("blue")),
						})
					end
				elseif str ~= "General" then
					line = ui.Line({ ui.Span(str):style(th.spot.title or ui.Style():fg("green")) })
				end

				if line then
					local line_height = ui.height
							and ui.height(str, { width = max_width, ansi = true, wrap = rt.preview.wrap })
						or (math.max(1, is_wrap and math.ceil(ui.width(line) / max_width) or 1))
					if next_str == nil and line_height == 1 then
						EOF_mediainfo = true
					end
					if (last_line + line_height) > mediainfo_job_skip then
						table.insert(lines, line)
					end
					if (last_line + line_height) >= mediainfo_job_skip + limit then
						last_line = mediainfo_job_skip + limit
						EOF_mediainfo = false
						break
					end
					last_line = last_line + line_height
				end
				str = next_str
			end
		end
		mediainfo_height = math.min(limit, last_line)
	end

	if not no_metadata then
		if EOF_mediainfo and #lines == 0 and mediainfo_job_skip > 0 then
			if
				image_layer_count(job)
				< (
					1
					+ math.floor(
						math.max(
							0,
							utils.get_state(const.STATE_KEY.units)
									and (math.abs(job.skip / utils.get_state(const.STATE_KEY.units)))
								or 0
						)
					)
				)
			then
				ya.emit("peek", {
					math.max(0, (job.skip - (utils.get_state(const.STATE_KEY.units) or 0))),
					only_if = job.file.url,
					upper_bound = true,
				})
				return
			else
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
	if not cache_img_url_cha or cache_img_url_cha.len <= 0 then
		local cache_img_status, image_preload_err
		local layer_index = 0
		local units = utils.get_state(const.STATE_KEY.units)
		if units ~= nil then
			local max_layer = image_layer_count(job)
			layer_index = math.floor(math.max(0, math.abs(job.skip / units)))
			if layer_index + 1 > max_layer then
				layer_index = math.max(0, max_layer - 1)
			end
		end
		local cache_img_url_tmp = Url(cache_img_url .. ".tmp")
		if fs.cha(cache_img_url_tmp) then
			fs.remove("file", cache_img_url_tmp)
		end
		local tmp_file_path, _ = type(fs.unique) == "function" and fs.unique("file", cache_img_url_tmp)
			or fs.unique_name(cache_img_url_tmp)
		cache_img_status, image_preload_err = require("magick")
			.with_limit()
			:arg({
				"-background",
				"none",
				tostring(job.file.path or job.file.cache or job.file.url.path or job.file.url) .. "[" .. tostring(
					layer_index
				) .. "]",
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

		if not cache_img_status and image_preload_err then
			ya.dbg("mediainfo", image_preload_err)
			err_msg = err_msg .. (image_preload_err and (tostring(image_preload_err)) or "")
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
