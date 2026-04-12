local function get_instance_path(Inst: Instance)
	local success, result = pcall(function()
		local x: string = Inst.Name
		local current = Inst.Parent

		while current do
			x = tostring(current.Name) .. '/' .. x
			if current == game then break end
			current = current.Parent
		end

		return x
	end)

	if not success then
		if result then
			print("[-] Expected success on getInstancePath, got: " .. tostring(result))
			return result
		end
		return nil
	end

	if success then
		return result
	end
end

getgenv().get_instance_path = get_instance_path

return get_instance_path
