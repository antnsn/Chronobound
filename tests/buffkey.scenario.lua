--@moods: group buffed low
-- the buff key (LibBound): with your own buffs up, Arcane Intellect for the party member missing it
local T = dofile(wb.dir .. "/tests/_mage.lua")
T.mage(wb.mood == "low" and { 1459, 1460, 10157, 168 } or { 1459, 168 }) -- Arcane Intellect, Frost Armor; no conjure spells
local s = wb.state
local function aura(name) return { name = name, spellId = 1, duration = 1800, expirationTime = 9999999, sourceUnit = "player" } end
s.auras.player = { aura("Arcane Intellect"), aura("Frost Armor") }
wb.login()
wb.G.UnitCanAssist = function(_, unit) return wb.unit(unit) ~= nil end -- not in the stub
wb.join({ { unit = "party1", name = "Friend", classFile = "WARRIOR", level = wb.mood == "low" and 30 or nil } })
if wb.mood == "buffed" then s.auras.party1 = { aura("Arcane Brilliance") } end
wb.advance(7)
local macro = wb.frame("ChronoboundBuffKey"):GetAttribute("macrotext")
if wb.mood == "low" then
	local key = wb.frame("ChronoboundBuffKey")
	wb.expect("a level 30: rank 2 (level 14), rank 5 (56) is too high", key:GetAttribute("spell"), 1460)
	wb.expect("cast by spell ID", key:GetAttribute("type"), "spell")
elseif wb.mood == "group" then
	wb.expect("Arcane Intellect on the party member", macro, "/cast [nocombat,@party1] Arcane Intellect")
else
	wb.expect("Arcane Brilliance counts", macro, "")
end
