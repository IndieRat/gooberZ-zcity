if SERVER then AddCSLuaFile() end

-- CLASS REGISTRATION
local CLASS = player.RegClass("traitor")

local FactionData = {
    Models = {
        "models/player/group03/male_07.mdl",
        "models/player/group03/male_03.mdl",
        "models/player/group03/male_05.mdl",
        "models/player/group03/female_02.mdl"
    },
    Weapons = {
        Primary = {
            "weapon_svd_traitor",
            "weapon_uzii_traitor",
            "weapon_remington870_traitor",
            "weapon_mini14_traitor",
			"weapon_ak47u_traitor",
			"weapon_traitor_prototype"
        },
        Secondary = {
            "weapon_hkusp_traitor"
        },
        Equipment = {
            "weapon_goosyringe",
            "weapon_hg_grenade_bio",
            "ent_armor_anti_infected_mask",
			"weapon_t_radio"
        }
    }
}

-- Traitor ranks match standard Humanity Forces ranks for cover camouflage
local ranksName = {
    [1] = "Pvt. ",
    [2] = "Op. ",
    [3] = "Enf. "
}

-- Helper: Strip old rank prefixes dynamically
local function CleanRankPrefix(name)
    if not name or name == "" then return "" end
    name = string.Trim(name)
    name = name:gsub("^%a+%.%s*", "")
    return string.Trim(name)
end

local correspondingAmmo = {
    ["weapon_svd_traitor"]          = { ammo = "7.62x54 mm Bio-Energy", count = 90 },
    ["weapon_uzii_traitor"]         = { ammo = "9x19 mm Bio-Energy", count = 120 },
    ["weapon_remington870_traitor"] = { ammo = "12/70 Bio-Energy", count = 48 },
    ["weapon_mini14_traitor"]       = { ammo = "5.56x45 mm Bio-Energy", count = 120 },
    ["weapon_hkusp_traitor"]        = { ammo = "9x19 mm Bio-Energy", count = 60 },
	["weapon_ak47u_traitor"] 		= { ammo = "5.45x36 mm Bio-Energy", count = 120 },
	["weapon_traitor_prototype"]    = { ammo = "Assimlation Darts", count = 32 }
}

