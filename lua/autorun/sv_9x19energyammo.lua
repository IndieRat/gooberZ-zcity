local ammoKey = "9x19mmenergy"           -- Internal key
local ammoDisplayName = "9x19 mm Energy" -- Display name

local function registerElectricAmmo9x19()
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

    local matPistolAmmo = Material("vgui/hud/bullets/low_caliber.png")

    -- 1. MAIN AMMOTYPES DATA
    local ammoData = {
        name = ammoDisplayName,
        allowed = true,
         dmgtype = DMG_SHOCK,
		tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 120,
        maxcarry = 180,
        minsplash = 4,
        maxsplash = 4,
        TracerSetings = {
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
            Damage = 45,
            Force = 40,
            Penetration = 4.0,
            Shell = "9x19",
            Speed = 420,
            Diameter = 9.0,
            Mass = 8.0,
            Icon = matPistolAmmo,
            IsBlank = false,
        }
    }

    -- Primary entry only
    hg.ammotypes[ammoKey] = ammoData

    -- 3. AMMO ENTITY INFO
    if not hg.ammoents then
        hg.ammoents = {}
    end

    hg.ammoents[ammoKey] = {
        Material = "",
        Scale = 1.0,
        Color = Color(0, 180, 255),
        Count = 30,
    }

    -- 4. REGISTER ENGINE AMMO TYPE & ENTITY
    game.AddAmmoType(ammoData)
    
    if CLIENT then
        language.Add(ammoDisplayName .. "_ammo", ammoDisplayName)
    end
    
    local ammoent = {}
    ammoent.Base = "ammo_base"
    ammoent.PrintName = ammoDisplayName
	ammoent.IconOverride = "vgui/hud/bullets/low_caliber.png"
    ammoent.Category = "GooberZ"
    ammoent.Spawnable = true
    ammoent.AmmoCount = 30
    ammoent.AmmoType = ammoDisplayName
    ammoent.Model = "models/props_lab/box01a.mdl"
    ammoent.ModelMaterial = ""
    ammoent.ModelScale = 1.0
    ammoent.Color = Color(0, 180, 255)
    
    scripted_ents.Register(ammoent, "ent_ammo_" .. ammoKey)

    -- 5. AUXILIARY TABLES
    if hg.ammotypesallowed then
        hg.ammotypesallowed[ammoKey] = ammoData
    end

    if not hg.ammotypeshuy then
        hg.ammotypeshuy = {}
    end

    local huyData = table.Copy(ammoData)
    huyData.name = ammoDisplayName
    hg.ammotypeshuy[ammoDisplayName] = huyData

    -- 6. WEAPON BASE SYNCHRONIZATION
    local baseSWEP = weapons.GetStored("base_hg")
    if baseSWEP then
        baseSWEP.AmmoTypes2 = baseSWEP.AmmoTypes2 or {}
        baseSWEP.AmmoTypes2[ammoKey] = { ammoDisplayName, 45, 4.0, 1, false, 1, 40 }
    end
end

if hg and hg.ammotypes and (game.IsDedicated() or game.GetMap() ~= "") then
    registerElectricAmmo9x19()
else
    hook.Add("Initialize", "init_ammo_9x19mm_energy", registerElectricAmmo9x19)
end
