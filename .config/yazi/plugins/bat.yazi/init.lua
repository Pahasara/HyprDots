local M = {}

function M:peek(job)
    local child = Command("bat")
        :args({
            "--style", "plain",
            "--color", "always",
            tostring(job.file.url),
        })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    local limit = job.area.h
    local i, lines = 0, ""
    repeat
        local next, event = child:read_line()
        if event == 1 then
            ya.err(tostring(event))
        elseif event ~= 0 then
            break
        end

        i = i + 1
        if i > job.skip then
            lines = lines .. next
        end
    until i >= job.skip + limit

    child:start_kill()
    if job.skip > 0 and i < job.skip + limit then
        ya.manager_emit(
            "peek",
            { tostring(math.max(0, i - limit)), only_if = tostring(job.file.url), upper_bound = "" }
        )
    else
        lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
        ya.preview_widgets(job, { ui.Text.parse(lines):area(job.area), })
    end
end

function M:seek(job)
    local h = cx.active.current.hovered
    if h and h.url == job.file.url then
        local step = math.floor(job.units * job.area.h / 10)
        ya.manager_emit("peek", {
            tostring(math.max(0, cx.active.preview.skip + step)),
            only_if = tostring(job.file.url),
        })
    end
end

return M
