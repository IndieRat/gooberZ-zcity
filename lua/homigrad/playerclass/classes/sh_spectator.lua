-------------------------------------------------------------------
-- SPECTATOR SYSTEM
-- FP follow + orbital chase, camera model, no shadow, no fake
-------------------------------------------------------------------
if SERVER then AddCSLuaFile() end

_G.SPECTATORS = _G.SPECTATORS or {}

local SPECTATE_DELAY = 2
local CAMERA_MODEL = "models/dav0r/camera.mdl"

-- Orbit settings
local ORBIT_DIST = 80
local ORBIT_HEIGHT = 24
local ORBIT_LERP = 12

-------------------------------------------------------------------
-- CLASS
-------------------------------------------------------------------
local CLASS = player.RegClass("spectator")
CLASS.NoGloves = true

function CLASS.On(self, data)
    if not SERVER then return end
    if not IsValid(self) then return end

    _G.SPECTATORS[self] = true

    if not self:Alive() then
        self:Spawn()
    end

    self:StripWeapons()
    self:StripAmmo()
    self.armors = {}
    self.armors_health = {}

    self.PreSpecModel = self:GetModel()
    self:SetModel(CAMERA_MODEL)


    self:DrawViewModel(true)
    self:DrawShadow(true)
    self:SetNoDraw(false) -- other players can still see the cam prop

    self:SetNotSolid(true)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetMoveType(MOVETYPE_NOCLIP)
    self:SetGravity(0)
    self:GodEnable()

    self.CanFake = false
    self.FakeDisabled = true
    self.NoFake = true

    if self.SetNetVar then
        self:SetNetVar("AssimilationProgress", 0)
        self:SetNetVar("BioSuicidePending", false)
        self:SetNetVar("IsSpectator", true)
    end

    if hg then
        if hg.ragdollFake and IsValid(hg.ragdollFake[self]) then
            hg.ragdollFake[self]:Remove()
            hg.ragdollFake[self] = nil
        end
        if hg.FakeUp then hg.FakeUp(self, true, true) end
    end

    -- 0 = first person, 1 = orbital
    self:SetNWInt("GooberZ_SpecMode", 0)
    self:SetNWEntity("GooberZ_SpecTarget", NULL)

    timer.Simple(0.15, function()
        if not IsValid(self) then return end
        self:SetMoveType(MOVETYPE_NOCLIP)
        self:SetNotSolid(true)
        self:SetModel(CAMERA_MODEL)
        self:DrawShadow(false)
        SpectateNextAlivePlayer(self)
    end)
end

function CLASS.Off(self)
    if not SERVER then return end
    if not IsValid(self) then return end

    _G.SPECTATORS[self] = nil
    self.CanFake = nil
    self.FakeDisabled = nil
    self.NoFake = nil

    if self.SetNetVar then
        self:SetNetVar("IsSpectator", false)
    end

    if self.PreSpecModel then
        self:SetModel(self.PreSpecModel)
    end

    self:DrawViewModel(true)
    self:DrawShadow(true)
    self:SetNoDraw(false)
    self:SetNotSolid(false)
    self:SetMoveType(MOVETYPE_WALK)
    self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    self:SetGravity(1)
    self:GodDisable()
    self:SetNWEntity("GooberZ_SpecTarget", NULL)
    self:SetNWInt("GooberZ_SpecMode", 0)
end

-------------------------------------------------------------------
-- BLOCK FAKE + SYNC PHYSICAL POSITION
-------------------------------------------------------------------
if SERVER then
    hook.Add("HG_CanFake", "GooberZ_BlockSpecFake", function(ply)
        if IsValid(ply) and (ply.PlayerClassName == "spectator" or _G.SPECTATORS[ply] or ply.NoFake) then
            return false
        end
    end)

    hook.Add("PlayerCanFake", "GooberZ_BlockSpecFake2", function(ply)
        if IsValid(ply) and (ply.PlayerClassName == "spectator" or _G.SPECTATORS[ply]) then
            return false
        end
    end)

    hook.Add("Think", "GooberZ_SpecAntiFake", function()
        for ply, _ in pairs(_G.SPECTATORS) do
            if not IsValid(ply) then
                _G.SPECTATORS[ply] = nil
                continue
            end

            if ply:GetMoveType() ~= MOVETYPE_NOCLIP then
                ply:SetMoveType(MOVETYPE_NOCLIP)
            end
			
			
			_G.SPECTATORS[ply] = true
            ply:DrawShadow(false)
            
            -- SYNC PHYSICAL POSITION SO OTHER PLAYERS SEE THE CAMERA
            local target = ply:GetNWEntity("GooberZ_SpecTarget")
            if IsValid(target) and target:Alive() then
                local mode = ply:GetNWInt("GooberZ_SpecMode", 0)
                if mode == 0 then
					-- First Person: DO NOT hide the camera model
					ply:SetNoDraw(false)
					ply:SetPos(target:EyePos())
				else
					-- Orbital: camera should also be visible
					ply:SetNoDraw(false)
				 
                    if ply:GetNoDraw() then ply:SetNoDraw(false) end
                    
                    local tgtPos = target:GetPos() + Vector(0, 0, ORBIT_HEIGHT + 18)
                    local back = ply:EyeAngles():Forward() * -ORBIT_DIST
                    
                    local tr = util.TraceHull({
                        start = tgtPos,
                        endpos = tgtPos + back,
                        mins = Vector(-4, -4, -4),
                        maxs = Vector(4, 4, 4),
                        filter = {target, ply},
                        mask = MASK_SOLID_BRUSHONLY
                    })
                    
                    -- Just use 'tr' directly to set the physical position
                    ply:SetPos(tr.HitPos)
                end
            else
                -- Free Cam: Ensure it's visible
                if ply:GetNoDraw() then ply:SetNoDraw(false) end
            end

            if hg and hg.ragdollFake and IsValid(hg.ragdollFake[ply]) then
                hg.ragdollFake[ply]:Remove()
                hg.ragdollFake[ply] = nil
                if hg.FakeUp then hg.FakeUp(ply, true, true) end
            end
        end
    end)
