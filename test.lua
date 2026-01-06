--// DELTA ANDROID | NEON CHECKPOINT GUI (FINAL ULTIMATE)
--// MINIMIZE → HIDE GUI + SHOW LOGO RESTORE

if game.CoreGui:FindFirstChild("JriikGui") then
	game.CoreGui.NeonCheckpointGui:Destroy()
end

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local parentGui = gethui and gethui() or game.CoreGui

-- =====================================================
-- SAFE TELEPORT
-- =====================================================
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hrp.Anchored = true
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.CFrame = cf + Vector3.new(0,4,0)

	task.wait(0.25)
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
end

-- =====================================================
-- WALK SPEED
-- =====================================================
local walkSpeedValue = 16
local function applyWalkSpeed()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = walkSpeedValue end
end

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	applyWalkSpeed()
end)

-- =====================================================
-- CHECKPOINT DATA
-- =====================================================
local Checkpoints = {
	{name="C1", cf=CFrame.new(-3640.67,229.43,289.87), cd=80},
	{name="C2", cf=CFrame.new(1860.78,105.82,-235.41), cd=60},
	{name="Vinson", cf=CFrame.new(3731.35,1508.92,-184.39), cd=120},
	{name="C3", cf=CFrame.new(5709.64,320.89,628.29), cd=90},
	{name="C4", cf=CFrame.new(8992.34,595.60,103.32), cd=75},
	{name="Run", cf=CFrame.new(10113.24,552,35.11), cd=45},
}

-- =====================================================
-- GUI ROOT
-- =====================================================
local gui = Instance.new("ScreenGui", parentGui)
gui.Name = "JriikGui"
gui.ResetOnSpawn = false

-- =====================================================
-- MAIN FRAME
-- =====================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,240)
main.Position = UDim2.new(0.5,-140,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,8)

-- SCALE
local uiScale = Instance.new("UIScale", main)
local function autoScale()
	local v = workspace.CurrentCamera.ViewportSize
	if UIS.TouchEnabled and v.X < 900 then
		uiScale.Scale = 0.8
	elseif v.X < 1200 then
		uiScale.Scale = 0.9
	else
		uiScale.Scale = 1
	end
end
autoScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(autoScale)

-- =====================================================
-- TITLE BAR
-- =====================================================
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active = true

local title = Instance.new("TextLabel", titleBar)
title.Text = "Jriik Tools"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(0,255,255)
ti
