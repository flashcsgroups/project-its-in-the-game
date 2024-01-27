-- Wait for assets

game.Players.LocalPlayer.PlayerGui:WaitForChild("HUD")


-- get services

local runservice = game:GetService("RunService")
local Players = game:GetService("Players")

-- set variables

_G.money = 0

-- variables

local player = Players.LocalPlayer
local moneyFrame = player.PlayerGui.HUD.MoneyFrame
local moneyText = moneyFrame.MoneyText 

-- code
runservice.Stepped:Connect(function()
	local money = _G.money
	if money then
		moneyText.Text = "$ " .. money
	end
end)