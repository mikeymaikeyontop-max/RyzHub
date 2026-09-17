-- ============================================================
-- ⚡ RYZHUB | v24.0 (All Directly in ScreenGui)
-- by mikey
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
-- 1. الإعدادات
-- ============================================================
local Config = {
    SilentAim = false,
    Aimlock = false,
    MouseLock = false,
    ShowFOV = false,
    AutoSoru = false,
    ESP = false,
    ESPDistance = false,
    ESPHealth = false,
    SpeedHack = false,
    Fly = false,
    FOVRadius = 150,
    AimRange = 300,
    Speed = 16,
    FlySpeed = 50,
    SoruAHK = false,
    SoruKey = "Z",
}

local Blacklist = {}

local function IsBlacklisted(player)
    if not player then return true end
    if player == LocalPlayer then return true end
    if Blacklist[player.Name] then return true end
    return false
end

-- ============================================================
-- 2. الواجهة
-- ============================================================
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- العنوان (مباشرة في ScreenGui)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 580, 0, 35)
Title.Position = UDim2.new(0.5, -290, 0.5, -230)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.BackgroundTransparency = 0.1
Title.Text = "⚡ RYZHUB | by mikey"
Title.TextColor3 = Color3.fromRGB(153, 68, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.BorderSizePixel = 0
Title.Parent = ScreenGui
Title.ZIndex = 2

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = Title

-- ============================================================
-- 3. نظام التبويبات
-- ============================================================
local currentTab = "Combat"
local tabButtons = {}
local tabElements = {
    Combat = {},
    ESP = {},
    Misc = {},
    AHK = {},
    Blacklist = {},
}

local function SwitchTab(tabName)
    currentTab = tabName
    for tab, elements in pairs(tabElements) do
        for _, el in ipairs(elements) do
            if el and el.Parent then
                el.Visible = (tab == tabName)
            end
        end
    end
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.TextColor3 = Color3.fromRGB(220, 220, 240)
            btn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
        else
            btn.TextColor3 = Color3.fromRGB(180, 180, 190)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
    end
end

local function RegisterElement(tab, element)
    table.insert(tabElements[tab], element)
    element.Visible = (currentTab == tab)
end

local function CreateTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 28)
    btn.Position = UDim2.new(0.5, -290 + xPos, 0.5, -190)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = ScreenGui
    btn.ZIndex = 2
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    
    tabButtons[name] = btn
end

CreateTabButton("Combat", 0)
CreateTabButton("ESP", 95)
CreateTabButton("Misc", 190)
CreateTabButton("AHK", 285)
CreateTabButton("Blacklist", 380)

-- حقوق mikey
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(0, 580, 0, 20)
Credits.Position = UDim2.new(0.5, -290, 0.5, 230)
Credits.BackgroundTransparency = 1
Credits.Text = "⚡ RyzHub | Made by mikey ⚡"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 10
Credits.Font = Enum.Font.GothamItalic
Credits.Parent = ScreenGui
Credits.ZIndex = 2

