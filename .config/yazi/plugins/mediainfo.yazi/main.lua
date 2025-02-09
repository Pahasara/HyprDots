--- @since 25.2.7

local skip_labels = {
	["Complete name"] = true,
	["CompleteName_Last"] = true,
	["Unique ID"] = true,
	["File size"] = true,
	["Format/Info"] = true,
	["Codec ID/Info"] = true,
	["MD5 of the unencoded content"] = true,
}

local M = {}
local suffix = "_mediainfo"

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

function M:peek(job)
	local start, cache_img_url = os.clock(), ya.file_cache(job)
	if not cache_img_url or not self:preload(job) then
		return
	end

	local cache_img_url_no_skip = ya.file_cache({ file = job.file, skip = 0 })
	local cache_mediainfo_path = tostring(cache_img_url_no_skip) .. suffix
	ya.sleep(math.max(0, PREVIEW.image_delay / 1000 + start - os.clock()))
	local output = read_mediainfo_cached_file(cache_mediainfo_path)

	local lines = {}

	if output then
		local i = 0
		for str in output:gmatch("[^\n]*") do
			local label, value = str:match("(.*[^ ])  +: (.*)")
			local line

			if label then
				if not skip_labels[label] then
					line = ui.Line({
						ui.Span(label .. ": "):style(ui.Style():bold()),
						ui.Span(value):style(ui.Style():fg("blue")),
					})
				end
			elseif str ~= "General" then
				line = ui.Line({ ui.Span(str):style(ui.Style():fg("green")) })
			end

			if line then
				if i >= job.skip then
					table.insert(lines, line)
				end

				local max_width = math.max(1, job.area.w - 3)
				i = i + math.max(1, math.ceil(line:width() / max_width))
			end
		end
	end

	local rendered_img_rect = ya.image_show(cache_img_url, job.area)
	local image_height = rendered_img_rect and rendered_img_rect.h or 0
	ya.preview_widgets(job, {
		ui.Text(lines)
			:area(ui.Rect({
				x = job.area.x,
				y = job.area.y + image_height,
				w = job.area.w,
				h = job.area.h - image_height,
			}))
			:wrap(ui.Text.WRAP),
	})
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		ya.manager_emit("peek", {
			math.max(0, cx.active.preview.skip + job.units),
			only_if = job.file.url,
		})
	end
end

function M:preload(job)
	local video = require("video")
	video = ya.dict_merge(video, { skip = job.skip, file = job.file })
	local cache_img_status, video_preload_err = video:preload(job)
	if not cache_img_status then
		if video_preload_err then
			return cache_img_status, video_preload_err
		else
			return cache_img_status
		end
	end

	local cache_img_url_no_skip = ya.file_cache({ file = job.file, skip = 0 })
	local cache_mediainfo_url = Url(tostring(cache_img_url_no_skip) .. suffix)

	local cha = fs.cha(cache_mediainfo_url)
	if cha and cha.len > 1000 then
		return true
	end
	local cmd = "mediainfo"
	local output, _ = Command(cmd):args({ tostring(job.file.url) }):stdout(Command.PIPED):output()
	local missing_deps_err_msg = string.format("Failed to start `%s`, Do you have `%s` installed?", cmd, cmd)
	local status = fs.write(cache_mediainfo_url, output and output.stdout or missing_deps_err_msg)

	if status then
		return true
	else
		return false
	end
end

return M
