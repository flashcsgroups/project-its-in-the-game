wait(.1)


local function onHealthChanged()
	
	local pistolBot = script.Parent
	local humanoid = pistolBot:WaitForChild("Humanoid")
	

	if (humanoid.Health < 1) then
	pistolBot:BreakJoints()
	wait(2)
	pistolBot:Destroy()
	end
end 

--humanoid.HealthChanged:Connect(onHealthChanged())

game["Run Service"].Stepped:Connect(function ()
		onHealthChanged()
end)