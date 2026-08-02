if SERVER then AddCSLuaFile() end

-- CLASS REGISTRATION
local CLASS = player.RegClass("goober")
CLASS.NoGloves = true

-- Table holding active converging processes
hg = hg or {}
hg.GooberModel = hg.GooberModel or "models/player/leymirba/protogenpm.mdl"
hg.convergingtwo = hg.convergingtwo or {}

-- Required materials and valid bone whitelist table
local whiteMaterial = Material("models/debug/debugwhite")
local validBones = {
    ["ValveBiped.Bip01_Pelvis"] = true,
    ["ValveBiped.Bip01_Spine"] = true,
    ["ValveBiped.Bip01_Spine1"] = true,
    ["ValveBiped.Bip01_Spine2"] = true,
    ["ValveBiped.Bip01_Spine4"] = true,
    ["ValveBiped.Bip01_Neck1"] = true,
    ["ValveBiped.Bip01_Head1"] = true,
    ["ValveBiped.Bip01_L_Clavicle"] = true,
    ["ValveBiped.Bip01_L_UpperArm"] = true,
    ["ValveBiped.Bip01_L_Forearm"] = true,
    ["ValveBiped.Bip01_L_Hand"] = true,
    ["ValveBiped.Bip01_R_Clavicle"] = true,
    ["ValveBiped.Bip01_R_UpperArm"] = true,
    ["ValveBiped.Bip01_R_Forearm"] = true,
    ["ValveBiped.Bip01_R_Hand"] = true,
    ["ValveBiped.Bip01_L_Thigh"] = true,
    ["ValveBiped.Bip01_L_Calf"] = true,
    ["ValveBiped.Bip01_L_Foot"] = true,
    ["ValveBiped.Bip01_L_Toe0"] = true,
    ["ValveBiped.Bip01_R_Thigh"] = true,
    ["ValveBiped.Bip01_R_Calf"] = true,
    ["ValveBiped.Bip01_R_Foot"] = true,
    ["ValveBiped.Bip01_R_Toe0"] = true,
}

-- ====================================================================
-- CLIENT DRAW CONVERSION FUNCTION
-- ====================================================================
if CLIENT then
    function hg.DrawConversionTwo(ent, ply)
        if not hg.convergingtwo[ply] then
            if IsValid(ply.mdlfur) then
                ply.mdlfur:Remove()
            end
            return
        end
        
        local startTime = hg.convergingtwo[ply]

        if not IsValid(ent) or not IsValid(ply) then
            hg.convergingtwo[ply] = nil
            return
        end
        
        -- Calculates progress linearly over 3 seconds
        local status = math.ease.OutSine(1 - math.Clamp((startTime - CurTime() + 3) / 3, 0, 1))
        
        if status >= 1 then
            hg.convergingtwo[ply] = nil
            if IsValid(ply.mdlfur) then
                ply.mdlfur:Remove()
            end
            return
        end
   
        if IsValid(ply.mdlfur) then
            local mdl = ply.mdlfur
            mdl:SetPos(ent:GetPos())
            mdl:SetupBones()
            ent:SetupBones()

            for i = 0, mdl:GetBoneCount() - 1 do
                local nam = ent:GetBoneName(i)
                if not validBones[nam] then continue end
                local bon = mdl:LookupBone(nam)
                if not bon then continue end
                local m1 = ent:GetBoneMatrix(i)

                if m1 and hg.bone_apply_matrix then
                    hg.bone_apply_matrix(mdl, bon, m1)
                end
            end
            mdl:DrawModel()
        end

      
    end

    -- Hook rendering logic into player & ragdoll draw cycles
    hook.Add("PostPlayerDraw", "DrawGooberConversionTwoPlayer", function(ply)
        local char = hg.GetCurrentCharacter and hg.GetCurrentCharacter(ply) or ply
        hg.DrawConversionTwo(char, ply)
    end)

    hook.Add("PostDrawPlayerRagdoll", "DrawGooberConversionTwoRagdoll", function(ply, ent)
        hg.DrawConversionTwo(ent, ply)
    end)
end

