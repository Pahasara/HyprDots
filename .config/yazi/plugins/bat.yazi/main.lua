--- @since 25.4.8

local M = {}

function M:peek(job)
    -- Check if file exists
    if not job.file then
        return
    end

    local child = Command("bat")
        :args({
            "--style",
            "plain",
            "--color",
            "always",
            tostring(job.file.url),
        })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    local max_lines = job.area.h
    local collected_lines = ""
    local i = 0
    local last_line = 0
    local is_wrap = rt and rt.preview and rt.preview.wrap == "yes"

    repeat
        local next, event = child:read_line()
        if event == 1 then
            ya.err(tostring(event))
        elseif event ~= 0 then
            break
        end

        -- Process line
        i = i + 1
        if i > job.skip then
            -- Add the line directly to our collected text without adding extra newlines
            collected_lines = collected_lines .. next
            last_line = last_line + 1
        end
    until last_line >= max_lines

    child:start_kill()

    -- Handle pagination and upper bounds
    if job.skip > 0 and #collected_lines == 0 then
        ya.manager_emit("peek", { math.max(0, job.skip - max_lines), only_if = job.file.url, upper_bound = false })
        return
    end

    -- Process tabs
    local processed_text = collected_lines:gsub("\t", string.rep(" ", (rt and rt.preview or PREVIEW).tab_size))

    -- Create text widget with proper wrapping
    ya.preview_widgets(job, {
        ui.Text.parse(processed_text):area(job.area):wrap(is_wrap and ui.Text.WRAP or ui.Text.WRAP_NO),
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

return M
