local history = require("history")

local M = {}

local PROJECTS_DIR = os.getenv("HOME") .. "/work/git"

function M.scan()
	local dirs = {}
	local handle = io.popen("ls -d " .. PROJECTS_DIR .. "/*/")
	if not handle then
		return dirs
	end

	for line in handle:lines() do
		-- Remove trailing slash
		local path = line:gsub("/$", "")
		local name = path:match(".+/(.+)$")
		if name then
			table.insert(dirs, { name = name, path = path })
		end
	end

	handle:close()
	return dirs
end

function M.sorted()
	local dirs = M.scan()
	local recent = history.read()

	-- Build a rank lookup: lower number = more recent
	local rank = {}
	for i, path in ipairs(recent) do
		rank[path] = i
	end

	table.sort(dirs, function(a, b)
		local ra = rank[a.path] or 9999
		local rb = rank[b.path] or 9999
		if ra ~= rb then
			return ra < rb
		end
		return a.name < b.name
	end)

	return dirs
end

return M
