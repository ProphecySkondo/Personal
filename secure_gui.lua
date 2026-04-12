local get_fallback_func = get_fallback_func or assert(get_fallback_func, "[-] get_fallback_func isn't supported")

local secure_gui = get_fallback_func("function", get_hidden_gui or gethui or function()
	if getInstance("RobloxInternalFunctions") then
		return getInstance("RobloxInternalFunctions")
	end

	local Protected = newInstance("RobloxInternalFunctions", {
		className = "Folder",
		parent = CoreGui
	}, true)

	return Protected
end)

getgenv().secure_gui = secure_gui
return secure_gui
