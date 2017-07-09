-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

CreateConVar("ttt_juggernautsuit_detective", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Detectives be able to buy the Juggernaut Suit?")
CreateConVar("ttt_juggernautsuit_traitor", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Traitors be able to buy the Juggernaut Suit?")

EQUIP_JUGGERNAUT_SUIT = GenerateNewEquipmentID()

local perk = {
	id = EQUIP_JUGGERNAUT_SUIT,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_juggernaut_suit",
	name = "juggernaut_suit_name",
	desc = "juggernaut_suit_desc",
	hud = true
}

if (GetConVar("ttt_juggernautsuit_detective"):GetBool()) then
	if SERVER then
		perk["loadout"] = GetConVar("ttt_juggernautsuit_detective_loadout"):GetBool()
	end
	table.insert(EquipmentItems[ROLE_DETECTIVE], perk)
end
if (GetConVar("ttt_juggernautsuit_traitor"):GetBool()) then
	if SERVER then
		perk["loadout"] = GetConVar("ttt_juggernautsuit_traitor_loadout"):GetBool()
	end
	table.insert(EquipmentItems[ROLE_TRAITOR], perk)
end
