-- ASSETS & VARIABLES
local box = game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Find"):WaitForChild("Box")
--local pistolBot = game.ReplicatedStorage.Bots.PistolBot

-- FUNCTIONS
local function onClick()
	print("box interaction started")
	
	_G.QUEST_FIND_PROGRESS += 1
	print("quest progress increased")
	
	
	game.ReplicatedFirst.QuestUpdateEvent:Fire()
	print("QuestUpdateEvent fired")
	
	box.Parent = game.ReplicatedStorage
	game.Workspace.Find_Search_Icon.Parent = game.ReplicatedStorage
	print("box interaction finished, box parented to ReplicatedStorage")
	
	-- spawn bot
	--local pistolBotClone = pistolBot:Clone()
	game.ReplicatedStorage.Quests.Enemies.FindPistolBot.Parent = game.Workspace
	-- moet nog werken V
	--pistolBotClone.Origin.Position = Vector3.new(100.67, 2.197, -646.85)
end

-- TRIGGERS
box.ClickDetector.MouseClick:Connect(onClick)