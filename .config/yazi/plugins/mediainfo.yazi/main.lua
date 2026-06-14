--- @since 26.1.22

local M = {}
local using_new_height_api = ui.lines ~= nil
local const
local utils
local adobe
local audio
local image
local video
local none_media_preview

const = require(".const")
utils = require(".utils")

if using_new_height_api then
	ya.dbg("mediainfo", "Using yazi version >= 26.5.6")
	adobe = require(".adobe-stable")
	audio = require(".audio-stable")
	image = require(".image-stable")
	video = require(".video-stable")
	none_media_preview = require(".none-media-preview-stable")
else
	ya.dbg("mediainfo", "Using yazi version <= 26.1.22")
	adobe = require(".adobe-old")
	audio = require(".audio-old")
	image = require(".image-old")
	video = require(".video-old")
	none_media_preview = require(".none-media-preview-old")
end

function M:peek(job)
	-- debounce peek
	local start = os.clock()
	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

	-- Need mime to decide which module to use
	if not job.mime then
		return
	end

	local no_metadata_user_cfg = utils.get_state(const.STATE_KEY.no_metadata)
	if no_metadata_user_cfg ~= nil then
		job.args.no_metadata = no_metadata_user_cfg
	end

	local no_preview_user_cfg = utils.get_state(const.STATE_KEY.no_preview)
	if no_preview_user_cfg ~= nil then
		job.args.no_preview = no_preview_user_cfg
	end

	utils.set_states(const.STATE_KEY.cached_job_args, tostring(job.file.url), job.args)
	if job.args.no_preview and job.args.no_metadata then
		ya.preview_widget(job, {
			ui.Clear(job.area),
		})
		return
	end

	if job.args.no_preview then
		return none_media_preview:peek(job)
	end

	local is_video = string.find(job.mime, "^video/")
	local is_audio = string.find(job.mime, "^audio/")
	local is_image = string.find(job.mime, "^image/")
	local is_adobe = const.seekable_mimes[job.mime]

	if is_adobe then
		return adobe:peek(job)
	elseif is_image then
		return image:peek(job)
	elseif is_video then
		return video:peek(job)
	elseif is_audio then
		return audio:peek(job)
	else
		return none_media_preview:peek(job)
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		utils.set_state(const.STATE_KEY.units, job.units)
		ya.emit("peek", {
			math.max(0, cx.active.preview.skip + job.units),
			only_if = job.file.url,
		})
	end
end
function M:preload(job)
	local cache_img_url = ya.file_cache({ file = job.file, skip = 0 })
	if not cache_img_url then
		ya.dbg("mediainfo", "Can't access yazi cache folder")
		return true
	end
	if not job.mime then
		return false
	end

	local no_metadata_user_cfg = utils.get_state(const.STATE_KEY.no_metadata)
	if no_metadata_user_cfg ~= nil then
		job.args.no_metadata = no_metadata_user_cfg
	end

	local no_preview_user_cfg = utils.get_state(const.STATE_KEY.no_preview)
	if no_preview_user_cfg ~= nil then
		job.args.no_preview = no_preview_user_cfg
	end

	if job.args.no_preview and job.args.no_metadata then
		return false, nil
	end
	if job.args.no_preview then
		return none_media_preview:peek(job)
	end

	local is_video = string.find(job.mime, "^video/")
	local is_audio = string.find(job.mime, "^audio/")
	local is_image = string.find(job.mime, "^image/")
	local is_adobe = const.seekable_mimes[job.mime]

	if is_adobe then
		return adobe:preload(job)
	elseif is_image then
		return image:preload(job)
	elseif is_video then
		return video:preload(job)
	elseif is_audio then
		return audio:preload(job)
	else
		return none_media_preview:peek(job)
	end
end

function M:entry(job)
	local action = job.args[1]
	if action == const.ENTRY_ACTION.reset or job.args.reset then
		utils.set_state(const.STATE_KEY.no_preview, nil)
		utils.set_state(const.STATE_KEY.no_metadata, nil)
		ya.emit("peek", {
			force = true,
		})
		return
	end

	if action == const.ENTRY_ACTION.show_metadata or job.args.show_metadata then
		utils.set_state(const.STATE_KEY.no_metadata, false)
		ya.emit("peek", {
			force = true,
		})
	end

	if action == const.ENTRY_ACTION.show_preview or job.args.show_preview then
		utils.set_state(const.STATE_KEY.no_preview, false)
		ya.emit("peek", {
			force = true,
		})
	end

	if action == const.ENTRY_ACTION.hide_metadata or job.args.hide_metadata then
		utils.set_state(const.STATE_KEY.no_metadata, true)
		ya.emit("peek", {
			force = true,
		})
	end
	if action == const.ENTRY_ACTION.hide_preview or job.args.hide_preview then
		utils.set_state(const.STATE_KEY.no_preview, true)
		ya.emit("peek", {
			force = true,
		})
	end

	job.retry = job.retry or 0
	if job.retry > 5 then
		utils.error("Preview data is loading, try again later")
		return
	end

	local current_file = utils.current_file()
	if not current_file then
		ya.sleep(0.1)
		job.retry = job.retry + 1
		return self:entry(job)
	end

	local job_args = utils.get_states(const.STATE_KEY.cached_job_args, current_file)
	if not job_args then
		ya.sleep(0.1)
		job.retry = job.retry + 1
		return self:entry(job)
	end

	if action == const.ENTRY_ACTION.toggle_metadata or job.args.toggle_metadata then
		utils.set_state(const.STATE_KEY.no_metadata, not job_args.no_metadata)
		ya.emit("peek", {
			force = true,
		})
	end
	if action == const.ENTRY_ACTION.toggle_preview or job.args.toggle_preview then
		utils.set_state(const.STATE_KEY.no_preview, not job_args.no_preview)
		ya.emit("peek", {
			force = true,
		})
	end
end

return M