end

-------------------------------------------------------------------
-- HELPERS
-------------------------------------------------------------------
local function GetAlivePlayers(exclude)
    local t = {}
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) and p:Alive() and p ~= exclude
            and p.PlayerClassName ~= "spectator"
            and not _G.SPECTATORS[p]
            and p:Team() ~= TEAM_SPECTATOR
        then
            table.insert(t, p)
        end
    end
    return t
end

function SpectateNextAlivePlayer(ply)
    if not IsValid(ply) then return end
    local alive = GetAlivePlayers(ply)
    if #alive == 0 then
        ply:SetNWEntity("GooberZ_SpecTarget", NULL)
        ply:ChatPrint("[Spectate] Free cam (no living players)")
        return
    end
    ply._specIndex = (ply._specIndex or 0) % #alive + 1
    local target = alive[ply._specIndex]
    if IsValid(target) then
        ply:SetNWEntity("GooberZ_SpecTarget", target)
        local mode = ply:GetNWInt("GooberZ_SpecMode", 0)
        ply:ChatPrint("[Spectate] Watching: " .. target:Nick() .. (mode == 0 and " (FP)" or " (Orbit)"))
    end
end

function SpectatePrevAlivePlayer(ply)
    if not IsValid(ply) then return end
    local alive = GetAlivePlayers(ply)
    if #alive == 0 then return end
    ply._specIndex = (ply._specIndex or 2) - 2
    if ply._specIndex < 0 then ply._specIndex = #alive - 1 end
    SpectateNextAlivePlayer(ply)
end

function GetSpectatorCount()
    local n = 0
    for p, _ in pairs(_G.SPECTATORS) do
        if IsValid(p) then n = n + 1 else _G.SPECTATORS[p] = nil end
    end
    return n
end

function GetSpectatorList()
    local t = {}
    for p, _ in pairs(_G.SPECTATORS) do
        if IsValid(p) then table.insert(t, p) else _G.SPECTATORS[p] = nil end
    end
    return t
end

function CleanSpectators(targetClass)
    targetClass = targetClass or "default"
    for _, ply in ipairs(GetSpectatorList()) do
        if not IsValid(ply) then continue end
        if CLASS and CLASS.Off then CLASS.Off(ply) end
        if ply.SetPlayerClass then
            ply:SetPlayerClass(targetClass)
        else
            ply.PlayerClassName = targetClass
        end
    end
    _G.SPECTATORS = {}
    print("[GooberZ] Cleaned spectators → " .. targetClass)
end

-------------------------------------------------------------------
-- DEATH → spectator
-------------------------------------------------------------------
hook.Add("PlayerDeath", "GooberZ_DelayedSpectate", function(victim)
    if not IsValid(victim) then return end
    if victim.PlayerClassName == "spectator" or _G.SPECTATORS[victim] then return end
    if victim.GetNetVar and victim:GetNetVar("BioSuicidePending", false) then return end

    local sid = victim:SteamID64() or tostring(victim:EntIndex())
    timer.Create("GooberZ_SpecDelay_" .. sid, SPECTATE_DELAY, 1, function()
        if not IsValid(victim) then return end
        if victim:Alive() and victim.PlayerClassName == "spectator" then return end
        if victim:Alive() and not _G.SPECTATORS[victim] then return end

        if victim.SetPlayerClass then
            if not victim:Alive() then victim:Spawn() end
            victim:SetPlayerClass("spectator")
        else
            if not victim:Alive() then victim:Spawn() end
            victim.PlayerClassName = "spectator"
            if CLASS.On then CLASS.On(victim) end
        end
        victim:ChatPrint("[Spectate] LMB/RMB cycle | R free cam | Jump: FP/Orbit | WASD fly")
    end)
end)

