-- REMOTE LOGGER - SMART PREDICTION (Hanya aktif saat prediksi jatuh)
-- Target: ReplicatedStorage.Events.ServerFallDamage (FireServer)
-- Auto ON/OFF berdasarkan prediksi jatuh

if hookmetamethod == nil then
    warn("Executor tidak support hookmetamethod")
    return
end

if _G.__SMART_FALL_LOGGER then
    warn("Smart God sudah berjalan")
    return
end
_G.__SMART_FALL_LOGGER = true

print("=== SMART GOD STARTED ===")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TARGET_REMOTE = "ReplicatedStorage.Events.ServerFallDamage"

local predictFalling = false

-- ================== PREDIKSI JATUH ==================
local function updateFallPrediction()
    local character = LocalPlayer.Character
    if not character then 
        predictFalling = false
        return 
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not root or not humanoid then 
        predictFalling = false
        return 
    end
    
    -- Cek 1: State Freefall / FallingDown
    local state = humanoid:GetState()
    if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.FallingDown then
        predictFalling = true
        return
    end
    
    -- Cek 2: Raycast ke bawah (50 stud)
    local rayOrigin = root.Position
    local rayDirection = Vector3.new(0, -50, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    -- Cek 3: Velocity jatuh keras
    if root.Velocity.Y < -30 or (not result and root.Position.Y < 100) then
        predictFalling = true
    else
        predictFalling = false
    end
end

-- Jalankan prediksi setiap frame (sangat ringan)
RunService.Heartbeat:Connect(updateFallPrediction)

-- ================== FUNGSI LOG ==================
local function simpleStringify(v)
    if typeof(v) == "Instance" then return v:GetFullName() end
    if typeof(v) == "table" then
        local t = {}
        for k,val in pairs(v) do t[tostring(k)] = simpleStringify(val) end
        return "{" .. table.concat(t, ", ") .. "}"
    end
    return tostring(v)
end

-- ================== HOOK NAMECALL (SMART) ==================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    -- Hanya proses jika sedang prediksi jatuh + remote target
    if predictFalling 
    and method == "FireServer"
    and self:IsA("RemoteEvent")
    and self:GetFullName() == TARGET_REMOTE then
        
        local args = {...}
        local timeStr = os.date("%Y-%m-%d %H:%M:%S")
        
        local logLine = string.format(
            "[%s] [FALL DETECTED] FireServer → %s  args(%d): ",
            timeStr, self:GetFullName(), #args
        )
        
        local argParts = {}
        for i, arg in ipairs(args) do
            table.insert(argParts, "#" .. i .. ": " .. simpleStringify(arg))
        end
        logLine = logLine .. table.concat(argParts, " | ")
        
        warn(logLine)           -- console
    end
    
    -- Selalu return original (sangat aman)
    return oldNamecall(self, ...)
end)
