TOOL.Category = "GooberZ"
TOOL.Name = "GooberZ Zones And Spawnpoints"
TOOL.Command = nil
TOOL.ConfigName = "GZ setter"

-- Tool Modes Definition
local MODE_ESCORT = 1
local MODE_SPAWN = 2
local MODE_SPAWNZONES = 3
local MODE_ITEM = 4
local MODE_VEHICLE = 5
local MAX_MODES = 5

local hostlered = false
local ModeNames = {
    [MODE_ESCORT] = "Escort Zone",
    [MODE_SPAWN] = "Spawnpoint",
	[MODE_SPAWNZONES] = "Player Spawn Zones",
	[MODE_ITEM] = "Item Spawn Points",
	[MODE_VEHICLE] = "Vehicle Spawn Points",
}

-------------------------------------------------------------------
-- SERVER
-------------------------------------------------------------------
if SERVER then
    util.AddNetworkString("GooberZ_SyncZones")

    _G.ESCORT_ZONES = _G.ESCORT_ZONES or {}
    _G.GOOBER_SPAWNPOINTS = _G.GOOBER_SPAWNPOINTS or {}
	
	_G.SPAWN_ZONES = _G.SPAWN_ZONES or {
		
	}
	_G.ITEM_SPAWNPOINTS = _G.ITEM_SPAWNPOINTS or {}
	_G.GROUND_VEHICLES_SPAWNPOINTS = _G.GROUND_VEHICLES_SPAWNPOINTS or {}
	_G.WATER_VEHICLES_SPAWNPOINTS = _G.WATER_VEHICLES_SPAWNPOINTS or {}
	_G.AIR_VEHICLES_SPAWNPOINTS = _G.AIR_VEHICLES_SPAWNPOINTS or {}

    local function SyncZones(ply)
        net.Start("GooberZ_SyncZones")

        net.WriteUInt(#_G.ESCORT_ZONES, 16)
        for _, zone in ipairs(_G.ESCORT_ZONES) do
            net.WriteVector(zone.min)
            net.WriteVector(zone.max)
        end

        net.WriteUInt(#_G.GOOBER_SPAWNPOINTS, 16)
        for _, spawn in ipairs(_G.GOOBER_SPAWNPOINTS) do
            net.WriteVector(spawn)
        end
		
		net.WriteUInt(#_G.SPAWN_ZONES, 16)
		for _, zone in ipairs(_G.SPAWN_ZONES) do
            net.WriteVector(zone.min)
            net.WriteVector(zone.max)
			net.WriteString(zone.spawnType)
        end
		
		net.WriteUInt(#_G.ITEM_SPAWNPOINTS, 16)
        for _, spawn in ipairs(_G.ITEM_SPAWNPOINTS) do
            net.WriteVector(spawn)
        end
		
		net.WriteUInt(#_G.GROUND_VEHICLES_SPAWNPOINTS, 16)
		for _, spawn in ipairs(_G.GROUND_VEHICLES_SPAWNPOINTS) do
			net.WriteVector(spawn)
		end
		
		net.WriteUInt(#_G.WATER_VEHICLES_SPAWNPOINTS, 16)
		for _, spawn in ipairs(_G.WATER_VEHICLES_SPAWNPOINTS) do
			net.WriteVector(spawn)
		end 
		
		net.WriteUInt(#_G.AIR_VEHICLES_SPAWNPOINTS, 16)
		for _, spawn in ipairs(_G.AIR_VEHICLES_SPAWNPOINTS) do
			net.WriteVector(spawn)
		end

        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    function TOOL:SyncZones(ply)
        SyncZones(ply or self:GetOwner())
    end

    hook.Add("PlayerInitialSpawn", "GooberZ_SyncZonesOnJoin", function(ply)
        timer.Simple(2, function()
            if IsValid(ply) then SyncZones(ply) end
        end)
    end)
end

-------------------------------------------------------------------
-- CLIENT & HUD
-------------------------------------------------------------------
if CLIENT then
    _G.CLIENT_ESCORT_ZONES = _G.CLIENT_ESCORT_ZONES or {}
    _G.CLIENT_SPAWNPOINTS = _G.CLIENT_SPAWNPOINTS or {}
	
	_G.CLIENT_SPAWNZONES = _G.CLIENT_SPAWNZONES or {
		
	}
	_G.CLIENT_ITEMSPAWNS = _G.CLIENT_ITEMSPAWNS or {}
	_G.CLIENT_GVEHICLES_SPAWN = _G.CLIENT_GVEHICLES_SPAWN or {}
	_G.CLIENT_WVEHICLES_SPAWN = _G.CLIENT_WVEHICLES_SPAWN or {}
	_G.CLIENT_AVEHICLES_SPAWN = _G.CLIENT_AVEHICLES_SPAWN or {}

    net.Receive("GooberZ_SyncZones", function()
        _G.CLIENT_ESCORT_ZONES = {}
        local zoneCount = net.ReadUInt(16)
        for i = 1, zoneCount do
            table.insert(_G.CLIENT_ESCORT_ZONES, {
                min = net.ReadVector(),
                max = net.ReadVector()
            })
        end

        _G.CLIENT_SPAWNPOINTS = {}
        local spawnCount = net.ReadUInt(16)
        for i = 1, spawnCount do
            table.insert(_G.CLIENT_SPAWNPOINTS, net.ReadVector())
        end
		
		_G.CLIENT_SPAWNZONES = {}
		local zoneCount = net.ReadUInt(16)
        for i = 1, zoneCount do
            table.insert(_G.CLIENT_SPAWNZONES, {
                min = net.ReadVector(),
                max = net.ReadVector(),
				spawnType = net.ReadString()
            })
        end
		
		_G.CLIENT_ITEMSPAWNS = {}
		local itemCount = net.ReadUInt(16)
		for i = 1, itemCount do
			table.insert(_G.CLIENT_ITEMSPAWNS, net.ReadVector())
		end
		
		_G.CLIENT_GVEHICLES_SPAWN = {}
		local vehiclesCount = net.ReadUInt(16)
		for i = 1, vehiclesCount do
			table.insert(_G.CLIENT_GVEHICLES_SPAWN, net.ReadVector())
		end
		
		_G.CLIENT_WVEHICLES_SPAWN = {}
		local boatsCount = net.ReadUInt(16)
		for i = 1, boatsCount do
			table.insert(_G.CLIENT_WVEHICLES_SPAWN, net.ReadVector())
		end
		
		_G.CLIENT_AVEHICLES_SPAWN = {}
		local helisCount = net.ReadUInt(16)
		for i = 1, helisCount do
			table.insert(_G.CLIENT_AVEHICLES_SPAWN, net.ReadVector())
		end
    end)

    language.Add("tool.goober_zoner.name", "Goober Zone Creator")
    language.Add("tool.goober_zoner.desc", "Mark escort zones and spawnpoints.")
    language.Add("tool.goober_zoner.0", "LMB: Place/Start | RMB: Remove nearest / Cancel | R: Cycle Mode")
    language.Add("tool.goober_zoner.1", "LMB: Set Opposite Corner | RMB: Cancel zone")

    function TOOL.BuildCPanel(CPanel)
        CPanel:AddControl("Header", {
            Text = "Goober Zone Creator",
            Description = "R = Cycle Tool Mode\nLMB = Place element / set corner\nRMB = Remove nearest element / cancel"
        })
    end
end

-------------------------------------------------------------------
-- AUTH & HELPERS
-------------------------------------------------------------------
local function IsAuthorized(ply)
    return IsValid(ply) and (ply:IsAdmin() or ply:IsSuperAdmin())
end

function TOOL:GetToolMode()
    local wep = self:GetWeapon()
    if IsValid(wep) then
        return wep:GetNWInt("GooberZ_Mode", MODE_ESCORT)
    end
    return MODE_ESCORT
end

function TOOL:SetToolMode(mode)
    local wep = self:GetWeapon()
    if IsValid(wep) then
        wep:SetNWInt("GooberZ_Mode", mode)
    end
end

function TOOL:Deploy()
    if SERVER then
        self:SyncZones(self:GetOwner())
    end
    return true
end

-------------------------------------------------------------------
-- MODE SWITCHING (RELOAD / R KEY)
-------------------------------------------------------------------
function TOOL:Reload(trace)
    local ply = self:GetOwner()
    if not IsAuthorized(ply) then return false end

    -- Reset box creation stage when changing modes
    self:SetStage(0)

    local currentMode = self:GetToolMode()
    local nextMode = (currentMode % MAX_MODES) + 1
    self:SetToolMode(nextMode)

    if SERVER then
        ply:ChatPrint("[GooberZ] Switched mode to: " .. ModeNames[nextMode])
		
		local wep = self:GetWeapon()
		wep:SetNWInt("GooberZ_Mode", nextMode)
        sound.Play("buttons/button14.wav", ply:GetPos(), 70, 120)
    end

    return true
end

-------------------------------------------------------------------
-- LEFT CLICK (PLACE)
-------------------------------------------------------------------
function TOOL:LeftClick(trace)
    local ply = self:GetOwner()
    if not IsAuthorized(ply) then
        if SERVER then ply:ChatPrint("[GooberZ] Admin only.") end
        return false
    end

    local mode = self:GetToolMode()
	local wep = self:GetWeapon()
	local vehicleType = IsValid(wep) and wep:GetNWString("GooberZ_VehicleType", "ground") or "ground"
	local spawnZoneType = IsValid(wep) and wep:GetNWString("GooberZ_SpawnType", "default") or "default"

    ---------------------------------------------------------------
    -- MODE 1: ESCORT ZONE (2-click Box)
    ---------------------------------------------------------------
    if mode == MODE_ESCORT then
        if self:GetStage() == 0 then
            self:SetStage(1)
            self:GetWeapon():SetNWVector("GooberZ_PointA", trace.HitPos)
            if SERVER then
                ply:ChatPrint("[GooberZ] Corner A set. Click opposite corner.")
            end
            return true
        end

        if self:GetStage() == 1 then
            if SERVER then
                local pointA = self:GetWeapon():GetNWVector("GooberZ_PointA")
                local pointB = trace.HitPos
                OrderVectors(pointA, pointB)

                if math.abs(pointB.z - pointA.z) < 5 then
                    pointB.z = pointA.z + 100
                end

                table.insert(_G.ESCORT_ZONES, { min = pointA, max = pointB })
                ply:ChatPrint("[GooberZ] Escort zone created. Total: " .. #_G.ESCORT_ZONES)
                sound.Play("buttons/blip1.wav", pointB, 75, 100)
                self:SyncZones()
            end
            self:SetStage(0)
            return true
        end
    end

    ---------------------------------------------------------------
    -- MODE 2: SPAWNPOINT
    ---------------------------------------------------------------
    if mode == MODE_SPAWN then
        if SERVER then
            local hitPos = trace.HitPos + Vector(0, 0, 8)
            table.insert(_G.GOOBER_SPAWNPOINTS, hitPos)
            ply:ChatPrint("[GooberZ] Spawnpoint added. Total: " .. #_G.GOOBER_SPAWNPOINTS)
            sound.Play("buttons/button14.wav", hitPos, 75, 100)
            self:SyncZones()
        end
        return true
    end
	
	---------------------------------------------------------------
    -- MODE 2: SPAWNZONES
    ---------------------------------------------------------------
	if mode == MODE_SPAWNZONES then
		 if self:GetStage() == 0 then
            self:SetStage(1)
            self:GetWeapon():SetNWVector("GooberZ_PointA", trace.HitPos)
            if SERVER then
                ply:ChatPrint("[GooberZ] Corner A set. Click opposite corner.")
            end
            return true
        end

        if self:GetStage() == 1 then
            if SERVER then
                local pointA = self:GetWeapon():GetNWVector("GooberZ_PointA")
                local pointB = trace.HitPos
                OrderVectors(pointA, pointB)

                if math.abs(pointB.z - pointA.z) < 5 then
                    pointB.z = pointA.z + 100
                end

                table.insert(_G.SPAWN_ZONES, { min = pointA, max = pointB, spawnType = spawnZoneType })
                ply:ChatPrint("[GooberZ] Escort zone created. Total: " .. #_G.SPAWN_ZONES)
                sound.Play("buttons/blip1.wav", pointB, 75, 100)
                self:SyncZones()
            end
            self:SetStage(0)
            return true
        end
		
		
	end
	
	 ---------------------------------------------------------------
    -- MODE 3: ITEM SPAWNPOINT
    ---------------------------------------------------------------
	if mode == MODE_ITEM then
		if SERVER then
			local hitPos = trace.HitPos + Vector(0, 0, 8)
			table.insert(_G.ITEM_SPAWNPOINTS, hitPos)
			ply:ChatPrint("[GooberZ] Item Spawnpoint added. Total: " .. #_G.ITEM_SPAWNPOINTS)
			sound.Play("buttons/button14.wav", hitPos, 75, 100)
			self:SyncZones()
		end
		return true
	end
	
	if mode == MODE_VEHICLE  then
		if SERVER then
			local hitPos = trace.HitPos + Vector(0, 0, 8)
			if vehicleType == "ground" then
				table.insert(_G.GROUND_VEHICLES_SPAWNPOINTS, hitPos)
				ply:ChatPrint("[GooberZ] Vehicle Ground Spawnpoint added. Total: " .. #_G.GROUND_VEHICLES_SPAWNPOINTS)
			elseif vehicleType == "water" then
				table.insert(_G.WATER_VEHICLES_SPAWNPOINTS, hitPos)
				ply:ChatPrint("[GooberZ] Vehicle Water Spawnpoint added. Total: " .. #_G.WATER_VEHICLES_SPAWNPOINTS)
			elseif vehicleType == "air" then
				table.insert(_G.AIR_VEHICLES_SPAWNPOINTS, hitPos)
				ply:ChatPrint("[GooberZ] Vehicle Water Spawnpoint added. Total: " .. #_G.AIR_VEHICLES_SPAWNPOINTS)
			end	
			sound.Play("buttons/button14.wav", hitPos, 75, 100)
			self:SyncZones()
		end
		return true
	end

    return false
end

-------------------------------------------------------------------
-- RIGHT CLICK (REMOVE / CANCEL)
-------------------------------------------------------------------
function TOOL:RightClick(trace)
    local ply = self:GetOwner()
    if not IsAuthorized(ply) then
        if SERVER then ply:ChatPrint("[GooberZ] Admin only.") end
        return false
    end

    -- Cancel box placement stage if active
    if self:GetStage() == 1 then
        self:SetStage(0)
        if SERVER then ply:ChatPrint("[GooberZ] Zone placement cancelled.") end
        return true
    end

    local mode = self:GetToolMode()
	local wep = self:GetWeapon()
	local vehicleType = IsValid(wep) and wep:GetNWString("GooberZ_VehicleType", "ground") or "ground"
	local spawnZoneType = IsValid(wep) and wep:GetNWString("GooberZ_SpawnType", "default") or "default"

    ---------------------------------------------------------------
    -- MODE 1: REMOVE NEAREST ESCORT ZONE
    ---------------------------------------------------------------
    if mode == MODE_ESCORT then
        if SERVER then
            if #_G.ESCORT_ZONES == 0 then
                ply:ChatPrint("[GooberZ] No escort zones to remove.")
                return false
            end

            local hitPos = trace.HitPos
            local bestIndex = nil
            local bestDist = math.huge

            for idx, zone in ipairs(_G.ESCORT_ZONES) do
                local center = (zone.min + zone.max) * 0.5
                local dist = center:Distance(hitPos)
                if dist < bestDist then
                    bestDist = dist
                    bestIndex = idx
                end
            end

            if bestIndex then
                table.remove(_G.ESCORT_ZONES, bestIndex)
                ply:ChatPrint("[GooberZ] Escort zone removed. Remaining: " .. #_G.ESCORT_ZONES)
                sound.Play("buttons/button10.wav", ply:GetPos(), 75, 100)
                self:SyncZones()
                return true
            end
        end
        return true
    end

    ---------------------------------------------------------------
    -- MODE 2: REMOVE NEAREST SPAWNPOINT
    ---------------------------------------------------------------
    if mode == MODE_SPAWN then
        if SERVER then
            if #_G.GOOBER_SPAWNPOINTS == 0 then
                ply:ChatPrint("[GooberZ] No spawnpoints to remove.")
                return false
            end

            local hitPos = trace.HitPos
            local bestIndex = nil
            local bestDist = 250 -- Maximum distance radius to remove a spawn point

            for idx, spawnPos in ipairs(_G.GOOBER_SPAWNPOINTS) do
                local dist = spawnPos:Distance(hitPos)
                if dist < bestDist then
                    bestDist = dist
                    bestIndex = idx
                end
            end

            if bestIndex then
                table.remove(_G.GOOBER_SPAWNPOINTS, bestIndex)
                ply:ChatPrint("[GooberZ] Spawnpoint removed. Remaining: " .. #_G.GOOBER_SPAWNPOINTS)
                sound.Play("buttons/button10.wav", ply:GetPos(), 75, 100)
                self:SyncZones()
                return true
            else
                ply:ChatPrint("[GooberZ] No spawnpoint near crosshair to remove.")
            end
        end
        return true
    end
	
	if mode == MODE_SPAWNZONES then
        if SERVER then
            if #_G.SPAWN_ZONES == 0 then
                ply:ChatPrint("[GooberZ] No SPAWN_ZONES to remove.")
                return false
            end

            local hitPos = trace.HitPos
            local bestIndex = nil
            local bestDist = 250 -- Maximum distance radius to remove a spawn point

            for idx, zone in ipairs(_G.SPAWN_ZONES) do
                local center = (zone.min + zone.max) * 0.5
                local dist = center:Distance(hitPos)
                if dist < bestDist then
                    bestDist = dist
                    bestIndex = idx
                end
            end

            if bestIndex then
                table.remove(_G.SPAWN_ZONES, bestIndex)
                ply:ChatPrint("[GooberZ] SPAWN_ZONES removed. Remaining: " .. #_G.SPAWN_ZONES)
                sound.Play("buttons/button10.wav", ply:GetPos(), 75, 100)
                self:SyncZones()
                return true
            else
                ply:ChatPrint("[GooberZ] No SPAWN_ZONES near crosshair to remove.")
            end
        end
        return true
    end
	
	if mode == MODE_ITEM then
		if SERVER then
            if #_G.ITEM_SPAWNPOINTS == 0 then
                ply:ChatPrint("[GooberZ] No spawnpoints to remove.")
                return false
            end

            local hitPos = trace.HitPos
            local bestIndex = nil
            local bestDist = 250 -- Maximum distance radius to remove a spawn point

            for idx, spawnPos in ipairs(_G.ITEM_SPAWNPOINTS) do
                local dist = spawnPos:Distance(hitPos)
                if dist < bestDist then
                    bestDist = dist
                    bestIndex = idx
                end
            end

            if bestIndex then
                table.remove(_G.ITEM_SPAWNPOINTS, bestIndex)
                ply:ChatPrint("[GooberZ] Spawnpoint removed. Remaining: " .. #_G.ITEM_SPAWNPOINTS)
                sound.Play("buttons/button10.wav", ply:GetPos(), 75, 100)
                self:SyncZones()
                return true
            else
                ply:ChatPrint("[GooberZ] No spawnpoint near crosshair to remove.")
            end
        end
        return true
	end
	
	if mode == MODE_VEHICLE then
		if SERVER then
            if (#_G.GROUND_VEHICLES_SPAWNPOINTS == 0 and vehicleType == "ground") and (#_G.WATER_VEHICLES_SPAWNPOINTS == 0 and vehicleType == "water") and (#_G.AIR_VEHICLES_SPAWNPOINTS == 0 and vehicleType == "air") then
                ply:ChatPrint("[GooberZ] No spawnpoints to remove.")
                return false
            end

            local hitPos = trace.HitPos
            local bestIndex = nil
            local bestDist = 250 -- Maximum distance radius to remove a spawn point

			if vehicleType == "ground" then
				 for idx, spawnPos in ipairs(_G.GROUND_VEHICLES_SPAWNPOINTS) do
					local dist = spawnPos:Distance(hitPos)
					if dist < bestDist then
						bestDist = dist
						bestIndex = idx
					end
				end
			elseif vehicleType == "water" then
				 for idx, spawnPos in ipairs(_G.WATER_VEHICLES_SPAWNPOINTS) do
					local dist = spawnPos:Distance(hitPos)
					if dist < bestDist then
						bestDist = dist
						bestIndex = idx
					end
				end
			elseif vehicleType == "air" then
				 for idx, spawnPos in ipairs(_G.AIR_VEHICLES_SPAWNPOINTS) do
					local dist = spawnPos:Distance(hitPos)
					if dist < bestDist then
						bestDist = dist
						bestIndex = idx
					end
				end
			end

            if bestIndex then
                if vehicleType == "ground" then
					table.remove(_G.GROUND_VEHICLES_SPAWNPOINTS, bestIndex)
					ply:ChatPrint("[GooberZ] Spawnpoint removed. Remaining: " .. #_G.GROUND_VEHICLES_SPAWNPOINTS)
				elseif vehicleType == "water" then
					table.remove(_G.WATER_VEHICLES_SPAWNPOINTS, bestIndex)
					ply:ChatPrint("[GooberZ] Spawnpoint removed. Remaining: " .. #_G.WATER_VEHICLES_SPAWNPOINTS)
				elseif vehicleType == "air" then
					table.remove(_G.AIR_VEHICLES_SPAWNPOINTS, bestIndex)
					ply:ChatPrint("[GooberZ] Spawnpoint removed. Remaining: " .. #_G.AIR_VEHICLES_SPAWNPOINTS)
				end
                sound.Play("buttons/button10.wav", ply:GetPos(), 75, 100)
                self:SyncZones()
                return true
            else
                ply:ChatPrint("[GooberZ] No spawnpoint near crosshair to remove.")
            end
        end
        return true
	end

    return false
end

-------------------------------------------------------------------
-- CLIENT DRAW & HUD INDICATORS
-------------------------------------------------------------------
if CLIENT then
    local mat = Material("models/debug/debugwhite")
	
	language.Add("tool.goober_zooner.name", "Goober Zone Creator")
	language.Add("tool.goober_zooner.desc", "Mark escort zones and spawnpoints.")
	language.Add("tool.goober_zooner.0", "LMB: Place/Start | RMB: Remove nearest / Cancel | R: Cycle Mode")
	language.Add("tool.goober_zooner.1", "LMB: Set Opposite Corner | RMB: Cancel zone")
end

-------------------------------------------------------------------
-- FORCE SYNC HOOK (USE KEY)
-------------------------------------------------------------------
local CHANGE_SPAWN_TYPE = 18
hook.Add("PlayerButtonDown", "GooberZ_ToolForceSyncOnUse", function(ply, button)
    if not IsValid(ply) or not ply:IsAdmin() then return end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" or (wep.Mode and wep.Mode ~= "goober_zooner") then return end

    -------------------------------------------------------------------
    -- E KEY: FORCE SYNC VISUALS TO ALL CLIENTS
    -------------------------------------------------------------------
    if button == KEY_E then 
        if SERVER then
            net.Start("GooberZ_ZoneVisuals")
            net.WriteUInt(#_G.ESCORT_ZONES, 16)
            for _, zone in ipairs(_G.ESCORT_ZONES) do
                net.WriteVector(zone.min)
                net.WriteVector(zone.max)
            end
            net.WriteUInt(#_G.GOOBER_SPAWNPOINTS, 16)
            for _, spawn in ipairs(_G.GOOBER_SPAWNPOINTS) do
                net.WriteVector(spawn)
            end
            net.WriteUInt(#_G.SPAWN_ZONES, 16)
            for _, spawn in ipairs(_G.SPAWN_ZONES) do
                net.WriteVector(spawn.min) 
                net.WriteVector(spawn.max)
                net.WriteString(spawn.spawnType)
            end
            net.WriteUInt(#_G.ITEM_SPAWNPOINTS, 16)
            for _, spawn in ipairs(_G.ITEM_SPAWNPOINTS) do
                net.WriteVector(spawn)
            end
            net.WriteUInt(#_G.GROUND_VEHICLES_SPAWNPOINTS, 16)
            for _, spawn in ipairs(_G.GROUND_VEHICLES_SPAWNPOINTS) do
                net.WriteVector(spawn)
            end
            net.WriteUInt(#_G.WATER_VEHICLES_SPAWNPOINTS, 16)
            for _, spawn in ipairs(_G.WATER_VEHICLES_SPAWNPOINTS) do
                net.WriteVector(spawn)
            end
            net.Broadcast()

            ply:ChatPrint("[GooberZ] Forced zone/spawn sync to all clients.")
            sound.Play("buttons/button9.wav", ply:GetPos(), 70, 100)
        end

    -------------------------------------------------------------------
    -- H KEY: CYCLE SUB-MODES / TYPES
    -------------------------------------------------------------------
    elseif button == KEY_H then
        if SERVER then
            -- Get the active mode stored on the tool weapon
            local mode = wep:GetNWInt("GooberZ_Mode", 1)

            -- Cycle Spawn Zone Sub-Types
            if mode == MODE_SPAWNZONES then
                local spawnZoneType = wep:GetNWString("GooberZ_SpawnType", "default")

                if spawnZoneType == "default" then
                    spawnZoneType = "hf/t"
                elseif spawnZoneType == "hf/t" then
                    spawnZoneType = "infected"
                elseif spawnZoneType == "infected" then
                    spawnZoneType = "default"
                end

                wep:SetNWString("GooberZ_SpawnType", spawnZoneType)
                ply:ChatPrint("[GooberZ] Changed Spawn Zone Type To: " .. spawnZoneType)
                sound.Play("buttons/button14.wav", ply:GetPos(), 70, 110)

            -- Cycle Vehicle Sub-Types
            elseif mode == MODE_VEHICLE then
                local vehicleType = wep:GetNWString("GooberZ_VehicleType", "ground")

                if vehicleType == "ground" then
                    vehicleType = "water"
                elseif vehicleType == "water" then
                    vehicleType = "air"
				elseif vehicleType == "air" then
					vehicleType = "ground"
                end

                wep:SetNWString("GooberZ_VehicleType", vehicleType)
                ply:ChatPrint("[GooberZ] Changed Vehicle Type To: " .. vehicleType)
                sound.Play("buttons/button14.wav", ply:GetPos(), 70, 110)
            end
        end
    end
end)