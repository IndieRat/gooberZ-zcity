AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Ammo Crate"
ENT.Category = "GooberZ"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/items/ammocrate_rockets.mdl" -- Standard GMod ammo crate model

function ENT:Initialize()
    self:SetModel(self.Model)
    
    if SERVER then
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    
    -- Cooldown check to prevent spamming
    if self.NextUse and self.NextUse > CurTime() then return end
    self.NextUse = CurTime() + 1.0

    local supplied = false

    -- 1. Check for GooberZ (GZ) custom ammo systems if available
    -- (Adapting to common GZ framework patterns)
    if activator.GiveAmmo and activator.GetActiveWeapon then
        local activeWeapon = activator:GetActiveWeapon()
        
        if IsValid(activeWeapon) then
            -- Try refilling the currently equipped gun's primary and secondary ammo
            local primaryAmmoType = activeWeapon:GetPrimaryAmmoType()
            local secondaryAmmoType = activeWeapon:GetSecondaryAmmoType()
            
            if primaryAmmoType and primaryAmmoType > 0 then
                local maxClip = activeWeapon:GetMaxClip1()
                if maxClip > 0 then
                    -- Refill clip or give standard reserve blocks
                    activator:GiveAmmo(maxClip * 2, primaryAmmoType)
                    supplied = true
                else
                    activator:GiveAmmo(30, primaryAmmoType)
                    supplied = true
                end
            end
            
            if secondaryAmmoType and secondaryAmmoType > 0 then
                activator:GiveAmmo(5, secondaryAmmoType)
                supplied = true
            end
        end
    end

    if supplied then
        self:EmitSound("items/ammo_pickup.wav", 75, 100)
        
        -- Optional visual feedback or particle effect
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos() + Vector(0, 0, 20))
        util.Effect("ItemPickup", effectdata)
        
        print("[GooberZ] Player " .. activator:Nick() .. " resupplied from Ammo Crate.")
    end
end