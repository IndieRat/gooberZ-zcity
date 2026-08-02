local ammoKey = "12x70bioenergy"
local ammoDisplayName = "12/70 Bio-Energy"

local function registerBioAmmo1270()
    if not hg or not hg.ammotypes then return end

    -------------------------------------------------------------------
    -- CLEANUP
    -------------------------------------------------------------------
    hg.ammotypes[ammoKey] = nil
    if hg.ammotypesallowed then hg.ammotypesallowed[ammoKey] = nil end
    if hg.ammotypeshuy then hg.ammotypeshuy[ammoKey] = nil end
    if hg.ammoents then hg.ammoents[ammoKey] = nil end

    if scripted_ents.Get("ent_ammo_" .. ammoKey) then
        scripted_ents.GetStored("ent_ammo_" .. ammoKey).Category = "GooberZ"
    end

    if hg.ammotypes[ammoKey] then return end

    local matShotgunAmmo = Material("vgui/hud/bullets/buck_caliber.png")

    -- 1. CLIENT TRACER (Green Bio-Energy)
    if CLIENT then
        local EFFECT = {}
        function EFFECT:Init(data)
            self.StartPos = data:GetStart()
            self.EndPos = data:GetOrigin()
            self.DieTime = CurTime() + 0.18
            self.LaserMat = Material("effects/laser_tracer")
            self.Mat = Material("effects/greenflare")
        end
        function EFFECT:Think() return CurTime() < self.DieTime end
        function EFFECT:Render()
            local alpha = math.Clamp((self.DieTime - CurTime()) / 0.18, 0, 1)
            render.SetMaterial(self.LaserMat)
            render.DrawBeam(self.StartPos, self.EndPos, 6, 0, 1, Color(80, 255, 80, 255 * alpha))
            render.SetMaterial(self.Mat)
            render.DrawSprite(self.EndPos, 22, 22, Color(80, 255, 100, 255 * alpha))
        end
        effects.Register(EFFECT, "tracer_bio_green")
    end

    -- 2. MAIN AMMO DATA
    local ammoData = {
        name = ammoDisplayName,
        allowed = true,
        dmgtype = DMG_SHOCK,
		tracer = TRACER_LINE,
        plydmg = 1,
        npcdmg = 1,
        force = 380,
        maxcarry = 60,
        minsplash = 12,
        maxsplash = 12,

        TracerSettings = {
            TracerBody = Material("particle/fire"),
			TracerTail = Material("effects/laser_tracer"),
			TracerHeadSize = 55,
			TracerLength = 85,
			TracerWidth = 5,
			TracerColor = Color(0, 255, 0),
			TracerTPoint1 = 0.25,
			TracerTPoint2 = 1,
			TracerSpeed = 15000,
            NoSpin = true,
        },

        BulletSettings = {
            Damage = 18,
            Force = 12,
            Penetration = 6.5,
            NumBullet = 8,
            Shell = "12x70",
            Speed = 380,
            AirResistMul = 0.0004,
            Diameter = 12/8,
            Mass = 32/8,
            Icon = matShotgunAmmo,
            ShellColor = Color(80, 255, 80)
        }
    }

    hg.ammotypes[ammoKey] = ammoData

    -- 3. AMMO ENTITY
    if not hg.ammoents then hg.ammoents = {} end
    hg.ammoents[ammoKey] = {
        Material = "",
        Scale = 1.0,
        Color = Color(0, 255, 0),
        Count = 30,
    }

    -- 4. REGISTER ENGINE AMMO
    game.AddAmmoType({
        name = ammoDisplayName,
        dmgtype = DMG_ACID,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 380,
        maxcarry = 60,
    })

    if CLIENT then
        language.Add(ammoDisplayName .. "_ammo", ammoDisplayName)
    end

    -- 5. ENTITY REGISTRATION
    local ammoent = {}
    ammoent.Base = "ammo_base"
    ammoent.PrintName = ammoDisplayName
    ammoent.Category = "GooberZ"
	ammoent.IconOverride = "vgui/hud/bullets/buck_caliber.png"
    ammoent.Spawnable = true
    ammoent.AmmoCount = 30
    ammoent.AmmoType = ammoDisplayName
    ammoent.Model = "models/props_lab/box01a.mdl"
    ammoent.ModelMaterial = ""
    ammoent.ModelScale = 1.0
    ammoent.Color = Color(0, 180, 255)
    
    scripted_ents.Register(ammoent, "ent_ammo_" .. ammoKey)

    -- 6. AUXILIARY TABLES
    if hg.ammotypesallowed then
        hg.ammotypesallowed[ammoKey] = ammoData
    end

    if not hg.ammotypeshuy then hg.ammotypeshuy = {} end
    hg.ammotypeshuy[ammoDisplayName] = table.Copy(ammoData)

    -- 7. Weapon base sync
    local baseSWEP = weapons.GetStored("base_hg")
    if baseSWEP then
        baseSWEP.AmmoTypes2 = baseSWEP.AmmoTypes2 or {}
        baseSWEP.AmmoTypes2[ammoKey] = { ammoKey, 50, 4.0, 1, false, 1, 40 }
    end

    print("[GooberZ] Successfully registered ammo: " .. ammoDisplayName)
end

-- Auto registration
if hg and hg.ammotypes and (game.IsDedicated() or game.GetMap() ~= "") then
    registerBioAmmo1270()
else
    hook.Add("Initialize", "init_ammo_12x70_bioenergy", registerBioAmmo1270)
end
