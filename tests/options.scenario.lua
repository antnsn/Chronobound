local T = dofile(wb.dir .. "/tests/_mage.lua")
T.mage({ 1459, 168, 5504 })
wb.login()
wb.advance(7)
wb.slash("/cb")
wb.check(wb.shown("ChronoboundOptions"), "options open")
local titles = {}
for _, p in ipairs(wb.ns.optionsState.pages) do titles[#titles + 1] = p.title end
wb.expect("pages", table.concat(titles, ", "), "Buffs, Food & water, Travel, Portal service, Extras, Skin")
-- explanations: the card's tooltip carries the plain-word help while explain is on
local card = wb.frame("ChronoboundWaterFrame")
card.__scripts.OnEnter(card)
local tip = table.concat(wb.G.GameTooltip.__lines or {}, " | ")
wb.check(tip:find("Mages make their own water", 1, true), "explanation in the tooltip")
wb.slash("/cb explain")
wb.G.GameTooltip.__lines = {}
card.__scripts.OnEnter(card)
wb.expect("no tooltip with explanations off", #(wb.G.GameTooltip.__lines or {}), 0)
wb.ns.db.waterLow = 12
wb.reload()
wb.expect("settings survive /reload", wb.saved("ChronoboundDB").waterLow, 12)
wb.expect("explain off survives too", wb.saved("ChronoboundDB").explain, false)
-- unlock and lock: the explanation tooltip still works afterwards
wb.ns.db.explain = true
wb.slash("/cb unlock")
wb.slash("/cb lock")
local rested = wb.frame("ChronoboundWellRestedFrame")
wb.check(rested.__motion ~= false, "cards keep mouse-over after locking")
