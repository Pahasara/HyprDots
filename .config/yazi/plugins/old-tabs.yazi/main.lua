--- @since 25.5.28

local function setup(_, opts)
	function Tabs.height()
		return 0
	end
	Header:children_add(function()
		if #cx.tabs == 0 then
			return ""
		end
		local spans = {}
		for i = 1, #cx.tabs do
			spans[#spans + 1] = ui.Span(" " .. i .. " ")
		end
		spans[cx.tabs.idx]:reverse()
		return ui.Line(spans)
	end, 9000, Header.RIGHT)
end
return { setup = setup }
