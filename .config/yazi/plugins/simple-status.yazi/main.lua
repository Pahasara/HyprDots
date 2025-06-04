local function spacer()
	return ui.Span(" ")
end

local function nlink()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span("")
	end

	if not h.cha.nlink then
		return ui.Span("")
	end

	return ui.Span(h.cha.nlink .. " ")
end

local function owner()
	local h = cx.active.current.hovered
	if not h or not h.cha.uid or not h.cha.gid then
		return ui.Span("")
	end

	local user = ya.user_name(h.cha.uid) or h.cha.uid
	local group = ya.group_name(h.cha.gid) or h.cha.gid

	return ui.Line(string.format("%s:%s ", user, group))
end

local function mtime()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span("")
	end

	if not h.cha.mtime then
		return ui.Span("")
	end

	return ui.Span(os.date("%Y-%m-%d %H:%M", h.cha.mtime // 1) .. " ")
end

return {
	setup = function()
		Status:children_remove(2, Status.LEFT) -- size
		Status:children_remove(5, Status.RIGHT) -- percentage

		Status:children_add(spacer, 900, Status.RIGHT)
		Status:children_add(spacer, 1100, Status.RIGHT)
		Status:children_add(nlink, 1200, Status.RIGHT)
		Status:children_add(owner, 1300, Status.RIGHT)
		Status:children_add(mtime, 1400, Status.RIGHT)
	end,
}
