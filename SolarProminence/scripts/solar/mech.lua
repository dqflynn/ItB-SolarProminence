
-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- locate our mech assets.
local mechPath = path .."img/units/solar/"

-- make a list of our files.
local files = {
	"mech.png",
	"mech_a.png",
	"mech_w.png",
	"mech_w_broken.png",
	"mech_broken.png",
	"mech_ns.png",
	"mech_h.png"
}

-- iterate our files and add the assets so the game can find them.
for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/solar_".. file, mechPath .. file)
end

-- create animations for our mech with our imported files.
-- note how the animations starts searching from /img/
local a = ANIMS
a.solar_mech =			a.MechUnit:new{Image = "units/player/solar_mech.png", PosX = -20, PosY = -3}
a.solar_mecha =			a.MechUnit:new{Image = "units/player/solar_mech_a.png", PosX = -21, PosY = -12, NumFrames = 4 }
a.solar_mechw =			a.MechUnit:new{Image = "units/player/solar_mech_w.png", PosX = -19, PosY = -6 }
a.solar_mech_broken =	a.MechUnit:new{Image = "units/player/solar_mech_broken.png", PosX = -16, PosY = -12 }
a.solar_mechw_broken =	a.MechUnit:new{Image = "units/player/solar_mech_w_broken.png", PosX = -17, PosY = -6 }
a.solar_mech_ns =		a.MechIcon:new{Image = "units/player/solar_mech_ns.png"}


-- we can make a mech based on another mech much like we did with weapons.
SolarMech = FlameMech:new{
	Name = "Solar Mech",
	
	-- FlameMech is also Prime, so this is redundant, but if you had no base, you would need a class.
	Class = "Prime",
	
	-- various stats.
	Health = 3,
	MoveSpeed = 3,
	Massive = true,
	
	-- reference the animations we set up earlier.
	Image = "solar_mech",
	
	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = 5,
	
	-- Any weapons this mech should start with goes in this table.
	SkillList = { "Dqf_Daybreak" },
	
	-- movement sounds.
	SoundLocation = "/mech/prime/punch_mech/",
	
	-- impact sounds.
	ImpactMaterial = IMPACT_METAL,
	
	-- who will be controlling this unit.
	DefaultTeam = TEAM_PLAYER,
}

-- or we can make a mech with a clean base when we are more proficient.
-- TemplateMech = Pawn:new{}
