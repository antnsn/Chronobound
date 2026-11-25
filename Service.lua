-- The portal service (LibBound Service.lua): announce portals in Trade, and an alert with
-- [Invite]/[Whisper] when someone asks for one ("wtb port org", or "uc" whispered).
local _, ns = ...
if ns.disabled then return end
local Bound = LibStub("LibBound-1.0")

-- what people type for each city: word -> the city {target} becomes
local TARGETS = {
	Horde = { org = "Orgrimmar", orgrimmar = "Orgrimmar", ogri = "Orgrimmar", uc = "Undercity",
		undercity = "Undercity", tb = "Thunder Bluff", ["thunder bluff"] = "Thunder Bluff" },
	-- no "if" for Ironforge: it is an ordinary word ("anyone know if ...")
	Alliance = { sw = "Stormwind", stormwind = "Stormwind", ironforge = "Ironforge",
		darn = "Darnassus", darnassus = "Darnassus" },
}

Bound.InstallService(ns, {
	label = "Portals",
	page = "Portal service",
	example = 'Portals to {portals}! Whisper "port {short}", tips welcome :)',
	reply = "Hi {name}! Inviting you for a portal to {target}, I'm in {zone}.",
	keywords = { "portal", "portals", "mage port" },
	weak = { "port", "ports" }, -- "need a port pls" yes, "lol port" no
	targets = function() return TARGETS[UnitFactionGroup("player")] or TARGETS.Horde end,
	available = function() return #ns.KnownPortals() > 0 end,
	unavailable = "You know no portals yet (Portal: Orgrimmar at level 40).",
	fill = {
		portals = function() return table.concat(ns.KnownPortals(), ", ") end,
		short = function() return table.concat(ns.KnownPortals(true), "/") end,
		runes = function() return ns.PortalRunes() end,
	},
	help = ns.Help.service,
})
