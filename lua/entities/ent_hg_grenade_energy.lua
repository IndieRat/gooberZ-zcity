AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_hg_grenade"

ENT.PrintName = "Energy Grenade"
ENT.Category = "GooberZ"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/Items/grenadeAmmo.mdl"

ENT.TimeToBoom = 3.5
ENT.Radius = 280
ENT.Damage = 35
ENT.Force = 400

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(8)
        end

        -- Use timer.Simple for guaranteed fuse (most reliable method)
        timer.Simple(self.TimeToBoom, function()
            if IsValid(self) then
                self:Explode()
            end
        end)
    end

    function ENT:Explode()
        if self.hasExploded then return end
        self.hasExploded = true

        local pos = self:GetPos()

        -- Visual
        local effect = EffectData()
        effect:SetOrigin(pos)
        effect:SetScale(1.3)
        util.Effect("Explosion", effect)

        -- Sound
        self:EmitSound("ambient/energy/zap9.wav", 95, 100, 1, CHAN_AUTO)

        -- Shock + Stun
        for _, ent in ipairs(ents.FindInSphere(pos, self.Radius)) do
            if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
                local dist = ent:GetPos():Distance(pos)
                local dmgScale = math.Clamp(1 - (dist / self.Radius), 0.25, 1)

                if ent:IsPlayer() then
                    if hg and hg.LightStunPlayer then
                        hg.LightStunPlayer(ent, 3.8 * dmgScale)
                    end

                    local dmg = DamageInfo()
                    dmg:SetDamage(self.Damage * dmgScale)
                    dmg:SetDamageType(DMG_SHOCK)
                    dmg:SetAttacker(IsValid(self.owner) and self.owner or self)
                    dmg:SetInflictor(self)
                    ent:TakeDamageInfo(dmg)

                    if ent.ScreenFade then
                        ent:ScreenFade(SCREENFADE.IN, Color(0, 180, 255, 180), 0.9, 0.2)
                    end
                end
            end
        end

        self:Remove()
    end

    function ENT:PhysicsCollide(data, phys)
        if data.Speed > 60 then
            self:EmitSound("physics/metal/metal_grenade_impact_hard1.wav", 70)
        end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end