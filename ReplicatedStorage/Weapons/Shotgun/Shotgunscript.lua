local function WaitForChild(parent, childName)
	while not parent:FindFirstChild(childName) do parent.ChildAdded:wait() end
	return parent[childName]
end

----- TOOL DATA -----
local Damage = 9
local FireRate = 1 / 1.25
local Range = 350
local MinSpread = 0.050
local MaxSpread = 0.050
local ClipSize = 4
local SpareAmmo = 999
local AimInaccuracyStepAmount = 1
local ReloadTime = 3
----------------------------------------

local FriendlyReticleColor = Color3.new(0, 1, 0)
local EnemyReticleColor	= Color3.new(1, 0, 0)
local NeutralReticleColor	= Color3.new(1, 1, 1)

local Spread = MinSpread
local AmmoInClip = ClipSize

local Tool = script.Parent
local Handle = WaitForChild(Tool, 'Handle')
local WeaponGui = nil

local LeftButtonDown
local Reloading = false
local IsShooting = false
local Pitch = script.Parent.Handle.FireSound

local MyPlayer = nil
local MyCharacter = nil
local MyHumanoid = nil
local MyTorso = nil
local MyMouse = nil


local RecoilAnim
local RecoilTrack = nil

local ReloadAnim
local ReloadTrack = nil

local IconURL = Tool.TextureId  
local DebrisService = game:GetService('Debris')
local PlayersService = game:GetService('Players')


local FireSound

local OnFireConnection = nil
local OnReloadConnection = nil

local DecreasedAimLastShot = false
local LastSpreadUpdate = time()

local flare = script.Parent:WaitForChild("Flare")

local FlashHolder = nil


local WorldToCellFunction = Workspace.Terrain.WorldToCellPreferSolid
local GetCellFunction = Workspace.Terrain.GetCell

function RayIgnoreCheck(hit, pos)
	if hit then
		if hit.Transparency >= 1 or string.lower(hit.Name) == "water" or
				hit.Name == "Effect" or hit.Name == "Rocket" or hit.Name == "Bullet" or
				hit.Name == "Handle" or hit:IsDescendantOf(MyCharacter) then
			return true
		elseif hit:IsA('Terrain') and pos then
			local cellPos = WorldToCellFunction(Workspace.Terrain, pos)
			if cellPos then
				local cellMat = GetCellFunction(Workspace.Terrain, cellPos.x, cellPos.y, cellPos.z)
				if cellMat and cellMat == Enum.CellMaterial.Water then
					return true
				end
			end
		end
	end
	return false
end

function RayCast(startPos, vec, rayLength)
	local hitObject, hitPos = game.Workspace:FindPartOnRay(Ray.new(startPos + (vec * .01), vec * rayLength), Handle)
	if hitObject and hitPos then
		local distance = rayLength - (hitPos - startPos).magnitude
		if RayIgnoreCheck(hitObject, hitPos) and distance > 0 then
			return RayCast(hitPos, vec, distance)
		end
	end
	return hitObject, hitPos
end



function TagHumanoid(humanoid, player)
	while humanoid:FindFirstChild('creator') do
		humanoid:FindFirstChild('creator'):Destroy()
	end 
	local creatorTag = Instance.new("ObjectValue")
	creatorTag.Value = player
	creatorTag.Name = "creator"
	creatorTag.Parent = humanoid
	DebrisService:AddItem(creatorTag, 1.5)

	local weaponIconTag = Instance.new("StringValue")
	weaponIconTag.Value = IconURL
	weaponIconTag.Name = "icon"
	weaponIconTag.Parent = creatorTag
end


local function CreateBullet(bulletPos)
	local bullet = Instance.new('Part', Workspace)
	bullet.FormFactor = Enum.FormFactor.Custom
	bullet.Size = Vector3.new(0.1, 0.1, 0.1)
	bullet.BrickColor = BrickColor.new("Black")
	bullet.Shape = Enum.PartType.Block
	bullet.CanCollide = false
	bullet.CFrame = CFrame.new(bulletPos)
	bullet.Anchored = true
	bullet.TopSurface = Enum.SurfaceType.Smooth
	bullet.BottomSurface = Enum.SurfaceType.Smooth
	bullet.Name = 'Bullet'
	DebrisService:AddItem(bullet, 2.5)
		
	return bullet
end

