local loadedInstances = {}

local function newEnv(custom, blacklist)
    blacklist = blacklist or {}
    
    local env = {
        VERSION = "1.1.1-dbg",
        game = game,
        workspace = workspace,
        Instance = Instance,
        Vector2 = Vector2,
        Vector3 = Vector3,
        CFrame = CFrame,
        UDim2 = UDim2,
        UDim = UDim,
        Color3 = Color3,
        Enum = Enum,
        task = task,
        print = print,
        warn = warn,
        error = error,
        tonumber = tonumber,
        tostring = tostring,
        pairs = pairs,
        ipairs = ipairs,
        next = next,
        select = select,
        getfenv = getfenv,
        setfenv = setfenv,
        require = require,
        loadstring = loadstring,
        pcall = pcall,
        xpcall = xpcall,
        math = math,
        table = table,
        string = string,
        coroutine = coroutine,
        debug = debug,
        tick = tick,
        os = os,
		setmetatable = setmetatable,
		shared = shared,
		_G = _G,
		getgenv = getgenv,
    }
    
    for key, _ in pairs(custom) do
        env[key] = _
    end

    for key, _ in pairs(blacklist) do
        if type(_) == "function" or (_ ~= true and _ ~= false and _ ~= nil) then
			env[key] = _
		else
			env[key] = nil
		end
    end
    
    return setmetatable(env, {
        __index = function(self, key)
			if blacklist[key] == true or blacklist[key] == false then
                return nil
			elseif blacklist[key] ~= nil then
				return blacklist[key]
            end
            return rawget(self, key) or getfenv(1)[key]
        end,
        __metatable = "The metatable is locked",
    })
end

local function makeGameProxy(overrides)
    return setmetatable({}, {
        __index = function(_, key)
            if overrides[key] then
                return overrides[key]
            end
            return game[key]
        end,
        __newindex = function(_, key, value)
            game[key] = value
        end,
        __metatable = "The metatable is locked"
    })
end

local function import(URL: string, env, blacklist)
	local success, result = xpcall(function()
		local x = loadstring(game:HttpGet(URL))
		return x
	end, function(err)
		print("[-] Failed to import URL:", URL .. " identified error:", tostring(err))
	end)
	
	if not success then
		if result then
			error()
			return result
		end
		return nil
	end

	if success then
		local fn = result	
		if env then
			setfenv(fn, newEnv(env, blacklist))
			return fn()
		end
		return fn()
	end
	return nil
end

getgenv().loadedInstances = loadedInstances
local trusted = {

}

import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/get_instance_path.lua", trusted, {})
import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/get_fallback_func.lua", trusted, {})
local newInstance, getInstance = import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/newInstance.lua", trusted, {})

import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/secure_gui.lua", trusted, {})

getgenv().get_instance_path = get_instance_path
getgenv().newInstance = newInstance
getgenv().getInstance = getInstance
getgenv().newEnv = newEnv
getgenv().import = import
getgenv().makeGameProxy = makeGameProxy
