--- @since 26.1.22

local M = {}
local const = require(".const")
local utils = require(".utils")

function M:peek(job)
	local preload_status, preload_err = self:preload(job)
	-- Stop if preload failed
	if not preload_status then
		return
	end

	local cache_img_url = ya.file_cache({
		skip = job.skip > 90 and 90 or job.skip,
		args = job.args,
		file = job.file,
		area = job.area,
	})
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
			if job.skip > 90 then
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

	-- NOTE: Workaround case video.lua doesn't doesn't generate preview image because of `skip` overflow video duration
	if not rendered_img_rect then
		local prev_image_height = utils.get_state(const.STATE_KEY.prev_image_height)
		image_height = prev_image_height and prev_image_height[tostring(cache_img_url_no_skip)] or 0
	else
		utils.set_state(const.STATE_KEY.prev_image_height, { [tostring(cache_img_url_no_skip)] = image_height })
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

	-- NOTE: Preload image from video

	local cache_img_status, video_preload_err = require("video"):preload({
		skip = job.skip > 90 and 90 or job.skip,
		args = job.args,
		file = job.file,
		area = job.area,
	})

	if not cache_img_status and video_preload_err then
		ya.dbg("mediainfo", video_preload_err)
		err_msg = err_msg .. string.format("Failed to start `%s`.\n Do you have `%s` installed?\n", "ffmpeg", "ffmpeg")
	end

	-- NOTE: Get mediainfo and save to cache folder
	local cache_mediainfo_url = Url(tostring(ya.file_cache({ file = job.file, skip = 0 })) .. const.suffix)
	local cache_mediainfo_cha = fs.cha(cache_mediainfo_url)
	-- Case peek function called preload to refetch mediainfo
	if cache_mediainfo_cha and not job.args.force_reload_mediainfo then
		return true, err_msg ~= "" and ("Error: " .. err_msg) or nil
	end

	local output, err
	local is_valid_utf8_path = utils.is_valid_utf8(tostring(job.file.path or job.file.cache or job.file.url))
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
