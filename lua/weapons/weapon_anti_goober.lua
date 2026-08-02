-------------------------------------------------------------------
-- ANTI-TRANSFORMED SYRINGE (SWEP)
-------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_bandage_sh"
SWEP.PrintName = "Anti-Transformed Syringe"
SWEP.Instructions = "LMB to inject yourself, RMB to inject into someone else. Contains a concentrated necrotizing solution created by combining ATA with various chemicals, this causes rapid cellular dissolution in infected targets."
SWEP.Category = "GooberZ"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.Wait = 1
SWEP.Primary.Next = 0
SWEP.HoldType = "normal"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/tfa_ins2/upgrades/phy_optic_eotech.mdl"
SWEP.Model = "models/weapons/w_models/w_jyringe_jroj.mdl"

if CLIENT then
	SWEP.WepSelectIcon = Material("vgui/wep_jack_hmcd_adrenaline")
	SWEP.IconOverride = "vgui/wep_jack_hmcd_adrenaline.png"
	SWEP.BounceWeaponIcon = false
end

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.WorkWithFake = true
SWEP.offsetVec = Vector(5, -1.5, -2.5)
SWEP.offsetAng = Angle(90, 0, -90)
SWEP.modeNames = {
	[1] = "chemical_injector"
}

function SWEP:InitializeAdd()
	self:SetHold(self.HoldType)

	self.modeValues = {
		[1] = 1
	}
end

SWEP.modeValuesdef = {
	[1] = 1
}

SWEP.DeploySnd = ""
SWEP.HolsterSnd = ""
SWEP.showstats = false

local hg_healanims = ConVarExists("hg_healanims") and GetConVar("hg_healanims") or CreateConVar("hg_healanims", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Toggle heal/food animations", 0, 1)

function SWEP:Think()
	if not IsValid(self:GetOwner()) then return end
	if not self:GetOwner():KeyDown(IN_ATTACK) and hg_healanims:GetBool() then
		self:SetHolding(math.max(self:GetHolding() - 4, 0))
	end
end

function SWEP:Animation()
	local hold = self:GetHolding()
	self:BoneSet("r_upperarm", vector_origin, Angle(0, -hold + (100 * (hold / 100)), 0))
	self:BoneSet("r_forearm", vector_origin, Angle(-hold / 6, -hold * 2, -15))
end

function SWEP:OwnerChanged()
	local owner = self:GetOwner()
	if IsValid(owner) and owner:IsNPC() then
		self:NPCHeal(owner, 0.1, "snd_jack_hmcd_needleprick.wav")
	end
end

if SERVER then
	-- Function to continuously melt/dissolve the target safely without infinite recursion loops
	local function ApplyMeltingLoop(targetPly, attacker, inflictor)
		if not IsValid(targetPly) then return end
		
		-- Set Network Variable tag
		targetPly:SetNWBool("IsMelting", true)

		local timerID = "GooberMeltLoop_" .. targetPly:EntIndex()
		
		timer.Create(timerID, 0.5, 0, function()
			-- Stop loop if target is invalid or no longer melting
			if not IsValid(targetPly) or not targetPly:GetNWBool("IsMelting", false) then
				if timer.Exists(timerID) then
					timer.Remove(timerID)
				end
				return
			end

			-- Play periodic sizzling sound
			targetPly:EmitSound("ambient/levels/canals/toxic_slime_sizzle1.wav", 70, math.random(100, 110))

			-- Deal clean acid/burn damage directly without calling fake loops inside the timer
			local dmg = DamageInfo()
			dmg:SetDamage(25) -- Configured to tick damage safely over time rather than instant crashing
			dmg:SetDamageType(DMG_ACID + DMG_BURN)
			if IsValid(attacker) then dmg:SetAttacker(attacker) end
			if IsValid(inflictor) then dmg:SetInflictor(inflictor) end
			targetPly:TakeDamageInfo(dmg)
			
			print(targetPly.organism.o2[1])
			if targetPly.organism.o2[1] <= 15 then
				targetPly:Kill()
			end

			-- Check if dead, trigger fake/ragdoll safely once
			if not targetPly:Alive() then
				if timer.Exists(timerID) then
					timer.Remove(timerID)
				end
				targetPly:SetNWBool("IsMelting", false)
				
				if hg and hg.Fake and not targetPly.IsFake then
					hg.Fake(targetPly, nil, true)
				end
			end
		end)
	end

	function SWEP:Heal(ent, mode)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end

		-- Animation check
		if ent == hg.GetCurrentCharacter(owner) and hg_healanims:GetBool() then
			self:SetHolding(math.min(self:GetHolding() + 4, 100))
			if self:GetHolding() < 100 then return end
		end

		if self.modeValues[1] <= 0 then return end

		-- Check target class
		local targetPly = ent
		if IsValid(ent) and ent:IsRagdoll() and IsValid(ent.owner) then
			targetPly = ent.owner
		end

		if not IsValid(targetPly) then return end

		local className = targetPly.PlayerClassName or (targetPly.GetPlayerClass and targetPly:GetPlayerClass()) or ""
		local isGoober = (className == "goober")

		-- Play injection sound
		targetPly:EmitSound("snd_jack_hmcd_needleprick.wav", 65, math.random(90, 100))

		if isGoober then
			-- --- INFECTED MELTING LOOP START ---
			ApplyMeltingLoop(targetPly, owner, self)
		else
			-- --- REGULAR HUMAN LOGIC ---
			local org = targetPly.organism
			if org then
				-- Poison the non-infected player
				org.poison4 = CurTime()
				org.poisonAdd = (org.poisonAdd or 0) + 50
			else
				-- Standard damage fallback if organism framework is absent
				local dmg = DamageInfo()
				dmg:SetDamage(50)
				dmg:SetDamageType(DMG_POISON)
				dmg:SetAttacker(owner)
				dmg:SetInflictor(self)
				targetPly:TakeDamageInfo(dmg)
			end
		end

		-- Consume syringe and remove weapon safely
		self.modeValues[1] = 0
		if IsValid(owner) and owner:IsPlayer() then
			owner:SelectWeapon("weapon_hands_sh")
		end
		self:Remove()
	end
end