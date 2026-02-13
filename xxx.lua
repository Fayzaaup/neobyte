--// NeoByte Premium (Fly Speed Input)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NeoByte | Premium",
   LoadingTitle = "NeoByte Premium",
   LoadingSubtitle = "Speed Input Version",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false,
})

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local MainTab = Window:CreateTab("Main", 4483362458)

--========================--
--        FLY SYSTEM      --
--========================--

local Flying = false
local FlySpeed = 1 -- DEFAULT 1
local BV, BG
local FlyConnection

local function StartFly()
   Flying = true
   
   BV = Instance.new("BodyVelocity")
   BV.MaxForce = Vector3.new(9e9,9e9,9e9)
   BV.Parent = Root

   BG = Instance.new("BodyGyro")
   BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
   BG.CFrame = Root.CFrame
   BG.Parent = Root

   FlyConnection = RunService.RenderStepped:Connect(function()
      local MoveDir = Vector3.zero
      
      if UIS:IsKeyDown(Enum.KeyCode.W) then
         MoveDir += workspace.CurrentCamera.CFrame.LookVector
      end
      if UIS:IsKeyDown(Enum.KeyCode.S) then
         MoveDir -= workspace.CurrentCamera.CFrame.LookVector
      end
      if UIS:IsKeyDown(Enum.KeyCode.A) then
         MoveDir -= workspace.CurrentCamera.CFrame.RightVector
      end
      if UIS:IsKeyDown(Enum.KeyCode.D) then
         MoveDir += workspace.CurrentCamera.CFrame.RightVector
      end
      if UIS:IsKeyDown(Enum.KeyCode.Space) then
         MoveDir += Vector3.new(0,1,0)
      end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
         MoveDir -= Vector3.new(0,1,0)
      end

      BV.Velocity = MoveDir * FlySpeed * 50
      BG.CFrame = workspace.CurrentCamera.CFrame
   end)
end

local function StopFly()
   Flying = false
   if FlyConnection then
      FlyConnection:Disconnect()
      FlyConnection = nil
   end
   if BV then BV:Destroy() end
   if BG then BG:Destroy() end
end

MainTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         StartFly()
      else
         StopFly()
      end
   end,
})

-- INPUT SPEED
MainTab:CreateInput({
   Name = "Fly Speed (Default 1)",
   PlaceholderText = "Masukkan angka...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local Num = tonumber(Text)
      if Num and Num > 0 then
         FlySpeed = Num
         Rayfield:Notify({
            Title = "NeoByte",
            Content = "Fly Speed set ke "..Num,
            Duration = 3,
         })
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Masukkan angka yang valid!",
            Duration = 3,
         })
      end
   end,
})

--========================--
--       ANTI AFK         --
--========================--

MainTab:CreateButton({
   Name = "Enable Anti AFK",
   Callback = function()
      local VirtualUser = game:GetService("VirtualUser")
      Player.Idled:Connect(function()
         VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
         task.wait(1)
         VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({
         Title = "NeoByte",
         Content = "Anti AFK Activated!",
         Duration = 4,
      })
   end,
})

MainTab:CreateParagraph({
   Title = "NeoByte Premium",
   Content = "Fly + Anti AFK\nSpeed default 1\nWASD Move | Space Up | Ctrl Down",
})