local function Reload()
	if not Reloading then
		Reloading = true
		if AmmoInClip ~= ClipSize and SpareAmmo > 0 then
			if RecoilTrack then
				RecoilTrack:Stop()
			end
			if WeaponGui and WeaponGui:FindFirstChild('Crosshair') then
				if WeaponGui.Crosshair:FindFirstChild('ReloadingLabel') then
					WeaponGui.Crosshair.ReloadingLabel.Visible = true
				end
			end
			if ReloadTrack then
				ReloadTrack:Play()
			end
			script.Parent.Handle.Reload:Play()
			wait(ReloadTime)
			local ammoToUse = math.min(ClipSize - AmmoInClip, SpareAmmo)
			AmmoInClip = AmmoInClip + ammoToUse
			SpareAmmo = SpareAmmo - ammoToUse
			UpdateAmmo(AmmoInClip)
			if ReloadTrack then
				ReloadTrack:Stop()
			end
		end
		Reloading = false
	end
end

function OnFire()
	if IsShooting then return end
	if MyHumanoid and MyHumanoid.Health > 0 then
		if RecoilTrack and AmmoInClip > 0 then
			RecoilTrack:Play()
		end
		IsShooting = true
		while LeftButtonDown and AmmoInClip > 0 and not Reloading do
			if Spread and not DecreasedAimLastShot then
				Spread = math.min(MaxSpread, Spread + AimInaccuracyStepAmount)
				UpdateCrosshair(Spread)
			end
			DecreasedAimLastShot = not DecreasedAimLastShot
			if Handle:FindFirstChild('FireSound') then
				Pitch.Pitch = .8 + (math.random() * .5)
				Handle.FireSound:Play()
				Handle.Flash.Enabled = true
				flare.MuzzleFlash.Enabled = true
			end
			if MyMouse then
				local targetPoint = MyMouse.Hit.p
				local shootDirection = (targetPoint - Handle.Position).unit
				shootDirection = CFrame.Angles((0.5 - math.random()) * 2 * Spread,
																(0.5 - math.random()) * 2 * Spread,
																(0.5 - math.random()) * 2 * Spread) * shootDirection
				local hitObject, bulletPos = RayCast(Handle.Position, shootDirection, Range)
				local bullet
				if hitObject then
					bullet = CreateBullet(bulletPos)
				end
				if hitObject and hitObject.Parent then
					local hitHumanoid = hitObject.Parent:FindFirstChild("Humanoid")
					if hitHumanoid then
						local hitPlayer = game.Players:GetPlayerFromCharacter(hitHumanoid.Parent)
						if MyPlayer.Neutral or (hitPlayer and hitPlayer.TeamColor ~= MyPlayer.TeamColor) then
							TagHumanoid(hitHumanoid, MyPlayer)
							hitHumanoid:TakeDamage(Damage)
							if bullet then
								bullet:Destroy()
								bullet = nil
								WeaponGui.Crosshair.Hit:Play()
							end
							Spawn(UpdateTargetHit)
						end
					end
				end
				AmmoInClip = AmmoInClip - 1
				UpdateAmmo(AmmoInClip)
			end
			wait(.3)
			flare.MuzzleFlash.Enabled = false
			wait(FireRate-.3)
		end

		Handle.Flash.Enabled = false
		IsShooting = false
		
		if AmmoInClip == 0 then
			Handle.Tick:Play()
			Reload()
		end
		if RecoilTrack then
			RecoilTrack:Stop()
		end
	end
end

local TargetHits = 0
function UpdateTargetHit()
	TargetHits = TargetHits + 1
	if WeaponGui and WeaponGui:FindFirstChild('Crosshair') and WeaponGui.Crosshair:FindFirstChild('TargetHitImage') then
		WeaponGui.Crosshair.TargetHitImage.Visible = true
	end
	wait(0.5)
	TargetHits = TargetHits - 1
	if TargetHits == 0 and WeaponGui and WeaponGui:FindFirstChild('Crosshair') and WeaponGui.Crosshair:FindFirstChild('TargetHitImage') then
		WeaponGui.Crosshair.TargetHitImage.Visible = false
	end
end

function UpdateCrosshair(value, mouse)
	if WeaponGui then
		local absoluteY = 650
		WeaponGui.Crosshair:TweenSize(
			UDim2.new(0, value * absoluteY * 2 + 23, 0, value * absoluteY * 2 + 23),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Linear,
			0.33)
	end
end

