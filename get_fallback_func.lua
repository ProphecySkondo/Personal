local function get_fallback_func(t, f, fallback)
	if type(f) == t then
		return f
	end

	return fallback
end

return get_fallback_func
