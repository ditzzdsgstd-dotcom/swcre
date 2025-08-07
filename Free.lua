local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "YoxanXHub | Hypershot V1.5",
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

-- Silent Aim Function
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function GetClosestTarget()
   local maxDistance = 500
   local closest = nil
   local shortest = math.huge
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
         local head = player.Character.Head
         local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
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

-- Bring Head Logic
RunService.RenderStepped:Connect(function()
   if getgenv().BringHeads then
      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            head.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * 10)
         end
      end
   end
end)

--// ESP
local function CreateESP(player)
    if player == game.Players.LocalPlayer then return end
    if player.Character and player.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui", player.Character.Head)
        billboard.Name = "YoxanESP"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true

        local name = Instance.new("TextLabel", billboard)
        name.Size = UDim2.new(1, 0, 1, 0)
        name.BackgroundTransparency = 1
        name.Text = player.Name
        name.TextColor3 = player.TeamColor.Color
        name.TextStrokeTransparency = 0.5
        name.Font = Enum.Font.SourceSansBold
        name.TextScaled = true
    end
end

local function ClearESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local esp = player.Character.Head:FindFirstChild("YoxanESP")
        if esp then esp:Destroy() end
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if getgenv().ESPEnabled then
            CreateESP(player)
        end
    end)
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if getgenv().ESPEnabled then
        CreateESP(player)
    end
end

--// Wall Transparency Near Enemies
local function UpdateWallTransparency()
    if not getgenv().WallXRay then return end
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) then
            local distance = (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
            if distance <= 40 then
                part.LocalTransparencyModifier = 0.7
            else
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(UpdateWallTransparency)

--// Rayfield UI Finish
Rayfield:Notify({
   Title = "YoxanXHub | Hypershot V1.5",
   Content = "All Features Successfully Loaded.",
   Duration = 6
})
