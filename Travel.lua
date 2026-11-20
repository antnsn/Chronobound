-- The travel panel: beside the game menu (Escape), the teleports in one column and the portals in
-- the other, for the mage's faction. Click one to cast it; the menu closes. Destinations not
-- learned yet are greyed with the level and where to learn them. Rune counts and the Hearthstone
-- at the bottom. The panel holds secure buttons, so it lives on UIParent (a secure child would
-- make the game menu itself protected and break Escape in combat); it follows the menu out of
-- combat only, which is also the only time a teleport can be cast.
local _, ns = ...
if ns.disabled then return end

local CITIES = {
	Horde = {
		{ city = "Orgrimmar", teleport = 3567, tLevel = 20, portal = 11417, pLevel = 40 },
		{ city = "Undercity", teleport = 3563, tLevel = 20, portal = 11418, pLevel = 40 },
		{ city = "Thunder Bluff", teleport = 3566, tLevel = 30, portal = 11420, pLevel = 50 },
	},
	Alliance = {
		{ city = "Stormwind", teleport = 3561, tLevel = 20, portal = 10059, pLevel = 40 },
		{ city = "Ironforge", teleport = 3562, tLevel = 20, portal = 11416, pLevel = 40 },
		{ city = "Darnassus", teleport = 3565, tLevel = 30, portal = 11419, pLevel = 50 },
	},
}
local RUNE_TELEPORT, RUNE_PORTAL, HEARTHSTONE = 17031, 17032, 6948
local ROW_H, W = 30, 250

local function Known(id)
	local ok, k = pcall(IsPlayerSpell, id)
	return ok and not ns.IsSecret(k) and k and true or false
end
local function Count(id)
	local ok, n = pcall(C_Item.GetItemCount, id)
	return (ok and not ns.IsSecret(n) and n) or 0
end
local function SpellIcon(id)
	local ok, t = pcall(C_Spell.GetSpellTexture, id)
	return ok and ns.Clean(t) or 134400
end

