local loadedInstances = {}

local Connections: {[string]: RBXScriptConnection} = {} -- stores all the Connections in a table

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
        env[key] = nil
    end
    
    return setmetatable(env, {
        __index = function(self, key)
            if blacklist[key] ~= nil then
                return nil
            end
            return getfenv(0)[key]
        end,
        __metatable = "The metatable is locked",
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

local function Has(name: string): boolean
    return Connections[name] ~= nil
end

local function newConnection(name: string, newConn: RBXScriptConnection)
    if Connections[name] then Connections[name]:Disconnect() end
    Connections[name] = newConn
end

local function Disconnect(name: string)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

local function DisconnectGroup(prefix: string)
    for name in Connections do
        if name:sub(1, #prefix) == prefix then
            Connections[name]:Disconnect()
            Connections[name] = nil
        end
    end
end

local function clear_console()
	local S = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	print(S)
end
-- clear_console is very optimized trust

local mainEnv = {
	copyrawmetatable = import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/copyrawmetatable.lua"),
	Services = import("https://raw.githubusercontent.com/ProphecySkondo/Modules/refs/heads/main/Services.lua"),
	get_instance_path = import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/get_instance_path.lua"),
	get_fallback_func = import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/get_fallback_func.lua"),
	old_api = import("https://raw.githubusercontent.com/ProphecySkondo/finalstand/refs/heads/main/apis/main.lua"),
	loadedInstances = loadedInstances
}
local newInstance, getInstance = import("https://raw.githubusercontent.com/ProphecySkondo/Personal/refs/heads/main/newInstance.lua", mainEnv)
local Global = (getgenv and getgenv()) or _G or shared or nil

setfenv(1, newEnv(mainEnv, {}))

--# Real programming starts over here

local RunService = Services.RunService
local ReplicatedStorage = Services.ReplicatedStorage
local Players = Services.Players

local Client = Players.LocalPlayer
local DataModel = Client.Character or Client.CharacterAdded:Wait()

local _Humanoid = {
	walkspeed = 16;
	jumppower = 50;
	hipheight = 0;
	rigtype = "R6" or "R15";
}

local HumanoidMesh = nil

local function updateValues(humanoid)
	if not humanoid or not humanoid.Parent then return end
	humanoid.WalkSpeed = _Humanoid.walkspeed
	humanoid.JumpPower = _Humanoid.jumppower
	humanoid.HipHeight = _Humanoid.hipheight
end

local function hookCharacter(character)
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if not humanoid then return end

	HumanoidMesh = humanoid

	DisconnectGroup(".ValuesChanged_")

	newConnection(".ValuesChanged_WalkSpeed", humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= _Humanoid.walkspeed then
			_Humanoid.walkspeed = humanoid.WalkSpeed
			if WalkspeedSlider then
				WalkspeedSlider:SetValue(_Humanoid.walkspeed)
			end
		end
	end))

	newConnection(".ValuesChanged_JumpPower", humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if humanoid.JumpPower ~= _Humanoid.jumppower then
			_Humanoid.jumppower = humanoid.JumpPower
			if JumpPowerSlider then
				JumpPowerSlider:SetValue(_Humanoid.jumppower)
			end
		end
	end))

	newConnection(".ValuesChanged_HipHeight", humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
		if humanoid.HipHeight ~= _Humanoid.hipheight then
			_Humanoid.hipheight = humanoid.HipHeight
		end
	end))

	newConnection(".StateChanged_Local", humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Running
			or newState == Enum.HumanoidStateType.Jumping
			or newState == Enum.HumanoidStateType.Landed
			or newState == Enum.HumanoidStateType.Freefall then
			updateValues(humanoid)
		end
	end))

	task.defer(function()
		updateValues(humanoid)
	end)
end

newConnection(".CharacterAdded", Client.CharacterAdded:Connect(function(character)
	hookCharacter(character)
end))

local initialCharacter = Client.Character
if initialCharacter then
	hookCharacter(initialCharacter)
end

local MainLibrary = {
	Library = import("https://gist.githubusercontent.com/ProphecySkondo/6c6f7c95bedf4e68b434c25928587dbb/raw/f5f3e3cd151a05eb31954333666e5f7d7ad1b2b7/.lua", {}, {request = true,debug = true,setfenv = true,getfenv = true,});
	SaveManager = import("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/SaveManager.lua", {}, {request = true,debug = true,setfenv = true,getfenv = true,});
	Interface = import("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/InterfaceManager.lua", {}, {request = true,debug = true,setfenv = true,getfenv = true,});
}

local Version = "BETA 0.1"
local Options = Fluent.Options
local Icons = {
	cracked = "heart-crack",
	refresh = "refresh-cw",
	misc = "shield",
}

