AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

resource.AddWorkshop("650523765")

CreateConVar("ttt_hermesboots_detective_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Detectives have the Hermes Boots in their loadout?")
CreateConVar("ttt_hermesboots_traitor_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Traitors have the Hermes Boots in their loadout?")
local speed = CreateConVar("ttt_hermesboots_speed", 1.3, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "The speed multiplier for the Hermes Boots.")

include('shared.lua')

--[[Perk logic]]--
hook.Add("TTTPlayerSpeed", "TTTHermesBoots", function(ply)
	if (IsValid(ply) and ply:HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
		if (EQUIP_JUGGERNAUT_SUIT and ply:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			return speed:GetFloat() * GetConVar("ttt_juggernautsuit_speed"):GetFloat() -- multiply with the speed of the Juggernaut Suit
		else
			return speed:GetFloat()
		end
	end
end)
