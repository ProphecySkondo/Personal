loadedInstances = loadedInstances or function()
  warn("[-] loadedInstances table wasn't found")
end

local function newInstance(Name, Properties, Bool: boolean)
	local instance = Instance.new(Properties.className)
	local _debugid = instance:GetDebugId(10)
	instance.Name = Name
	instance.Parent = Properties.parent

	loadedInstances[Name] = {
		["Instance"] = instance,
		["Class"] = instance.ClassName,
		["Parent"] = instance.Parent,
		["DebugId"] = _debugid,
		["Path"] = getInstancePath(instance)
	}

	if Bool then
		return instance
	end
end

local function getInstance(Identifier)
    for Name, data in pairs(loadedInstances) do
        if Name == Identifier or data["DebugId"] == Identifier then
            return data["Instance"]
        end
    end
    return nil
end

return newInstance, getInstance
