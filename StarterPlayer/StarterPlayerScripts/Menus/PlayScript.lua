game.Players.LocalPlayer.PlayerGui:WaitForChild("MainMenu")

print("Finished waiting")

local mainMenu = game.Players.LocalPlayer.PlayerGui.MainMenu
local startButton = mainMenu.background.buttons.play

function startGame()
	mainMenu.Enabled = false
	print("the game has been started!")
end

startButton.MouseButton1Click:Connect(startGame)
