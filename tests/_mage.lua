-- shared setup for the scenarios: a mage with the given spells known (loaded with dofile)
local M = {}
function M.mage(known)
	local s = wb.state
	s.player.classFile, s.player.class, s.player.classId = "MAGE", "Mage", 8
	local names = {
		[1459] = "Arcane Intellect", [1460] = "Arcane Intellect", [10157] = "Arcane Intellect",
		[168] = "Frost Armor", [7302] = "Ice Armor", [6117] = "Mage Armor",
		[5504] = "Conjure Water", [5505] = "Conjure Water", [587] = "Conjure Food",
		[3567] = "Teleport: Orgrimmar", [3563] = "Teleport: Undercity", [3566] = "Teleport: Thunder Bluff",
		[11417] = "Portal: Orgrimmar", [11418] = "Portal: Undercity", [11420] = "Portal: Thunder Bluff",
		[3561] = "Teleport: Stormwind", [3562] = "Teleport: Ironforge", [3565] = "Teleport: Darnassus",
		[10059] = "Portal: Stormwind", [11416] = "Portal: Ironforge", [11419] = "Portal: Darnassus",
		[429959] = "Well-Rested",
	}
	for _, id in ipairs(known or {}) do s.spells[id] = names[id] end
	s.spells[429959] = "Well-Rested"
	s.items[5350] = { name = "Conjured Water" }
	s.items[2288] = { name = "Conjured Fresh Water" }
	s.items[5349] = { name = "Conjured Muffin" }
end
function M.macroFor(spellName)
	for _, f in ipairs(wb.frames()) do
		local m = f:GetAttribute("macrotext")
		if m and f.__shown and m:find(spellName, 1, true) then return f end
	end
end
return M
