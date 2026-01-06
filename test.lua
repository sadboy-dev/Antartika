--// DELTA ANDROID GUI - NEON THEME (SMOOTH TOP CORNER)

local UIS = game:GetService("UserInputService")
local parentGui = gethui and gethui() or game.CoreGui

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaNeonGUI"
gui.Parent = parentGui
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 250)
main.Position = UDim2.new(0.5, -150, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Parent = gui

-- Corner (DIPERKECIL → ATAS TIDAK RUNCING)
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 6)

-- Neon Stroke
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 255, 255)
mainStroke.Transparency = 0.25

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.BackgroundTransparency = 0.05
titleBar.Parent = main

-- Title Text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "NEON GUI"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -32, 0, 5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
close.Parent = titleBar
Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)
Instance.new("UIStroke", close).Color = Color3.fromRGB(255, 80, 120)

-- Minimize Button
local min = Instance.new("TextButton")
min.Size = UDim2.new(0, 28, 0, 28)
min.Position = UDim2.new(1, -64, 0, 5)
min.Text = "-"
min.Font = Enum.Font.GothamBold
min.TextSize = 17
min.TextColor3 = Color3.fromRGB(0,0,0)
min.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
min.Parent = titleBar
Instance.new("UICorner", min).CornerRadius = UDim.new(0,6)
Instance.new("UIStroke", min).Color = Color3.fromRGB(0, 200, 255)

-- Holder
local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, -38)
holder.Position = UDim2.new(0, 0, 0, 38)
holder.BackgroundTransparency = 1
holder.Parent = main

-- Button Creator
local function createButton(text, x, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 130, 0, 42)
	btn.Position = UDim2.new(0, x, 0, y)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(0, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	btn.Parent = holder
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(120, 0, 255)
	stroke.Thickness = 1.5
end

-- Layout tombol
local paddingX = 15
local paddingY = 18
local gapY = 55
local leftX = paddingX
local rightX = main.Size.X.Offset - 130 - paddingX

local c = 1
for row = 0, 2 do
	createButton("Button "..c, leftX,  paddingY + (gapY * row))
	c += 1
	createButton("Button "..c, rightX, paddingY + (gapY * row))
	c += 1
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

-- Drag (Touch + Mouse)
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