-- Helper: Safely apply compatible random attachments
local function ApplyRandomAttachments(ply, wepClass)
    if not hg or not hg.SetAttachment then return end

    local wepTable = weapons.Get(wepClass)
    if not wepTable or not wepTable.availableAttachments then return end

    local attachmentBlacklist = {
        ["supressor6"] = true,
        ["scope_kar98k"] = true,
    }

    local reservedKeys = {
        ["mount"] = true,
        ["mountType"] = true,
        ["mountAngle"] = true,
        ["empty"] = true,
        ["noblock"] = true
    }

    local attachmentsToEquip = {}

    local function WeaponSupportsMountType(wepAtts, requiredMount)
        if not requiredMount then return true end
        for cat, catData in pairs(wepAtts) do
            if istable(catData) and catData.mountType then
                local mounts = catData.mountType
                if isstring(mounts) and mounts == requiredMount then
                    return true
                elseif istable(mounts) and table.HasValue(mounts, requiredMount) then
                    return true
                end
            end
        end
        return false
    end

    -- 1. ROLL STANDARD CATEGORY ATTACHMENTS
    for category, catTable in pairs(wepTable.availableAttachments) do
        if category ~= "sight" and category ~= "underbarrel" and istable(catTable) then
            local validInCategory = {}

            for key, attData in pairs(catTable) do
                if not reservedKeys[key] and type(key) ~= "string" and istable(attData) then
                    local attName = attData[1]
                    if attName and attName ~= "empty" and not attachmentBlacklist[attName] then
                        table.insert(validInCategory, attName)
                    end
                elseif category == "mount" and istable(attData) then
                    local attName = attData[1]
                    if attName and attName ~= "empty" and not attachmentBlacklist[attName] then
                        table.insert(validInCategory, attName)
                    end
                end
            end

            if #validInCategory > 0 then
                table.insert(attachmentsToEquip, validInCategory[math.random(1, #validInCategory)])
            end
        end
    end

    -- 2. ROLL UNDERBARRELS
    if wepTable.availableAttachments.underbarrel and hg.attachments then
        local ubCategory = hg.attachments.underbarrel or hg.attachments.grip or {}
        local validUnderbarrels = {}

        local ubTable = wepTable.availableAttachments.underbarrel
        for key, attData in pairs(ubTable) do
            if not reservedKeys[key] and type(key) ~= "string" and istable(attData) then
                local attName = attData[1]
                if attName and attName ~= "empty" and not attachmentBlacklist[attName] then
                    table.insert(validUnderbarrels, attName)
                end
            end
        end

        if #validUnderbarrels == 0 then
            for attName, attInfo in pairs(ubCategory) do
                if istable(attInfo) and not attachmentBlacklist[attName] then
                    local attMountType = attInfo.mountType or attInfo[1]
                    if WeaponSupportsMountType(wepTable.availableAttachments, attMountType) then
                        table.insert(validUnderbarrels, attName)
                    end
                end
            end
        end

        if #validUnderbarrels > 0 then
            table.insert(attachmentsToEquip, validUnderbarrels[math.random(1, #validUnderbarrels)])
        end
    end

    -- 3. ROLL SIGHT / OPTIC
    if wepTable.availableAttachments.sight and hg.attachments then
        local sightCategory = hg.attachments.sight or hg.attachments
        local validOptics = {}

        for attName, attInfo in pairs(sightCategory) do
            if istable(attInfo) and not attachmentBlacklist[attName] then
                local attMountType = attInfo.mountType or attInfo[1]

                if WeaponSupportsMountType(wepTable.availableAttachments, attMountType) then
                    local isPistol = wepClass:find("glock") or wepClass:find("usp") or wepClass:find("pistol")
                    local isSniperScope = attName:find("kar98") or attName:find("pu") or attName:find("pso") or attName:find("3x9")

                    if not (isPistol and isSniperScope) then
                        table.insert(validOptics, attName)
                    end
                end
            end
        end

        if #validOptics > 0 then
            table.insert(attachmentsToEquip, validOptics[math.random(1, #validOptics)])
        end
    end

    -- 4. APPLY ATTACHMENTS
    if #attachmentsToEquip > 0 then
        timer.Simple(0.05, function()
            if not IsValid(ply) then return end
            local wepInst = ply:GetWeapon(wepClass)
            if IsValid(wepInst) then
                wepInst.attachments = wepInst.attachments or {}
                for _, attName in ipairs(attachmentsToEquip) do
                    hg.SetAttachment(wepInst.attachments, attName, wepClass)
                end
            end
        end)
    end
end

local function SetupTraitorLoadout(ply)
    if not IsValid(ply) then return end

    -- Model Selection
    local models = FactionData.Models
    if models and #models > 0 then
        ply:SetModel(models[math.random(1, #models)])
        ply:SetSubMaterial()
        if ply.SetNetVar then
            ply:SetNetVar("Accessories", "")
        end
    end

    local function GiveWeaponWithAmmo(wepClass)
        ply:Give(wepClass)
        ApplyRandomAttachments(ply, wepClass)
        local ammoInfo = correspondingAmmo[wepClass]
        if ammoInfo then
            ply:GiveAmmo(ammoInfo.count, ammoInfo.ammo, true)
        end
    end

    -- Primary
    if #FactionData.Weapons.Primary > 0 then
        local chosenPrimary = FactionData.Weapons.Primary[math.random(1, #FactionData.Weapons.Primary)]
        GiveWeaponWithAmmo(chosenPrimary)
    end

    -- Secondary
    if #FactionData.Weapons.Secondary > 0 then
        local chosenSecondary = FactionData.Weapons.Secondary[math.random(1, #FactionData.Weapons.Secondary)]
        GiveWeaponWithAmmo(chosenSecondary)
    end

    -- Equipment
    if FactionData.Weapons.Equipment then
        for _, item in ipairs(FactionData.Weapons.Equipment) do
            if weapons.GetStored(item) then
                ply:Give(item)
            elseif hg and hg.AddArmor then
                hg.AddArmor(ply, item)
            end
        end
    end

    if hg and hg.CreateInv then hg.CreateInv(ply) end
    if ply.SyncArmor then ply:SyncArmor() end
end

function CLASS.On(self, data)
    if not SERVER then return end
    local ply = self
    if not IsValid(ply) then return end

    ply:StripWeapons()
    ply:StripAmmo()
    ply.armors = {}
    ply.armors_health = {}
    ply:Give("weapon_hands_sh")

    SetupTraitorLoadout(ply)

    -- Appearance
    local Appearance = ply.CurAppearance or {}
    local plycolor = Appearance.AColor and Color(Appearance.AColor.r, Appearance.AColor.g, Appearance.AColor.b)

    if plycolor then
        local h, s, l = plycolor:ToHSL()
        plycolor = HSLToColor(h, s / 4, l * 2)
        Appearance.AColor = plycolor
        plycolor = plycolor:ToVector()
    end

    ply.CurAppearance = Appearance
    ply:SetPlayerColor(plycolor or VectorRand(0.95, 1))

    -- === SPOOF RESISTANCE RANK FOR CAMOUFLAGE ===
    local oldName = Appearance.AName or ply:Nick() or ""
    local cleanName = CleanRankPrefix(oldName)

    local prefix = ranksName[math.random(1, 3)] or "Pvt. "
    local newName = prefix .. cleanName

    ply:SetNWString("PlayerName", newName)
    Appearance.AName = newName
end