if SERVER then AddCSLuaFile() end

-- CLASS REGISTRATION
local CLASS = player.RegClass("doctor")

local mdls = {
	["Liz"] = "models/player/hostage/hostage_02.mdl",
	["Rum"] = "models/player/hostage/hostage_01.mdl",
	["Hyb"] = "models/player/group02/male_02.mdl",
	["Blu"] = "models/player/group01/male_09.mdl",
	["Brad"] = "models/humans/gordon/group01/gordoncitizen.mdl"
}

local loadout = {
	Secondary = {"weapon_hkusp_electric", "weapon_357_bolt"},
	Melee = {
		"weapon_pocketknife"
	},
	Equipment = {
		"weapon_reverse", "weapon_medkit_sh", "weapon_betablock", "ent_armor_anti_infected_mask"
	}
}

local pools = {"Rum", "Liz", "Hyb", "Blu", "Brad"}

local correspondingUsers = {
	["Rumor"] = "Rum",
	["Autistic Dragon"] = "Liz",
	["Skelekitten"] = "Hyb",
	["blue_gelatin"] = "Blu",
	["b14thetruth"] = "Brad"
}

-- Helper: Strip old rank prefixes dynamically
local function CleanRankPrefix(name)
    if not name or name == "" then return "" end
    name = string.Trim(name)
    name = name:gsub("^%a+%.%s*", "")
    return string.Trim(name)
end


local correspondingAmmo = {
    ["weapon_hkusp_electric"]        = { ammo = "9x19 mm Energy", count = 32 },
	["weapon_357_bolt"]				= { ammo = ".357 Bolt", count = 36 },
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


local function SetupDocLoadout(ply)
	local role
	
	-- 1. Check if the player has a corresponding user entry
	local cleanName = CleanRankPrefix(ply:Nick())
	print(cleanName)
	if correspondingUsers[cleanName] then
		role = correspondingUsers[cleanName]
	else
		-- Fallback to random if not found
		role = pools[math.random(1, #pools)]
	end

	local mdl = mdls[role]
	
	ply:SetModel(mdl)
	ply:SetSubMaterial()
	
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
	
	if loadout.Melee and #loadout.Melee > 0 then
		ply:Give(loadout.Melee[math.random(1, #loadout.Melee)])
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
	return role
end

local names = {
	["Rum"] = "Dr. Rumor",
	["Liz"] = "Dr. Lizard",
	["Hyb"] = "Mr. Hybrid",
	["Blu"] = "Blu. 'Gelatin'",
	["Brad"] = "Dr. Physics"
}



function CLASS.On(self, data)
    if not SERVER then return end
    local ply = self
    if not IsValid(ply) then return end

    ply:StripWeapons()
    ply:StripAmmo()
    ply.armors = {}
    ply.armors_health = {}
    ply:Give("weapon_hands_sh")

    local r = SetupDocLoadout(ply)

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

 
    local newName = names[r]

    ply:SetNWString("PlayerName", newName)
    Appearance.AName = newName
end