
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
Dqf_Vortex_Cannon = Brute_Tankmech:new{
	Name = "Vortex Cannon",
	Description = "Fires a blast that damages and pushes.",
	Icon = "weapons/dqf_vortex_cannon.png", -- notice how the game starts looking in /img/
	Damage = 1,
	
	-- adding upgrades for your weapon can be a fun part.
	-- their names would be Weapon_Template_A, Weapon_Template_B and Weapon_Template_AB (combined)
	-- since we haven't made them yet, we set upgrades to 0 to avoid crashing the game.
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