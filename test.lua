--// DELTA SAFE | FULL READY MOBILE-FRIENDLY GUI
-- NEON GUI + SHIELD + FAIL-SAFE TELEPORT + 2-COLUMN + SMALL WALK SPEED SLIDER + DRAGABLE LOGO

-- CLEAN OLD GUI
pcall(function()
	if game.CoreGui:FindFirstChild("NeonCheckpointGui") then
		game.CoreGui.NeonCheckpointGui:Destroy()
	end
end)

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = game.CoreGui
pcall(function() if gethui then parentGui = gethui() end end)

------------------------------------------------
-- SHIELD CONFIG
------------------------------------------------
local SHIELD_HP = 1000
local shieldEnabled = true
local shieldConnection = nil
local function applyShield(character)
	if not shieldEnabled or not character then return end
	local hum = character:WaitForChild("Humanoid",5)
	if not hum then return end
	hum.MaxHealth = SHIELD_HP
	hum.Health = SHIELD_HP
	if shieldConnection then shieldConnection:Disconnect() end
	shieldConnection = hum.HealthChanged:Connect(function(hp)
		if shieldEnabled and hp < SHIELD_HP then hum.Health = SHIELD_HP end
	end)
end

if player.Character then applyShield(player.Character) end
player.CharacterAdded:Connect(function(char) wait(0.3) applyShield(char) end)

------------------------------------------------
-- CHECKPOINT DATA
------------------------------------------------
local Checkpoints = {
	{name="C1", cf=CFrame.new(-3640.67,229.43,289.87), cd=80},
	{name="C2", cf=CFrame.new(1860.78,105.82,-235.41), cd=60},
	{name="Vinson", cf=CFrame.new(3731.35,1508.92,-184.39), cd=120},
	{name="C3", cf=CFrame.new(5709.64,320.89,628.29), cd=90},
	{name="C4", cf=CFrame.new(8992.34,595.60,103.32), cd=75},
	{name="Run", cf=CFrame.new(10113.24,552,35.11), cd=45},
}

------------------------------------------------
-- FAIL-SAFE TELEPORT
------------------------------------------------
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid",5)
	local hrp = char:WaitForChild("HumanoidRootPart",5)
	if not hum or not hrp then return end
	local targetPos = cf.Position
	local MAX_RETRY = 3
	for attempt = 1, MAX_RETRY do
		hrp.Anchored = true
		hum:ChangeState(Enum.HumanoidStateType.Physics)
		hrp.CFrame = cf + Vector3.new(0,4,0)
		wait(0.2)
		if (hrp.Position - targetPos).Magnitude < 10 then break end
	end
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	wait(0.05)
	hrp.Anchored = false
end

------------------------------------------------
-- GUI SETUP
------------------------------------------------
local gui = Instance.new("ScreenGui", parentGui)
gui.Name = "NeonCheckpointGui"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,300)
main.Position = UDim2.new(0.5,-140,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,8)

-- TITLE BAR
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active = true

local title = Instance.new("TextLabel", titleBar)
title.Text = "Jriik Tools"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,10,0,0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local close = Instance.new("TextButton", titleBar)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,80,80)
close.Size = UDim2.new(0,26,0,26)
close.Position = UDim2.new(1,-30,0.5,-13)
close.BackgroundTransparency = 1

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton", titleBar)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.fromRGB(0,255,255)
minimize.Size = UDim2.new(0,26,0,26)
minimize.Position = UDim2.new(1,-60,0.5,-13)
minimize.BackgroundTransparency = 1

-- CONTENT HOLDER
local holder = Instance.new("Frame", main)
holder.Position = UDim2.new(0,0,0,36)
holder.Size = UDim2.new(1,0,1,-36-60)
holder.BackgroundTransparency = 1

-- LOGO RESTORE
local logo = Instance.new("TextButton", gui)
logo.Text = "⚡"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 22
logo.TextColor3 = Color3.fromRGB(0,255,255)
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,20,0.5,-22)
logo.BackgroundColor3 = Color3.fromRGB(15,15,20)
logo.Visible = false
Instance.new("UICorner",logo).CornerRadius = UDim.new(1,0)

