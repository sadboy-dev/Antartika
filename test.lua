--// DELTA ANDROID - NEON TELEPORT GUI
--// SEQUENTIAL CHECKPOINT COOLDOWN SYSTEM

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
-- CHECKPOINT DATA (URUTAN + COOLDOWN)
-- =====================================================
local Checkpoints = {
	{
		name = "C1",
		cf = CFrame.new(-3640.67,229.43,289.87),
		cd = 80
	},
	{
		name = "C2",
		cf = CFrame.new(1860.78,105.82,-235.41),
		cd = 60
	},
	{
		name = "Vinson",
		cf = CFrame.new(3731.35,1508.92,-184.39),
		cd = 120
	},
	{
		name = "C3",
		cf = CFrame.new(5709.64,320.89,628.29),
		cd = 90
	},
	{
		name = "C4",
		cf = CFrame.new(8992.34,595.60,103.32),
		cd = 75
	},
	{
		name = "Run",
		cf = CFrame.new(10113.24,552,35.11),
		cd = 45
	}
}

-- =====================================================
-- GUI
-- =====================================================
local gui = Instance.new("ScreenGui", parentGui)
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
-- BUTTON SYSTEM (SEQUENTIAL)
-- =====================================================
local buttons = {}
local currentIndex = 1

local function lockButton(btn, text)
	btn.Text = text or "LOCKED"
	btn.TextColor3 = Color3.fromRGB(120,120,120)
	btn.AutoButtonColor = false
end

local function readyButton(btn, name)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(0,255,255)
	btn.AutoButtonColor = true
end

local function startCooldown(index)
	local data = Checkpoints[index]
	local btn = buttons[index]

	lockButton(btn, "WAIT ("..data.cd.."s)")

	task.spawn(function()
		local start = tick()
		while true do
			local remain = data.cd - (tick() - start)
			if remain <= 0 then
				readyButton(btn, data.name)
				break
			end
			btn.Text = "WAIT ("..math.ceil(remain).."s)"
			task.wait(1)
		end
	end)
end

local function createButton(index, x, y)
	local data = Checkpoints[index]

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0,130,0,42)
	btn.Position = UDim2.new(0,x,0,y)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)

	lockButton(btn)

	btn.MouseButton1Click:Connect(function()
		if index ~= currentIndex then return end
		if btn.Text ~= data.name then return end

		safeTeleport(data.cf)
		lockButton(btn)

		currentIndex += 1
		if Checkpoints[currentIndex] then
			startCooldown(currentIndex)
		end
	end)

	buttons[index] = btn
end

-- Layout
local padX,padY,gapY = 15,18,55
local leftX,rightX = padX,300-130-padX
local i=1
for row=0,2 do
	createButton(i,leftX,padY+gapY*row); i+=1
	createButton(i,rightX,padY+gapY*row); i+=1
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
			if input.UserInputState==Enum.UserInputState
