-- ============================================================
-- ⚡ RYZHUB | v1.0
-- by Ryz
-- ============================================================

if getgenv().RyzHubLoaded then return end
getgenv().RyzHubLoaded = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Text = "⚡ RYZHUB"
Title.TextColor3 = Color3.fromRGB(153, 68, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 10)
tc.Parent = Title

-- نص الترحيب
local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1, -20, 0, 30)
Welcome.Position = UDim2.new(0, 10, 0, 60)
Welcome.BackgroundTransparency = 1
Welcome.Text = "مرحباً بك في RyzHub!"
Welcome.TextColor3 = Color3.fromRGB(220, 220, 220)
Welcome.TextSize = 14
Welcome.Font = Enum.Font.Gotham
Welcome.Parent = MainFrame

-- إشعار
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ RyzHub",
    Text = "تم التحميل بنجاح!",
    Duration = 3
})

print("[RyzHub] Loaded successfully!")