-- the rows for the player's faction: { spell, city, kind, known, level }
function ns.TravelRows()
	local faction = UnitFactionGroup("player")
	local out = {}
	for _, c in ipairs(CITIES[faction] or CITIES.Horde) do
		out[#out + 1] = { spell = c.teleport, city = c.city, kind = "teleport", known = Known(c.teleport), level = c.tLevel }
		out[#out + 1] = { spell = c.portal, city = c.city, kind = "portal", known = Known(c.portal), level = c.pLevel }
	end
	return out
end

local M = {}
ns.modules[#ns.modules + 1] = M
local panel, buttons, dirty = nil, {}, true
local UI

-- buttons take both mouse phases (the secure action fires on the one ActionButtonUseKeyDown
-- picks); the menu closes only after that phase, so it can't hide the button before the cast
local function ActingPhase(down)
	local useDown = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown")
	return (down and useDown) or (not down and not useDown)
end
local function CloseAfter(self, _, down)
	if not ActingPhase(down) then return end
	if self.castable == false then return end
	C_Timer.After(0, function() if not InCombatLockdown() then HideUIPanel(GameMenuFrame) end end)
end

local function Tooltip(self)
	if not self.tip then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tip)
	if self.help and ns.db.explain then GameTooltip:AddLine(self.help, 1, 1, 1, true) end
	if self.note then GameTooltip:AddLine(self.note, 0.6, 0.9, 1, true) end
	GameTooltip:Show()
end

-- a destination: a secure button that casts when known, else a plain greyed frame
local function Destination(i)
	local b = buttons[i]
	if b then return b end
	b = CreateFrame("Button", "ChronoboundTravelButton" .. i, panel, "SecureActionButtonTemplate")
	b:SetSize(W / 2 - 14, ROW_H - 4)
	b:RegisterForClicks("AnyDown", "AnyUp")
	b.icon = b:CreateTexture(nil, "ARTWORK")
	b.icon:SetSize(ROW_H - 6, ROW_H - 6); b.icon:SetPoint("LEFT")
	b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	b.text = UI.Font(b, 12, UI.C.text)
	b.text:SetPoint("LEFT", b.icon, "RIGHT", 6, 4)
	b.text:SetPoint("RIGHT")
	b.text:SetWordWrap(false)
	b.sub = UI.Font(b, 10, UI.C.dim)
	b.sub:SetPoint("TOPLEFT", b.text, "BOTTOMLEFT", 0, -1)
	UI.Highlight(b)
	b:SetScript("OnEnter", Tooltip)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- the cast happens on the click itself; then close the menu like the game's own buttons do
	b:SetScript("PostClick", CloseAfter)
	buttons[i] = b
	return b
end

local function Build()
	if InCombatLockdown() then dirty = true return end
	dirty = false
	if not panel then
		UI = ns.UI
		panel = CreateFrame("Frame", "ChronoboundTravel", UIParent, "BackdropTemplate, SecureHandlerStateTemplate")
		panel:SetWidth(W)
		panel:SetFrameStrata("DIALOG")
		panel:Hide()
		-- combat starting with the menu open: a secure driver hides the panel (Lua can't then)
		panel:SetAttribute("_onstate-cbcombat", [[ if newstate == 1 or newstate == "1" then self:Hide() end ]])
		RegisterStateDriver(panel, "cbcombat", "[combat] 1; 0")
		UI.Box(panel, 0.95)
		panel.title = UI.FrameTitle(panel)
		panel.title:SetPoint("TOPLEFT", 12, -10)
		panel.title:SetText("Travel")
		panel.colT = UI.Font(panel, 10, UI.C.accent); panel.colT:SetPoint("TOPLEFT", 12, -30); panel.colT:SetText("TELEPORT")
		panel.colP = UI.Font(panel, 10, UI.C.accent); panel.colP:SetPoint("TOPLEFT", W / 2 + 4, -30); panel.colP:SetText("PORTAL")
		panel.runes = UI.Font(panel, 11, UI.C.text)
		panel.hearth = CreateFrame("Button", "ChronoboundTravelHearth", panel, "SecureActionButtonTemplate")
		panel.hearth:SetSize(W - 24, ROW_H - 4)
		panel.hearth:RegisterForClicks("AnyDown", "AnyUp")
		panel.hearth.icon = panel.hearth:CreateTexture(nil, "ARTWORK")
		panel.hearth.icon:SetSize(ROW_H - 6, ROW_H - 6); panel.hearth.icon:SetPoint("LEFT")
		panel.hearth.icon:SetTexture(134414)
		panel.hearth.text = UI.Font(panel.hearth, 12, UI.C.text)
		panel.hearth.text:SetPoint("LEFT", panel.hearth.icon, "RIGHT", 6, 0)
		panel.hearth:SetAttribute("type", "item")
		panel.hearth:SetAttribute("item", "item:" .. HEARTHSTONE)
		panel.hearth.tip, panel.hearth.help = "Hearthstone", ns.Help.hearthstone
		UI.Highlight(panel.hearth)
		panel.hearth:SetScript("OnEnter", Tooltip)
		panel.hearth:SetScript("OnLeave", function() GameTooltip:Hide() end)
		panel.hearth:SetScript("PostClick", CloseAfter)
	end
	local rows = ns.TravelRows()
	for i, r in ipairs(rows) do
		local b = Destination(i)
		local line = math.floor((i - 1) / 2)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", panel, "TOPLEFT", r.kind == "teleport" and 12 or (W / 2 + 4), -46 - line * ROW_H)
		b.icon:SetTexture(SpellIcon(r.spell))
		b.text:SetText(r.city)
		b.tip = (r.kind == "teleport" and "Teleport: " or "Portal: ") .. r.city
		b.help = r.kind == "teleport" and ns.Help.teleport or ns.Help.portal
		b.castable = r.known
		if r.known then
			b:SetAttribute("type", "spell")
			b:SetAttribute("spell", r.spell)
			b.icon:SetDesaturated(false); b.icon:SetAlpha(1)
			b.text:SetTextColor(unpack(UI.C.text))
			b.sub:SetText("")
			b.note = "Click to cast."
		else
			b:SetAttribute("type", nil)
			b:SetAttribute("spell", nil)
			b.icon:SetDesaturated(true); b.icon:SetAlpha(0.6)
			b.text:SetTextColor(unpack(UI.C.dim))
			b.sub:SetText("level " .. r.level)
			b.note = ("Learn it at level %d from a mage trainer."):format(r.level)
		end
		b:Show()
	end
	for i = #rows + 1, #buttons do buttons[i]:Hide() end
	M:UpdateCounts()
	local lines = math.ceil(#rows / 2)
	panel.runes:ClearAllPoints()
	panel.runes:SetPoint("TOPLEFT", 12, -50 - lines * ROW_H)
	panel.hearth:ClearAllPoints()
	panel.hearth:SetPoint("TOPLEFT", 12, -70 - lines * ROW_H)
	panel:SetHeight(76 + lines * ROW_H + ROW_H)
end

-- the text-only parts (counts, hearthstone place): safe to change in combat
function M:UpdateCounts()
	if not panel then return end
	local t, p = Count(RUNE_TELEPORT), Count(RUNE_PORTAL)
	local function N(n) return (n < 3 and UI.Hex({ 1, 0.62, 0.42 }) or "") .. n .. "|r" end
	panel.runes:SetText("Runes: Teleportation " .. N(t) .. " · Portals " .. N(p))
	local bind = GetBindLocation and ns.Clean(GetBindLocation()) or nil
	panel.hearth.text:SetText("Hearthstone" .. (bind and (" → " .. bind) or ""))
	if not InCombatLockdown() then panel.hearth:SetShown(Count(HEARTHSTONE) > 0) end
end

-- beside the menu, in UIParent coordinates (no anchor to the menu: it isn't ours to protect)
local function Place()
	local l, _, w, h = GameMenuFrame:GetRect()
	if not l then return end
	local s = GameMenuFrame:GetEffectiveScale() / UIParent:GetEffectiveScale()
	panel:ClearAllPoints()
	panel:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (l + w) * s + 12, (select(2, GameMenuFrame:GetRect()) + h) * s)
end

-- shown only with the menu open, the option on, out of combat
function M:Update()
	if InCombatLockdown() then return end
	if not ns.db.travel or not GameMenuFrame:IsShown() then
		if panel then panel:Hide() end
		return
	end
	if dirty or not panel then Build() end
	if not panel then return end
	Place()
	M:UpdateCounts()
	panel:Show()
end

function M:Init()
	if not GameMenuFrame then return end
	local f = CreateFrame("Frame")
	for _, e in ipairs({ "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED", "BAG_UPDATE_DELAYED", "PLAYER_ENTERING_WORLD" }) do
		f:RegisterEvent(e)
	end
	f:SetScript("OnEvent", function(_, event)
		if event == "BAG_UPDATE_DELAYED" then M:UpdateCounts() return end
		if event ~= "PLAYER_REGEN_ENABLED" then dirty = true end -- spells or zone changed: rebuild
		M:Update() -- also catches up on what combat held back
	end)
	GameMenuFrame:HookScript("OnShow", function() M:Update() end)
	GameMenuFrame:HookScript("OnHide", function() if panel and not InCombatLockdown() then panel:Hide() end end)
	M:Update()
end
