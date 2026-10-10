AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Type             = "nextbot"
ENT.PrintName        = "Goober"
ENT.Category         = "GooberZ"
ENT.Spawnable        = true
ENT.AdminOnly        = false

ENT.Model            = "models/player/leymirba/protogenpm.mdl"

ENT.MoveSpeed        = 200
ENT.AttackRange      = 70
ENT.PounceRange      = 1500
ENT.AssimilationRate = 35
ENT.StartHealth      = 100

ENT.IsOrganism       = true
ENT.hg_organism      = true
ENT.IsGoober         = true

-------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------
local function GetPhysicalEntity(ply)
    if not IsValid(ply) then return nil end
    if hg and hg.ragdollFake and IsValid(hg.ragdollFake[ply]) then
        return hg.ragdollFake[ply]
    end
    local nwRagdoll = ply:GetNWEntity("FakeRagdoll")
    if IsValid(nwRagdoll) then return nwRagdoll end
    return ply
end

local function GetPlayerFromPhys(physEnt)
    if not IsValid(physEnt) then return nil end
    if physEnt:IsPlayer() then return physEnt end
    if physEnt:IsRagdoll() then
        if IsValid(physEnt.Player) then return physEnt.Player end
        local owner = physEnt:GetNWEntity("RagdollOwner")
        if IsValid(owner) then return owner end
    end
    return nil
end

-------------------------------------------------------------------
-- Initialize
-------------------------------------------------------------------
function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetHealth(self.StartHealth)
    self.MaxHealthLimit = self.StartHealth

    self.LoseTargetDist = 1500
    self.SearchRadius   = 30000
    self.LastAttack     = 0
    self.NextPounce     = 0
    self.Carrying       = nil
    self.AssimilationProgress = {}
    self.CurrentAnim    = -1

    if SERVER then
        self:SetCollisionGroup(COLLISION_GROUP_NPC)
        
        -- Improve locomotion / pathfinding traversal
        if self.loco then
            self.loco:SetStepHeight(24) -- Let it step over debris and normal stairs
            self.loco:SetJumpHeight(300) -- Gives it decent jump clearance
        end
    end

    -- Delay sequence init so model is fully loaded
    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        local idle = self:FindSequence({"idle", "idle_all", "idle_all_01", "reference", "ragdoll"})
        if idle ~= -1 then
            self:ResetSequence(idle)
            self:SetCycle(0)
            self:SetPlaybackRate(1)
            self.CurrentAnim = idle
        end
    end)
end

function ENT:FindSequence(names)
    for _, name in ipairs(names) do
        local seq = self:LookupSequence(name)
        if seq and seq ~= -1 then
            return seq
        end
    end
    return -1
end

-------------------------------------------------------------------
-- Animation & Physics Smoothing Fix (PROPER LOOPING)
-------------------------------------------------------------------
function ENT:BodyUpdate()
    if not IsValid(self) then return end

    local vel = self.loco and self.loco:GetVelocity() or self:GetVelocity()
    local speed2d = vel:Length2D()

    -- Dynamically look up the correct sequence IDs instead of hardcoding
    local idle = self:FindSequence({"idle", "idle_all", "idle_all_01", "reference"})
    if idle == -1 then idle = 0 end
    
    local walk = self:FindSequence({"walk_all", "walk_lower"})
    if walk == -1 then walk = idle end
    
    local run  = self:FindSequence({"run_all", "run_all_02", "run_lower"})
    if run == -1 then run = walk end

    local targetSeq = idle
    if speed2d > 160 then
        targetSeq = run
    elseif speed2d > 8 then
        targetSeq = walk
    end

    local crawling = hg and hg.GooberNPCSupport and hg.GooberNPCSupport.ShouldCrawl(self)
    if crawling then
        local crawl = self:FindSequence({"crawl_all", "crawl", "crawl_01", "zombie_crawl", "crawl_aim"})
        if crawl ~= -1 then targetSeq = crawl end
    end

    if targetSeq ~= self.CurrentAnim then
        self:ResetSequence(targetSeq)
        self:SetCycle(0)
        self.CurrentAnim = targetSeq
    end

    self:SetPlaybackRate(crawling and 0.65 or 1)
    self:FrameAdvance()

    -- Smooth facing direction
    if self.loco then
        local enemy = self:GetEnemy()
        if IsValid(enemy) then
            local phys = GetPhysicalEntity(enemy)
            if IsValid(phys) and self:GetPos():Distance(phys:GetPos()) < self.AttackRange + 50 then
                -- Face the enemy when very close
                self.loco:FaceTowards(phys:GetPos())
            elseif speed2d > 5 then
                -- Face the direction of movement while chasing
                self.loco:FaceTowards(self:GetPos() + vel)
            end
        elseif speed2d > 5 then
            self.loco:FaceTowards(self:GetPos() + vel)
        end
    end
