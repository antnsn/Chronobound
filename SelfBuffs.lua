-- Self-buff cards: Arcane Intellect and the armor spell. A card shows when the buff is missing or
-- about to run out; click it to cast (out of combat). Built on LibBound's buff timers. A spell the
-- mage hasn't learned yet shows nothing.
local _, ns = ...
if ns.disabled then return end
local D = ns.DATA

local function Name(list) local id = ns.BestRank(list) return id and ns.SpellName(id) end
-- a buff's name as the client shows it, known or not (someone else can cast it on you)
local function BuffName(list, english) return ns.SpellName(list[1]) or english end

-- which armor to keep up: Mage Armor when chosen and known, else Ice Armor, else Frost Armor
local function ArmorSpell()
	if ns.db.armorChoice == "Mage" then
		local m = Name(D.mageArmor)
		if m then return m end
	end
	return Name(D.iceArmor) or Name(D.frostArmor)
end
ns.ArmorSpell = ArmorSpell

ns.MakeBuffTimer({
	key = "intellect", point = "aiPoint", frameName = "ChronoboundIntellectFrame",
	label = "Arcane Intellect", icon = 135932,
	names = function() return { BuffName(D.intellect, "Arcane Intellect"), BuffName(D.brilliance, "Arcane Brilliance") } end,
	active = function() return ns.BestRank(D.intellect) ~= nil end,
	cast = function() return Name(D.intellect) end,
	explain = ns.Help.intellect,
	goneText = "Missing: click to cast",
})

ns.MakeBuffTimer({
	key = "armor", point = "arPoint", frameName = "ChronoboundArmorFrame",
	label = "Armor", icon = 135843,
	title = function() return ArmorSpell() or "Frost Armor" end,
	-- any of the three counts as armored: the card asks for the chosen one only when none is up
	names = function()
		return { BuffName(D.mageArmor, "Mage Armor"), BuffName(D.iceArmor, "Ice Armor"), BuffName(D.frostArmor, "Frost Armor") }
	end,
	active = function() return ArmorSpell() ~= nil end,
	cast = ArmorSpell,
	explain = ns.Help.armor,
	goneText = "Missing: click to cast",
})

-- the buff key (LibBound) also gives Arcane Intellect to the group, on the next member in range
-- missing it (Arcane Brilliance counts)
ns.groupBuffs[#ns.groupBuffs + 1] = { list = D.intellect,
	names = function() return { BuffName(D.intellect, "Arcane Intellect"), BuffName(D.brilliance, "Arcane Brilliance") } end,
	enabled = function() return ns.db.intellect ~= false end }
