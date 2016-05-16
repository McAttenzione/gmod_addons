-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("652046425") -- this addon
	resource.AddWorkshop("620977303") -- Blacklight Heavy Playermodel
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

EQUIP_JUGGERNAUT_SUIT = getNextFreeID()

local juggernautSuit = {
	id = EQUIP_JUGGERNAUT_SUIT,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_juggernaut_suit",
	name = "Juggernaut Suit",
	desc = "Reduces explosion damage by 80%,\nbut you get a maximum of 50 damage,\nit further reduces fire damage by 65%\nand your movement speed by 25%.",
	hud = true
}

local detectiveCanUse = CreateConVar("ttt_juggernautsuit_det", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Detective be able to use the Juggernaut Suit.")
local traitorCanUse = CreateConVar("ttt_juggernautsuit_tr", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should the Traitor be able to use the Juggernaut Suit.")

if (detectiveCanUse:GetBool()) then
	table.insert(EquipmentItems[ROLE_DETECTIVE], juggernautSuit)
end
if (traitorCanUse:GetBool()) then
	table.insert(EquipmentItems[ROLE_TRAITOR], juggernautSuit)
end

if SERVER then
	hook.Add("EntityTakeDamage", "TTTJuggernautSuit", function(ent, dmginfo)
		if (IsValid(ent) and ent:IsPlayer() and ent:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			if (dmginfo:IsExplosionDamage()) then
				dmginfo:ScaleDamage(0.20)
				if (dmginfo:GetDamage() > 50) then
					dmginfo:SetDamage(50)
				end
			elseif (dmginfo:IsDamageType(DMG_BURN)) then
				dmginfo:ScaleDamage(0.35)
			end
		end
	end)

	hook.Add("TTTPlayerSpeed", "TTTJuggernautSuit", function(ply)
		if (IsValid(ply) and ply:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			if (EQUIP_HERMES_BOOTS and ply:HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
				return 1.05 -- 5% increase with hermes boots
			else
				return 0.75 -- 25% decrease
			end
		end
	end)

	local model = Model("models/player/zaratusa/juggernaut_suit/blheavysoldier.mdl")
	hook.Add("TTTOrderedEquipment", "TTTJuggernautSuit", function(ply, equipment, isItem)
		if (equipment == EQUIP_JUGGERNAUT_SUIT) then
			ply:SetModel(model)
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
	-- best performance, but the has about 0.5 seconds delay to the HasEquipmentItem() function
	hook.Add("TTTBoughtItem", "TTTJuggernautSuit", function()
		if (LocalPlayer():HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			yCoordinate = getYCoordinate(EQUIP_JUGGERNAUT_SUIT)
		end
	end)

	local material = Material("vgui/ttt/perks/juggernaut_suit_hud.png")
	hook.Add("HUDPaint", "TTTJuggernautSuit", function()
		if (LocalPlayer():HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			surface.SetMaterial(material)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(20, yCoordinate, 64, 64)
		end
	end)
end
