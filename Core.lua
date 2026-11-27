-- Chronobound: the Mage addon of the Bound family, built on LibBound-1.0 (the shared core).
-- This file sets the addon up; every other file returns at once on a non-mage (ns.disabled).
local addonName, ns = ...
local Bound = LibStub("LibBound-1.0")

-- Spells and items, lowest rank first (index i of a spell list makes index i of its item list).
-- Classic IDs; Forever follows Classic content. Checked in game before each release.
ns.DATA = {
	removeCurse = { 475 }, -- Remove Lesser Curse
	water = { 5504, 5505, 5506, 6127, 10138, 10139, 10140 },
	waterItems = { 5350, 2288, 2136, 3772, 8077, 8078, 8079 },
	food = { 587, 597, 990, 6129, 10144, 10145, 28612 },
	foodItems = { 5349, 1113, 1114, 1487, 8075, 8076, 22895 },
	intellect = { 1459, 1460, 1461, 10156, 10157 },
	brilliance = { 23028 },
	frostArmor = { 168, 7300, 7301 },
	iceArmor = { 7302, 7320, 10219, 10220 },
	mageArmor = { 6117, 22782, 22783 },
}

ns.disabled = Bound:NewAddon(addonName, ns, {
	class = "MAGE",
	title = "Chronobound",
	prefix = "9fdcff",
	db = "ChronoboundDB",
	slash = { "/cb", "/chronobound" },
	media = "Interface\\AddOns\\Chronobound\\Media\\",
	defaults = {
		skin = "frost",
		intellect = true, intellectMinutes = 2, intellectSound = false, intellectIcon = true, intellectKeep = true,
		aiPoint = { "CENTER", "UIParent", "CENTER", -250, 200 },
		armor = true, armorMinutes = 1, armorSound = false, armorIcon = true, armorKeep = true, armorChoice = "Frost",
		arPoint = { "CENTER", "UIParent", "CENTER", -250, 140 },
		conjure = true, waterLow = 5, foodLow = 3,
		cwPoint = { "CENTER", "UIParent", "CENTER", 250, 200 },
		cfPoint = { "CENTER", "UIParent", "CENTER", 250, 140 },
		travel = true,
		-- Well-Rested and Well Fed (shared with every Bound addon) sit lower than in Lightbound
		wrPoint = { "CENTER", "UIParent", "CENTER", 0, 320 },
		wfPoint = { "CENTER", "UIParent", "CENTER", 0, 260 },
	},
})
