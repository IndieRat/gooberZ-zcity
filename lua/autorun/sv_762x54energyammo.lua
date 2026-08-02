local ammoKey = "762x54mmelectric"
local ammoDisplayName = "7.62x54 mm Energy"

local function registerElectricAmmo762x54()
    if not hg or not hg.ammotypes then return end

    -- Cleanup old entries
    hg.ammotypes[ammoKey] = nil
    if hg.ammotypesallowed then hg.ammotypesallowed[ammoKey] = nil end
    if hg.ammotypeshuy then hg.ammotypeshuy[ammoKey] = nil end
    if hg.ammoents then hg.ammoents[ammoKey] = nil end

    if scripted_ents.Get("ent_ammo_" .. ammoKey) then
        scripted_ents.GetStored("ent_ammo_" .. ammoKey).Category = "GooberZ"
    end

    if hg.ammotypes[ammoKey] then return end

    local matRifleAmmo = Material("vgui/hud/bullets/high_caliber.png")
    -- Main Ammo Data
    local ammoData = {
        name = ammoDisplayName,
        allowed = true,
         dmgtype = DMG_SHOCK,
		tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 450,
        maxcarry = 120,
        minsplash = 11,
        maxsplash = 11,

        TracerSetings = {
            TracerBody = Material("particle/fire"),
			TracerTail = Material("effects/laser_tracer"),
			TracerHeadSize = 55,
			TracerLength = 85,
			TracerWidth = 5,
			TracerColor = Color(0, 0, 255),
			TracerTPoint1 = 0.25,
			TracerTPoint2 = 1,
			TracerSpeed = 15000,
            NoSpin = true,
        },

        BulletSettings = {
            Damage = 70,
            Force = 70,
            Penetration = 12.3,
            Shell = "762x54",
            Speed = 830,
            Diameter = 7.62,
            Mass = 9.6,
            Icon = matRifleAmmo,
        }
    }

    hg.ammotypes[ammoKey] = ammoData

    -- Ammo Entity Info
    if not hg.ammoents then hg.ammoents = {} end
    hg.ammoents[ammoKey] = {
        Material = "",
        Scale = 1.0,
        Color = Color(0, 180, 255),
        Count = 30,
    }

    -- Register Engine Ammo
    game.AddAmmoType({
        name = ammoDisplayName,
        dmgtype = DMG_SHOCK,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 450,
        maxcarry = 120,
    })

    if CLIENT then
        language.Add(ammoDisplayName .. "_ammo", ammoDisplayName)
    end

   local ammoent = {}
    ammoent.Base = "ammo_base"
    ammoent.PrintName = ammoDisplayName
    ammoent.Category = "GooberZ"
	ammoent.IconOverride = "vgui/hud/bullets/high_caliber.png"
    ammoent.Spawnable = true
    ammoent.AmmoCount = 30
    ammoent.AmmoType = ammoDisplayName
    ammoent.Model = "models/props_lab/box01a.mdl"
    ammoent.ModelMaterial = ""
    ammoent.ModelScale = 1.0
    ammoent.Color = Color(0, 180, 255)
    
    scripted_ents.Register(ammoent, "ent_ammo_" .. ammoKey)

    -- Auxiliary tables
    if hg.ammotypesallowed then
        hg.ammotypesallowed[ammoKey] = ammoData
    end

    if not hg.ammotypeshuy then hg.ammotypeshuy = {} end
    hg.ammotypeshuy[ammoDisplayName] = table.Copy(ammoData)

    -- Weapon base sync
    local baseSWEP = weapons.GetStored("base_hg")
    if baseSWEP then
        baseSWEP.AmmoTypes2 = baseSWEP.AmmoTypes2 or {}
        baseSWEP.AmmoTypes2[ammoKey] = { ammoKey, 80, 4.0, 1, false, 1, 60 }
    end

    print("[GooberZ] Successfully registered ammo: " .. ammoDisplayName)
end

-- Auto registration
if hg and hg.ammotypes and (game.IsDedicated() or game.GetMap() ~= "") then
    registerElectricAmmo762x54()
else
    hook.Add("Initialize", "init_ammo_762x54_energy", registerElectricAmmo762x54)
end
