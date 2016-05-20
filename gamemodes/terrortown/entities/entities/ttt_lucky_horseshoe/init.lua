AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

resource.AddWorkshop("650523807")

CreateConVar("ttt_luckyhorseshoe_detective_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Detectives have the Lucky Horseshoe in their loadout?")
CreateConVar("ttt_luckyhorseshoe_traitor_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Traitors have the Lucky Horseshoe in their loadout?")

include('shared.lua')

--[[Perk logic]]--
hook.Add("EntityTakeDamage", "TTTLuckyHorseshoe", function(ent, dmginfo)
	if (IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() and ent:HasEquipmentItem(EQUIP_LUCKY_HORSESHOE)) then
		dmginfo:ScaleDamage(0.10) -- decrease damage by 90%
		if (dmginfo:GetDamage() > 35) then -- maximum of 35 damage
			dmginfo:SetDamage(35)
		end
	end
end)
