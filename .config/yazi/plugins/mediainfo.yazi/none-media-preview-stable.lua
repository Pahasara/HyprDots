--- @since 26.5.6

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
				local to = math.min(line_height, job.skip + limit - last_line)

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

					if last_line + 1 > job.skip then
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
					if last_line >= job.skip + limit then
						last_line = job.skip + limit
						EOF_mediainfo = false
						break
					end
				end
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
