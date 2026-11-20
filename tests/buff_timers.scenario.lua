--@moods: missing off buffed keep secret
-- Well-Rested and Well Fed from LibBound, as in Lightbound's session test.
local T = dofile(wb.dir .. "/tests/_mage.lua")
T.mage({})
local s = wb.state
local db = {}
if wb.mood == "off" then db.wellRested = false db.wellFed = false end
if wb.mood == "keep" then db.wellRestedKeep = true end
if wb.mood == "secret" then s.secret = true end
local base = {}
if wb.mood == "buffed" or wb.mood == "keep" then
	base = { wb.aura("Well-Rested", 429959, 200), wb.aura("Well Fed", 433, 100) }
end
s.auras.player = base
wb.login({ saved = { ChronoboundDB = db } })
wb.advance(7)
local cards = wb.shown("ChronoboundWellRestedFrame") and wb.shown("ChronoboundWellFedFrame")
wb.expect("cards with time left", cards, wb.mood == "buffed" or wb.mood == "keep")
if wb.mood == "buffed" then
	wb.check(wb.frame("ChronoboundWellRestedFrame").statusText:GetText():find("left"), "countdown text")
end
if wb.mood == "keep" then
	wb.setAuras({ base[2] })
	wb.advance(7)
	wb.check(wb.printed("Well%-Rested is gone, rebuff"), "one rebuff reminder")
	local n = 0
	for _, l in ipairs(wb.log) do if l:find("Well%-Rested is gone, rebuff") then n = n + 1 end end
	wb.advance(60)
	local m = 0
	for _, l in ipairs(wb.log) do if l:find("Well%-Rested is gone, rebuff") then m = m + 1 end end
	wb.expect("only once", m, n)
	wb.check(wb.frame("ChronoboundWellRestedFrame").statusText:GetText():find("run out"), "has run out card")
end
if wb.mood == "secret" then
	wb.combat(true)
	wb.setAuras({})
	wb.advance(3)
	wb.combat(false)
	wb.advance(3)
end
