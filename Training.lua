--// DELTA SAFE | FINAL ULTRA MODERN TWEEN TELEPORT BUTTON
-- GUI + SHIELD + TELEPORT SAFE + SLIDER + DRAG + TWEEN BUTTONS

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = game.CoreGui
pcall(function() if gethui then parentGui = gethui() end end)

-- CLEAN OLD GUI
pcall(function() if parentGui:FindFirstChild("NeonCheckpointGui") then parentGui.NeonCheckpointGui:Destroy() end end)

------------------------------------------------
-- SHIELD CONFIG
------------------------------------------------
local SHIELD_HP = 1000
local shieldEnabled = true
local shieldConnection = nil
local function applyShield(char)
	if not shieldEnabled or not char then return end
	local hum = char:WaitForChild("Humanoid",5)
	if hum then
		hum.MaxHealth = SHIELD_HP
		hum.Health = SHIELD_HP
		if shieldConnection then shieldConnection:Disconnect() end
		shieldConnection = hum.HealthChanged:Connect(function(hp)
			if shieldEnabled and hp < SHIELD_HP then hum.Health = SHIELD_HP end
		end)
	end
end
if player.Character then applyShield(player.Character) end
player.CharacterAdded:Connect(applyShield)

------------------------------------------------
-- CHECKPOINT DATA
------------------------------------------------
local Checkpoints = {
	{name="C1", cf=CFrame.new(-3231.74, 1489.39, 5420.16)},
	{name="C2", cf=CFrame.new(2843.37, 574.13, -321.68)},
	{name="Tissue", cf=CFrame.new(6569.05, 332.36, 284.94)},
	{name="TanggaGoa", cf=CFrame.new(8072.17, 329.00, 412.34)},
	{name="TanggaC4", cf=CFrame.new(8258.87, 384.31, 985.75)},
	{name="Terakhir", cf=CFrame.new(9916.30, 592.29, 24.58)},
}

------------------------------------------------
-- FAIL-SAFE TELEPORT
------------------------------------------------
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid",5)
	local hrp = char:WaitForChild("HumanoidRootPart",5)
	if not hum or not hrp then return end
	-- pastikan teleport tidak jatuh di bawah tanah
	local safePos = cf.Position + Vector3.new(0,5,0)
	hrp.Anchored = true
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.CFrame = CFrame.new(safePos)
	wait(0.2)
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
end

------------------------------------------------
-- GUI SETUP
------------------------------------------------
local gui = Instance.new("ScreenGui", parentGui)
gui.Name = "NeonCheckpointGui"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,260)
main.Position = UDim2.new(0.5,-140,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius=UDim.new(0,8)

-- TITLE
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active=true

local title = Instance.new("TextLabel", titleBar)
title.Text="Jriik Tools"
title.Font=Enum.Font.GothamBold
title.TextSize=14
title.TextColor3=Color3.fromRGB(0,255,255)
title.BackgroundTransparency=1
title.Size=UDim2.new(1,-90,1,0)
title.Position=UDim2.new(0,10,0,0)
title.TextXAlignment=Enum.TextXAlignment.Left

local close = Instance.new("TextButton", titleBar)
close.Text="X"
close.Font=Enum.Font.GothamBold
close.TextSize=14
close.TextColor3=Color3.fromRGB(255,80,80)
close.Size = UDim2.new(0,26,0,26)
close.Position = UDim2.new(1,-30,0.5,-13)
close.BackgroundTransparency=1

local minimize = Instance.new("TextButton", titleBar)
minimize.Text="—"
minimize.Font=Enum.Font.GothamBold
minimize.TextSize=18
minimize.TextColor3=Color3.fromRGB(0,255,255)
minimize.Size = UDim2.new(0,26,0,26)
minimize.Position = UDim2.new(1,-60,0.5,-13)
minimize.BackgroundTransparency=1

local holder = Instance.new("Frame", main)
holder.Position = UDim2.new(0,0,0,36)
holder.Size = UDim2.new(1,0,1,-36-50)
holder.BackgroundTransparency = 1

-- LOGO
local logo = Instance.new("TextButton", gui)
logo.Text="⚡"
logo.Font=Enum.Font.GothamBold
logo.TextSize=22
logo.TextColor3=Color3.fromRGB(0,255,255)
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,20,0.5,-22)
logo.BackgroundColor3=Color3.fromRGB(15,15,20)
logo.Visible=false
Instance.new("UICorner",logo).CornerRadius=UDim.new(1,0)

------------------------------------------------
-- BUTTON 2-COLUMN TWEEN
------------------------------------------------
local buttons={}
local idx=1
local px,py,gy = 14,14,48
local lx,rx = 14,280-120-14

