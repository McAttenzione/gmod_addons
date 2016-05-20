include('shared.lua')

LANG.AddToLanguage("english", "hermes_boots_name", "Hermes Boots")
LANG.AddToLanguage("english", "hermes_boots_desc", "Increases your movement speed.")

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
hook.Add("TTTBoughtItem", "TTTHermesBoots", function()
	if (LocalPlayer():HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
		yCoordinate = getYCoordinate(EQUIP_HERMES_BOOTS)
	end
end)

-- draw the HUD icon
local material = Material("vgui/ttt/perks/hermes_boots_hud.png")
hook.Add("HUDPaint", "TTTHermesBoots", function()
	if (LocalPlayer():HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
		surface.SetMaterial(material)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(20, yCoordinate, 64, 64)
	end
end)
