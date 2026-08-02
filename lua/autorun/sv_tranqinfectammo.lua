if SERVER then
    -------------------------------------------------------------------
    -- BIO ENERGY AMMO POOL TABLE
    -------------------------------------------------------------------
    local BIO_ENERGY_AMMO_POOL = {
        ["Assimlation Darts"] = true,
    }
	
	local stored = {
		["Assimlation Darts"] = 100,
	}
	
    -------------------------------------------------------------------
    -- ASSIMILATION / INFECTION HOOK (HOMIGRAD / LUA BULLET COMPATIBLE)
    -------------------------------------------------------------------
	local function ApplyDischarge(ply, ammoName)
		local totalTicks = 40       -- How many times the timer will run
		local tickInterval = 1       -- How many seconds between each tick
		local addPerTick = stored[ammoName] / totalTicks
		
		local timerId = "Discharge_Goober" .. ply:EntIndex()
	
		timer.Create(timerId, tickInterval, totalTicks, function()
			-- Stop the timer if the player disconnected or became invalid
			if not IsValid(ply) then
				if timer.Exists(timerId) then timer.Remove(timerId) end
				return
			end
			
			local progress = ply:GetNetVar("AssimilationProgress", 0)
			local maxValue = ply:GetNetVar("MaxAssimilation", 100)
			
			if progress < maxValue then
				-- Subtract the tick amount, keeping it safely at or above 0
				ply:SetNetVar("AssimilationProgress", math.max(0, progress + addPerTick))
			end
		end)
	
	end
	
    hook.Add("PostEntityFireBullets", "GooberBioDartAssimilationPool", function(entity, bulletData)
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
		
		print("BIO DART APPLY")

        -- 5. Assimilation Calculation
		ApplyDischarge(ply, ammoName)

        -- Screen Feedback Effect
        ply:ScreenFade(SCREENFADE.IN, Color(0, 255, 50, 100), 0.4, 0)
    end)
end