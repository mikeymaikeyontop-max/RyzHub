-- ============================================================
-- ⚡ RYZHUB | v14.1 (Big Red Flash Target Box) + AHK
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
    ESP = false,
    ShowFOV = false,
    Noclip = false,
    AutoFlash = false,
    Aimlock = false,
    Fly = false,
    Hitbox = false,
    SmartAutoV3 = false,
    JumpMacro = false,
    FOVRadius = 150,
    AimRange = 300,
    Speed = 16,
    FlySpeed = 50,
    -- Soru AHK (إضافة جديدة)
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

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 420)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = MainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 90)
stroke.Thickness = 1
stroke.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 6)
tbc.Parent = TabBar

local tabFrames = {}

local function CreateTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        if tabFrames[name] then tabFrames[name].Visible = true end
        for _, c in pairs(TabBar:GetChildren()) do
            if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(180, 180, 190) end
        end
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    end)
end

CreateTabButton("Combat", 0)
CreateTabButton("ESP", 90)
CreateTabButton("Misc", 180)
CreateTabButton("AHK", 270)
CreateTabButton("Blacklist", 360)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function CreateTabFrame(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = ContentFrame
    tabFrames[name] = frame
    return frame
end

local CombatTab = CreateTabFrame("Combat")
CombatTab.Visible = true
local ESPTab = CreateTabFrame("ESP")
local MiscTab = CreateTabFrame("Misc")
local AHKTab = CreateTabFrame("AHK")
local BlacklistTab = CreateTabFrame("Blacklist")

-- ============================================================
-- 3. دوال مساعدة
-- ============================================================
local function CreateSection(parent, title, xPos, yPos, width)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0, width, 1, -10)
    section.Position = UDim2.new(0, xPos, 0, yPos)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    return section
end

local function CreateCheckbox(parent, text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 14, 0, 14)
    checkbox.Position = UDim2.new(0, 0, 0, 3)
    checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    checkbox.Text = ""
    checkbox.BorderSizePixel = 1
    checkbox.BorderColor3 = Color3.fromRGB(80, 80, 90)
    checkbox.Parent = frame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 2)
    c.Parent = checkbox
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
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

