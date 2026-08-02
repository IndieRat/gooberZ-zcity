if SERVER then AddCSLuaFile() end

-- Helper clamp function fallback (handles math.clamp or math.Clamp)
math.clamp = math.clamp or math.Clamp or function(val, min, max)
    return math.max(min, math.min(max, val))
end

-- Default model path
hg = hg or {}
hg.GooberModel = hg.GooberModel or "models/eradium/protogen_player.mdl"


-- ====================================================================
-- CLIENT-SIDE SCREEN OVERLAY
-- ====================================================================
if CLIENT then
    -- ====================================================================
    -- SHARED DRAWING HELPER
    -- Keeps background boxes and borders 100% consistent across all UI
    -- ====================================================================
    local function DrawUIBox(x, y, w, h)
        -- Outer Border
        draw.RoundedBox(4, x - 1, y - 1, w + 2, h + 2, Color(60, 60, 60, 200))
        -- Inner Background
        draw.RoundedBox(4, x, y, w, h, Color(10, 10, 10, 240))
    end

    -- ====================================================================
    -- 1. ATTACKER HUD (GOOBER SIDE)
    -- ====================================================================
    local function DrawGooberAttackerHUD()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end

        -- Only run for Goobers
        if ply.PlayerClassName ~= "goober" then return end

        -- Check if currently carrying an entity
        local carryent = ply:GetNetVar("carryent")
        if not IsValid(carryent) then return end

        -- Resolve target
        local victim = (hg and hg.RagdollOwner and hg.RagdollOwner(carryent)) or carryent.Player
        if not IsValid(victim) or not victim:Alive() or victim.PlayerClassName == "goober" then return end

        local maxVal = victim:GetNetVar("MaxAssimilation", 100)
        local progress = victim:GetNetVar("AssimilationProgress", 0)

        -- Dimensions & Positioning
        local screenW, screenH = ScrW(), ScrH()
        local barWidth = 320
        local barHeight = 22
        local paddingX, paddingY = 16, 12

        local containerW = barWidth + (paddingX * 2)
        local containerH = barHeight + 36 + paddingY
        local containerX = (screenW / 2) - (containerW / 2)
        local containerY = screenH * 0.72

        local fraction = math.Clamp(progress / maxVal, 0, 1)
        local percentage = math.floor(fraction * 100)

        -- Container Box
        DrawUIBox(containerX, containerY, containerW, containerH)

        -- Header Text (Victim Name)
        local headerText = "CONVERTING: " .. string.upper(victim:Nick())
        draw.SimpleText(headerText, "DermaDefaultBold", screenW / 2, containerY + paddingY, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        -- Progress Bar Track
        local barX = containerX + paddingX
        local barY = containerY + paddingY + 22
        draw.RoundedBox(4, barX, barY, barWidth, barHeight, Color(30, 30, 30, 255))

        -- Progress Bar Fill (Green Tint)
        local fillWidth = barWidth * fraction
        if fillWidth > 0 then
            draw.RoundedBox(4, barX, barY, fillWidth, barHeight, Color(75, 205, 90, 255))
        end

        -- Progress Bar Text
        local statusText = percentage .. "% (" .. math.floor(progress) .. " / " .. maxVal .. ")"
        draw.SimpleText(statusText, "DermaDefaultBold", screenW / 2, barY + (barHeight / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    hook.Add("HUDPaint", "GooberAttackerHUD", DrawGooberAttackerHUD)

    -- ====================================================================
    -- 2. VICTIM OVERLAY & HUD (HUMAN SIDE)
    -- ====================================================================
    local function DrawInfectionOverlay()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end

        local maxVal = ply:GetNetVar("MaxAssimilation", 100)
        local progress = ply:GetNetVar("AssimilationProgress", 0)

        if progress <= 0 or maxVal <= 0 then return end

        local screenW, screenH = ScrW(), ScrH()

        -- Player Color Setup
        local plrColorVec = ply:GetPlayerColor() or Vector(1, 0.2, 0.2)
        local r, g, b = plrColorVec.x * 255, plrColorVec.y * 255, plrColorVec.z * 255

        local fraction = math.Clamp(progress / maxVal, 0, 1)
        local percentage = math.floor(fraction * 100)

        -- ----------------------------------------------------------------
        -- Subtle Screen Edge Tint (Prevents blocking full screen vision completely)
        -- ----------------------------------------------------------------
        local alpha = fraction * 160
        surface.SetDrawColor(r, g, b, alpha * 0.3)
        surface.DrawRect(0, 0, screenW, screenH)

        -- ----------------------------------------------------------------
        -- Matching HUD Container
        -- ----------------------------------------------------------------
        local barWidth = 320
        local barHeight = 22
        local paddingX, paddingY = 16, 12

        local containerW = barWidth + (paddingX * 2)
        local containerH = barHeight + 36 + paddingY
        local containerX = (screenW / 2) - (containerW / 2)
        local containerY = screenH * 0.72

        -- Main Container Box
        DrawUIBox(containerX, containerY, containerW, containerH)

        -- Header Warning Text
        draw.SimpleText("ASSIMILATION IN PROGRESS", "DermaDefaultBold", screenW / 2, containerY + paddingY, Color(230, 80, 80, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        -- Progress Bar Track
        local barX = containerX + paddingX
        local barY = containerY + paddingY + 22
        draw.RoundedBox(4, barX, barY, barWidth, barHeight, Color(30, 30, 30, 255))

        -- Progress Bar Fill (Infection Tint)
        local fillWidth = barWidth * fraction
        if fillWidth > 0 then
            draw.RoundedBox(4, barX, barY, fillWidth, barHeight, Color(r, g, b, 220))
        end

        -- Progress Bar Text
        local statusText = percentage .. "% (" .. math.floor(progress) .. " / " .. maxVal .. ")"
        draw.SimpleText(statusText, "DermaDefaultBold", screenW / 2, barY + (barHeight / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    hook.Add("HUDPaint", "DrawGooberInfectionOverlay", DrawInfectionOverlay)
end

-- ====================================================================
-- SERVER-SIDE LOGIC & COMMANDS
-- ====================================================================

local purposefulQuotesInfected = {
   "Mrgmm--I can't, they like me here..",
   "What--What a strange impulse I had.. I'm okay though, we all are..",
   "Maybe.. Maybe I'm happy? And want to live.. To be there when more members join..",
   "I.. I don't want to die.. Want.. To live.. To give..",
   "They need my tone.. my hum.. I contribute..",
   "So much more to be done.. to be made.. to be the rebirther..",
}

local horrorOfInfection = {
    "That could've--That could've been me!",
	"Dear god! You're changing! What-- What are you?",
	"Hello? Hello! Nevermind, it's useless!",
	"Why do I feel like I am next.. Am I?",
	"Goodbye.. If you're still there.",
	"No, no, no, no! This is a nightmare!",
	"I wish I never had witness that..."
}

local moreOfInfection = {
  "Ooo! The new one has such.. interesting thoughts..",
  "It's almost like a instinctual shiver, when we hear a tone in the frequency..",
  "Our community is growing.. more thoughts.. more bodies..",
  "It's not all bad.. You get to have us..",
  "All these fun games from the bald ones!",
  "You look like us now!"
}

local selfInfectionTalk = {
   "My head... So many echos.. What are they saying?",
   "I'm sorry.. But.. They.. They are right..",
   "I feel... Funny... Heavier... So many voices",
   "Who--I.. I.. I like this..",
   "Am I dead... No... I'm... alive?",
   "Why- Why do I feel so noticed.."
}

hook.Add("Org Think", "generalGooberImportantShit", function(owner, org, timeValue)
    if not owner:IsPlayer() or not owner:Alive() then return end
    if owner.PlayerClassName == "goober" then  
		local currentVal = owner:GetNetVar("AssimilationProgress", 0)
		if currentVal > 0 then
			owner:SetNetVar("AssimilationProgress", 0)
		end
		
		if owner.suiciding then
			owner.suiciding = false
			owner:ChatPrint(purposefulQuotesInfected[math.random(1, #purposefulQuotesInfected)])
		end
	else
		if SERVER then
			if owner.SetNetVar then
				local maxValue = owner:GetNetVar("MaxAssimilation", 100)
				local currentVal = owner:GetNetVar("AssimilationProgress", 0)
				
				-- Check if armor reduction is active and decay existing assimilation
				local reduction = owner:GetNetVar("AssimilationReduction", 0)
				
				if reduction > 0 and currentVal > 0 then
					-- Decay rate scales based on time and reduction percentage (e.g., 10 units/sec at 100% reduction)
					local decayAmount = timeValue * 10 * reduction
					currentVal = math.max(0, currentVal - decayAmount)
					owner:SetNetVar("AssimilationProgress", currentVal)
				end

				-- Conversion check
				if currentVal >= maxValue then
					if owner.SetPlayerClass then
						AssimilatePlayer(owner)
						owner:SetNetVar("AssimilationProgress", 0)
						owner:ChatPrint(selfInfectionTalk[math.random(1, #selfInfectionTalk)])
						local nearbyEnts = ents.FindInSphere(owner:GetPos(), 400)
						for _, ent in ipairs(nearbyEnts) do
							if IsValid(ent) and ent:IsPlayer() and ent ~= owner then
												
								if ent.PlayerClassName ~= "goober" and ent.PlayerClassName ~= "traitor" then
									ent:ChatPrint(horrorOfInfection[math.random(1, #horrorOfInfection)])
									
									if ent.organism then
										local org = ent.organism
										if org.adrenaline < 3.2 then
											org.adrenaline = org.adrenaline + 3.2
										end
									end	
								else 
									ent:ChatPrint(moreOfInfection[math.random(1, #moreOfInfection)])
												
									if ent.organism then
										local org = ent.organism
										if org.adrenaline < 1.9 then
											org.adrenaline = org.adrenaline + 1.9
										end
									end
								end
							end
						end
						
					end
				end
			end
		end
	end
    
  
end)

hook.Add("OnEntityCreated", "GooberZ_AdjustWaterPhysics", function(ent)
    -- Wait a frame for physics to initialize
    timer.Simple(0, function()
        if not IsValid(ent) then return end
        
        -- Check for target model path
		print(ent:GetModel())
        if ent:GetModel() == "models/player/leymirba/protogenpm.mdl" then
            local physCount = ent:GetPhysicsObjectCount()
            if physCount == 0 then return end

            for i = 0, physCount - 1 do
                local phys = ent:GetPhysicsObjectNum(i)
                if IsValid(phys) then
                    -- 1. Grab original mass of the specific bone
                    local currentMass = phys:GetMass()

                    -- 2. Cut mass in half.
                    local newMass = math.max(0.5, currentMass * 0.5)
                    phys:SetMass(newMass)

                    -- 3. Adjust Buoyancy Ratio (1.0 = Neutral float, 1.2 - 1.5 = Floats nicely)
                    phys:SetBuoyancyRatio(0.4)
                end
            end
        end
    end)
end)
-- Server command to update the model path
if SERVER then
    concommand.Add("gz_set_goober_model", function(ply, cmd, args)
        -- Admin check
        if IsValid(ply) and not ply:IsAdmin() then
			print("[GZ] Admin access required.")
			return
		end

        local newMdl = args[1]
        if not newMdl or newMdl == "" then
            print("[GZ] Current Model: " .. hg.GooberModel)
            return
        end

        -- Check if model file exists before setting
        if util.IsValidModel(newMdl) then
            hg.GooberModel = newMdl
            print("[GZ] Model updated to: " .. newMdl)
            if IsValid(ply) then
                ply:ChatPrint("[GZ] Model path updated to: " .. newMdl)
            end
        else
            if IsValid(ply) then
                ply:ChatPrint("[GZ] Invalid model path: " .. newMdl)
            end
        end
    end)
	
	concommand.Add("gz_set_max_assimilation", function(ply, cmd, args)
        -- Admin check
        if IsValid(ply) and not ply:IsAdmin() then
			print("[GZ] Admin access required.")
			return
		end

        local targetArg = args[1]
        local newMax = tonumber(args[2])

        if not targetArg or not newMax or newMax <= 0 then
            local msg = "[GZ] Usage: gz_setmaxassimilation <player_name / userid / * > <max_value>"
            if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
            return
        end

        -- Target handling
        if targetArg == "*" then
            -- Set max assimilation for all players on the server
            for _, p in ipairs(player.GetAll()) do
                if p.SetNetVar then
                    p:SetNetVar("MaxAssimilation", newMax)
                end
            end

            local msg = "[GZ] Set Max Assimilation to " .. newMax .. " for ALL players."
            if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
        else
            -- Search for specific player by name or UserID
            local targetPly = nil
            for _, p in ipairs(player.GetAll()) do
                if tostring(p:UserID()) == targetArg or string.find(string.lower(p:Nick()), string.lower(targetArg), 1, true) then
                    targetPly = p
                    break
                end
            end

            if IsValid(targetPly) then
                if targetPly.SetNetVar then
                    targetPly:SetNetVar("MaxAssimilation", newMax)
                end

                local msg = "[GZ] Set Max Assimilation to " .. newMax .. " for " .. targetPly:Nick()
                if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
            else
                local msg = "[GZ] Target player not found: " .. targetArg
                if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
            end
        end
    end)
	
	concommand.Add("gz_help_give_mass", function(ply, cmd, args)
        -- Admin authorization check
        if IsValid(ply) and not (ply:IsAdmin() or ply:IsSuperAdmin()) then
            ply:ChatPrint("[GooberZ] Admin only command.")
            return
        end

        local modelPath = args[1]
        if not modelPath or modelPath == "" then
            local msg = "[GooberZ] Usage: gz_help_give_mass \"models/path/to/model.mdl\""
            print(msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
            return
        end

        modelPath = string.lower(string.Trim(modelPath))

        -- Spawn temporary prop out of view
        local tempEnt = ents.Create("prop_physics")
        if not IsValid(tempEnt) then return end

        tempEnt:SetModel(modelPath)
        tempEnt:SetPos(Vector(0, 0, -10000))
        tempEnt:SetNoDraw(true)
        tempEnt:Spawn()

        local count = tempEnt:GetPhysicsObjectCount()

        -- Fallback to ragdoll if prop_physics produced no physics bones
        if count == 0 then
            tempEnt:Remove()
            tempEnt = ents.Create("prop_ragdoll")
            tempEnt:SetModel(modelPath)
            tempEnt:SetPos(Vector(0, 0, -10000))
            tempEnt:SetNoDraw(true)
            tempEnt:Spawn()
            count = tempEnt:GetPhysicsObjectCount()
        end

        -- Error handling if model has no valid physics mesh
        if count == 0 then
            local msg = "[GooberZ] Error: Could not retrieve physics objects for model: " .. modelPath
            print(msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
            if IsValid(tempEnt) then tempEnt:Remove() end
            return
        end

        local totalMass = 0
        local totalBuoyancy = 0

        for i = 0, count - 1 do
            local phys = tempEnt:GetPhysicsObjectNum(i)
            if IsValid(phys) then
                totalMass = totalMass + phys:GetMass()
                totalBuoyancy = totalBuoyancy + phys:GetBuoyancyRatio()
            end
        end

        local avgBuoyancy = totalBuoyancy / count

        -- Console readout
        local printOutput = string.format(
            "\n=========================================\n" ..
            " MODEL PHYSICS READOUT\n" ..
            " Model: %s\n" ..
            " Physics Objects / Bones: %d\n" ..
            " Total Mass: %.2f kg\n" ..
            " Avg Buoyancy Ratio: %.2f\n" ..
            "=========================================",
            modelPath, count, totalMass, avgBuoyancy
        )
        print(printOutput)

        -- In-game chat readout
        if IsValid(ply) then
            ply:ChatPrint(string.format("[GooberZ] %s | Bones: %d | Mass: %.2f kg | Buoyancy Ratio: %.2f", modelPath, count, totalMass, avgBuoyancy))
        end

        -- Clean up temporary entity
        tempEnt:Remove()
    end)
	
	concommand.Add("gz_spawn_goober", function(ply)
		if IsValid(ply) and not ply:IsAdmin() then return end
		local pos = IsValid(ply) and ply:GetEyeTrace().HitPos + Vector(0,0,10) or Vector(0,0,100)
		local npc = ents.Create("npc_goober")
		if IsValid(npc) then
			npc:SetPos(pos)
			npc:Spawn()
			print("[GooberZ] Spawned Goober NPC")
		end
	end)
	
	concommand.Add("gz_test_panic_range", function(ply)
		if IsValid(ply) and not ply:IsAdmin() then return end
		local nearbyEnts = ents.FindInSphere(ply:GetPos(), 400)
		for _, ent in ipairs(nearbyEnts) do
			if IsValid(ent) and ent:IsPlayer() then
				print("plr nearby")
								
				if ent.PlayerClassName ~= "goober" and ent.PlayerClassName ~= "traitor" then
					ent:ChatPrint(horrorOfInfection[math.random(1, #horrorOfInfection)])
					
					print(ent.organism)
					if ent.organism then
						local org = ent.organism
						if org.adrenaline < 3.2 then
							org.adrenaline = org.adrenaline + 3.2
						end
					end	
				else 
					ent:ChatPrint(moreOfInfection[math.random(1, #moreOfInfection)])
								
					if ent.organism then
						local org = ent.organism
						if org.adrenaline < 1.9 then
							org.adrenaline = org.adrenaline + 1.9
						end
					end
				end
			end
		end
	end)
end



