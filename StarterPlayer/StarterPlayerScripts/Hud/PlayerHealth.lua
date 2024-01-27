-- WAIT FOR ASSETS

game.Players.LocalPlayer.PlayerGui:WaitForChild("HUD")

-- GET GAME SERVICES

local runservice = game:GetService("RunService") 
local players = game:GetService("Players")

-- VARIABLES

local player = players.LocalPlayer
local healthFrame = player.PlayerGui.HUD.HealthFrame
local healthBar = healthFrame.HealthBar
local healthBarProgress = healthFrame.HealthBar.HealthProgress
local healthTextLabel = healthFrame.HealthBar.PlayerHealth

-- FUNCTIONS

local function getPlayerHealth(player)
	local character = player.character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			return humanoid.health
		end
	end
	return nil
end

-- CODE

runservice.Stepped:Connect(function()
	local health = getPlayerHealth(player)
	
	if health > 10 then
		healthTextLabel.Parent = healthBarProgress
	else
		healthTextLabel.Parent = healthBar
	end
	
	if health then
		healthTextLabel.Text = health
		healthBarProgress.Size = UDim2.new(health/100, 0, 1, 0)
	end
end)