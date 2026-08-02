if SERVER then AddCSLuaFile() end

-- CLASS REGISTRATION
local CLASS = player.RegClass("humanityForces")

local FactionData = {
    Models = {
        ["Soldier"] = {
            "models/player/group03/male_07.mdl",
            "models/player/group03/male_03.mdl",
            "models/player/group03/male_05.mdl",
            "models/player/group03/female_02.mdl"
        },
        ["Medic"] = {
            "models/player/group03m/male_04.mdl",
            "models/player/group03m/female_04.mdl"
        }
    },
    Weapons = {
        ["Soldier"] = {
            [1] = {  -- Low Gear
                Primary = {"weapon_uzii_electric", "weapon_mini14_electric", "weapon_remington870_electric", "weapon_ak74u_electric"},
                Secondary = {"weapon_glock26_electric", "weapon_glock18c_electric"},
                Equipment = {"ent_armor_anti_infected_mask", "weapon_hg_grenade_energy", "weapon_handcuffs", "weapon_handcuffs_key", "weapon_reverse_combat"}
            },
            [2] = {  -- Standard
                Primary = {"weapon_hkmp5_electric", "weapon_mini14_electric", "weapon_hk416_electric", "weapon_m590a1_electric", "weapon_ak74u_electric", "weapon_rpk_electric"},
                Secondary = {"weapon_glock26_electric", "weapon_glock18c_electric", "weapon_hkusp_electric"},
                Equipment = {"ent_armor_anti_infected_vest", "ent_armor_anti_infected_mask", "weapon_hg_grenade_energy", "weapon_handcuffs", "weapon_handcuffs_key", "weapon_anti_goober", "weapon_reverse_combat"}
            },
            [3] = {  -- Elite
                Primary = {"weapon_m4a1_electric", "weapon_sg552_electric", "weapon_spas12_electric", "weapon_svd_electric", "weapon_ak74_electric", "weapon_akm_prototype", "weapon_pkm_electric"},
                Secondary = {"weapon_hkusp_electric", "weapon_357_bolt"},
                Equipment = {"ent_armor_anti_infected_vest", "ent_armor_anti_infected_helmet", "ent_armor_anti_infected_mask", "weapon_hg_grenade_energy", "weapon_handcuffs", "weapon_handcuffs_key", "weapon_anti_goober", "weapon_reverse_combat"}
            }
        },
        ["Medic"] = {
            [1] = {
                Equipment = {"weapon_med_pouch", "weapon_medkit_sh", "weapon_betablock", "ent_armor_anti_infected_mask", "weapon_hg_grenade_energy", "weapon_handcuffs", "weapon_handcuffs_key", "weapon_anti_goober"}
            }
        }
    }
}

local correspondingAmmo = {
    ["weapon_uzii_electric"]         = { ammo = "9x19 mm Energy", count = 120 },
    ["weapon_hkmp5_electric"]        = { ammo = "9x19 mm Energy", count = 150 },
    ["weapon_glock26_electric"]      = { ammo = "9x19 mm Energy", count = 60 },
    ["weapon_glock18c_electric"]     = { ammo = "9x19 mm Energy", count = 90 },
    ["weapon_hkusp_electric"]        = { ammo = "9x19 mm Energy", count = 60 },
    ["weapon_mini14_electric"]       = { ammo = "5.56x45 mm Energy", count = 120 },
    ["weapon_hk416_electric"]        = { ammo = "5.56x45 mm Energy", count = 180 },
    ["weapon_m4a1_electric"]         = { ammo = "5.56x45 mm Energy", count = 180 },
    ["weapon_sg552_electric"]        = { ammo = "5.56x45 mm Energy", count = 180 },
    ["weapon_m590a1_electric"]       = { ammo = "12/70 Energy", count = 64 },
    ["weapon_spas12_electric"]       = { ammo = "12/70 Energy", count = 64 },
    ["weapon_svd_electric"]          = { ammo = "7.62x54 mm Energy", count = 90 },
    ["weapon_remington870_electric"] = { ammo = "12/70 Energy", count = 64 },
	["weapon_357_bolt"]				= { ammo = ".357 Bolt", count = 60 },
	["weapon_ak74u_electric"]		= { ammo = "5.45x39 mm Energy", count = 180 },
	["weapon_ak74_electric"]        = { ammo = "5.45x39 mm Energy", count = 180 },
	["weapon_akm_prototype"] 		= { ammo = "7.62x39 mm Incedinary Energy", count = 120 }
}

