AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

resource.AddWorkshop("650523765")

CreateConVar("ttt_hermesboots_detective_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Detectives have the Hermes Boots in their loadout?")
CreateConVar("ttt_hermesboots_traitor_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Traitors have the Hermes Boots in their loadout?")

include('shared.lua')

--[[Perk logic]]--
hook.Add("TTTPlayerSpeed", "TTTHermesBoots", function(ply)
	if (IsValid(ply) and ply:HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
		if (EQUIP_JUGGERNAUT_SUIT and ply:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			return 1.05 -- 5% increase with juggernaut suit
		else
			return 1.3 -- 30% increase
		end
	end
end)
