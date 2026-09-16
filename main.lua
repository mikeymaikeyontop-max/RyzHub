-- ============================================================
-- ⚡ RYZHUB | v3.1
-- by mikey
-- Silent Aim + FOV + ESP + Discord + Color Changer
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
    ShowFOV = false,
    FOVRadius = 150,
    AimRange = 300,
    Smoothness = 0.5,
    AccentColor = Color3.fromRGB(153, 68, 255),
}

-- ============================================================
-- 2. الواجهة
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 540)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = MainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Config.AccentColor
stroke.Thickness = 1.5
stroke.Parent = MainFrame

-- شريط العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Text = "⚡ RYZHUB v3.1"
Title.TextColor3 = Config.AccentColor
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 10)
tc.Parent = Title

-- حقوق mikey
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Position = UDim2.new(0, 0, 0, 40)
Credits.BackgroundTransparency = 1
Credits.Text = "by mikey"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 11
Credits.Font = Enum.Font.GothamItalic
Credits.Parent = MainFrame

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
    if FOVCircle then FOVCircle:Remove() end
    if ESPFolder then ESPFolder:Destroy() end
    getgenv().RyzHubLoaded = false
end)

-- ============================================================
-- 3. دوال Toggle
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
            btn.BackgroundColor3 = Config.AccentColor
            knob.Position = UDim2.new(1, -18, 0.5, -8)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            knob.Position = UDim2.new(0, 2, 0.5, -8)
        end
        callback(state)
    end)
end

-- ============================================================
-- 4. دوال Slider
-- ============================================================
local function CreateSlider(text, minVal, maxVal, default, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.Parent = MainFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 25)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Config.AccentColor
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(1, 0)
    sbc.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Config.AccentColor
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(mouseX / sliderBg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(minVal + (maxVal - minVal) * percent)
            valueLabel.Text = tostring(val)
            callback(val)
        end
    end)
end

-- ============================================================
-- 5. العناصر
-- ============================================================
CreateToggle("Silent Aim", 70, function(v) Config.SilentAim = v end)
CreateToggle("Show FOV Circle", 110, function(v)
    Config.ShowFOV = v
    if FOVCircle then FOVCircle.Visible = v end
end)
CreateToggle("Player ESP", 150, function(v)
    Config.ESP = v
    if not v then
        for _, esp in pairs(ESPFolder:GetChildren()) do
            esp:Destroy()
        end
    end
end)

CreateSlider("FOV Radius", 50, 500, 150, 190, function(v)
    Config.FOVRadius = v
    if FOVCircle then FOVCircle.Radius = v end
end)

CreateSlider("Aim Range", 50, 500, 300, 250, function(v)
    Config.AimRange = v
end)

CreateSlider("Smoothness", 0, 10, 5, 310, function(v)
    Config.Smoothness = v / 10
end)

-- ============================================================
-- 6. FOV Circle
-- ============================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = Config.FOVRadius
FOVCircle.Color = Config.AccentColor
FOVCircle.Filled = false
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

-- ============================================================
-- 7. ESP Folder
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RyzHubESP"
ESPFolder.Parent = ScreenGui

-- ============================================================
-- 8. نظام تغيير الألوان
-- ============================================================
local function ChangeAccentColor(color)
    Config.AccentColor = color
    stroke.Color = color
    Title.TextColor3 = color
    if FOVCircle then FOVCircle.Color = color end
end

-- زر تغيير اللون
local ColorBtn = Instance.new("TextButton")
ColorBtn.Size = UDim2.new(1, -20, 0, 35)
ColorBtn.Position = UDim2.new(0, 10, 0, 370)
ColorBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ColorBtn.Text = "🎨 Change Color"
ColorBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
ColorBtn.TextSize = 13
ColorBtn.Font = Enum.Font.GothamBold
ColorBtn.BorderSizePixel = 0
ColorBtn.Parent = MainFrame

local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 6)
cbc.Parent = ColorBtn

-- قائمة الألوان
local colorList = {
    {name = "Purple", color = Color3.fromRGB(153, 68, 255)},
    {name = "Blue", color = Color3.fromRGB(0, 150, 255)},
    {name = "Red", color = Color3.fromRGB(255, 50, 50)},
    {name = "Green", color = Color3.fromRGB(50, 255, 100)},
    {name = "Orange", color = Color3.fromRGB(255, 150, 0)},
    {name = "Pink", color = Color3.fromRGB(255, 50, 150)},
    {name = "Cyan", color = Color3.fromRGB(0, 255, 255)},
    {name = "White", color = Color3.fromRGB(255, 255, 255)},
}
local colorIndex = 1

ColorBtn.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colorList + 1
    local newColor = colorList[colorIndex]
    ChangeAccentColor(newColor.color)
    ColorBtn.Text = "🎨 Color: " .. newColor.name
end)

-- ============================================================
-- 9. زر Discord
-- ============================================================
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -20, 0, 35)
DiscordBtn.Position = UDim2.new(0, 10, 0, 415)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "💬 Join Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 13
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Parent = MainFrame

local dbc = Instance.new("UICorner")
dbc.CornerRadius = UDim.new(0, 6)
dbc.Parent = DiscordBtn

DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "💬 Discord",
            Text = "Copied link! Opening Discord...",
            Duration = 3
        })
    end)
    pcall(function()
        setclipboard("https://discord.gg/UFMmHU95p4")
    end)
    pcall(function()
        game:GetService("GuiService"):OpenInBrowser("https://discord.gg/UFMmHU95p4")
    end)
end)

-- ============================================================
-- 10. حقوق mikey في الأسفل
-- ============================================================
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.BackgroundTransparency = 1
Footer.Text = "⚡ RyzHub | Made by mikey"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.TextSize = 11
Footer.Font = Enum.Font.Gotham
Footer.Parent = MainFrame

-- ============================================================
-- 11. Silent Aim Engine
-- ============================================================
local function GetClosestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local closest = nil
    local minDist = Config.AimRange
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            if hrp and head then
                local dist = (myPos - hrp.Position).Magnitude
                if dist < minDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if fovDist <= Config.FOVRadius then
                            minDist = dist
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ============================================================
-- 12. ESP
-- ============================================================
local espCache = {}

local function CreateESP(player)
    if espCache[player] then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hrp or not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = ESPFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 20)
    distLabel.Position = UDim2.new(0, 0, 0, 20)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0
    distLabel.Parent = billboard

    espCache[player] = {billboard = billboard, distLabel = distLabel}
end

-- ============================================================
-- 13. الحلقة الرئيسية
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

        for player, data in pairs(espCache) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local dist = (myChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    data.distLabel.Text = math.floor(dist) .. "m"
                end
            else
                data.billboard:Destroy()
                espCache[player] = nil
            end
        end
    end
end)

-- ============================================================
-- 14. إشعار
-- ============================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ RyzHub v3.1",
        Text = "Loaded! Made by mikey",
        Duration = 3
    })
end)

print("[RyzHub] v3.1 Loaded successfully! | by mikey")
