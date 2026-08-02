AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_hg_grenade"

ENT.PrintName = "Bio-Assimilation Grenade"
ENT.Category = "GooberZ"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/Items/grenadeAmmo.mdl"

ENT.TimeToBoom = 3.5
ENT.Radius = 300
ENT.Damage = 15          -- Lower base physical damage, relies on assimilation
ENT.AssimilationAdd = 45 -- Base assimilation progress added on hit
ENT.Force = 200

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

        -- Fuse timer
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

        -- Visual Effects (Blood/Acid Splash)
        local effect = EffectData()
        effect:SetOrigin(pos)
        effect:SetScale(1.5)
        util.Effect("BloodImpact", effect)
        
        local expEffect = EffectData()
        expEffect:SetOrigin(pos)
        expEffect:SetScale(1.2)
        util.Effect("cshot_spit", expEffect)

        -- Audio Effects
        self:EmitSound("npc/barnacle/neck_snap1.wav", 90, 85, 1, CHAN_AUTO)
        self:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav", 95, 110, 1, CHAN_AUTO)

        -- Bio-Shock + Assimilation application
        for _, ent in ipairs(ents.FindInSphere(pos, self.Radius)) do
            if IsValid(ent) and ent:IsPlayer() and ent:Alive() then
                -- Ignore fellow Goobers
                if ent.PlayerClassName != "goober" then
                    local dist = ent:GetPos():Distance(pos)
                    local dmgScale = math.Clamp(1 - (dist / self.Radius), 0.2, 1)

                    -- 1. Apply Assimilation Progress (Factoring in Armor Reduction)
                    local currentProgress = ent:GetNetVar("AssimilationProgress", 0)
                    local maxVal = ent:GetNetVar("MaxAssimilation", 100)
                    local reduction = ent:GetNetVar("AssimilationReduction", 0)
                    local mult = math.Clamp(1 - reduction, 0, 1)

                    local addProgress = (self.AssimilationAdd * dmgScale) * mult
                    local newProgress = currentProgress + addProgress

                    ent:SetNetVar("AssimilationProgress", newProgress)

                    -- 2. Stun Effect
                    if hg and hg.LightStunPlayer then
                        hg.LightStunPlayer(ent, 3.0 * dmgScale)
                    end

                    -- 3. Chemical Damage
                    local dmg = DamageInfo()
                    dmg:SetDamage(self.Damage * dmgScale)
                    dmg:SetDamageType(DMG_ACID)
                    dmg:SetAttacker(IsValid(self.owner) and self.owner or self)
                    dmg:SetInflictor(self)
                    ent:TakeDamageInfo(dmg)

                    -- 4. Green Bio Flash
                    if ent.ScreenFade then
                        ent:ScreenFade(SCREENFADE.IN, Color(50, 205, 50, 190), 0.8, 0.3)
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