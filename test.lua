--// Simple Executor GUI
--// Author: ChatGPT

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Corner
local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Executor GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Left
Title.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn)

-- Button Holder
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -20, 1, -60)
ButtonFrame.Position = UDim2.new(0, 10, 0, 50)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

-- Grid Layout
local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 150, 0, 50)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)
Grid.HorizontalAlignment = Center
Grid.VerticalAlignment = Center
Grid.Parent = ButtonFrame

-- Create 6 Buttons
for i = 1, 6 do
	local btn = Instance.new("TextButton")
	btn.Text = "Button " .. i
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Parent = ButtonFrame
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		print("Button " .. i .. " clicked")
	end)
end

-- Minimize Function
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	ButtonFrame.Visible = not minimized
	MainFrame.Size = minimized and UDim2.new(0, 350, 0, 50) or UDim2.new(0, 350, 0, 300)
end)

-- Close Function
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
