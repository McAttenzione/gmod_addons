-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

-- co-author :"FloTurtle"
-- contact "https://steamcommunity.com/profiles/76561198114511249"

include('shared.lua')

LANG.AddToLanguage("english", "juggernaut_suit_name", "Juggernaut Suit")
LANG.AddToLanguage("english", "juggernaut_suit_desc", "Reduces explosion damage by 80%,\nbut you get a maximum of 50 damage,\nit further reduces all elemental damage\nand your movement speed.")

-- feel for to use this function for your own perk, but please credit me
-- your perk needs a "hud = true" in the table, to work properly
local defaultY = ScrH() / 2 + 20
local function getYCoordinate(currentPerkID)
	local amount, i, perk = 0, 1
	while (i < currentPerkID) do
		perk = GetEquipmentItem(LocalPlayer():GetRole(), i)
		if (istable(perk) and perk.hud and LocalPlayer():HasEquipmentItem(perk.id)) then
			amount = amount + 1
		end
		i = i * 2
	end

	return defaultY - 80 * amount
end

local yCoordinate = defaultY
-- best performance, but the has about 0.5 seconds delay to the HasEquipmentItem() function
hook.Add("TTTBoughtItem", "TTTJuggernautSuit", function()
	if (LocalPlayer():HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
		yCoordinate = getYCoordinate(EQUIP_JUGGERNAUT_SUIT)
	end
end)

-- draw the HUD icon
local material = Material("vgui/ttt/perks/juggernaut_suit_hud.png")
hook.Add("HUDPaint", "TTTJuggernautSuit", function()
	if (LocalPlayer():HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
		surface.SetMaterial(material)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(20, yCoordinate, 64, 64)
	end
end)
