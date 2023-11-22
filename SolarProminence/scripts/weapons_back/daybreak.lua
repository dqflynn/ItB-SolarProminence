
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
local this = {}
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- add assets from our mod so the game can find them.
modApi:appendAsset("img/weapons/dqf_daybreak.png", path .."img/weapons/daybreak/weapon.png")

-- create a weapon based on Punchmech's Prime Punch.
-- using the new function creates a copy of an existing table,
-- and will use the variables and  function from it, unless we specify new values.
Dqf_Daybreak = Prime_Punchmech:new{
	Name = "Daybreak",
	Description = "Fires a short-range blast, damaging and pushing an adjacent enemy. Damage increases every 3 Grid Power.",
	Icon = "weapons/dqf_daybreak.png", -- notice how the game starts looking in /img/
	Damage = 1,
	Push = 1,
	SelfDamage = 0,
	
	-- adding upgrades for your weapon can be a fun part.
	-- their names would be Weapon_Template_A, Weapon_Template_B and Weapon_Template_AB (combined)
	Upgrades = 2,
	UpgradeCost = {1,3},
}

function Dqf_Daybreak:GetSkillEffect(p1,p2)
	if Board:IsTipImage() then
		local ret = SkillEffect()
		local direction = GetDirection(p2 - p1)
		local push_damage = direction
		local damage = SpaceDamage(p2, self.Damage, push_damage) --self.Damage = 1
		damage.sAnimation = "explopunch1_"..direction
		ret:AddDamage(damage)
		
		return ret
	end
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local push_damage = direction
	local damage = SpaceDamage(p2, (self.Damage + math.floor((Game:GetPower():GetValue())/3)), push_damage) --self.Damage = 1
	damage.sAnimation = "explopunch1_"..direction
	ret:AddDamage(damage)
	
	return ret
end
	

Weapon_Texts.Dqf_Daybreak_Upgrade1 = "+1 Damage/Self"
Weapon_Texts.Dqf_Daybreak_Upgrade2 = "+1 Damage"

Dqf_Daybreak_A = Dqf_Daybreak:new{
	Damage = 2,
	SelfDamage = 1,
	UpgradeDescription = "Damage +1, Self Damage +1."
}

Dqf_Daybreak_B = Dqf_Daybreak:new{
	Damage = 2,
	UpgradeDescription = "Damage +1."
}

Dqf_Daybreak_AB = Dqf_Daybreak:new{
	Damage = 3,
	SelfDamage = 1
}