-- ============================================================
-- 4. دوال مساعدة
-- ============================================================
local function CreateCheckbox(tab, text, xPos, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 22)
    frame.Position = UDim2.new(0.5, -290 + xPos, 0.5, -150 + yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = ScreenGui
    frame.ZIndex = 3
    RegisterElement(tab, frame)
    
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 16, 0, 16)
    checkbox.Position = UDim2.new(0, 0, 0, 3)
    checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    checkbox.Text = ""
    checkbox.BorderSizePixel = 1
    checkbox.BorderColor3 = Color3.fromRGB(80, 80, 90)
    checkbox.Parent = frame
    checkbox.ZIndex = 4
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 2)
    c.Parent = checkbox
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -25, 1, 0)
    label.Position = UDim2.new(0, 25, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 4
    
    local state = false
    checkbox.MouseButton1Click:Connect(function()
        state = not state
        if state then
            checkbox.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
        else
            checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        callback(state)
    end)
end

local function CreateSlider(tab, text, minVal, maxVal, default, xPos, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 30)
    frame.Position = UDim2.new(0.5, -290 + xPos, 0.5, -150 + yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = ScreenGui
    frame.ZIndex = 3
    RegisterElement(tab, frame)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 4
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    valueLabel.ZIndex = 4
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.3, -5, 0, 6)
    bar.Position = UDim2.new(0.7, 0, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    bar.ZIndex = 4
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    fill.ZIndex = 5
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill
    
    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local x = input.Position.X - bar.AbsolutePosition.X
            local p = math.clamp(x / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0)
            local val = math.floor(minVal + (maxVal - minVal) * p)
            valueLabel.Text = tostring(val)
            callback(val)
        end
    end)
end

-- ============================================================
-- 5. تبويب Combat
-- ============================================================
CreateCheckbox("Combat", "Silent Aim", 15, 0, function(v) Config.SilentAim = v end)
CreateCheckbox("Combat", "Aimlock", 15, 27, function(v) Config.Aimlock = v end)
CreateCheckbox("Combat", "Mouse Lock", 15, 54, function(v) Config.MouseLock = v end)
CreateCheckbox("Combat", "Show FOV", 15, 81, function(v) Config.ShowFOV = v end)
CreateCheckbox("Combat", "Auto Soru", 15, 108, function(v) Config.AutoSoru = v end)

CreateSlider("Combat", "FOV Radius", 50, 500, 150, 290, 0, function(v) Config.FOVRadius = v end)
CreateSlider("Combat", "Aim Range", 50, 500, 300, 290, 40, function(v) Config.AimRange = v end)

-- ============================================================
-- 6. تبويب ESP
-- ============================================================
CreateCheckbox("ESP", "Enable ESP", 15, 0, function(v) Config.ESP = v end)
CreateCheckbox("ESP", "ESP Distance", 15, 27, function(v) Config.ESPDistance = v end)
CreateCheckbox("ESP", "ESP Health", 15, 54, function(v) Config.ESPHealth = v end)

-- ============================================================
-- 7. تبويب Misc
-- ============================================================
CreateCheckbox("Misc", "Speed Hack", 15, 0, function(v) Config.SpeedHack = v end)
CreateCheckbox("Misc", "Fly", 15, 27, function(v) Config.Fly = v end)
CreateSlider("Misc", "Speed", 16, 200, 16, 15, 60, function(v) Config.Speed = v end)
CreateSlider("Misc", "Fly Speed", 10, 200, 50, 15, 100, function(v) Config.FlySpeed = v end)

-- ============================================================
-- 8. تبويب AHK
-- ============================================================
CreateCheckbox("AHK", "Auto Soru AHK", 15, 0, function(v) Config.SoruAHK = v end)

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0, 250, 0, 20)
keyLabel.Position = UDim2.new(0.5, -290 + 15, 0.5, -150 + 30)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Select Key to Press:"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
keyLabel.TextSize = 12
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = ScreenGui
keyLabel.ZIndex = 3
RegisterElement("AHK", keyLabel)

local keyButtons = {}
local function CreateKeyButton(text, xPos, yPos, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 28)
    btn.Position = UDim2.new(0.5, -290 + xPos, 0.5, -150 + yPos)
    btn.BackgroundColor3 = (Config.SoruKey == keyName) and Color3.fromRGB(100, 50, 180) or Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = ScreenGui
    btn.ZIndex = 3
    RegisterElement("AHK", btn)
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config.SoruKey = keyName
        for _, b in pairs(keyButtons) do
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
    end)
    
    table.insert(keyButtons, btn)
end

CreateKeyButton("Z", 15, 60, "Z")
CreateKeyButton("X", 65, 60, "X")
CreateKeyButton("C", 115, 60, "C")

-- ============================================================
-- 9. تبويب Blacklist
-- ============================================================
local blacklistButtons = {}

local function RefreshPlayerList()
    for _, btn in ipairs(blacklistButtons) do
        btn:Destroy()
    end
    blacklistButtons = {}
    
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 540, 0, 26)
            btn.Position = UDim2.new(0.5, -290 + 15, 0.5, -150 + y)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.Text = (Blacklist[p.Name] and "🚫 " or "✅ ") .. p.Name
            btn.TextColor3 = Blacklist[p.Name] and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.Parent = ScreenGui
            btn.ZIndex = 3
            RegisterElement("Blacklist", btn)
            table.insert(blacklistButtons, btn)
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if Blacklist[p.Name] then
                    Blacklist[p.Name] = nil
                    btn.Text = "✅ " .. p.Name
                    btn.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    Blacklist[p.Name] = true
                    btn.Text = "🚫 " .. p.Name
                    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
            end)
            
            y = y + 30
        end
    end
