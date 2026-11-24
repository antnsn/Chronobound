--@moods: top bottom empty combat instance off
-- Carrot on a Stick (LibBound's Carrot.lua): on while mounted, the own trinket back afterwards.
local T = dofile(wb.dir .. "/tests/_mage.lua")
T.mage({ 1459, 168, 5504 })
local mood, s = wb.mood, wb.state
local TRINKET = 270225
local slot = mood == "bottom" and 14 or 13
if mood ~= "empty" then s.slots[slot] = TRINKET end
s.bags[11122] = 1
local db = { carrotSwap = mood ~= "off", carrotSlot = mood == "bottom" and "Bottom" or "Top" }
if mood == "instance" then s.instance = { inside = true, kind = "party", name = "Deadmines" } end
wb.login({ saved = { ChronoboundDB = db } })
wb.advance(7)
-- taking the carrot off into the backpack (the stubs do nothing)
local held
rawset(wb.G, "PickupInventoryItem", function(id) held = id end)
rawset(wb.G, "PutItemInBackpack", function() if held then s.slots[held] = nil; held = nil end end)

local function ride(on)
	wb.mount(on)
	wb.setAuras(on and { wb.aura("Swift Horse", 23229) } or {})
	wb.advance(1)
end

local own = mood ~= "empty" and TRINKET or nil
if mood == "combat" then wb.combat(true) end
ride(true)
local stays = mood == "off" or mood == "instance" or mood == "combat"
wb.expect("carrot on", s.slots[slot], stays and own or 11122)
if mood == "combat" then
	wb.combat(false)
	wb.advance(1)
	wb.expect("carrot on after the fight", s.slots[slot], 11122)
end
ride(false)
wb.expect("own trinket back", s.slots[slot], own)

-- the Extras page has the section and still fits in the window
wb.slash("/cb")
local extras
for _, p in ipairs(wb.ns.optionsState.pages) do if p.title == "Extras" then extras = p.frame end end
wb.check(extras, "Extras page")
-- the page is 494 px high; keep room: wowbench counts every note as one line, in game the buff key note takes two
wb.check(-extras.y <= 470, "Extras page fits: " .. -extras.y .. " of 494 px")
