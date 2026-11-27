-- Chronobound's option pages; LibBound adds Extras (Well Rested, Well Fed, explanations,
-- minimap) and Skin, and builds the window.
local _, ns = ...
if ns.disabled then return end
local Bound = LibStub("LibBound-1.0")

local function BuffPage(UI)
	local p = UI.NewPage("Buffs", "Cards for the buffs a mage keeps up. Click a card to cast (out of combat).")
	local W = UI.CONTENT_W
	local function Block(title, key, note)
		p:Add(UI.Section(p, p.y - 4, title) + 2)
		if note then p:Add(UI.Note(p, p.y, note)) end
		local third = math.floor(W / 3)
		UI.DBToggle(p, 0, p.y, third, key, "Show")
		UI.DBToggle(p, third, p.y, third, key .. "Sound", "Sound")
		UI.DBToggle(p, third * 2, p.y, third, key .. "Keep", "When missing", nil, function() ns.UpdateBuffTimers() end)
		p:Add(32)
		p:Add(select(2, UI.Slider(p, p.y, "Warn with time left", key .. "Minutes", 1, 10, 1, " min")) + 8)
	end
	Block("Arcane Intellect", "intellect", "More mana. Lasts 30 minutes.")
	Block("Armor", "armor", "Frost Armor, then Ice Armor when you learn it, or Mage Armor if you pick it below.")
	p:Add(select(2, UI.Cycle(p, p.y, "Armor to keep up", { "Frost", "Mage" },
		function() return ns.db.armorChoice end,
		function(v) ns.db.armorChoice = v; ns.UpdateBuffTimers() end,
		function()
			return ns.db.armorChoice == "Mage" and "Mage Armor: more mana back while casting (from level 34)."
				or "Frost or Ice Armor: more armor, slows enemies that hit you."
		end)))
end

local function ConjurePage(UI)
	local p = UI.NewPage("Food & water", "A card when your conjured food or water runs low. Click it to conjure more.")
	local W = UI.CONTENT_W
	p:Add(select(2, UI.DBToggle(p, 0, p.y, W, "conjure", "Watch conjured food and water",
		"Counts every rank in your bags, and says when you can make a better one.")) + 8)
	p:Add(select(2, UI.Slider(p, p.y, "Water: warn at", "waterLow", 0, 40, 1, " left")) + 8)
	p:Add(select(2, UI.Slider(p, p.y, "Food: warn at", "foodLow", 0, 40, 1, " left")) + 8)
end

local function TravelPage(UI)
	local p = UI.NewPage("Travel", "Teleports, portals and your Hearthstone beside the game menu (Escape).")
	local W = UI.CONTENT_W
	p:Add(select(2, UI.DBToggle(p, 0, p.y, W, "travel", "Show the travel panel when the game menu opens",
		"Greyed ones are not learned yet; hover for the level.")) + 8)
	p:Add(UI.Note(p, p.y, ns.Help.runes))
end

ns.optionPages[#ns.optionPages + 1] = BuffPage
ns.optionPages[#ns.optionPages + 1] = ConjurePage
if ns.CleansePage then ns.optionPages[#ns.optionPages + 1] = ns.CleansePage end -- Decurse (Decurse.lua)
ns.optionPages[#ns.optionPages + 1] = TravelPage
ns.optionPages[#ns.optionPages + 1] = ns.ServicePage
Bound.InstallOptions(ns, { header = "Mage helper", launcher = "Mage helper: food and water, buffs, travel." })
