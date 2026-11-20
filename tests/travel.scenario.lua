--@moods: fresh horde alliance combat off
local T = dofile(wb.dir .. "/tests/_mage.lua")
local m = wb.mood
T.mage((m == "fresh" or m == "off") and {} or (m == "alliance" and { 3561, 10059 } or { 3567, 11417 }))
wb.state.player.faction = m == "alliance" and "Alliance" or "Horde"
wb.state.bags[17031], wb.state.bags[17032], wb.state.bags[6948] = 7, 2, 1
wb.state.bind = "Crossroads"
wb.login({ saved = { ChronoboundDB = { travel = m ~= "off" } } })
wb.advance(2)
wb.expect("hidden until Escape", wb.shown("ChronoboundTravel"), false)
if m == "combat" then
	wb.combat(true)
	wb.openGameMenu()
	wb.expect("not in combat: no teleports there, and the menu stays unprotected", wb.shown("ChronoboundTravel"), false)
	wb.combat(false)
	wb.expect("appears once the fight is over", wb.shown("ChronoboundTravel"), true)
else
	wb.openGameMenu()
end
wb.expect("shows with the game menu", wb.shown("ChronoboundTravel"), m ~= "off")
if m == "off" then
	wb.expect("no secure buttons built while it is off", wb.frame("ChronoboundTravelButton1"), nil)
	return
end
wb.check(wb.frame("ChronoboundTravel"):GetParent() == wb.G.UIParent, "the panel is not a child of the game menu")
local rows = wb.ns.TravelRows()
local function Row(city, kind) for _, r in ipairs(rows) do if r.city == city and r.kind == kind then return r end end end
local function Button(spell)
	for _, f in ipairs(wb.frames()) do if f:GetAttribute("spell") == spell and f.__shown then return f end end
end
local panel = wb.frame("ChronoboundTravel")
local function Text(f) return f and f.text and f.text:GetText() end
if m == "horde" or m == "combat" then
	wb.check(Row("Orgrimmar", "teleport").known, "Orgrimmar teleport known")
	wb.check(Button(3567), "a button casts Teleport: Orgrimmar")
	wb.check(Button(11417), "a button casts Portal: Orgrimmar")
	local tb = Row("Thunder Bluff", "teleport")
	wb.expect("Thunder Bluff not learned", tb.known, false)
	wb.expect("its level", tb.level, 30)
	wb.expect("portal level", Row("Thunder Bluff", "portal").level, 50)
	wb.check(not Row("Stormwind", "teleport"), "no Alliance cities for the Horde")
	wb.check(panel.footer:GetText():find("Teleportation 7"), "rune count")
	wb.check(Text(panel.hearth):find("Crossroads"), "hearthstone shows its inn")
	local b = Button(3567)
	b.__scripts.PostClick(b, "LeftButton", true) -- the mouse-down phase: the cast hasn't happened
	wb.advance(0.1)
	if m == "horde" then
		wb.expect("still open after mouse-down", wb.shown("GameMenuFrame"), true)
		b:Click() -- the mouse-up phase casts
		wb.advance(0.1)
		wb.expect("a click closes the menu after the cast", wb.shown("GameMenuFrame"), false)
	end
elseif m == "alliance" then
	wb.check(Button(3561), "Teleport: Stormwind")
	wb.check(Row("Darnassus", "portal") and not Row("Darnassus", "portal").known, "Darnassus portal greyed")
	wb.check(not Row("Orgrimmar", "teleport"), "no Horde cities for the Alliance")
elseif m == "fresh" then
	for _, r in ipairs(rows) do wb.expect(r.city .. " " .. r.kind .. " greyed", r.known, false) end
	wb.expect("no castable buttons", Button(3567), nil)
end
if m == "combat" then
	wb.combat(true)
	wb.ns.db.travel = false
	wb.ns.Refresh() -- the option turned off mid-fight: applied when combat ends
	wb.combat(false)
	wb.expect("turned off after combat", wb.shown("ChronoboundTravel"), false)
end
wb.closeGameMenu()
wb.expect("closes with the menu", wb.shown("ChronoboundTravel"), false)
if m == "horde" then
	wb.openGameMenu()
	wb.combat(true) -- a fight starts with the menu open
	wb.expect("the panel hides when combat starts", wb.shown("ChronoboundTravel"), false)
	wb.combat(false)
end
