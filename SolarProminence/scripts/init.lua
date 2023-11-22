
-- init.lua is the entry point of every mod

local mod = {
	id = "dqf_solar_prominence",
	name = "Solar Prominence",
	version = "1.048596",
	requirements = {
		modApiExt = "1.2",
		memedit = "0.1.0",
	},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init()
	-- look in template/mech to see how to code mechs.
	require(self.scriptPath .."solar/mech")
	require(self.scriptPath .."weapons/daybreak")
	require(self.scriptPath .."vortex/mech")
	require(self.scriptPath .."weapons/vortex_cannon")
	require(self.scriptPath .."nebula/mech")
	require(self.scriptPath .."weapons/singularity_launcher")
end

function mod:load(options, version)
	-- after we have added our mechs, we can add a squad using them.
	modApi:addSquad(
		{
			"Solar Prominence",		-- title
			"SolarMech",			-- mech #1
			"VortexMech",			-- mech #2
			"NebulaMech"			-- mech #3
		},
		"Solar Prominence",
		"Mechs using the power of the cosmos and the Grid to purge the Vek.",
		self.resourcePath .."img/mod_icon.png"
	)
	LOG("Solar Load Completed!")
end

return mod
