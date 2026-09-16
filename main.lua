-- ============================================================
-- ⚡ RYZHUB | v10.1 (Full Edition)
-- by mikey
-- FOV + ESP + Silent Aim + Aimlock + Mouse Lock + Auto Flash + Whitelist
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
-- 1. الإعدادات + Whitelist
-- ============================================================
local Config = {
    SilentAim = false,
    ESP = false,
    ShowFOV = false,
    Noclip = false,
    AutoFlash = false,
    Aimlock = false,
    MouseLock = false,
    FOVRadius = 150,
    AimRange = 300,
    Speed = 16,
}

local Whitelist = {}

local function IsWhitelisted(player)
    if not player then return true end
    if player == LocalPlayer then return true end
    if Whitelist[player.Name] then return true end
    return false
end

-- ============================================================
-- 2. الواجهة
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
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

-- شريط التبويبات
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

CreateTabButton("Aimbot", 0)
CreateTabButton("Misc", 90)
CreateTabButton("Whitelist", 180)

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

local AimbotTab = CreateTabFrame("Aimbot")
AimbotTab.Visible = true
local MiscTab = CreateTabFrame("Misc")
local WhitelistTab = CreateTabFrame("Whitelist")

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
-- 4. محتوى تبويب Aimbot
-- ============================================================
local ESPColumn = CreateSection(AimbotTab, "ESP", 10, 5, 220)
CreateCheckbox(ESPColumn, "Enable ESP", 30, function(v) Config.ESP = v end)
CreateCheckbox(ESPColumn, "Show Name", 55, function(v) end)
CreateCheckbox(ESPColumn, "Show Distance", 80, function(v) end)

local MoveColumn = CreateSection(AimbotTab, "Movement", 250, 5, 240)
CreateSlider(MoveColumn, "Walk Speed", 16, 200, 16, 30, function(v)
    Config.Speed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
CreateCheckbox(MoveColumn, "Noclip", 65, function(v) Config.Noclip = v end)

-- ============================================================
-- 5. محتوى تبويب Misc
-- ============================================================
local MiscColumn = CreateSection(MiscTab, "Misc", 10, 5, 220)
CreateCheckbox(MiscColumn, "Silent Aim", 30, function(v) Config.SilentAim = v end)
CreateCheckbox(MiscColumn, "Aimlock (Right Click)", 55, function(v) Config.Aimlock = v end)
CreateCheckbox(MiscColumn, "Mouse Lock", 80, function(v) Config.MouseLock = v end)
CreateCheckbox(MiscColumn, "Show FOV", 105, function(v) Config.ShowFOV = v end)
CreateCheckbox(MiscColumn, "Auto Flash (R)", 130, function(v) Config.AutoFlash = v end)
CreateSlider(MiscColumn, "FOV Radius", 50, 500, 150, 155, function(v) Config.FOVRadius = v end)
CreateSlider(MiscColumn, "Aim Range", 50, 500, 300, 190, function(v) Config.AimRange = v end)

-- ============================================================
-- 6. محتوى تبويب Whitelist
-- ============================================================
local WhitelistScroll = Instance.new("ScrollingFrame")
WhitelistScroll.Size = UDim2.new(1, -20, 1, -40)
WhitelistScroll.Position = UDim2.new(0, 10, 0, 35)
WhitelistScroll.BackgroundTransparency = 1
WhitelistScroll.BorderSizePixel = 0
WhitelistScroll.ScrollBarThickness = 4
WhitelistScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 180)
WhitelistScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
WhitelistScroll.Parent = WhitelistTab

local WhitelistList = Instance.new("UIListLayout")
WhitelistList.Padding = UDim.new(0, 2)
WhitelistList.SortOrder = Enum.SortOrder.Name
WhitelistList.Parent = WhitelistScroll

local function RefreshPlayerList()
    for _, child in ipairs(WhitelistScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 24)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.Text = (Whitelist[p.Name] and "✅ " or "❌ ") .. p.Name
            btn.TextColor3 = Whitelist[p.Name] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.Parent = WhitelistScroll
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if Whitelist[p.Name] then
                    Whitelist[p.Name] = nil
                    btn.Text = "❌ " .. p.Name
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                else
                    Whitelist[p.Name] = true
                    btn.Text = "✅ " .. p.Name
                    btn.TextColor3 = Color3.fromRGB(100, 255, 100)
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
RefreshBtn.Parent = WhitelistTab