-- ====================================================================
-- CLASS DEFINITION
-- ====================================================================
function CLASS.Off(self)
    if CLIENT then return end

    if ApplyAppearance then
        ApplyAppearance(self, false, false, false, true)
    end
    
    if SERVER then
        if self.organism then
            self.organism.bloodtype = self.oldbloodtype or "o-"
        end
        
        if hg and hg.ClearArmorRestrictions then
            hg.ClearArmorRestrictions(self)
        end
    end
    
    if self.SetNetVar then
        self:SetNetVar("AssimilationProgress", 0)
        self:SetNetVar("carryent", nil)
    end
    
    self.JumpPowerMul = nil
    self.SpeedGainClassMul = nil
    self:SetNWInt("SpeedGainClassMul", nil)
    self.MeleeDamageMul = nil
    self.StaminaExhaustMul = nil
end

function CLASS.On(self, data)
    local currentMdl = hg.GooberModel

    if SERVER then
        if self.organism then
            self.oldbloodtype = self.organism.bloodtype
            self.organism.bloodtype = "unknown"
        end
		
    
        local Appearance = self.CurAppearance or {}
        Appearance.AAttachments = ""
        Appearance.AColthes = ""
        if self.SetNetVar then
            self:SetNetVar("Accessories", "")
        end
		

        self.CurAppearance = Appearance
        
        local oldName = Appearance.AName or ""
        self:SetNWString("PlayerName", oldName .. "?")
        Appearance.AName = oldName .. "?"
        
        
        self.JumpPowerMul = 1.5
        self.SpeedGainClassMul = 5
        self.StaminaExhaustMul = 0.5
        self:SetNWInt("SpeedGainClassMul", self.SpeedGainClassMul)
		
		hg.SetArmorRestrictions(self, {all = true})
    end
    
    if data and data.instant then
        if SERVER then
            self.JumpPowerMul = 1.5
            self.SpeedGainClassMul = 5
            self.StaminaExhaustMul = 0.5
            self:SetNWInt("SpeedGainClassMul", self.SpeedGainClassMul)
        end
        
        self:SetModel(currentMdl)
        self:SetSubMaterial()
        
        if self.SetNetVar then
            self:SetNetVar("Accessories", "")
        end
        
        for i = 1, self:GetFlexNum() - 1 do
            self:SetFlexWeight(i, 0)
        end
        
        return
    end

    if CLIENT then
        if IsValid(self.mdlfur) then
            self.mdlfur:Remove()
        end

        self.mdlfur = ClientsideModel(currentMdl)
        if IsValid(self.mdlfur) then
            self.mdlfur.GetPlayerColor = function() return self:GetPlayerColor() end
            self.mdlfur:SetNoDraw(true)
        end

        -- Trigger the new convergingtwo dynamic transition
        if hg and hg.convergingtwo then
            hg.convergingtwo[self] = CurTime()
        end
    end
    
    if hg and hg.Fake then
        hg.Fake(self, nil, true)
    end

    timer.Create("gooberlolol"..self:EntIndex(), 1.6, 1, function()
        if IsValid(self) then
            if hg then
                if hg.SavePoses then hg.SavePoses(self) end
                if hg.FakeUp then hg.FakeUp(self, true, true) end
            end
            
            self.JumpPowerMul = 1.5
            self.SpeedGainClassMul = 5
            self.StaminaExhaustMul = 0.5
            self:SetNWInt("SpeedGainClassMul", self.SpeedGainClassMul)
            
            self:SetModel(currentMdl)
            self:SetSubMaterial()
            
            if self.SetNetVar then
                self:SetNetVar("Accessories", "")
            end
            
            for i = 1, self:GetFlexNum() - 1 do
                self:SetFlexWeight(i, 0)
            end
            
            if hg then
                if hg.Fake then hg.Fake(self, nil, true) end
                if hg.ApplyPoses then hg.ApplyPoses(self) end
                if hg.organism and hg.organism.Clear and self.organism then
                    hg.organism.Clear(self.organism)
                end
            end

            if self.organism then
                self.oldbloodtype = self.organism.bloodtype
                self.organism.bloodtype = "unknown"
            end
        end
    end)
end

