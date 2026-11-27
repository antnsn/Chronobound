-- Decurse (LibBound Cleanse.lua): group members carrying a debuff you can remove, one click each
-- (Remove Lesser Curse on a click), plus a mouseover key for each. The frame, the options page and
-- `/cb ignore` are LibBound's.
local _, ns = ...
if ns.disabled then return end
local Bound = LibStub("LibBound-1.0")
local D = ns.DATA

Bound.InstallCleanse(ns, {
	title = "Decurse",
	page = false, -- Options.lua puts it after its own pages
	buttons = {
		{ list = D.removeCurse, types = { Curse = true } },
	},
})
