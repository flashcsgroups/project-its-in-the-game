game.Players.LocalPlayer.PlayerGui:WaitForChild("clothingStoreUi")
workspace:WaitForChild("ClothingStore"):WaitForChild("Shopkeeper"):WaitForChild("Hitbox"):WaitForChild("ClickDetector")

--Variables
local shopkeeper = workspace.ClothingStore.Shopkeeper.Hitbox.ClickDetector
local clothingStoreUi = game.Players.LocalPlayer.PlayerGui.clothingStoreUi
local HUD = game.Players.LocalPlayer.PlayerGui.HUD
local closeButton2= clothingStoreUi.Frame.closeButton

--Function
local function openClothingStoreUi ()
	clothingStoreUi.Enabled = true;
	HUD.Enabled = false;
	print('clothing has opened')
end
local function closeClothingStoreUi ()
	clothingStoreUi.Enabled = false;
	HUD.Enabled = true;
	print('clothing has closed')
end

shopkeeper.MouseClick:Connect(openClothingStoreUi)
closeButton2.Activated:Connect(closeClothingStoreUi)
