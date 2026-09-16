-- ============================================================
-- ⚡ RYZHUB | v2.0
-- by Ryz
-- Silent Aim + ESP + Flash Step + Player Features
-- ============================================================

if getgenv().RyzHubLoaded then return end
getgenv().RyzHubLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- 1. الإعدادات
-- ============================================================
local Config = {
    SilentAim = false,
    ESP = false,
    FlashStepZ = false,
    FlashStepX = false,
    AimRange = 200,
    Smoothness = 0.5,
}

-- ============================================================
-- 2. الواجهة
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
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
Title.Text = "⚡ RYZHUB v2.0"
Title.TextColor3 = Color3.fromRGB(153, 68, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 10)
tc.Parent = Title

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 6)
cc.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    getgenv().RyzHubLoaded = false
end)

-- ============================================================
-- 3. دالة Toggle
-- ============================================================
local function CreateToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.Parent = MainFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 10)
    bc.Parent = btn

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    knob.BorderSizePixel = 0
    knob.Parent = btn

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(153, 68, 255)
            knob.Position = UDim2.new(1, -18, 0.5, -8)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            knob.Position = UDim2.new(0, 2, 0.5, -8)
        end
        callback(state)
    end)
end

-- ============================================================
-- 4. دالة زر
-- ============================================================
local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
    btn.MouseButton1Click:Connect(callback)
end

-- ============================================================
-- 5. العناصر
-- ============================================================
CreateToggle("Silent Aim", 55, function(v) Config.SilentAim = v end)
CreateToggle("Player ESP", 95, function(v) Config.ESP = v end)
CreateToggle("Flash Step (Z)", 135, function(v) Config.FlashStepZ = v end)
CreateToggle("Flash Step (X)", 175, function(v) Config.FlashStepX = v end)

CreateButton("WalkSpeed: 50", 220, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

CreateButton("WalkSpeed: 100", 260, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

CreateButton("JumpPower: 200", 300, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 200
    end
end)

CreateButton("Reset Speed", 340, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- ============================================================
-- 6. Silent Aim Engine
-- ============================================================
local function GetClosestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local closest = nil
    local minDist = Config.AimRange

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (myPos - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- ============================================================
-- 7. ESP
-- ============================================================
local espCache = {}

local function CreateESP(player)
    if espCache[player] then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.AlwaysOnTop = true
    billboard.Adornee = hrp
    billboard.Parent = hrp

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = player.Name
    text.TextColor3 = Color3.fromRGB(255, 50, 50)
    text.TextSize = 12
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard

    espCache[player] = billboard
end

local function RemoveESP()
    for player, gui in pairs(espCache) do
        gui:Destroy()
        espCache[player] = nil
    end
end

-- ============================================================
-- 8. الحلقة الرئيسية
-- ============================================================
RunService.RenderStepped:Connect(function()
    -- Silent Aim
    if Config.SilentAim then
        local enemy = GetClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
            local targetPos = enemy.Character.Head.Position
            local cameraPos = Camera.CFrame.Position
            local lookAt = CFrame.lookAt(cameraPos, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, Config.Smoothness)
        end
    end

    -- ESP
    if Config.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player)
            end
        end
    end
end)

-- ============================================================
-- 9. Flash Step Auto
-- ============================================================
task.spawn(function()
    while ScreenGui.Parent do
        if Config.FlashStepZ or Config.FlashStepX then
            local key = Config.FlashStepX and "X" or "Z"
            game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================================
-- 10. إشعار
-- ============================================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ RyzHub v2.0",
    Text = "Loaded with Silent Aim + ESP + Flash Step!",
    Duration = 3
})

print("[RyzHub] v2.0 Loaded successfully!")
