AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

resource.AddWorkshop("652046425") -- this addon
resource.AddWorkshop("620977303") -- Blacklight Heavy Playermodel

CreateConVar("ttt_juggernautsuit_detective_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Detectives have the Juggernaut Suit in their loadout?")
CreateConVar("ttt_juggernautsuit_traitor_loadout", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should Traitors have the Juggernaut Suit in their loadout?")

include('shared.lua')

--[[Perk logic]]--
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
