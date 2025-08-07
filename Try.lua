-- Rayfield Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "YoxanXHub | Hypershot V2.1",
   LoadingTitle = "YoxanXHub Loaded",
   LoadingSubtitle = "Made by YoxanX",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local MainTab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- Silent Aim Toggle
MainTab:CreateToggle({
   Name = "Silent Aim (Headshot)",
   CurrentValue = true,
   Flag = "SilentAim",
   Callback = function(Value)
      getgenv().SilentAimEnabled = Value
   end
})

-- ESP Toggle
VisualTab:CreateToggle({
   Name = "ESP Box + Name",
   CurrentValue = true,
   Flag = "ESPEnabled",
   Callback = function(Value)
      getgenv().ESPEnabled = Value
   end
})

-- No Recoil Toggle
CombatTab:CreateToggle({
   Name = "Anti Recoil / Spread",
   CurrentValue = false,
   Flag = "AntiRecoil",
   Callback = function(Value)
      getgenv().AntiRecoil = Value
   end
})

-- Bring Head Feature Toggle
MainTab:CreateToggle({
   Name = "Bring Heads",
   CurrentValue = false,
   Flag = "BringHeads",
   Callback = function(Value)
      getgenv().BringHeads = Value
   end
})

-- Wall Transparency Toggle
VisualTab:CreateToggle({
   Name = "Transparent Wall (Nearby)",
   CurrentValue = false,
   Flag = "WallTransparency",
   Callback = function(Value)
      getgenv().WallTransparency = Value
   end
})

-- Silent Aim Logic
local function GetClosestTarget()
   local maxDistance = 500
   local closest = nil
   local shortest = math.huge
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
         local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
         local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
         if onScreen and dist < shortest and dist <= maxDistance then
            closest = player.Character.Head
            shortest = dist
         end
      end
   end
   return closest
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index

mt.__index = function(t, k)
   if getgenv().SilentAimEnabled and tostring(k) == "Hit" then
      local target = GetClosestTarget()
      if target then return target end
   end
   return oldIndex(t, k)
end

-- ESP Drawing
local function CreateESP(plr)
   local box = Drawing.new("Square")
   local name = Drawing.new("Text")

   box.Thickness = 1
   box.Transparency = 1
   box.Color = plr.TeamColor.Color
   box.Filled = false

   name.Color = plr.TeamColor.Color
   name.Size = 14
   name.Center = true
   name.Outline = true

   RunService.RenderStepped:Connect(function()
      if not getgenv().ESPEnabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
         box.Visible = false
         name.Visible = false
         return
      end

      local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
      if onScreen then
         box.Visible = true
         name.Visible = true
         local size = 50
         box.Size = Vector2.new(size, size)
         box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
         name.Position = Vector2.new(pos.X, pos.Y - size/1.5)
         name.Text = plr.Name
      else
         box.Visible = false
         name.Visible = false
      end
   end)
end

Players.PlayerAdded:Connect(CreateESP)
for _, plr in ipairs(Players:GetPlayers()) do
   if plr ~= LocalPlayer then
      CreateESP(plr)
   end
end

-- Wall Transparency Logic
RunService.RenderStepped:Connect(function()
   if getgenv().WallTransparency then
      for _, part in ipairs(workspace:GetDescendants()) do
         if part:IsA("BasePart") and part.Transparency < 1 and part.Position.FuzzyEq(LocalPlayer.Character.Head.Position, 30) then
            part.LocalTransparencyModifier = 0.7
         end
      end
   else
      for _, part in ipairs(workspace:GetDescendants()) do
         if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
         end
      end
   end
end)

-- Anti Recoil / Spread Logic
game:GetService("RunService").RenderStepped:Connect(function()
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
game:GetService("RunService").RenderStepped:Connect(function()
   if getgenv().BringHeads then
      for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
         if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            head.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * 10)
         end
      end
   end
end)

-- Notification when everything is ready
wait(1)
Rayfield:Notify({
   Title = "YoxanXHub",
   Content = "✅ All features loaded successfully!",
   Duration = 5
})
