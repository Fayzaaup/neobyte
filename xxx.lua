--// NeoByte Premium Script
--// Simple Fly + Anti AFK
--// Made by NeoByte

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NeoByte | Premium",
   LoadingTitle = "NeoByte Premium",
   LoadingSubtitle = "by Neo Studio",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

-- Premium Key Check (Simple Local Key)
local PremiumKey = "NEOBYTE-2026"
local UserInputKey = "NEOBYTE-2026" -- Ganti manual kalau mau pakai input box

if UserInputKey ~= PremiumKey then
   Rayfield:Notify({
      Title = "Access Denied",
      Content = "Invalid Premium Key!",
      Duration = 5,
   })
   return
end

Rayfield:Notify({
   Title = "Premium Activated",
   Content = "Welcome to NeoByte Premium!",
   Duration = 5,
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Tab
local MainTab = Window:CreateTab("Main", 4483362458)

--========================--
--        FLY SYSTEM      --
--========================--

local Flying = false
local FlySpeed = 50
local BodyVelocity

MainTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      
      if Flying then
         BodyVelocity = Instance.new("BodyVelocity")
         BodyVelocity.MaxForce = Vector3.new(1,1,1) * 1000000
         BodyVelocity.Parent = HumanoidRootPart
         
         game:GetService("RunService").RenderStepped:Connect(function()
            if Flying and BodyVelocity then
               BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed
            end
         end)
      else
         if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
         end
      end
   end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      FlySpeed = Value
   end,
})

--========================--
--       ANTI AFK         --
--========================--

MainTab:CreateToggle({
   Name = "Enable Anti AFK",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         local VirtualUser = game:GetService("VirtualUser")
         Player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
         end)
         
         Rayfield:Notify({
            Title = "Anti AFK",
            Content = "Anti AFK Activated!",
            Duration = 4,
         })
      else
         Rayfield:Notify({
            Title = "Anti AFK",
            Content = "Anti AFK stays until rejoin.",
            Duration = 4,
         })
      end
   end,
})

--========================--
--        PREMIUM TAG     --
--========================--

MainTab:CreateParagraph({
   Title = "NeoByte Premium",
   Content = "Exclusive Premium Script\nFly + Anti AFK\nVersion 1.0",
})