hook.Add("PlayerSpawn", "GooberZ_CancelSpecDelay", function(ply)
    if not IsValid(ply) then return end
    local sid = ply:SteamID64() or tostring(ply:EntIndex())

    if ply.PlayerClassName == "spectator" or _G.SPECTATORS[ply] then
        timer.Simple(0, function()
            if IsValid(ply) and (_G.SPECTATORS[ply] or ply.PlayerClassName == "spectator") then
                ply:SetMoveType(MOVETYPE_NOCLIP)
                ply:SetModel(CAMERA_MODEL)
                ply:SetNotSolid(true)
                ply:DrawShadow(false)
            end
        end)
        return
    end

    timer.Remove("GooberZ_SpecDelay_" .. sid)
end)

-------------------------------------------------------------------
-- INPUT
-------------------------------------------------------------------
hook.Add("KeyPress", "GooberZ_SpectateCycle", function(ply, key)
    if not IsValid(ply) then return end
    if ply.PlayerClassName ~= "spectator" and not _G.SPECTATORS[ply] then return end

    if key == IN_ATTACK then
        SpectateNextAlivePlayer(ply)
    elseif key == IN_ATTACK2 then
        SpectatePrevAlivePlayer(ply)
    elseif key == IN_RELOAD then
        if IsValid(ply:GetNWEntity("GooberZ_SpecTarget")) then
            ply:SetNWEntity("GooberZ_SpecTarget", NULL)
            ply:ChatPrint("[Spectate] Free cam")
        else
            SpectateNextAlivePlayer(ply)
        end
    elseif key == IN_JUMP then
        if not IsValid(ply:GetNWEntity("GooberZ_SpecTarget")) then
            ply:ChatPrint("[Spectate] Select a target first (LMB)")
            return
        end
        local mode = ply:GetNWInt("GooberZ_SpecMode", 0)
        mode = (mode == 0) and 1 or 0
        ply:SetNWInt("GooberZ_SpecMode", mode)
        ply:ChatPrint(mode == 0 and "[Spectate] First Person" or "[Spectate] Orbital")
    end
end)

-------------------------------------------------------------------
-- CLIENT VIEW (FP + Orbital) + no local shadow/model
-------------------------------------------------------------------
if CLIENT then
    local orbitPos = nil

    hook.Add("CalcView", "GooberZ_CustomSpectatorView", function(ply, pos, angles, fov)
        if ply.PlayerClassName ~= "spectator" and not ply:GetNWBool("IsSpectator", false) then
            if ply.PlayerClassName ~= "spectator" then return end
        end

        local target = ply:GetNWEntity("GooberZ_SpecTarget")
        local mode = ply:GetNWInt("GooberZ_SpecMode", 0)

        -- ===== FOLLOW TARGET =====
        if IsValid(target) and target:Alive() then
            -- FIRST PERSON
            if mode == 0 then
                local view = { fov = fov, drawviewer = false }
                local attach = target:LookupAttachment("eyes")
                if attach and attach > 0 then
                    local eye = target:GetAttachment(attach)
                    if eye then
                        view.origin = eye.Pos
                        view.angles = eye.Ang
                        return view
                    end
                end
                view.origin = target:EyePos()
                view.angles = target:EyeAngles()
                return view
            end

            -- ORBITAL / CHASE
            local tgtPos = target:GetPos() + Vector(0, 0, ORBIT_HEIGHT)
            local viewAng = angles -- Use spectator's mouse angles instead of target's eye angles

            local back = viewAng:Forward() * -ORBIT_DIST
            local desired = tgtPos + back + Vector(0, 0, 18)

            -- wall avoid
            local tr = util.TraceHull({
                start = tgtPos,
                endpos = desired,
                mins = Vector(-4, -4, -4),
                maxs = Vector(4, 4, 4),
                filter = { target, ply },
                mask = MASK_SOLID_BRUSHONLY
            })
            if tr.Hit then
                desired = tr.HitPos + tr.HitNormal * 6
            end

            orbitPos = orbitPos or desired
            orbitPos = LerpVector(FrameTime() * ORBIT_LERP, orbitPos, desired)

            return {
                origin = orbitPos,
                angles = viewAng, -- Free aiming based on your mouse
                fov = fov,
                drawviewer = false
            }
        end

        -- ===== FREE CAM =====
        orbitPos = nil
        return {
            origin = pos,
            angles = angles,
            fov = fov,
            drawviewer = false
        }
    end)
	
	hook.Add("ShouldDrawLocalPlayer", "GooberZ_SpecDrawLocal", function(ply)
		-- Always draw the camera model locally
		if ply.PlayerClassName == "spectator" or ply:GetNWBool("IsSpectator", false) then
			return true
		end
	end)

	hook.Add("PrePlayerDraw", "GooberZ_SpecNoLocalShadow", function(ply)
		-- Allow shadows normally
		if ply == LocalPlayer() and (ply.PlayerClassName == "spectator" or ply:GetNWBool("IsSpectator", false)) then
			return false
		end
	end)

end