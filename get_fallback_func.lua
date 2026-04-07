local Global = (getgenv and getgenv())
            or _G
            or shared
            or {}

function get_fallback_func(t, f, fallback)
	if type(f) == t then
		return f
	end

	return fallback
end

Global.get_fallback_func = get_fallback_func

return get_fallback_func
