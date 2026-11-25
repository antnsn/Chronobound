--@moods: horde noportal combat secret alliance
-- The portal service (LibBound Service.lua): announce in Trade, alerts with [Invite]/[Whisper].
local T = dofile(wb.dir .. "/tests/_mage.lua")
local m = wb.mood
T.mage(m == "noportal" and {} or m == "alliance" and { 3561, 10059 } or { 3567, 11417, 3563, 11418 })
wb.state.player.faction = m == "alliance" and "Alliance" or "Horde"
wb.state.bags[17032] = 5
wb.login()
wb.advance(2)
local G = wb.G
local me = G.UnitName("player")
local channels = { 2, "Trade - City", false }
rawset(G, "GetChannelList", function() return unpack(channels) end)
local invited = {}
rawset(G, "C_PartyInfo", { InviteUnit = function(n) invited[#invited + 1] = n end })
local function Sent(kind)
	local out = {}
	for _, c in ipairs(wb.chat) do if not c.addon and (not kind or c.kind == kind) then out[#out + 1] = c end end
	return out
end
local function Lines(pat) local n = 0 for _, l in ipairs(wb.log) do if l:find(pat, 1, true) then n = n + 1 end end return n end
local function Trade(text, who) wb.fire("CHAT_MSG_CHANNEL", text, who, "", "2. Trade - City", "", "", 2, 2, "Trade - City") end

local db = wb.saved("ChronoboundDB")
wb.expect("example message by default", db.serviceMessage, 'Portals to {portals}! Whisper "port {short}", tips welcome :)')
wb.expect("auto-whisper off by default", db.serviceAutoWhisper, false)

if m == "alliance" then
	wb.slash("/cb announce")
	local p = Sent("CHANNEL")[1]
	wb.expect("Alliance: its own cities", p and p.msg, 'Portals to Stormwind! Whisper "port sw", tips welcome :)')
	Trade("anyone know if the quest is bugged?", "Anduin")
	wb.expect("Alliance: 'if' is not Ironforge", Lines("[Invite]"), 0)
	Trade("wtb port sw", "Varian")
	wb.expect("Alliance: a request", Lines("[Invite]"), 1)
	return
end
if m == "noportal" then
	wb.slash("/cb announce")
	wb.check(wb.printed("You know no portals yet"), "no portals: says why")
	wb.expect("no portals: nothing posted", #Sent(), 0)
	return
end

-- a send the client refuses: said, and no wait before the next try
rawset(G.C_ChatInfo, "SendChatMessage", function() error("blocked") end)
wb.slash("/cb announce")
wb.check(wb.printed("Could not post"), "a refused post: says so")
rawset(G.C_ChatInfo, "SendChatMessage", nil)

-- announce
wb.slash("/cb announce")
local posts = Sent("CHANNEL")
wb.expect("one post", #posts, 1)
wb.expect("filled message", posts[1] and posts[1].msg, 'Portals to Orgrimmar, Undercity! Whisper "port org/uc", tips welcome :)')
wb.expect("to the Trade channel", posts[1] and posts[1].target, 2)
wb.advance(10)
wb.slash("/cb announce")
wb.expect("not again within the interval", #Sent("CHANNEL"), 1)
wb.check(wb.printed("Wait %d+ s"), "says how long to wait")
wb.advance(60)
channels = {}
wb.slash("/cb announce")
wb.check(wb.printed("no Trade channel"), "outside a city: says so")
wb.expect("outside a city: nothing posted", #Sent("CHANNEL"), 1)
channels = { 2, "Trade - City", false }
db.serviceMessage = "   "
wb.slash("/cb announce")
wb.check(wb.printed("Your message is empty"), "empty message: says so")
wb.expect("empty message: nothing posted", #Sent("CHANNEL"), 1)
db.serviceMessage = nil -- back to the example on the next read
wb.slash("/cb announce")
wb.expect("an unset message uses the example", #Sent("CHANNEL"), 2)

-- listen
if m == "combat" then wb.combat(true) end
if m == "secret" then
	Trade(wb.SECRET, "Thrall-Ashborne")
	Trade("wtb port org", wb.SECRET)
	wb.expect("secret text or sender: no line", Lines("[Invite]"), 0)
end
Trade("wtb port org", "Thrall-Ashborne")
wb.expect("a request: one line", Lines("[Invite]"), 1)
wb.check(wb.printed("Thrall%-Ashborne"), "the line names the sender")
Trade("wtb port org pls", "Thrall-Ashborne")
wb.expect("same sender within 60 s: no second line", Lines("[Invite]"), 1)
Trade("wtb port uc", me)
wb.expect("own message: no line", Lines("[Invite]"), 1)
Trade("going to org later", "Garrosh")
wb.expect("chatter: no line", Lines("[Invite]"), 1)
Trade("WTS portals to Org/UC/TB, tips welcome", "Jaina")
wb.expect("a rival's ad: no line", Lines("[Invite]"), 1)
wb.fire("CHAT_MSG_WHISPER", "uc", "Sylvanas", "", "", "", "", 0, 0, "")
wb.expect("a whispered city: a line", Lines("[Invite]"), 2)
Trade("need a port pls", "Rexxar")
wb.expect("'need a port pls': a line", Lines("[Invite]"), 3)
Trade("lol port", "Rokhan")
wb.expect("'lol port': no line", Lines("[Invite]"), 3)

-- links
wb.expect("invite link handled", G.LibStub("LibBound-1.0").ServiceLink("addon:bound:Chronobound:invite:Ståle-Ashborne"), true)
wb.expect("invites the full name", invited[1], "Ståle-Ashborne")
wb.expect("another addon's link is not ours", G.LibStub("LibBound-1.0").ServiceLink("addon:bound:Shadowbound:invite:X"), false)
wb.expect("auto-whisper off: no whisper", #Sent("WHISPER"), 0)

-- auto-whisper
db.serviceAutoWhisper = true
Trade("any portal to org?", "Baine")
if m == "combat" then
	wb.expect("in combat: no auto-whisper", #Sent("WHISPER"), 0)
else
	local w = Sent("WHISPER")
	wb.expect("auto-whisper once", #w, 1)
	wb.expect("to the sender", w[1] and w[1].target, "Baine")
	wb.check(w[1] and w[1].msg:find("Hi Baine! Inviting you for a portal to Orgrimmar", 1, true), "reply filled")
	wb.advance(120)
	Trade("any portal to org??", "Baine")
	wb.expect("not again within 10 minutes", #Sent("WHISPER"), 1)
end

-- the options page: the message box saves into the settings
if m == "horde" then
	wb.slash("/cb")
	local box
	for _, f in ipairs(wb.frames()) do
		if f:GetObjectType() == "EditBox" and f:GetText() == wb.ns.ServiceMessage() then box = f end
	end
	wb.check(box, "the message box shows the message")
	if box then
		box:SetText("Portals {portals} here")
		box.__scripts.OnEditFocusLost(box)
		wb.expect("the box saves", db.serviceMessage, "Portals {portals} here")
		box:SetText("")
		box.__scripts.OnEditFocusLost(box)
		wb.expect("an empty box goes back to the example", db.serviceMessage, nil)
		local function Btn(label)
			for _, f in ipairs(wb.frames()) do
				if f:GetObjectType() == "Button" and f:GetText() == label then return f end
			end
		end
		wb.advance(120)
		box:SetText("Fresh {portals}") -- typed, still focused (not saved yet)
		local now = Btn("Announce now")
		wb.check(now, "an Announce now button")
		if now then now.__scripts.OnClick(now) end
		local posts2 = Sent("CHANNEL")
		wb.expect("Announce now posts the text in the box", posts2[#posts2].msg, "Fresh Orgrimmar, Undercity")
		box:SetText("junk")
		local reset = Btn("Reset to example")
		if reset then reset.__scripts.OnClick(reset) end
		box.__scripts.OnEditFocusLost(box) -- the click takes the focus away afterwards
		wb.expect("Reset to example wins over the typed text", db.serviceMessage == nil or db.serviceMessage == wb.ns.service.example, true)
		wb.expect("the box shows the example", box:GetText(), wb.ns.service.example)
	end
end