-- Custom Resistance Ranks mapped by priority tier
local ranksName = {
    [1] = "Pvt. ",
    [2] = "Op. ",
    [3] = "Enf. "
}

local toDocRanks = {
    [1] = "Field Med. ",
    [2] = "Comb Med. ",
    [3] = "Tac Surgeon. "
}

local toRadioRanks = {
    [1] = "RTO. ",           -- Radio Telephone Operator
    [2] = "Sig Op. ",
    [3] = "Net Ctrl. ",
}

local toAmmoBoxRanks = {
    [1] = "Log. ",           -- logistics
    [2] = "Supply. ",
    [3] = "QM. ",            -- quartermaster
}

local toRavenRanks = {
	[1] = "Blackbird. ",
	[2] = "Phathom. ",
	[3] = "Specter Raven. "
}

local subRoles = {
	"None",
	"Radio",
	"AmmoBox",
	"Raven"
}

-- Helper: Strip ALL known rank prefixes (single + multi-word)
local function CleanRankPrefix(name)
    if not name or name == "" then return "" end
    name = string.Trim(name)

    -- Explicit list of every rank you use (order: longest first)
    local prefixes = {
        "Tac Surgeon. ",
        "Field Med. ",
        "Comb Med. ",
        "Pvt. ",
        "Op. ",
        "Enf. ",
        "Doc. ",
        "Priv. ",
        "Corp. ",
        "Sgt. ",
		"RTO. ",
		"Sig Op. ",
		"Net Ctrl. ",
		"Log. ",
		"Supply. ",
		"QM. ",
		"Blackbird. ",
		"Phathom. ",
		 "Specter Raven. "
    }

    for _, prefix in ipairs(prefixes) do
        if string.StartWith(name, prefix) then
            name = string.sub(name, #prefix + 1)
            break
        end
    end

    -- Fallback: strip any remaining "Word." or "Word Word." style prefix
    name = name:gsub("^[%a%s]+%.%s*", "")

    return string.Trim(name)
end
-- Helper: Safely apply compatible random attachments
local function ApplyRandomAttachments(ply, wepClass)
    if not hg or not hg.SetAttachment then return end

    local wepTable = weapons.Get(wepClass)
    if not wepTable or not wepTable.availableAttachments then return end

    local attachmentBlacklist = {
        ["supressor6"] = true,
        ["scope_kar98k"] = true,
		["laser4"] = true,
    }

    local reservedKeys = {
        ["mount"] = true,
        ["mountType"] = true,
        ["mountAngle"] = true,
        ["empty"] = true,
        ["noblock"] = true,
        ["removehuy"] = true
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

    -- Strict verification to ensure the attachment name exists in Homigrad's global registry
    local function IsValidGlobalAttachment(attName)
        if not attName or not isstring(attName) or attName == "empty" or attachmentBlacklist[attName] then return false end
        if not hg.attachments then return true end

        for _, categoryData in pairs(hg.attachments) do
            if istable(categoryData) and categoryData[attName] then
                return true
            end
        end
        return false
    end

    -- General recursive or flat extractor to find valid strings inside tables safely
    local function ExtractAttachmentName(item)
        if isstring(item) then
            return item
        elseif istable(item) then
            -- Usually the first index [1] holds the attachment class string
            if isstring(item[1]) then
                return item[1]
            end
        end
        return nil
    end

    -- 1. ROLL STANDARD CATEGORY ATTACHMENTS (barrel, grip, slide, stock, etc.)
    for category, catTable in pairs(wepTable.availableAttachments) do
        if category ~= "sight" and category ~= "underbarrel" and category ~= "mount" and istable(catTable) then
            local validInCategory = {}

            for key, attData in pairs(catTable) do
                if not reservedKeys[key] then
                    local attName = ExtractAttachmentName(attData)
                    if IsValidGlobalAttachment(attName) then
                        table.insert(validInCategory, attName)
                    end
                end
            end

            if #validInCategory > 0 then
                table.insert(attachmentsToEquip, validInCategory[math.random(1, #validInCategory)])
            end
        end
    end

    -- 2. ROLL UNDERBARRELS (Handles custom rails like AK electric, grips, lasers, etc.)
    if wepTable.availableAttachments.underbarrel and hg.attachments then
        local ubCategory = hg.attachments.underbarrel or hg.attachments.grip or {}
        local validUnderbarrels = {}

        local ubTable = wepTable.availableAttachments.underbarrel
        for key, attData in pairs(ubTable) do
            if not reservedKeys[key] then
                local attName = ExtractAttachmentName(attData)
                if IsValidGlobalAttachment(attName) then
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

    -- 4. SAFELY APPLY FILTERED ATTACHMENTS
    if #attachmentsToEquip > 0 then
        timer.Simple(0.05, function()
            if not IsValid(ply) then return end
            local wepInst = ply:GetWeapon(wepClass)
            if IsValid(wepInst) then
                wepInst.attachments = wepInst.attachments or {}
                for _, attName in ipairs(attachmentsToEquip) do
                    if isstring(attName) then
                        hg.SetAttachment(wepInst.attachments, attName, wepClass)
                    end
                end
            end
        end)
    end
end
local function SetupHumanityLoadout(ply, priorityOverride)
    if not IsValid(ply) then return end

    local roles = {"Soldier", "Medic"}
    local role = math.random(1, 2) / 2 >= 0.5 and "Soldier" or "Medic"
    local priority = priorityOverride or math.random(1, 3)

    -- Model
    local modelList = FactionData.Models[role]
    if modelList and #modelList > 0 then
        ply:SetModel(modelList[math.random(1, #modelList)])
        ply:SetSubMaterial()
        if ply.SetNetVar then
            ply:SetNetVar("Accessories", "")
        end
    end

    -- Loadout
	local loadout = FactionData.Weapons[role] and (FactionData.Weapons[role][priority] or FactionData.Weapons[role][1])
	if role == "Medic" then
		loadout.Primary = FactionData.Weapons["Soldier"][priority].Primary
		loadout.Secondary = FactionData.Weapons["Soldier"][priority].Secondary
	end
    if not loadout then return role, priority end

    local function GiveWeaponWithAmmo(wepClass)
        ply:Give(wepClass)
        ApplyRandomAttachments(ply, wepClass)

        local ammoInfo = correspondingAmmo[wepClass]
        if ammoInfo then
            ply:GiveAmmo(ammoInfo.count, ammoInfo.ammo, true)
        end
    end

    if loadout.Primary and #loadout.Primary > 0 then
        GiveWeaponWithAmmo(loadout.Primary[math.random(1, #loadout.Primary)])
    end
    if loadout.Secondary and #loadout.Secondary > 0 then
        GiveWeaponWithAmmo(loadout.Secondary[math.random(1, #loadout.Secondary)])
    end

    if loadout.Equipment then
        for _, item in ipairs(loadout.Equipment) do
            if weapons.GetStored(item) then
                ply:Give(item)
            elseif hg and hg.AddArmor then
                hg.AddArmor(ply, item)
            end
        end
    end

    if hg and hg.CreateInv then hg.CreateInv(ply) end
    if ply.SyncArmor then ply:SyncArmor() end

    return role, priority
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

    -- === RETRIEVE PRESET ARGUMENTS (WITH FALLBACKS) ===
    local presetRole = ply.PendingRole
    local presetPriority = ply.PendingPriority

    -- Clear them so they don't stick around for future respawns unintentionally
    ply.PendingRole = nil
    ply.PendingPriority = nil

    -- Pass them into your loadout generator
    local role, priority = SetupHumanityLoadout(ply, presetPriority)

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
	
	local subRole = "None"
	if role != "Medic" then
		subRole = subRoles[math.random(1, #subRoles)]
		
		if subRole == "Radio" then
			ply:Give("weapon_hf_radio")
		elseif subRole == "AmmoBox" then
			ply:Give("weapon_droppable_ammo")
		elseif subRole == "Raven" then
			ply:Give("weapon_atc")
		end
	end

    -- === APPLY RANK PREFIX ===
    local oldName = Appearance.AName or ply:Nick() or ""
    local cleanName = CleanRankPrefix(oldName)

    local prefix = ""
    if role == "Medic" then
        prefix = toDocRanks[priority] or "Field Med. "
    else
        if subRole == "None" then
			prefix = ranksName[priority] or "Pvt. "
		elseif subRole == "Radio" then
			prefix 	= toRadioRanks[priority] or "RTO. "
		elseif subRole == "AmmoBox" then
			prefix 	= toAmmoBoxRanks[priority] or "Log. "
		elseif subRole == "Raven" then
			prefix = toRavenRanks[priority] or "Blackbird. "
		end
    end

    local newName = prefix .. cleanName

    ply:SetNWString("PlayerName", newName)
    Appearance.AName = newName
end