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
        gethui = gethui,
		setmetatable = setmetatable
    }
    
    for key, _ in pairs(custom) do
        env[key] = _
    end

    for key, _ in pairs(blacklist) do
        env[key] = nil
    end
    
    return setmetatable(env, {
        __index = function(self, key)
            if blacklist[key] ~= nil then
                return nil
            end
            return getfenv(0)[key]
        end,
        __metatable = "This metatable is locked",
    })
end

return newEnv
