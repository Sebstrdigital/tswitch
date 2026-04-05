local M = {}

function M.pick(projects)
	-- Build the input string: one project name per line
	local lines = {}
	for _, proj in ipairs(projects) do
		table.insert(lines, proj.name)
	end
	local input = table.concat(lines, "\n")

	-- Pipe into fzf
	local cmd = string.format('echo "%s" | fzf --reverse --height=40%% --prompt="project> "', input)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local result = handle:read("*l")
	handle:close()

	if not result or result == "" then
		return nil
	end

	-- Find the matching project
	for _, proj in ipairs(projects) do
		if proj.name == result then
			return proj
		end
	end

	return nil
end

return M
