game.Players.LocalPlayer.PlayerGui:WaitForChild("MainMenu")

print("Finished waiting")

local mainMenu = game.Players.LocalPlayer.PlayerGui.MainMenu
local guideStart = game.Players.LocalPlayer.PlayerGui.guidegui
local guideButton = mainMenu.background.buttons.howtoplay
local closeButton = game.Players.LocalPlayer.PlayerGui.guidegui.guide.close

local function startGuide()
	mainMenu.Enabled = false;
	guideStart.Enabled = true;
	print("Guide has been started")
end

guideButton.MouseButton1Click:Connect(startGuide)

local function closeGuide()
	mainMenu.Enabled = true;
	guideStart.Enabled = false;
	print("Guide has been closed")
end

closeButton.MouseButton1Click:Connect(closeGuide)