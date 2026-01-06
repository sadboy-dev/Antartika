--// DELTA ANDROID GUI FINAL FULL
--// Touch + Mouse Drag Supported

local UIS = game:GetService("UserInputService")
local parentGui = gethui and gethui() or game.CoreGui

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaFinalGUI"
gui.Parent = parentGui
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 300)
main.Position = UDim2.new(0.5, -175, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title Bar (DRAG AREA)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.BackgroundTransparency = 0.01
titleBar.Parent = main

-- Title Text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Delta Executor GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
close.Parent = titleBar
Instance.new("UICorner", close)

-- Minimize Button
local min = Instance.new("TextButton")
min.Size = UDim2.new(0, 30, 0, 30)
min.Position = UDim2.new(1, -70, 0, 5)
min.Text = "-"
min.Font = Enum.Font.GothamBold
min.TextSize = 18
min.TextColor3 = Color3.new(1,1,1)
min.BackgroundColor3 = Color3.fromRGB(70,70,70)
min.Parent = titleBar
Instance.new("UICorner", min)

-- Holder
local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, -40)
holder.Position = UDim2.new(0, 0, 0, 40)
holder.BackgroundTransparency = 1
holder.Parent = main

-- Button Creator
local function createButton(text, x, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 150, 0, 45)
	btn.Position = UDim2.new(0, x, 0, y)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.Parent = holder
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		print(text .. " clicked")
	end)
end

-- Create 6 Buttons (2x3)
local startX, startY = 25, 20
local gapX, gapY = 175, 60
local num = 1

for row = 0, 2 do
	for col = 0, 1 do
		createButton("Button " .. num,
			startX + (gapX * col),
			startY + (gapY * row)
		)
		num += 1
	end
end

-- Minimize Logic
local minimized = false
min.MouseButton1Click:Connect(function()
	minimized = not minimized
	holder.Visible = not minimized
	main.Size = minimized and UDim2.new(0,350,0,40) or UDim2.new(0,350,0,300)
end)

-- Close Logic
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- DRAG SYSTEM (MOBILE + PC)
local dragging = false
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
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

titleBar.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		updateDrag(input)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		updateDrag(input)
	end
end)
