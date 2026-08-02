-------------------------------------------------------------------
-- ANTI-TRANSFORMED CLOAK (Stealth Device)
-------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Anti-Transformed Cloak"
SWEP.Instructions = "Primary Fire: Toggle Cloak (Hide from highlights and be invisible).\nReload (R): Check remaining fuel.\nWarning: Consumes stamina rapidly on movement and has a limited active duration.\n\n[LORE] A invention by the Humanity Forces to hide from the bio sensors of the assimliated yet the invisiblity isn't perfect"
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
-- Using a generic slam/device model, change if desired
SWEP.WorldModel = "models/weapons/w_slam.mdl"

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
SWEP.offsetVec = Vector(6, 5.5, -4.1)
SWEP.offsetAng = Angle(180, 160, 180)

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	if SERVER then
		self:SetNWFloat("CloakFuel", 100) -- Max time capacity
		self:SetNWBool("IsCloaked", false)
	end
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	-- Force uncloak if the weapon is put away
	if SERVER and self:GetNWBool("IsCloaked", false) then
		self:Uncloak()
	end
	return true
end

function SWEP:OnRemove()
	-- Force uncloak if the weapon is dropped or deleted
	if SERVER and self:GetNWBool("IsCloaked", false) then
		self:Uncloak()
	end
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	self:SetNextPrimaryFire(CurTime() + 1)

	if CLIENT then return end

	local owner = self:GetOwner()
	if not IsValid(owner) or not owner:IsPlayer() then return end

	-- Toggle Logic
	if self:GetNWBool("IsCloaked", false) then
		self:Uncloak()
	else
		self:Cloak()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	
	-- Cooldown so they can't spam their chat by holding R
	if (self.NextReloadMsg or 0) > CurTime() then return end
	self.NextReloadMsg = CurTime() + 1.5

	if SERVER then
		local owner = self:GetOwner()
		if IsValid(owner) then
			-- Round it nicely so it looks like a percentage
			local fuel = math.Round(self:GetNWFloat("CloakFuel", 100))
			owner:ChatPrint(string.format("[Cloak] Power remaining: %d%%", fuel))
			owner:EmitSound("weapons/smg1/switch_single.wav", 50, 150)
		end
	end
end

if SERVER then
	function SWEP:Cloak()
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		-- Don't allow cloaking if they have no fuel or are totally exhausted
		if self:GetNWFloat("CloakFuel", 100) <= 0 then 
			owner:ChatPrint("[Cloak] Error: Device depleted.")
			return 
		end
		if owner.organism and owner.organism.stamina and owner.organism.stamina[1] < 10 then
			owner:ChatPrint("[Cloak] Error: Too exhausted to initiate sequence.")
			return
		end

		self:SetNWBool("IsCloaked", true)
		owner:SetNWBool("IsCloaked", true) -- Set this so your NV Halo script can check it!
		owner:EmitSound("npc/scanner/scanner_nearmiss2.wav", 65, 100)

		-- Apply the invisible material
		local mat = "Models/effects/vol_light001"
		owner:SetMaterial(mat)
		
		-- Hide SWEP and ViewModel
		self:SetMaterial(mat)
		local vm = owner:GetViewModel()
		if IsValid(vm) then vm:SetMaterial(mat) end

		-- Hide Homigrad specific character/ragdoll models
		local char = hg and hg.GetCurrentCharacter and hg.GetCurrentCharacter(owner)
		if IsValid(char) then char:SetMaterial(mat) end
	end

	function SWEP:Uncloak()
		local owner = self:GetOwner()
		self:SetNWBool("IsCloaked", false)
		
		if IsValid(owner) then
			owner:SetNWBool("IsCloaked", false)
			owner:EmitSound("npc/scanner/scanner_siren1.wav", 65, 100)
			
			-- Restore normal materials
			owner:SetMaterial("")
			self:SetMaterial("")
			
			local vm = owner:GetViewModel()
			if IsValid(vm) then vm:SetMaterial("") end

			local char = hg and hg.GetCurrentCharacter and hg.GetCurrentCharacter(owner)
			if IsValid(char) then char:SetMaterial("") end
		end
	end
end

function SWEP:Think()
	if CLIENT then return end

	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	if self:GetNWBool("IsCloaked", false) then
		-- 1. Drain the SWEP's internal fuel (Time limit)
		local fuel = self:GetNWFloat("CloakFuel", 100)
		fuel = fuel - (FrameTime() * 1)
		self:SetNWFloat("CloakFuel", fuel)

		-- 2. Drain Player Exhaustion (Homigrad Stamina)
		if owner.organism and owner.organism.stamina then
			local vel = ply:GetVelocity()
			if vel:Length() > 0.1 then
				-- Adds to the subadd to drain stamina rapidly
				owner.organism.stamina.subadd = owner.organism.stamina.subadd + 0.15
			end
		end

		-- 3. Check Uncloak Conditions
		local outOfStamina = (owner.organism and owner.organism.stamina and owner.organism.stamina[1] < 10)
		
		if fuel <= 0 then
			owner:ChatPrint("[Cloak] Device depleted. Uncloaking.")
			self:Uncloak()
		elseif outOfStamina then
			owner:ChatPrint("[Cloak] Exhaustion limit reached. Uncloaking.")
			self:Uncloak()
		end
	else
		-- 4. Slowly recharge fuel while uncloaked (Optional)
		local fuel = self:GetNWFloat("CloakFuel", 100)
		if fuel < 100 then
			self:SetNWFloat("CloakFuel", math.min(100, fuel + (FrameTime() * 1.5))) 
		end
	end
end

-- ===================================================================
-- RENDERING & HOMIGRAD FAKE WEAPON LOGIC 
-- (Kept intact from the base radio script to prevent breaking drops)
-- ===================================================================
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

	-- Apply cloak material to Homigrad's custom WorldModel
	if self:GetNWBool("IsCloaked", false) then
		WorldModel:SetMaterial("Models/effects/vol_light001")
	else
		WorldModel:SetMaterial("")
	end

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
		
		-- Make sure dropped fake guns are cloaked if the user was cloaked
		if self:GetNWBool("IsCloaked", false) then
			ent:SetMaterial("Models/effects/vol_light001")
		end
		
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