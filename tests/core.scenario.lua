--@moods: mage warrior combatreload
local T = dofile(wb.dir .. "/tests/_mage.lua")
if wb.mood == "mage" then
	T.mage({ 1459, 168 })
	wb.login()
	wb.advance(7)
	wb.slash("/cb")
	wb.check(wb.shown("ChronoboundOptions"), "/cb opens the options")
	wb.slash("/cbunlock")
	wb.expect("space-free alias unlocks", wb.ns.unlocked, true)
	wb.check(wb.shown("ChronoboundIntellectFrame"), "unlocked: every card shows to be placed")
	wb.slash("/cb lock")
	wb.expect("and locks again", wb.ns.unlocked, false)
	wb.slash("/cb help")
	wb.check(wb.printed("/cb reset"), "help lists the commands")
elseif wb.mood == "combatreload" then
	T.mage({ 1459, 168, 5504 })
	wb.login()
	wb.advance(7)
	wb.combat(true)
	wb.reload() -- a /reload in the middle of a fight
	wb.advance(2)
	wb.expect("no cards built while still fighting", wb.frame("ChronoboundWaterFrame"), nil)
	wb.combat(false)
	wb.advance(7)
	wb.expect("the water card is there after the fight", wb.shown("ChronoboundWaterFrame"), true)
else
	wb.state.player.classFile, wb.state.player.class = "WARRIOR", "Warrior"
	wb.login()
	wb.slash("/cb")
	wb.check(wb.printed("only does something on a mage"), "a warrior is told why")
	local any = false
	for _, f in ipairs(wb.frames()) do if f.__name and f.__name:find("^Chronobound") then any = true end end
	wb.expect("no Chronobound frames on a warrior", any, false)
	wb.check(wb.printed("%[addon%] disabled Chronobound"), "unticked for this character")
end
