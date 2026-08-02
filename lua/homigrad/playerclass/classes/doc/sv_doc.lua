if SERVER then
    util.AddNetworkString("GooberZ_SyncPath")
	
	local function isSpeical(plr)
		if plr.GetNetVar and (plr:GetNetVar("IsHoldingBriefcase", false) == true or plr:GetNetVar("ShowPathToEscort", false) == true)  then
			return true
			
		else
			return false
		end
		
	
	end


    -- =========================================================================
    -- A* Pathfinding Algorithm (Server-Side)
    -- =========================================================================
    local function FindNavPath(startPos, endPos)
        if not navmesh.IsLoaded() then return nil end

        local startArea = navmesh.GetNearestNavArea(startPos)
        local endArea = navmesh.GetNearestNavArea(endPos)

        if not IsValid(startArea) or not IsValid(endArea) then return nil end
        if startArea == endArea then return {startPos, endPos} end

        local openSet = { [startArea:GetID()] = startArea }
        local cameFrom = {}
        
        local gScore = { [startArea:GetID()] = 0 }
        local fScore = { [startArea:GetID()] = startPos:Distance(endPos) }

        while not table.IsEmpty(openSet) do
            local current, currentID = nil, nil
            local lowestF = math.huge

            for id, area in pairs(openSet) do
                local f = fScore[id] or math.huge
                if f < lowestF then
                    lowestF = f
                    current = area
                    currentID = id
                end
            end

            if current == endArea then
                local path = {endPos}
                local currID = endArea:GetID()
                
                while cameFrom[currID] do
                    local area = cameFrom[currID]
                    table.insert(path, 1, area:GetCenter())
                    currID = area:GetID()
                end
                table.insert(path, 1, startPos)
                return path
            end

            openSet[currentID] = nil

            for k, neighbor in pairs(current:GetAdjacentAreas()) do
                local neighborID = neighbor:GetID()
                local tentative_gScore = gScore[currentID] + current:GetCenter():Distance(neighbor:GetCenter())

                if tentative_gScore < (gScore[neighborID] or math.huge) then
                    cameFrom[neighborID] = current
                    gScore[neighborID] = tentative_gScore
                    fScore[neighborID] = gScore[neighborID] + neighbor:GetCenter():Distance(endPos)
                    
                    if not openSet[neighborID] then
                        openSet[neighborID] = neighbor
                    end
                end
            end
        end

        return nil
    end

    -- Calculate paths for Doctors every 1 second and send to them
    local nextPathUpdate = 0
    hook.Add("Think", "GooberZ_ServerPathCalc", function()
        if CurTime() < nextPathUpdate then return end
        nextPathUpdate = CurTime() + 1 

        local zones = _G.ESCORT_ZONES
        if not zones or #zones == 0 then return end

        for _, ply in ipairs(player.GetAll()) do
            -- Only calculate for players who actually need to see the path
            if ply.PlayerClassName == "doctor" or isSpeical(ply) then
                local allPaths = {}
                local startPos = ply:GetPos()

                for i, zone in ipairs(zones) do
                    local zoneCenter = (zone.min + zone.max) / 2
                    local path = FindNavPath(startPos, zoneCenter)
                    if path then
                        allPaths[i] = path
                    end
                end

                -- Network the paths to this specific player
                net.Start("GooberZ_SyncPath")
                net.WriteUInt(table.Count(allPaths), 8) -- How many zones have valid paths
                
                for zoneIndex, pathTable in pairs(allPaths) do
                    net.WriteUInt(zoneIndex, 8) -- Which zone this path belongs to
                    net.WriteUInt(#pathTable, 16) -- How many points in this path
                    
                    for _, point in ipairs(pathTable) do
                        net.WriteVector(point)
                    end
                end
                net.Send(ply)
            end
        end
    end)
end