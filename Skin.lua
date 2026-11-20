-- Chronobound's look, "Frost crystal": dark ice-blue panels, frosted glass, crystal shards in the
-- corners, a cold white rim that breathes slowly while a card needs you, pale cyan titles.
-- LibBound derives the Blizzard and Flat skins from it. Textures: tools/make_media.py.
local _, ns = ...
if ns.disabled then return end
local Bound = LibStub("LibBound-1.0")
local F = Bound.FONTS

local frost = {
	name = "Frost crystal",
	font = { ui = F.friz, title = F.friz, narrow = F.arialn, card = F.morpheus },
	color = {
		bg = { 0, 0, 0, 0 },
		side = { 0, 0.02, 0.05, 0.40 },
		header = { 0, 0.02, 0.05, 0.35 },
		border = { 0.36, 0.62, 0.78, 0.9 },
		hover = { 0.10, 0.22, 0.32, 1 },
		selected = { 0.09, 0.20, 0.30, 1 },
		text = { 0.90, 0.96, 1.00 },
		dim = { 0.62, 0.72, 0.80 },
		accent = { 0.62, 0.89, 1.00 },
		track = { 0.08, 0.16, 0.22, 1 },
		button = { 0.04, 0.09, 0.13, 1 },
		navGlow = { 0.45, 0.83, 1, 0.65 },
		row = { 0.06, 0.13, 0.19, 0.8 },
		rowWarn = { 0.40, 0.30, 0.05, 0.5 },
		rowBad = { 0.45, 0.08, 0.10, 0.55 },
		highlight = { 0.75, 0.94, 1, 0.08 },
		cell = { 0.08, 0.14, 0.19, 0.85 },
		cdText = { 0.85, 0.96, 1 },
		glow = { 0.55, 0.86, 1 },
		gridLine = { 0.75, 0.94, 1, 0.08 },
		gridCentre = { 0.45, 0.83, 1, 0.45 },
	},
	box = {
		backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true, tileSize = 16, edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },
		},
		bg = { 0.03, 0.08, 0.12 },
		border = { 0.55, 0.85, 1, 1 },
	},
	dialog = {
		backdrop = {
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 11, right = 11, top = 12, bottom = 11 },
		},
		outset = 10,
		border = { 0.70, 0.88, 1, 1 },
		under = { 0.02, 0.06, 0.09, 1 },
		plate = false,
	},
	tex = Bound.STOCK_TEX,
	card = {
		panel = { 0.05, 0.11, 0.16, 0.93 },
		gilt = { 0.45, 0.72, 0.88, 1 },         -- the outer edge
		giltFaint = { 0.30, 0.52, 0.66, 0.9 },  -- the inner rule
		light = { 0.75, 0.94, 1, 0.08 },
		rays = { 0.80, 0.96, 1 },               -- the breathing rim
		raysFaded = { 0.55, 0.62, 0.68 },
		title = { 0.75, 0.94, 1 },
		status = { 0.84, 0.92, 0.98 },
		urgent = { 1, 0.62, 0.42 },
		glowEdge = { 0.85, 0.97, 1, 1 },
		iconEdge = { 0.62, 0.89, 1, 0.9 },
		frost = "Frost", frostTint = { 0.75, 0.92, 1, 0.10 },
		crest = "Crest", crestTint = { 0.70, 0.88, 1, 0.16 },
		shards = "Shard", shardTint = { 0.80, 0.95, 1, 0.95 },
		rim = "Rim", breathe = true, breatheTime = 2.8,
		burst = false, studs = false, ring = false, round = false,
	},
	widgets = "blizzard",
}

Bound.InstallSkin(ns, {
	skins = { frost = frost },
	order = { "frost", "blizzard", "flat" },
	default = "frost",
	about = { frost = "Ice-blue frosted glass with crystal corners and a slow cold rim." },
})
Bound.InstallBuffTimers(ns)
Bound.InstallMinimap(ns)
