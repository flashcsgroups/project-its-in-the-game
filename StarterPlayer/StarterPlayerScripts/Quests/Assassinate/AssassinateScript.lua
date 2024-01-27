-- ASSETS & VARIABLES
_G.QUEST_ASSASSINATE_PROGRESS = 0

local ClickDetector = workspace:WaitForChild("Quest_Assassinate"):WaitForChild(" "):WaitForChild("Hitbox"):WaitForChild("ClickDetector")

local questLabel = game.Players.LocalPlayer.PlayerGui:WaitForChild("QuestGui"):WaitForChild("Frame"):WaitForChild("QuestFrame"):WaitForChild("Quest_Assassinate")
local dialogueReturnEvent = game:GetService("ReplicatedFirst"):WaitForChild("DialogueReturnEvent")
--local box = game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Find"):WaitForChild("Box")
local awaitingReturn = false
local questUpdateEvent = game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent")

-- FUNCTIONS
local function onClick()
	print("quest npc clicked")

	_G.NPC_NAME = "Igor Karkarov"

	if _G.QUEST_ASSASSINATE_PROGRESS == 0 then
		_G.NPC_DIALOGUE = {
			"I got a [job] for you. Can I trust you?", 
			"I got a into some trouble with some [shady guy] earlier at the beach.",
			"I followed him back to his apartment, he lives in the [tall building next to the McDonald's].",
			"I need you to [take care] of him for me.",
			"He might see you coming so [be prepared]."
		}
		--box.Parent = workspace
		game.ReplicatedStorage.Quest_Icons.Assassinate_Search_Icon.Parent = workspace
		game.ReplicatedStorage.Quests.Enemies.AssassinateARbot.Parent = workspace
		_G.QUEST_ASSASSINATE_PROGRESS += 1
	elseif _G.QUEST_ASSASSINATE_PROGRESS == 1 then
		_G.NPC_DIALOGUE = {
			"Come on, please help me [take care] this man. He should be at his apartment..",
			"It's [next to the mcdonalds in the tall building]."
		}
	elseif _G.QUEST_ASSASSINATE_PROGRESS == 2 then
		_G.NPC_DIALOGUE = {
			"You got him? Thanks.",
			"Here's your reward, it's [$1000]."
		}
		_G.money += 1000
		_G.QUEST_ASSASSINATE_PROGRESS += 1
		game.Workspace.AssassinateNPC_Icon.Parent = game.ReplicatedStorage
	elseif _G.QUEST_ASSASSINATE_PROGRESS == 3 then
		_G.NPC_DIALOGUE = {
			"What more do you want from me? get going now."
		}
	end

	game.ReplicatedFirst.DialogueStartEvent:Fire()

	print("fired dialogue start event")

	awaitingReturn = true

	print("updated quest (find) progress to match: " .. _G.QUEST_ASSASSINATE_PROGRESS)
	end

	local function onDialogueReturnEvent()
	print("dialogue return event received")

	if awaitingReturn then
		questLabel.Visible = _G.QUEST_ASSASSINATE_PROGRESS ~= 3
		game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent"):Fire()
	end
	
	questUpdateEvent:Fire()

	awaitingReturn = false

	print("dialogue return event completed")
end

-- TRIGGERS
ClickDetector.MouseClick:Connect(onClick)
dialogueReturnEvent.Event:Connect(onDialogueReturnEvent)