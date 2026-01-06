--// DELTA EXECUTOR GUI FIX

-- Services
local UIS = game:GetService("UserInputService")

-- Parent GUI (DELTA FIX)
local parentGui = gethui and gethui() or game:GetService("CoreGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaGUI"
ScreenGui.Parent = parentGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Delta Executor GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
Close.Parent = TitleBar
Instance.new("UICorner", Close)

-- Minimize Button
local Min = Instance.new("TextButton")
Min.Size = UDim2.new(0, 30, 0, 30)
Min.Position = UDim2.new(1, -70, 0, 5)
Min.Text = "-"
Min.Font = Enum.Font.GothamBold
Min.TextSize = 18
Min.TextColor3 = Color3.new(1,1,1)
Min.BackgroundColor3 = Color3.fromRGB(70,70,70)
Min.Parent = TitleBar
Instance.new("UICorner", Min)

-- Button Holder
local Holder = Instance.new("Frame")
Holder.Size = UDim2.new(1, -20, 1, -60)
Holder.Position = UDim2.new(0, 10, 0, 50)
Holder.BackgroundTransparency = 1
Holder.Parent = MainFrame

-- Grid Layout
local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 150, 0, 50)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.VerticalAlignment = Enum.VerticalAlignment.Center
Grid.Parent = Holder

-- Buttons
for i = 1, 6 do
	local btn = Instance.new("TextButton")
	btn.Text = "Button "..i
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.Parent = Holder
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		print("Button "..i.." pressed")
	end)
end

-- Minimize Logic
local minimized = false
Min.MouseButton1Click:Connect(function()
	minimized = not minimized
	Holder.Visible = not minimized
	MainFrame.Size = minimized and UDim2.new(0,350,0,40) or UDim2.new(0,350,0,300)
end)

-- Close Logic
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Drag System (DELTA FIX)
local dragging, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
