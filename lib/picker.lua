local M = {}

local NAME_W = 26

local function pad(str, width)
	if #str >= width then
		return str:sub(1, width)
	end
	return str .. string.rep(" ", width - #str)
end

function M.pick(projects)
	-- Write sorted order to a temp file for the enrich script
	local order_file = os.tmpname()
	local f = io.open(order_file, "w")
	if not f then
		return nil
	end

	-- Build initial lines (names only, padded to match enriched format)
	local lines = {}
	for _, proj in ipairs(projects) do
		f:write(proj.name .. "\t" .. proj.path .. "\n")
		table.insert(lines, pad(proj.name, NAME_W))
	end
	f:close()
	local input = table.concat(lines, "\n")

	-- Header with blank line below for spacing
	local header = pad("PROJECT", NAME_W)
		.. pad("BRANCH", 30)
		.. pad("  MOD", 7)
		.. pad("  TMX", 7)
		.. "AGE"
		.. "\n"

	-- Resolve enrich script path relative to this file
	local info = debug.getinfo(1, "S")
	local lib_dir = info.source:match("^@(.+)/[^/]+$")
	local enrich = lib_dir .. "/../bin/tswitch-enrich"

	-- Preview: show directory listing of the selected project
	local projects_dir = os.getenv("HOME") .. "/work/git"
	local preview_cmd = "ls -1p " .. projects_dir .. "/{1} 2>/dev/null"

	-- fzf: show names instantly, reload with enriched data on start
	-- --layout=reverse: prompt+header at top, items below, no empty gap
	local cmd = string.format(
		"echo '%s' | fzf"
			.. " --layout=reverse"
			.. " --height=100%%"
			.. " --prompt='Project -> '"
			.. " --header=$'%s'"
			.. " --no-sort"
			.. " --preview='%s'"
			.. " --preview-window=right,30%%,border-left"
			.. " --bind='start:reload:%s %s'"
			.. " --margin=1,0,0,2",
		input, header, preview_cmd, enrich, order_file
	)

	local handle = io.popen(cmd)
	if not handle then
		os.remove(order_file)
		return nil
	end

	local result = handle:read("*l")
	handle:close()
	os.remove(order_file)

	if not result or result == "" then
		return nil
	end

	-- Extract the project name (first column)
	local chosen = result:match("^(%S+)")

	-- Find the matching project
	for _, proj in ipairs(projects) do
		if proj.name == chosen then
			return proj
		end
	end

	return nil
end

return M
