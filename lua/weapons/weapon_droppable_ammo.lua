-------------------------------------------------------------------
-- DROPPABLE AMMO CRATE (SWEP)
-------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Droppable Ammo Crate"
SWEP.Instructions = "Primary Fire: Place down an Ammo Crate.\nConsumes on use. n/n/ [LORE] Standard issued Ammo box with grenades"
SWEP.Category = "GooberZ"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Wait = 1
SWEP.Primary.Next = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IdleHoldType = "normal"
SWEP.HoldType = "slam"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/props/de_prodigy/ammo_can_02.mdl"

if CLIENT then
	SWEP.WepSelectIcon = Material("vgui/hud/bullets/high_caliber.png")
	SWEP.IconOverride = "vgui/hud/bullets/high_caliber.png"
	SWEP.BounceWeaponIcon = false
end

SWEP.Weight = 0
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 5
SWEP.SlotPos = 5
SWEP.WorkWithFake = true
SWEP.offsetVec = Vector(10, 6, -5)
SWEP.offsetAng = Angle(0, 0, 90)

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	return true
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local owner = self:GetOwner()
	if not IsValid(owner) or not owner:IsPlayer() then return end

	-- Calculate spawn position in front of the player
	local spawnPos = owner:GetShootPos() + owner:GetAimVector() * 40
	local spawnAng = Angle(0, owner:EyeAngles().yaw, 0)

	-- Create the physical ammo crate entity
	local crate = ents.Create("ent_gz_ammo_limited_crate")
	if IsValid(crate) then
		crate:SetPos(spawnPos)
		crate:SetAngles(spawnAng)
		crate:Spawn()
		crate:Activate()

		local phys = crate:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:ApplyForceCenter(owner:GetAimVector() * 150)
		end
	end

	owner:EmitSound("physics/metal/metal_box_impact_bullet1.wav", 65, 100)
	
	-- Remove the weapon from the inventory after placement
	self:Remove()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:DrawWorldModel()
	if !self:GetOwner():IsPlayer() then
		self:DrawModel()
	end
end

function SWEP:DrawWorldModel2()
	self.model = IsValid(self.model) and self.model or ClientsideModel(self.WorldModel)
	local WorldModel = self.model
	local owner = hg and hg.GetCurrentCharacter and hg.GetCurrentCharacter(self:GetOwner()) or self:GetOwner()

	WorldModel:SetNoDraw(true)
	WorldModel:SetModelScale(self.ModelScale or 1)

	if(IsValid(owner) and owner:IsPlayer())then
		local offsetVec = self.offsetVec
		local offsetAng = self.offsetAng
		local boneid = owner:LookupBone("ValveBiped.Bip01_L_Hand")

		if(not boneid)then return end

		local matrix = owner:GetBoneMatrix(boneid)

		if(not matrix)then return end

		local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
		WorldModel:SetPos(newPos)
		WorldModel:SetAngles(newAng)
		WorldModel:SetupBones()

		WorldModel:DrawModel()
	else
		WorldModel:SetPos(self:GetPos())
		WorldModel:SetAngles(self:GetAngles())
		WorldModel:DrawModel()
	end
end

function SWEP:SetHold(value)
	self:SetWeaponHoldType(value)
	self:SetHoldType(value)
	self.holdtype = value
end

function SWEP:BoneSet(lookup_name, vec, ang)
	local owner = self:GetOwner()
	if IsValid(owner) and !owner:IsPlayer() then return end
	if hg and hg.bone then
		hg.bone.Set(owner, lookup_name, vec, ang, "ammocrate_swep", 0.01)
	end
end

function SWEP:Step()
end

function SWEP:Think()
end

if(SERVER)then
	function SWEP:SetFakeGun(ent)
		self:SetNWEntity("fakeGun", ent)
		self.fakeGun = ent
	end

	function SWEP:RemoveFake()
		if(not IsValid(self.fakeGun))then return end
		self.fakeGun:Remove()
		self:SetFakeGun()
	end

	SWEP.RHandPos = Vector(0, 0, 0)

	function SWEP:CreateFake(ragdoll)
		if(IsValid(self:GetNWEntity("fakeGun")))then return end

		local ent = ents.Create("prop_physics")
		local lh = ragdoll:GetPhysicsObjectNum(5)
		local rh = ragdoll:GetPhysicsObjectNum(7)

		if IsValid(rh) and IsValid(lh) and IsValid(self:GetOwner()) then
			rh:SetPos(rh:GetPos() + self:GetOwner():EyeAngles():Forward() * 20)
			rh:SetAngles(self:GetOwner():EyeAngles() + Angle(0, 0, -90))
			lh:SetPos(rh:GetPos())
		end

		ent:SetModel(self.WorldModel)
		ent:Spawn()

		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		ent:SetOwner(ragdoll)
		if IsValid(ent:GetPhysicsObject()) then
			ent:GetPhysicsObject():SetMass(0)
		end
		ent:SetNoDraw(true)
		ent.dontPickup = true
		ent.fakeOwner = self

		ragdoll:DeleteOnRemove(ent)
		ragdoll.fakeGun = ent

		if(IsValid(ragdoll.ConsRH))then 
			ragdoll.ConsRH:Remove()
		end

		self:SetFakeGun(ent)
		ent:CallOnRemove("homigrad-swep", self.RemoveFake, self)
	end

	function SWEP:RagdollFunc(pos, angles, ragdoll)
		local shadowControl = shadowControl or (hg and hg.ShadowControl)
		if shadowControl then
			shadowControl(ragdoll, 5, 0.001, angles, 500, 30, pos, 500, 50)
		end
	end
end