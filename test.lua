--// DELTA ANDROID | NEON CHECKPOINT GUI
--// AUTO DETECT POSITION + SEQUENTIAL COOLDOWN

if game.CoreGui:FindFirstChild("NeonCheckpointGui") then
	game.CoreGui.NeonCheckpointGui:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
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
-- CHECKPOINT DATA (URUT)
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
-- DETECT CURRENT CHECKPOINT
-- =====================================================
local function detectCheckpoint()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local closestIndex = 1
	local closestDist = math.huge

	for i,cp in ipairs(Checkpoints) do
		local dist = (hrp.Position - cp.cf.Position).Magnitude
		if dist < closestDist then
			closestDist = dist
			closestIndex = i
		end
	end

	-- Jika terlalu jauh (>500 studs), anggap masih C1
	if closestDist > 500 then
		return 1
	end

	return closestIndex
end

local currentIndex = detectCheckpoint() + 1
if currentIndex > #Checkpoints then
	currentIndex = #Checkpoints
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
Instance.new("UICorner",main).CornerRadius = UDim.new(0,6)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active = true
Instance.new("UICorner",titleBar).CornerRadius = UDim.new(0,6)

local title = Instance.new("TextLabel", titleBar)
title.Text = "NEON CHECKPOINT"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.TextXAlignment = Enum.TextXAlignment.Left

local holder = Instance.new("Frame", main)
holder.Position = UDim2.new(0,0,0,36)
holder.Size = UDim2.new(1,0,1,-36)
holder.BackgroundTransparency = 1

-- =====================================================
-- BUTTON SYSTEM (AUTO PROGRESS)
-- =====================================================
local buttons = {}

local function lock(btn,txt)
	btn.Text = txt or "DONE"
	btn.TextColor3 = Color3.fromRGB(120,120,120)
	btn.AutoButtonColor = false
end

local function ready(btn,name)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(0,255,255)
	btn.AutoButtonColor = true
end

local function startCooldown(i)
	local d = Checkpoints[i]
	local b = buttons[i]
	if not d or not b then return end

	task.spawn(function()
		for t=d.cd,1,-1 do
			b.Text = "WAIT ("..t.."s)"
			task.wait(1)
		end
		ready(b,d.name)
	end)
end

local function makeButton(i,x,y)
	local d = Checkpoints[i]
	if not d then return end

	local b = Instance.new("TextButton", holder)
	b.Size = UDim2.new(0,120,0,38)
	b.Position = UDim2.new(0,x,0,y)
	b.BackgroundColor3 = Color3.fromRGB(25,25,35)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	if i < currentIndex then
		lock(b,"DONE")
	elseif i == currentIndex then
		lock(b,"WAIT")
	else
		lock(b,"LOCKED")
	end

	b.MouseButton1Click:Connect(function()
		if i ~= currentIndex or b.Text ~= d.name then return end
		safeTeleport(d.cf)
		lock(b,"DONE")
		currentIndex += 1
		startCooldown(currentIndex)
	end)

	buttons[i] = b
end

-- Layout
local px,py,gy = 14,14,52
local lx,rx = px,280-120-px
local idx=1
for r=0,2 do
	makeButton(idx,lx,py+r*gy); idx+=1
	makeButton(idx,rx,py+r*gy); idx+=1
end

-- Start cooldown sesuai posisi player
startCooldown(currentIndex)

-- =====================================================
-- DRAG TOUCH
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

UIS.InputEnded:Connect(function() drag=false end)
