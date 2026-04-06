local Disassembler = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/Duck/refs/heads/main/modules/2.lua"))()
local readfile = readfile

local function disassemble_file(filePath: string, method: string?)
    local success, response = pcall(readfile, filePath)
    if not success then
        if response then
            print(response)
        end
    end
	
    local bytecode = response
    return method == "fancy" and Disassembler.FancyDisassemble(response, true, false) or Disassembler.Disassemble(response, false)
end

return disassemble_file
