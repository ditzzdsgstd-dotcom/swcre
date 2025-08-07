local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "YoxanXHub | Hypershot V1.55",
   LoadingTitle = "YoxanXHub Loaded",
   LoadingSubtitle = "YoxanXHub V1.55 OP",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local Main = Window:CreateTab("Main", 4483362458)
local Combat = Window:CreateTab("Combat", 4483362458)
local Visual = Window:CreateTab("Visual", 4483362458)

-- Variables
getgenv().SilentAimEnabled = true
getgenv().ESPEnabled = true
getgenv().AntiRecoil = false
getgenv().BringHeads = false
getgenv().WallTransparency = false
getgenv().ESPTextSize = 14

-- Toggles
Main:CreateToggle({
   Name = "Silent Aim (Headshot + Prediction)",
   CurrentValue = true,
   Flag = "SilentAim",
   Callback = function(v) getgenv().SilentAimEnabled = v end
})

Visual:CreateToggle({
   Name = "ESP Box + Name",
   CurrentValue = true,
   Flag = "ESPEnabled",
   Callback = function(v) getgenv().ESPEnabled = v end
})

Visual:CreateSlider({
   Name = "ESP Text Size",
   Range = {10, 30},
   Increment = 1,
   CurrentValue = 14,
   Flag = "ESPTextSize",
   Callback = function(val) getgenv().ESPTextSize = val end
})

Combat:CreateToggle({
   Name = "Anti Recoil / Spread",
   CurrentValue = false,
   Flag = "AntiRecoil",
   Callback = function(v) getgenv().AntiRecoil = v end
})

Main:CreateToggle({
   Name = "Bring Heads",
   CurrentValue = false,
   Flag = "BringHeads",
   Callback = function(v) getgenv().BringHeads = v end
})

Visual:CreateToggle({
   Name = "Transparent Wall (Nearby)",
   CurrentValue = false,
   Flag = "WallTransparency",
   Callback = function(v) getgenv().WallTransparency = v end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Silent Aim Target Finder with Prediction
local function GetClosestTarget()
   local maxDist, target = 500, nil
   local shortest = math.huge
   for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
         local head = plr.Character.Head
         local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
         local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
         if onScreen and dist < shortest and dist <= maxDist then
            shortest = dist
            target = head
         end
      end
   end
   return target
end

-- Hook to redirect hit detection
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = function(t, k)
   if getgenv().SilentAimEnabled and tostring(k) == "Hit" then
      local target = GetClosestTarget()
      if target then
         local predicted = target.Position + (target.Velocity * 0.05)
         return { Position = predicted }
      end
   end
   return oldIndex(t, k)
end

-- Anti Recoil / Spread Loop
RunService.RenderStepped:Connect(function()
   if getgenv().AntiRecoil then
      for _, v in next, getgc(true) do
         if typeof(v) == "table" and rawget(v, "Spread") then
            v.Spread = 0
            v.BaseSpread = 0
            v.MinCamRecoil = Vector3.new()
            v.MaxCamRecoil = Vector3.new()
            v.MinRotRecoil = Vector3.new()
            v.MaxRotRecoil = Vector3.new()
            v.MinTransRecoil = Vector3.new()
            v.MaxTransRecoil = Vector3.new()
         end
      end
   end
end)

-- Bring Heads Logic
RunService.RenderStepped:Connect(function()
   if getgenv().BringHeads then
      for _, plr in ipairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            plr.Character.Head.CFrame = CFrame.new(Camera.CFrame.Position + Camera.CFrame.LookVector * 10)
         end
      end
   end
end)

-- Wall Transparency
RunService.RenderStepped:Connect(function()
   if getgenv().WallTransparency then
      for _, part in ipairs(workspace:GetDescendants()) do
         if part:IsA("BasePart") and part.Transparency < 1 and not part:IsDescendantOf(LocalPlayer.Character) then
            local distance = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < 20 then
               part.LocalTransparencyModifier = 0.8
            else
               part.LocalTransparencyModifier = 0
            end
         end
      end
   end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Fungsi membuat ESP
local function CreateESP(player)
   if not player.Character or not player.Character:FindFirstChild("Head") then return end
   local head = player.Character.Head

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "YoxanXESP"
   billboard.Adornee = head
   billboard.AlwaysOnTop = true
   billboard.Size = UDim2.new(0, 100, 0, 40)
   billboard.StudsOffset = Vector3.new(0, 2, 0)

   local nameLabel = Instance.new("TextLabel", billboard)
   nameLabel.Size = UDim2.new(1, 0, 1, 0)
   nameLabel.BackgroundTransparency = 1
   nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
   nameLabel.TextStrokeTransparency = 0
   nameLabel.Font = Enum.Font.GothamBold
   nameLabel.TextScaled = true
   nameLabel.Text = player.Name
   nameLabel.Name = "ESPText"

   billboard.Parent = head
end

-- Update ESP
local function UpdateESP()
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
         local head = player.Character.Head
         if getgenv().ESPEnabled then
            if not head:FindFirstChild("YoxanXESP") then
               CreateESP(player)
            else
               local label = head:FindFirstChild("YoxanXESP"):FindFirstChild("ESPText")
               if label then
                  label.TextSize = getgenv().ESPTextSize or 15
               end
            end
         else
            if head:FindFirstChild("YoxanXESP") then
               head:FindFirstChild("YoxanXESP"):Destroy()
            end
         end
      end
   end
end

-- Loop
RunService.RenderStepped:Connect(UpdateESP)

Rayfield:Notify({
   Title = "YoxanXHub",
   Content = "All features loaded successfully.",
   Duration = 4,
   Image = 4483362458
})
