if SERVER then
    -------------------------------------------------------------------
    -- BIO ENERGY AMMO POOL TABLE
    -------------------------------------------------------------------
    local BIO_ENERGY_AMMO_POOL = {
        ["9x19 mm Bio-Energy"] = true,
        ["7.62x54 mm Bio-Energy"] = true,
        ["5.56x45 mm Bio-Energy"] = true,
        ["12/70 Bio-Energy"] = true,
		["5.45x39 mm Bio-Energy"] = true,
        ["bio_energy"] = true,
        ["bio"] = true,
    }
	
	local AMMO_DAMAGE = {
		["9x19 mm Bio-Energy"] = 7,
        ["7.62x54 mm Bio-Energy"] = 34,
        ["5.56x45 mm Bio-Energy"] = 12,
		["5.45x39 mm Bio-Energy"] = 12,
        ["12/70 Bio-Energy"] = 7,
	}

    -------------------------------------------------------------------
    -- ASSIMILATION / INFECTION HOOK (HOMIGRAD / LUA BULLET COMPATIBLE)
    -------------------------------------------------------------------
    hook.Add("PostEntityFireBullets", "GooberBioAmmoAssimilationPool", function(entity, bulletData)
        if not bulletData or not bulletData.Trace then return end

        local tr = bulletData.Trace
        local target = tr.Entity
        if not IsValid(target) then return end

        -- 1. Resolve real target player (Handles Homigrad ragdolls & organisms)
        local ply = target
        if not ply:IsPlayer() then
            if ply:IsRagdoll() then
                if IsValid(ply.Player) then
                    ply = ply.Player
                elseif IsValid(ply:GetNWEntity("RagdollOwner")) then
                    ply = ply:GetNWEntity("RagdollOwner")
                elseif hg and hg.RagdollOwner then
                    local owner = hg.RagdollOwner(ply)
                    if IsValid(owner) then ply = owner end
                elseif hg and hg.ragdollFake then
                    for p, rag in pairs(hg.ragdollFake) do
                        if rag == ply then
                            ply = p
                            break
                        end
                    end
                end
            else
                return
            end
        end

        -- Check player validity, alive state, and existing team/class
        local plyClass = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass())
        if not IsValid(ply) or not ply:Alive() or plyClass == "goober" then return end

        -- 2. Validate Attacker
        local attacker = bulletData.Attacker
        if not IsValid(attacker) then
            attacker = entity and entity:IsPlayer() and entity or (IsValid(entity) and entity:GetOwner())
        end
        if not IsValid(attacker) or not attacker:IsPlayer() then return end

        -- 3. Resolve Ammo Name
        local ammoName = bulletData.AmmoType
        if isnumber(ammoName) then
            ammoName = game.GetAmmoName(ammoName)
        end

        -- Fallback to Active Weapon if AmmoType was omitted in tInfo
        if not ammoName or ammoName == "" then
            local wep = attacker:GetActiveWeapon()
            if IsValid(wep) then
                local ammoID = wep:GetPrimaryAmmoType()
                ammoName = (wep.GetStat and wep:GetStat("Primary.Ammo"))
                        or (wep.Primary and wep.Primary.Ammo)
                        or (ammoID and game.GetAmmoName(ammoID))
            end
        end

        -- Verify if hit ammo belongs to Bio-Energy Pool
        if not ammoName or not BIO_ENERGY_AMMO_POOL[ammoName] then return end

        -- 4. Determine Hitgroup (Supports Homigrad bone-to-hitgroup map)
        local hitgroup = tr.HitGroup
        if target:IsRagdoll() and hg and hg.bonetohitgroup then
            local boneName = target:GetBoneName(target:TranslatePhysBoneToBone(tr.PhysicsBone))
            if boneName and hg.bonetohitgroup[boneName] then
                hitgroup = hg.bonetohitgroup[boneName]
            end
        end

        -- 5. Assimilation Calculation
        local maxValue = ply.GetNetVar and ply:GetNetVar("MaxAssimilation", 100) or 100
        local currentVal = ply.GetNetVar and ply:GetNetVar("AssimilationProgress", 0) or 0
        local reduction = ply.GetNetVar and ply:GetNetVar("AssimilationReduction", 0) or 0

        local baseBuildUp = AMMO_DAMAGE[ammoName]
        if hitgroup == HITGROUP_HEAD then
            baseBuildUp = maxValue + 10 -- Instant build-up on headshot
        end

        local effective = baseBuildUp * math.Clamp(1 - reduction, 0, 1)
        local newVal = math.min(currentVal + effective, maxValue)

        if ply.SetNetVar then
            ply:SetNetVar("AssimilationProgress", newVal)
        end

        -- Screen Feedback Effect
        ply:ScreenFade(SCREENFADE.IN, Color(0, 255, 50, 100), 0.4, 0)
    end)
	
	 -------------------------------------------------------------------
    -- SUICIDE TRACKING
    -------------------------------------------------------------------
    hook.Add("Org Think", "GooberSuicideAssimilationTrack9x19", function(owner, org, timeValue)
        if not IsValid(owner) or not owner:Alive() or owner.PlayerClassName == "goober" or not owner.GetNetVar then return end

        if not owner.suiciding then
            if owner:GetNetVar("BioSuicidePending", false) then
                owner:SetNetVar("BioSuicidePending", false)
            end
            return
        end

        local wep = owner:GetActiveWeapon()
        if not IsValid(wep) then return end

        local usedAmmo = (wep.GetStat and wep:GetStat("Primary.Ammo")) or (wep.Primary and wep.Primary.Ammo)
        if BIO_ENERGY_AMMO_POOL[usedAmmo] then
            owner:SetNetVar("BioSuicidePending", true)
        end
    end)

    -------------------------------------------------------------------
    -- PLAYER DEATH → CONVERT + CLEAN RAGDOLL + INVENTORY TRANSFER
    -------------------------------------------------------------------
    hook.Add("PlayerDeath", "GooberSuicideAssimilation9x19", function(victim, inflictor, attacker)
        if not IsValid(victim) or victim.PlayerClassName == "goober" then return end

        local isBioSuicide = victim.GetNetVar and victim:GetNetVar("BioSuicidePending", false)
        local isHeadshot = victim:LastHitGroup() == HITGROUP_HEAD
        local isAttackerBio = IsValid(attacker) and attacker:IsPlayer() and (attacker.PlayerClassName == "goober")

        -- CRITICAL FIX: Allow conversion on Bio Suicide, Headshots, OR if killed by an infected/bio source
        if not (isBioSuicide or (isHeadshot and attacker == victim) or isAttackerBio) then return end

        print("[Goober] Bio death/suicide → converting " .. victim:Nick())

        local oldPos = victim:GetPos()
        local oldAngles = victim:GetAngles()

        -- 1. Save deep copy of custom Inventory table
        local oldInventory = victim.Inventory and table.Copy(victim.Inventory) or {}

        -- 2. Save equipped weapons list
        local oldWeapons = {}
        for _, wep in ipairs(victim:GetWeapons()) do
            if IsValid(wep) then
                table.insert(oldWeapons, {
                    class = wep:GetClass(),
                    clip1 = wep:Clip1(),
                    clip2 = wep:Clip2()
                })
            end
        end

        timer.Simple(0.05, function()
            if not IsValid(victim) then return end

            -- Clean dropped entity props from location
            local nearbyEnts = ents.FindInSphere(oldPos, 120)
            for _, ent in ipairs(nearbyEnts) do
                if IsValid(ent) and (ent:IsWeapon() or string.StartWith(ent:GetClass(), "weapon_") or ent.IsHGWeapon) then
                    local class = ent:GetClass()
                    local alreadySaved = false
                    for _, wData in ipairs(oldWeapons) do
                        if wData.class == class then
                            alreadySaved = true
                            break
                        end
                    end

                    if not alreadySaved then
                        table.insert(oldWeapons, {
                            class = class,
                            clip1 = ent.Clip1 and ent:Clip1() or 0,
                            clip2 = ent.Clip2 and ent:Clip2() or 0
                        })
                    end

                    ent:Remove()
                end
            end

            if CleanPlayerCorpse then
                CleanPlayerCorpse(victim)
            end

            -- Respawn and Position
            victim:Spawn()
            victim:SetPos(oldPos)
            victim:SetAngles(oldAngles)
            victim:SetHealth(victim:GetMaxHealth() or 100)

            timer.Simple(0.15, function()
                if not IsValid(victim) then return end

                -- Trigger global role change logic
                if victim.SetNetVar then
					victim:SetNetVar("AssimilationProgress", 100)
                end

                -- Restore Inventory & Weapons
                if oldInventory then
                    victim.Inventory = oldInventory
                    if victim.SyncInventory then victim:SyncInventory() end
                end

                for _, wepData in ipairs(oldWeapons) do
                    if not victim:HasWeapon(wepData.class) then
                        local givenWep = victim:Give(wepData.class)
                        if IsValid(givenWep) then
                            if givenWep.SetClip1 then givenWep:SetClip1(wepData.clip1) end
                            if givenWep.SetClip2 then givenWep:SetClip2(wepData.clip2) end
                        end
                    end
                end

                -- Cleanup NetVars
                if victim.SetNetVar then
                    victim:SetNetVar("BioSuicidePending", false)
                end

                victim:ScreenFade(SCREENFADE.IN, Color(0, 255, 100, 120), 0.6, 0)
            end)
        end)
    end)
end
