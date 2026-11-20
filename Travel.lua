-- The travel panel (LibBound): beside the game menu (Escape), the mage's teleports in one column and
-- portals in the other, for the player's faction, then the rune counts and the Hearthstone.
local _, ns = ...
if ns.disabled then return end
local Bound = LibStub("LibBound-1.0")

local CITIES = {
	Horde = {
		{ city = "Orgrimmar", teleport = 3567, tLevel = 20, portal = 11417, pLevel = 40 },
		{ city = "Undercity", teleport = 3563, tLevel = 20, portal = 11418, pLevel = 40 },
		{ city = "Thunder Bluff", teleport = 3566, tLevel = 30, portal = 11420, pLevel = 50 },
	},
	Alliance = {
		{ city = "Stormwind", teleport = 3561, tLevel = 20, portal = 10059, pLevel = 40 },
		{ city = "Ironforge", teleport = 3562, tLevel = 20, portal = 11416, pLevel = 40 },
		{ city = "Darnassus", teleport = 3565, tLevel = 30, portal = 11419, pLevel = 50 },
	},
}
local RUNE_TELEPORT, RUNE_PORTAL = 17031, 17032

local function Known(id)
	local ok, k = pcall(IsPlayerSpell, id)
	return ok and not ns.IsSecret(k) and k and true or false
end
local function Count(id)
	local ok, n = pcall(C_Item.GetItemCount, id)
	return (ok and not ns.IsSecret(n) and n) or 0
end

-- the rows for the player's faction: { spell, city, kind, known, level } (+ the panel's fields)
function ns.TravelRows()
	local faction = UnitFactionGroup("player")
	local out = {}
	for _, c in ipairs(CITIES[faction] or CITIES.Horde) do
		out[#out + 1] = { spell = c.teleport, city = c.city, label = c.city, kind = "teleport", column = 1,
			known = Known(c.teleport), level = c.tLevel, tip = "Teleport: " .. c.city, help = ns.Help.teleport,
			learn = "from a mage trainer" }
		out[#out + 1] = { spell = c.portal, city = c.city, label = c.city, kind = "portal", column = 2,
			known = Known(c.portal), level = c.pLevel, tip = "Portal: " .. c.city, help = ns.Help.portal,
			learn = "from a mage trainer" }
	end
	return out
end

Bound.InstallTravel(ns, {
	columns = { "TELEPORT", "PORTAL" },
	rows = ns.TravelRows,
	footer = function()
		local t, p = Count(RUNE_TELEPORT), Count(RUNE_PORTAL)
		local function N(n) return (n < 3 and ns.UI.Hex({ 1, 0.62, 0.42 }) or "") .. n .. "|r" end
		return "Runes: Teleportation " .. N(t) .. " · Portals " .. N(p)
	end,
	hearthHelp = ns.Help.hearthstone,
})