-- HANDS HOOK
function hookHands()
    local hands = weapons.GetStored("weapon_hands_sh")
    if not hands then return end

    local customClassInfo = {
        ["sc_infiltrator"] = {
            PrintName = "CQC",
            WepSelectIcon = Material("vgui/inventory/perk_quick_reload"),
            handsDesc = "infiltrator",
            Instructions = "beta test test beta"
        },
        ["furry"] = {
            PrintName = "Paws",
            WepSelectIcon = Material("zbattle/paw_hmcd.png"),
            handsDesc = "furry",
            Instructions = "LMB - raise paws\nRELOAD - lower paws\n\nIn the raised state:\nLMB - strike\nRMB - block\n\n<color=91,121,229>As a bearer of a pathowogen infection, you have new abilities.\n\nIn lowered state, hold RMB to grab uninfected prey, then hold LMB to assimilate them.\n\nYou can press LMB to lick your fellow mates, doing so helps them alleviate their pain.\n\n:3<color=180,180,180>"
        },
        ["headcrabzombie"] = {
            PrintName = "Claws",
            WepSelectIcon = Material("vgui/wep_jack_hmcd_zombhands"),
            handsDesc = "zombie",
            Instructions = "LMB - strike\nRMB - block/grab player\n\n<color=150,0,0>These are your zombified hands. They're no energy sword, but they still pack a wallop."
        },
        ["goober"] = {
            PrintName = "Goober Paws",
            WepSelectIcon = Material("zbattle/paw_hmcd.png"),
            handsDesc = "goober",
            Instructions = "LMB - raise paws\nRELOAD - lower paws\n\nIn the raised state:\nLMB - strike\nRMB - block\n\nIn lowered state, hold RMB to stun and grab prey.\nWhile holding prey, you'll assimilate them."
        }
    }
	
	local targetArmors = {
		["ent_armor_anti_infected_mask"] = true,
		["ent_armor_anti_infected_helmet"] = true,
		["ent_armor_anti_infected_vest"] = true
	}
	
	local requiredHits = {
		["anti_infected_mask"] = 7,
		["anti_infected_helmet"] = 5,
		["anti_infected_vest"] = 5
	}

    -- Cache default weapon values
   local origPrintName = hands.PrintName or "Hands"
    local origInstructions = hands.Instructions or ""
    local origWepSelectIcon = hands.WepSelectIcon
    local oldWorldModel = hands.WorldModel
  -- Ensure variables required by AttackFront exist on the weapon base
    hands.ReachDistance = hands.ReachDistance or 70
    hands.Penetration = hands.Penetration or 1
    local originalThink = hands.Think
    function hands:Think()
        if originalThink then
            originalThink(self)
        end
        
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        local classInfo = customClassInfo[owner.PlayerClassName]
        
        if classInfo and self.handsDesc ~= classInfo.handsDesc then
            self.PrintName = classInfo.PrintName
            self.WepSelectIcon = classInfo.WepSelectIcon
            self.handsDesc = classInfo.handsDesc
            if classInfo.Instructions then
                self.Instructions = classInfo.Instructions
            end
            self.InfoMarkup = nil
            
            if self.worldModel and self.worldModel ~= self.worldModel:SetModel("models/weapons/salat/anims/furry_fists.mdl") then
                self.worldModel:SetModel("models/weapons/salat/anims/furry_fists.mdl")
            end
			
			if self.WorldModel then
				self.WorldModel = "models/weapons/salat/anims/furry_fists.mdl"
			end
        elseif not classInfo and self.handsDesc ~= "default" then
            self.PrintName = origPrintName
            self.WepSelectIcon = origWepSelectIcon
            self.Instructions = origInstructions
            self.handsDesc = "default"
            self.InfoMarkup = nil
            
            if self.worldModel then
                self.worldModel:SetModel(oldWorldModel)
            end
			
			if self.WorldModel then
				self.WorldModel = oldWorldModel
			end
        end
    end

    -------------------------------------------------------------------
    -- Primary Attack Integration
    -------------------------------------------------------------------
    local clawClasses = {
        ["goober"] = 1
    }
	
	local tagName = "armorSnag"
	
	local function customPrimary(self)
        local owner = self:GetOwner()
        if not IsValid(owner) or owner:InVehicle() then return end
        if (self.attacked or 0) > CurTime() then return end
        local side = "fists_left"
        local rand = math.Round(util.SharedRandom( "fist_Punching", 1, 2 ), 0) == 1
        local twohands = (owner:GetNetVar("carrymass",0) ~= 0 and owner:GetNetVar("carrymass",0) or owner:GetNetVar("carrymass2",0)) > 15

        local inv = owner:GetNetVar("Inventory",{})
        if not inv then return end
        local havekastet = inv["Weapons"] and inv["Weapons"]["hg_brassknuckles"]

        if rand or (CLIENT and ((owner:GetTable().ChatGestureWeight >= 0.1) or twohands)) or havekastet then
            side = "fists_right"
        end

        if owner.organism and owner.organism.rarmamputated and owner.organism.larmamputated then return end

        if owner.organism and owner.organism.larmamputated then
            rand = 1
            side = "fists_right"
        end

        if owner.organism and owner.organism.rarmamputated then
            rand = 2
            side = "fists_left"
        end

        if owner:KeyDown(IN_ATTACK2) and owner.PlayerClassName ~= "sc_infiltrator" and owner.PlayerClassName ~= "headcrabzombie" then return end
        if owner:GetNetVar("handcuffed",false) then return end
        local olddown = self:GetNextDown()
        self:SetNextDown(CurTime() + 7)
        if not self:GetFists() then
            self:SetFists(true)
            self:DoBFSAnimation("fists_draw",1)
            self:SetNextPrimaryFire(CurTime() + .35)
            return
        end

        if self:GetBlocking() then return end

        if not IsFirstTimePredicted() then
            self:DoBFSAnimation(side,1)
            return
        end
        self.attacked = CurTime() + 0.2

        local special_attack = (olddown - 5) < CurTime()
        if owner.organism and owner.organism.rarmamputated then
            special_attack = false
        end

        if self.IsLocal and self:IsLocal() then
            ViewPunch(special_attack and Angle(0, 0, 0) or Angle((-1), -(rand and 2 or -2), (rand and 8 or -8)))
            if special_attack then
                timer.Simple(0.06, function()
                    ViewPunch(Angle(-15, 2, 2))
                end)
            end
        end

        self:UpdateNextIdle()

        self:SetNextPrimaryFire(CurTime() + .35 * math.Clamp((180 - owner.organism.stamina[1]) / 90,1,2) + (math.max(special_attack and 0.5 or 0, clawClasses[owner.PlayerClassName] or 0)))
        self:SetNextSecondaryFire(CurTime() + .35 + (math.max(special_attack and 0.5 or 0, clawClasses[owner.PlayerClassName] or 0)))
        self:SetLastShootTime(CurTime())

        local snd, pitch = "weapons/slam/throw.wav", math.random(110, 120)
        if owner.PlayerClassName == "goober" then
            snd, pitch = "npc/zombie/claw_miss"..math.random(2)..".wav", math.random(95, 110)
        end
        if SERVER then sound.Play(snd, self:GetPos(), 65, pitch) end

        if SERVER then
            owner:LagCompensation(true)
            
            local isGoober = owner.PlayerClassName == "goober"
            local trMinsClaws, trMaxsClaws = Vector(-12, -12, -12), Vector(12, 12, 12)
            local trMins, trMaxs = Vector(-8, -8, -8), Vector(8, 8, 8)

            local Ent, HitPos, physbone, trace

            if isGoober then
                local pos = hg.eye and hg.eye(owner) or owner:GetShootPos()
                trace = util.TraceHull({
                    start = pos,
                    endpos = pos + owner:GetAimVector() * self.ReachDistance,
                    filter = {owner, hg.GetCurrentCharacter and hg.GetCurrentCharacter(owner) or owner},
                    mins = trMinsClaws,
                    maxs = trMaxsClaws,
                })
                Ent = trace.Entity
                HitPos = trace.HitPos
            else
                local pos = hg.eye and hg.eye(owner) or owner:GetShootPos()
                trace = util.TraceHull({
                    start = pos,
                    endpos = pos + owner:GetAimVector() * self.ReachDistance,
                    filter = {owner, hg.GetCurrentCharacter and hg.GetCurrentCharacter(owner) or owner},
                    mins = trMins,
                    maxs = trMaxs,
                })
                Ent = trace.Entity
                HitPos = trace.HitPos
            end

            local AimVec = owner:GetAimVector()
            
            if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
                local inv = owner:GetNetVar("Inventory", {})
                local havekastet = inv["Weapons"] and inv["Weapons"]["hg_brassknuckles"]
                local SelfForce, Mul = 150, 1 * (havekastet and 1.7 or 1)

                if isGoober and hgIsDoor and hgIsDoor(Ent) then
                    if (Ent.Clawed or 0) > math.random(15, 30) then
                        if hgBlastThatDoor then hgBlastThatDoor(Ent, owner:GetAimVector() * 50 + owner:GetVelocity()) end
                    else
                        if vent then sound.Play(vent[math.random(#vent)], HitPos, 90, math.random(90, 110), 1) end
                        sound.Play("physics/wood/wood_crate_impact_hard" .. math.random(4) .. ".wav", HitPos, 90, math.random(90, 110), 1)
                    end
                    Ent.Clawed = (Ent.Clawed or 0) + 1
                elseif self.IsEntSoft and self:IsEntSoft(Ent) then
                    SelfForce = 25
                    local snd = "Flesh.ImpactHard"
                    if isGoober then
                        snd = "npc/zombie/claw_strike" .. math.random(3) .. ".wav"
                    end
                    sound.Play(snd, HitPos, 65, math.random(90, 110))
                    
                    if owner.IsBerserk and owner:IsBerserk() and owner.organism then
                        sound.Play("zbattle/berserk/unarmed" .. math.random(1, 9) .. ".wav", HitPos, 90, math.random(90, 110), 0.1 + owner.organism.berserk / 2)
                    end

                    if isGoober then
                        util.Decal("Blood", HitPos + owner:EyeAngles():Forward() * -1, HitPos - owner:EyeAngles():Forward() * -1)
                        timer.Simple(0, function()
                            local effectdata2 = EffectData()
                            effectdata2:SetNormal(owner:EyeAngles():Forward() * -1)
                            effectdata2:SetStart(HitPos + owner:EyeAngles():Forward() * -1)
                            effectdata2:SetMagnitude(1)
                            util.Effect("zippy_impact_flesh", effectdata2)
                        end)
                        
                        -- FIX 1: Nerfed the goober massive damage multiplier to something reasonable
                        Mul = Mul + 1.5

                        -- FIX 2: Rewrote how it finds the player entity from ragdolls (Homigrad compatibility)
						 local ply = Ent
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
            
                       
						
                        if IsValid(ply) and ply.PlayerClassName ~= "goober" then
							local snagVal = ply:GetNetVar(tagName, 0)
							local newVal = snagVal + 1
							ply:SetNetVar(tagName, newVal)
							
							if ply.armors and istable(ply.armors) then
								local armors = ply.armors
								for slot, key in pairs(armors) do
									print(key, newVal, requiredHits[key], requiredHits[key] <= newVal)
									if requiredHits[key] <= newVal then
										hg.DropArmorForce(ply, key)
										ply:SetNetVar(tagName, 0)
									end
								end
							end
						
                            local currentVal = ply:GetNetVar("AssimilationProgress", 0)
                            ply:SetNetVar("AssimilationProgress", currentVal + 15)
                        end
                    end
                else
                    local snd = "Flesh.ImpactSoft"
                    if isGoober then
                        snd = "npc/zombie/claw_strike" .. math.random(3) .. ".wav"
                    end
                    sound.Play(snd, HitPos, 65, math.random(90, 110))
                end

                local DamageAmt = (math.random(3, 5) * (special_attack and 3 or 1)) * (self.DamageMul or 1)
                local ent = Ent
                local vec = AimVec

                if ent.PrecacheGibs then ent:PrecacheGibs() end

                if string.find(ent:GetClass(), "prop_") and not ent:IsRagdoll() then
                    ent:CallOnRemove("gibbreak", function()
                        ent:GibBreakClient(vec * 100)
                    end)

                    timer.Simple(1, function()
                        if IsValid(ent) then ent:RemoveCallOnRemove("gibbreak") end
                    end)
                end

                Mul = Mul * (owner.MeleeDamageMul or 1)

                if Ent:IsPlayer() and IsValid(Ent:GetActiveWeapon()) and Ent:GetActiveWeapon().GetBlocking then
                    local isBlocking = isfunction(self.GetBlocking) and self:GetBlocking() or false
                    Mul = Mul * (isBlocking and 0.5 or 1)
                end

                if owner.organism then
                    if owner.organism.superfighter then
                        Mul = Mul * 5 * (self.Penetration or 1)
                        Ent.organism.immobilization = 10
                    end
                    if owner.IsBerserk and owner:IsBerserk() then
                        Mul = Mul * (1 + owner.organism.berserk * 5) * (self.Penetration or 1)
                        Ent.organism.immobilization = 1
                    end
                end

                if self.BlockingLogic then
                    Mul = Mul * self:BlockingLogic(Ent, Mul, 0, trace)
                end

                local isGlass = false
                if string.find(Ent:GetClass(), "break") then
                    local brushSurfaces = Ent.GetBrushSurfaces and Ent:GetBrushSurfaces()
                    if brushSurfaces and brushSurfaces[1] then
                        local mat = brushSurfaces[1]:GetMaterial()
                        if mat and string.find(mat:GetName(), "glass") then
                            isGlass = true
                        end
                    end
                end

                local Dam = DamageInfo()
                Dam:SetAttacker(owner)
                Dam:SetInflictor(self)
                -- FIX 3: Nerfed the flat base Goober damage multiplier from 5 to 2
                Dam:SetDamage(DamageAmt * Mul * 0.75 * (isGoober and 2 or 1))
                Dam:SetDamageForce(AimVec * Mul ^ 2)
                Dam:SetDamageType((isGoober or (Ent:GetClass() == "func_breakable_surf")) and DMG_SLASH or DMG_CLUB)
                Dam:SetDamagePosition(HitPos)
                Ent:TakeDamageInfo(Dam)

                if isGlass and Ent:Health() <= 0 and hg and hg.organism and hg.organism.AddWoundManual then
                    hg.organism.AddWoundManual(owner, math.Rand(50, 75) * 0.5, vector_origin, AngleRand(), owner:LookupBone("ValveBiped.Bip01_" .. (rand and "R" or "L") .. "_Hand") or 0, CurTime())
                end

                local Phys = Ent:IsPlayer() and Ent:GetPhysicsObject() or Ent:GetPhysicsObjectNum(physbone or 0)

                if Ent:IsPlayer() then
                    Ent:ViewPunch(Angle(special_attack and -45 or -5, 0, 0))
                end

                if IsValid(Phys) then
                    if Ent:IsPlayer() then
                        local supMult = (owner.organism and owner.organism.superfighter) and 2 or 1
                        local berserkMult = (owner.organism and owner.organism.berserk) and (1 + owner.organism.berserk * 5) or 1
                        -- FIX 4: Lowered velocity scaling for Goobers
                        Ent:SetVelocity(AimVec * SelfForce * 1.5 * supMult * (isGoober and 2 or 1) * berserkMult)
                    end
                    
                    -- FIX 5: Lowered physics force so props and bodies don't fly across the map
                    Phys:ApplyForceOffset(AimVec * 5000 * Mul * (isGoober and 1.5 or 1), HitPos)
                    
                    local supMultOwn = (owner.organism and owner.organism.superfighter) and 2 or 1
                    local berserkOwn = (owner.organism and owner.organism.berserk) and (owner.organism.berserk / 10) or 0
                    owner:SetVelocity(AimVec * SelfForce * 0.8 * supMultOwn * (isGoober and 1.5 or 1) * (1 + berserkOwn))
                end
            end

            if SERVER and owner.organism and owner.organism.stamina then
                owner.organism.stamina.subadd = owner.organism.stamina.subadd + 4
            end

            owner:LagCompensation(false)
        end

        if special_attack then
            self:DoBFSAnimation("fists_uppercut",1)
        else
            self:DoBFSAnimation(side, clawClasses[owner.PlayerClassName] and 1 or 0.5)
        end
    end
	
    local originalPrimary = hands.PrimaryAttack
    function hands:PrimaryAttack()
        local owner = self:GetOwner()
        if IsValid(owner) and (owner.PlayerClassName == "goober") then
            customPrimary(self)
            return
        else
            if originalPrimary then
                originalPrimary(self)
            end
        end
    end

    -------------------------------------------------------------------
    -- Secondary Attack Hook Logic
    -------------------------------------------------------------------
    local originalSecondary = hands.SecondaryAttack
    function hands:SecondaryAttack()
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        if originalSecondary then
            originalSecondary(self)
        end
        
        local isHandcuffed = owner.handcuffed 
            or owner:GetNetVar("handcuffed", false) 
            or (owner.GetNWBool and owner:GetNWBool("handcuffed", false))

        if isHandcuffed then return end

        if SERVER and owner.PlayerClassName == "goober" then
            local pos = hg.eye and hg.eye(owner) or owner:GetShootPos()
            local trMins, trMaxs = Vector(-8, -8, -8), Vector(8, 8, 8)

            local tr = util.TraceHull({
                start = pos,
                endpos = pos + owner:GetAimVector() * (self.ReachDistance or 70),
                filter = {owner, hg.GetCurrentCharacter and hg.GetCurrentCharacter(owner) or owner},
                mins = trMins,
                maxs = trMaxs,
            })

            if tr.Hit and IsValid(tr.Entity) then
                local ent = tr.Entity
                local targetPly = ent:IsPlayer() and ent or (ent:IsRagdoll() and ent.Player)

                if IsValid(targetPly) and targetPly:Alive() and targetPly.PlayerClassName ~= "goober" then
                    sound.Play("Flesh.ImpactSoft", owner:GetShootPos(), 65, math.random(90, 110))

                    if hg and hg.LightStunPlayer then
                        hg.LightStunPlayer(targetPly, 3)
                    end

                    timer.Simple(0, function()
                        local rag = hg.GetCurrentCharacter and hg.GetCurrentCharacter(targetPly)
                        if IsValid(rag) and self.SetCarrying then
                            self:SetCarrying(rag, tr.PhysicsBone, tr.HitPos, self.ReachDistance or 70)
                        end
                    end)
                end
            end
        end
    end
end

hook.Add("InitPostEntity", "InjectCustomClassToHands", hookHands)
concommand.Add("gz_hot_load_hands", hookHands)

-- =========================================================
-- ORGANISM REGEN & ASSIMILATION HOOK (Shared/Server)
-- =========================================================
hook.Add("Org Think", "goooberstuff", function(owner, org, timeValue)
    if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() then return end
    if owner.PlayerClassName != "goober" then return end

    -- Regeneration
    org.blood = math.Approach(org.blood, 5000, timeValue * 30)

    for i, wound in pairs(org.wounds or {}) do
        wound[1] = math.max(wound[1] - timeValue * 1.8, 0)
    end
    
    for i, wound in pairs(org.arterialwounds or {}) do
        wound[1] = math.max(wound[1] - timeValue * 1.8, 0)
    end
    
    org.internalBleed = math.max((org.internalBleed or 0) - timeValue * 1.8, 0)
    
    local regen = timeValue / 15

    org.lleg = math.max((org.lleg or 0) - regen, 0)
    org.rleg = math.max((org.rleg or 0) - regen, 0)
    org.rarm = math.max((org.rarm or 0) - regen, 0)
    org.larm = math.max((org.larm or 0) - regen, 0)
    org.chest = math.max((org.chest or 0) - regen, 0)
    org.pelvis = math.max((org.pelvis or 0) - regen, 0)
	org.spine1 = math.max(org.spine1 - regen, 0)
	org.spine2 = math.max(org.spine2 - regen, 0)
	org.spine3 = math.max(org.spine3 - regen, 0)
    org.skull = math.max((org.skull or 0) - regen, 0)
	org.pain = math.max(org.pain - regen, 0)

    org.llegdislocation = false
    org.rlegdislocation = false
    org.rarmdislocation = false
    org.larmdislocation = false
    org.jawdislocation = false
    
    org.liver = math.max((org.liver or 0) - regen, 0)
    org.intestines = math.max((org.intestines or 0) - regen, 0)
    org.heart = math.max((org.heart or 0) - regen, 0)
    org.stomach = math.max((org.stomach or 0) - regen, 0)
    if org.lungsR then org.lungsR[1] = math.max(org.lungsR[1] - regen, 0); org.lungsR[2] = math.max(org.lungsR[2] - regen, 0) end
    if org.lungsL then org.lungsL[1] = math.max(org.lungsL[1] - regen, 0); org.lungsL[2] = math.max(org.lungsL[2] - regen, 0) end
    org.brain = math.max((org.brain or 0) - regen * 0.1, 0)

    org.hungry = 0
    
    -- Assimilation logic
    if SERVER then
        local carryent = owner:GetNetVar("carryent")
        
        -- Must be holding a ragdoll
        if IsValid(carryent) then
            local victim = (hg and hg.RagdollOwner and hg.RagdollOwner(carryent)) or carryent.Player

            if IsValid(victim) and victim:Alive() and victim.PlayerClassName != "goober" then
                local currentVal = victim:GetNetVar("AssimilationProgress", 0)
                local maxVal = victim:GetNetVar("MaxAssimilation", 100)

                -- Calculate victim's armor reduction (e.g., 0.5 = 50% slower, 1.0 = blocked)
                local victimReduction = victim:GetNetVar("AssimilationReduction", 0)
                local progressMult = math.Clamp(1 - victimReduction, 0, 1)

                -- Base assimilation speed multiplied by victim's armor mitigation multiplier
                local addVal = (timeValue * 30) * progressMult
                local newVal = currentVal + addVal

                -- Keep victim stunned while being converted
                if hg and hg.LightStunPlayer then
                    hg.LightStunPlayer(victim, 1)
                end

                if newVal >= maxVal then
					victim:SetNetVar("AssimilationProgress", maxVal)
                    owner:SetNetVar("carryent", nil)
                    owner:ChatPrint("[Goober] You fully converted " .. victim:Nick() .. "!")
                else
                    victim:SetNetVar("AssimilationProgress", newVal)
                end
            end
        end
    end
end)

-- ====================================================================
-- CLIENT-SIDE HUD FOR GOOBER VISION
-- ====================================================================

if CLIENT then
    local function getGooberVisionColor(ply)
        if not IsValid(ply) then return Color(100, 255, 180) end
        local vec = ply:GetPlayerColor()
        return Color(
            math.floor(vec.x * 255 * 0.9),
            math.floor(vec.y * 255 * 1.2),
            math.floor(vec.z * 255 * 1.0)
        )
    end

    -- Always-active color correction (soft night vision)
    hook.Add("RenderScreenspaceEffects", "GooberVision_Always", function()
        local ply = LocalPlayer()
        if ply.PlayerClassName ~= "goober" or not ply:Alive() then return end

        local cc = {
            ["$pp_colour_addr"] = 0,
            ["$pp_colour_addg"] = 0.035,
            ["$pp_colour_addb"] = 0.05,
            ["$pp_colour_brightness"] = -0.12,
            ["$pp_colour_contrast"] = 1.18,
            ["$pp_colour_colour"] = 0.55,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0.12,
            ["$pp_colour_mulb"] = 0.18
        }
        DrawColorModify(cc)

        -- Very subtle constant bloom
        DrawBloom(0.03, 0.3, 1.2, 1.2, 0.6, 0.2, 0.6, 1, 1)
    end)

    -- Highlight humans through walls + always-visible goobers
	hook.Add("PreDrawHalos", "GooberVision_Halos", function()
		local ply = LocalPlayer()
		if not IsValid(ply) or ply.PlayerClassName ~= "goober" or not ply:Alive() then return end

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
		-- Humans (Red - ignoreZ = true draws through walls)
		if #humans > 0 then
			halo.Add(humans, Color(255, 50, 50), 2, 2, 1, true, true)
		end

		-- Goobers (Green - normal halo)
		if #goobers > 0 then
			halo.Add(goobers, Color(50, 255, 50), 2, 2, 1, true, true)
		end
	end)

    -- Soft projected "vision" light (always on, follows player color)
    local vision_light = nil

    hook.Add("Think", "GooberVision_Light", function()
        local ply = LocalPlayer()
        if ply.PlayerClassName ~= "goober" or not ply:Alive() then
            if IsValid(vision_light) then
                vision_light:Remove()
                vision_light = nil
            end
            return
        end

        if not IsValid(vision_light) then
            vision_light = ProjectedTexture()
            vision_light:SetTexture("effects/flashlight001")
            vision_light:SetBrightness(0.6)
            vision_light:SetEnableShadows(false)
            vision_light:SetFOV(100)
            vision_light:SetNearZ(10)
            vision_light:SetFarZ(1200)
        end

        local col = getGooberVisionColor(ply)
        vision_light:SetColor(col)

        vision_light:SetPos(ply:EyePos() + ply:EyeAngles():Forward() * 20)
        vision_light:SetAngles(ply:EyeAngles())
        vision_light:Update()
    end)
end