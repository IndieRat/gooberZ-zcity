if CLIENT then
    local cachedPaths = {}
    local beamMat = Material("sprites/physbeama") -- A glowing beam material
	
	local function isSpeical(plr)
		if plr.GetNetVar and (plr:GetNetVar("IsHoldingBriefcase", false) == true or plr:GetNetVar("ShowPathToEscort", false) == true)  then
			return true
			
		else
			return false
		end
		
	
	end

    -- Receive paths from the server
    net.Receive("GooberZ_SyncPath", function()
        cachedPaths = {} -- Clear old paths
        
        local numPaths = net.ReadUInt(8)
        
        -- DEBUG: If you don't see this in your console, the server isn't sending paths!
        -- print("[GooberZ] Received " .. numPaths .. " paths from server!") 

        for i = 1, numPaths do
            local zoneIndex = net.ReadUInt(8)
            local numPoints = net.ReadUInt(16)
            
            local path = {}
            for j = 1, numPoints do
                table.insert(path, net.ReadVector())
            end
            
            cachedPaths[zoneIndex] = path
        end
    end)

    -- Use a proper rendering hook instead of Think
    hook.Add("PostDrawTranslucentRenderables", "DrawEscortZonePath", function(bDepth, bSkybox)
        -- Don't draw this in the skybox projection
        if bSkybox then return end 

        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end
        
        -- Make sure this exact string matches how Homigrad sets your class!
        if localPlayer.PlayerClassName ~= "doctor" and not isSpeical(localPlayer) then return end 

        local zones = _G.CLIENT_ESCORT_ZONES
        if not zones or #zones == 0 then return end

        for i, zone in ipairs(zones) do
            if zone.min and zone.max then
                local zoneCenter = (zone.min + zone.max) / 2
                
                -- 1. Draw the target box
                render.SetColorMaterial()
                render.DrawBox(zoneCenter, angle_zero, Vector(-16, -16, 0), Vector(16, 16, 64), Color(0, 0, 255, 100), true)
                render.DrawWireframeBox(zoneCenter, angle_zero, Vector(-16, -16, 0), Vector(16, 16, 64), Color(100, 150, 255), true)

                local path = cachedPaths[i]

                -- 2. Draw the path
                if path and #path > 1 then
                    render.SetMaterial(beamMat)
                    
                    for j = 1, #path - 1 do
                        -- Lift the path 20 units so it definitely doesn't clip into the floor
                        local p1 = path[j] + Vector(0, 0, 20)
                        local p2 = path[j + 1] + Vector(0, 0, 20)
                        
                        -- Draw a thick, visible green beam
                        render.DrawBeam(p1, p2, 8, 0, 1, Color(0, 255, 50, 255))
                    end
                else
                    -- Fallback: Draw a straight red line if no path exists yet
                    render.SetMaterial(beamMat)
                    render.DrawBeam(localPlayer:GetPos() + Vector(0,0,40), zoneCenter + Vector(0,0,40), 4, 0, 1, Color(255, 0, 0, 150))
                end
            end
        end
    end)
end