-------------------------------------------------------------------
-- HUMANITY FORCES RADIO (Reinforcement Caller)
-------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_base"
SWEP.PrintName = "The Corps Radio"
SWEP.Instructions = "Primary Fire: Call in Corp reinforcements.\nConsumes on use."
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
SWEP.WorldModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"

if CLIENT then
	SWEP.WepSelectIcon = Material("vgui/wep_jack_hmcd_walkietalkie")
	SWEP.IconOverride = "vgui/wep_jack_hmcd_walkietalkie.png"
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
SWEP.offsetVec = Vector(6, 5.5, -41)
SWEP.offsetAng = Angle(180, 160, 180)

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

	-- Play a transmission confirmation sound
	owner:EmitSound("radio/voip_end_transmit_beep_01.wav", 55, 100)
	
	print(GetSpectatorCount())
	if GetSpectatorCount() > 0 then
		owner:ChatPrint("[Radio] Transmission sent: Requesting Corp reinforcements...")

		-- Trigger the reinforcement function
		if CallForReinforcements then
			CallForReinforcements("traitor")
		else
			print("[T Radio Error] CallForReinforcements function not found!")
		end

		-- Remove the radio from inventory/hands
		self:Remove()
	else
		owner:ChatPrint("[Radio] Transmission sent: We have no one on standby!")
	end
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
		hg.bone.Set(owner, lookup_name, vec, ang, "walkietalkie", 0.01)
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