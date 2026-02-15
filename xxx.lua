-- LOAD ORION
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- WINDOW
local Window = OrionLib:MakeWindow({
	Name = "Neuro Utility",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "NeuroUtility"
})

-- TAB
local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- =====================
-- 🔹 ANTI AFK
-- =====================

MainTab:AddToggle({
	Name = "Anti AFK",
	Default = false,
	Callback = function(Value)
		if Value then
			_G.AntiAFK = true
			LocalPlayer.Idled:Connect(function()
				if _G.AntiAFK then
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end
			end)
			OrionLib:MakeNotification({
				Name = "Anti AFK",
				Content = "Activated",
				Time = 3
			})
		else
			_G.AntiAFK = false
			OrionLib:MakeNotification({
				Name = "Anti AFK",
				Content = "Disabled",
				Time = 3
			})
		end
	end
})

-- =====================
-- 🔹 TELEPORT TO PLAYER
-- =====================

local function GetPlayerList()
	local list = {}
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(list, player.Name)
		end
	end
	return list
end

local SelectedPlayer = nil

MainTab:AddDropdown({
	Name = "Select Player",
	Default = "",
	Options = GetPlayerList(),
	Callback = function(Value)
		SelectedPlayer = Value
	end
})

MainTab:AddButton({
	Name = "Teleport",
	Callback = function()
		if SelectedPlayer then
			local target = Players:FindFirstChild(SelectedPlayer)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
			end
		end
	end
})

OrionLib:Init()
