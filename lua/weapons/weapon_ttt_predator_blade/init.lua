AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

resource.AddWorkshop("646635858")

function SWEP:Think()
	if (self:Clip1() < self.Primary.ClipSize and self.NextJumpStack < CurTime()) then
		self:SetClip1(self:Clip1() + 1)
		self.NextJumpStack = CurTime() + 5
	end

	if (IsValid(self.Owner) and self.Owner:GetNWInt("PredatorStacks") > self.MinimumPredatorStacks and self.NextSpeedDecrease < CurTime()) then
		self:ChangePredatorStacks(-1)
	end

	local idletime = self:GetNWFloat("NextIdle")

	if (idletime > 0 and CurTime() > idletime) then
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence("idle"))
		self:UpdateNextIdle()
	end
end
