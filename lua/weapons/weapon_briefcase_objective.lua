AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Briefcase"
SWEP.Instructions = "You cannot hold anything else but this briefcase because it's heavy n/n/[LORE] A briefcase dense with important files just begging to be read."
SWEP.Category = "GooberZ"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "normal"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/props_c17/SuitCase_Passenger_Physics.mdl"
SWEP.Model = "models/props_c17/SuitCase_Passenger_Physics.mdl"

if CLIENT then
	SWEP.BounceWeaponIcon = false
end

SWEP.Weight = 0
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 5
SWEP.SlotPos = 99
SWEP.WorkWithFake = false
SWEP.NoHolster = true

SWEP.offsetVec = Vector(5, -1.5, -0.6)
SWEP.offsetAng = Angle(-90, 0, 0)
SWEP.ModelScale = 0.8

function SWEP:DrawWorldModel()
	self.model = IsValid(self.model) and self.model or ClientsideModel(self.WorldModel)
	local WorldModel = self.model
	local owner = self:GetOwner()
	WorldModel:SetNoDraw(true)
	WorldModel:SetModelScale(self.ModelScale)
	if IsValid(owner) then
		local offsetVec = self.offsetVec
		local offsetAng = self.offsetAng
		local boneid = owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if not boneid then return end
		local matrix = owner:GetBoneMatrix(boneid)
		if not matrix then return end
		local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
		WorldModel:SetPos(newPos)
		WorldModel:SetAngles(newAng)
		WorldModel:SetupBones()
	else
		WorldModel:SetPos(self:GetPos())
		WorldModel:SetAngles(self:GetAngles())
	end

	WorldModel:DrawModel()
end

function SWEP:SetHold(value)
	self:SetWeaponHoldType(value)
	self:SetHoldType(value)
	self.holdtype = value
end

function SWEP:Think()
	self:SetHold(self.HoldType)
end

if CLIENT then
	function SWEP:DrawHUD()
	end
end

function SWEP:Deploy()
	if SERVER then
		local owner = self:GetOwner()
		if IsValid(owner) then
			owner:SetNetVar("IsHoldingBriefcase", true)
			owner.IsHoldingBriefcase = true
		end
	end
	return true
end

function SWEP:Holster()
	if SERVER then
		local owner = self:GetOwner()
		if IsValid(owner) then
			owner:SetNetVar("IsHoldingBriefcase", false)
			owner.IsHoldingBriefcase = nil
			
			-- Use hg.drop to spawn/throw the weapon entity cleanly if the function exists
			if hg and hg.drop then
				hg.drop(owner, self, nil, 250)
				return false -- Return false to let hg.drop handle stripping/switching safely via code
			end
		end
	end
	return true
end

function SWEP:OnRemove()
	if SERVER then
		local owner = self:GetOwner()
		if IsValid(owner) then
			owner:SetNetVar("IsHoldingBriefcase", false)
			owner.IsHoldingBriefcase = nil
		end
	end
end

function SWEP:Initialize()
	self:SetHold(self.HoldType)
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end