end

RefreshPlayerList()

-- ============================================================
-- 10. Floating Button
-- ============================================================
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(153, 68, 255)
FloatingBtn.Text = "⚡"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 24
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.BorderSizePixel = 0
FloatingBtn.ZIndex = 1000
FloatingBtn.Parent = ScreenGui

local fbc = Instance.new("UICorner")
fbc.CornerRadius = UDim.new(1, 0)
fbc.Parent = FloatingBtn

local draggingFB = false
local dragStartFB, startPosFB

FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFB = true
        dragStartFB = input.Position
        startPosFB = FloatingBtn.Position
    end
end)

FloatingBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFB = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingFB and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartFB
        FloatingBtn.Position = UDim2.new(startPosFB.X.Scale, startPosFB.X.Offset + delta.X, startPosFB.Y.Scale, startPosFB.Y.Offset + delta.Y)
    end
end)

FloatingBtn.MouseButton1Click:Connect(function()
    for _, elements in pairs(tabElements) do
        for _, el in ipairs(elements) do
            el.Visible = not el.Visible
        end
    end
    for _, btn in pairs(tabButtons) do
        btn.Visible = not btn.Visible
    end
    Title.Visible = not Title.Visible
    Credits.Visible = not Credits.Visible
end)

-- ============================================================
-- 11. FOV Circle
-- ============================================================
local FOVFrame = Instance.new("Frame")
FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderSizePixel = 0
FOVFrame.Visible = false
FOVFrame.ZIndex = 500
FOVFrame.Parent = ScreenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = FOVFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(153, 68, 255)
fovStroke.Thickness = 2
fovStroke.Parent = FOVFrame

-- ============================================================
-- 12. 3D Flash Box
-- ============================================================
local FlashBoxPart = Instance.new("Part")
FlashBoxPart.Name = "RyzFlashBox"
FlashBoxPart.Size = Vector3.new(6, 6, 6)
FlashBoxPart.Transparency = 1
FlashBoxPart.Color = Color3.fromRGB(255, 0, 0)
FlashBoxPart.Material = Enum.Material.Neon
FlashBoxPart.CanCollide = false
FlashBoxPart.Anchored = true
FlashBoxPart.CastShadow = false
FlashBoxPart.Parent = workspace

local flashHighlight = Instance.new("Highlight")
flashHighlight.Name = "RyzFlashHighlight"
flashHighlight.FillColor = Color3.fromRGB(255, 0, 0)
flashHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
flashHighlight.FillTransparency = 0.7
flashHighlight.OutlineTransparency = 0
flashHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
flashHighlight.Adornee = FlashBoxPart
flashHighlight.Parent = FlashBoxPart

-- ============================================================
-- 13. ESP
-- ============================================================
local espCache = {}

local function CreateESP(player)
    if espCache[player] then return end
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "RyzESP_" .. player.Name
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RyzName_" .. player.Name
    billboard.Size = UDim2.new(0, 150, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = PlayerGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 20)
    distLabel.Position = UDim2.new(0, 0, 0, 20)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.Position = UDim2.new(0, 0, 0, 40)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100HP"
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextSize = 10
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.Parent = billboard
    
    espCache[player] = {highlight = highlight, billboard = billboard, distLabel = distLabel, healthLabel = healthLabel}
end

local function RemoveESP(player)
    if espCache[player] then
        if espCache[player].highlight then espCache[player].highlight:Destroy() end
        if espCache[player].billboard then espCache[player].billboard:Destroy() end
        espCache[player] = nil
    end
end

