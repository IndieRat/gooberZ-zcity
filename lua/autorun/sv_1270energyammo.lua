local ammoKey = "12x70electric"
local ammoDisplayName = "12/70 Energy"

local function registerElectricAmmo1270()
    if not hg or not hg.ammotypes then return end

     -------------------------------------------------------------------
    -- CLEANUP: Wipe old/ghost ZCity entries before registering
    -------------------------------------------------------------------
    hg.ammotypes[ammoKey] = nil
    if hg.ammotypesallowed then hg.ammotypesallowed[ammoKey] = nil end
    if hg.ammotypeshuy then hg.ammotypeshuy[ammoKey] = nil end
    if hg.ammoents then hg.ammoents[ammoKey] = nil end
    
    -- Unregister any conflicting scripted entity registered under ZCity
    if scripted_ents.Get("ent_ammo_" .. ammoKey) then
        scripted_ents.GetStored("ent_ammo_" .. ammoKey).Category = "GooberZ"
    end
    -------------------------------------------------------------------

    -- Guard against running registration twice
    if hg.ammotypes[ammoKey] then return end

    local matShotgunAmmo = Material("vgui/hud/bullets/buck_caliber.png")


    -- Main Ammo Data
    local ammoData = {
        name = ammoDisplayName,
        allowed = true,
        dmgtype = DMG_SHOCK,
		tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 350,
        maxcarry = 46,
        minsplash = 15,
        maxsplash = 15,

        TracerSettings = {
            TracerBody = Material("particle/fire"),
			TracerTail = Material("effects/laser_tracer"),
			TracerHeadSize = 55,
			TracerLength = 85,
			TracerWidth = 5,
			TracerColor = Color(0, 0, 255),
			TracerTPoint1 = 0.25,
			TracerTPoint2 = 1,
			TracerSpeed = 15000
        },

        BulletSettings = {
            Damage = 16,
            Force = 8,
            Penetration = 7.5,
            NumBullet = 8,
            Shell = "12x70",
            Speed = 400,
            AirResistMul = 0.0003,
            Diameter = 12/8,
            Mass = 32/8,
            Icon = matShotgunAmmo,
            ShellColor = Color(255, 0, 0)
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
        force = 350,
        maxcarry = 46,
    })

    if CLIENT then
        language.Add(ammoDisplayName .. "_ammo", ammoDisplayName)
    end

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
        baseSWEP.AmmoTypes2[ammoKey] = { ammoKey, 45, 4.0, 1, false, 1, 40 }
    end

    print("[GooberZ] Successfully registered ammo: " .. ammoDisplayName)
end

-- Registration timing
if hg and hg.ammotypes and (game.IsDedicated() or game.GetMap() ~= "") then
    registerElectricAmmo1270()
else
    hook.Add("Initialize", "init_ammo_12x70_energy", registerElectricAmmo1270)
end

