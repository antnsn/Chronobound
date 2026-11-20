--@moods: fresh low empty enough newrank combat
local T = dofile(wb.dir .. "/tests/_mage.lua")
local m = wb.mood
T.mage(m == "fresh" and {} or (m == "newrank" and { 5504, 5505 } or { 5504, 587 }))
local bags = wb.state.bags
if m == "low" or m == "combat" then bags[5350] = 3 end
if m == "enough" then bags[5350] = 20; bags[5349] = 20 end
if m == "newrank" then bags[5350] = 20 end
wb.login()
wb.advance(7)
local water = wb.frame("ChronoboundWaterFrame")
if m == "fresh" then
	wb.expect("no card before the spell is known", wb.shown("ChronoboundWaterFrame"), false)
elseif m == "low" then
	wb.expect("water card when low", wb.shown("ChronoboundWaterFrame"), true)
	wb.expect("count in the status", water.statusText:GetText(), "3 Conjured Water left")
	wb.check(T.macroFor("Conjure Water"), "clicking conjures water")
	bags[5350] = 20
	wb.fire("BAG_UPDATE_DELAYED")
	wb.expect("gone after conjuring", wb.shown("ChronoboundWaterFrame"), false)
elseif m == "empty" then
	wb.expect("no water: card", wb.shown("ChronoboundWaterFrame"), true)
	wb.expect("says none left", water.statusText:GetText(), "No water left")
	wb.expect("food card too", wb.shown("ChronoboundFoodFrame"), true)
elseif m == "enough" then
	wb.expect("plenty: no water card", wb.shown("ChronoboundWaterFrame"), false)
	wb.expect("plenty: no food card", wb.shown("ChronoboundFoodFrame"), false)
elseif m == "newrank" then
	wb.expect("old rank only: a calm card", wb.shown("ChronoboundWaterFrame"), true)
	wb.expect("says a better rank is known", water.statusText:GetText(), "A better rank is known")
	wb.expect("and doesn't glow", water.IsGlowing(), false)
	bags[2288] = 10
	wb.fire("BAG_UPDATE_DELAYED")
	wb.expect("gone once the new rank is made", wb.shown("ChronoboundWaterFrame"), false)
elseif m == "combat" then
	wb.expect("low: card", wb.shown("ChronoboundWaterFrame"), true)
	wb.combat(true)
	wb.expect("quiet in combat", wb.shown("ChronoboundWaterFrame"), false)
	wb.combat(false)
	wb.expect("back after", wb.shown("ChronoboundWaterFrame"), true)
end
