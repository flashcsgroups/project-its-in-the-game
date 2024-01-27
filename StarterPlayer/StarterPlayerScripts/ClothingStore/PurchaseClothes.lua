game.Players.LocalPlayer.PlayerGui:WaitForChild("clothingStoreUi")
--variables
local purchaseShirt1 = game.Players.LocalPlayer.PlayerGui.clothingStoreUi.Frame.Frame.FrameShirt1.TextButton
local purchaseShirt2 = game.Players.LocalPlayer.PlayerGui.clothingStoreUi.Frame.Frame.FrameShirt2.TextButton
local shirt = game.Players.LocalPlayer.Character:FindFirstChild("Shirt")
local pants = game.Players.LocalPlayer.Character:FindFirstChild("Pants")

--function
local function purchasedShirt1()
	if _G.money > 99 then
		_G.money = _G.money - 100
		shirt.ShirtTemplate = 'http://www.roblox.com/asset/?id=7248050676'
		pants.PantsTemplate = 'http://www.roblox.com/asset/?id=730003798'
		print("pak gekocht")
	end
end
local function purchasedShirt2()
	if _G.money > 99 then
		_G.money = _G.money - 100
		shirt.ShirtTemplate = 'http://www.roblox.com/asset/?id=8621453252'
		pants.PantsTemplate ='http://www.roblox.com/asset/?id=12380638123'
		print("hoodie gekocht")
	end
end
--code
purchaseShirt1.Activated:Connect(purchasedShirt1)
purchaseShirt2.Activated:Connect(purchasedShirt2)