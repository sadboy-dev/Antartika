--// DELTA ANDROID - NEON TELEPORT GUI
--// SEQUENTIAL CHECKPOINT SYSTEM (FIXED VERSION)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = gethui and gethui() or game.CoreGui

-- =====================================================
-- SAFE TELEPORT (ANTI DAMAGE + ANTI JATUH)
-- =====================================================
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist

	local origin = Vector3.new(cf.X, cf.Y + 60, cf.Z)
	local result = workspace:Raycast(origin, Vector3.new(0,-500,0), rayParams)

	local finalY = cf.Y
	if result then
		finalY = result.Position.Y + 4
	end

	hrp.Anchored = true
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.CFrame = CFrame.new(cf.X, finalY, cf.Z)

	task.wait(0.25)
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
end

player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
end)

-- =====================================================
-- CHECKPOINT DATA (URUTAN)
-- =====================================================
local Checkpoints = {
	{name="C1",     cf=CFrame.new(-3640.67,229.43,289.87), cd=80},
	{name="C2",     cf=CFrame.new(1860.78,105.82,-235.41), cd=60},
	{name="Vinson", cf=CFrame.new(3731.35,1508.92,-184.39), cd=120},
	{name="C3",     cf=CFrame.new(5709.64,320.89,628.29), cd=90},
	{name="C4",     cf=CFrame.new(8992.34,595.60,103.32), cd=75},
	{name="Run",    cf=CFrame.new(10113.24,552,35.11), cd=45},
}

-- =====================================================
-- GUI
-- =====================================================
local gui = Instance.new("ScreenGui")
gui.Parent = parentGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,250)
main.Position = UDim2.new(0.5,-150,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,6)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,38)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active = true
Instance.new("UICorner",titleBar).CornerRadius = UDim.new(0,6)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-20,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "NEON CHECKPOINT"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local holder = Instance.new("Frame", main)
holder.Size = UDim2.new(1,0,1,-38)
holder.Position = UDim2.new(0,0,0,38)
holder.BackgroundTransparency = 1

-- =====================================================
-- BUTTON SYSTEM (SEQUENTIAL - FIX)
-- =====================================================
local buttons = {}
local currentIndex = 1

local function lock(btn, txt)
	btn.Text = txt or "LOCKED"
	btn.TextColor3 = Color3.fromRGB(120,120,120)
	btn.AutoButtonColor = false
end

local function ready(btn, txt)
	btn.Text = txt
	btn.TextColor3 = Color3.fromRGB(0,255,255)
	btn.AutoButtonColor = true
end

local function startCooldown(index)
	local data = Checkpoints[index]
	local btn = buttons[index]
	if not data or not btn then return end

	lock(btn, "WAIT ("..data.cd.."s)")

	task.spawn(function()
		local start = tick()
		while tick() - start < data.cd do
			local left = math.ceil(data.cd - (tick() - start))
			btn.Text = "WAIT ("..left.."s)"
			task.wait(1)
		end
		ready(btn, data.name)
	end)
end

local function createButton(index, x, y)
	local data = Checkpoints[index]
	if not data then return end

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0,130,0,42)
	btn.Position = UDim2.new(0,x,0,y)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)

	lock(btn)

	btn.MouseButton1Click:Connect(function()
		if index ~= currentIndex then return end
		if btn.Text ~= data.name then return end

		safeTeleport(data.cf)
		lock(btn)

		currentIndex += 1
		startCooldown(currentIndex)
	end)

	buttons[index] = btn
end

-- Layout AMAN
local padX, padY, gapY = 15, 18, 55
local leftX, rightX = padX, 300 - 130 - padX

local idx = 1
for row = 0,2 do
	if Checkpoints[idx] then
		createButton(idx, leftX, padY + gapY * row)
		idx += 1
	end
	if Checkpoints[idx] then
		createButton(idx, rightX, padY + gapY * row)
		idx += 1
	end
end

-- START: hanya C1 cooldown
startCooldown(1)

-- =====================================================
-- DRAG (TOUCH + MOUSE)
-- =====================================================
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=main.Position
		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then dragging=false end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
		local delta=input.Position-dragStart
		main.Position=UDim2.new(
			startPos.X.Scale,startPos.X.Offset+delta.X,
			startPos.Y.Scale,startPos.Y.Offset+delta.Y
		)
	end
end)
