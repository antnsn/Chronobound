--@moods: group buffed
-- the buff key (LibBound): with your own buffs up, Arcane Intellect for the party member missing it
local T = dofile(wb.dir .. "/tests/_mage.lua")
T.mage({ 1459, 168 }) -- Arcane Intellect, Frost Armor; no conjure spells, so no conjure card
local s = wb.state
local function aura(name) return { name = name, spellId = 1, duration = 1800, expirationTime = 9999999, sourceUnit = "player" } end
s.auras.player = { aura("Arcane Intellect"), aura("Frost Armor") }
wb.login()
wb.G.UnitCanAssist = function(_, unit) return wb.unit(unit) ~= nil end -- not in the stub
wb.join({ { unit = "party1", name = "Friend", classFile = "WARRIOR" } })
if wb.mood == "buffed" then s.auras.party1 = { aura("Arcane Brilliance") } end
wb.advance(7)
local macro = wb.frame("ChronoboundBuffKey"):GetAttribute("macrotext")
if wb.mood == "group" then
	wb.expect("Arcane Intellect on the party member", macro, "/cast [nocombat,@party1] Arcane Intellect")
else
	wb.expect("Arcane Brilliance counts", macro, "")
end