for r=0,2 do
	for c=0,1 do
		local d = Checkpoints[idx]
		if not d then break end
		local b = Instance.new("TextButton", holder)
		b.Size = UDim2.new(0,120,0,38)
		b.Position = UDim2.new(0,(c==0 and lx or rx),0,py+r*gy)
		b.BackgroundColor3 = Color3.fromRGB(25,25,35)
		b.Font = Enum.Font.Gotham
		b.TextSize = 12
		b.Text = d.name
		Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
		-- Tween saat klik
		b.MouseButton1Click:Connect(function()
			safeTeleport(d.cf)
			-- Tween button shrink & fade
			local tweenOut = TweenService:Create(b,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=0.7,Size=UDim2.new(0,110,0,34)})
			local tweenIn = TweenService:Create(b,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=0,Size=UDim2.new(0,120,0,38)})
			tweenOut:Play()
			tweenOut.Completed:Wait()
			tweenIn:Play()
		end)
		buttons[idx] = b
		idx+=1
	end
end

------------------------------------------------
-- SLIDER WALK SPEED
------------------------------------------------
local sliderHolder = Instance.new("Frame", main)
sliderHolder.Size=UDim2.new(1,-40,0,40)
sliderHolder.Position=UDim2.new(0,20,1,-60)
sliderHolder.BackgroundTransparency=1
sliderHolder.ClipsDescendants=true

local sliderLabel = Instance.new("TextLabel", sliderHolder)
sliderLabel.Text="WalkSpeed: 16"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 13
sliderLabel.TextColor3=Color3.fromRGB(0,255,255)
sliderLabel.BackgroundTransparency=1
sliderLabel.Size = UDim2.new(1,0,0.4,0)
sliderLabel.Position = UDim2.new(0,0,0,0)

local sliderTrack = Instance.new("Frame", sliderHolder)
sliderTrack.Size = UDim2.new(1,0,0,10)
sliderTrack.Position = UDim2.new(0,0,0.5,0)
sliderTrack.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner",sliderTrack).CornerRadius=UDim.new(0,5)

local sliderBar = Instance.new("Frame", sliderTrack)
sliderBar.Size = UDim2.new(0.16,0,1,0)
sliderBar.Position = UDim2.new(0,0,0,0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0,255,255)
Instance.new("UICorner",sliderBar).CornerRadius=UDim.new(0,5)

local draggingSlider=false
local function updateSlider(posX)
	local rel = math.clamp(posX-sliderTrack.AbsolutePosition.X,0,sliderTrack.AbsoluteSize.X)
	local speed = math.floor(rel/sliderTrack.AbsoluteSize.X*100)
	sliderLabel.Text="WalkSpeed: "..speed
	TweenService:Create(sliderBar,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.new(rel/sliderTrack.AbsoluteSize.X,0,1,0)}):Play()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	end
end

sliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
		draggingSlider=true
		updateSlider(input.Position.X)
	end
end)
sliderTrack.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
		updateSlider(input.Position.X)
	end
end)
sliderTrack.InputEnded:Connect(function(input)
	draggingSlider=false
end)

------------------------------------------------
-- MINIMIZE / RESTORE
------------------------------------------------
local canToggle=true
local function safeClick(func)
	if not canToggle then return end
	canToggle=false
	func()
	task.wait(0.2)
	canToggle=true
end

minimize.MouseButton1Click:Connect(function()
	safeClick(function()
		TweenService:Create(main,TweenInfo.new(0.3),{Position=UDim2.new(0.5,-140,0.5,-150),BackgroundTransparency=1}):Play()
		wait(0.3)
		main.Visible=false
		logo.Visible=true
		sliderHolder.Visible=false
	end)
end)

logo.MouseButton1Click:Connect(function()
	safeClick(function()
		logo.Visible=false
		sliderHolder.Visible=true
		main.Visible=true
		TweenService:Create(main,TweenInfo.new(0.3),{Position=UDim2.new(0.5,-140,0.5,-130),BackgroundTransparency=0}):Play()
	end)
end)

close.MouseButton1Click:Connect(function()
	shieldEnabled=false
	if shieldConnection then shieldConnection:Disconnect() end
	gui:Destroy()
end)

------------------------------------------------
-- DRAG GUI / LOGO
------------------------------------------------
local dragging=false
local dragStart,startPos
local dragTarget=nil
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

titleBar.InputBegan:Connect(function(input)
	if not main.Visible then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=main.Position
		dragTarget=main
	end
end)

logo.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=logo.Position
		dragTarget=logo
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and dragTarget then dragUpdate(input) end
end)

UIS.InputEnded:Connect(function(input)
	dragging=false
	dragTarget=nil
end)
