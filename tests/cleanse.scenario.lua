--@moods: first none keys
-- Decurse (LibBound Cleanse.lua): a group member with a debuff this class removes gets a row that
-- casts on them, a key per spell. The stand-in client has no SecureGroupHeader: the frame is the list.
local T = dofile(wb.dir .. "/tests/_mage.lua")
local m = wb.mood
local known = { 475 }
if m == "none" then known = {} end
T.mage(known)
local s = wb.state
wb.login()
local G = wb.G
local bound = {}
G.SetOverrideBindingClick = function(owner, prio, key, button) bound[key] = button end
G.ClearOverrideBindings = function() bound = {} end
wb.join({ { unit = "party1", name = "Friend", classFile = "WARRIOR" } })
local second = nil
s.auras.party1 = { (m == "second" or m == "abolish") and second or { name = "Bad Curse", spellId = 111, dispelName = "Curse", icon = 136139 } }
wb.fire("UNIT_AURA", "party1")
wb.advance(2)
if m == "none" then
	wb.check(not wb.shown("ChronoboundCleanseFrame"), "no spell to remove debuffs yet: no frame")
	return
end
local row = wb.frame("ChronoboundCleanseRow1")
wb.check(row ~= nil and row.data ~= nil, "the afflicted member gets a row")
wb.expect("on them", row:GetAttribute("unit"), "party1")
wb.expect("left click: Remove Lesser Curse", row:GetAttribute("spell1"), "Remove Lesser Curse")
if m == "first" then
	wb.expect("as a spell", row:GetAttribute("type1"), "spell")
elseif m == "keys" then
	wb.ns.db.clKey, wb.ns.db.clKey2 = "F", "G"
	wb.ns.ApplyCleanseKey()
	wb.expect("F: the first key", bound.F, "ChronoboundCleanseKeyButton")
	wb.expect("which casts on the mouseover", wb.frame("ChronoboundCleanseKeyButton"):GetAttribute("macrotext"),
		"/cast [@mouseover,help,nodead][help,nodead] Remove Lesser Curse")
	wb.slash("/cb")
	local page
	for _, p in ipairs(wb.ns.optionsState.pages) do if p.title == "Decurse" then page = p.frame end end
	wb.check(page and -page.cleanseBottom <= page:GetHeight(), "the Decurse page fits: " .. tostring(page and page.cleanseBottom))
	wb.slash("/cb ignore Bad Curse")
	wb.check(wb.ns.db.clIgnore["bad curse"], "/cb ignore keeps a debuff name")
end