------------------------------------------------
-- BUTTON SYSTEM 2-COLUMN
------------------------------------------------
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
	local d = Checkpoints[i]
	local b = buttons[i]
	if not d or not b then return end
	task.spawn(function()
		for t=d.cd,1,-1 do
			b.Text = "WAIT ("..t.."s)"
			wait(1)
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
	lock(b,"LOCKED")
	b.MouseButton1Click:Connect(function()
		if i ~= currentIndex or b.Text ~= d.name then return end
		safeTeleport(d.cf)
		lock(b,"DONE")
		currentIndex += 1
		if currentIndex <= #Checkpoints then startCooldown(currentIndex) end
	end)
	buttons[i] = b
end

-- LAYOUT 2-COLUMN
local px,py,gy = 14,14,52
local lx,rx = px,280-120-px
local idx=1
for r=0,2 do
	makeButton(idx,lx,py+r*gy); idx+=1
	makeButton(idx,rx,py+r*gy); idx+=1
end
for i,btn in pairs(buttons) do
	if i == 1 then lock(btn,"WAIT") else lock(btn,"LOCKED") end
end
startCooldown(1)

------------------------------------------------
-- SMALL WALK SPEED SLIDER
------------------------------------------------
local sliderHolder = Instance.new("Frame", main)
sliderHolder.Size = UDim2.new(1,-40,0,40)
sliderHolder.Position = UDim2.new(0,20,1,-50)
sliderHolder.BackgroundColor3 = Color3.fromRGB(25,25,35)
Instance.new("UICorner",sliderHolder).CornerRadius = UDim.new(0,8)

local sliderLabel = Instance.new("TextLabel", sliderHolder)
sliderLabel.Text = "WalkSpeed: 16"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 13
sliderLabel.TextColor3 = Color3.fromRGB(0,255,255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Size = UDim2.new(1,0,0.4,0)
sliderLabel.Position = UDim2.new(0,0,0,0)

local slider = Instance.new("Frame", sliderHolder)
slider.Size = UDim2.new(0.16,0,0.4,10)
slider.Position = UDim2.new(0,0,0.6,0)
slider.BackgroundColor3 = Color3.fromRGB(0,255,255)
Instance.new("UICorner",slider).CornerRadius = UDim.new(0,4)

local function updateSlider(posX)
	local rel = math.clamp(posX - sliderHolder.AbsolutePosition.X,0,sliderHolder.AbsoluteSize.X)
	slider.Size = UDim2.new(rel/sliderHolder.AbsoluteSize.X,0,0.4,10)
	local speed = math.floor(rel/sliderHolder.AbsoluteSize.X*100)
	sliderLabel.Text = "WalkSpeed: "..speed
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	end
end

local draggingSlider = false
sliderHolder.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
		updateSlider(input.Position.X)
	end
end)
sliderHolder.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
		updateSlider(input.Position.X)
	end
end)
sliderHolder.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end)

------------------------------------------------
-- MINIMIZE / RESTORE
------------------------------------------------
minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	logo.Visible = true
	sliderHolder.Visible = false
end)
logo.MouseButton1Click:Connect(function()
	main.Visible = true
	logo.Visible = false
	sliderHolder.Visible = true
end)
close.MouseButton1Click:Connect(function()
	shieldEnabled = false
	if shieldConnection then shieldConnection:Disconnect() end
	gui:Destroy()
end)

------------------------------------------------
-- DRAG SUPPORT HP + PC + LOGO
------------------------------------------------
local dragging = false
local dragStart, startPos
local dragTarget = nil

local function dragUpdate(input)
	local delta = input.Position - dragStart
	if dragTarget then
		dragTarget.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end

-- MAIN DRAG
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		dragTarget = main
	end
end)

-- LOGO DRAG
logo.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = logo.Position
		dragTarget = logo
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
		dragUpdate(input)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging = false
		dragTarget = nil
	end
end)
