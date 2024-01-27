local questGui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("QuestGui")
local questList = questGui:WaitForChild("Frame"):WaitForChild("QuestFrame")

local QUEST_FIND_OBJECTIVES = {
	"Find the mysterious man's <font color='#ff5500'>package</font> at the <font color='#ff5500'>construction site</font>", 
	"Return the <font color='#ff5500'>package</font> to the mysterious man"
}

local QUEST_ASSASSINATE_OBJECTIVES = {
	"Take care of the <font color='#ff5500'> target </font> at his <font color='#ff5500'>apartment</font>", 
	"Return to <font color='#ff5500'>Igor</font>"
}

local QUEST_TUTORIAL_OBJECTIVES = {
	"Purchase a <font color='#ff5500'> pistol </font> from the <font color='#ff5500'> gun store </font>"
}



local function updateQuestObjectives()
	if _G.QUEST_FIND_PROGRESS > #QUEST_FIND_OBJECTIVES or _G.QUEST_FIND_PROGRESS == 0 then
		questList:WaitForChild("Quest_Find").Text = 'nil'
	elseif _G.QUEST_FIND_PROGRESS ~= 'nil' then
		questList:WaitForChild("Quest_Find").Text = "<font color='#ff5500'>◆</font>   " .. QUEST_FIND_OBJECTIVES[_G.QUEST_FIND_PROGRESS]		
	end

	if _G.QUEST_ASSASSINATE_PROGRESS > #QUEST_ASSASSINATE_OBJECTIVES or _G.QUEST_ASSASSINATE_PROGRESS == 0 then
		questList:WaitForChild("Quest_Assassinate").Text = 'nil'
	elseif _G.QUEST_ASSASSINATE_PROGRESS ~= 'nil' then
		questList:WaitForChild("Quest_Assassinate").Text = "<font color='#ff5500'>◆</font>   " .. QUEST_ASSASSINATE_OBJECTIVES[_G.QUEST_ASSASSINATE_PROGRESS]		
	end
	
	if _G.QUEST_TUTORIAL_PROGRESS > #QUEST_TUTORIAL_OBJECTIVES or _G.QUEST_TUTORIAL_PROGRESS == 0 then
		questList:WaitForChild("Quest_Tutorial").Text = 'nil'
	elseif _G.QUEST_TUTORIAL_PROGRESS ~= 'nil' then
		questList:WaitForChild("Quest_Tutorial").Text = "<font color='#ff5500'>◆</font>   " .. QUEST_TUTORIAL_OBJECTIVES[_G.QUEST_TUTORIAL_PROGRESS]		
	end
end

local function main()
	print("objectivehandler event received")

	updateQuestObjectives()

	local checksum = 0

	for _, object in questList:GetChildren() do
		if object:IsA("TextLabel") and object.Visible == true then
			checksum += 1
		end
	end

	if checksum > 0 then
		questGui.Enabled = true
	else
		questGui.Enabled = false
	end

	print("objectivehandler event completed with checksum: " .. checksum)
end

game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent").Event:Connect(main)