local rbc = Instance.new("UICorner")
rbc.CornerRadius = UDim.new(0, 4)
rbc.Parent = RefreshBtn

RefreshBtn.MouseButton1Click:Connect(RefreshPlayerList)

-- ============================================================
-- 7. Floating Button
-- ============================================================
local FloatingBtn = Instance.new("ImageButton")
FloatingBtn.Name = "FloatingButton"
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(153, 68, 255)
FloatingBtn.Image = "rbxassetid://11270029456"
FloatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
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
-- 8. FOV Circle (سريع - RenderStepped)
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
-- 9. ESP (محسّن)
-- ============================================================
local espCache = {}

local function CreateESP(player)
    if espCache[player] then return end
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RyzESP_" .. player.Name
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = game:GetService("CoreGui")
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 25)
    nameLabel.BackgroundTransparency = 0.3
    nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 20)
    distLabel.Position = UDim2.new(0, 0, 0, 25)
    distLabel.BackgroundTransparency = 0.3
    distLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Parent = billboard
    
    espCache[player] = billboard
end

local function RemoveESP(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
end

-- ============================================================
-- 10. حلقة ESP + Noclip
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
                    if not IsWhitelisted(p) and p.Character then
                        CreateESP(p)
                    end
                end
                
                for player, gui in pairs(espCache) do
                    if IsWhitelisted(player) or not player.Character or not player.Character:FindFirstChild("Head") then
                        RemoveESP(player)
                    else
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (myChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            local distLabel = gui:FindFirstChild("DistLabel")
                            if distLabel then distLabel.Text = math.floor(dist) .. "m" end
                        end
                    end
                end
            else
                for player, gui in pairs(espCache) do
                    RemoveESP(player)
                end
            end
        end)
        task.wait(0.2)
    end
end)

-- ============================================================
-- 11. الحصول على العدو الأقرب
-- ============================================================
local function GetClosestEnemy()
    local closest = nil
    local minDist = Config.AimRange
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if not IsWhitelisted(p) and p.Character then
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
-- 12. Auto Flash Step (عند الضغط على R)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R and Config.AutoFlash then
        local closest = GetClosestEnemy()
        if closest and closest.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, closest.Character.HumanoidRootPart.Position)
            end
        end
    end
end)

-- ============================================================
-- 13. Silent Aim + Aimlock + Mouse Lock
-- ============================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.SilentAim then
            local closest = GetClosestEnemy()
            if closest and closest.Character then
                local targetPart = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local direction = (targetPart.Position - myChar.HumanoidRootPart.Position).Unit
                        myChar.HumanoidRootPart.CFrame = CFrame.new(myChar.HumanoidRootPart.Position, myChar.HumanoidRootPart.Position + direction)
                    end
                end
            end
        end
        
        if Config.Aimlock then
            local closest = GetClosestEnemy()
            if closest and closest.Character then
                local targetPart = closest.Character:FindFirstChild("Head")
                if targetPart then
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
                end
            end
        end
    end)
end)

-- ============================================================
-- 14. F4 (إخفاء) + F7 (إغلاق كامل)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        MainFrame.Visible = not MainFrame.Visible
        FloatingBtn.Visible = not FloatingBtn.Visible
    end
    
    if input.KeyCode == Enum.KeyCode.F7 then
        print("[RyzHub] Shutting down...")
        
        Config.SilentAim = false
        Config.ESP = false
        Config.ShowFOV = false
        Config.Noclip = false
        Config.AutoFlash = false
        Config.Aimlock = false
        Config.MouseLock = false
        
        for player, gui in pairs(espCache) do
            if gui then gui:Destroy() end
        end
        espCache = {}
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        
        if ScreenGui then
            ScreenGui:Destroy()
            ScreenGui = nil
        end
        
        getgenv().RyzHubLoaded = false
        print("[RyzHub] Script terminated successfully!")
    end
end)

-- ============================================================
-- 15. إشعار
-- ============================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ RyzHub v10.1",
        Text = "Loaded! Press F7 to terminate.",
        Duration = 5
    })
end)

print("[RyzHub] v10.1 Loaded successfully!")
