-------------------------------------------------------------------
-- ANTI-TRANSFORMED SYRINGE (SWEP)
-------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_bandage_sh"
SWEP.PrintName = "ATA Quick-Combat"
SWEP.Instructions = "LMB to inject yourself, RMB to inject into someone else. Contains a concentrated strain of ATA that lingers in your blood stream, halving current assimilation."
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
	function SWEP:Heal(ent, mode)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end

		-- Animation check
		if ent == hg.GetCurrentCharacter(owner) and hg_healanims:GetBool() then
			self:SetHolding(math.min(self:GetHolding() + 4, 100))
			if self:GetHolding() < 100 then return end
		end

		if self.modeValues[1] <= 0 then return end

		-- Check target class (supports ragdolls)
		local targetPly = ent
		if IsValid(ent) and ent:IsRagdoll() and IsValid(ent.owner) then
			targetPly = ent.owner
		end

		if not IsValid(targetPly) then return end

		-- Play injection sound
		targetPly:EmitSound("snd_jack_hmcd_needleprick.wav", 65, math.random(90, 100))

		-- --- SLOW REGEN LOGIC START ---
		local currentProgress = targetPly:GetNetVar("AssimilationProgress", 0)
		
		-- We want to remove half of their CURRENT progress over time
		local amountToRemove = currentProgress / 2 
		
		local totalTicks = 20        -- How many times the timer will run
		local tickInterval = 1       -- How many seconds between each tick
		local removePerTick = amountToRemove / totalTicks

		local timerID = "GooberATA_Regen_" .. targetPly:EntIndex()

		-- Create a timer that ticks X times, slowly draining the assimilation
		timer.Create(timerID, tickInterval, totalTicks, function()
			-- Stop the timer if the player disconnected or became invalid
			if not IsValid(targetPly) then
				if timer.Exists(timerID) then timer.Remove(timerID) end
				return
			end
			
			local progress = targetPly:GetNetVar("AssimilationProgress", 0)
			
			-- Subtract the tick amount, keeping it safely at or above 0
			targetPly:SetNetVar("AssimilationProgress", math.max(0, progress - removePerTick))
		end)
		-- --- SLOW REGEN LOGIC END ---

		-- Consume syringe and remove weapon safely
		self.modeValues[1] = 0
		if IsValid(owner) and owner:IsPlayer() then
			owner:SelectWeapon("weapon_hands_sh")
		end
		self:Remove()
	end
end