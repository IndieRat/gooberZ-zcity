--[[
    7.62x39 mm Incedinary Energy / Incedinary Electric Ammo Type for HG Ammo System
]]

local ammoKey = "tranqassim"           -- Internal key
local ammoDisplayName = "Assimlation Darts" -- Main display name key

local function registerElectricAmmodart()
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
        dmgtype = DMG_CLUB,
        tracer = "tracer_bio_green",
       	plydmg = 0,
		npcdmg = 0,
		force = 50,
		maxcarry = 30,
		minsplash = 0,
		maxsplash = 0,
        TracerSetings = {
             TracerBody = Material("particle/fire"),
			TracerTail = Material("effects/laser_tracer"),
			TracerHeadSize = 55,
			TracerLength = 85,
			TracerWidth = 5,
			TracerColor = Color(255, 255, 255),
			TracerTPoint1 = 0.25,
			TracerTPoint2 = 1,
			TracerSpeed = 15000
        },
       BulletSettings = {
			Damage = 5,
			Force = 10,
			Penetration = 0,
			Shell = "9x19",
			Spread = Vector(0, 0, 0),
			Speed = 650,
			AirResistMul = 0.0002,
			Diameter = 9,
			Mass = 18,
			Icon = matPistolAmmo,
			tranquilizer = true,
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
        Color = Color(255, 255, 255),
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
    ammoent.Color = Color(209, 112, 0)
    
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
    registerElectricAmmodart()
else
    hook.Add("Initialize", "init_ammo_762x39mm_inced_energy", registerElectricAmmodart)
end

