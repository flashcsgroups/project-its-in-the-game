game.Players.LocalPlayer.PlayerGui:WaitForChild("GunstoreUI")
workspace:WaitForChild("gunstore"):WaitForChild("Shopkeeper"):WaitForChild("Hitbox")
--Variables
local shopkeeper = workspace.gunstore.Shopkeeper.Hitbox.ClickDetector
local gunstoreUI = game.Players.LocalPlayer.PlayerGui.GunstoreUI
local HUD = game.Players.LocalPlayer.PlayerGui.HUD
local closeButton= gunstoreUI.Frame.TextButton

--Function
local function openGunshopUI ()
	gunstoreUI.Enabled = true;
	HUD.Enabled = false;
	print('gunstore has opened')
end
local function closeGunshopUI ()
	gunstoreUI.Enabled = false;
	HUD.Enabled = true;
	print('gunstore has closed')
end

shopkeeper.MouseClick:Connect(openGunshopUI)
closeButton.Activated:Connect(closeGunshopUI)