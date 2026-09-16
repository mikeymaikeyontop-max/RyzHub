-- ============================================================
-- ⚡ RYZHUB | v7.0 (Mobile Lite Edition)
-- by mikey
-- خفيف جداً + متوافق مع الهواتف + Ignore List
-- ============================================================

print("[RyzHub] Loading Lite Edition...")

if getgenv().RyzHubLoaded then return end
getgenv().RyzHubLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- 🔐 1. قائمة التجاهل
-- ============================================================
local IgnoreList = {}

local function IsIgnored(player)
    if not player then return true end
    if player == LocalPlayer then return true end
    if IgnoreList[player.Name] then return true end
    return false
end

-- ============================================================
-- 2. الإعدادات
-- ============================================================
local Config = {
    SilentAim = false,
    ESP = false,
    ShowFOV = false,
    Noclip = false,
    AutoFlash = false,
    FOVRadius = 150,
    AimRange = 300,
    Speed = 16,
}

-- ============================================================
-- 3. الواجهة (خفيفة جداً - بدون مكتبات خارجية)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0, 10, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(153, 68, 255)
stroke.Thickness = 1
stroke.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Text = "⚡ RYZHUB v7.0"
Title.TextColor3 = Color3.fromRGB(153, 68, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 8)
tc.Parent = Title

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 5)
cc.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if ESPFolder then ESPFolder:Destroy() end
    if FOVFrame then FOVFrame:Destroy() end
    getgenv().RyzHubLoaded = false
end)

-- ============================================================
-- 4. دالة Toggle خفيفة
-- ============================================================
local currentY = 40

local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 28)
    btn.Position = UDim2.new(0, 8, 0, currentY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = "❌ " .. text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = "✅ " .. text
            btn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
        else
            btn.Text = "❌ " .. text
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        callback(state)
    end)
    
    currentY = currentY + 32
end

-- ============================================================
-- 5. العناصر
-- ============================================================
CreateToggle("Silent Aim", function(v) Config.SilentAim = v end)
CreateToggle("Player ESP", function(v)
    Config.ESP = v
    if not v and ESPFolder then
        for _, x in pairs(ESPFolder:GetChildren()) do x:Destroy() end
    end
end)
CreateToggle("Show FOV", function(v) Config.ShowFOV = v end)
CreateToggle("Noclip", function(v) Config.Noclip = v end)
CreateToggle("Auto Flash (R)", function(v) Config.AutoFlash = v end)
CreateToggle("Speed Boost", function(v)
    Config.Speed = v and 100 or 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Speed
    end
end)

-- زر إضافة لاعب للقائمة
local AddIgnoreBtn = Instance.new("TextButton")
AddIgnoreBtn.Size = UDim2.new(1, -16, 0, 28)
AddIgnoreBtn.Position = UDim2.new(0, 8, 0, currentY)
AddIgnoreBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
AddIgnoreBtn.Text = "🚫 Add Nearest to Ignore"
AddIgnoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddIgnoreBtn.TextSize = 10
AddIgnoreBtn.Font = Enum.Font.GothamBold
AddIgnoreBtn.BorderSizePixel = 0
AddIgnoreBtn.Parent = MainFrame

local aic = Instance.new("UICorner")
aic.CornerRadius = UDim.new(0, 5)
aic.Parent = AddIgnoreBtn

AddIgnoreBtn.MouseButton1Click:Connect(function()
    local closest = nil
    local minDist = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (myPos - hrp.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closest = p
                end
            end
        end
    end
    
    if closest then
        IgnoreList[closest.Name] = true
        AddIgnoreBtn.Text = "✅ Added: " .. closest.Name
        task.wait(2)
        AddIgnoreBtn.Text = "🚫 Add Nearest to Ignore"
    end
end)

currentY = currentY + 32

-- ============================================================
-- 6. FOV Circle (يتبع الماوس - خفيف)
-- ============================================================
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderSizePixel = 0
FOVFrame.Visible = false
FOVFrame.ZIndex = 999
FOVFrame.Parent = ScreenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = FOVFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(153, 68, 255)
fovStroke.Thickness = 1.5
fovStroke.Parent = FOVFrame

-- ============================================================
-- 7. ESP Folder
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RyzHubESP"
ESPFolder.Parent = ScreenGui

-- ============================================================
-- 8. الحصول على العدو الأقرب
-- ============================================================
local function GetClosestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local closest = nil
    local minDist = Config.AimRange
    
    for _, p in ipairs(Players:GetPlayers()) do
        if not IsIgnored(p) and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (myPos - hrp.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closest = p
                end
            end
        end
    end
    return closest
end

-- ============================================================
-- 9. ESP (خفيف)
-- ============================================================
local espCache = {}

local function CreateESP(player)
    if espCache[player] then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 80, 0, 20)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = ESPFolder
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = player.Name
    text.TextColor3 = Color3.fromRGB(255, 50, 50)
    text.TextSize = 11
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.Parent = billboard
    
    espCache[player] = billboard
end

-- ============================================================
-- 10. الحلقة الرئيسية (خفيفة - 10 FPS بدلاً من 60)
-- ============================================================
task.spawn(function()
    while ScreenGui.Parent do
        -- FOV Circle يتبع الماوس
        if FOVFrame then
            FOVFrame.Visible = Config.ShowFOV
            if Config.ShowFOV then
                local mouse = UserInputService:GetMouseLocation()
                FOVFrame.Position = UDim2.new(0, mouse.X - Config.FOVRadius, 0, mouse.Y - Config.FOVRadius)
                FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
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
            for _, p in ipairs(Players:GetPlayers()) do
                if not IsIgnored(p) and p.Character then
                    CreateESP(p)
                end
            end
            
            for player, gui in pairs(espCache) do
                if IsIgnored(player) or not player.Character then
                    gui:Destroy()
                    espCache[player] = nil
                end
            end
        end
        
        task.wait(0.1) -- 10 FPS (خفيف جداً)
    end
end)

-- ============================================================
-- 11. Auto Flash Step (عند الضغط على R)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R and Config.AutoFlash then
        local enemy = GetClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local targetPos = enemy.Character.HumanoidRootPart.Position
                myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, targetPos)
            end
        end
    end
end)

-- ============================================================
-- 12. إشعار
-- ============================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ RyzHub v7.0",
        Text = "Mobile Lite Edition Loaded!",
        Duration = 3
    })
end)

print("[RyzHub] v7.0 Lite Loaded successfully!")
