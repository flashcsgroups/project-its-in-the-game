-- ASSETS & VARIABLES
_G.QUEST_FIND_PROGRESS = 0

local ClickDetector = workspace:WaitForChild("Quest_Find"):WaitForChild(" "):WaitForChild("ClickBox"):WaitForChild("ClickDetector")

local questLabel = game.Players.LocalPlayer.PlayerGui:WaitForChild("QuestGui"):WaitForChild("Frame"):WaitForChild("QuestFrame"):WaitForChild("Quest_Find")
local dialogueReturnEvent = game:GetService("ReplicatedFirst"):WaitForChild("DialogueReturnEvent")
local awaitingReturn = false
local box = game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Find"):WaitForChild("Box")
local questUpdateEvent = game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent")

-- FUNCTIONS
local function onClick()
	print("quest npc clicked")

	_G.NPC_NAME = "MYSTERIOUS MAN"

	if _G.QUEST_FIND_PROGRESS == 0 then
		_G.NPC_DIALOGUE = {
			"Hey you, I need your help. I left a [package] behind, It's important.", 
			"I dropped it at the [construction site], you should get it before someone else finds it.",
			"Rest assured, it'll be worth the troubles. Just [watch your back]..."
		}
		box.Parent = workspace
		game.ReplicatedStorage.Quest_Icons.Find_Search_Icon.Parent = workspace
		_G.QUEST_FIND_PROGRESS += 1
	elseif _G.QUEST_FIND_PROGRESS == 1 then
		_G.NPC_DIALOGUE = {
			"Come on, I asked you to get me my [package]. It's not gonna fetch itself."
		} 
	elseif _G.QUEST_FIND_PROGRESS == 2 then
		_G.NPC_DIALOGUE = {
			"You got the package? Thanks.",
			"Here's the reward I promised, it's [$750]."
		}
		_G.QUEST_FIND_PROGRESS += 1
		_G.money += 750
		game.Workspace.FindNPC_Icon.Parent = game.ReplicatedStorage
	elseif _G.QUEST_FIND_PROGRESS == 3 then
		_G.NPC_DIALOGUE = {
			"Thanks for getting me my package."
		}
	end

		game.ReplicatedFirst.DialogueStartEvent:Fire()

		print("fired dialogue start event")

		awaitingReturn = true

	print("updated quest (find) progress to match: " .. _G.QUEST_FIND_PROGRESS)
	end

	local function onDialogueReturnEvent()
		print("dialogue return event received")

		if awaitingReturn then
			questLabel.Visible = _G.QUEST_FIND_PROGRESS ~= 3
			game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent"):Fire()
		end

		questUpdateEvent:Fire()

		awaitingReturn = false

		print("dialogue return event completed")
	end

	-- TRIGGERS
	ClickDetector.MouseClick:Connect(onClick)
	dialogueReturnEvent.Event:Connect(onDialogueReturnEvent)