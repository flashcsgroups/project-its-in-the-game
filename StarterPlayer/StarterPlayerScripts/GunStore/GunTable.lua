game.Players.LocalPlayer.PlayerGui:WaitForChild("GunstoreUI")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")
local questUpdateEvent = game:GetService("ReplicatedFirst"):WaitForChild("QuestUpdateEvent")
--variables
local purchasePistol = game.Players.LocalPlayer.PlayerGui.GunstoreUI.Frame.Frame.pistol.TextButton
local purchaseSMG = game.Players.LocalPlayer.PlayerGui.GunstoreUI.Frame.Frame.SMG.TextButton
local purchaseShotgun = game.Players.LocalPlayer.PlayerGui.GunstoreUI.Frame.Frame.shotgun.TextButton
local purchaseAR = game.Players.LocalPlayer.PlayerGui.GunstoreUI.Frame.Frame.AR.TextButton
local backpack = game.Players.LocalPlayer.Backpack
local weaponsFolder = ReplicatedStorage.Weapons

--functions
local function purchasedPistol ()
	if _G.money >= 200 then
		_G.money = _G.money - 200
		local weapon = weaponsFolder:FindFirstChild("Handgun")
		weapon:Clone().Parent = backpack
		print("pistol bought")
		
		if _G.QUEST_TUTORIAL_PROGRESS == 1 then
			_G.QUEST_TUTORIAL_PROGRESS += 1
			game:GetService("Players").LocalPlayer.PlayerGui.QuestGui.Frame.QuestFrame.Quest_Tutorial.Visible = false
			questUpdateEvent:Fire()
			game.ReplicatedStorage.Quest_Icons.FindNPC_Icon.Parent = workspace
			game.ReplicatedStorage.Quest_Icons.AssassinateNPC_Icon.Parent = workspace
			game.ReplicatedStorage.Quests.QNPC.Quest_Assassinate.Parent = workspace
			game.ReplicatedStorage.Quests.QNPC.Quest_Find.Parent = workspace

			game.Workspace.Quest_Tutorial:Destroy()
		end
	end
	if _G.money >= 200 then
		purchasePistol.BackgroundColor3 = Color3.new(0, 1, 0)
	end
end
local function purchasedSMG ()
	if _G.money >= 400 then
		_G.money = _G.money - 400
		local weapon = weaponsFolder:FindFirstChild("SMG")
		weapon:Clone().Parent = backpack
		print("SMG bought")
	end
end
local function purchasedShotgun ()
	if _G.money >= 500 then
		_G.money = _G.money - 500
		local weapon = weaponsFolder:FindFirstChild("Shotgun")
		weapon:Clone().Parent = backpack
		print("Shotgun bought")
	end
	
end
local function purchasedAR ()
	if _G.money >= 600 then
		_G.money = _G.money - 600
		local weapon = weaponsFolder:FindFirstChild("Assault Rifle")
		weapon:Clone().Parent = backpack
		print("AR bought")
	end
	
end


--code
purchasePistol.Activated:Connect(purchasedPistol)
purchaseSMG.Activated:Connect(purchasedSMG)
purchaseShotgun.Activated:Connect(purchasedShotgun)
purchaseAR.Activated:Connect(purchasedAR)
