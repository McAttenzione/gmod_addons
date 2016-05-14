-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("650523765")
end

-- feel for to use this function for your own perk, but please credit me
local function getNextFreeID()
	local freeID, i = 1, 1
	while (freeID == 1) do
		if (!istable(GetEquipmentItem(ROLE_DETECTIVE, i))
			and !istable(GetEquipmentItem(ROLE_TRAITOR, i))) then
			freeID = i
		end
		i = i * 2
	end

	return freeID
end

EQUIP_HERMES_BOOTS = getNextFreeID()

local hermesBoots = {
	id = EQUIP_HERMES_BOOTS,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_hermes_boots",
	name = "Hermes Boots",
	desc = "Increases your movement speed by 30%.",
	hud = true
}

local detectiveCanUse = CreateConVar("ttt_hermesboots_det", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Detective be able to use the Hermes Boots.")
local traitorCanUse = CreateConVar("ttt_hermesboots_tr", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Traitor be able to use the Hermes Boots.")

if (detectiveCanUse:GetBool()) then
	table.insert(EquipmentItems[ROLE_DETECTIVE], hermesBoots)
end
if (traitorCanUse:GetBool()) then
	table.insert(EquipmentItems[ROLE_TRAITOR], hermesBoots)
end

if SERVER then
	hook.Add("TTTPlayerSpeed", "TTTHermesBoots", function(ply)
		if (IsValid(ply) and ply:HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
			return 1.3 -- 30% increase
		end
	end)
else
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
	hook.Add("TTTBoughtItem", "TTTHermesBoots", function()
		yCoordinate = getYCoordinate(EQUIP_HERMES_BOOTS)
	end)

	hook.Add("TTTBeginRound", "TTTHermesBoots", function()
		yCoordinate = defaultY
	end)

	local material = Material("vgui/ttt/perks/hermes_boots_hud.png")
	hook.Add("HUDPaint", "TTTHermesBoots", function()
		if (LocalPlayer():HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
			surface.SetMaterial(material)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(20, yCoordinate, 64, 64)
		end
	end)
end
