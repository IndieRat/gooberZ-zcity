AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Limited Ammo Crate"
ENT.Category = "GooberZ"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Model = "models/props/de_prodigy/ammo_can_02.mdl"

function ENT:SetupDataTables()
    -- Network the current and max uses so clients can render them
    self:NetworkVar("Int", 0, "CurrentUses")
    self:NetworkVar("Int", 1, "MaxUses")
end

function ENT:Initialize()
    self:SetModel(self.Model)
    
    if SERVER then
        -- Fix physics initialization so it drops and acts like a true prop
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        
        -- Initialize use counter (15 uses max)
        self:SetMaxUses(15)
        self:SetCurrentUses(15)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(25) -- Give it a realistic weight so it doesn't feel like floating cardboard
        end
    end
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    
    -- Cooldown check to prevent spamming
    if self.NextUse and self.NextUse > CurTime() then return end
    self.NextUse = CurTime() + 1.0

    -- Check if it still has uses left
    if self:GetCurrentUses() <= 0 then
        activator:ChatPrint("[GooberZ] This ammo crate is empty!")
        return
    end

    local supplied = false
	
	local grenade = "weapon_hg_grenade_energy"
	local wep = activator:GetWeapon(grenade)
	if not IsValid(wep) then
		activator:Give(grenade)
	end

    -- 1. Check for GooberZ (GZ) custom ammo systems if available
    if activator.GiveAmmo and activator.GetActiveWeapon then
        local activeWeapon = activator:GetActiveWeapon()
        
        if IsValid(activeWeapon) then
            local primaryAmmoType = activeWeapon:GetPrimaryAmmoType()
            local secondaryAmmoType = activeWeapon:GetSecondaryAmmoType()
           
            if primaryAmmoType and primaryAmmoType > 0 then
                local maxClip = activeWeapon:GetMaxClip1()
                if maxClip > 0 then
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
        -- Decrement use count server-side (networked automatically)
        if SERVER then
            self:SetCurrentUses(self:GetCurrentUses() - 1)
        end

        self:EmitSound("items/ammo_pickup.wav", 75, 100)
       
        -- Visual feedback
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos() + Vector(0, 0, 10))
        util.Effect("ItemPickup", effectdata)
       
        activator:ChatPrint("[GooberZ] Resupplied! Uses left: " .. self:GetCurrentUses() .. "/" .. self:GetMaxUses())

        -- Destroy crate if uses run out
        if self:GetCurrentUses() <= 0 then
            self:EmitSound("physics/metal/metal_box_break1.wav", 80, 100)
            
            local destroyEffect = EffectData()
            destroyEffect:SetOrigin(self:GetPos())
            util.Effect("Explosion", destroyEffect)

            self:Remove()
        end
    end
end

if CLIENT then
    function ENT:DrawTranslucent()
        self:DrawModel()

        -- 3D2D Billboard Setup
        local pos = self:GetPos() + Vector(0, 0, 20) -- Height offset above the ammo box
        local ang = LocalPlayer():EyeAngles()
        
        -- Face the camera horizontally (yaw only) so it's always readable from any side
        ang:RotateAroundAxis(ang:Forward(), 90)
        ang:RotateAroundAxis(ang:Right(), 90)

        cam.Start3D2D(pos, Angle(0, ang.yaw, 90), 0.08)
            local current = self:GetCurrentUses()
            local max = self:GetMaxUses()

            -- Background box for readability
            draw.RoundedBox(8, -110, -50, 220, 100, Color(0, 0, 0, 180))
            
            -- Border color changes based on remaining uses
            local borderColor = current > 5 and Color(50, 200, 50, 220) or Color(200, 50, 50, 220)
            surface.SetDrawColor(borderColor)
            surface.DrawOutlinedRect(-110, -50, 220, 100, 4)

            -- Text display
            draw.SimpleText("AMMO CRATE", "DermaDefaultBold", 0, -25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            local countColor = current > 5 and Color(255, 255, 255, 255) or Color(255, 100, 100, 255)
            draw.SimpleText(current .. " / " .. max, "Trebuchet24", 0, 15, countColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end