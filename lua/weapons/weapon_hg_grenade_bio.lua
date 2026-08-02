-------------------------------------------------------------------------------
-- 2. BIO-ASSIMILATION GRENADE (SWEP)
-------------------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_hg_grenade_tpik"

SWEP.PrintName = "Bio-Assimilation Grenade"
SWEP.Category = "GooberZ"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Instructions = "Primary Fire: High Throw\nSecondary Fire: Low Throw\nReload: Cancel Throw\n\n[LORE] Synthesized by insurgent traitors using stolen bio-mass technologies, this canister disperses a concentrated splash of a corroding version of the 'Cure' upon burst. Non-assimilated targets caught within the blast radius suffer chemical corrosion, severe disorientation, and applies a decent amount of assimilation."

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Wait = 2
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "camera"

SWEP.WorldModel = "models/Items/grenadeAmmo.mdl"
SWEP.WorldModelReal = "models/weapons/c_grenade.mdl"
SWEP.WorldModelFake = "models/weapons/tfa_ins2/w_m67.mdl"

-- Points to your bio-energy grenade entity
SWEP.ENT = "ent_hg_grenade_bioenergy"

SWEP.AnimList = {
    ["deploy"] = { "draw", 1, false },
    ["attack"] = { "throw", 0.8, false, false, function(self)
        if CLIENT then return end
        self:Throw(1100, self.SpoonTime, nil, Vector(2, 4, 0), Angle(-40, 0, 0))
        self:FinishThrow()
    end, 0.65 },
    ["attack2"] = { "lowthrow", 0.8, false, false, function(self)
        if CLIENT then return end
        self:Throw(550, self.SpoonTime, nil, Vector(0, 4, -6), Angle(40, 0, 0))
        self:FinishThrow()
    end, 0.6 },
    ["pullbackhigh"] = { "pullbackhigh", 1.5, false, false, function(self)
        self:SetShowPin(false)
        self.ReadyToThrow = true
    end, 0.8 },
    ["pullbacklow"] = { "pullbacklow", 1.5, false, false, function(self)
        self:SetShowPin(false)
        self.IsLowThrow = true
        self.ReadyToThrow = true
    end, 0.8 },
    ["revers_pullbackhigh"] = { "pullbackhigh", 2, false, true, function(self)
        self:SetShowPin(true)
    end, 0.9 },
    ["revers_pullbacklow"] = { "pullbacklow", 2, false, true, function(self)
        self:SetShowPin(true)
    end, 0.9 },
    ["idle"] = { "draw", 1, false },
}

function SWEP:FinishThrow()
    self.InThrowing = false
    self.ReadyToThrow = false
    self.SpoonTime = false
    self.Spoon = true

    timer.Simple(0.6, function()
        if not IsValid(self) then return end
        self.count = (self.count or 1) - 1
        if self.count < 1 then
            if IsValid(self:GetOwner()) then
                self:GetOwner():SelectWeapon("weapon_hands_sh")
            end
            self:Remove()
        else
            self:PlayAnim("idle")
            self:SetShowSpoon(true)
            self:SetShowGrenade(true)
            self:SetShowPin(true)
        end
    end)
end

function SWEP:Initialize()
    self:PlayAnim("deploy")
    self.count = 1
    self.Spoon = true
    self.ReadyToThrow = false
    self.IsLowThrow = false

    if SERVER then
        self:SetShowSpoon(true)
        self:SetShowGrenade(true)
        self:SetShowPin(true)
    end
end

function SWEP:Deploy()
    self:PlayAnim("deploy")
end

function SWEP:PrimaryAttack()
    if self.ReadyToThrow or (self.CoolDown and self.CoolDown > CurTime()) then return end
    local owner = self:GetOwner()
    if not hg.CanUseLeftHand(owner) or not hg.CanUseRightHand(owner) then return end

    self.CoolDown = CurTime() + 2
    self:PlayAnim("pullbackhigh")
    self.Thrower = owner
end

function SWEP:SecondaryAttack()
    if self.ReadyToThrow or (self.CoolDown and self.CoolDown > CurTime()) then return end
    local owner = self:GetOwner()
    if not hg.CanUseLeftHand(owner) or not hg.CanUseRightHand(owner) then return end

    self.CoolDown = CurTime() + 2
    self:PlayAnim("pullbacklow")
    self.Thrower = owner
    self.IsLowThrow = true
end

function SWEP:Reload()
    if self.ReadyToThrow then
        self:ResetThrow()
        return
    end
end

function SWEP:ResetThrow()
    if self.SpoonTime then return end
    self.ReadyToThrow = false
    self:PlayAnim(self.IsLowThrow and "revers_pullbacklow" or "revers_pullbackhigh")
    self.IsLowThrow = false
end