function UpdateAmmo(value)
	if WeaponGui and WeaponGui:FindFirstChild('AmmoHud') and WeaponGui.AmmoHud:FindFirstChild('ClipAmmo') then
		WeaponGui.AmmoHud.ClipAmmo.Text = AmmoInClip
		if value > 0 and WeaponGui:FindFirstChild('Crosshair') and WeaponGui.Crosshair:FindFirstChild('ReloadingLabel') then
			WeaponGui.Crosshair.ReloadingLabel.Visible = false
		end
	end
	if WeaponGui and WeaponGui:FindFirstChild('AmmoHud') and WeaponGui.AmmoHud:FindFirstChild('TotalAmmo') then
		WeaponGui.AmmoHud.TotalAmmo.Text = SpareAmmo
	end
end


function OnMouseDown()
	LeftButtonDown = true
	OnFire()
end

function OnMouseUp()
	LeftButtonDown = false
end

function OnKeyDown(key)
	if string.lower(key) == 'r' then
		Reload()
		if RecoilTrack then
			RecoilTrack:Stop()
		end
	end
end


function OnEquipped(mouse)
	Handle.EquipSound:Play()
	Handle.EquipSound2:Play()
	Handle.UnequipSound:Stop()
	RecoilAnim = WaitForChild(Tool, 'Recoil')
	ReloadAnim = WaitForChild(Tool, 'Reload')
	FireSound  = WaitForChild(Handle, 'FireSound')

	MyCharacter = Tool.Parent
	MyPlayer = game:GetService('Players'):GetPlayerFromCharacter(MyCharacter)
	MyHumanoid = MyCharacter:FindFirstChild('Humanoid')
	MyTorso = MyCharacter:FindFirstChild('Torso')
	MyMouse = mouse
	WeaponGui = WaitForChild(Tool, 'WeaponHud'):Clone()
	if WeaponGui and MyPlayer then
		WeaponGui.Parent = MyPlayer.PlayerGui
		UpdateAmmo(AmmoInClip)
	end
	if RecoilAnim then
		RecoilTrack = MyHumanoid:LoadAnimation(RecoilAnim)
	end
	
	if ReloadAnim then
		ReloadTrack = MyHumanoid:LoadAnimation(ReloadAnim)
	end

	if MyMouse then
		MyMouse.Icon = "http://www.roblox.com/asset/?id=18662154"
		MyMouse.Button1Down:connect(OnMouseDown)
		MyMouse.Button1Up:connect(OnMouseUp)
		MyMouse.KeyDown:connect(OnKeyDown)
	end
end


-- Unequip logic here
function OnUnequipped()
	Handle.UnequipSound:Play()
	Handle.EquipSound:Stop()
	Handle.EquipSound2:Stop()
	LeftButtonDown = false
	flare.MuzzleFlash.Enabled = false
	Reloading = false
	MyCharacter = nil
	MyHumanoid = nil
	MyTorso = nil
	MyPlayer = nil
	MyMouse = nil
	if OnFireConnection then
		OnFireConnection:disconnect()
	end
	if OnReloadConnection then
		OnReloadConnection:disconnect()
	end
	if FlashHolder then
		FlashHolder = nil
	end
	if WeaponGui then
		WeaponGui.Parent = nil
		WeaponGui = nil
	end
	if RecoilTrack then
		RecoilTrack:Stop()
	end
	if ReloadTrack then
		ReloadTrack:Stop()
	end
end

local function SetReticleColor(color)
	if WeaponGui and WeaponGui:FindFirstChild('Crosshair') then
		for _, line in pairs(WeaponGui.Crosshair:GetChildren()) do
			if line:IsA('Frame') then
				line.BorderColor3 = color
			end
		end
	end
end


Tool.Equipped:connect(OnEquipped)
Tool.Unequipped:connect(OnUnequipped)

while true do
	wait(0.033)
	if WeaponGui and WeaponGui:FindFirstChild('Crosshair') and MyMouse then
		WeaponGui.Crosshair.Position = UDim2.new(0, MyMouse.X, 0, MyMouse.Y)
		SetReticleColor(NeutralReticleColor)

		local target = MyMouse.Target
		if target and target.Parent then
			local player = PlayersService:GetPlayerFromCharacter(target.Parent)
			if player then
				if MyPlayer.Neutral or player.TeamColor ~= MyPlayer.TeamColor then
					SetReticleColor(EnemyReticleColor)
				else
					SetReticleColor(FriendlyReticleColor)
				end
			end
		end
	end
	if Spread and not IsShooting then
		local currTime = time()
		if currTime - LastSpreadUpdate > FireRate * 2 then
			LastSpreadUpdate = currTime
			Spread = math.max(MinSpread, Spread - AimInaccuracyStepAmount)
			UpdateCrosshair(Spread, MyMouse)
		end
	end
end
