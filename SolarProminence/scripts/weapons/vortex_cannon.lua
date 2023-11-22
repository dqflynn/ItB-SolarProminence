
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

-- add assets from our mod so the game can find them.
modApi:appendAsset("img/weapons/dqf_vortex_cannon.png", path .."img/weapons/vortex_cannon/weapon.png")

-- create a weapon based on Punchmech's Prime Punch.
-- using the new function creates a copy of an existing table,
-- and will use the variables and  function from it, unless we specify new values.
Dqf_Vortex_Cannon = TankDefault:new{
	Name = "Vortex Cannon",
	Class = "Brute",
	Description = "Fires a blast that damages and pushes.",
	Icon = "weapons/dqf_vortex_cannon.png",
	Explosion = "",
	Sound = "/general/combat/explode_small",
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	Damage = 1,
	SelfDamage = 0,
	Push = 1,
	TipImage = StandardTips.Ranged,
	Upgrades = 2,
	UpgradeCost = {1,2},
}

Weapon_Texts.Dqf_Vortex_Cannon_Upgrade1 = "+1 Damage/Self"
Weapon_Texts.Dqf_Vortex_Cannon_Upgrade2 = "+1 Damage"

Dqf_Vortex_Cannon_A = Dqf_Vortex_Cannon:new{
	Damage = 2,
	SelfDamage = 1,
	UpgradeDescription = "Damage +1, Self-damage +1."
}

Dqf_Vortex_Cannon_B = Dqf_Vortex_Cannon:new{
	Damage = 2,
	UpgradeDescription = "Damage +1."
}

Dqf_Vortex_Cannon_AB = Dqf_Vortex_Cannon:new{
	Damage = 3,
	SelfDamage = 1
}

--[[Dear Subset devs:
	Why would you do this to me? Why would you make me reprint the skill effect just because you checked manually for pushback when applying the self-damage
	and have no other method of applying it? Why would you do that? I shudder to think what madness must have o'ertaken you.
]]--

function Dqf_Vortex_Cannon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	if self.SelfDamage > 0 then
		local selfDam = SpaceDamage(p1, self.SelfDamage)
		ret:AddDamage(selfDam)
	end

	local pathing = self.Phase and PATH_PHASING or PATH_PROJECTILE
	local target = GetProjectileEnd(p1,p2,pathing)  
	
	local damage = SpaceDamage(target, self.Damage)
	if self.Flip == 1 then
		damage = SpaceDamage(target,self.Damage,DIR_FLIP)
	end
	if self.Push == 1 then
		damage.iPush = direction
	end
	damage.iAcid = self.Acid
	damage.iFrozen = self.Freeze
	damage.iFire = self.Fire
	damage.iShield = self.Shield
	damage.sAnimation = self.Explo..direction
	
	if self.Phase and Board:IsBuilding(target) then
		damage.sAnimation = ""
		damage.iDamage = 0
	end
	
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)--"effects/shot_mechtank")
		
	if self.BackShot == 1 then
		local backdir = GetDirection(p1 - p2)
		local target2 = GetProjectileEnd(p1,p1 + DIR_VECTORS[backdir])

		if target2 ~= p1 then
			damage = SpaceDamage(target2, self.Damage, backdir)
			damage.sAnimation = self.Explo..backdir
			ret:AddProjectile(damage,self.ProjectileArt)
		end
	end
	
	if self.PhaseShield then
		local temp = p1 + DIR_VECTORS[direction]
		while true do
			if Board:IsBuilding(temp) then
				damage = SpaceDamage(temp, 0)
				damage.iShield = 1
				ret:AddDamage(damage)
			end
		
			if temp == target then
				break
			end
			
			temp = temp + DIR_VECTORS[direction]
		end
	end
	
	return ret
end