--// NeoByte Ultimate | Fixed UI Version

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CorrectKey = "NEOBYTE-ULTRA-2026"

local Window = Rayfield:CreateWindow({
   Name = "💎 NeoByte Ultimate",
   LoadingTitle = "NeoByte Ultimate",
   LoadingSubtitle = "Premium Edition",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "NeoByteConfig"
   },
   KeySystem = true,
   KeySettings = {
      Title = "NeoByte Premium Access",
      Subtitle = "Enter Key Below",
      Note = "Contact Owner For Key",
      FileName = "NeoByteKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {CorrectKey}
   }
})

--========================--
--        SERVICES        --
--========================--

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local MainTab = Window:CreateTab("Main", 4483362458)

--========================--
--          FLY           --
--========================--

local FlySpeed = 1
local BV, BG, FlyConnection

local function StartFly()
   BV = Instance.new("BodyVelocity")
   BV.MaxForce = Vector3.new(9e9,9e9,9e9)
   BV.Parent = Root

   BG = Instance.new("BodyGyro")
   BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
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
   if FlyConnection then FlyConnection:Disconnect() end
   if BV then BV:Destroy() end
   if BG then BG:Destroy() end
end

MainTab:CreateToggle({
   Name = "✈ Enable Fly",
   CurrentValue = false,
   Callback = function(Value)
      if Value then StartFly() else StopFly() end
   end,
})

MainTab:CreateInput({
   Name = "Fly Speed (Default 1)",
   PlaceholderText = "Enter Speed...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local Num = tonumber(Text)
      if Num and Num > 0 then
         FlySpeed = Num
      end
   end,
})

--========================--
--        ANTI AFK        --
--========================--

MainTab:CreateButton({
   Name = "🛑 Enable Anti AFK",
   Callback = function()
      local VirtualUser = game:GetService("VirtualUser")
      Player.Idled:Connect(function()
         VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
         task.wait(1)
         VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      end)
   end,
})

--========================--
--       TELEPORT         --
--========================--

local SelectedPlayer = nil

local function GetPlayersList()
   local t = {}
   for _, plr in pairs(game.Players:GetPlayers()) do
      if plr ~= Player then
         table.insert(t, plr.Name)
      end
   end
   return t
end

local PlayerDropdown = MainTab:CreateDropdown({
   Name = "👤 Select Player",
   Options = GetPlayersList(),
   CurrentOption = {},
   MultipleOptions = false,
   Callback = function(Option)
      SelectedPlayer = Option[1]
   end,
})

MainTab:CreateButton({
   Name = "🚀 Smooth Teleport",
   Callback = function()
      if not SelectedPlayer then return end
      local Target = game.Players:FindFirstChild(SelectedPlayer)
      if not Target or not Target.Character then return end

      local TargetRoot = Target.Character:FindFirstChild("HumanoidRootPart")
      if not TargetRoot then return end

      local tween = TweenService:Create(
         Root,
         TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
         {CFrame = TargetRoot.CFrame * CFrame.new(0,0,-4)}
      )
      tween:Play()
   end,
})

MainTab:CreateParagraph({
   Title = "💎 NeoByte Premium",
   Content = "Fly | Teleport | Anti AFK\nFixed UI Version 2026",
})
