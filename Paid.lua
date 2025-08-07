-- Local OrionLib setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Create main window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Hypershot V1.5",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "YoxanXHub Loaded"
})

-- Tabs
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local VisualTab = Window:MakeTab({Name = "Visual", Icon = "rbxassetid://4483362458", PremiumOnly = false})

-- Silent Aim Toggle
MainTab:AddToggle({
    Name = "Silent Aim (Headshot)",
    Default = true,
    Callback = function(Value)
        getgenv().SilentAimEnabled = Value
    end
})

-- ESP Toggle
VisualTab:AddToggle({
    Name = "ESP Box + Name",
    Default = true,
    Callback = function(Value)
        getgenv().ESPEnabled = Value
    end
})

-- ESP Text Size Slider
VisualTab:AddSlider({
    Name = "ESP Text Size",
    Min = 8,
    Max = 24,
    Default = 12,
    Increment = 1,
    Callback = function(Value)
        getgenv().ESPTextSize = Value
    end
})

-- No Recoil Toggle
CombatTab:AddToggle({
    Name = "Anti Recoil / Spread",
    Default = false,
    Callback = function(Value)
        getgenv().AntiRecoil = Value
    end
})

-- Bring Head Feature Toggle
MainTab:AddToggle({
    Name = "Bring Heads",
    Default = false,
    Callback = function(Value)
        getgenv().BringHeads = Value
    end
})

-- Wall Transparency Toggle
VisualTab:AddToggle({
    Name = "Transparent Wall (Nearby)",
    Default = false,
    Callback = function(Value)
        getgenv().WallTransparency = Value
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ESP Folder
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "YoxanX_ESP"

-- Clean old ESP
local function ClearESP()
    for _, v in pairs(espFolder:GetChildren()) do
        v:Destroy()
    end
end

-- ESP Function
local function DrawESP()
    ClearESP()
    if not getgenv().ESPEnabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local nameTag = Drawing.new("Text")
            nameTag.Text = player.Name
            nameTag.Size = getgenv().ESPTextSize or 12
            nameTag.Center = true
            nameTag.Outline = true
            nameTag.Color = Color3.fromRGB(0, 255, 0)
            nameTag.Visible = true

            RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Head") then
                    local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                    if onScreen and getgenv().ESPEnabled then
                        nameTag.Position = Vector2.new(pos.X, pos.Y - 20)
                        nameTag.Visible = true
                        nameTag.Size = getgenv().ESPTextSize or 12
                    else
                        nameTag.Visible = false
                    end
                end
            end)
        end
    end
end

-- Silent Aim Target
local function GetClosestTarget()
    local maxDistance = 500
    local closest = nil
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if onScreen and dist < shortest and dist <= maxDistance then
                closest = head
                shortest = dist
            end
        end
    end
    return closest
end

-- Hook for Silent Aim
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

-- Anti Recoil Handler
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
                player.Character.Head.CFrame = Camera.CFrame + Camera.CFrame.LookVector * 10
            end
        end
    end
end)

-- Draw ESP Loop
RunService.RenderStepped:Connect(function()
    if getgenv().ESPEnabled then
        DrawESP()
    else
        ClearESP()
    end
end)

OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "All features loaded successfully!",
    Image = "rbxassetid://4483362458",
    Time = 5
})

-- Final init
OrionLib:Init()
