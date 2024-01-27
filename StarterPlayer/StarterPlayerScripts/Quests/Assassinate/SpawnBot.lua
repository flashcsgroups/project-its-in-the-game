local spawned = false

local function spawn()
	local bot = game:GetService('ReplicatedStorage'):WaitForChild("Bots"):WaitForChild("ARBot"):Clone()
	--bot spawnt maar is niet te zien
	bot.PrimaryPart.Position = Vector3.new(300,4.5,-800)
	bot.Parent = workspace
	spawned = true
end

local function validation()
	if _G.QUEST_ASSASSINATE_PROGRESS == 1 and not spawned then
		spawn()
	end
end

game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent").Event:Connect(validation)