local function CreateSlider(parent, text, minVal, maxVal, default, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.3, -5, 0, 6)
    bar.Position = UDim2.new(0.7, 0, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
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
-- 4. تبويب Combat
-- ============================================================
local CombatCol1 = CreateSection(CombatTab, "Combat Skills", 10, 5, 250)
CreateCheckbox(CombatCol1, "Silent Aim", 30, function(v) Config.SilentAim = v end)
CreateCheckbox(CombatCol1, "Aimlock", 55, function(v) Config.Aimlock = v end)
CreateCheckbox(CombatCol1, "Auto Flash (Click Target)", 80, function(v) Config.AutoFlash = v end)
CreateCheckbox(CombatCol1, "Hitbox System", 105, function(v) Config.Hitbox = v end)
CreateCheckbox(CombatCol1, "Smart Auto V3", 130, function(v) Config.SmartAutoV3 = v end)

local CombatCol2 = CreateSection(CombatTab, "Targeting", 280, 5, 250)
CreateSlider(CombatCol2, "FOV Radius", 50, 500, 150, 30, function(v) Config.FOVRadius = v end)
CreateSlider(CombatCol2, "Aim Range", 50, 500, 300, 65, function(v) Config.AimRange = v end)
CreateCheckbox(CombatCol2, "Show FOV", 100, function(v) Config.ShowFOV = v end)

-- ============================================================
-- 5. تبويب ESP
-- ============================================================
local ESPCol = CreateSection(ESPTab, "ESP Settings", 10, 5, 520)
CreateCheckbox(ESPCol, "Enable ESP", 30, function(v) Config.ESP = v end)
CreateCheckbox(ESPCol, "Reduced Detail", 55, function(v) Config.ReducedESP = v end)

-- ============================================================
-- 6. تبويب Misc
-- ============================================================
local MiscCol1 = CreateSection(MiscTab, "Movement", 10, 5, 250)
CreateSlider(MiscCol1, "Walk Speed", 16, 200, 16, 30, function(v)
    Config.Speed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
CreateCheckbox(MiscCol1, "Noclip", 65, function(v) Config.Noclip = v end)
CreateCheckbox(MiscCol1, "Fly", 90, function(v) Config.Fly = v end)
CreateSlider(MiscCol1, "Fly Speed", 10, 200, 50, 115, function(v) Config.FlySpeed = v end)

-- ============================================================
-- 7. تبويب AHK (Soru AHK) - الإضافة الجديدة
-- ============================================================
local AHKCol = CreateSection(AHKTab, "Soru AHK Settings", 10, 5, 520)

CreateCheckbox(AHKCol, "Enable Soru AHK (Press R)", 30, function(v) 
    Config.SoruAHK = v 
    print("[RyzHub] Soru AHK: " .. tostring(v))
end)

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 20)
keyLabel.Position = UDim2.new(0, 0, 0, 60)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Select Key to Press:"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
keyLabel.TextSize = 11
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = AHKCol

local keyButtons = {}
local function CreateKeyButton(text, xPos, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 28)
    btn.Position = UDim2.new(0, xPos, 0, 85)
    btn.BackgroundColor3 = (Config.SoruKey == keyName) and Color3.fromRGB(100, 50, 180) or Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = AHKCol
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config.SoruKey = keyName
        for _, b in pairs(keyButtons) do
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
        print("[RyzHub] Soru Key changed to: " .. keyName)
    end)
    
    table.insert(keyButtons, btn)
end

CreateKeyButton("Z", 0, "Z")
CreateKeyButton("X", 50, "X")
CreateKeyButton("C", 100, "C")

-- ============================================================
-- 8. تبويب Blacklist
-- ============================================================
local BlacklistScroll = Instance.new("ScrollingFrame")
BlacklistScroll.Size = UDim2.new(1, -20, 1, -40)
BlacklistScroll.Position = UDim2.new(0, 10, 0, 35)
BlacklistScroll.BackgroundTransparency = 1
BlacklistScroll.BorderSizePixel = 0
BlacklistScroll.ScrollBarThickness = 4
BlacklistScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 180)
BlacklistScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
BlacklistScroll.Parent = BlacklistTab

local BlacklistList = Instance.new("UIListLayout")
BlacklistList.Padding = UDim.new(0, 2)
BlacklistList.SortOrder = Enum.SortOrder.Name
BlacklistList.Parent = BlacklistScroll

local function RefreshPlayerList()
    for _, child in ipairs(BlacklistScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 24)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.Text = (Blacklist[p.Name] and "🚫 " or "✅ ") .. p.Name
            btn.TextColor3 = Blacklist[p.Name] and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.Parent = BlacklistScroll
            
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
        end
    end
end

RefreshPlayerList()

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 25)
RefreshBtn.Position = UDim2.new(0, 10, 1, -30)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
RefreshBtn.Text = "🔄 Refresh Player List"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 11
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Parent = BlacklistTab

local rbc = Instance.new("UICorner")
rbc.CornerRadius = UDim.new(0, 4)
rbc.Parent = RefreshBtn

RefreshBtn.MouseButton1Click:Connect(RefreshPlayerList)

-- ============================================================
-- 9. Floating Button
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

local dragging = false
local dragStart, startPos

FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
    end
end)

FloatingBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ============================================================
-- 10. FOV Circle
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
-- 11. Flash Target Box (كبير - 200x200)
-- ============================================================
local flashBox = Instance.new("TextButton")
flashBox.Name = "FlashTargetBox"
flashBox.Size = UDim2.new(0, 200, 0, 200)
flashBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flashBox.BackgroundTransparency = 0.6
flashBox.Text = ""
flashBox.TextColor3 = Color3.fromRGB(255, 255, 255)
flashBox.TextSize = 14
flashBox.Font = Enum.Font.GothamBold
flashBox.BorderSizePixel = 4
flashBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
flashBox.Visible = false
flashBox.ZIndex = 999
flashBox.Parent = ScreenGui

local flashCorner = Instance.new("UICorner")
flashCorner.CornerRadius = UDim.new(0, 15)
flashCorner.Parent = flashBox

flashBox.MouseEnter:Connect(function()
    flashBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flashBox.BackgroundTransparency = 0.3
    flashBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
    flashBox.BorderSizePixel = 6
end)

flashBox.MouseLeave:Connect(function()
    flashBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flashBox.BackgroundTransparency = 0.6
    flashBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
    flashBox.BorderSizePixel = 4
end)

flashBox.MouseButton1Click:Connect(function()
    local target = flashBox:GetAttribute("TargetPlayer")
    if target then
        local targetPlayer = Players:FindFirstChild(target)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, targetPlayer.Character.HumanoidRootPart.Position)
                pcall(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game)
                    task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game)
                end)
                print("[RyzHub] Flash Step → " .. targetPlayer.Name)
            end
        end
    end
end)

-- ============================================================
-- 12. ESP
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
    highlight.FillTransparency = Config.ReducedESP and 0.7 or 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RyzName_" .. player.Name
    billboard.Size = UDim2.new(0, 150, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = PlayerGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard
    
    espCache[player] = {highlight = highlight, billboard = billboard}
end

local function RemoveESP(player)
    if espCache[player] then
        if espCache[player].highlight then espCache[player].highlight:Destroy() end
        if espCache[player].billboard then espCache[player].billboard:Destroy() end
        espCache[player] = nil
    end
end

-- ============================================================
-- 13. GetClosestEnemy
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
-- 14. Fly
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.Fly then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
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
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local bv = char.HumanoidRootPart:FindFirstChild("RyzFly")
                if bv then bv:Destroy() end
            end
        end
    end)
end)

-- ============================================================
-- 15. Auto Flash Step Box Update
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.AutoFlash then
            local enemy = GetClosestEnemy()
            if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
                local head = enemy.Character.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    flashBox.Visible = true
                    flashBox.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y - 100)
                    flashBox:SetAttribute("TargetPlayer", enemy.Name)
                else
                    flashBox.Visible = false
                end
            else
                flashBox.Visible = false
            end
        else
            flashBox.Visible = false
        end
    end)
end)

-- ============================================================
-- 16. Soru AHK Logic (عند الضغط على R)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R and Config.SoruAHK then
        local target = flashBox:GetAttribute("TargetPlayer")
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
                    print("[RyzHub] Soru AHK → " .. targetPlayer.Name)
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
-- 18. Noclip + ESP
-- ============================================================
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        pcall(function()
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
                for _, p in ipairs(Players:GetPlayers()) do
                    if not IsBlacklisted(p) and p.Character then
                        CreateESP(p)
                    end
                end
                for player, data in pairs(espCache) do
                    if IsBlacklisted(player) or not player.Character then
                        RemoveESP(player)
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
-- 19. Silent Aim + Aimlock
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.SilentAim or Config.Aimlock then
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
        MainFrame.Visible = not MainFrame.Visible
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
        
        for player, data in pairs(espCache) do
            RemoveESP(player)
        end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        
        if ScreenGui then ScreenGui:Destroy() end
        getgenv().RyzHubLoaded = false
    end
end)

-- ============================================================
-- 21. إشعار
-- ============================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ RyzHub v14.1 + AHK",
        Text = "Big Red Flash Target + Soru AHK Loaded!",
        Duration = 5
    })
end)

print("[RyzHub] v14.1 + AHK Loaded successfully!")
