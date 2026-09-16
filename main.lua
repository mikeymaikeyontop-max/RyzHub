-- ============================================================
-- ⚡ RYZHUB | v5.0 (Rayfield UI)
-- by mikey
-- Silent Aim + ESP + Speed + Noclip + Aimbot + FOV + Discord
-- ============================================================

print("[RyzHub] Loading...")

if getgenv().RyzHubLoaded then return end
getgenv().RyzHubLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- 1. تحميل Rayfield UI
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================================
-- 2. الإعدادات
-- ============================================================
local Config = {
    SilentAim = false,
    Aimbot = false,
    ESP = false,
    ShowFOV = false,
    Noclip = false,
    FOVRadius = 150,
    AimRange = 300,
    Smoothness = 0.5,
    Speed = 16,
}

-- ============================================================
-- 3. إنشاء النافذة
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "⚡ RYZHUB v5.0 | by mikey",
    LoadingTitle = "RyzHub Loading...",
    LoadingSubtitle = "by mikey",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- ============================================================
-- 4. التبويبات
-- ============================================================
local MainTab = Window:CreateTab("Main", nil)

-- Silent Aim
MainTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value)
        Config.SilentAim = Value
    end,
})

-- Aimbot
MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        Config.Aimbot = Value
    end,
})

-- Show FOV
MainTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "ShowFOV",
    Callback = function(Value)
        Config.ShowFOV = Value
        if FOVFrame then FOVFrame.Visible = Value end
    end,
})

-- ESP
MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        Config.ESP = Value
        if not Value then
            for _, v in pairs(ESPFolder:GetChildren()) do
                v:Destroy()
            end
        end
    end,
})

-- Noclip
MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Noclip = Value
    end,
})

-- FOV Radius
MainTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 500},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVRadius",
    Callback = function(Value)
        Config.FOVRadius = Value
    end,
})

-- Aim Range
MainTab:CreateSlider({
    Name = "Aim Range",
    Range = {50, 500},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 300,
    Flag = "AimRange",
    Callback = function(Value)
        Config.AimRange = Value
    end,
})

-- Smoothness
MainTab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = 5,
    Flag = "Smoothness",
    Callback = function(Value)
        Config.Smoothness = Value / 10
    end,
})

-- Walk Speed
MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Config.Speed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- Discord Button
MainTab:CreateButton({
    Name = "💬 Join Discord",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/UFMmHU95p4")
        end)
        Rayfield:Notify({
            Title = "💬 Discord",
            Content = "Link copied to clipboard!",
            Duration = 3,
        })
    end,
})

-- ============================================================
-- 5. FOV Circle
-- ============================================================
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
FOVFrame.Position = UDim2.new(0.5, -Config.FOVRadius, 0.5, -Config.FOVRadius)
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderSizePixel = 0
FOVFrame.Visible = false
FOVFrame.Parent = game:GetService("CoreGui")

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = FOVFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(153, 68, 255)
fovStroke.Thickness = 1.5
fovStroke.Parent = FOVFrame

-- ============================================================
-- 6. ESP Folder
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RyzHubESP"
ESPFolder.Parent = game:GetService("CoreGui")

-- ============================================================
-- 7. Silent Aim Engine
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
-- 8. ESP
-- ============================================================
local espCache = {}

local function CreateESP(player)
    if espCache[player] then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

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
-- 9. الحلقة الرئيسية
-- ============================================================
RunService.RenderStepped:Connect(function()
    if Config.SilentAim or Config.Aimbot then
        local enemy = GetClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
            local targetPos = enemy.Character.Head.Position
            local cameraPos = Camera.CFrame.Position
            local lookAt = CFrame.lookAt(cameraPos, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, Config.Smoothness)
        end
    end

    if FOVFrame then
        FOVFrame.Visible = Config.ShowFOV
        FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
        FOVFrame.Position = UDim2.new(0.5, -Config.FOVRadius, 0.5, -Config.FOVRadius)
    end

    if Config.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end

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
    else
        for player, data in pairs(espCache) do
            data.billboard:Destroy()
            espCache[player] = nil
        end
    end
end)

-- ============================================================
-- 10. إشعار
-- ============================================================
Rayfield:Notify({
    Title = "⚡ RyzHub v5.0",
    Content = "Loaded! by mikey",
    Duration = 5,
})

print("[RyzHub] v5.0 Loaded successfully! | by mikey")
