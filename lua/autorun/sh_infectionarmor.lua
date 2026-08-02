if SERVER then AddCSLuaFile() end

--[[ ====================== CLIENT VISION ====================== ]]
if CLIENT then
    local vision_light = nil

    local function UpdateHFNV()
        print("HF NV (Red) Activated")

        local ply = LocalPlayer()
        if not IsValid(ply) or ply.PlayerClassName == "goober" or not ply:Alive() or not ply:GetNetVar("WearingHFMask", false) then
            hook.Remove("RenderScreenspaceEffects", "HFNvVision_Always")
            hook.Remove("PreDrawHalos", "HFNvVision_Halos")
            if IsValid(vision_light) then
                vision_light:Remove()
                vision_light = nil
            end
            return
        end

        -- Red Color Correction + Bloom
        hook.Add("RenderScreenspaceEffects", "HFNvVision_Always", function()
            local p = LocalPlayer()
            if p.PlayerClassName == "goober" or not p:GetNetVar("WearingHFMask", false) then return end

            local cc = {
                ["$pp_colour_addr"] = 0.08,
                ["$pp_colour_addg"] = 0.01,
                ["$pp_colour_addb"] = 0,
                ["$pp_colour_brightness"] = 0.05,
                ["$pp_colour_contrast"] = 0.25,
                ["$pp_colour_colour"] = 0.55,
                ["$pp_colour_mulr"] = 0.25,
                ["$pp_colour_mulg"] = 0.02,
                ["$pp_colour_mulb"] = 0.01
            }
            DrawColorModify(cc)
            DrawBloom(0.04, 0.45, 1.4, 1.4, 0.8, 0.3, 1, 0.2, 0.1)
        end)
		
		-- Halos: Goobers (Players & NPCs) = bright red threat, Humans = soft white/blue
        hook.Add("PreDrawHalos", "HFNvVision_Halos", function()
            local p = LocalPlayer()
            if p.PlayerClassName == "goober" or not p:GetNetVar("WearingHFMask", false) then return end

            local humans = {}
			local goobers = {}

			-------------------------------------------------------------------
			-- 1. ACTIVE PLAYERS (Standing up / Active)
			-------------------------------------------------------------------
			for _, p in ipairs(player.GetAll()) do
				if not IsValid(p) or not p:Alive() then continue end

				-- Skip cloaked players
				if p:GetNWBool("IsCloaked", false) then continue end

				-- If player is currently ragdolled/downed in Homigrad, skip their 
				-- player model so we don't draw overlapping halos (handled in step 2)
				local isRagdolled = (p.IsRagdolled and p:IsRagdolled()) or IsValid(p:GetNWEntity("ragdoll"))
				if isRagdolled then continue end

				if p.PlayerClassName == "goober" then
					table.insert(goobers, p)
				else
					table.insert(humans, p)
				end
			end

			-------------------------------------------------------------------
			-- 2. RAGDOLLS (Homigrad downed / unconscious / dead bodies)
			-------------------------------------------------------------------
			for _, rag in ipairs(ents.FindByClass("prop_ragdoll")) do
				if not IsValid(rag) then continue end

				-- Resolve owner of the ragdoll
				local owner = nil
				if IsValid(rag.Player) then
					owner = rag.Player
				elseif IsValid(rag:GetNWEntity("RagdollOwner")) then
					owner = rag:GetNWEntity("RagdollOwner")
				elseif IsValid(rag:GetNWEntity("ragdollOwner")) then
					owner = rag:GetNWEntity("ragdollOwner")
				elseif hg and hg.RagdollOwner then
					local hgOwner = hg.RagdollOwner(rag)
					if IsValid(hgOwner) then owner = hgOwner end
				end

				-- If the owner is cloaked, don't reveal their ragdoll
				if IsValid(owner) and owner:GetNWBool("IsCloaked", false) then continue end

				-- Insert the RAGDOLL entity itself into the halo table
				if IsValid(owner) and owner.PlayerClassName == "goober" then
					table.insert(goobers, rag)
				else
					-- Human ragdoll (or unowned dead body)
					table.insert(humans, rag)
				end
			end

			-------------------------------------------------------------------
			-- 3. DRAW HALOS
			-------------------------------------------------------------------
			-- Humans (Green - ignoreZ = true draws through walls)
			if #humans > 0 then
				halo.Add(humans, Color(50, 255, 50), 2, 2, 1, true, true)
			end

			-- Goobers Red - ignoreZ = true draws through walls)
			if #goobers > 0 then
				halo.Add(goobers, Color(255, 50, 50), 2, 2, 1, true, true)
			end
        end)

        -- Red-tinted projected light
        hook.Add("Think", "HFNvVision_Light", function()
            local p = LocalPlayer()
            if p.PlayerClassName == "goober" or not p:GetNetVar("WearingHFMask", false) then
                if IsValid(vision_light) then
                    vision_light:Remove()
                    vision_light = nil
                end
                return
            end

            if not IsValid(vision_light) then
                vision_light = ProjectedTexture()
                vision_light:SetTexture("effects/flashlight001")
                vision_light:SetBrightness(0.65)
                vision_light:SetEnableShadows(false)
                vision_light:SetFOV(105)
                vision_light:SetNearZ(8)
                vision_light:SetFarZ(1100)
            end

            vision_light:SetColor(Color(255, 80, 60))  -- Reddish
            vision_light:SetPos(p:EyePos() + p:EyeAngles():Forward() * 25)
            vision_light:SetAngles(p:EyeAngles())
            vision_light:Update()
        end)
    end

    -- NetVar Watcher
    hook.Add("Think", "HFNvVision_NetVarWatcher", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        local wearing = ply:GetNetVar("WearingHFMask", false)
        if ply.hfNVActive == nil then ply.hfNVActive = false end

        if wearing and not ply.hfNVActive then
            ply.hfNVActive = true
            UpdateHFNV()
        elseif not wearing and ply.hfNVActive then
            ply.hfNVActive = false
            hook.Remove("RenderScreenspaceEffects", "HFNvVision_Always")
            hook.Remove("PreDrawHalos", "HFNvVision_Halos")
            hook.Remove("Think", "HFNvVision_Light")
            if IsValid(vision_light) then
                vision_light:Remove()
                vision_light = nil
            end
        end
    end)
end

--[[ ====================== SERVER SYNC ====================== ]]
if SERVER then
    hook.Add("Org Think", "SyncAntiInfectedArmorNetVars", function(owner, org, timeValue)
        if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() then return end

        if (owner.nextArmorCheck or 0) > CurTime() then return end
        owner.nextArmorCheck = CurTime() + 0.5

        local armors = owner.armors or (owner.GetNetVar and owner:GetNetVar("Armor"))
        local isAntiInfected = false
        local totalReduction = 0
        local wearingMask = false

        if armors and istable(armors) and hg and hg.armor then
            for slot, armorKey in pairs(armors) do
                local armorData = hg.armor and hg.armor[slot] and hg.armor[slot][armorKey]
                if armorData and armorData.isAntiInfected then
                    isAntiInfected = true
                    totalReduction = totalReduction + (armorData.assimilationReduction or 0)

                    if slot == "face" then
                        wearingMask = true
                    end
                end
            end
        end

        -- Sync NetVars
        if owner.SetNetVar then
            owner:SetNetVar("InAntiInfectedArmor", isAntiInfected)
            owner:SetNetVar("AssimilationReduction", totalReduction)
            owner:SetNetVar("WearingHFMask", wearingMask)
        end
    end)
end