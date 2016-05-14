-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("650523807")
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

EQUIP_LUCKY_HORSESHOE = getNextFreeID()

local luckyHorseshoe = {
	id = EQUIP_LUCKY_HORSESHOE,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_lucky_horseshoe",
	name = "Lucky Horseshoe",
	desc = "Reduces your fall damage by 90%\nbut you get a maximum of 75 damage.",
	hud = true
}

local detectiveCanUse = CreateConVar("ttt_luckyhorseshoe_det", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Detective be able to use the Lucky Horseshoe.")
local traitorCanUse = CreateConVar("ttt_luckyhorseshoe_tr", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Traitor be able to use the Lucky Horseshoe.")

if (detectiveCanUse:GetBool()) then
	table.insert(EquipmentItems[ROLE_DETECTIVE], luckyHorseshoe)
end
if (traitorCanUse:GetBool()) then
	table.insert(EquipmentItems[ROLE_TRAITOR], luckyHorseshoe)
end

if SERVER then
	hook.Add("EntityTakeDamage", "TTTLuckyHorseshoe", function(ent, dmginfo)
		if (IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() and ent:HasEquipmentItem(EQUIP_LUCKY_HORSESHOE)) then
			dmginfo:ScaleDamage(0.10) -- decrease damage by 90%
			if (dmginfo:GetDamage() > 75) then
				dmginfo:SetDamage(75)
			end
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
	hook.Add("TTTBoughtItem", "TTTLuckyHorseshoe", function()
		yCoordinate = getYCoordinate(EQUIP_LUCKY_HORSESHOE)
	end)

	hook.Add("TTTBeginRound", "TTTLuckyHorseshoe", function()
		yCoordinate = defaultY
	end)

	local material = Material("vgui/ttt/perks/lucky_horseshoe_hud.png")
	hook.Add("HUDPaint", "TTTLuckyHorseshoe", function()
		if (LocalPlayer():HasEquipmentItem(EQUIP_LUCKY_HORSESHOE)) then
			surface.SetMaterial(material)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(20, yCoordinate, 64, 64)
		end
	end)
end
