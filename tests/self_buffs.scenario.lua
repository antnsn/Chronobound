--@moods: fresh lowlevel ice magearmor combat buffed brilliance gifted
local T = dofile(wb.dir .. "/tests/_mage.lua")
local m = wb.mood
local known = ({ fresh = {}, lowlevel = { 1459, 168 }, ice = { 1459, 168, 7302 }, magearmor = { 1459, 168, 6117 },
	combat = { 1459, 168 }, buffed = { 1459, 168 }, brilliance = { 1459, 168 }, gifted = {} })[m]
T.mage(known)
if m == "gifted" then
	-- a level 1 mage gets Arcane Intellect from someone else; it runs out
	wb.state.auras.player = { wb.aura("Arcane Intellect", 1459, 90) }
end
if m == "brilliance" then
	-- another mage's Brilliance, on a client where its name isn't English; not learned here
	wb.state.spells[23028] = "Brillance des Arcanes"
	wb.state.known[23028] = false
	wb.state.auras.player = { wb.aura("Brillance des Arcanes", 23028, 3600), wb.aura("Frost Armor", 168, 1800) }
end
local db = {}
if m == "magearmor" then db.armorChoice = "Mage" end
if m == "buffed" then
	wb.state.auras.player = { wb.aura("Arcane Intellect", 1459, 1800), wb.aura("Frost Armor", 168, 1800) }
end
wb.login({ saved = { ChronoboundDB = db } })
wb.advance(7)
local ai, ar = wb.shown("ChronoboundIntellectFrame"), wb.shown("ChronoboundArmorFrame")
if m == "gifted" then
	wb.advance(30)
	wb.expect("no countdown warning for a spell not known", wb.printed("Arcane Intellect: %d+ min left"), nil)
end
if m == "fresh" or m == "buffed" or m == "brilliance" or m == "gifted" then
	wb.expect("no intellect card", ai, false)
	wb.expect("no armor card", ar, false)
else
	wb.expect("intellect card when missing", ai, true)
	wb.expect("armor card when missing", ar, true)
	wb.check(T.macroFor("Arcane Intellect"), "clicking the intellect card casts Arcane Intellect")
	local armor = ({ lowlevel = "Frost Armor", combat = "Frost Armor", ice = "Ice Armor", magearmor = "Mage Armor" })[m]
	wb.expect("armor card names the right spell", wb.frame("ChronoboundArmorFrame").titleText:GetText(), armor)
	wb.check(T.macroFor(armor), "and casts it")
end
if m == "combat" then
	wb.combat(true)
	wb.advance(2)
	wb.expect("card stays while fighting", wb.shown("ChronoboundIntellectFrame"), true)
	wb.combat(false)
	wb.advance(1)
	wb.check(T.macroFor("Arcane Intellect"), "the card is clickable again after combat")
	wb.setAuras({ wb.aura("Arcane Intellect", 1459, 1800) })
	wb.advance(2)
	wb.expect("gone once the buff is up", wb.shown("ChronoboundIntellectFrame"), false)
end
