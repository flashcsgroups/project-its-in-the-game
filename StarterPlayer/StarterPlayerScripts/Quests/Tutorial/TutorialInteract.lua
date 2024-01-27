-- ASSETS & VARIABLES
_G.QUEST_TUTORIAL_PROGRESS = 0

local ClickDetector = workspace:WaitForChild("Quest_Tutorial"):WaitForChild(" "):WaitForChild("ClickBox"):WaitForChild("ClickDetector")

local questLabel = game.Players.LocalPlayer.PlayerGui:WaitForChild("QuestGui"):WaitForChild("Frame"):WaitForChild("QuestFrame"):WaitForChild("Quest_Tutorial")
local dialogueReturnEvent = game:GetService("ReplicatedFirst"):WaitForChild("DialogueReturnEvent")
local awaitingReturn = false
local questUpdateEvent = game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent")


-- FUNCTIONS
local function onClick()
	print("tutorial npc clicked")

	_G.NPC_NAME = "Huge Vapour"

	if _G.QUEST_TUTORIAL_PROGRESS == 0 then
		_G.NPC_DIALOGUE = {
			"Hey, you seem new here. My name is Huge Vapour. Welcome to [GRAMFT City].", 
			"Watch out, this city is full dangerous criminals out to get you, you gotta learn how to handle [a gun].",
			"You should buy a gun at the [gun store] at the other side of the city.",
			"Here's some [money], dont ask any questions.",
			"When you're done, there might be some people who need your help"
		}
		_G.money += 200
		game.ReplicatedStorage.Quest_Icons.Gunstore.Parent = workspace
		game.Workspace.TutorialNPC_Icon:Destroy()
		_G.QUEST_TUTORIAL_PROGRESS += 1
	elseif _G.QUEST_TUTORIAL_PROGRESS == 1 then
		_G.NPC_DIALOGUE = {
			"What are you waiting for, go on."
		}
	--elseif _G.QUEST_TUTORIAL_PROGRESS == 2 then
	--	_G.NPC_DIALOGUE = {
	--		"You got the package? Thanks.",
	--		"Here's the reward I promised, it's [$750]."
	--	}
	--	_G.QUEST_TUTORIAL_PROGRESS += 1
	--	_G.money += 750
	--elseif _G.QUEST_TUTORIAL_PROGRESS == 3 then
	--	_G.NPC_DIALOGUE = {
	--		"Thanks for getting me my package."
	--	}
	end

	game.ReplicatedFirst.DialogueStartEvent:Fire()

	print("fired dialogue start event")

	awaitingReturn = true

	print("updated quest (tutorial) progress to match: " .. _G.QUEST_TUTORIAL_PROGRESS)
end

local function onDialogueReturnEvent()
	print("dialogue return event received")

	if awaitingReturn then
		questLabel.Visible = _G.QUEST_TUTORIAL_PROGRESS ~= 3
		game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent"):Fire()
	end
	
	questUpdateEvent:Fire()

	awaitingReturn = false

	print("dialogue return event completed")
end

-- TRIGGERS
ClickDetector.MouseClick:Connect(onClick)
dialogueReturnEvent.Event:Connect(onDialogueReturnEvent)