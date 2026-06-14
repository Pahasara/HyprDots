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

	local cache_img_url_no_skip = ya.file_cache({ file = job.file, skip = 0 })

	local lines = {}
	local limit = job.area.h
	local last_line = 0
	local EOF_mediainfo = true
	local is_wrap = rt.preview.wrap == "yes" or rt.preview.wrap == ui.Wrap.YES

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
				if (last_line + line_height) > job.skip then
					table.insert(lines, line)
				end
				if (last_line + line_height) >= job.skip + limit then
					last_line = job.skip + limit
					EOF_mediainfo = false
					break
				end
				last_line = last_line + line_height
			end
			str = next_str
		end
	end

	if EOF_mediainfo and #lines == 0 and job.skip > 0 then
		ya.emit("peek", {
			math.max(0, (job.skip - (utils.get_state(const.STATE_KEY.units) or 0))),
			only_if = job.file.url,
			upper_bound = true,
		})
		return
	end

	utils.force_render()
	-- Handle preload error
	if preload_err then
		table.insert(lines, ui.Line(tostring(preload_err)):style(th.spot.title or ui.Style():fg("red")))
	end

	ya.preview_widget(job, {
		ui.Clear(job.area),
		ui.Text(lines):area(job.area):wrap(is_wrap and ui.Wrap.YES or ui.Wrap.NO),
	})

	-- NOTE: Hacky way to prevent image overlap with old metadata area
	utils.set_state(const.STATE_KEY.prev_metadata_area, {
		x = job.area.x,
		y = job.area.y,
		w = job.area.w,
		h = job.area.h,
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
