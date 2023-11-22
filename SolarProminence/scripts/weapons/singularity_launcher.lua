
--[[
	some simple examples of how to start coding weapons.
	to test these weapons, you can - with this mod enabled - write in the console:
	
	weapon Weapon_Template
	weapon Weapon_Template2
	
	you can then look over the code below to see how they were made.
	you'll notice Weapon_Template looks cooler than Weapon_Template2.
	to find out more on why that is, you can look at
	Prime_Punchmech in ITB/scripts/weapons_prime.lua,
	and look at how the GetSkillEffect of this weapon is different.
]]


-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath
LOG("Current Path: ")
LOG(path)

-- add assets from our mod so the game can find them.
modApi:appendAsset("img/weapons/dqf_singularity_launcher.png", path .."img/weapons/singularity_launcher/weapon.png")


-- add the singularity's assets to the game (i'm the dumbest man alive so this will take a while)
-- appending assets
LOG("Appending assets!")
modApi:appendAsset("img/units/player/dqf_black_hole.png", path .."img/units/player/black_hole.png")
modApi:appendAsset("img/units/player/dqf_black_holea.png", path .."img/units/player/black_holea.png")
modApi:appendAsset("img/units/player/dqf_black_holed.png", path .."img/units/player/black_holed.png")
modApi:appendAsset("img/units/player/dqf_black_holens.png", path .."img/units/player/black_holens.png")
modApi:appendAsset("img/effects/dqf_bh_projectile.png", path .. "img/effects/bh_projectile.png")
LOG("Assets appended!")
-- make an anim and add the files to the anim

local a = ANIMS
LOG("Anim created!")
a.dqf_black_hole =				a.MechUnit:new{ Image = "units/player/dqf_black_hole.png", PosX = -30, PosY = 0 }
a.dqf_black_holea =				a.MechUnit:new{ Image = "units/player/dqf_black_holea.png", PosX = -30, PosY = 0, NumFrames = 4 }
a.dqf_black_holed =				a.MechUnit:new{ Image = "units/player/dqf_black_holed.png", Loop = false, PosX = -30, Time = 0.075, NumFrames = 4 }
a.dqf_black_hole_ns =			a.MechIcon:new{ Image = "units/player/dqf_black_holens.png"}
LOG("Anim filled!")

-- make the singularity exist
Dqf_Singularity = Deploy_Tank:new{
	Name = "Singularity",
	Health = 2,
	MoveSpeed = 1,
	Image = "dqf_black_hole",
	SkillList = { "Dqf_Singularity_Pull" },
	--SoundLocation = "/support/civilian_tank/", -- not implemented
	ImpactMaterial = IMPACT_BLOB,
	SoundLocation = "/enemy/jelly/",
	Flying = true,
	DefaultTeam = TEAM_PLAYER,
	Corpse = false,
	Flying = true,
	Limited = 3
	--Corporate = true
}


Dqf_SingularityA = Dqf_Singularity:new{
	Health = 3
}

Dqf_SingularityB = Dqf_Singularity:new{
	MoveSpeed = 2
}

Dqf_SingularityAB = Dqf_Singularity:new{
	Health = 3, MoveSpeed = 2
}

Dqf_Singularity_Pull = Science_Repulse:new {
	Rarity = 0,
	Damage = 0,
	Class = "Unique",
	Icon = "weapons/deploy_tank.png",
	LaunchSound = "/weapons/stock_cannons",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Dqf_Singularity"
	}
}

function Dqf_Singularity_Pull:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	ret:AddBounce(p1,-2)
	--go through every 1-tile distance
	for i = DIR_START,DIR_END do
		local curr = p1 - DIR_VECTORS[i]
		local spaceDamage = SpaceDamage(curr, 0, i)
		
		spaceDamage.sAnimation = "airpush_"..i
		ret:AddDamage(spaceDamage)
		
		ret:AddBounce(curr,-1)
	end
	
	--go through every 2-tile distance
	for i = DIR_START,DIR_END do
		local curr = p1 - (DIR_VECTORS[i])*2
		local spaceDamage = SpaceDamage(curr, 0, i)
		
		spaceDamage.sAnimation = "airpush_"..i
		ret:AddDamage(spaceDamage)
		
		ret:AddBounce(curr,-1)
	end
	--[[TEST EFFECT
	local i = 0
	LOG(DIR_VECTORS)
	local curr = p1 - DIR_VECTORS[i]
	local spaceDamage = SpaceDamage(curr, 0, i)
	
	if self.ShieldFriendly and (Board:IsBuilding(curr) or Board:GetPawnTeam(curr) == TEAM_PLAYER) then
		spaceDamage.iShield = 1
	end
	
	spaceDamage.sAnimation = "airpush_"..i
	ret:AddDamage(spaceDamage)
	
	ret:AddBounce(curr,-1)
	]]--
	--apply extra bullshittery
	local selfDamage = SpaceDamage(p1,0)
	
	if self.ShieldSelf then
		selfDamage.iShield = 1
	end
		
	selfDamage.sAnimation = "ExploRepulse1"
	ret:AddDamage(selfDamage)
	
	return ret
end

Dqf_Singularity_Launcher = DeploySkill_Tank:new{
	Name = "Singularity Launcher",
	Description = "Fires a singularity that can pull enemies.",
	Icon = "weapons/dqf_singularity_launcher.png", -- notice how the game starts looking in /img/
	Deployed = "Dqf_Singularity",
	Class = "Science",
	Projectile = "effects/dqf_bh_projectile.png",
	Limited = 5,
	Upgrades = 2,
	UpgradeCost = {1,2},
}
--Custom targeting (allows flyers)
function Dqf_Singularity_Launcher:GetTargetArea(point)

	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
			
			if not Board:IsBlocked(curr, PATH_PROJECTILE) then
				ret:push_back(curr)
			end

		end
	end
	
	return ret
end

Weapon_Texts.Dqf_Singularity_Launcher_Upgrade1 = "+1 Summon Health"
Weapon_Texts.Dqf_Singularity_Launcher_Upgrade2 = "+1 Summon Move"

Dqf_Singularity_Launcher_A = Dqf_Singularity_Launcher:new{
	Deployed = "Dqf_SingularityA",
	UpgradeDescription = "+1 Singularity Health."
}

Dqf_Singularity_Launcher_B = Dqf_Singularity_Launcher:new{
	Deployed = "Dqf_SingularityB",
	UpgradeDescription = "+1 Singularity Move."
}

Dqf_Singularity_Launcher_AB = Dqf_Singularity_Launcher:new{
	Deployed = "Dqf_SingularityAB",
}