local Window = Fluent:CreateWindow({
    Title = "Universal Admin Hub " .. Version,
    SubTitle = "by saiscripts.vercel.app",
    TabWidth = 160,
    Size = UDim2.fromOffset(800, 460), -- Fat ass Gui
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark", -- Dark, Darker, Light Aqua, Rose, Amethyst, NSExpression
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when there's no MinimizeKeybind
})

local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = Icons.cracked });
	Abuse = Window:AddTab({ Title = "Abuse", Icon = Icons.refresh });
	Misc = Window:AddTab({ Title = "Scripts", Icon = Icons.misc });
}
-- * we can use lucide icons as said: https://lucide.dev/icons/

local Letter = Tabs.Main:AddParagraph {
	Title = "NOTE",
	Content = "if you have issues with the scripts then it's most likely you're executor\nUse Xeno",
}

local WalkspeedSlider = nil
local JumpPowerSlider = nil
local HipLengthSlider = nil

local tweaking = false

local function makeEdits()
	local Backdoor
	local AntiCheat
	local GetChatLogs
	local TweakOut
	local Movement
	local Jack
	local SkipJump
	local InstaRespawn
	local KickAll

	WalkspeedSlider = Tabs.Main:AddSlider("SpeedSlider", {
		Title = "Humanoid WalkSpeed",
		Description = "Changes the humanoid walkspeed (this is easy for games to detect, consider using a bypasser beforehand)",
		Default = 16, Min = 0, Max = 1000, Rounding = 1,
		Callback = function(Value)
			_Humanoid.walkspeed = Value
			if HumanoidMesh and HumanoidMesh.Parent then
				HumanoidMesh.WalkSpeed = Value
			end
		end
	})

	JumpPowerSlider = Tabs.Main:AddSlider("JumpPowerSlider", {
		Title = "Humanoid JumpPower",
		Description = "Changes the humanoid jump power",
		Default = 50, Min = 0, Max = 1000, Rounding = 1,
		Callback = function(Value)
			_Humanoid.jumppower = Value
			if HumanoidMesh and HumanoidMesh.Parent then
				HumanoidMesh.JumpPower = Value
			end
		end
	})

	HipLengthSlider = Tabs.Main:AddSlider("HipLengthSlider", {
		Title = "Hip Length Slider",
		Description = "Changes your hips",
		Default = 0, Min = 0, Max = 1000, Rounding = 1,
		Callback = function(Value)
			_Humanoid.hipheight = Value
			if HumanoidMesh and HumanoidMesh.Parent then
				HumanoidMesh.HipHeight = Value
			end
		end
	})

	InstaRespawn = Tabs.Main:AddToggle("InstantRespawn", {
		Title = "Instant Respawn",
		Description = "Make sure that you have replicatesignal",
		Default = false,
	})

	-- * quick lil finder, made by me :)
	Backdoor = Tabs.Main:AddButton {
		Title = "Search for backdoored remote",
		Description = "This is a lightweight backdoor scanner, doesn't include console logging",
		Callback = function()
			Window:Dialog {
				Title = "Are you sure?",
				Content = "NOTE: scanning for backdoors may get you kicked or even **banned**",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local Remote = nil
							local basicPayload = [[
								local replicated = %s
								replicated:SetAttribute("found", "%s")
							]]

							local checkThread = ReplicatedStorage:GetAttributeChangedSignal("found"):Connect(function()
								local Sai_Is_The_Goat = ReplicatedStorage:GetAttribute("found")
								if not Sai_Is_The_Goat then return end

								local Remote = Sai_Is_The_Goat

								Fluent:Notify {
									Title = "Backdoor Found!",
									Content = "Backdoor is at: " .. Remote .. " found by sai",
									Duration = 15,
								}
							end)

							for i, v in ipairs(ReplicatedStorage:GetDescendants()) do
								--if not v:IsA("RemoteEvent") or not v:IsA("RemoteFunction") then print("obj is not a remote") return end
								
								local isRemoteEvent = v:IsA("RemoteEvent")
								local isRemoteFunction = v:IsA("RemoteFunction")

								if v and typeof(v) == "Instance" then
									if isRemoteEvent then
										v:FireServer(string.format(basicPayload, ReplicatedStorage:GetFullName(), get_instance_path(v)))
									elseif isRemoteFunction then
										v:InvokeServer(string.format(basicPayload, ReplicatedStorage:GetFullName(), get_instance_path(v)))
									end
								end
							end

							if Remote == nil then
								Fluent:Notify {
									Title = "No Backdoor Found",
									Content = "Nothing was detected in replicatedstorage",
									Duration = 5,
								}
							end
						end
					},
					{
						Title = "Nevermind",
						Callback = function()
							Fluent:Notify {
								Title = "Cancelled backdoor finder",
								Content = "...",
								Duration = 3
							}
						end
					}
				}
			}
		end,
	}

	AntiCheat = Tabs.Main:AddToggle("DisableAntiCheat", {
		Title = "Disable Anti Cheat (Uses External Scripts)",
		Content = "Uses hooks",
		Default = false,
	})

	Tabs.Main:AddParagraph {
		Title = "IN DEVELOPMENT MODULES [BETA]",
		Content = "these aren't out yet",
	}

	Movement = Tabs.Main:AddDropdown("MovementSelector", { -- Finish
		Title = "Select Movement",
		Values = {"Regular", "CFrame", "Velocity", "Lag", "Spoofed(beta)"},
		Multi = false,
		Default = 1,
	})

	TweakOut = Tabs.Main:AddToggle("TweakOut", { -- Finish
		Title = "Tweak",
		Description = "Custom made by me lol",
		Default = false
	})

	Jack = Tabs.Main:AddToggle("JackOff", { -- Finish
		Title = "Start J*cking",
		Description = "Historical animation",
		Default = false
	})

	SkipJump = Tabs.Main:AddToggle("SideToSide", { -- Finish
		Title = "Side-to-side-jumping",
		Description = "Start jumping side to side really fast",
		Default = false
	})

	KickAll = Tabs.Abuse:AddButton {
		Title = "Kick All",
		Description = "Flings everyone, keeps you're pov though",
		Callback = function()
			Window:Dialog {
				Title = "Are you sure?",
				Content = "Some games have a strict policy for this, you might get banned",
				Buttons = {{
					Title = "Confirm",
					Callback = function()
						for i, v in ipairs(Players:GetPlayers()) do
							old_api:Fling(v)
						end

						Fluent:Notify {
							Title = "Finished kicking everyone",
							Content = "",
							Duration = 5
						}
					end
				}, {
					Title = "Nevermind",
					Callback = function()
						Fluent:Notify {
							Title = "Cancelled Kick All module",
							Content = "...",
							Duration = 3
						}
					end
				}}
			}
		end
	}
	
	GetChatLogs = Tabs.Misc:AddButton {
		Title = "ChatLogger",
		Description = "Starts a safe chat logger script",
		Callback = function()
			import("https://raw.githubusercontent.com/v-oidd/chat-tracker/main/chat-tracker.lua", {}, {request = true,debug = true,setfenv = true,getfenv = true,})

			Fluent:Notify {
				Title = "Protected ChatLogger script loaded!",
				Content = "Logs",
				Duration = "10",
			}
		end
	}

	InstaRespawn:OnChanged(function()
		if Options.InstantRespawn.Value == true then
			Fluent:Notify {
				Title = "Enabled instant respawn",
				Content = "",
				Duration = 5
			}

			if not replicatesignal then
				Fluent:Notify {
					Title = "'replicatesignal' doesn't exist in you're executor",
					Content = "",
					Duration = 2
				}
			end

			newConnection(".InstantRespawn", HumanoidMesh.Died:Connect(function()
				local cachedCFrame, cachedCamera = DataModel.HumanoidRootPart.CFrame, workspace.CurrentCamera
				
				replicatesignal(Client.ConnectDiedSignalBackend)
				task.delay(Players.RespawnTime - 0.165, function()
					local newCharacter = Client.Character
					if not newCharacter then return end
					local newHumanoid = newCharacter:FindFirstChildOfClass("Humanoid")
					if not newHumanoid then return end
					newHumanoid:ChangeState(15)
					task.wait(.5)
					if cachedCFrame and newCharacter:FindFirstChild("HumanoidRootPart") then
						newCharacter.HumanoidRootPart.CFrame = cachedCFrame
					end
					workspace.CurrentCamera = cachedCamera
					Fluent:Notify {
						Title = "respawned",
						Content = "",
						Duration = 2
					}
				end)
			end))
		end
	end)

	AntiCheat:OnChanged(function()
		
		if Options.DisableAntiCheat.Value == true then
			clear_console()
			Fluent:Notify {
				Title = "Executed anti cheat disabler...",
				Content = "Uses hookfunctions and getGc",
				Duration = 15
			}
		
			import("https://gist.githubusercontent.com/ProphecySkondo/3ee4179bdeadfe0dc235d31195f3a5d3/raw/e43bc09524e077f7dd59fb02f4d05783fca13728/adonis.lua", {}, {request = true}) -- removed request for safety
			import("https://gist.githubusercontent.com/ProphecySkondo/c13a9eb2ac8979c800a460e8152f09a7/raw/6204d3a9366ef24f798d315dc91a4db1317edaa3/ah.lua", {}, {request = true})
		end
	end)
end

makeEdits()

Fluent:Notify {
	Title = "Initialized",
	Content = "Created everything inside of Universal Admin Hub",
	SubContent = "https://saiscripts.vercel.app/",
	Duration = 7
}
