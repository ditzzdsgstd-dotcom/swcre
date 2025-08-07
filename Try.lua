local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "YoxanXHub | Hypershot V2.1",
   LoadingTitle = "YoxanXHub Loaded",
   LoadingSubtitle = "Silent Aim, ESP, Recoil",
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

Rayfield:Notify({
   Title = "YoxanXHub",
   Content = "All features loaded successfully.",
   Duration = 4,
   Image = 4483362458
})
