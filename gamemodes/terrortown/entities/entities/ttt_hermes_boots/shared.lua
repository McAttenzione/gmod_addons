-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

CreateConVar("ttt_hermesboots_detective", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Detectives be able to buy the Hermes Boots?")
CreateConVar("ttt_hermesboots_traitor", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Traitors be able to buy the Hermes Boots?")

EQUIP_HERMES_BOOTS = GenerateNewEquipmentID()

local perk = {
	id = EQUIP_HERMES_BOOTS,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_hermes_boots",
	name = "hermes_boots_name",
	desc = "hermes_boots_desc",
	hud = true
}

if (GetConVar("ttt_hermesboots_detective"):GetBool()) then
	if SERVER then
		perk["loadout"] = GetConVar("ttt_hermesboots_detective_loadout"):GetBool()
	end
	table.insert(EquipmentItems[ROLE_DETECTIVE], perk)
end
if (GetConVar("ttt_hermesboots_traitor"):GetBool()) then
	if SERVER then
		perk["loadout"] = GetConVar("ttt_hermesboots_traitor_loadout"):GetBool()
	end
	table.insert(EquipmentItems[ROLE_TRAITOR], perk)
end
