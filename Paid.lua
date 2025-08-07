local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Hypershot V2.1",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Silent Aim (Headshot)",
    Default = true,
    Callback = function(Value)
        getgenv().SilentAimEnabled = Value
    end
})

VisualTab:AddToggle({
    Name = "ESP Box + Name",
    Default = true,
    Callback = function(Value)
        getgenv().ESPEnabled = Value
    end
})

CombatTab:AddToggle({
    Name = "Anti Recoil / Spread",
    Default = false,
    Callback = function(Value)
        getgenv().AntiRecoil = Value
    end
})

MainTab:AddToggle({
    Name = "Bring Heads",
    Default = false,
    Callback = function(Value)
        getgenv().BringHeads = Value
    end
})

VisualTab:AddToggle({
    Name = "Transparent Wall (Nearby)",
    Default = false,
    Callback = function(Value)
        getgenv().WallTransparency = Value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Silent Aim: Get Closest Target to Crosshair
local function GetClosestTarget()
    local maxDistance = 500
    local closest = nil
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if onScreen and dist < shortest and dist <= maxDistance then
                closest = head
                shortest = dist
            end
        end
    end
    return closest
end

-- Hook __index untuk Silent Aim
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index

mt.__index = function(t, k)
    if getgenv().SilentAimEnabled and tostring(k) == "Hit" then
        local target = GetClosestTarget()
        if target then
            return target
        end
    end
    return oldIndex(t, k)
end

-- Anti Recoil / Spread Logic
RunService.RenderStepped:Connect(function()
    if getgenv().AntiRecoil then
        for _, v in next, getgc(true) do
            if typeof(v) == "table" and rawget(v, "Spread") then
                rawset(v, "Spread", 0)
                rawset(v, "BaseSpread", 0)
                rawset(v, "MinCamRecoil", Vector3.new())
                rawset(v, "MaxCamRecoil", Vector3.new())
                rawset(v, "MinRotRecoil", Vector3.new())
                rawset(v, "MaxRotRecoil", Vector3.new())
                rawset(v, "MinTransRecoil", Vector3.new())
                rawset(v, "MaxTransRecoil", Vector3.new())
            end
        end
    end
end)

-- Bring Heads Logic
RunService.RenderStepped:Connect(function()
    if getgenv().BringHeads then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                head.CFrame = CFrame.new(Camera.CFrame.Position + Camera.CFrame.LookVector * 10)
            end
        end
    end
end)

-- Transparent Walls Logic
RunService.RenderStepped:Connect(function()
    if getgenv().WallTransparency then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency < 0.95 and not obj:IsDescendantOf(LocalPlayer.Character) then
                local distance = (Camera.CFrame.Position - obj.Position).Magnitude
                if distance < 50 then
                    obj.LocalTransparencyModifier = 0.8
                end
            end
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ESP System
RunService.RenderStepped:Connect(function()
    if getgenv().ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if not head:FindFirstChild("YoxanXESP") then
                    local Billboard = Instance.new("BillboardGui")
                    Billboard.Name = "YoxanXESP"
                    Billboard.Adornee = head
                    Billboard.Size = UDim2.new(0, 200, 0, 50)
                    Billboard.StudsOffset = Vector3.new(0, 3, 0)
                    Billboard.AlwaysOnTop = true

                    local NameTag = Instance.new("TextLabel")
                    NameTag.Size = UDim2.new(1, 0, 1, 0)
                    NameTag.BackgroundTransparency = 1
                    NameTag.TextStrokeTransparency = 0.5
                    NameTag.Text = player.Name
                    NameTag.TextScaled = true
                    NameTag.Font = Enum.Font.SourceSansBold
                    NameTag.TextColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    NameTag.Parent = Billboard

                    Billboard.Parent = head
                end
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local esp = player.Character.Head:FindFirstChild("YoxanXESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- Wall Transparency Nearby
RunService.RenderStepped:Connect(function()
    if getgenv().WallTransparency then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency < 0.3 and v:IsDescendantOf(workspace) then
                local dist = (v.Position - Camera.CFrame.Position).Magnitude
                if dist <= 40 then
                    v.Transparency = 0.7
                    v.Material = Enum.Material.ForceField
                end
            end
        end
    end
end)

OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "✅ All Features Are Ready!",
    Image = "rbxassetid://7734068321", -- Icon bisa diganti sesuai preferensi
    Time = 5
})
