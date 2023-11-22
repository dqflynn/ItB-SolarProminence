
-- this line just gets the file path for the mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- locate the mech assets.
local mechPath = path .."img/units/nebula/"

-- make a list of the files.
local files = {
	"mech.png",
	"mech_a.png",
	"mech_w.png",
	"mech_w_broken.png",
	"mech_broken.png",
	"mech_ns.png",
	"mech_h.png"
}

-- iterate the files and add the assets so the game can find them.
for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/nebula_".. file, mechPath .. file)
end
-- I'm not actually entirely sure how this works but people smarter than me said it loads the mod somehow

-- create animations for the mech with the imported files.
-- don't take the advice left by a previous comment
local a = ANIMS
a.nebula_mech =			a.MechUnit:new{Image = "units/player/nebula_mech.png", PosX = -20, PosY = -3}
a.nebula_mecha =		a.MechUnit:new{Image = "units/player/nebula_mech_a.png", PosX = -14, PosY = -12, NumFrames = 4 }
a.nebula_mechw =		a.MechUnit:new{Image = "units/player/nebula_mech_w.png", PosX = -19, PosY = 6 }
a.nebula_mech_broken =	a.MechUnit:new{Image = "units/player/nebula_mech_broken.png", PosX = -15, PosY = -6 }
a.nebula_mechw_broken =	a.MechUnit:new{Image = "units/player/nebula_mech_w_broken.png", PosX = -17, PosY = 8 }
a.nebula_mech_ns =		a.MechIcon:new{Image = "units/player/nebula_mech_ns.png"}


-- Base off Flame Mech, because I'm a lazy bastard and this is easier.
NebulaMech = ScienceMech:new{
	Name = "Nebula Mech",
	
	-- Set class.
	Class = "Science",
	
	-- various stats.
	Health = 2,
	MoveSpeed = 1,
	Massive = true,
	Flying = true,
	
	-- reference the animations we set up earlier.
	Image = "nebula_mech",
	
	-- ImageOffset specifies which color scheme will be used.
	-- (only appropriate if you draw your mechs with Archive olive green colors)
	ImageOffset = 5,
	
	-- Any weapons this mech should start with goes in this table.
	SkillList = { "Dqf_Singularity_Launcher" },
	
	-- movement sounds.
	SoundLocation = "/mech/prime/punch_mech/",
	
	-- impact sounds.
	ImpactMaterial = IMPACT_METAL,
	
	-- who will be controlling this unit.
	DefaultTeam = TEAM_PLAYER,
}

-- or we can make a mech with a clean base when we are more proficient.
-- TemplateMech = Pawn:new{}
