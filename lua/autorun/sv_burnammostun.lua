if SERVER then
    -------------------------------------------------------------------
    -- BIO ENERGY AMMO POOL TABLE
    -------------------------------------------------------------------
    local BIO_ENERGY_AMMO_POOL = {
        ["7.62x39 mm Incendiary Energy"] = true,
    }

   local REQUIRED_SHOTS = {
        ["7.62x39 mm Incendiary Energy"] = 3,
	}

    -------------------------------------------------------------------
    -- ELECTRIC / ENERGY STUN HOOK (HOMIGRAD / LUA BULLET COMPATIBLE)
    -------------------------------------------------------------------
	 
	local trackVarName = "stunTag"
    hook.Add("PostEntityFireBullets", "IncedinaryAmmoStunEnergyPool", function(entity, bulletData)
        if not bulletData or not bulletData.Trace then return end

        local tr = bulletData.Trace
        local target = tr.Entity
        if not IsValid(target) then return end
		
		
        -- 1. Resolve real target player (Handles Homigrad ragdolls)
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

        if not IsValid(ply) or not ply:Alive() then return end

        -- 2. Resolve Ammo Name
        local ammoName = bulletData.AmmoType
        if isnumber(ammoName) then
            ammoName = game.GetAmmoName(ammoName)
        end

        -- Fallback check via active weapon if AmmoType wasn't explicitly set in tInfo
        if not ammoName or ammoName == "" then
            local attacker = bulletData.Attacker or entity
            if IsValid(attacker) and attacker:IsPlayer() then
                local wep = attacker:GetActiveWeapon()
                if IsValid(wep) then
                    local ammoID = wep:GetPrimaryAmmoType()
                    ammoName = (wep.GetStat and wep:GetStat("Primary.Ammo"))
                            or (wep.Primary and wep.Primary.Ammo)
                            or (ammoID and game.GetAmmoName(ammoID))
                end
            end
        end

        -- Verify ammo is in the energy pool
        if not ammoName or not BIO_ENERGY_AMMO_POOL[ammoName] then return end

        -- 3. Apply Homigrad Stun Effect
		
		
		local org = ply.organism
        if hg and hg.LightStunPlayer and ply:GetNetVar(trackVarName, 0) >= REQUIRED_SHOTS[ammoName] then
            hg.LightStunPlayer(ply, 0.5)
			ply:Ignite(4, 0)
			ply:SetNetVar(trackVarName, 0)
		else 
			local current = ply:GetNetVar(trackVarName, 0)
			ply:SetNetVar(trackVarName, current + 1)
        end
    end)
end