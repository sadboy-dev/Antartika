--// DELTA SAFE | NEON GUI + PERMANENT SHIELD + FAIL-SAFE TELEPORT

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

-- GUI PARENT (DELTA SAFE)
local parentGui = game.CoreGui
pcall(function()
	if gethui then
		parentGui = gethui()
	end
end)

------------------------------------------------
-- SHIELD CONFIG (AUTO ON)
------------------------------------------------
local SHIELD_HP = 1000
local shieldEnabled = true
local shieldConnection = nil

local function applyShield(character)
	if not shieldEnabled then return end
	if not character then return end

	local hum = character:WaitForChild("Humanoid", 5)
	if not hum then return end

	hum.MaxHealth = SHIELD_HP
	hum.Health = SHIELD_HP

	if shieldConnection then
		shieldConnection:Disconnect()
	end

	shieldConnection = hum.HealthChanged:Connect(function(hp)
		if shieldEnabled and hp < SHIELD_HP then
			hum.Health = SHIELD_HP
		end
	end)
end

-- APPLY SHIELD IMMEDIATELY
if player.Character then
	applyShield(player.Character)
end

player.CharacterAdded:Connect(function(char)
	wait(0.3)
	applyShield(char)
end)

------------------------------------------------
-- CHECKPOINT DATA
------------------------------------------------
local Checkpoints = {
	{name="C1",cf=CFrame.new(-3640.67,229.43,289.87),cd=80},
	{name="C2",cf=CFrame.new(1860.78,105.82,-235.41),cd=60},
	{name="Vinson",cf=CFrame.new(3731.35,1508.92,-184.39),cd=120},
	{name="C3",cf=CFrame.new(5709.64,320.89,628.29),cd=90},
	{name="C4",cf=CFrame.new(8992.34,595.60,103.32),cd=75},
	{name="Run",cf=CFrame.new(10113.24,552,35.11),cd=45},
}

------------------------------------------------
-- FAIL-SAFE SAFE TELEPORT
------------------------------------------------
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid",5)
	local hrp = char:WaitForChild("HumanoidRootPart",5)
	if not hum or not hrp then return end

	local targetPos = cf.Position
	local MAX_RETRY = 3

	for attempt = 1, MAX_RETRY do
		-- freeze sementara
		hrp.Anchored = true
		hum:ChangeState(Enum.HumanoidStateType.Physics)

		-- teleport
		hrp.CFrame = cf + Vector3.new(0,4,0)
		wait(0.2)

		-- cek berhasil atau tidak
		local dist = (hrp.Position - targetPos).Magnitude
		if dist < 10 then
			break -- sukses
		end
	end

	-- restore state
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	wait(0.05)
	hrp.Anchored = false
end

------------------------------------------------
-- GUI SETUP
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "NeonCheckpointGui"
gui.ResetOnSpawn = false
gui.Parent = parentGui

-- MAIN FRAME
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

-- CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,36)
content.Size = UDim2.new(1,0,1,-36)
content.BackgroundTransparency = 1

local info = Instance.new("TextLabel", content)
info.Text = "✓ Shield Active\n✓ GUI Running\n✓ Delta Safe\n✓ Teleport Fail-Safe"
info.Font = Enum.Font.Gotham
info.TextSize = 13
info.TextColor3 = Color3.fromRGB(200,200,200)
info.BackgroundTransparency = 1
info.Size = UDim2.new(1,0,1,0)

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
-- MINIMIZE / RESTORE
------------------------------------------------
minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	logo.Visible = true
end)

logo.MouseButton1Click:Connect(function()
	main.Visible = true
	logo.Visible = false
end)

close.MouseButton1Click:Connect(function()
	shieldEnabled = false
	if shieldConnection then
		shieldConnection:Disconnect()
	end
	gui:Destroy()
end)

------------------------------------------------
-- DRAG SUPPORT
------------------------------------------------
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging = false
end)

------------------------------------------------
-- CHECKPOINT BUTTON SYSTEM (Optional)
-- Tambahkan checkpoint / teleport buttons disini jika ingin
------------------------------------------------