-- ============================================================
-- 14. GetClosestEnemy
-- ============================================================
local function GetClosestEnemy()
    local closest = nil
    local minDist = Config.AimRange
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if not IsBlacklisted(p) and p.Character then
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
-- 15. Fly + Speed Hack + Auto Soru
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        if Config.SpeedHack then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Config.Speed
            end
        end
        
        if Config.Fly then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not hrp:FindFirstChild("RyzFly") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "RyzFly"
                    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = hrp
                end
                local bv = hrp:FindFirstChild("RyzFly")
                if bv then
                    local moveDir = Vector3.new(0, 0, 0)
                    local camCF = Camera.CFrame
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = moveDir.Unit * Config.FlySpeed
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        else
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("RyzFly")
                if bv then bv:Destroy() end
            end
        end
        
        if Config.AutoSoru then
            local enemy = GetClosestEnemy()
            if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local myHrp = char:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    myHrp.CFrame = CFrame.new(myHrp.Position, enemy.Character.HumanoidRootPart.Position)
                end
            end
        end
    end)
end)

-- ============================================================
-- 16. Soru AHK Logic
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R and Config.SoruAHK then
        local target = FlashBoxPart:GetAttribute("TargetPlayer")
        if target then
            local targetPlayer = Players:FindFirstChild(target)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.wait(0.05)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end)
                    task.wait(0.1)
                    pcall(function()
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game)
                        task.wait(0.05)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game)
                    end)
                    myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, targetPlayer.Character.HumanoidRootPart.Position)
                    local key = Config.SoruKey
                    pcall(function()
                        if key == "Z" then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                        elseif key == "X" then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.X, false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.X, false, game)
                        elseif key == "C" then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.C, false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.C, false, game)
                        end
                    end)
                end
            end
        end
    end
end)

-- ============================================================
-- 17. FOV Circle Update
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.ShowFOV and FOVFrame then
            FOVFrame.Visible = true
            local mouse = UserInputService:GetMouseLocation()
            FOVFrame.Position = UDim2.new(0, mouse.X - Config.FOVRadius, 0, mouse.Y - Config.FOVRadius)
            FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
        elseif FOVFrame then
            FOVFrame.Visible = false
        end
    end)
end)

-- ============================================================
-- 18. ESP Loop
-- ============================================================
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        pcall(function()
            if Config.ESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    if not IsBlacklisted(p) and p.Character then
                        CreateESP(p)
                    end
                end
                for player, data in pairs(espCache) do
                    if IsBlacklisted(player) or not player.Character then
                        RemoveESP(player)
                    else
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (myChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            data.distLabel.Text = math.floor(dist) .. "m"
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                data.healthLabel.Text = math.floor(humanoid.Health) .. "HP"
                                if humanoid.Health > 50 then
                                    data.healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                elseif humanoid.Health > 25 then
                                    data.healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                                else
                                    data.healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end
                    end
                end
            else
                for player, data in pairs(espCache) do
                    RemoveESP(player)
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- ============================================================
-- 19. Silent Aim + Aimlock + MouseLock
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.SilentAim or Config.Aimlock or Config.MouseLock then
            local closest = GetClosestEnemy()
            if closest and closest.Character then
                local targetPart = closest.Character:FindFirstChild("Head")
                if targetPart then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
                end
            end
        end
    end)
end)

-- ============================================================
-- 20. F4 (إخفاء) + F7 (إغلاق)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        for _, elements in pairs(tabElements) do
            for _, el in ipairs(elements) do
                el.Visible = not el.Visible
            end
        end
        for _, btn in pairs(tabButtons) do
            btn.Visible = not btn.Visible
        end
        Title.Visible = not Title.Visible
        Credits.Visible = not Credits.Visible
        FloatingBtn.Visible = not FloatingBtn.Visible
    end
    
    if input.KeyCode == Enum.KeyCode.F7 then
        Config.SilentAim = false
        Config.ESP = false
        Config.ShowFOV = false
        Config.Noclip = false
        Config.AutoFlash = false
        Config.Aimlock = false
        Config.Fly = false
        Config.SoruAHK = false
        Config.SpeedHack = false
        Config.AutoSoru = false
        Config.MouseLock = false
        
        for player, data in pairs(espCache) do
            RemoveESP(player)
        end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        
        if FlashBoxPart then FlashBoxPart:Destroy() end
        if ScreenGui then ScreenGui:Destroy() end
        getgenv().RyzHubLoaded = false
    end
end)

-- ============================================================
-- 21. إشعار
-- ============================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ RyzHub v24.0",
        Text = "Loaded! by mikey",
        Duration = 5
    })
end)

print("[RyzHub] v24.0 Loaded successfully! by mikey")
