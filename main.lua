--// NEON CHECKPOINT GUI (NO GOD MODE)
--// DELTA ANDROID FRIENDLY

if game.CoreGui:FindFirstChild("NeonCheckpointGui") then
	game.CoreGui.NeonCheckpointGui:Destroy()
end

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = gethui and gethui() or game.CoreGui

-- =====================================================
-- SAFE TELEPORT (ANTI FALL SAAT TELEPORT SAJA)
-- =====================================================
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hrp.Anchored = true
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.CFrame = cf + Vector3.new(0,6,0)
	task.wait(0.35)
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
end

-- =====================================================
-- CHECKPOINT DATA
-- =====================================================
local Checkpoints = {
	{name="C1", cf=CFrame.new(-3640.67,229.43,289.87), cd=80},
	{name="C2", cf=CFrame.new(1860.78,105.82,-235.41), cd=60},
	{name="Vinson", cf=CFrame.new(3731.35,1508.92,-184.39), cd=120},
	{name="C3", cf=CFrame.new(5709.64,320.89,628.29), cd=90},
	{name="C4", cf=CFrame.new(8992.34,595.60,103.32), cd=75},
	{name="Run", cf=CFrame.new(10113.24,552.00,35.11), cd=45},
}

-- =====================================================
-- DETECT CHECKPOINT
-- =====================================================
local CHECKPOINT_RADIUS = 120
local finishedOnce = false

local function detectCheckpoint()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local best,dist = 0,math.huge
	for i,cp in ipairs(Checkpoints) do
		local d = (hrp.Position - cp.cf.Position).Magnitude
		if d < dist then
			dist = d
			best = i
		end
	end
	return (dist <= CHECKPOINT_RADIUS) and best or 0
end

-- =====================================================
-- GUI
-- =====================================================
local gui = Instance.new("ScreenGui", parentGui)
gui.Name = "NeonCheckpointGui"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,240)
main.Position = UDim2.new(0.5,-140,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(15,15,22)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,8)

-- TITLE BAR
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,32)
titleBar.Active = true

local title = Instance.new("TextLabel", titleBar)
title.Text = "NEON CHECKPOINT"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,10,0,0)
title.Size = UDim2.new(1,-90,1,0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE
local close = Instance.new("TextButton", titleBar)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,80,80)
close.Size = UDim2.new(0,26,0,26)
close.Position = UDim2.new(1,-30,0.5,-13)
close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- MINIMIZE
local minimize = Instance.new("TextButton", titleBar)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.fromRGB(0,255,255)
minimize.Size = UDim2.new(0,26,0,26)
minimize.Position = UDim2.new(1,-60,0.5,-13)
minimize.BackgroundTransparency = 1

-- HOLDER
local holder = Instance.new("Frame", main)
holder.Position = UDim2.new(0,0,0,36)
holder.Size = UDim2.new(1,0,1,-36)
holder.BackgroundTransparency = 1

-- =====================================================
-- CHECKPOINT BUTTONS
-- =====================================================
local buttons = {}
local currentIndex = 1

local function setLocked(btn,text)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(130,130,130)
	btn.AutoButtonColor = false
end

local function setReady(btn,text)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(0,255,255)
	btn.AutoButtonColor = true
end

local function startCooldown(i)
	local cp = Checkpoints[i]
	local btn = buttons[i]
	if not cp or not btn then return end
	task.spawn(function()
		for t=cp.cd,1,-1 do
			btn.Text = "WAIT ("..t.."s)"
			task.wait(1)
		end
		setReady(btn,cp.name)
	end)
end

local function makeButton(i,x,y)
	local cp = Checkpoints[i]
	local b = Instance.new("TextButton", holder)
	b.Size = UDim2.new(0,120,0,38)
	b.Position = UDim2.new(0,x,0,y)
	b.BackgroundColor3 = Color3.fromRGB(25,25,40)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	setLocked(b,"LOCKED")

	b.MouseButton1Click:Connect(function()
		if i ~= currentIndex or b.Text ~= cp.name then return end
		safeTeleport(cp.cf)
		setLocked(b,"DONE")
		currentIndex += 1
		if currentIndex > #Checkpoints then
			finishedOnce = true
			return
		end
		startCooldown(currentIndex)
	end)

	buttons[i] = b
end

local pad = 14
local lx = pad
local rx = 280 - 120 - pad
local y = 16
local gap = 52

local id = 1
for r=0,2 do
	makeButton(id,lx,y+r*gap); id+=1
	makeButton(id,rx,y+r*gap); id+=1
end

-- =====================================================
-- SYNC PROGRESS (RESPAWN & RESET)
-- =====================================================
local function syncProgress()
	task.wait(1)
	local detected = detectCheckpoint()

	if finishedOnce and detected == 0 then
		currentIndex = 1
		finishedOnce = false
	else
		currentIndex = detected == 0 and 1 or detected + 1
	end

	for i,b in ipairs(buttons) do
		if i < currentIndex then
			setLocked(b,"DONE")
		elseif i == currentIndex then
			setLocked(b,"WAIT")
		else
			setLocked(b,"LOCKED")
		end
	end

	startCooldown(currentIndex)
end

syncProgress()
player.CharacterAdded:Connect(syncProgress)

-- =====================================================
-- MINIMIZE
-- =====================================================
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	holder.Visible = not minimized
	main.Size = minimized and UDim2.new(0,280,0,36) or UDim2.new(0,280,0,240)
end)

-- =====================================================
-- DRAG (TOUCH + MOUSE)
-- =====================================================
local dragging,dragStart,startPos
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = i.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging = false
end)
