-- ZCity: Custom Playermodel Ragdoll Full Fix v2 (Short-Limb / Robloxian Compatible)
if CLIENT then return end

hook.Add("InitPostEntity", "ZCity_PM_FullFix_Init", function()
    if not hg then return end

    -------------------------------------------------------------------
    -- Mass reference
    -------------------------------------------------------------------
    local hl2MassTable = {
        ["ValveBiped.Bip01_Pelvis"]   = 14.0,
        ["ValveBiped.Bip01_Spine2"]  = 26.0,
        ["ValveBiped.Bip01_Head1"]   = 9.0,
        ["ValveBiped.Bip01_R_Thigh"] = 10.0,
        ["ValveBiped.Bip01_L_Thigh"] = 10.0,
        ["ValveBiped.Bip01_R_Calf"]  = 5.0,
        ["ValveBiped.Bip01_L_Calf"]  = 5.0,
        ["ValveBiped.Bip01_R_Foot"]  = 3.0,
        ["ValveBiped.Bip01_L_Foot"]  = 3.0,
        ["ValveBiped.Bip01_R_UpperArm"] = 3.5,
        ["ValveBiped.Bip01_L_UpperArm"] = 3.5,
        ["ValveBiped.Bip01_R_Forearm"]  = 3.0,
        ["ValveBiped.Bip01_L_Forearm"]  = 3.0,
        ["ValveBiped.Bip01_R_Hand"]    = 2.0,
        ["ValveBiped.Bip01_L_Hand"]    = 2.0,
    }

    -------------------------------------------------------------------
    -- Expanded bone fallbacks
    -------------------------------------------------------------------
    local defaultBonesFallback = {
        [0]  = {"ValveBiped.Bip01_Pelvis", "pelvis", "root", "HumanoidRootNode", "RootPart", "LowerTorso", "Torso", "hip", "hips"},
        [1]  = {"ValveBiped.Bip01_Spine2", "spine2", "spine", "UpperTorso", "Spine1", "Spine2", "Chest"},
        [2]  = {"ValveBiped.Bip01_R_UpperArm", "r_upperarm", "bip_r_upperarm", "RightUpperArm", "RightArm", "Right Arm"},
        [3]  = {"ValveBiped.Bip01_L_UpperArm", "l_upperarm", "bip_l_upperarm", "LeftUpperArm", "LeftArm", "Left Arm"},
        [4]  = {"ValveBiped.Bip01_L_Forearm", "l_forearm", "bip_l_forearm", "LeftLowerArm", "LeftForearm"},
        [5]  = {"ValveBiped.Bip01_L_Hand", "l_hand", "hand_l", "LeftHand", "Left Hand"},
        [6]  = {"ValveBiped.Bip01_R_Forearm", "r_forearm", "bip_r_forearm", "RightLowerArm", "RightForearm"},
        [7]  = {"ValveBiped.Bip01_R_Hand", "r_hand", "hand_r", "RightHand", "Right Hand"},
        [8]  = {"ValveBiped.Bip01_R_Thigh", "r_thigh", "bip_r_thigh", "RightUpperLeg", "RightLeg", "Right Leg"},
        [9]  = {"ValveBiped.Bip01_R_Calf", "r_calf", "bip_r_calf", "RightLowerLeg", "RightCalf"},
        [10] = {"ValveBiped.Bip01_Head1", "head", "bip_head", "Head"},
        [11] = {"ValveBiped.Bip01_L_Thigh", "l_thigh", "bip_l_thigh", "LeftUpperLeg", "LeftLeg", "Left Leg"},
        [12] = {"ValveBiped.Bip01_L_Calf", "l_calf", "bip_l_calf", "LeftLowerLeg", "LeftCalf"},
        [13] = {"ValveBiped.Bip01_L_Foot", "l_foot", "foot_l", "LeftFoot", "Left Foot"},
        [14] = {"ValveBiped.Bip01_R_Foot", "r_foot", "foot_r", "RightFoot", "Right Foot"},
    }

    -------------------------------------------------------------------
    -- realPhysNum (same as before)
    -------------------------------------------------------------------
    function hg.realPhysNum(ragdoll, physNumber)
        if not IsValid(ragdoll) then return 0 end
        local model = ragdoll:GetModel()
        local boneList = defaultBonesFallback[physNumber] or {"ValveBiped.Bip01_Pelvis"}

        if hg.cachedmodels and hg.cachedmodels[model] then
            for _, boneName in ipairs(boneList) do
                if hg.cachedmodels[model][boneName] then
                    return hg.cachedmodels[model][boneName]
                end
            end
        end

        if hg.cacheModel then hg.cacheModel(ragdoll) end

        if hg.cachedmodels and hg.cachedmodels[model] then
            for _, boneName in ipairs(boneList) do
                if hg.cachedmodels[model][boneName] then
                    return hg.cachedmodels[model][boneName]
                end
            end
        end

        for _, boneName in ipairs(boneList) do
            local boneIdx = ragdoll:LookupBone(boneName)
            if boneIdx then
                local physIdx = ragdoll:TranslateBoneToPhysBone(boneIdx)
                if physIdx and physIdx >= 0 then return physIdx end
            end
        end
        return 0
    end

    -------------------------------------------------------------------
    -- Mass-aware ShadowControl with short-limb boost
    -------------------------------------------------------------------
    local shadowparams = {}
    function hg.ShadowControl(ragdoll, physNumber, ss, ang, maxang, maxangdamp, pos, maxspeed, maxspeeddamp)
        if not IsValid(ragdoll) then return end
        physNumber = hg.realPhysNum(ragdoll, physNumber) or 0
        local phys = ragdoll:GetPhysicsObjectNum(physNumber)
        if not IsValid(phys) then return end

        local mass = phys:GetMass()
        local massRatio = math.Clamp(mass / 8.0, 0.4, 4.5)

        -- Short-limb boost (detected once and stored on the ragdoll)
        local shortLimbMul = ragdoll._zcity_shortlimb or 1.0

        shadowparams.secondstoarrive = ss or 0.05
        shadowparams.angle           = ang
        shadowparams.maxangular      = maxang and (maxang * (ragdoll.power or 1) * massRatio * shortLimbMul)
        shadowparams.maxangulardamp  = maxangdamp and (maxangdamp * massRatio)
        shadowparams.pos             = pos
        shadowparams.maxspeed        = maxspeed and (maxspeed * (ragdoll.power or 1) * massRatio * shortLimbMul)
        shadowparams.maxspeeddamp    = maxspeeddamp and (maxspeeddamp * massRatio)
        shadowparams.dampfactor      = 0.9

        phys:Wake()
        phys:ComputeShadowControl(shadowparams)
    end

    -------------------------------------------------------------------
    -- Ragdoll_Create sanitizer + short-limb detection
    -------------------------------------------------------------------
    hook.Add("Ragdoll_Create", "ZCity_Fix_PhysicsSanitizer", function(ply, ragdoll)
        if not IsValid(ragdoll) then return end
        local physCount = ragdoll:GetPhysicsObjectCount()
        if physCount <= 0 then return end

        local IdealMass = hg.IdealMassPlayer or {}
        local currentTotalMass = 0

        -- Detect short thighs (Robloxian / chibi style)
        local thighLen = 20
        local thighBone = ragdoll:LookupBone("ValveBiped.Bip01_L_Thigh") or ragdoll:LookupBone("ValveBiped.Bip01_R_Thigh")
        if thighBone then
            local parent = ragdoll:GetBoneParent(thighBone)
            if parent and parent >= 0 then
                local pos1 = ragdoll:GetBonePosition(thighBone)
                local pos2 = ragdoll:GetBonePosition(parent)
                if pos1 and pos2 then
                    thighLen = pos1:Distance(pos2)
                end
            end
        end

        -- If thighs are shorter than ~8 units → short-limb model
        ragdoll._zcity_shortlimb = (thighLen < 8) and 2.8 or 1.0

        for i = 0, physCount - 1 do
            local phys = ragdoll:GetPhysicsObjectNum(i)
            if not IsValid(phys) then continue end

            local boneIdx  = ragdoll:TranslatePhysBoneToBone(i)
            local boneName = (boneIdx and boneIdx >= 0) and ragdoll:GetBoneName(boneIdx) or ""

            local targetMass = IdealMass[boneName] or hl2MassTable[boneName] or math.Clamp(phys:GetMass(), 2.0, 16.0)
            phys:SetMass(targetMass)
            phys:SetDamping(1.2, 5.0)   -- even lower angular damping for short limbs
            currentTotalMass = currentTotalMass + targetMass
        end

        -- Total mass balance
        if currentTotalMass > 0 then
            local scale = math.Clamp(90.0 / currentTotalMass, 0.25, 3.5)
            for i = 0, physCount - 1 do
                local phys = ragdoll:GetPhysicsObjectNum(i)
                if IsValid(phys) then
                    phys:SetMass(math.Clamp(phys:GetMass() * scale, 1.5, 32.0))
                end
            end
        end

        -- No self-collision
        if not ragdoll._zcity_nocollide then
            ragdoll._zcity_nocollide = true
            for i = 0, physCount - 1 do
                for j = i + 1, physCount - 1 do
                    constraint.NoCollide(ragdoll, ragdoll, i, j)
                end
            end
        end
    end)

    -------------------------------------------------------------------
    -- Self-damage filter
    -------------------------------------------------------------------
    hook.Add("Ragdoll Collide", "ZCity_Fix_PreventSelfDamage", function(ragdoll, data)
        if IsValid(ragdoll) and data.HitEntity == ragdoll then return true end
    end)

    -------------------------------------------------------------------
    -- Aggressive sit-up / head-lift for short-limb models
    -------------------------------------------------------------------
    local shadowControl = hg.ShadowControl
	local realPhysNum   = hg.realPhysNum

	hook.Add("Think", "ZCity_PM_SitUpBoost", function()
		for _, ply in player.Iterator() do
			local ragdoll = (hg.ragdollFake and hg.ragdollFake[ply]) or ply.FakeRagdoll
			if not IsValid(ragdoll) or not ply:Alive() then continue end

			local org = ply.organism
			if not org or not org.canmove then continue end

			local wep = ply:GetActiveWeapon()
			local angles = ply:EyeAngles()
			local shortMul = ragdoll._zcity_shortlimb or 1.0

			-- Pure E-key sit-up (the main problem case)
			local pureE = ply:KeyDown(IN_USE) 
					   and not ply:KeyDown(IN_FORWARD) 
					   and not ply:KeyDown(IN_BACK)
					   and not ply:KeyDown(IN_DUCK)
					   and not ply:KeyDown(IN_ATTACK2)
					   and not (ishgweapon(wep) and wep.IsResting and wep:IsResting())

			local wantsSitUp = pureE
							or ply:KeyDown(IN_USE)
							or ply:KeyDown(IN_FORWARD)
							or ply:KeyDown(IN_BACK)
							or ply:KeyDown(IN_DUCK)
							or (angles.p < -12)
							or (ishgweapon(wep) and (ply:KeyDown(IN_ATTACK2) or (wep.IsResting and wep:IsResting())))
							or (IsValid(wep) and wep.ismelee and (ply:KeyDown(IN_ATTACK2) or ply:KeyDown(IN_ATTACK)))
							or hg.RagdollCombatInUse(ply)
							or (ply:InVehicle() and not ply:KeyDown(IN_USE))

			if not wantsSitUp then continue end

			local pelvisPhys = ragdoll:GetPhysicsObjectNum(realPhysNum(ragdoll, 0))
			local spinePhys  = ragdoll:GetPhysicsObjectNum(realPhysNum(ragdoll, 1))
			local headPhys   = ragdoll:GetPhysicsObjectNum(realPhysNum(ragdoll, 10))

			if not IsValid(pelvisPhys) or not IsValid(spinePhys) then continue end

			local pelvisPos = pelvisPhys:GetPos()

			-- ========== SPINE (main sit-up) ==========
			local anglSpine = Angle(0, 0, 0)
			anglSpine:Set(angles)

			if pureE then
				-- Special pure-E pose: lean torso more upright
				anglSpine:RotateAroundAxis(anglSpine:Right(), 15)
			elseif ply:KeyDown(IN_DUCK) then
				anglSpine:RotateAroundAxis(anglSpine:Right(), 35)
			end

			anglSpine:RotateAroundAxis(anglSpine:Forward(), 90)
			anglSpine:RotateAroundAxis(anglSpine:Up(), 90)
			anglSpine:RotateAroundAxis(anglSpine:Forward(), (ishgweapon(wep) and not wep:IsPistolHoldType()) and 120 or 180)
			anglSpine:RotateAroundAxis(anglSpine:Up(), (ishgweapon(wep) and wep.IsResting and wep:IsResting()) and (50 - angles.p) or 0)

			-- Higher lift target for short limbs
			local liftAmount = pureE and (32 * shortMul) or (26 * shortMul)
			local targetSpinePos = pelvisPos + Vector(0, 0, liftAmount) + angles:Forward() * (8 * shortMul)

			-- Extremely high torque when pure E is held
			local torque = pureE and (8500 * shortMul) or (5500 * shortMul)
			local damp   = pureE and 280 or 400

			shadowControl(ragdoll, 1, 0.03, anglSpine, torque, damp, targetSpinePos, 2200 * shortMul, 180)

			-- Extra direct upward force while holding E (helps short thighs)
			if pureE and IsValid(spinePhys) then
				local upForce = Vector(0, 0, 4500 * shortMul * (ragdoll.power or 1))
				spinePhys:ApplyForceCenter(upForce)
			end

			-- ========== HEAD ==========
			if org.canmovehead and IsValid(headPhys) then
				local anglHead = Angle(0, 0, 0)
				anglHead:Set(angles)

				if pureE or ply:KeyDown(IN_DUCK) or angles.p < -12 then
					anglHead:RotateAroundAxis(anglHead:Right(), -100)
				end

				anglHead:RotateAroundAxis(anglHead:Forward(), 90)
				anglHead:RotateAroundAxis(anglHead:Up(), 90)

				local targetHeadPos = pelvisPos + Vector(0, 0, 48 * shortMul) + angles:Forward() * (12 * shortMul)
				local headTorque = pureE and (9000 * shortMul) or (6500 * shortMul)

				shadowControl(ragdoll, 10, 0.03, anglHead, headTorque, 450, targetHeadPos, 2500 * shortMul, 220)
			end
		end
	end)
end)