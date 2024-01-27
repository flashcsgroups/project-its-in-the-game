-- ASSETS & VARIABLES
local character = script.Parent
local humanoid = character:FindFirstChild("Humanoid")

local currentHealth = humanoid.Health
local lastDamage = nil
local lastRegen = tick()

local regenerationLimit = 0.75 * humanoid.MaxHealth
local regenerationRate = 1
local regenerationSize = 0.01 * humanoid.MaxHealth

-- FUNCTIONS
humanoid.Changed:Connect(function(property)
	if property == "Health" or property == "MaxHealth" then
		if humanoid.Health < currentHealth and humanoid.Health > 0 then
			currentHealth = humanoid.Health
			lastDamage = tick()
		elseif humanoid.Health > currentHealth and humanoid.Health > 0 then
			if currentHealth + regenerationSize > humanoid.Health then
				lastDamage = tick()
			end
			currentHealth = humanoid.Health
		end
	end
end)

-- START
while true do
	if lastDamage == nil or (tick() - lastDamage) >= 5 then
		if currentHealth < regenerationLimit then
			local timePassed = (tick() - lastRegen)
			if timePassed >= regenerationRate then
				lastRegen = tick()
				local healthToAdd = regenerationSize
				humanoid.Health = math.min(humanoid.Health + healthToAdd, humanoid.MaxHealth)
			end
		end
	end
	task.wait()
end