local M = {}

function M.is_inside()
	return os.getenv("TMUX") ~= nil
end

function M.next_session_name()
	local handle = io.popen("tmux list-sessions -F '#{session_name}' 2>/dev/null")
	if not handle then
		return "dev"
	end

	local sessions = {}
	for line in handle:lines() do
		sessions[line] = true
	end
	handle:close()

	if not sessions["dev"] then
		return "dev"
	end

	local i = 1
	while sessions["dev" .. i] do
		i = i + 1
	end
	return "dev" .. i
end

function M.new_session(name, path)
	local session = M.next_session_name()
	os.execute(string.format('tmux new-session -d -s "%s" -n "%s" -c "%s"', session, name, path))
	os.execute(string.format('tmux attach -t "%s"', session))
end

function M.new_window(name, path)
	os.execute(string.format('tmux new-window -n "%s" -c "%s"', name, path))
end

return M
