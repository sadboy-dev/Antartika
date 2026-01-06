--// DELTA ANDROID - NEON TELEPORT GUI (FULL SAFE VERSION)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parentGui = gethui and gethui() or game.CoreGui

-- =====================================================
-- SAFE TELEPORT (ANTI DAMAGE + ANTI JATUH + ANTI VOID)
-- =====================================================
local function safeTeleport(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	-- Raycast cari tanah
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist

	local origin = Vector3.new(cf.X, cf.Y + 60, cf.Z)
	local direction = Vector3.new(0, -500, 0)
	local result = workspace:Raycast(origin, direction, rayParams)

	local finalY = cf.Y
	if result then
		finalY = result.Position.Y + 4
	end

	-- Freeze total
	hrp.Anchored = true
	hum:ChangeState(Enum.HumanoidStateType.Physics)

	-- Teleport
	hrp.CFrame = CFrame.new(cf.X, finalY, cf.Z)

	-- Stabilkan
	task.wait(0.25)
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
end

-- Disable ragdoll & fall (extra safety)
player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
end)

-- =====================================================
-- TELEPORT DATA
-- =====================================================
local Teleports = {
	C1     = CFrame.new(-3640.67, 229.43, 289.87),
	C2     = CFrame.new(1860.78, 105.82, -235.41),
	Vinson = CFrame.new(3731.35, 1508.92, -184.39),
	C3     = CFrame.new(5709.64, 320.89, 628.29),
	C4     = CFrame.new(8992.34, 595.60, 103.32),
	Run    = CFrame.new(10113.24, 552.00, 35.11),
}

-- =====================================================
-- GUI
-- =====================================================
local gui = Instance.new("ScreenGui")
gui.Name = "NeonTeleportGUI"
gui.Parent = parentGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 250)
main.Position = UDim2.new(0.5, -150, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,255,255)
stroke.Transparency = 0.25

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,38)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
titleBar.Active = true
titleBar.BackgroundTransparency = 0.05
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "NEON TELEPORT"
title.TextColor3 = Color3.fromRGB(0,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(200,60,80)
close.Parent = titleBar
Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)

-- Minimize
local min = Instance.new("TextButton")
min.Size = UDim2.new(0,28,0,28)
min.Position = UDim2.new(1,-64,0,5)
min.Text = "-"
min.Font = Enum.Font.GothamBold
min.TextSize = 17
min.TextColor3 = Color3.fromRGB(0,0,0)
min.BackgroundColor3 = Color3.fromRGB(0,255,255)
min.Parent = titleBar
Instance.new("UICorner", min).CornerRadius = UDim.new(0,6)

-- Holder
local holder = Instance.new("Frame")
holder.Size = UDim2.new(1,0,1,-38)
holder.Position = UDim2.new(0,0,0,38)
holder.BackgroundTransparency = 1
holder.Parent = main

-- =====================================================
-- BUTTON CREATOR
-- =====================================================
local function createButton(name, x, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,130,0,42)
	btn.Position = UDim2.new(0,x,0,y)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(0,255,255)
	btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
	btn.Parent = holder
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	local s = Instance.new("UIStroke", btn)
	s.Color = Color3.fromRGB(120,0,255)
	s.Thickness = 1.5

	btn.MouseButton1Click:Connect(function()
		local cf = Teleports[name]
		if cf then
			safeTeleport(cf)
		end
	end)
end

-- Layout tombol
local padX, padY, gapY = 15, 18, 55
local leftX = padX
local rightX = main.Size.X.Offset - 130 - padX

local names = {"C1","C2","Vinson","C3","C4","Run"}
local i = 1
for row = 0, 2 do
	createButton(names[i], leftX,  padY + (gapY * row)); i += 1
	createButton(names[i], rightX, padY + (gapY * row)); i += 1
end

-- Minimize
local minimized = false
min.MouseButton1Click:Connect(function()
	minimized = not minimized
	holder.Visible = not minimized
	main.Size = minimized and UDim2.new(0,300,0,38) or UDim2.new(0,300,0,250)
end)

-- Close
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- =====================================================
-- DRAG (TOUCH + MOUSE)
-- =====================================================
local dragging, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement
	) then
		updateDrag(input)
	end
end)
