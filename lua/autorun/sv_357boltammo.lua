local ammoKey = ".357electric"
local ammoDisplayName = ".357 Bolt"

local function registerElectricAmmo357()
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
		force = 130,
		maxcarry = 150,
		minsplash = 2.5,
		maxsplash = 2.5,

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
			Damage = 40,
			Force = 40,
			Penetration = 5.8,
			Shell = "10mm",
			Speed = 440,
			Diameter = 9,
			Mass = 10.2,
			Icon = matPistolAmmo
		}
    }

    hg.ammotypes[ammoKey] = ammoData

    -- Ammo Entity Info
    if not hg.ammoents then hg.ammoents = {} end
    hg.ammoents[ammoKey] = {
        Material = "",
        Scale = 1.0,
        Color = Color(0, 0, 255),
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
    registerElectricAmmo357()
else
    hook.Add("Initialize", "init_ammo_357_energy", registerElectricAmmo357)
end
