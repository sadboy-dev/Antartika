local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local cp1 = Instance.new("TextButton")
local cp2 = Instance.new("TextButton")
local vns = Instance.new("TextButton")
local cp3 = Instance.new("TextButton")
local cp4 = Instance.new("TextLabel")
local fn = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")
 
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

local C1 = {
    "https://raw.githubusercontent.com/sadboy-dev/Antartika/refs/heads/main/c1.lua",
}

local C2 = {
    "https://raw.githubusercontent.com/sadboy-dev/Antartika/refs/heads/main/c2.lua",
}

local VNS = {
    "https://raw.githubusercontent.com/sadboy-dev/Antartika/refs/heads/main/vinson.lua",
}

local C3 = {
    "https://raw.githubusercontent.com/sadboy-dev/Antartika/refs/heads/main/c3.lua",
}

local C4 = {
    "https://raw.githubusercontent.com/sadboy-dev/Antartika/refs/heads/main/c4.lua",
}

local FINISH = {
    "https://raw.githubusercontent.com/sadboy-dev/Antartika/refs/heads/main/finish.lua",
}


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local hrp

local routes = {}
local animConn
local isMoving = false

local playbackRate = 1
local isReplayRunning = false
 
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 90, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Jriik89"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
 
cp1.Name = "cp1"
cp1.Parent = Frame
cp1.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
cp1.Size = UDim2.new(0, 45, 0, 28)
cp1.Font = Enum.Font.SourceSans
cp1.Text = "CP1"
cp1.TextColor3 = Color3.fromRGB(0, 0, 0)
cp1.TextScaled = true
cp1.TextSize = 14.000
cp1.TextWrapped = true
 
cp2.Name = "cp2"
cp2.Parent = Frame
cp2.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
cp2.Position = UDim2.new(0, 0, 0.491228074, 0)
cp2.Size = UDim2.new(0, 45, 0, 28)
cp2.Font = Enum.Font.SourceSans
cp2.Text = "CP2"
cp2.TextColor3 = Color3.fromRGB(0, 0, 0)
cp2.TextScaled = true
cp2.TextSize = 14.000
cp2.TextWrapped = true

vns.Name = "vns"
vns.Parent = Frame
vns.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
vns.Position = UDim2.new(0.231578946, 0, 0, 0)
vns.Size = UDim2.new(0, 45, 0, 28)
vns.Font = Enum.Font.SourceSans
vns.Text = "Vinson"
vns.TextColor3 = Color3.fromRGB(0, 0, 0)
vns.TextScaled = true
vns.TextSize = 14.000
vns.TextWrapped = true

cp3.Name = "cp3"
cp3.Parent = Frame
cp3.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
cp3.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
cp3.Size = UDim2.new(0, 45, 0, 29)
cp3.Font = Enum.Font.SourceSans
cp3.Text = "CP3"
cp3.TextColor3 = Color3.fromRGB(0, 0, 0)
cp3.TextScaled = true
cp3.TextSize = 14.000
cp3.TextWrapped = true

cp4.Name = "cp4"
cp4.Parent = Frame
cp4.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
cp4.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
cp4.Size = UDim2.new(0, 45, 0, 28)
cp4.Font = Enum.Font.SourceSans
cp4.Text = "CP4"
cp4.TextColor3 = Color3.fromRGB(0, 0, 0)
cp4.TextScaled = true
cp4.TextSize = 14.000
cp4.TextWrapped = true
 
fn.Name = "fn"
fn.Parent = Frame
fn.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
fn.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
fn.Size = UDim2.new(0, 45, 0, 28)
fn.Font = Enum.Font.SourceSans
fn.Text = "FINISH"
fn.TextColor3 = Color3.fromRGB(0, 0, 0)
fn.TextSize = 14.000
 
closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)
 
mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)
 
mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false
 
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "Script Teleport By:";
    Text = "Jriik89";
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;
 
Frame.Active = true -- main = gui
Frame.Draggable = true



cp1.MouseButton1Down:connect(function()
    local plr = game.Players.LocalPlayer
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(-3718.99, 255.00, 235.67)
    end
 end)

cp2.MouseButton1Down:connect(function()
    local plr = game.Players.LocalPlayer
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(3718.99, 255.00, 235.67)
    end
 end)

vns.MouseButton1Down:connect(function()
    local plr = game.Players.LocalPlayer
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(3718.99, 255.00, 235.67)
    end
 end)

cp3.MouseButton1Down:connect(function()
    local plr = game.Players.LocalPlayer
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(3718.99, 255.00, 235.67)
    end
 end)

cp4.MouseButton1Down:connect(function()
    local plr = game.Players.LocalPlayer
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(3718.99, 255.00, 235.67)
    end
 end)

fn.MouseButton1Down:connect(function()
    local plr = game.Players.LocalPlayer
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(170.09, 889.82, 149.50) * CFrame.Angles(0,0,0)
    end
 end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    game.Players.LocalPlayer.Character.Animate.Disabled = false
 
end)

closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)
 
mini.MouseButton1Click:Connect(function()
    cp1.Visible = false
    cp2.Visible = false
    vns.Visible = false
    cp3.Visible = false
    cp4.Visible = false
    fn.Visible = false
    mini.Visible = false
    mini2.Visible = true
    main.Frame.BackgroundTransparency = 1
    closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)
 
mini2.MouseButton1Click:Connect(function()
    cp1.Visible = true
    cp2.Visible = true
    vns.Visible = true
    cp3.Visible = true
    cp4.Visible = true
    fn.Visible = true
    mini.Visible = true
    mini2.Visible = false
    main.Frame.BackgroundTransparency = 0 
    closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)
