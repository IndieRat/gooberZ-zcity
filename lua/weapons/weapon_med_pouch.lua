AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "ATA Pouch"
SWEP.Instructions = "Standard issue pouch of ATA for combat recovery with infected\nLMB: Refill/give self ATA (uses pouch charges). \nRMB: Refill/give other player's ATA (uses pouch charges). n/n/[LORE] Standard issued Medical pouches given to medics to carry more than one ATA"
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

SWEP.HoldType = "slam"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"
SWEP.Model = "models/w_models/weapons/w_eq_medkit.mdl"

if CLIENT then
	SWEP.BounceWeaponIcon = false
end

SWEP.Weight = 0
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Slot = 5
SWEP.SlotPos = 99

SWEP.WorkWithFake = true
SWEP.offsetVec = Vector(5, 0, -2)
SWEP.offsetAng = Angle(0, 0, 0)
SWEP.ModelScale = 1

-- Pouch mode structure: 15 uses stored in modeValues[1]
function SWEP:InitializeAdd()
	self:SetHold(self.HoldType)
end

function SWEP:Initialize()
	self:SetHold(self.HoldType)
	self.modeValues = {
		[1] = 15, -- 15 refills/syringes in the pouch itself
	}
end

function SWEP:DrawWorldModel()
	self.model = IsValid(self.model) and self.model or ClientsideModel(self.WorldModel)
	local WorldModel = self.model
	local owner = self:GetOwner()
	WorldModel:SetNoDraw(true)
	WorldModel:SetModelScale(self.ModelScale)
	if IsValid(owner) then
		local offsetVec = self.offsetVec
		local offsetAng = self.offsetAng
		
		local attachOwner = owner
		if owner.FakeRagdoll and IsValid(owner.FakeRagdoll) then
			attachOwner = owner.FakeRagdoll
		end

		local boneid = attachOwner:LookupBone("ValveBiped.Bip01_R_Hand")
		if not boneid then return end
		local matrix = attachOwner:GetBoneMatrix(boneid)
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

-- Shared function to handle giving or replacing weapon_reverse using the pouch's charge pool
local function GiveOrReplaceReverse(pouch, ply, sourceOwner, isSelf)
	-- Check if pouch has charges left
	if not pouch.modeValues or pouch.modeValues[1] <= 0 then
		if IsValid(sourceOwner) then
			sourceOwner:PrintMessage(HUD_PRINTTALK, "[HF Medic Pouch] The medic pouch is out of charges!")
		end
		return false
	end

	local existingWep = ply:GetWeapon("weapon_reverse")
	if IsValid(existingWep) then
		local isEmpty = false
		if existingWep.modeValues and existingWep.modeValues[1] then
			if existingWep.modeValues[1] <= 0 then
				isEmpty = true
			end
		end

		if isEmpty then
			ply:StripWeapon("weapon_reverse")
			local newWep = ply:Give("weapon_reverse")
			if IsValid(newWep) then
				if newWep.modeValues then
					newWep.modeValues[1] = 1 -- stays at 1 as requested
				end
				ply:EmitSound("items/medshot4.wav", 75, 100)
				-- Consumes 1 charge from the pouch
				pouch.modeValues[1] = pouch.modeValues[1] - 1
			end
		else
			if not isSelf and IsValid(sourceOwner) then
				sourceOwner:PrintMessage(HUD_PRINTTALK, "[HF Medic Pouch] Target already has a charged weapon_reverse!")
			elseif isSelf and IsValid(sourceOwner) then
				sourceOwner:PrintMessage(HUD_PRINTTALK, "[HF Medic Pouch] Your weapon_reverse is already charged!")
			end
			return false
		end
	else
		local newWep = ply:Give("weapon_reverse")
		if IsValid(newWep) then
			if newWep.modeValues then
				newWep.modeValues[1] = 1
			end
			ply:EmitSound("items/medshot4.wav", 75, 100)
			-- Consumes 1 charge from the pouch
			pouch.modeValues[1] = pouch.modeValues[1] - 1
		end
	end

	-- Delete pouch if charges reach 0
	if pouch.modeValues[1] <= 0 then
		if IsValid(sourceOwner) then
			sourceOwner:SelectWeapon("weapon_hands_sh")
		end
		pouch:Remove()
	end

	return true
end

-- LMB: Give/Refill Self
function SWEP:PrimaryAttack()
	if CLIENT then return end
	
	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	GiveOrReplaceReverse(self, owner, owner, true)

	self:SetNextPrimaryFire(CurTime() + 1)
end

-- RMB: Give/Refill Other Player in front
function SWEP:SecondaryAttack()
	if CLIENT then return end
	
	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	local shootPos = owner:GetShootPos()
	local aimVec = owner:GetAimVector()
	if owner.FakeRagdoll and IsValid(owner.FakeRagdoll) then
		shootPos = owner.FakeRagdoll:GetPos() + Vector(0, 0, 40)
	end

	local tr = util.TraceLine({
		start = shootPos,
		endpos = shootPos + aimVec * 70,
		filter = {owner, owner.FakeRagdoll},
		mask = MASK_SHOT
	})

	local targetEntity = tr.Entity
	if not IsValid(targetEntity) then return end

	local targetPly = targetEntity:IsPlayer() and targetEntity or (targetEntity.Player and IsValid(targetEntity.Player) and targetEntity.Player)
	if not IsValid(targetPly) or not targetPly:IsPlayer() then return end

	GiveOrReplaceReverse(self, targetPly, owner, false)

	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Reload()
end