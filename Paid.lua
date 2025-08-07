-- YoxanXHub | Hypershot V2.1 (1/3)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Hypershot V1.5 BETA",
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
    Min = 10,-- YoxanXHub V2.1 - 2/3
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

-- Get Closest Target to Cursor
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

-- Silent Aim Hook
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

-- Anti Recoil
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

-- ESP Logic
local function CreateESP(player)
   local billboard = Instance.new("BillboardGui")
   billboard.Name = "YoxanXESP"
   billboard.AlwaysOnTop = true
   billboard.Size = UDim2.new(0, 100, 0, 40)
   billboard.StudsOffset = Vector3.new(0, 2, 0)

   local text = Instance.new("TextLabel", billboard)
   text.Size = UDim2.new(1, 0, 1, 0)
   text.BackgroundTransparency = 1
   text.TextColor3 = Color3.fromRGB(0, 255, 0)
   text.TextStrokeTransparency = 0
   text.Font = Enum.Font.GothamBold
   text.TextScaled = true

   billboard.Adornee = player.Character:FindFirstChild("Head")
   text.Text = player.Name
   text.TextSize = getgenv().ESPTextSize or 15
   billboard.Parent = player.Character:FindFirstChild("Head")
end

local function UpdateESP()
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
         local head = player.Character.Head
         if getgenv().ESPEnabled then
            if not head:FindFirstChild("YoxanXESP") then
               CreateESP(player)
            else
               head:FindFirstChild("YoxanXESP").TextLabel.TextSize = getgenv().ESPTextSize or 15
            end
         else
            if head:FindFirstChild("YoxanXESP") then
               head:FindFirstChild("YoxanXESP"):Destroy()
            end
         end
      end
   end
end

RunService.RenderStepped:Connect(UpdateESP)

-- Bring Head Logic
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
    Max = 25,
    Default = 15,
    Increment = 1,
    Callback = function(Value)
        getgenv().ESPTextSize = Value
    end
})

-- Anti Recoil Toggle
CombatTab:AddToggle({
    Name = "Anti Recoil / Spread",
    Default = false,
    Callback = function(Value)
        getgenv().AntiRecoil = Value
    end
})

-- Bring Head Toggle
MainTab:AddToggle({
    Name = "Bring Heads",
    Default = false,
    Callback = function(Value)
        getgenv().BringHeads = Value
    end
})

-- Transparent Wall Toggle
VisualTab:AddToggle({
    Name = "Transparent Wall (Nearby)",
    Default = false,
    Callback = function(Value)
        getgenv().WallTransparency = Value
    end
})

-- Final Notify (3/3)
OrionLib:MakeNotification({
    Name = "YoxanXHub Ready",
    Content = "All Features Are Fully Loaded!",
    Image = "rbxassetid://4483345998",
    Time = 6
})

OrionLib:Init()
