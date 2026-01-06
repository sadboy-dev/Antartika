--// DELTA ANDROID | NEON CHECKPOINT GUI
--// MANUAL GOD MODE (ANTI FALL DAMAGE FULL FIX)

if game.CoreGui:FindFirstChild("NeonCheckpointGui") then
	game.CoreGui.NeonCheckpointGui:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = gethui and gethui() or game.CoreGui

-- =====================================================
-- GOD MODE (ANTI FALL DAMAGE)
-- =====================================================
local GodMode = false
local healthConn, stateConn

local function enableGod(char)
	local hum = char:WaitForChild("Humanoid")

	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

	hum.MaxHealth = 100
	hum.Health = 100

	if healthConn then healthConn:Disconnect() end
	healthConn = hum.HealthChanged:Connect(function(h)
		if GodMode and h < 100 then
			hum.Health = 100
		end
	end)

	if stateConn then stateConn:Disconnect() end
	stateConn = hum.StateChanged:Connect(function(_, new)
		if GodMode and new == Enum.HumanoidStateType.Dead then
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			hum.Health = 100
		end
	end)
end

local function disableGod(char)
	local hum = char:FindFirstChild("Humanoid")
	if not hum then return end

	if healthConn then healthConn:Disconnect() healthConn=nil end
	if stateConn then stateConn:Disconnect() stateConn=nil end

	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
	hum.BreakJointsOnDeath = true

	hum.MaxHealth = 100
	if hum.Health > 100 then
		hum.Health = 100
	end
end

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if GodMode then
		enableGod(char)
	end
end)

-- =====================================================
-- SAFE TELEPORT (NO DAMAGE / NO FALL)
-- =====================================================
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hrp.Anchored = true
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.CFrame = cf + Vector3.new(0,4,0)
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
	{name="Run", cf=CFrame.new(10113.24,552,35.11), cd=45},
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
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,8)

-- TITLE BAR
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active = true

local title = Instance.new("TextLabel", titleBar)
title.Text = "NEON CHECKPOINT"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,10,0,0)
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

local function lock(btn,text)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(130,130,130)
	btn.AutoButtonColor = false
end

local function ready(btn,text)
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
		ready(btn,cp.name)
	end)
end

local function makeButton(i,x,y)
	local cp = Checkpoints[i]
	local b = Instance.new("TextButton", holder)
	b.Size = UDim2.new(0,120,0,38)
	b.Position = UDim2.new(0,x,0,y)
	b.BackgroundColor3 = Color3.fromRGB(25,25,35)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	lock(b,"LOCKED")

	b.MouseButton1Click:Connect(function()
		if i ~= currentIndex or b.Text ~= cp.name then return end
		safeTeleport(cp.cf)
		lock(b,"DONE")
		currentIndex += 1
		if currentIndex > #Checkpoints then
			finishedOnce = true
			return
		end
		startCooldown(currentIndex)
	end)

	buttons[i] = b
end

local px,py,gy = 14,14,52
local lx,rx = px,280-120-px
local idx=1
for r=0,2 do
	makeButton(idx,lx,py+r*gy); idx+=1
	makeButton(idx,rx,py+r*gy); idx+=1
end

-- =====================================================
-- GOD MODE TOGGLE (MANUAL)
-- =====================================================
local toggle = Instance.new("TextButton", holder)
toggle.Size = UDim2.new(1,-28,0,28)
toggle.Position = UDim2.new(0,14,1,-36)
toggle.BackgroundColor3 = Color3.fromRGB(30,20,20)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 12
toggle.TextColor3 = Color3.fromRGB(0,255,255)
toggle.Text = "GOD MODE : OFF"
Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,8)

toggle.MouseButton1Click:Connect(function()
	GodMode = not GodMode
	toggle.Text = GodMode and "GOD MODE : ON" or "GOD MODE : OFF"
	local char = player.Character
	if char then
		if GodMode then enableGod(char) else disableGod(char) end
	end
end)

-- =====================================================
-- SYNC PROGRESS
-- =====================================================
local function syncProgress()
	task.wait(1)
	local detected = detectCheckpoint()
	if finishedOnce and detected == 0 then
		currentIndex = 1
		finishedOnce = false
	else
		currentIndex = (detected == 0) and 1 or detected + 1
	end
	for i,btn in pairs(buttons) do
		if i < currentIndex then
			lock(btn,"DONE")
		elseif i == currentIndex then
			lock(btn,"WAIT")
		else
			lock(btn,"LOCKED")
		end
	end
	startCooldown(currentIndex)
end

syncProgress()
player.CharacterAdded:Connect(syncProgress)

-- =====================================================
-- MINIMIZE
-- =====================================================
local minimized=false
minimize.MouseButton1Click:Connect(function()
	minimized=not minimized
	holder.Visible=not minimized
	main.Size=minimized and UDim2.new(0,280,0,36) or UDim2.new(0,280,0,240)
end)

-- =====================================================
-- DRAG (TOUCH + MOUSE)
-- =====================================================
local drag,ds,sp
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
		drag=true ds=i.Position sp=main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if drag and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
		local d=i.Position-ds
		main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function()
	drag=false
end)
