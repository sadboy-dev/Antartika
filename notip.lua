--------------------------------------------------
-- REMOTE LOGGER (LIFETIME)
--------------------------------------------------

if _G.__REMOTE_LOGGER_RUNNING then
    warn("Remote Logger already running")
    return
end
_G.__REMOTE_LOGGER_RUNNING = true

_G.REMOTE_LOGGER_ENABLED = true

print("=== REMOTE LOGGER STARTED ===")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

--------------------------------------------------
-- GUI TOGGLE (DRAGGABLE MOBILE)
--------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodModeToggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0,150,0,45)
ToggleButton.Position = UDim2.new(0,20,0,200)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextScaled = true
ToggleButton.Text = "GodMode: ON"
ToggleButton.Parent = ScreenGui

--------------------------------------------------
-- DRAG SYSTEM (TOUCH SUPPORT)
--------------------------------------------------

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

--------------------------------------------------
-- TOGGLE FUNCTION
--------------------------------------------------

ToggleButton.MouseButton1Click:Connect(function()
    _G.REMOTE_LOGGER_ENABLED = not _G.REMOTE_LOGGER_ENABLED

    if _G.REMOTE_LOGGER_ENABLED then
        ToggleButton.Text = "GodMode: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        ToggleButton.Text = "GodMode: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)

--------------------------------------------------
-- FILE LOGGER ADDITION
--------------------------------------------------

local LOG_FILE = "RemoteLog.txt"

if not isfile(LOG_FILE) then
    writefile(LOG_FILE, "=== REMOTE LOGGER STARTED ===\n")
end

local function appendLog(text)
    if not _G.REMOTE_LOGGER_ENABLED then return end
    appendfile(LOG_FILE, text .. "\n")
end

--------------------------------------------------
-- utility stringify
--------------------------------------------------

local function safeToString(v, depth)
    depth = depth or 0
    if depth > 2 then return "..." end

    if typeof(v) == "Instance" then
        return v:GetFullName()
    elseif typeof(v) == "table" then
        local t = {}
        for k,val in pairs(v) do
            table.insert(t, tostring(k).."="..safeToString(val, depth+1))
        end
        return "{"..table.concat(t,", ").."}"
    else
        return tostring(v)
    end
end

--------------------------------------------------
-- hook __namecall
--------------------------------------------------

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if not _G.REMOTE_LOGGER_ENABLED then
        return oldNamecall(self, ...)
    end

    local method = getnamecallmethod()
    local args = {...}

    if (method == "FireServer" or method == "InvokeServer")
        and typeof(self) == "Instance"
        and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then

        local info = {
            Remote = self:GetFullName(),
            Class = self.ClassName,
            Method = method,
            Args = {}
        }

        for i,v in ipairs(args) do
            info.Args[i] = safeToString(v)
        end

        local logText = "[REMOTE] "
            .. info.Method .. " "
            .. info.Class .. " "
            .. info.Remote .. " ARGS: "
            .. table.concat(info.Args, " | ")

        warn(logText)
        appendLog(logText)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

--------------------------------------------------
-- OnClientEvent receive hook
--------------------------------------------------

local function hookRemote(remote)
    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            if not _G.REMOTE_LOGGER_ENABLED then return end

            local args = {...}
            local out = {}
            for i,v in ipairs(args) do
                out[i] = safeToString(v)
            end

            local logText = "[REMOTE RECEIVE] "
                .. remote:GetFullName()
                .. " ARGS: "
                .. table.concat(out, " | ")

            warn(logText)
            appendLog(logText)
        end)
    end
end

for _,inst in ipairs(game:GetDescendants()) do
    if inst:IsA("RemoteEvent") then
        hookRemote(inst)
    end
end

game.DescendantAdded:Connect(function(inst)
    if inst:IsA("RemoteEvent") then
        hookRemote(inst)
    end
end)

print("=== REMOTE LOGGER READY ===")
appendLog("=== REMOTE LOGGER READY ===")
