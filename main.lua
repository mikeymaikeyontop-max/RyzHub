-- ============================================================
-- ⚡ RYZHUB | v8.0 (Matrix Design + Mobile Floating Button)
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
    FOVRadius = 150,
    AimRange = 300,
    Speed = 16,
    Highlight = false,
    Box = false,
    BoxFill = false,
    HealthBar = false,
    Skeleton = false,
    IgnoreTeam = false,
}

local IgnoreList = {}

local function IsIgnored(player)
    if not player then return true end
    if player == LocalPlayer then return true end
    if IgnoreList[player.Name] then return true end
    if Config.IgnoreTeam and player.Team == LocalPlayer.Team then return true end
    return false
end

-- ============================================================
-- 2. الواجهة الرئيسية (تصميم Matrix)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
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

-- شريط التبويبات العلوي
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 6)
tbc.Parent = TabBar

-- أزرار التبويبات
local currentTab = nil
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
    
    return btn
end

CreateTabButton("Aimbot", 0)
CreateTabButton("Misc", 90)
CreateTabButton("Settings", 180)

-- حاوية المحتوى
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ============================================================
-- 3. إنشاء التبويبات
-- ============================================================
local function CreateTabFrame(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = ContentFrame
    tabFrames[name] = frame
    return frame
end

-- تبويب Aimbot
local AimbotTab = CreateTabFrame("Aimbot")
AimbotTab.Visible = true

-- تبويب Misc
local MiscTab = CreateTabFrame("Misc")

-- تبويب Settings
local SettingsTab = CreateTabFrame("Settings")

-- ============================================================
-- 4. مكونات التصميم
-- ============================================================
local function CreateSection(parent, title, xPos, yPos, width)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0, width, 1, -10)
    section.Position = UDim2.new(0, xPos, 0, 5)
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

local function CreateDropdown(parent, text, options, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 25)
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
    
    local selected = Instance.new("TextButton")
    selected.Size = UDim2.new(0.5, 0, 1, 0)
    selected.Position = UDim2.new(0.5, 0, 0, 0)
    selected.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    selected.Text = options[1] or ""
    selected.TextColor3 = Color3.fromRGB(220, 220, 240)
    selected.TextSize = 11
    selected.Font = Enum.Font.Gotham
    selected.BorderSizePixel = 0
    selected.Parent = frame
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 4)
    sc.Parent = selected
    
    local currentIndex = 1
    selected.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        selected.Text = options[currentIndex]
        callback(options[currentIndex])
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
-- 5. محتوى تبويب Aimbot
-- ============================================================
local ESPColumn = CreateSection(AimbotTab, "ESP", 10, 0, 200)

CreateCheckbox(ESPColumn, "Highlight", 30, function(v) Config.Highlight = v end)
CreateCheckbox(ESPColumn, "AlwaysOnTop", 55, function(v) end)
CreateCheckbox(ESPColumn, "Box", 80, function(v) Config.Box = v end)
CreateCheckbox(ESPColumn, "Box Fill", 105, function(v) Config.BoxFill = v end)
CreateCheckbox(ESPColumn, "HealthBar", 130, function(v) Config.HealthBar = v end)
CreateCheckbox(ESPColumn, "Skeleton", 155, function(v) Config.Skeleton = v end)
CreateCheckbox(ESPColumn, "Ignore Team", 180, function(v) Config.IgnoreTeam = v end)

-- زر إضافة للقائمة
local addIgnoreBtn = Instance.new("TextButton")
addIgnoreBtn.Size = UDim2.new(1, 0, 0, 20)
addIgnoreBtn.Position = UDim2.new(0, 0, 0, 205)
addIgnoreBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
addIgnoreBtn.Text = "Add Nearest to Ignore"
addIgnoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addIgnoreBtn.TextSize = 10
addIgnoreBtn.Font = Enum.Font.GothamBold
addIgnoreBtn.BorderSizePixel = 0
addIgnoreBtn.Parent = ESPColumn

local aic = Instance.new("UICorner")
aic.CornerRadius = UDim.new(0, 4)
aic.Parent = addIgnoreBtn

addIgnoreBtn.MouseButton1Click:Connect(function()
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
                if d < minDist then minDist = d; closest = p end
            end
        end
    end
    if closest then
        IgnoreList[closest.Name] = true
        addIgnoreBtn.Text = "✅ Added: " .. closest.Name
        task.wait(2)
        addIgnoreBtn.Text = "Add Nearest to Ignore"
    end
end)

-- عمود Movement
local MoveColumn = CreateSection(AimbotTab, "Movement", 230, 0, 250)

