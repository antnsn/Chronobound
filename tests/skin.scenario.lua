--@moods: frost blizzard flat
local T = dofile(wb.dir .. "/tests/_mage.lua")
T.mage({ 1459 })
wb.login({ saved = { ChronoboundDB = { skin = wb.mood } } })
wb.advance(7)
local want = ({ frost = "Frost crystal", blizzard = "Blizzard", flat = "Flat" })[wb.mood]
wb.expect("active skin", wb.ns.UI.Active().name, want)
wb.check(wb.shown("ChronoboundIntellectFrame"), "a card builds in this skin")
wb.slash("/cb")
wb.check(wb.shown("ChronoboundOptions"), "the options build in this skin")
