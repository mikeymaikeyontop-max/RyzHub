-- ============================================================
-- ⚡ RYZHUB | v6.0 (Full Edition)
-- by mikey
-- FOV + Silent Aim + ESP + Auto Flash Step + Noclip + Ignore List
-- ============================================================

print("[RyzHub] Loading...")

if getgenv().RyzHubLoaded then return end
getgenv().RyzHubLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- 🔐 1. قائمة التجاهل (Ignore List)
-- ============================================================
local IgnoreList = {
    -- ["PlayerName1"] = true,
}
local IgnoreIDs = {
    -- [123456789] = true,
}

local function IsIgnored(player)
    if not player then return true end
    if player == LocalPlayer then return true end
    if IgnoreList[player.Name] then return true end
    if IgnoreIDs[player.UserId] then return true end
    return false
end

-- ============================================================
-- 2. تحميل Rayfield UI
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================================
-- 3. الإعدادات
-- ============================================================
local Config = {
    SilentAim = false,
    Aimbot = false,
    ESP = false,
    ShowFOV = false,
    Noclip = false,
    AutoFlash = false,
    FOVRadius = 150,
    AimRange = 300,
    Smoothness = 0.5,
    Speed = 16,
}

-- ============================================================
-- 4. إنشاء النافذة
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "⚡ RYZHUB v6.0 | by mikey",
    LoadingTitle = "RyzHub Loading...",
    LoadingSubtitle = "by mikey",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- ============================================================
-- 5. تبويب Main
-- ============================================================
local MainTab = Window:CreateTab("Main", nil)

MainTab:CreateToggle({
    Name = "Silent Aim (No Camera Move)",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value) Config.SilentAim = Value end,
})

MainTab:CreateToggle({
    Name = "Show FOV Circle (Follows Mouse)",
    CurrentValue = false,
    Flag = "ShowFOV",
    Callback = function(Value) Config.ShowFOV = Value end,
})

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

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value) Config.Noclip = Value end,
})

MainTab:CreateToggle({
    Name = "Auto Flash Step (Press R)",
    CurrentValue = false,
    Flag = "AutoFlash",
    Callback = function(Value) Config.AutoFlash = Value end,
})

MainTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 500},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVRadius",
    Callback = function(Value) Config.FOVRadius = Value end,
})

MainTab:CreateSlider({
    Name = "Aim Range",
    Range = {50, 500},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 300,
    Flag = "AimRange",
    Callback = function(Value) Config.AimRange = Value end,
})

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

-- ============================================================
-- 6. تبويب Ignore List
-- ============================================================
local IgnoreTab = Window:CreateTab("🚫 Ignore List", nil)

IgnoreTab:CreateSection("Players in Server")

local playerList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerList, p.Name)
    end
end

local selectedPlayer = nil

IgnoreTab:CreateDropdown({
    Name = "Select Player",
    Options = playerList,
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "PlayerDropdown",
    Callback = function(Option) selectedPlayer = Option end,
})

IgnoreTab:CreateButton({
    Name = "🚫 Add to Ignore List",
    Callback = function()
        if selectedPlayer then
            IgnoreList[selectedPlayer] = true
            Rayfield:Notify({
                Title = "🚫 Ignore List",
                Content = selectedPlayer .. " added!",
                Duration = 3,
            })
        end
    end,
})

IgnoreTab:CreateButton({
    Name = "✅ Remove from Ignore List",
    Callback = function()
        if selectedPlayer and IgnoreList[selectedPlayer] then
            IgnoreList[selectedPlayer] = nil
            Rayfield:Notify({
                Title = "✅ Removed",
                Content = selectedPlayer .. " removed!",
                Duration = 3,
            })
        end
    end,
})

-- ============================================================
-- 7. FOV Circle (يتبع الماوس)
-- ============================================================
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderSizePixel = 0
FOVFrame.Visible = false
FOVFrame.ZIndex = 999
FOVFrame.Parent = game:GetService("CoreGui")

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = FOVFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(153, 68, 255)
fovStroke.Thickness = 2
fovStroke.Parent = FOVFrame

-- ============================================================
-- 8. ESP Folder
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RyzHubESP"
ESPFolder.Parent = game:GetService("CoreGui")

-- ============================================================
-- 9. الحصول على موقع الماوس
-- ============================================================
local UserInputService = game:GetService("UserInputService")
local mouseLocation = Vector2.new(0, 0)
local mouse = LocalPlayer:GetMouse()

-- ============================================================
-- 10. دالة الحصول على أقرب عدو
-- ============================================================
local function GetClosestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local closest = nil
    local minDist = Config.AimRange

    for _, player in ipairs(Players:GetPlayers()) do
        if not IsIgnored(player) and player.Character then
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
-- 11. دالة الحصول على العدو في FOV
-- ============================================================
local function GetEnemyInFOV()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local closest = nil
    local minDist = Config.AimRange

    for _, player in ipairs(Players:GetPlayers()) do
        if not IsIgnored(player) and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            if hrp and head then
                local dist = (myPos - hrp.Position).Magnitude
                if dist < minDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
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
-- 13. دالة إرسال الضربة (Flash Step)
-- ============================================================
local function SendKey(key)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- ============================================================
-- 14. الحلقة الرئيسية
-- ============================================================
RunService.RenderStepped:Connect(function()
    -- تحديث موقع الماوس
    mouseLocation = UserInputService:GetMouseLocation()

    -- FOV Circle (يتبع الماوس)
    if FOVFrame then
        FOVFrame.Visible = Config.ShowFOV
        FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
        FOVFrame.Position = UDim2.new(0, mouseLocation.X - Config.FOVRadius, 0, mouseLocation.Y - Config.FOVRadius)
    end

    -- Silent Aim (بدون تحريك الكاميرا)
    if Config.SilentAim then
        local enemy = GetEnemyInFOV()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
            -- إرسال ضربة نحو العدو (بدون تحريك الكاميرا)
            -- ملاحظة: هذا يعتمد على أن اللعبة تستخدم "Lock On" target
            -- يمكنك تعديل هذا الجزء حسب آلية اللعبة
        end
    end

    -- Noclip
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

    -- ESP
    if Config.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if not IsIgnored(player) and player.Character then
                CreateESP(player)
            end
        end

        for player, data in pairs(espCache) do
            if IsIgnored(player) then
                data.billboard:Destroy()
                espCache[player] = nil
            elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
-- 15. Auto Flash Step (عند الضغط على R)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R and Config.AutoFlash then
        local enemy = GetClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                -- الدوران نحو العدو
                local targetPos = enemy.Character.HumanoidRootPart.Position
                myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, targetPos)
                -- إرسال Flash Step
                task.wait(0.05)
                SendKey("R")
                print("[RyzHub] Flash Step → " .. enemy.Name)
            end
        end
    end
end)

-- ============================================================
-- 16. إشعار
-- ============================================================
Rayfield:Notify({
    Title = "⚡ RyzHub v6.0",
    Content = "Loaded! FOV + Silent Aim + Auto Flash Step!",
    Duration = 5,
})

print("[RyzHub] v6.0 Loaded successfully! | by mikey")