CreateSlider(MoveColumn, "Speed", 16, 200, 16, 30, function(v)
    Config.Speed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

CreateCheckbox(MoveColumn, "Fly", 65, function(v) end)
CreateCheckbox(MoveColumn, "Auto Strafe", 90, function(v) end)

CreateDropdown(MoveColumn, "Speed Method", {"Normal", "Legit", "Fast"}, 115, function(v) end)

CreateSlider(MoveColumn, "Fly Speed", 16, 200, 50, 145, function(v) end)

-- ============================================================
-- 6. محتوى تبويب Misc
-- ============================================================
local MiscColumn = CreateSection(MiscTab, "Misc", 10, 0, 220)
CreateCheckbox(MiscColumn, "Silent Aim", 30, function(v) Config.SilentAim = v end)
CreateCheckbox(MiscColumn, "Show FOV", 55, function(v) Config.ShowFOV = v end)
CreateCheckbox(MiscColumn, "Noclip", 80, function(v) Config.Noclip = v end)
CreateCheckbox(MiscColumn, "Auto Flash (R)", 105, function(v) Config.AutoFlash = v end)

CreateSlider(MiscColumn, "FOV Radius", 50, 500, 150, 130, function(v) Config.FOVRadius = v end)
CreateSlider(MiscColumn, "Aim Range", 50, 500, 300, 165, function(v) Config.AimRange = v end)

-- ============================================================
-- 7. محتوى تبويب Settings
-- ============================================================
local SettingsColumn = CreateSection(SettingsTab, "Settings", 10, 0, 300)
CreateCheckbox(SettingsColumn, "Enable ESP", 30, function(v) Config.ESP = v end)

-- ============================================================
-- 8. Floating Button (للجوال)
-- ============================================================
local FloatingBtn = Instance.new("ImageButton")
FloatingBtn.Name = "FloatingButton"
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(153, 68, 255)
FloatingBtn.Image = "rbxassetid://11270029456" -- يمكنك تغيير الصورة
FloatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.BorderSizePixel = 0
FloatingBtn.ZIndex = 1000
FloatingBtn.Parent = ScreenGui

local fbc = Instance.new("UICorner")
fbc.CornerRadius = UDim.new(1, 0)
fbc.Parent = FloatingBtn

-- جعل الزر قابلاً للسحب
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

-- عند الضغط على الزر: إخفاء/إظهار الواجهة
local uiVisible = true
FloatingBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end)

-- ============================================================
-- 9. اختصارات الكيبورد (F4 للإخفاء، F7 للإغلاق)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    if input.KeyCode == Enum.KeyCode.F7 then
        Config.SilentAim = false
        Config.ESP = false
        Config.ShowFOV = false
        Config.Noclip = false
        if ScreenGui then ScreenGui:Destroy() end
        getgenv().RyzHubLoaded = false
    end
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
fovStroke.Thickness = 1.5
fovStroke.Parent = FOVFrame

-- ============================================================
-- 11. ESP Folder
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "RyzHubESP"
ESPFolder.Parent = ScreenGui

-- ============================================================
-- 12. الحلقة الرئيسية
-- ============================================================
task.spawn(function()
    while ScreenGui.Parent do
        if Config.ShowFOV then
            FOVFrame.Visible = true
            local mouse = UserInputService:GetMouseLocation()
            FOVFrame.Position = UDim2.new(0, mouse.X - Config.FOVRadius, 0, mouse.Y - Config.FOVRadius)
            FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
        else
            FOVFrame.Visible = false
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
            for _, p in ipairs(Players:GetPlayers()) do
                if not IsIgnored(p) and p.Character and p.Character:FindFirstChild("Head") then
                    if not ESPFolder:FindFirstChild(p.Name) then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = p.Name
                        bb.Size = UDim2.new(0, 100, 0, 30)
                        bb.AlwaysOnTop = true
                        bb.Adornee = p.Character.Head
                        bb.Parent = ESPFolder
                        
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = p.Name
                        txt.TextColor3 = Color3.fromRGB(255, 50, 50)
                        txt.TextSize = 11
                        txt.Font = Enum.Font.GothamBold
                        txt.TextStrokeTransparency = 0
                        txt.Parent = bb
                    end
                end
            end
            
            for _, bb in ipairs(ESPFolder:GetChildren()) do
                local plr = Players:FindFirstChild(bb.Name)
                if not plr or IsIgnored(plr) or not plr.Character then
                    bb:Destroy()
                end
            end
        else
            for _, bb in ipairs(ESPFolder:GetChildren()) do
                bb:Destroy()
            end
        end
        
        task.wait(0.1)
    end
end)

-- ============================================================
-- 13. Auto Flash Step
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R and Config.AutoFlash then
        local closest = nil
        local minDist = Config.AimRange
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myPos = myChar.HumanoidRootPart.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if not IsIgnored(p) and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (myPos - hrp.Position).Magnitude
                    if d < minDist then minDist = d; closest = p end
                end
            end
        end
        if closest and closest.Character:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, closest.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ============================================================
-- 14. إشعار
-- ============================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ RyzHub v8.0",
        Text = "Loaded! Tap the floating button to toggle UI.",
        Duration = 5
    })
end)

print("[RyzHub] v8.0 Loaded successfully!")
