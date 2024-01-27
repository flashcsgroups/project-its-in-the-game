wait(.1)


local function onHealthChanged()
	
	local ARBot = script.Parent
	local humanoid = ARBot:WaitForChild("Humanoid")
	

	if (humanoid.Health < 1) then
	ARBot:BreakJoints()
	wait(2)
	ARBot:Destroy()
	end
end 

--humanoid.HealthChanged:Connect(onHealthChanged())

game["Run Service"].Stepped:Connect(function ()
		onHealthChanged()
end)