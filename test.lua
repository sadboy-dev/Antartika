--// DELTA ANDROID | NEON CHECKPOINT GUI (FINAL FULL)
--// CHECKPOINT + WALK SPEED SLIDER + AUTO SCALE + FADE

if game.CoreGui:FindFirstChild("JriikToolsV2") then
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
	if hum then
		hum.WalkSpeed = walkSpeedValue
	end
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
-- CHECKPOINT DETECT
-- =====================================================
local CHECKPOINT_RADIUS = 120
local finishedOnce = false

local function detectCheckpoint()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local closest, dist = nil, math.huge
	for i,cp in ipairs(Checkpoints) do
		local d = (hrp.Position - cp.cf.Position).Magnitude
		if d < dist then
			dist = d
			closest = i
		end
	end

	if not closest or dist > CHECKPOINT_RADIUS then
		return 0
	end
	return closest
end

-- =====================================================
-- GUI
-- =====================================================
local gui = Instance.new("ScreenGui", parentGui)
gui.Name = "JriikToolsV2"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,240)
main.Position = UDim2.new(0.5,-140,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,8)

-- UI SCALE
local uiScale = Instance.new("UIScale", main)
local function autoScaleUI()
	local v = workspace.CurrentCamera.ViewportSize
	if UIS.TouchEnabled and v.X < 900 then
		uiScale.Scale = 0.8
	elseif v.X < 1200 then
		uiScale.Scale = 0.9
	else
		uiScale.Scale = 1
	end
end
autoScaleUI()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(autoScaleUI)

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

local minimize = Instance.new("TextButton", titleBar)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.fromRGB(0,255,255)
minimize.Size = UDim2.new(0,26,0,26)
minimize.Position = UDim2.new(1,-60,0.5,-13)
minimize.BackgroundTransparency = 1

-- CONTENT
local holder = Instance.new("Frame", main)
holder.Position = UDim2.new(0,0,0,36)
holder.Size = UDim2.new(1,0,1,-36)
holder.BackgroundTransparency = 1

-- =====================================================
-- FADE SYSTEM
-- =====================================================
local function fade(container, value)
	for _,v in pairs(container:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			TweenService:Create(v,TweenInfo.new(0.25),{
				TextTransparency=value,
				BackgroundTransparency=value
			}):Play()
		elseif v:IsA("Frame") then
			TweenService:Create(v,TweenInfo.new(0.25),{
				BackgroundTransparency=value
			}):Play()
		end
	end
end

-- =====================================================
-- BUTTON SYSTEM
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
	local d,b = Checkpoints[i],buttons[i]
	if not d or not b then return end
	task.spawn(function()
		for t=d.cd,1,-1 do
			b.Text="WAIT ("..t.."s)"
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
	lock(b,"LOCKED")

	b.MouseButton1Click:Connect(function()
		if i~=currentIndex or b.Text~=d.name then return end
		safeTeleport(d.cf)
		lock(b,"DONE")
		currentIndex+=1
		if currentIndex<=#Checkpoints then
			startCooldown(currentIndex)
		end
	end)
	buttons[i]=b
end

local px,py,gy=14,14,52
local lx,rx=px,280-120-px
local idx=1
for r=0,2 do
	makeButton(idx,lx,py+r*gy); idx+=1
	makeButton(idx,rx,py+r*gy); idx+=1
end

-- =====================================================
-- WALK SPEED SLIDER
-- =====================================================
local speedFrame = Instance.new("Frame", holder)
speedFrame.Size = UDim2.new(1,-28,0,46)
speedFrame.Position = UDim2.new(0,14,1,-52)
speedFrame.BackgroundTransparency = 1

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(1,0,0,18)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed: 16"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.TextColor3 = Color3.fromRGB(0,255,255)

local bar = Instance.new("Frame", speedFrame)
bar.Size = UDim2.new(1,0,0,6)
bar.Position = UDim2.new(0,0,0,26)
bar.BackgroundColor3 = Color3.fromRGB(30,30,45)
Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

local fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,255,255)
Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame", bar)
knob.Size = UDim2.new(0,14,0,14)
knob.Position = UDim2.new(0,-7,0.5,-7)
knob.BackgroundColor3 = Color3.fromRGB(0,255,255)
Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

local dragging=false
bar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true
	end
end)

UIS.InputEnded:Connect(function() dragging=false end)

UIS.InputChanged:Connect(function(i)
	if dragging then
		local x=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
		fill.Size=UDim2.new(x,0,1,0)
		knob.Position=UDim2.new(x,-7,0.5,-7)
		walkSpeedValue=math.floor(16+x*(60-16))
		speedLabel.Text="WalkSpeed: "..walkSpeedValue
		applyWalkSpeed()
	end
end)

-- =====================================================
-- MINIMIZE WITH FADE
-- =====================================================
local minimized=false
minimize.MouseButton1Click:Connect(function()
	minimized=not minimized
	if minimized then
		fade(holder,1)
		task.delay(0.25,function()
			holder.Visible=false
			speedFrame.Visible=false
		end)
	else
		holder.Visible=true
		speedFrame.Visible=true
		fade(holder,0)
	end
	main.Size=minimized and UDim2.new(0,280,0,36) or UDim2.new(0,280,0,240)
end)

-- =====================================================
-- DRAG
-- =====================================================
local drag,ds,sp
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		drag=true ds=i.Position sp=main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if drag then
		local d=i.Position-ds
		main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function() drag=false end)
