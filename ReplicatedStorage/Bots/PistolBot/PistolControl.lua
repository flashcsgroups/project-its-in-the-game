

-- Variabelen voor munitie, shade, wachttijd en herlaadstatus
local ammo = 15 -- Hoeveelheid munitie
local damage = 5
local firerate = .40 -- Wachttijd tussen schoten
local r=false -- Herlaadstatus

local t=script.Parent



-- Configuratie voor de positie en oriëntatie van het wapen
local cf={CFrame.new(.8,.5,.4)*CFrame.Angles(math.rad(270),math.rad(40),0),CFrame.new(-1.2,0.5,0.4)*CFrame.Angles(math.rad(270),math.rad(-5),0)}

-- Laden van de RbxUtility bibliotheek
local c=require(game.ReplicatedStorage:WaitForChild("LoadLibrary"):WaitForChild("RbxUtility")).Create

-- Creëren van de kogels
local b1=c'Part'{TopSurface=0;BottomSurface=0;Anchored=true;CanCollide=false;BrickColor=BrickColor.new("Cool yellow");Size=Vector3.new(.2,.2,1);c'SpecialMesh'{MeshType=6;Scale=Vector3.new(.2,.2,1)}};Transparency=.5
local b2=b1:Clone()
b1.Name,b2.Name='1','2'

-- Creëren van een onzichtbaar deel voor beweging
local mov=c'Part'{Transparency=1;CanCollide=false;Parent=t;Anchored=true}

-- Verwijzing naar het wapen
local h=t:WaitForChild'Handle'

-- Functie om het wapen te herladen
local function reload(boo)
	if(boo and ammo~=15)or ammo==0 then
		r=true
		if firerate then
			firerate=.03
		end
		h.Reload:Play()
		wait(3)
		ammo=15
		if firerate then
			firerate = .40
		end
		r=false
	elseif boo then
		wait(.1)
	end
end

-- Functie om de dichtstbijzijnde speler te vinden
local function near()
	local dis,pl=50,nil
	for _,v in ipairs(game.Players:GetPlayers())do
		if v.Character and v.Character:FindFirstChild'Humanoid'and v:DistanceFromCharacter(h.Position)<dis then
			dis,pl=v:DistanceFromCharacter(h.Position),v
		end
	end
	if pl then
		return pl.Character:GetModelCFrame(),dis,CFrame.new(pl.Character.Humanoid.WalkToPoint).lookVector
	else
		return nil
	end
end

-- Functie om het karakter te laten bewegen
Spawn(function()
	while wait(math.random(2,7)/10)do
		local n=near()
		if n and math.random(1,3)==2 or not n then
			mov.CFrame=t.Torso.CFrame+t.Torso.CFrame.lookVector*Vector3.new(math.random(-25,25),0,math.random(-25,25))
		else
			mov.CFrame=n+Vector3.new((math.random(1,2)==1 and 1 or -1)*math.random(25,50),0,(math.random(1,2)==1 and 1 or -1)*math.random(25,50))
		end
		wait(.1)
		t.Humanoid:MoveTo(mov.Position,mov)
	end
end)

-- Hoofdlus voor het afvuren van het wapen
while true do
	if workspace.PistolBot then
	local n,mag,hum=near()
	if n then
		n=n.p
		if not r then
			w=.40
			local dir=h.Position-n
			local tst,_=workspace:FindPartOnRay(Ray.new(t.Torso.Position,(n-t.Torso.Position).Unit*999),t)
			local aim=n+Vector3.new(math.random(-mag*.015,mag*.015),math.random(-mag*.015,mag*.015),math.random(-mag*.015,mag*.015))*(2+math.random())+hum
			if tst and tst.Parent and game.Players:GetPlayerFromCharacter(tst.Parent)then
				wait(.08)
				h.Fire:Play()
				local par,pos=workspace:FindPartOnRay(Ray.new(h.Position,(aim-h.Position).Unit*999),t)
				if par then
					local h=par.Parent:FindFirstChild'Humanoid'or par.Parent.Parent:FindFirstChild'Humanoid'
					if h and h.Health-damage>0 then
						h.Health=h.Health-damage
					elseif h then
						h.Health = 0
						h.Parent:BreakJoints()
					end
				end
				ammo=ammo-1
				mag=(h.Position-pos).magnitude
				b1.Parent,b2.Parent=t,t
				b1.CFrame,b2.CFrame=CFrame.new(h.Position:Lerp(pos,.375),pos),CFrame.new(pos:Lerp(h.Position,.125),h.Position)
				b1.Mesh.Scale,b2.Mesh.Scale=Vector3.new(.2,.2,mag*.75),Vector3.new(.2,.2,mag/4)
				Delay(.03,function()b1.Parent=nil wait(.03)b2.Parent=nil end)
			end
			
			wait(.05)
			if ammo==0 then
				reload()
			end
			
			
		end
	else
		reload(true)
		w=false
	end
end
	end