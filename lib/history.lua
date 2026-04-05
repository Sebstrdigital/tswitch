local M = {}

local HISTORY_FILE = os.getenv("HOME") .. "/.tswitch_history"
local MAX_ENTRIES = 20

function M.read()
	local entries = {}
	local file = io.open(HISTORY_FILE, "r")
	if not file then
		return entries
	end

	for line in file:lines() do
		if line ~= "" then
			table.insert(entries, line)
		end
	end

	file:close()
	return entries
end

function M.record(path)
	local entries = M.read()

	-- Remove duplicate if it exists
	local filtered = {}
	for _, entry in ipairs(entries) do
		if entry ~= path then
			table.insert(filtered, entry)
		end
	end

	-- Prepend the new path
	table.insert(filtered, 1, path)

	-- Cap at max entries
	while #filtered > MAX_ENTRIES do
		table.remove(filtered)
	end

	-- Write back
	local file = io.open(HISTORY_FILE, "w")
	if not file then
		return
	end

	for _, entry in ipairs(filtered) do
		file:write(entry .. "\n")
	end

	file:close()
end

return M
