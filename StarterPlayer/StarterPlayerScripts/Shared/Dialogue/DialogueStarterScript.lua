-- ASSETS & VARIABLES
game:GetService("ReplicatedFirst"):WaitForChild("DialogueStartEvent")
local dialogueReturnEvent = game:GetService("ReplicatedFirst"):WaitForChild("DialogueReturnEvent")
local dialogueUi = game.Players.LocalPlayer.PlayerGui:WaitForChild("Shared"):WaitForChild("DialogueGui")
local nextButton = game.Players.LocalPlayer.PlayerGui.Shared.DialogueGui:WaitForChild("TextButton")
local dialogueSlide = 1

-- FUNCTIONS
local function characterWaitTime(char)
	if char == '.' then 
		return .800
	elseif char == ';' then 
		return .600
	elseif char == ',' then 
		return .400
	else 
		return .050 
	end
end

local function loadDialogue()
	dialogueUi.DialogueBox.DialogueContent.Text = ""

	local substitution = false

	for char in _G.NPC_DIALOGUE[dialogueSlide]:gmatch"." do
		if char == '[' then
			dialogueUi.DialogueBox.DialogueContent.Text = dialogueUi.DialogueBox.DialogueContent.Text .. "<font color='#ff5500'></font>"
			substitution = true
		end

		if char == ']' then
			substitution = false
		end

		if char ~= '[' and char ~= ']' then
			if substitution then
				dialogueUi.DialogueBox.DialogueContent.Text = dialogueUi.DialogueBox.DialogueContent.Text:gsub("</font>", char .. "</font>")
			else
				dialogueUi.DialogueBox.DialogueContent.Text = dialogueUi.DialogueBox.DialogueContent.Text .. char
			end
			task.wait(characterWaitTime(char))
		end
	end

	task.wait(0.5)

	nextButton.Visible = true
end

local function nextDialogue()
	nextButton.Visible = false

	if dialogueSlide < #_G.NPC_DIALOGUE then
		dialogueSlide += 1
		loadDialogue()
	else
		dialogueUi.Enabled = false
		dialogueReturnEvent:Fire()
	end
end

local function dialogueStarter()
	dialogueSlide = 1
	nextButton.Visible = false

	dialogueUi.DialogueBox.DialogueContent.Text = ""
	dialogueUi.DialogueBox.Header.Text = _G.NPC_NAME

	dialogueUi.Enabled = true

	loadDialogue()
end

-- TRIGGERS
game.ReplicatedFirst.DialogueStartEvent.Event:Connect(dialogueStarter)
nextButton.MouseButton1Click:Connect(nextDialogue)