end

function ENT:PlayAttackAnim()
    local seq = self:LookupSequence("zombie_attack_01")
    if seq == -1 then
        seq = self:LookupSequence("seq_meleeattack01")
    end
    if seq == -1 then
        seq = self:LookupSequence("attack01")
    end
    
    if seq and seq ~= -1 then
        self:AddGestureSequence(seq)
    end
end

-------------------------------------------------------------------
-- AI & Pathfinding
-------------------------------------------------------------------
function ENT:RunBehaviour()
    while true do
        local crawlMul = hg and hg.GooberNPCSupport and hg.GooberNPCSupport.ShouldCrawl(self) and 0.42 or 1

        if self:HaveEnemy() then
            self.loco:SetDesiredSpeed(self.MoveSpeed * crawlMul)
            self:ChaseEnemy()
        else
            self.loco:SetDesiredSpeed(self.MoveSpeed * 0.6 * crawlMul)
            
            local wanderPos = self:FindRandomSpawnablePos() or (self:GetPos() + Vector(math.Rand(-1,1), math.Rand(-1,1), 0) * 400)
            self:MoveToPos(wanderPos)

            self:FindEnemy()
            coroutine.wait(1)
        end
        coroutine.yield()
    end
end

function ENT:FindRandomSpawnablePos()
    local areas = navmesh.GetAllNavAreas()
    if #areas > 0 then
        local area = areas[math.random(1, #areas)]
        if IsValid(area) then
            return area:GetRandomPoint()
        end
    end
    return nil
end

function ENT:FindEnemy()
    local enemies = {}
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() and ply.PlayerClassName ~= "goober" and not ply.IsGoober then
            local physEnt = GetPhysicalEntity(ply)
            if IsValid(physEnt) then
                local dist = self:GetPos():Distance(physEnt:GetPos())
                if dist < self.SearchRadius then
                    table.insert(enemies, {ply = ply, dist = dist})
                end
            end
        end
    end
    table.sort(enemies, function(a, b) return a.dist < b.dist end)
    if #enemies > 0 then
        self:SetEnemy(enemies[1].ply)
        return true
    end
    return false
end

function ENT:HaveEnemy()
    local enemy = self:GetEnemy()
    if not IsValid(enemy) or not enemy:Alive() or enemy.PlayerClassName == "goober" or enemy.PlayerClassName == "spectator" or enemy.IsGoober then
        return self:FindEnemy()
    end
    local physEnt = GetPhysicalEntity(enemy)
    if not IsValid(physEnt) then return self:FindEnemy() end
    if self:GetPos():Distance(physEnt:GetPos()) > self.LoseTargetDist then
        return self:FindEnemy()
    end
    return true
end

function ENT:SetEnemy(ent) self.Enemy = ent end
function ENT:GetEnemy() return self.Enemy end

function ENT:ChaseEnemy()
    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end

    local path = Path("Follow")
    path:SetMinLookAheadDistance(300)
    path:SetGoalTolerance(40) -- Increased slightly to prevent stuttering near targets

    local physEnt = GetPhysicalEntity(enemy)
    if not IsValid(physEnt) then return end

    path:Compute(self, physEnt:GetPos())
    if not path:IsValid() then return end

    while path:IsValid() and self:HaveEnemy() do
        physEnt = GetPhysicalEntity(self:GetEnemy())
        if not IsValid(physEnt) then break end

        -- Update path constantly to track player movement
        if path:GetAge() > 0.4 then
            path:Compute(self, physEnt:GetPos())
        end
        
        path:Update(self)

        local dist = self:GetPos():Distance(physEnt:GetPos())

        if dist < self.PounceRange and dist > self.AttackRange and CurTime() > self.NextPounce
            and not (hg and hg.GooberNPCSupport and hg.GooberNPCSupport.ShouldCrawl(self)) then
            if self.loco:IsOnGround() then
                local dir = (physEnt:GetPos() - self:GetPos()):GetNormalized()
                self.loco:Jump()
                self.loco:SetVelocity(dir * 600 + Vector(0, 0, 200))
                self.NextPounce = CurTime() + math.Rand(2.5, 4.0)
                self:EmitSound("npc/fast_zombie/fz_scream1.wav", 80, math.random(90, 110))
            end
        end

        if dist < self.AttackRange then
            self:AttackEnemy(self:GetEnemy())
        end

        if self.loco:IsStuck() then
            self:HandleStuck()
            return -- Break out of chase loop to reset
        end

        coroutine.yield()
    end
end

-- Missing function from your original code
function ENT:HandleStuck()
    self.loco:ClearStuck()
    
    -- Try jumping to get unstuck
    if self.loco:IsOnGround() then
        self.loco:Jump()
    end
    
    -- Move to a random nearby spot to try and un-wedge itself
    local escapePoint = self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * 150
    self:MoveToPos(escapePoint)
    coroutine.wait(0.5)
end

function ENT:AttackEnemy(enemy)
    if CurTime() < (self.LastAttack or 0) + 1.2 then return end
    self.LastAttack = CurTime()

    self:PlayAttackAnim()

    local physEnt = GetPhysicalEntity(enemy)
    if not IsValid(physEnt) then return end

    local plyTarget = GetPlayerFromPhys(physEnt)
    if IsValid(plyTarget) and plyTarget:Alive() then
        plyTarget.pain = (plyTarget.pain or 0) + 150
        plyTarget.shock = (plyTarget.shock or 0) + 80
        plyTarget.blood = math.max((plyTarget.blood or 5000) - 200, 0)

        if hg and hg.LightStunPlayer then
            hg.LightStunPlayer(plyTarget, 3.0)
        end
    end

    self.Carrying = enemy
    self.AssimilationProgress[enemy] = self.AssimilationProgress[enemy] or 0
    sound.Play("Flesh.ImpactHard", self:GetPos(), 75, math.random(90, 110))
end

function ENT:Think()
    if SERVER then
        self:BodyUpdate()
    end

    if SERVER and IsValid(self.Carrying) then
        local victim = self.Carrying
        if not victim:Alive() or victim.PlayerClassName == "goober" or victim.PlayerClassName == "spectator" or victim.IsGoober then
            self.Carrying = nil
            return
        end

        local physEnt = GetPhysicalEntity(victim)
        if not IsValid(physEnt) then
            self.Carrying = nil
            return
        end

        local dist = self:GetPos():Distance(physEnt:GetPos())
        if dist > self.AttackRange + 40 then
            self.Carrying = nil
            return
        end

        local progress = self.AssimilationProgress[victim] or 0
        local maxVal = victim:GetNetVar("MaxAssimilation", 100) or 100
        local reduction = victim:GetNetVar("AssimilationReduction", 0) or 0
        local add = (FrameTime() * self.AssimilationRate) * math.Clamp(1 - reduction, 0, 1)

        progress = math.min(progress + add, maxVal)
        self.AssimilationProgress[victim] = progress

        if victim.SetNetVar then
            victim:SetNetVar("AssimilationProgress", progress)
        end

        if hg and hg.LightStunPlayer then
            hg.LightStunPlayer(victim, 0.8)
        end

        if progress >= maxVal then
            self.AssimilationProgress[victim] = nil
            self.Carrying = nil
            self:EmitSound("npc/zombie/zombie_alert1.wav", 80)
        end
    end
end

function ENT:OnInjured(dmg)
    if not self.RegenTimer then
        self.RegenTimer = true
        local timerName = "GooberNPC_Regen_" .. self:EntIndex()
        timer.Create(timerName, 0.5, 0, function()
            if not IsValid(self) or self:Health() <= 0 then
                timer.Remove(timerName)
                self.RegenTimer = false
                return
            end
            if self:Health() < self.MaxHealthLimit then
                self:SetHealth(math.min(self:Health() + 8, self.MaxHealthLimit))
            else
                timer.Remove(timerName)
                self.RegenTimer = false
            end
        end)
    end
end

function ENT:OnKilled(dmg)
    if timer.Exists("GooberNPC_Regen_" .. self:EntIndex()) then
        timer.Remove("GooberNPC_Regen_" .. self:EntIndex())
    end
    self:BecomeRagdoll(dmg)
end