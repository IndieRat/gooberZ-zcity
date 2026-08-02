--[[
    5.56x45mm Energy / Electric Ammo Type for HG Ammo System
]]

local ammoKey = "556x45mmenergy"           -- Internal key
local ammoDisplayName = "5.56x45 mm Energy" -- Main display name key

local function registerElectricAmmo556()
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
	  if hg.ammotypes[ammoKey] then return end

    local matRifleAmmo = Material("vgui/hud/bullets/high_caliber.png")

    -- 1. MAIN AMMOTYPES DATA
    local ammoData = {
        name = ammoDisplayName,
        allowed = true,
         dmgtype = DMG_SHOCK,
		tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 180,
        maxcarry = 210,
        minsplash = 5,
        maxsplash = 5,
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
            Damage = 60,
            Force = 60,
            Penetration = 6.0,
            Shell = "5.56x45",
            Speed = 900,
            Diameter = 5.56,
            Mass = 4.0,
            Icon = matRifleAmmo,
            IsBlank = false,
        }
    }

    -- Primary entry (used for table iterations, radial menus, and lookups)
    hg.ammotypes[ammoKey] = ammoData

    -- 3. AMMO ENTITY INFO
    if not hg.ammoents then
        hg.ammoents = {}
    end

    hg.ammoents[ammoKey] = {
        Material = "",
        Scale = 1.0,
        Color = Color(0, 0, 255),
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

    -- 5. AUXILIARY TABLES (Single Key to prevent duplicate entries in UI/loops)
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
        baseSWEP.AmmoTypes2[ammoKey] = { ammoKey, 60, 6.0, 1, false, 1, 60 }
    end
end

if hg and hg.ammotypes and (game.IsDedicated() or game.GetMap() ~= "") then
    registerElectricAmmo556()
else
    hook.Add("Initialize", "init_ammo_556x45mm_energy", registerElectricAmmo556)
end

