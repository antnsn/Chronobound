-- Every plain-word explanation in one place (tooltips show them while "Explain things" is on).
-- Written for someone new to WoW: what it is, why it matters, what to do.
local _, ns = ...
if ns.disabled then return end

ns.Help = {
	intellect = "Arcane Intellect raises your Intellect, so you have more mana for spells. It lasts half an hour: keep it on all the time.",
	armor = "Your armor spell (Frost Armor, later Ice Armor, or Mage Armor) protects you. Frost and Ice Armor also slow enemies that hit you. Keep one on all the time.",
	water = "Mages make their own water. Drinking it brings your mana back after a fight, so you never have to buy any.",
	food = "Mages make their own food too. Eating it brings your health back after a fight.",
	newRank = "You have learned a better rank: new food or water brings back more. Conjure fresh and throw the old away when you need the space.",
	teleport = "A teleport takes you to that city in a few seconds. It uses one Rune of Teleportation, sold by reagent vendors.",
	portal = "A portal opens a gate for you and your group to that city. It uses one Rune of Portals.",
	hearthstone = "Your Hearthstone takes you back to the inn you set it to. Talk to an innkeeper to change it.",
	runes = "Runes for teleports and portals are sold by reagent vendors in the big cities.",
}
