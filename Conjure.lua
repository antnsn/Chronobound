-- Conjured food and water: a card when the bags run low, and a calm one when they only hold an
-- older rank than the mage can make; a click conjures the best rank (out of combat). Quiet in combat: the
-- cards hide while fighting and come back after.
local _, ns = ...
if ns.disabled then return end
local D = ns.DATA

local KINDS = {
	{ kind = "water", spells = D.water, items = D.waterItems, low = "waterLow", point = "cwPoint",
		frame = "ChronoboundWaterFrame", title = "Conjure water", noun = "water", icon = 132794 },
	{ kind = "food", spells = D.food, items = D.foodItems, low = "foodLow", point = "cfPoint",
		frame = "ChronoboundFoodFrame", title = "Conjure food", noun = "food", icon = 133952 },
}

local function Count(id)
	local ok, n = pcall(C_Item.GetItemCount, id)
	if ok and not ns.IsSecret(n) then return n or 0 end
	return 0
end

-- total of every rank in the bags, how many of the best rank the mage can make, and the best
-- rank's spell ID and index (nil when no conjure spell is known yet)
function ns.ConjuredCount(kind)
	local k = kind == "food" and KINDS[2] or KINDS[1]
	local total = 0
	for _, id in ipairs(k.items) do total = total + Count(id) end
	local spell, idx = ns.BestRank(k.spells)
	local best = idx and Count(k.items[idx]) or 0
	return total, best, spell, idx
end

local function ItemName(id)
	local ok, n = pcall(C_Item.GetItemNameByID, id)
	return ok and ns.Clean(n) or nil
end

local M = {}
ns.modules[#ns.modules + 1] = M
local cards = {}

local function UpdateKind(k)
	local card = cards[k.kind]
	if not card then return end
	if ns.unlocked then
		card:SetTitle(k.title); card:SetStatus("3 left"); card:Show(); card:Glow(false)
		if not InCombatLockdown() then card.overlay:Sync(nil) end
		return
	end
	local total, best, spell, idx = ns.ConjuredCount(k.kind)
	local show, status, urgent, explain, glow = false, nil, false, ns.Help[k.kind], true
	if ns.db.conjure and spell and not ns.InCombat() then
		if total <= ns.db[k.low] then
			show = true
			local name = ItemName(k.items[idx]) or ("conjured " .. k.noun)
			status = total == 0 and ("No " .. k.noun .. " left") or (total .. " " .. name .. " left")
			urgent = total == 0
		elseif best == 0 then
			-- plenty, but all of an older rank: a calm card (no glow) until the new rank is made
			show, glow = true, false
			status = "A better rank is known"
			explain = ns.Help.newRank
		end
	end
	if show then
		card:SetTitle(k.title)
		card:SetStatus(status, urgent)
		card:SetExplain(explain)
		card:Show(); card:Glow(glow)
	else
		card:Glow(false); card:Hide()
	end
	if not InCombatLockdown() then
		card.overlay:Sync(show and spell and ns.SpellName(spell) or nil, "player", explain)
	end
end

function M:Update()
	for _, k in ipairs(KINDS) do UpdateKind(k) end
end

function M:Init()
	for _, k in ipairs(KINDS) do
		local card = ns.MakeCard(k.frame)
		card:SetIcon(k.icon)
		card:SetTitle(k.title)
		card:SetExplain(ns.Help[k.kind])
		ns.MakeMovable(card, k.point)
		ns.ApplyPoint(card, k.point)
		card.overlay = ns.CastOverlay(card)
		cards[k.kind] = card
	end
	local f = CreateFrame("Frame")
	for _, e in ipairs({ "BAG_UPDATE_DELAYED", "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED",
		"PLAYER_ENTERING_WORLD" }) do f:RegisterEvent(e) end
	f:SetScript("OnEvent", function() M:Update() end)
	M:Update()
end
