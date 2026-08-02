if SERVER then
    util.AddNetworkString("GamemodeNotifyPlr")
    util.AddNetworkString("GamemodeSyncTimer")
    util.AddNetworkString("GamemodePlaySound")
    util.AddNetworkString("GamemodeStopSound")
    util.AddNetworkString("GamemodeShowRoleInstructions")
	util.AddNetworkString("GamemodeShowRoleTips")
end

-- ====================================================================
-- ROLE INSTRUCTIONS & FACTION LORE CONFIGURATION
-- ====================================================================
GM_ROLE_CONFIG = {
    ----------------------------------------------------------------
    -- THE CORP (perfection / hive / "the cure")
    ----------------------------------------------------------------
    patient_zero = {
        title = "CORP: HARBINGER",
        color = Color(50, 205, 50),
        objective = "You are the Harbinger, the beginning, the alpha of the cure and the omega of man -- to assimilate all.",
        lore = "THE CORP: We have a gift for them, Mr L. Let's say, we might have snuck one of product into one of their 'safe' havens"
    },
    infected = {
        title = "CORP: WANTED ADDITION",
        color = Color(34, 139, 34),
        objective = "There is nothing to do now but spread, hunt, chase, work together for one goal -- to assimilate all.",
        lore = "THE CORP: You are one of many tones in the frequency of your head, every thought for you and others endearing the creation of more."
    },
    containment_subject = {
        title = "CORP: STARVED ASSIMILATED",
        color = Color(50, 205, 50),
        objective = "You are tired of the quietness in your head, make more 'friends' -- to assimilate all.",
        lore = "THE CORP: Being trapped in a glass box made you bored, hasn't it? Something nagging within, perhaps loneliness you want to fill?"
    },
    uncounted_lost = {
        title = "CORP: WANTED ADDITION",
        color = Color(70, 130, 180),
        objective = "There is nothing to do now but spread, hunt, chase, work together for one goal -- to assimilate all.",
        lore = "THE CORP: You had attempted to run, fight, pray for your angels to save you, don't cry, we still hear you, you'll never be alone again."
    },
    far_gone_traitor = {
        title = "CORP: IMAGE OF PERFECTION",
        color = Color(178, 34, 34),
        objective = "You truly are a traitor to your kind, complete your fantasy, and give the gift.",
        lore = "THE CORP: Devotion, Belief, Madness. You don't care what they say, all you want to be apart of the frequency they claimed to be."
    },
    fallen_soldier = {
        title = "CORP: STRUGGLED ENTRY",
        color = Color(128, 0, 128),
        objective = "You have become the very thing you tried to stop, but there no point in fighting it, accept your seat in chaos and assimilate.",
        lore = "HUMANITY LOSS: You thought the assimilated were mindless, monsters of the dark, but now, the more you stay with us, become a hum in our tone, the more you stop believing in that.."
    },
    fallen_doctor = {
        title = "CORP: WELCOMING HOME",
        color = Color(50, 205, 50),
        objective = "It’s over. The mind that fought the cure now carries it.",
        lore = "VIP LOSS: “I’m sorry,” you mutter—before thousands of voices echo in your skull, welcoming you back with your name.."
    },
   traitor = {
    title = "CORP: MATCH STICK",
    color = Color(255, 50, 50),
    objective = "Blend in as a Gloved Hand. Find the weak point and begin the spread.",
    lore = "THE CORP: They will call you a traitor. You are only the first spark of a larger frequency."
	},
	traitor_soldier = {
		title = "CORP: WHITE WIND",
		color = Color(255, 50, 50),
		objective = "Break this zone. Convert or remove every remaining human presence.",
		lore = "THE CORP: This is one front in a longer correction. Keep the image advancing."
	},
	mystery_traitor = {
		title = "CORP: BACKSTABBER",
		color = Color(255, 50, 50),
		objective = "Wear their trust. Use it. Finish the work from inside.",
		lore = "THE CORP: You already wear their rank and their uniform. The only thing left is the act."
	},
	traitor_offense = {
		title = "CORP: GREEDY GHOST",
		color = Color(255, 50, 50),
		objective = "Secure the files and reach the extract. Knowledge is the priority.",
		lore = "THE CORP: They will protect the briefcase as if it still belongs to them. It does not."
	},
	reinforcements_traitor = {
		title = "CORP: HOUR HAND",
		color = Color(255, 50, 50),
		objective = "The opening has been given. Strike while they are thin.",
		lore = "THE CORP: We received the signal. Numbers are on our side. Move."
	},
    ----------------------------------------------------------------
    -- HUMANITY FORCES (messy freedom / memory / hold the line)
    ----------------------------------------------------------------
    infection_humanity = {
        title = "HF: GLOVED HAND",
        color = Color(0, 150, 255),
        objective = "Be the guardian of civilians and ensure your and their humanity will remain.",
        lore = "HUMANITY FORCES: The drill is simple: Make sure no hell breaks loose, and every man and women stays human."
    },
    war_humanity = {
        title = "HF: FLAG BURNER",
        color = Color(0, 150, 255),
        objective = "Eliminate or detain these crazy lunatics, stop anything that follows the 'Perfect Image'.",
        lore = "HUMANITY FORCES: Trust those you deployed next to. And take down every perfection with our flame!"
    },
    containment_unit = {
        title = "HF: DAREDEVILS",
        color = Color(0, 150, 255),
        objective = "The worse of the worse has happened, cuff what your team can, melt what y'all cant.",
        lore = "HUMANITY FORCES: We are here to maintain order, everyone. Civil yet quick."
    },
    traitor_humanity = {
        title = "HF: GLOVED HAND",
        color = Color(0, 150, 255),
        objective = "One of the 'said' guardians of this zone isn't who they say they are.",
        lore = "HUMANITY FORCES: Patches, weapons, masks. What's different is they want to spread the perfection while we want to maintain it."
    },
    mystery_humanity = {
        title = "HF: HOME SWEEP",
        color = Color(0, 150, 255),
        objective = "Something is up in the HQ of HF, and now, there seems to be spy among you and your team.",
        lore = "HUMANITY FORCES: Home Quarters, familiar place, everyone is armed to defend our base of operation while one is armed to assimilate."
    },
    breach_guard = {
        title = "HF: FIRST IN LINE",
        color = Color(0, 150, 255),
        objective = "Stay alive from the endless horde of the assimilated, make each shot worth the waste.",
        lore = "HUMANITY FORCES: Flashing red lights, buzzers blaring, panic pursuing the fact of confrontation, now we hold the line."
    },
    zone_clearence_operator = {
        title = "HF: CLEAN-UP CREW",
        color = Color(0, 150, 255),
        objective = "Clean the streets, clear the alleys, ensure that this city is cleaned beside the stacks of false 'perfection'.",
        lore = "HUMANITY FORCES: It's time to do the chores and bring back home to its better image.."
    },
    body_guard = {
        title = "HF: HARP SONG",
        color = Color(0, 150, 255),
        objective = "Keep the Doctor unassimilated and help his path to the escort zone!",
        lore = "HUMANITY FORCES: This is our future, we cant let the assimilated take it from us."
    },
    reinforcements_hf = {
        title = "HF: MIRCALE",
        color = Color(0, 150, 255),
        objective = "The radio said it, the orders were recived, assist in your side's objective to your best of abilities.",
        lore = "HUMANITY FORCES: Civilian, Soldier, or just Human is all it needs for a miracle to arrive."
    },
    humanity_defendant = {
        title = "HF: STINGING BEE",
        color = Color(0, 150, 255),
        objective = "We sting, bite, shoot anyone who isnt one of us that attempts to take a look of our plans.",
        lore = "HUMANITY FORCES: If they want it, they'll have to fight by the skin of their teeth to get it."
    },

    ----------------------------------------------------------------
    -- UNALIGNED / AFFILIATED (civilians, VIPs, strays, tests)
    ----------------------------------------------------------------
    survivor = {
        title = "UNALIGNED: CIVILIAN",
        color = Color(220, 220, 220),
        objective = "Stay human, fight the 'assimilated' and stay under the wings of your guardians.",
        lore = "UNALIGNED: With a random melee you had around you, you head out in seek of protection that was promised to you."
    },
    innocent = {
        title = "UNALIGNED: CIVILIAN",
        color = Color(220, 220, 220),
        objective = "Remain human, remain civilian, assist or remain out of way in the suspision of a backstabber.",
        lore = "UNALIGNED: Everything is peaceful, no assimilated, no war. What could go wrong?"
    },
    doctor = {
        title = "AFFILIATED: DOCTOR",
        color = Color(255, 255, 255),
        objective = "Redemption is now, follow the path you see with your guarding squad and remain human as much as you can.",
        lore = "AFFILIATED: Either knowledge, invention, or importance has granted you the second chance from the people."
    },
    vip_doctor = {
        title = "AFFILIATED: VIP DOCTOR",
        color = Color(240, 240, 240),
        objective = "Redemption is now, follow the path you see with your guarding squad and remain human as much as you can..",
        lore = "AFFILIATED: Either knowledge, invention, or importance has granted you the second chance from the prople."
    },
    no_mercy_survivor = {
        title = "UNALIGNED: SURVIVOR",
        color = Color(220, 220, 220),
        objective = "Stay alive, continue thriving, as being not in the zones is a job only for the endurant, no protection, no guardian.",
        lore = "UNALIGNED: Far from any city, it not that they have forgotten you, no, you are just too much assimilated cities ahead to reach.."
    },
    no_mercy_viligante = {
        title = "UNALIGNED: VIGILANTE",
        color = Color(255, 200, 0),
        objective = "If the heros of today cant reach us, then I'll take their belief and be the hero.",
        lore = "UNALIGNED: Bravery, Foolishness, Selflessness, it all doesnt matter who they deem you as, you are playing by your own rules."
    },
    test_subject = {
        title = "SIM: TEST SUBJECT",
        color = Color(255, 200, 0),
        objective = "Testing environment. Check timers, roles, and toys.",
        lore = "SIMULATION: Network checks and state validation. Try not to lore yourself into a real panic."
    },
    lms = {
        title = "SOLE SURVIVOR",
        color = Color(255, 60, 60),
        objective = "Last one standing, hide, run, leave, anything but accept your fate..",
        lore = "SOLE SURVIVOR: Everyone else is a memory or a monster. Struggle.."
    },
}

-- Mapping player classes to role config keys
local CLASS_TO_ROLE_KEY = {
    goober = "patient_zero",
    humanityForces = "infection_humanity",
    traitor = "traitor",
    bystander = "innocent",
	doctor = "doctor",
    default = "survivor"
}

GM_ROLE_TIPS = {
	hf = {
		title = "",
		body = "",
		color = Color(0, 150, 255)
	}
}

-- ====================================================================
-- GAMEMODE STATE & CONFIG
-- ====================================================================
GM_STATE = GM_STATE or {
    CurrentMode = nil,
    InProgress = false,
    EndTime = 0,
    RoundTime = 300,
    LastManStandingTriggered = false,
    LMSMusicPath = "empty",
    LMSMusicPath_Traitor = "empty",
    LMSMusicPath_Mystery = "empty",
	LMSMusicPath_VIP = "empty",
    RoundThemePath = "empty",
	VictoryThemePath = "empty",
	ZoneClearenceDiffculty = 3,
	BroadingcastingPath = ""
}

GOOBER_NPCS = GOOBER_NPCS or {}
GOOBER_SPAWNPOINTS = GOOBER_SPAWNPOINTS or {}

ESCORT_ZONES = ESCORT_ZONES or {}
SPAWN_ZONES = SPAWN_ZONES or {}

PUBLIC_ITEM_POOL = PUBLIC_ITEM_POOL or {
	"weapon_glock26_electric",
	"weapon_hf_radio",
	"weapon_reverse",
	"weapon_mosin_vig",
	"weapon_buck200knife",
	"weapon_hg_axe",
	"weapon_hg_spear_knife",
	"weapon_droppable_ammo"
	
}

ITEM_SPAWNPOINTS = ITEM_SPAWNPOINTS or {}

PUBLIC_GROUND_VEHICLES = PUBLIC_GROUND_VEHICLES or {
	"gtav_sanchez",
	"gtav_blazer",
	"gtav_speedo",
	"gtav_dukes",
	"gtav_infernus",
}

PUBLIC_WATER_VEHICLES = PUBLIC_WATER_VEHICLES or {
	"gtav_dinghy",
	"gtav_seashark",
}

PUBLIC_AIR_VEHICLES = PUBLIC_AIR_VEHICLES or {
	"glide_gtav_buzzard2",
	"glide_gtav_swift",
	"glide_gtav_maverick",
	"glide_gtav_annihilator"
}

GROUND_VEHICLES_SPAWNPOINTS = GROUND_VEHICLES_SPAWNPOINTS or {}
WATER_VEHICLES_SPAWNPOINTS = WATER_VEHICLES_SPAWNPOINTS or {}
AIR_VEHICLES_SPAWNPOINTS = AIR_VEHICLES_SPAWNPOINTS or {}

function GiveSafeHands(ply)
    if not IsValid(ply) then return end
    
    ply:Give("weapon_hands_sh")
end

-------------------------------------------------------------------
-- GooberZ Zone Visuals
-------------------------------------------------------------------

if SERVER then
    util.AddNetworkString("GooberZ_ZoneVisuals")

    _G.ESCORT_ZONES = _G.ESCORT_ZONES or {}
    _G.GOOBER_SPAWNPOINTS = _G.GOOBER_SPAWNPOINTS or {}
	
	_G.SPAWN_ZONES = _G.SPAWN_ZONES or {
		
	}
	_G.ITEM_SPAWNPOINTS = _G.ITEM_SPAWNPOINTS or {}
	_G.GROUND_VEHICLES_SPAWNPOINTS = _G.GROUND_VEHICLES_SPAWNPOINTS or {}
	_G.WATER_VEHICLES_SPAWNPOINTS = _G.WATER_VEHICLES_SPAWNPOINTS or {}
	_G.AIR_VEHICLES_SPAWNPOINTS = _G.AIR_VEHICLES_SPAWNPOINTS or {}

    function GooberZ_SyncZoneVisuals(ply)
        net.Start("GooberZ_ZoneVisuals")

        net.WriteUInt(#_G.ESCORT_ZONES, 16)
        for _, z in ipairs(_G.ESCORT_ZONES) do
            net.WriteVector(z.min)
            net.WriteVector(z.max)
        end

        net.WriteUInt(#_G.GOOBER_SPAWNPOINTS, 16)
        for _, p in ipairs(_G.GOOBER_SPAWNPOINTS) do
            net.WriteVector(p)
        end
		
		net.WriteUInt(#_G.SPAWN_ZONES, 16)
		for _, zone in ipairs(_G.SPAWN_ZONES) do
            net.WriteVector(zone.min)
            net.WriteVector(zone.max)
			net.WriteString(zone.spawnType)
        end
		
		net.WriteUInt(#_G.ITEM_SPAWNPOINTS, 16)
		for _, p in ipairs(_G.ITEM_SPAWNPOINTS) do
			net.WriteVector(p)
		end
		
		net.WriteUInt(#_G.GROUND_VEHICLES_SPAWNPOINTS, 16)
		for _, v in ipairs(_G.GROUND_VEHICLES_SPAWNPOINTS) do
			net.WriteVector(v)
		end
		
		net.WriteUInt(#_G.WATER_VEHICLES_SPAWNPOINTS, 16)
		for _, v in ipairs(_G.WATER_VEHICLES_SPAWNPOINTS) do
			net.WriteVector(v)
		end
		
		net.WriteUInt(#_G.AIR_VEHICLES_SPAWNPOINTS, 16)
		for _, v in ipairs(_G.AIR_VEHICLES_SPAWNPOINTS) do
			net.WriteVector(v)
		end

        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end

        print("[GooberZ] Synced visuals → Zones: " .. #_G.ESCORT_ZONES .. " | Spawns: " .. #_G.GOOBER_SPAWNPOINTS)
    end
	

    hook.Add("PlayerInitialSpawn", "GooberZ_ZoneVisuals_Join", function(ply)
        timer.Simple(2, function()
            if IsValid(ply) then GooberZ_SyncZoneVisuals(ply) end
        end)
    end)

    timer.Create("GooberZ_ZoneVisuals_Resync", 15, 0, function()
        if #_G.ESCORT_ZONES > 0 or #_G.GOOBER_SPAWNPOINTS > 0  then
            GooberZ_SyncZoneVisuals()
        end
    end)

    -- Debug command
    concommand.Add("gz_debug_spawns", function(ply)
        if IsValid(ply) and not ply:IsAdmin() then return end
        print("=== GOOBER SPAWNPOINTS (" .. #_G.GOOBER_SPAWNPOINTS .. ") ===")
        for i, p in ipairs(_G.GOOBER_SPAWNPOINTS) do
            print(i, p)
        end
        GooberZ_SyncZoneVisuals()
    end)
	
	
end

if CLIENT then
    local CL_ESCORTS = {}
    local CL_SPAWNS = {}
	local CL_ZONES = {}
	local CL_ITEMSPAWNS = {}
	local CL_VEHICLES = {}
	
	local zoneTypeToColor = {
		["default"] = Color(255, 255, 200),
		["hf/t"] = Color(255, 0, 255),
		["infected"] = Color(255, 0, 0)
	}

    net.Receive("GooberZ_ZoneVisuals", function()
        CL_ESCORTS = {}
        local n = net.ReadUInt(16)
        for i = 1, n do
            table.insert(CL_ESCORTS, {
                min = net.ReadVector(),
                max = net.ReadVector()
            })
        end

        CL_SPAWNS = {}
        local m = net.ReadUInt(16)
        for i = 1, m do
            table.insert(CL_SPAWNS, net.ReadVector())
        end
		
		CL_ZONES = {}
		local o = net.ReadUInt(16)
		for i = 1, o do
			table.insert(CL_ZONES, {
				 min = net.ReadVector(),
                max = net.ReadVector(),
				spawnType = net.ReadString()
			})
		end	
		
		CL_ITEMSPAWNS = {}
		local p = net.ReadUInt(16)
		for i = 1, p do
			table.insert(CL_ITEMSPAWNS, net.ReadVector())
		end
		
		CL_VEHICLES = {}
		local g = net.ReadUInt(16)
		for i = 1, g do
			table.insert(CL_VEHICLES, net.ReadVector())
		end
		
		local w = net.ReadUInt(16)
		for i = 1, w do
			table.insert(CL_VEHICLES, net.ReadVector())
		end
		
		local a = net.ReadUInt(16)
		for i = 1, a do
			table.insert(CL_VEHICLES, net.ReadVector())
		end

        print("[GooberZ CLIENT] Received zones=" .. #CL_ESCORTS .. " spawns=" .. #CL_SPAWNS)
    end)

    local matBeam = Material("sprites/physbeam")
    local matGlow = Material("sprites/light_glow02_add")
    local matWhite = Material("models/debug/debugwhite")

    local function DrawEdge(a, b, col)
        render.SetMaterial(matBeam)
        render.DrawBeam(a, b, 5, 0, 1, col)
        render.DrawBeam(a, b, 2, 0, 1, Color(255, 255, 255, math.min(255, col.a + 40)))
    end

    local function DrawZoneBox(mins, maxs, col)
        local c = {
            Vector(mins.x, mins.y, mins.z),
            Vector(maxs.x, mins.y, mins.z),
            Vector(maxs.x, maxs.y, mins.z),
            Vector(mins.x, maxs.y, mins.z),
            Vector(mins.x, mins.y, maxs.z),
            Vector(maxs.x, mins.y, maxs.z),
            Vector(maxs.x, maxs.y, maxs.z),
            Vector(mins.x, maxs.y, maxs.z),
        }
        DrawEdge(c[1], c[2], col) DrawEdge(c[2], c[3], col)
        DrawEdge(c[3], c[4], col) DrawEdge(c[4], c[1], col)
        DrawEdge(c[5], c[6], col) DrawEdge(c[6], c[7], col)
        DrawEdge(c[7], c[8], col) DrawEdge(c[8], c[5], col)
        DrawEdge(c[1], c[5], col) DrawEdge(c[2], c[6], col)
        DrawEdge(c[3], c[7], col) DrawEdge(c[4], c[8], col)
    end

    local function DrawSpawnMarker(pos, pulse, col, colCore)
        local h = 56
        local r = 14 + 4 * pulse

        cam.IgnoreZ(true)

        -- vertical pillar
        render.SetMaterial(matBeam)
        render.DrawBeam(pos, pos + Vector(0, 0, h), 6, 0, 1, col)
        render.DrawBeam(pos, pos + Vector(0, 0, h), 2, 0, 1, colCore)

        -- ground ring (4 short beams)
        local ring = 18
        local a1 = pos + Vector(ring, 0, 2)
        local a2 = pos + Vector(-ring, 0, 2)
        local a3 = pos + Vector(0, ring, 2)
        local a4 = pos + Vector(0, -ring, 2)
        render.DrawBeam(a1, a2, 3, 0, 1, col)
        render.DrawBeam(a3, a4, 3, 0, 1, col)

        -- glow sprite
        render.SetMaterial(matGlow)
        render.DrawSprite(pos + Vector(0, 0, 20), 32 + 10 * pulse, 32 + 10 * pulse, col)
        render.DrawSprite(pos + Vector(0, 0, 20), 12, 12, colCore)

        -- solid-ish sphere fallback (very visible)
        render.SetColorMaterial()
        render.DrawWireframeSphere(pos + Vector(0, 0, 16), 12, 8, 8, col, true)
    end

    hook.Add("PostDrawTranslucentRenderables", "GooberZ_ZoneVisuals_Draw", function()
        if #CL_ESCORTS == 0 and #CL_SPAWNS == 0 and #CL_ZONES == 0 and #CL_ITEMSPAWNS == 0 and #CL_VEHICLES == 0 then return end

        local pulse = 0.55 + 0.45 * math.sin(CurTime() * 2.5)
        local zoneCol = Color(40, 255, 120, math.floor(130 + 90 * pulse))

        for _, z in ipairs(CL_ESCORTS) do
            local mins = Vector(z.min)
            local maxs = Vector(z.max)
            if math.abs(maxs.z - mins.z) < 5 then
                maxs.z = mins.z + 100
            end
            DrawZoneBox(mins, maxs, zoneCol)
        end

		local col = Color(255, 120, 20, 230)
        local colCore = Color(255, 220, 80, 230)
        for _, p in ipairs(CL_SPAWNS) do
            if isvector(p) then
                DrawSpawnMarker(p, pulse, col, colCore)
            end
        end
		
		for _, s in ipairs(CL_ZONES) do
			 local mins = Vector(s.min)
            local maxs = Vector(s.max)
			
			local col = zoneTypeToColor[s.spawnType]
            if math.abs(maxs.z - mins.z) < 5 then
                maxs.z = mins.z + 100
            end
            DrawZoneBox(mins, maxs, col)
		end
		
		local col = Color(20, 120, 220, 230)
        local colCore = Color(80, 220, 255, 230)
		for _, p in ipairs(CL_ITEMSPAWNS) do
			if isvector(p) then
                DrawSpawnMarker(p, pulse, col, colCore)
            end
		end
		
		local col = Color(20, 220, 120, 230)
        local colCore = Color(80, 255, 220, 230)
		for _, p in ipairs(CL_VEHICLES) do
			if isvector(p) then
                DrawSpawnMarker(p, pulse, col, colCore)
            end
		end
    end)
end

local previousSpawnPos = nil
-- gets random spawn (Fixed to handle both entity objects and position vectors safely, plus anti-repetition)
function GetRandomGooberSpawn()
    if #GOOBER_SPAWNPOINTS == 0 then
        print("[GooberZ] WARNING: No goober_spawnpoint entities found in the map!")
        -- FALLBACK: If no spawn points exist, spawn near a random active player
        local players = GetActivePlayers()
        if #players > 0 then
            local targetPly = players[math.random(#players)]
            if IsValid(targetPly) then
                return targetPly:GetPos() + Vector(math.Rand(-300, 300), math.Rand(-300, 300), 10)
            end
        end
        return Vector(0, 0, 0)
    end

    -- Pick a spawn entry, and if we have more than 1 point, try to avoid picking the exact same one
    local spawnEntry = GOOBER_SPAWNPOINTS[math.random(#GOOBER_SPAWNPOINTS)]
    local chosenPos = Vector(0, 0, 0)

    if IsValid(spawnEntry) then
        chosenPos = spawnEntry:GetPos()
    elseif isvector(spawnEntry) then
        chosenPos = spawnEntry
    end

    -- If there's more than 1 spawn point and this matches the last one, try picking again once
    if #GOOBER_SPAWNPOINTS > 1 and previousSpawnPos and chosenPos == previousSpawnPos then
        local retryEntry = GOOBER_SPAWNPOINTS[math.random(#GOOBER_SPAWNPOINTS)]
        if IsValid(retryEntry) then
            chosenPos = retryEntry:GetPos()
        elseif isvector(retryEntry) then
            chosenPos = retryEntry
        end
    end

    -- Save this position for the next check
    previousSpawnPos = chosenPos
    return chosenPos
end

function PopulateAllItemSpawns()
    if not SERVER then return end -- Weapon spawning must happen on the SERVER
    if not PUBLIC_ITEM_POOL or #PUBLIC_ITEM_POOL == 0 then return end
    if not ITEM_SPAWNPOINTS or #ITEM_SPAWNPOINTS == 0 then return end

    for _, p in ipairs(ITEM_SPAWNPOINTS) do
        if isvector(p) then
            -- Pick a random class string from your pool (e.g., "weapon_pistol", "wep_custom")
            local class = PUBLIC_ITEM_POOL[math.random(#PUBLIC_ITEM_POOL)]
            local randomWep = ents.Create(class)

            if IsValid(randomWep) then
                -- 1. Set position slightly off the floor so it doesn't get stuck in geometry
                randomWep:SetPos(p + Vector(0, 0, 5))
                
                -- 2. CRITICAL: Initialize the entity into the game world
                randomWep:Spawn()
                randomWep:Activate()
				randomWep.IsSpawned = true

                -- 3. Wake physics so the item falls naturally to the ground
                local phys = randomWep:GetPhysicsObject()
                if IsValid(phys) then
                    phys:Wake()
                end
            else
                print("[GooberZ] Failed to create item entity: " .. tostring(class))
            end
        end
    end
end

function PopulateAllVehicles()
	if not SERVER then return end
	if (not PUBLIC_GROUND_VEHICLES or #PUBLIC_GROUND_VEHICLES == 0) and (not PUBLIC_WATER_VEHICLES or #PUBLIC_WATER_VEHICLES == 0) then return end
	if (not GROUND_VEHICLES_SPAWNPOINTS or #GROUND_VEHICLES_SPAWNPOINTS == 0) and (not WATER_VEHICLES_SPAWNPOINTS or #WATER_VEHICLES_SPAWNPOINTS == 0) then return end
	
	
	for _, v in ipairs(GROUND_VEHICLES_SPAWNPOINTS) do
		local class = PUBLIC_GROUND_VEHICLES[math.random(#PUBLIC_GROUND_VEHICLES)]
		local randomVeh = ents.Create(class)
		
		if IsValid(randomVeh) then
			randomVeh:SetPos(v)
			
			randomVeh:Spawn()
			local phys = randomVeh:GetPhysicsObject()
            if IsValid(phys) then
                phys:Wake()
            end
		end
	end
	
	for _, v in ipairs(WATER_VEHICLES_SPAWNPOINTS) do
		local class = PUBLIC_WATER_VEHICLES[math.random(#PUBLIC_WATER_VEHICLES)]
		local randomVeh = ents.Create(class)
		
		if IsValid(randomVeh) then
			randomVeh:SetPos(v + Vector(0, 0, 2))
			
			randomVeh:Spawn()
			local phys = randomVeh:GetPhysicsObject()
            if IsValid(phys) then
                phys:Wake()
            end
		end
	end
	
	for _, v in ipairs(AIR_VEHICLES_SPAWNPOINTS) do
		local class = PUBLIC_AIR_VEHICLES[math.random(#PUBLIC_AIR_VEHICLES)]
		local randomVeh = ents.Create(class)
		
		if IsValid(randomVeh) then
			randomVeh:SetPos(v)
			
			randomVeh:Spawn()
			local phys = randomVeh:GetPhysicsObject()
            if IsValid(phys) then
                phys:Wake()
            end
		end
	end
end

function SpawnGooberWave(y)
    for i = 1, y do
        local spawnPos = GetRandomGooberSpawn()
		
        -- Make sure we don't spawn at origin if no spawn points exist
        if spawnPos == Vector(0,0,0) then
            print("[GooberZ] Aborting wave spawn: No valid spawn points available.")
            return
        end

        local npc = ents.Create("npc_goober")

        if IsValid(npc) then
            -- Increased scatter range from (-5, 5) to (-150, 150) so they spread out
            local x = math.random(-150, 150)
            local y = math.random(-150, 150)
            
            -- Added a tiny bit of Z offset (10) to make sure they don't get stuck under the floor
            npc:SetPos(spawnPos + Vector(x, y, 10)) 
            npc:Spawn()

            GOOBER_NPCS[npc] = true
            npc:CallOnRemove("RemoveFromList", function(ent)
                GOOBER_NPCS[ent] = nil
            end)
        end
    end

    print("[GooberZ] Spawned Goober wave with scatter offset")
end


-- Helper to fetch number of goobers
local function CountGooberNPCs()
    local count = 0
    for ent, _ in pairs(GOOBER_NPCS) do
        if IsValid(ent) then count = count + 1 end
    end
    return count
end

-- Helper to clean
local function RemoveAllGooberNPCs()
    for ent, _ in pairs(GOOBER_NPCS) do
        if IsValid(ent) then ent:Remove() end
    end
    GOOBER_NPCS = {}
end



-- Helper to fetch role info safely
local function GetRoleConfig(roleKey)
    return GM_ROLE_CONFIG[roleKey] or {
        title = "UNKNOWN ROLE",
        color = Color(200, 200, 200),
        objective = "No objective defined.",
        lore = "No lore available."
    }
end

-- Helper to fetch tips info safely
local function GetTipConfig(roleKey)
	return GM_ROLE_TIPS[roleKey] or {
		title = "UNTITLED",
		body = "NOTHING IN HERE :^|"
	}
	
	
end

-- Broadcast notice to all players
local function NotifyAll(msg)
    PrintMessage(HUD_PRINTTALK, "[Gamemode] " .. msg)
    PrintMessage(HUD_PRINTCENTER, msg)
end

-- Direct notice to single player
local function NotifyPlr(ply, msg)
    if not IsValid(ply) then return end
    net.Start("GamemodeNotifyPlr")
        net.WriteString(msg)
    net.Send(ply)
end

-- Send dynamic role instructions & lore to HUD (side card)
local function SendRoleInstructionsByKey(ply, roleKey, duration)
    if not IsValid(ply) then return end
    local cfg = GetRoleConfig(roleKey)

    net.Start("GamemodeShowRoleInstructions")
        net.WriteString(cfg.title or "")
        net.WriteColor(cfg.color or Color(200, 200, 200))
        net.WriteString(cfg.objective or "")
        net.WriteString(cfg.lore or "")
        net.WriteFloat(duration or 12)
    net.Send(ply)
end

-- Send dynamic tips to HUD
local function SendTipsByKey(ply, tipKey, duration)
	if not IsValid(ply) then return end
	local tip = GetTipConfig(tipKey)
	
	net.Start("GamemodeShowRoleTips")
		net.WriteString(tip.title or "")
		net.WriteColor(tip.color or Color(200, 200, 200))
		net.WriteString(tip.body or "")
		net.WriteFloat(duration or 12)
	net.Send(ply)
end

-- Helper to play global music
local function PlayGlobalSound(soundPath)
    if not soundPath or soundPath == "" or soundPath == "empty" then return end
    if soundPath:StartWith("sound/") then soundPath = soundPath:sub(7) end

	GM_STATE.BroadingcastingPath = soundPath
    net.Start("GamemodePlaySound")
        net.WriteString(soundPath)
    net.Broadcast()
	
    local duration = SoundDuration(soundPath)

    -- If SoundDuration fails or returns 0, reset immediately or set a safe fallback
    if not duration or duration <= 0 then
        GM_STATE.BroadingcastingPath = ""
        return
    end

    -- Automatically clear the broadcasting path after the track finishes
    timer.Simple(duration, function()
        -- Verify the current playing track is still this sound before clearing
        if GM_STATE.BroadingcastingPath == soundPath then
            GM_STATE.BroadingcastingPath = ""
        end
    end)
end

-- Helper to stop global music
local function StopGlobalSounds()
	GM_STATE.BroadingcastingPath = ""
    net.Start("GamemodeStopSound")
    net.Broadcast()
end

local function GetLMSMusicPath()
    local mode = GM_STATE.CurrentMode
    if (mode == "traitor" or mode == "mystery") and GM_STATE.LMSMusicPath_Traitor ~= "empty" then
        -- Rule: Traitor or Mystery triggers when traitor is the last one alive
        local activeTraitors = 0
        local totalAlive = 0
        
        for _, ply in ipairs(player.GetAll()) do
            if ply:Alive() then
                totalAlive = totalAlive + 1
                if ply.PlayerClassName == "traitor" then -- Adjust class check if your traitor class name differs
                    activeTraitors = activeTraitors + 1
                end
            end
        end
        
        -- If the last person alive is a traitor (or only traitors remain)
        if activeTraitors > 0 and activeTraitors == totalAlive then
            return GM_STATE.LMSMusicPath_Traitor
        end
        
    elseif mode == "vip" and GM_STATE.LMSMusicPath_VIP ~= "empty" then
        -- Rule: VIP triggers when doctor is last one alive
        local activeDoctors = 0
        local totalAlive = 0
        
        for _, ply in ipairs(player.GetAll()) do
            if ply:Alive() then
                totalAlive = totalAlive + 1
                if ply.PlayerClassName == "doctor" then
                    activeDoctors = activeDoctors + 1
                end
            end
        end
        
        -- If the last person alive is the doctor
        if activeDoctors > 0 and activeDoctors == totalAlive then
            return GM_STATE.LMSMusicPath_VIP or GM_STATE.LMSMusicPath
        end
    end

    return GM_STATE.LMSMusicPath
end
local function SyncGamemodeToClients()
    net.Start("GamemodeSyncTimer")
        net.WriteString(GM_STATE.CurrentMode or "")
        net.WriteFloat(GM_STATE.EndTime or 0)
        net.WriteBool(GM_STATE.InProgress or false)
    net.Broadcast()
end

local function GetActivePlayers()
    local active = {}

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end

        -- Exclude custom spectator pool / class
        if SPECTATORS and SPECTATORS[ply] then continue end
        if ply.PlayerClassName == "spectator" then continue end
        if ply.GetNetVar and ply:GetNetVar("IsSpectator", false) then continue end

        -- Still in play: alive or Homigrad fake-ragdoll
        local isFakeRagdoll = (hg and hg.ragdollFake and IsValid(hg.ragdollFake[ply]))
            or ply.Fake
            or ply.fake

        if ply:Alive() or isFakeRagdoll then
            table.insert(active, ply)
        end
    end

    return active
end

local function IsPlayerHandcuffed(ply)
    if not IsValid(ply) then return false end
    if ply:GetNetVar("handcuffed", false) or ply.handcuffed then return true end

    local ragdoll = ply:GetNWEntity("Ragdoll") or ply.ragdoll
    if IsValid(ragdoll) and (ragdoll.handcuffed or ragdoll:GetNetVar("handcuffed", false)) then
        return true
    end

    return false
end

function CleanPlayerCorpse(ply)
    if not SERVER or not IsValid(ply) then return end

    -- Safety check: NEVER clean/remove a corpse or ragdoll if the player is currently alive or active using a fake ragdoll!
    local isFakeRagdoll = (hg and hg.ragdollFake and hg.ragdollFake[ply]) or ply.Fake or ply.fake
    if ply:Alive() or isFakeRagdoll then return end

    local rag = ply:GetRagdollEntity()
    if IsValid(rag) then rag:Remove() end

    local nwRag = ply:GetNWEntity("Ragdoll") or ply.Ragdoll or ply.ragdoll
    if IsValid(nwRag) then nwRag:Remove() end

    if hg and hg.ragdollFake then
        local fakeRag = hg.ragdollFake[ply]
        if IsValid(fakeRag) then fakeRag:Remove() end
        hg.ragdollFake[ply] = nil
    end

    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) then
            local class = ent:GetClass()
            if class == "prop_ragdoll" or class == "hl2mp_ragdoll" or class == "hg_ragdoll" or class == "fakeplayer" then
                local isOwner = (ent:GetRagdollOwner() == ply) or 
                                (ent.Player == ply) or 
                                (ent.Owner == ply) or 
                                (ent.ply == ply) or 
                                (ent:GetNWEntity("RagdollOwner") == ply) or 
                                (hg and hg.RagdollOwner and hg.RagdollOwner(ent) == ply)

                -- Double-check that the owner isn't accidentally being stripped while active
                if isOwner and not (ply:Alive() or isFakeRagdoll) then 
                    ent:Remove() 
                end
            end
        end
    end

    if not isFakeRagdoll then
        ply:SetNWEntity("Ragdoll", NULL)
    end
end

function CleanAllCorpses()
    if not SERVER then return end
    for _, ply in ipairs(player.GetAll()) do CleanPlayerCorpse(ply) end
    for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do if IsValid(ent) then ent:Remove() end end
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) then
            local class = ent:GetClass()
            if class == "hl2mp_ragdoll" or class == "hg_ragdoll" or class == "fakeplayer" then
                ent:Remove()
            end
        end
    end
end

function CleanAllDiscardedWeapons()
	if not SERVER then return end
	local weapons = ents.FindByClass("weapon_*")
	for _, wep in ipairs(weapons) do wep:Remove() end
	print("[GooberZ] Cleared all dropped weapons")
end

function CleanAllVehicles()
	if not SERVER then return end
	local vehicles = ents.FindByClass("gtav_*")
	for _, veh in ipairs(vehicles) do veh:Remove() end
end

local entityList = {
    ["ent_gz_ammo_limited_crate"] = true,
    ["ent_hg_grenade_bioenergy"]  = true,
    ["ent_hg_grenade_energy"]     = true,
}

function CleanAllTempEnts()
    if not SERVER then return end
    
    local count = 0
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and entityList[ent:GetClass()] then
            ent:Remove()
            count = count + 1
        end
    end
    
    print("[GooberZ] Cleared " .. count .. " temporary entities.")
end

-- Role assignment helper that triggers side HUD update automatically (Updated to accept role presets)
local meleePool = {
	"weapon_bat",
	"weapon_buck200knife",
	"weapon_hg_crowbar",
	"weapon_leadpipe",
	"weapon_hg_shovel",
	"weapon_pocketknife",
}

local function RandomMelee(ply)
	if not IsValid(ply) then return end

	local rand = math.random(1, #meleePool)
	local melee = meleePool[rand]
	
	ply:Give(melee)
end

local function GetSpawnZonesOfType(zoneType)
	local list = {}
	for _, zone in ipairs(_G.SPAWN_ZONES) do
		
		if zone.spawnType == zoneType then
			table.insert(list, zone)
		end
	end
	
	return list
end

local function SpawnAtZone(ply, zoneType)
    local zones = GetSpawnZonesOfType(zoneType)
    
    -- Ensure zones exist before trying to pick one
    if not zones or #zones == 0 then return end
    
    local zone = zones[math.random(1, #zones)]
    
    -- Pick a random coordinate within min/max boundaries for X, Y, and Z
    local randomX = math.Rand(zone.min.x, zone.max.x)
    local randomY = math.Rand(zone.min.y, zone.max.y)
    
    -- Optional offset (+10) on Z to prevent the player from spawning clipped into the ground
    local randomZ = math.Rand(zone.min.z, zone.max.z) + 10 
    
    local spawnPos = Vector(randomX, randomY, randomZ)
    
    ply:Spawn()
    ply:SetPos(spawnPos)
end

local function ApplyPlayerClass(ply, className, customRoleKey, presetRole, presetPriority)
    if not IsValid(ply) then return end

    -- Store preset data on the player so CLASS.On can access them when SetPlayerClass triggers
    if presetRole then ply.PendingRole = presetRole end
    if presetPriority then ply.PendingPriority = presetPriority end

    timer.Simple(0.05, function()
        if not IsValid(ply) or not ply:Alive() then return end

        if ply.SetPlayerClass then
			
            ply:SetPlayerClass(className)
			if GM_STATE.CurrentMode == "test" then
				ply:Give("weapon_physgun")
				ply:Give("gmod_tool")
			end

            if className == "default" or className == "bystander" then
                ply:StripWeapons()
                ply:StripAmmo()
                ply.armors = {}
                ply.armors_health = {}
				
                local flashlight = ply:Give("hg_flashlight")
                if IsValid(flashlight) then flashlight:Use(ply) end
            end
			
        end
		
		GiveSafeHands(ply)
		
		if className == "default" then
			RandomMelee(ply)
		end

        -- Trigger side HUD notification on role change
        local roleKey = customRoleKey or CLASS_TO_ROLE_KEY[className] or "survivor"
        SendRoleInstructionsByKey(ply, roleKey, 12)
    end)
end

-- Global helper to change player role mid-round (Updated to support optional preset arguments)
function ChangePlayerRoleMidRound(ply, newClassName, customRoleKey, presetRole, presetPriority)
    if not IsValid(ply) or not GM_STATE.InProgress then return end
    ApplyPlayerClass(ply, newClassName, customRoleKey, presetRole, presetPriority)
    NotifyPlr(ply, "YOUR ROLE HAS CHANGED!")
end
-- Advanced Assimilation Logic based on previous class and infection state
function AssimilatePlayer(ply)
    if not IsValid(ply) or not GM_STATE.InProgress then return end

    local gooberCount = 0
    for _, p in ipairs(GetActivePlayers()) do
        local className = p.PlayerClassName or (p.GetPlayerClass and p:GetPlayerClass()) or "default"
        if className == "goober" then
            gooberCount = gooberCount + 1
        end
    end

    local previousClass = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
    local newRoleKey = "infected"

    if gooberCount == 0 then
        newRoleKey = "patient_zero"
    else
        if previousClass == "humanityForces" then
            newRoleKey = "fallen_soldier"
        elseif previousClass == "traitor" then
            newRoleKey = "far_gone_traitor"
        elseif previousClass == "bystander" or previousClass == "default" then
            newRoleKey = "uncounted_lost"
		elseif previousClass == "doctor" then
			newRoleKey = "fallen_doctor"
        end
    end

    ApplyPlayerClass(ply, "goober", newRoleKey)
    NotifyPlr(ply, "YOU HAVE BEEN ASSIMILATED!")
end

-------------------------------------------------------------------
-- Zone helpers
-------------------------------------------------------------------

-- Is a position inside an AABB zone?
local function PosInZone(pos, zone)
    if not pos or not zone or not zone.min or not zone.max then return false end
    local mins, maxs = zone.min, zone.max
    return pos.x >= mins.x and pos.x <= maxs.x
       and pos.y >= mins.y and pos.y <= maxs.y
       and pos.z >= mins.z and pos.z <= maxs.z
end

-- Is this player currently inside ANY escort zone?
function IsPlayerInEscortZone(ply)
    if not IsValid(ply) then return false end

    local pos = ply:GetPos()
    -- Prefer physical body if faked/ragdolled
    if hg and hg.GetCurrentCharacter then
        local char = hg.GetCurrentCharacter(ply)
        if IsValid(char) then pos = char:GetPos() end
    end

    for _, zone in ipairs(_G.ESCORT_ZONES or {}) do
        if PosInZone(pos, zone) then
            return true, zone
        end
    end
    return false, nil
end

-- Is this player inside a zone AND matching a class / class list?
-- classFilter can be:
--   nil / false  → any class
--   "goober"     → only that class
--   {"goober","humanityForces"} → any of these
function IsPlayerInEscortZoneByClass(ply, classFilter)
    local inZone, zone = IsPlayerInEscortZone(ply)
    if not inZone then return false, nil end

    if not classFilter then
        return true, zone
    end

    local className = ply.PlayerClassName
        or (ply.GetPlayerClass and ply:GetPlayerClass())
        or "default"

    if isstring(classFilter) then
        return className == classFilter, zone
    end

    if istable(classFilter) then
        for _, c in ipairs(classFilter) do
            if className == c then
                return true, zone
            end
        end
    end

    return false, zone
end

-- Count players in escort zones (optional class filter)
function CountPlayersInEscortZones(classFilter)
    local count = 0
    local list = {}

    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() and ply:Team() ~= TEAM_SPECTATOR then
            if IsPlayerInEscortZoneByClass(ply, classFilter) then
                count = count + 1
                table.insert(list, ply)
            end
        end
    end

    return count, list
end

-- Are ALL living players of a class inside zones? (e.g. escort objective)
function AreAllClassInEscortZones(className)
    local total, inside = 0, 0

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() or ply:Team() == TEAM_SPECTATOR then continue end

        local class = ply.PlayerClassName
            or (ply.GetPlayerClass and ply:GetPlayerClass())
            or "default"

        if class == className then
            total = total + 1
            if IsPlayerInEscortZone(ply) then
                inside = inside + 1
            end
        end
    end

    if total == 0 then return false, 0, 0 end
    return inside >= total, inside, total
end

-- Is there a living player with a briefcase in the zones
function IsCarrierInEscortZones(classFilter)
	--IsHoldingBriefcase
	local count, list = CountPlayersInEscortZones(classFilter)
	
	if count <= 0 then return false end
	
	for _, plr in pairs(list) do
		if plr.GetNetVar and plr:GetNetVar("IsHoldingBriefcase", false) == true then
			return true
		end
	end
	
	
	return false
end

-- ====================================================================
-- GAMEMODE STARTERS
-- ====================================================================
-- Gets dynamic priority with support for flat/fixed bias if min and max are the same
local function GetDynamicHumanityPriority(minPriority, maxPriority)
    minPriority = minPriority or 1
    maxPriority = maxPriority or 3

    -- Condition: If min and max are the same number (e.g. 2, 2), just return that exact value immediately
    if minPriority == maxPriority then
        return minPriority
    end

    -- Count current active Humanity Forces
    local hfCount = 0
    for _, ply in ipairs(GetActivePlayers()) do
        local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
        if className == "humanityForces" then
            hfCount = hfCount + 1
        end
    end

    -- Fewer players = Higher priority/tier (3 is best gear, 1 is standard)
    local calculatedPriority = minPriority
    
    if hfCount >= 6 then
        calculatedPriority = minPriority -- Lowest tier when heavily populated
    elseif hfCount >= 3 then
        calculatedPriority = math.floor((minPriority + maxPriority) / 2) -- Medium reinforcement
    else
        calculatedPriority = maxPriority -- Highest tier when severely outnumbered
    end

    -- Clamp the result strictly between the bias boundaries
    return math.Clamp(calculatedPriority, minPriority, maxPriority)
end



function CallForReinforcements(reinType)
	if reinType == "humanityForces" then
		for spec, _ in pairs(_G.SPECTATORS) do
			spec:Spawn()
			
			timer.Simple(0.5, function()
				local p = GetDynamicHumanityPriority(2, 3)
				ApplyPlayerClass(spec, "humanityForces", "reinforcements_hf", nil, p) 
			end)
		end
	elseif reinType == "traitor" then
		for spec, _ in pairs(_G.SPECTATORS) do
			spec:Spawn()
			
			timer.Simple(0.5, function()
				ApplyPlayerClass(spec, "traitor", "reinforcements_hf", nil, 0) 
			end)
		end
	end
end



-- for modes that can played by one person
local specialCases = {
	["test"] = true,
	["test_escort"] = true,
	["breach"] = true,
	["zone-clearence"] = true,
}
-- Global queue table to store players waiting for the round reset / spawn sync
local roundSpawnQueue = {}

function StartGamemode(modeName, duration)
    local players = player.GetAll()
    if #players < 2 and not specialCases[modeName] then
        NotifyAll("Not enough players to start a round! (Minimum 2 required)")
        return
    end

    StopGlobalSounds()
    CleanAllCorpses()
	CleanAllDiscardedWeapons()
	CleanAllVehicles()
	CleanAllTempEnts()
	
	PopulateAllItemSpawns()
	PopulateAllVehicles()

    GM_STATE.CurrentMode = modeName
    GM_STATE.InProgress = true
    GM_STATE.RoundTime = duration or 300
    GM_STATE.EndTime = CurTime() + GM_STATE.RoundTime
    GM_STATE.LastManStandingTriggered = false
    
    -- Play round theme
	if GM_STATE.RoundThemePath and GM_STATE.RoundThemePath ~= "empty" then
		PlayGlobalSound(GM_STATE.RoundThemePath)
	end


    -- Shuffle players first so role assignments are randomized
    table.Shuffle(players)

    -- 1. DETERMINE ROLES AHEAD OF TIME AND STORE IN THE QUEUE
    roundSpawnQueue = {}
	
	local function Queue(role, keyR, tag, rolePrior)
		if not role then role = "" end
		if not keyR then keyR = "" end
		if not tag then tag = "" end
		if not rolePrior then rolePrior = 1 end
		
		
		return { newRole = role, roleKey = keyR, speicalTag = tag, priority = rolePrior }
	end

    if modeName == "infection" then
        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i == 1 then
                roundSpawnQueue[uid] = Queue("goober", "patient_zero", "none")
            elseif i <= math.ceil(#players / 2) then
				local dynPriority = GetDynamicHumanityPriority(1, 2)
                roundSpawnQueue[uid] = Queue("humanityForces", "infection_humanity", "none", dynPriority)
            else
                roundSpawnQueue[uid] = Queue("default", "survivor", "none")
            end
        end

    elseif modeName == "war" then
        local half = math.floor(#players / 2)
        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i <= half then
                roundSpawnQueue[uid] = Queue("traitor", "traitor_humanity", "none")
            else
				local dynPriority = GetDynamicHumanityPriority(1, 3)
                roundSpawnQueue[uid] = Queue("humanityForces", "war_humanity", "none", dynPriority)
            end
        end

    elseif modeName == "containment" then
        local gooberCount = math.max(1, math.floor(#players * 0.33))
        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i <= gooberCount then
                roundSpawnQueue[uid] = Queue("goober", "containment_subject", "none")
            else
				local dynPriority = GetDynamicHumanityPriority(2, 3)
                roundSpawnQueue[uid] = Queue("humanityForces", "containment_unit", "none", dynPriority)
            end
        end

    elseif modeName == "traitor" then
        local traitorCount = (#players >= 6) and 2 or 1
        local officerCount = math.floor((#players - traitorCount) / 2)

        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i <= traitorCount then
                roundSpawnQueue[uid] = Queue("traitor", "traitor", "none")
            elseif i <= (traitorCount + officerCount) then
				local dynPriority = GetDynamicHumanityPriority(2, 3)
                roundSpawnQueue[uid] = Queue("humanityForces", "traitor_humanity", "none")
            else
                roundSpawnQueue[uid] = Queue("default", "innocent", "none")
            end
        end

    elseif modeName == "mystery" then
        local traitorCount = (#players >= 6) and 2 or 1
        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i <= traitorCount then
                roundSpawnQueue[uid] = Queue("traitor", "mystery_traitor", "none")
            else
				local dynPriority = GetDynamicHumanityPriority(1, 3)
                roundSpawnQueue[uid] = Queue("humanityForces", "mystery_humanity", "none", dynPriority)
            end
        end
        
    elseif modeName == "zone-clearence" then
        local plrCount = 0
        for _, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            plrCount = plrCount + 1
			
			local dynPriority = GetDynamicHumanityPriority(2, 3)
            roundSpawnQueue[uid] = Queue("humanityForces", "zone_clearence_operator", "none", dynPriority)
        end
        SpawnGooberWave(plrCount * GM_STATE.ZoneClearenceDiffculty)
        
    elseif modeName == "breach" then
        for _, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
			local dynPriority = GetDynamicHumanityPriority(1, 2)
            roundSpawnQueue[uid] = Queue("humanityForces", "breach_guard", "none", dynPriority)
        end
        
        timer.Simple(3, function()
            NotifyAll("Here they come.")
            SpawnGooberWave(math.random(7, 11))
        end)

    elseif modeName == "vip" then
        local length = (#players >= 4) and 2 or 1
        local hasVIP = false

        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i == 1 then
                roundSpawnQueue[uid] = Queue("goober", "patient_zero", "none")
            elseif not hasVIP then
                hasVIP = true
                roundSpawnQueue[uid] = Queue("doctor", "vip_doctor", "none")
            else
				local dynPriority = GetDynamicHumanityPriority(2, 3)
                roundSpawnQueue[uid] = Queue("humanityForces", "body_guard", "none")
            end
        end
    elseif modeName == "defense" then
		local half = math.floor(#players / 2)
		
		local gaveBriefcase = false
        for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i <= half then
                roundSpawnQueue[uid] = Queue("traitor", "traitor_offense", "none")
				
            else
				local dynPriority = GetDynamicHumanityPriority(2, 3)
				if not gaveBriefcase then
					
					 roundSpawnQueue[uid] = Queue("humanityForces", "humanity_defendant", "carrier", dynPriority)
				else
					 roundSpawnQueue[uid] = Queue("humanityForces", "humanity_defendant", "none", dynPriority)
				end
            end
        end
	elseif modeName == "no-mercy" then
		local hasViligante = false
		 for i, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            if i == 1 then
                roundSpawnQueue[uid] = Queue("goober", "patient_zero", "none")
			else
				if not hasViligante then
					roundSpawnQueue[uid] = Queue("default", "no_mercy_viligante", "viligante")
					hasViligante = true
				else
					roundSpawnQueue[uid] = Queue("default", "no_mercy_survivor", "none")
					
				end
				
			end
		end
    elseif modeName == "test" or modeName == "test_escort" then
        for _, ply in ipairs(players) do
            if not IsValid(ply) then continue end
            local uid = ply:UniqueID()
            roundSpawnQueue[uid] = Queue("default", "test_subject", "none")
        end
    else
        NotifyAll("Unknown gamemode: " .. tostring(modeName))
        GM_STATE.InProgress = false
        return
    end

    -- 2. EXECUTE THE SPAWN & SYNC PROCESS FOR ALL PLAYERS
    for _, ply in ipairs(players) do
        if IsValid(ply) then
            -- Properly trigger Homigrad's gettingup transition instead of cutting it abruptly
            ply.gettingup = CurTime()
            
            -- Clear legacy or custom fake indicators
            ply.Fake = false
            ply.fake = false
            ply.Bleeding = 0
            
            if hg and hg.ragdollFake then
                local fakeRag = hg.ragdollFake[ply]
                if IsValid(fakeRag) then
                    fakeRag:Remove()
                end
                hg.ragdollFake[ply] = nil
            end

            ply:SetNWEntity("Ragdoll", NULL)
            ply:SetNWBool("Faking", false)

            -- Clean up lingering model props
            for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
                if IsValid(ent) and (ent:GetRagdollOwner() == ply or ent.Player == ply) then
                    ent:Remove()
                end
            end

            timer.Simple(0.05, function()
                if not IsValid(ply) then return end
				
				-- Retrieve role data from our synchronized queue using UniqueID
                local uid = ply:UniqueID()
                local queueData = roundSpawnQueue[uid]
				

                -- Safely respawn
				local spawnType = "default"
				
				if ((queueData.newRole == "humanityForces" or queueData.newRole == "traitor") and (GM_STATE.CurrentMode == "traitor" or GM_STATE.CurrentMode == "mystery")) or (queueData.newRole == "doctor" and GM_STATE.CurrentMode == "vip") or (queueData.newRole == "humanityForces") then
					spawnType = "hf/t"
				elseif (queueData.newRole == "goober") or (queueData.newRole == "traitor" and (GM_STATE.CurrentMode == "war" or GM_STATE.CurrentMode == "defense")) then
					spawnType = "infected"
				end
				
                SpawnAtZone(ply, spawnType)
                ply:StripWeapons()
                ply:StripAmmo()
                ply.armors = {}
                ply.armors_health = {}
                
                if queueData then
                    -- Apply the role safely right after spawn initialization
                    if queueData.newRole == "humanityForces" then
                      
                        ApplyPlayerClass(ply, queueData.newRole, queueData.roleKey, "none", queueData.priority)
                    else
                        ApplyPlayerClass(ply, queueData.newRole, queueData.roleKey)
                    end
					
					
					timer.Simple(0.5, function()
						local tag = queueData.speicalTag
						print(tag)
						if tag == "carrier" then
							ply:Give("weapon_briefcase_objective")
						elseif tag == "viligante" then
							ply:Give("weapon_mosin_vig")
							 ply:GiveAmmo(64, "7.62x54 mm Energy", true)
						end
					end)

                end
				
			
            end)
        end
    end

    NotifyAll("Gamemode started! Look top-left for your role!")

    if GM_STATE.RoundThemePath ~= "empty" then
        PlayGlobalSound(GM_STATE.RoundThemePath)
    end

    SyncGamemodeToClients()
end
-- ====================================================================
-- WIN CONDITIONS & ROUND CHECKING
-- ====================================================================

local function EndRound(winnerMessage)
    -- Immediately block win checks from firing again
    GM_STATE.InProgress = false 
    GM_STATE.CurrentMode = nil
    GM_STATE.LastManStandingTriggered = false

    NotifyAll(winnerMessage)
    StopGlobalSounds()
    SyncGamemodeToClients()
	RemoveAllGooberNPCs()
	PlayGlobalSound(GM_STATE.VictoryThemePath)

    timer.Simple(5, function()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) then
                ply:Kill()
                ply:Spawn()
                ply:StripWeapons()
                ply:StripAmmo()
                ply.armors = {}
                ply.armors_health = {}
                
				ply:SetNetVar("AssimilationProgress", 0)
				GiveSafeHands(ply)
				ply:SetNetVar("ShowPathToEscort", false)
            end
        end
        CleanAllCorpses()
		CleanAllDiscardedWeapons()
		CleanAllTempEnts()
    end)
end

local function TriggerLMS(targetPly, alertMessage)
    GM_STATE.LastManStandingTriggered = true

    local remainingTime = GM_STATE.EndTime - CurTime()
    if remainingTime > 75 then
        GM_STATE.EndTime = CurTime() + 75
        SyncGamemodeToClients()
    end

    NotifyAll(alertMessage or "LAST MAN STANDING! 1 Minute 15 Seconds left!")

    StopGlobalSounds()
	PlayGlobalSound(GetLMSMusicPath())

    if IsValid(targetPly) then
        NotifyPlr(targetPly, "HIDE...")
        SendRoleInstructionsByKey(targetPly, "lms", 15)
        
        local org = targetPly.organism
        if org then
            org.adrenaline = (org.adrenaline or 0) + 10
        elseif hg and hg.organism and hg.organism[targetPly] then
            hg.organism[targetPly].adrenaline = (hg.organism[targetPly].adrenaline or 0) + 10
        end
    end
end

hook.Add("Think", "GamemodeWinConditionCheck", function()
    -- Guard check: do not process if no round is running
    if not GM_STATE.InProgress or not GM_STATE.CurrentMode then return end

    -- NEW: Wait at least 2 seconds after starting before checking win conditions 
    -- This prevents instant wins while player classes and loadouts initialize
    if GM_STATE.EndTime - CurTime() > (GM_STATE.RoundTime - 2) then return end

    if (GM_STATE.NextCheck or 0) > CurTime() then return end
    GM_STATE.NextCheck = CurTime() + 1

    local activePlayers = GetActivePlayers()

    -- GUARD: Ensure players are fully spawned and loaded before checking win states
    if #activePlayers < 2 and not specialCases[GM_STATE.CurrentMode] then return end

    local counts = {
        goober = 0,
        gooberHandcuffed = 0,
        traitor = 0,
        traitorHandcuffed = 0,
        humanityForces = 0,
        bystander = 0,
		doctor = 0,
        default = 0
    }

    for _, ply in ipairs(activePlayers) do
        local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"

        if className == "goober" then
            if IsPlayerHandcuffed(ply) then
                counts.gooberHandcuffed = counts.gooberHandcuffed + 1
            else
                counts.goober = counts.goober + 1
            end
        elseif className == "traitor" then
            if IsPlayerHandcuffed(ply) then
                counts.traitorHandcuffed = counts.traitorHandcuffed + 1
            else
                counts.traitor = counts.traitor + 1
            end
        elseif counts[className] ~= nil then
            counts[className] = counts[className] + 1
        end
    end

    local totalActiveGoobers = counts.goober
    local totalHandcuffedGoobers = counts.gooberHandcuffed
    local totalActiveTraitors = counts.traitor
    local totalHandcuffedTraitors = counts.traitorHandcuffed
    local totalHumans = counts.humanityForces + counts.bystander + counts.default + counts.doctor
	local totalVIPs = counts.doctor
	
	
    -- Check if time ran out
    if CurTime() >= GM_STATE.EndTime then
		StopGlobalSounds()
		
        if GM_STATE.CurrentMode == "infection" or GM_STATE.CurrentMode == "breach" or GM_STATE.CurrentMode == "no-mercy" then
            EndRound("TIME'S UP! Humanity Forces survived the outbreak!")
        elseif GM_STATE.CurrentMode == "traitor" or GM_STATE.CurrentMode == "mystery"  then
			 -- More humans than traitors → HF / civilians hold the sector
			if totalHumans > totalActiveTraitors then
				EndRound("TIME'S UP! Humanity Forces win by surviving!")

			-- No humans, at least one traitor still human → mole walks out
			elseif totalHumans == 0 and totalActiveTraitors > 0 then
				EndRound("TIME'S UP! Traitors win — still human, sector theirs!")

			-- No humans, no traitors, infection remains → full cure
			elseif totalHumans == 0 and totalActiveTraitors == 0
				and (totalActiveGoobers > 0 or totalHandcuffedGoobers > 0) then
				EndRound("TIME'S UP! The cure took everyone!")

			-- Equal human/traitor counts, both alive
			else
				EndRound("TIME'S UP! Stalemate — sector contested!")
			end
        elseif GM_STATE.CurrentMode == "war" or GM_STATE.CurrentMode == "zone-clearence"  or GM_STATE.CurrentMode == "containment" then
            EndRound("TIME'S UP! Stalemate!")
		elseif GM_STATE.CurrentMode == "defense" then
			 EndRound("TIME'S UP! Humanity Forces defended the briefcase")
        elseif GM_STATE.CurrentMode == "test" or GM_STATE.CurrentMode == "test_escort" then
            EndRound("TEST COMPLETED!")
        end
        return
	else
		if GM_STATE.BroadingcastingPath == "" then
			PlayGlobalSound(GM_STATE.RoundThemePath)
		end
    end


    -------------------------------------------------------------------
    -- WIN EVALUATION BY MODE
    -------------------------------------------------------------------

    if GM_STATE.CurrentMode == "infection" then
        if totalHumans == 0 then
            EndRound("CORP ASSIMILATION VICTORY! All humans were converted!")
            return
		elseif totalActiveGoobers == 0 then
			EndRound("HUMANITY FORCES VICTORY! All goobers have been contained/neutralized!")
			return
        end

        if totalHumans == 1 and not GM_STATE.LastManStandingTriggered and (totalActiveGoobers > 0 or totalHandcuffedGoobers > 0) then
            local lastHuman
            for _, ply in ipairs(activePlayers) do
                local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
                if className == "humanityForces" or className == "bystander" or className == "default" then
                    lastHuman = ply
                    break
                end
            end
            TriggerLMS(lastHuman, "LAST SURVIVOR STANDING! Resist the Corp's cure!")
        end

    elseif GM_STATE.CurrentMode == "containment" then
        if totalHumans == 0 then
            EndRound("CORP VICTORY! Humanity Forces were wiped out!")
            return
        end

        if totalActiveGoobers == 0 then
            if totalHandcuffedGoobers > 0 then
                EndRound("HUMANITY VICTORY! All goobers have been contained!")
            else
                EndRound("HUMANITY VICTORY! All goobers have been neutralized!")
            end
            return
        end

        if totalHumans == 1 and not GM_STATE.LastManStandingTriggered and (totalActiveGoobers > 0 or totalHandcuffedGoobers > 0) then
            local lastHuman
            for _, ply in ipairs(activePlayers) do
                local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
                if className == "humanityForces" or className == "bystander" or className == "default" then
                    lastHuman = ply
                    break
                end
            end
            TriggerLMS(lastHuman, "CONTAINMENT EMERGENCY! Last Operative Standing!")
        end

    elseif GM_STATE.CurrentMode == "war" then
        if totalHumans == 0 then
            EndRound("CORP VICTORY! Humanity Forces eliminated!")
            return
        end

        if totalActiveTraitors == 0 then
            EndRound("HUMANITY VICTORY! All Corp loyalists eliminated!")
            return
        end

    elseif GM_STATE.CurrentMode == "traitor" or GM_STATE.CurrentMode == "mystery" then
        if totalHumans == 0 then
            EndRound("CORP VICTORY! The Corp took control!")
            return
        end

        if totalActiveTraitors == 0 and totalActiveGoobers == 0 then
            EndRound("HUMANITY VICTORY! Corp traitors eliminated and any infected that was created!")
            return
        end

        if totalHumans == 1 and not GM_STATE.LastManStandingTriggered and (totalActiveTraitors > 0 or totalHandcuffedTraitors > 0) then
            local lastHuman
            for _, ply in ipairs(activePlayers) do
                local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
                if className == "humanityForces" or className == "bystander" or className == "default" then
                    lastHuman = ply
                    break
                end
            end
            TriggerLMS(lastHuman, "LAST SURVIVOR STANDING! Survive against Corp infiltrators!")
		elseif totalActiveTraitors == 1 and not GM_STATE.LastManStandingTriggered and (totalHumans == 0 and (totalActiveGoobers > 0 or totalHandcuffedGoobers > 0)) then
			local lastHuman
            for _, ply in ipairs(activePlayers) do
                local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
                if className == "traitor" then
                    lastHuman = ply
                    break
                end
            end
            TriggerLMS(lastHuman, "TRAITOR'S GETAWAY! Flee or not, from the chaos you caused!")
        end
	elseif GM_STATE.CurrentMode == "zone-clearence" then
		if CountGooberNPCs() == 0 and totalActiveGoobers == 0 and totalHandcuffedGoobers == 0 then
			EndRound("ZONE CLEARANCE COMPLETE! All Goobers eliminated or detained!")
			return
		elseif totalHumans == 0 then
			EndRound("ZONE CLEARANCE FAILED! All operators were assimilated..")
		end
	elseif GM_STATE.CurrentMode == "breach" then
		if CountGooberNPCs() < 10 then
			SpawnGooberWave(math.random(7, 11))
		end

		if totalHumans == 0 then
			EndRound("BREACH FAILURE! All Humanity Forces were assimilated or killed!")
			return
		end
	elseif GM_STATE.CurrentMode ==  "vip" then
		if totalVIPs == 0 then
			EndRound("VIP FAILURE! VIP was killed or assimilated")
			return
		end
		
		local bool,c1, c2 = AreAllClassInEscortZones("doctor")
		if bool then
			EndRound("VIP ESCAPED! VIP was successfully escort or escaped to the zone!")
			return
		end
		
		if totalHumans == 0 and totalVIPs == 1 and not GM_STATE.LastManStandingTriggered then
			local lastHuman
            for _, ply in ipairs(activePlayers) do
                local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
                if className == "doctor" then
                    lastHuman = ply
                    break
                end
            end
            TriggerLMS(lastHuman, "VIP IS ALONE! This is their last sprint to the escape.")
		end
	elseif GM_STATE.CurrentMode == "defense" then
		if totalHumans == 0 then
			EndRound("DEFENSE FAILURE! All Humanity Forces Defendants were assimilated or killed!")
			return
		end
		
		if totalActiveTraitors == 0 then
			EndRound("DEFENSE SUCCESS! All Traitors were detained/neutralized!")
			return
		end
		
		local bool = IsCarrierInEscortZones("traitor")
		if bool then
			EndRound("DEFENSE FAILURE! Traitors had stole the briefcase")
			return
		end
	elseif GM_STATE.CurrentMode == "no-mercy" then
		if totalHumans == 0 then
			EndRound("CORP ASSIMILATION VICTORY! All humans were converted!")
			return
		end
		
		if totalActiveGoobers == 0 then
			EndRound("SURVIVORS VICTORY! All assimilated subjects were killed somehow?")
			return
		end
		
		if totalHumans == 1 and not GM_STATE.LastManStandingTriggered then
			local lastHuman
            for _, ply in ipairs(activePlayers) do
                local className = ply.PlayerClassName or (ply.GetPlayerClass and ply:GetPlayerClass()) or "default"
                if className == "humanityForces" or className == "bystander" or className == "default" then
                    lastHuman = ply
                    break
                end
            end
			
			TriggerLMS(lastHuman, "AND THEN THERE WAS ONE....")
			lastHuman:SetNetVar("ShowPathToEscort", true)
			
		elseif totalHumans == 1 and GM_STATE.LastManStandingTriggered then
		
			local bool, _, _ = AreAllClassInEscortZones("default")
			if bool then
				EndRound("SOLE SURVIVOR VICTORY! The last one escaped")
				return
			end
		end
	elseif GM_STATE.CurrentMode == "test_escort" then
		local bool,c1, c2 = AreAllClassInEscortZones("default")
		print(bool, c1, c2)
		if bool then
			EndRound("TEST COMPLETED DUE TO ESCORT ZONES BEING FILLED")
			return
		end
    end
end)

-- ====================================================================
-- CLIENT RECEIVERS & SIDE HUD DISPLAY
-- ====================================================================
if CLIENT then
    local clientEndTime = 0
    local clientMode = ""
    local clientInProgress = false
    local activeGlobalSound = nil

    local roleData = {
        title = "",
        color = Color(255, 255, 255),
        objective = "",
        lore = "",
        hideTime = 0
    }
	
	local tipData = {
		title = "",
		color = Color(255, 255, 255),
		body = "",
		hideTime = 0
	}

    net.Receive("GamemodeSyncTimer", function()
        clientMode = net.ReadString()
        clientEndTime = net.ReadFloat()
        clientInProgress = net.ReadBool()
    end)

    net.Receive("GamemodeNotifyPlr", function()
        local msg = net.ReadString()
        chat.AddText(Color(255, 200, 0), "[Role Notice] ", Color(255, 255, 255), msg)
        notification.AddLegacy(msg, NOTIFY_HINT, 5)
    end)

    net.Receive("GamemodeShowRoleInstructions", function()
        roleData.title = net.ReadString()
        roleData.color = net.ReadColor()
        roleData.objective = net.ReadString()
        roleData.lore = net.ReadString()
        local duration = net.ReadFloat()
        roleData.hideTime = CurTime() + (duration > 0 and duration or 12)
    end)
	
	net.Receive("GamemodeShowRoleTips", function()
		tipData.title = net.ReadString()
		tip.color = net.ReadColor()
		tip.body = net.ReadString()
		local duration = net.ReadFloat()
        roleData.hideTime = CurTime() + (duration > 0 and duration or 12)
	end)

    net.Receive("GamemodePlaySound", function()
        local soundPath = net.ReadString()
        if soundPath and soundPath ~= "" and soundPath ~= "empty" then
            if activeGlobalSound then activeGlobalSound:Stop() end
            activeGlobalSound = CreateSound(LocalPlayer(), soundPath)
            if activeGlobalSound then activeGlobalSound:Play() end
        end
    end)

    net.Receive("GamemodeStopSound", function()
        if activeGlobalSound then
            activeGlobalSound:Stop()
            activeGlobalSound = nil
        end
    end)

    -- HUD Render (Top-Center Timer + Top-Left Side Role/Lore Card)
    local function DrawRoundHUD()
        if not clientInProgress or clientEndTime <= 0 then return end

        -- 1. Top-Center Timer
        local timeRemaining = math.max(0, math.ceil(clientEndTime - CurTime()))
        local minutes = math.floor(timeRemaining / 60)
        local seconds = timeRemaining % 60
        local timeStr = string.format("%02d:%02d", minutes, seconds)
        local timerText = string.upper(clientMode) .. " - " .. timeStr
        
        surface.SetFont("DermaLarge")
        local textW, textH = surface.GetTextSize(timerText)
        local paddingX, paddingY = 20, 10
        local timerBoxW = textW + (paddingX * 2)
        local timerBoxH = textH + (paddingY * 2)
        local boxX = (ScrW() / 2) - (timerBoxW / 2)
        local boxY = 15

        draw.RoundedBox(6, boxX - 1, boxY - 1, timerBoxW + 2, timerBoxH + 2, Color(60, 60, 60, 200))
        draw.RoundedBox(6, boxX, boxY, timerBoxW, timerBoxH, Color(10, 10, 10, 240))
        draw.SimpleText(timerText, "DermaLarge", ScrW() / 2, boxY + paddingY, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        -- 2. Side Role Instruction & Lore Box (Positioned safely on the Top-Left)
        if roleData.hideTime > CurTime() and roleData.title ~= "" then
            local instBoxX = 20
            local instBoxY = 110

            -- Calculate Dynamic Width based on Title Size first
            surface.SetFont("DermaLarge")
            local fullTitleStr = "ROLE: " .. string.upper(roleData.title)
            local titleTextW, _ = surface.GetTextSize(fullTitleStr)

            -- Set a minimum comfortable width (e.g., 460) or stretch wider if the title/text demands it
            local dynamicBoxW = math.max(460, titleTextW + 36)

            -- Function to wrap text based on the calculated dynamic width
            local function WrapText(text, maxW)
                surface.SetFont("Trebuchet24")
                local words = string.Explode(" ", text)
                local lines = {}
                local currentLine = ""

                for _, word in ipairs(words) do
                    local testLine = currentLine == "" and word or (currentLine .. " " .. word)
                    local w, _ = surface.GetTextSize(testLine)
                    if w > maxW - 36 then
                        table.insert(lines, currentLine)
                        currentLine = word
                    else
                        currentLine = testLine
                    end
                end
                if currentLine ~= "" then table.insert(lines, currentLine) end
                return lines
            end

            local objLines = WrapText(roleData.objective, dynamicBoxW)
            local loreLines = (roleData.lore ~= "") and WrapText(roleData.lore, dynamicBoxW) or {}

            local titleH = 32
            local objH = #objLines * 26
            local loreH = (#loreLines > 0) and (#loreLines * 24 + 30) or 0
            local instBoxH = titleH + objH + loreH + 35

            -- Draw Side Card Background
            draw.RoundedBox(6, instBoxX - 1, instBoxY - 1, dynamicBoxW + 2, instBoxH + 2, Color(roleData.color.r, roleData.color.g, roleData.color.b, 160))
            draw.RoundedBox(6, instBoxX, instBoxY, dynamicBoxW, instBoxH, Color(12, 12, 12, 240))

            -- Role Title (Using DermaLarge)
            draw.SimpleText(fullTitleStr, "DermaLarge", instBoxX + 18, instBoxY + 12, roleData.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            -- Objectives (Using Trebuchet24 for big text)
            local lineY = instBoxY + 48
            for _, line in ipairs(objLines) do
                draw.SimpleText(line, "Trebuchet24", instBoxX + 18, lineY, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                lineY = lineY + 26
            end

            -- Faction Lore
            if #loreLines > 0 then
                lineY = lineY + 10
                draw.SimpleText("— FACTION LORE —", "DermaDefaultBold", instBoxX + 18, lineY, Color(180, 180, 180, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                lineY = lineY + 20

                for _, line in ipairs(loreLines) do
                    draw.SimpleText(line, "Trebuchet24", instBoxX + 18, lineY, Color(190, 190, 190, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    lineY = lineY + 24
                end
            end
        end
		
		if tipData.hideTime > CurTime() and tipData.title ~= "" then
			 local instBoxX = 20
            local instBoxY = 160

            -- Calculate Dynamic Width based on Title Size first
            surface.SetFont("DermaLarge")
            local fullTitleStr = string.upper(tipData.title)
            local titleTextW, _ = surface.GetTextSize(fullTitleStr)

            -- Set a minimum comfortable width (e.g., 460) or stretch wider if the title/text demands it
            local dynamicBoxW = math.max(460, titleTextW + 36)

            -- Function to wrap text based on the calculated dynamic width
            local function WrapText(text, maxW)
                surface.SetFont("Trebuchet24")
                local words = string.Explode(" ", text)
                local lines = {}
                local currentLine = ""

                for _, word in ipairs(words) do
                    local testLine = currentLine == "" and word or (currentLine .. " " .. word)
                    local w, _ = surface.GetTextSize(testLine)
                    if w > maxW - 36 then
                        table.insert(lines, currentLine)
                        currentLine = word
                    else
                        currentLine = testLine
                    end
                end
                if currentLine ~= "" then table.insert(lines, currentLine) end
                return lines
            end

            local loreLines = (tipData.body ~= "") and WrapText(tipData.body, dynamicBoxW) or {}

            local titleH = 32
            local objH = #objLines * 26
            local loreH = (#loreLines > 0) and (#loreLines * 24 + 30) or 0
            local instBoxH = titleH + objH + loreH + 35

            -- Draw Side Card Background
            draw.RoundedBox(6, instBoxX - 1, instBoxY - 1, dynamicBoxW + 2, instBoxH + 2, Color(tipData.color.r, tipData.color.g, tipData.color.b, 160))
            draw.RoundedBox(6, instBoxX, instBoxY, dynamicBoxW, instBoxH, Color(12, 12, 12, 240))

            -- Role Title (Using DermaLarge)
            draw.SimpleText(fullTitleStr, "DermaLarge", instBoxX + 18, instBoxY + 12, tipData.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            -- Objectives (Using Trebuchet24 for big text)
            local lineY = instBoxY + 48
            for _, line in ipairs(objLines) do
                draw.SimpleText(line, "Trebuchet24", instBoxX + 18, lineY, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                lineY = lineY + 26
            end

            -- Faction Lore
            if #loreLines > 0 then
                lineY = lineY + 10
                draw.SimpleText("— TIPS —", "DermaDefaultBold", instBoxX + 18, lineY, Color(180, 180, 180, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                lineY = lineY + 20

                for _, line in ipairs(loreLines) do
                    draw.SimpleText(line, "Trebuchet24", instBoxX + 18, lineY, Color(190, 190, 190, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    lineY = lineY + 24
                end
            end
		end
    end
    hook.Add("HUDPaint", "GamemodeDrawTimerHUD", DrawRoundHUD)
end
-- ====================================================================
-- CONSOLE COMMANDS
-- ====================================================================

concommand.Add("gz_clean_corpses", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    CleanAllCorpses() 
    NotifyAll("All corpses and fake entities were cleaned up.")
end)

concommand.Add("gz_start_gamemode", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local mode = args[1]
    local timeLimit = tonumber(args[2]) or 300
    if mode then StartGamemode(mode, timeLimit) end
end)

concommand.Add("gz_start_infection", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("infection", 300)
end)

concommand.Add("gz_start_war", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("war", 300)
end)

concommand.Add("gz_start_containment", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("containment", 300)
end)

concommand.Add("gz_start_traitor", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("traitor", 300)
end)

concommand.Add("gz_start_mystery", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("mystery", 300)
end)

concommand.Add("gz_start_breach", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("breach", 300)
end)

concommand.Add("gz_start_zone-clearence", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("zone-clearence", 300)
end)

concommand.Add("gz_start_vip", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    StartGamemode("vip", 300)
end)

concommand.Add("gz_start_defense", function(ply)
	if IsValid(ply) and not ply:IsAdmin() then return end
	StartGamemode("defense", 300)
end)

concommand.Add("gz_start_no-mercy", function(ply)
	if IsValid(ply) and not ply:IsAdmin() then return end
	StartGamemode("no-mercy", 300)
end)

concommand.Add("gz_end_gamemode", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    EndRound("The current gamemode was manually ended by an admin.")
end)

concommand.Add("gz_test_role_change", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end

    local newRoleClass = "goober"
    local targetPly = ply

    -- Determine arguments based on input format
    if args[1] then
        -- Check if arg1 is a valid player search query or if arg2 was supplied
        if args[2] then
            -- Format: gz_test_role_change <role> <username>
            newRoleClass = args[1]
            local targetName = string.lower(args[2])
            
            for _, p in ipairs(player.GetAll()) do
                if string.find(string.lower(p:Nick()), targetName, 1, true) then
                    targetPly = p
                    break
                end
            end
        else
            -- Format: gz_test_role_change <role_or_username>
            -- First check if arg1 matches a player name; if so, default role to goober for them
            local foundPlayer = nil
            local searchName = string.lower(args[1])
            
            for _, p in ipairs(player.GetAll()) do
                if string.find(string.lower(p:Nick()), searchName, 1, true) then
                    foundPlayer = p
                    break
                end
            end

            if IsValid(foundPlayer) then
                targetPly = foundPlayer
                newRoleClass = "goober"
            else
                -- If no player matched, treat arg1 as the role for yourself
                newRoleClass = args[1]
                targetPly = ply
            end
        end
    end

    if not IsValid(targetPly) then
        if IsValid(ply) then
            NotifyPlr(ply, "Target player not found!")
        else
            print("[Gamemode] Target player not found!")
        end
        return
    end

    ChangePlayerRoleMidRound(targetPly, newRoleClass,  CLASS_TO_ROLE_KEY[newRoleClass])
    
    if IsValid(ply) and ply ~= targetPly then
        NotifyPlr(ply, "Changed " .. targetPly:Nick() .. "'s role to " .. newRoleClass)
    end
end)

local oldPools = {
	item = PUBLIC_ITEM_POOL,
	vehicles = {
		ground = PUBLIC_GROUND_VEHICLES,
		water = PUBLIC_WATER_VEHICLES,
		air = PUBLIC_AIR_VEHICLES
	}
}
concommand.Add("gz_refresh_item_pool", function(ply) 
	if IsValid(ply) and not ply:IsAdmin() then return end
	
	PUBLIC_ITEM_POOL = oldPools.item
end)

concommand.Add("gz_refresh_vehicle_pool", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	
	local vType = args[1]
	if vType == "ground" then
		PUBLIC_GROUND_VEHICLES = oldPools.vehicles.ground
	elseif vType == "water" then
		PUBLIC_WATER_VEHICLES = oldPools.vehicles.water
	elseif vType == "air" then
		PUBLIC_AIR_VEHICLES = oldPools.vehicles.air
	end
end)

concommand.Add("gz_add_entry_item_pool", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	local class = args[1]
	
	table.insert(PUBLIC_ITEM_POOL, class)
end)

concommand.Add("gz_add_entry_vehicle_pool", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	local vType = args[1]
	local class = args[2]
	
	if vType == "ground" then
		table.insert(PUBLIC_GROUND_VEHICLES, class)
	elseif vType == "water" then
		table.insert(PUBLIC_WATER_VEHICLES, class)
	elseif vType == "air" then
		table.insert(PUBLIC_AIR_VEHICLES, class)
	end
end)

concommand.Add("gz_test_populate_items", function()
	if IsValid(ply) and not ply:IsAdmin() then return end
	 
	PopulateAllItemSpawns()
end)

concommand.Add("gz_test_populate_vehicles", function()
	if IsValid(ply) and not ply:IsAdmin() then return end
	
	PopulateAllVehicles()
end)

concommand.Add("gz_force_lms", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end

    if not GM_STATE.InProgress then
        if IsValid(ply) then
            NotifyPlr(ply, "No gamemode is currently active!")
        else
            print("[Gamemode] No gamemode is currently active!")
        end
        return
    end

    local validModes = {
        infection = true,
        containment = true,
        traitor = true,
        mystery = true,
        test = true
    }

    if not validModes[GM_STATE.CurrentMode] then
        local msg = "Current mode (" .. tostring(GM_STATE.CurrentMode) .. ") does not support Last Man Standing!"
        if IsValid(ply) then
            NotifyPlr(ply, msg)
        else
            print("[Gamemode] " .. msg)
        end
        return
    end

    local activePlayers = GetActivePlayers()
    if #activePlayers < 2 then
        local msg = "At least 2 active players are required to force Last Man Standing!"
        if IsValid(ply) then
            NotifyPlr(ply, msg)
        else
            print("[Gamemode] " .. msg)
        end
        return
    end

    local targetPly = IsValid(ply) and ply or activePlayers[1]

    for _, p in ipairs(activePlayers) do
        if p ~= targetPly then
            AssimilatePlayer(p)
        end
    end

    TriggerLMS(targetPly, "FORCED LAST MAN STANDING! " .. targetPly:Nick() .. " is the last survivor!")
end)

-- Sound search and setup command
concommand.Add("gz_help_sound_list", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end

    local query = args[1] and string.lower(args[1]) or ""
    local matchedFiles = {}

    -- Recursive function to find audio files inside the garrysmod/sound folder
    local function SearchFiles(dir)
        local searchPath = (dir == "") and "sound/*" or ("sound/" .. dir .. "/*")
        local files, folders = file.Find(searchPath, "GAME")

        if files then
            for _, f in ipairs(files) do
                local ext = string.GetExtensionFromFilename(f)
                if ext == "wav" or ext == "mp3" or ext == "ogg" then
                    local fullPath = (dir == "") and f or (dir .. "/" .. f)
                    if query == "" or string.find(string.lower(fullPath), query, 1, true) then
                        table.insert(matchedFiles, fullPath)
                    end
                end
            end
        end

        if folders then
            for _, folder in ipairs(folders) do
                SearchFiles((dir == "") and folder or (dir .. "/" .. folder))
            end
        end
    end

    print("\n=======================================================")
    print("      GOOBERZ SOUND DIRECTORY SEARCH & SETUP HELP      ")
    print("=======================================================")

    SearchFiles("")

    if #matchedFiles == 0 then
        print(" No sound files found matching: '" .. query .. "'")
    else
        print(" Found " .. #matchedFiles .. " sound file(s) matching: '" .. query .. "':\n")

        local limit = math.min(#matchedFiles, 20)
        for i = 1, limit do
            print(" [" .. i .. "] " .. matchedFiles[i])
        end

        if #matchedFiles > limit then
            print("\n ... and " .. (#matchedFiles - limit) .. " more files. Refine your search query to narrow results.")
        end

        local sample = matchedFiles[1]
        print("\n-------------------------------------------------------")
        print(" COPY-AND-PASTE CONSOLE COMMANDS:")
        print("-------------------------------------------------------")
        print(" gz_set_round_theme \"" .. sample .. "\"")
        print(" gz_set_lms_music \"" .. sample .. "\"")
        print(" gz_set_lms_music_infection \"" .. sample .. "\"")
        print(" gz_set_lms_music_containment \"" .. sample .. "\"")
        print(" gz_set_lms_music_traitor \"" .. sample .. "\"")
        print(" gz_set_lms_music_mystery \"" .. sample .. "\"")
    end

    print("=======================================================\n")
end)

-- ====================================================================
-- MUSIC CONFIGURATION CONSOLE COMMANDS
-- ====================================================================

-- Set the global main round theme song
concommand.Add("gz_set_round_theme", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.RoundThemePath = path
    NotifyAll("Round Theme updated to: " .. path)
end)

-- set the global victory theme song
concommand.Add("gz_set_victory_charm", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.VictoryThemePath = path
	NotifyAll("Victory Theme updated to: " .. path)
end)

-- Set default/fallback LMS music
concommand.Add("gz_set_lms_music", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.LMSMusicPath = path
    NotifyAll("Default LMS Music updated to: " .. path)
end)

-- Set Infection LMS music
concommand.Add("gz_set_lms_music_infection", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.LMSMusicPath_Infection = path
    NotifyAll("Infection LMS Music updated to: " .. path)
end)

-- Set Containment LMS music
concommand.Add("gz_set_lms_music_containment", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.LMSMusicPath_Containment = path
    NotifyAll("Containment LMS Music updated to: " .. path)
end)

-- Set Traitor LMS music
concommand.Add("gz_set_lms_music_traitor", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.LMSMusicPath_Traitor = path
    NotifyAll("Traitor LMS Music updated to: " .. path)
end)

-- Set Mystery LMS music
concommand.Add("gz_set_lms_music_mystery", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local path = args[1] or "empty"
    GM_STATE.LMSMusicPath_Mystery = path
    NotifyAll("Mystery LMS Music updated to: " .. path)
end)

concommand.Add("gz_test_play_gm_music", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	local mType = args[1] or "round"
	
	StopGlobalSounds()
	if mType == "round" then
		PlayGlobalSound(GM_STATE.RoundThemePath)
	elseif mType == "lms" then
		PlayGlobalSound(GM_STATE.LMSMusicPath)
	elseif mType == "victory" then
		PlayGlobalSound(GM_STATE.VictoryThemePath)
	elseif mType == "lms_infection" then
		PlayGlobalSound(GM_STATE.LMSMusicPath_Infection)
	elseif mType == "lms_containment" then
		PlayGlobalSound(GM_STATE.LMSMusicPath_Containment)
	end
end)

-- Test command for waves
concommand.Add("gz_test_spawn_wave", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	SpawnGooberWave(5)
end)

-- Set ZoneClearenceDiffculty to Int
concommand.Add("gz_set_zc_diff", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	-- Ensure an argument was provided
	if not args[1] then
		if IsValid(ply) then
			ply:ChatPrint("Usage: gz_set_zc_diff <difficulty_integer>")
		else
			print("Usage: gz_set_zc_diff <difficulty_integer>")
		end
		return
	end

	-- Convert the argument to a number (integer)
	local diffValue = tonumber(args[1])
	if not diffValue then
		local errMsg = "Invalid argument! Please provide a valid integer."
		if IsValid(ply) then ply:ChatPrint(errMsg) else print(errMsg) end
		return
	end

	-- Assign the integer value to the state
	GM_STATE.ZoneClearenceDiffculty = math.floor(diffValue)

	-- Feedback message
	local successMsg = "Zone Clearance Difficulty set to: " .. GM_STATE.ZoneClearenceDiffculty
	if IsValid(ply) then
		ply:ChatPrint(successMsg)
	else
		print(successMsg)
	end
end)

concommand.Add("gz_print_sequences", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then
        ply:ChatPrint("You must be an admin to use this command.")
        return
    end

    local modelPath = args[1]
    if not modelPath or modelPath == "" then
        local msg = "Usage: gz_print_sequences <model_path>\nExample: gz_print_sequences models/player/leymirba/protogenpm.mdl"
        if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
        return
    end

    -- Temporary entity to read model data
    local tempEnt = ents.Create("prop_dynamic")
    if not IsValid(tempEnt) then return end

    tempEnt:SetModel(modelPath)
    tempEnt:Spawn()
    tempEnt:SetNoDraw(true)

    local count = tempEnt:GetSequenceCount()

    if count and count > 0 then
        print("=======================================================")
        print(" SEQUENCES FOR: " .. modelPath)
        print(" Total sequences: " .. count)
        print("=======================================================")

        if IsValid(ply) then
            ply:ChatPrint("Printing " .. count .. " sequences to console.")
        end

        for i = 0, count - 1 do
			local name = tempEnt:GetSequenceName(i) or "unknown"
			local id = tempEnt:LookupSequence(name)

			print(string.format("[%d] %s  → LookupSequence = %d", i, name, id))
		end

        print("=======================================================")
        print(" Use these numbers in ResetSequence() / SetSequence()")
        print("=======================================================")
    else
        local errorMsg = "No sequences found or invalid model path!"
        if IsValid(ply) then ply:ChatPrint(errorMsg) else print(errorMsg) end
    end

    tempEnt:Remove()
end)
--[[
local spawnType = "default"
				
				if queueData.newRole == "humanityForces" or queueData.newRole == "traitor" then
					spawnType = "hf/t"
				elseif queueData.newRole == "goober" then
					spawnType = "infected"
				end
				
                SpawnAtZone(ply, spawnType)
                ply:StripWeapons()
                ply:StripAmmo()
                ply.armors = {}
                ply.armors_health = {}
                
]]--
concommand.Add("gz_full_role_change", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then
        ply:ChatPrint("You must be an admin to use this command.")
        return
    end
	
	local newRoleClass = "goober"
    local targetPly = ply

    -- Determine arguments based on input format
    if args[1] then
        -- Check if arg1 is a valid player search query or if arg2 was supplied
        if args[2] then
            -- Format: gz_test_role_change <role> <username>
            newRoleClass = args[1]
            local targetName = string.lower(args[2])
            
            for _, p in ipairs(player.GetAll()) do
                if string.find(string.lower(p:Nick()), targetName, 1, true) then
                    targetPly = p
                    break
                end
            end
        else
            -- Format: gz_test_role_change <role_or_username>
            -- First check if arg1 matches a player name; if so, default role to goober for them
            local foundPlayer = nil
            local searchName = string.lower(args[1])
            
            for _, p in ipairs(player.GetAll()) do
                if string.find(string.lower(p:Nick()), searchName, 1, true) then
                    foundPlayer = p
                    break
                end
            end

            if IsValid(foundPlayer) then
                targetPly = foundPlayer
                newRoleClass = "goober"
            else
                -- If no player matched, treat arg1 as the role for yourself
                newRoleClass = args[1]
                targetPly = ply
            end
        end
    end

    if not IsValid(targetPly) then
        if IsValid(ply) then
            NotifyPlr(ply, "Target player not found!")
        else
            print("[Gamemode] Target player not found!")
        end
        return
    end
	
	
	
	
	local spawnType = "default"
	if newRoleClass == "humanityForces" or newRoleClass == "traitor" then
		spawnType = "hf/t"
	elseif newRoleClass == "goober" then
		spawnType = "infected"
	end
	
		
	SpawnAtZone(targetPly, spawnType)
	targetPly:StripWeapons()
    targetPly:StripAmmo()
    targetPly.armors = {}
    targetPly.armors_health = {}


	if GM_STATE.InProgress then
		ChangePlayerRoleMidRound(targetPly, newRoleClass,  CLASS_TO_ROLE_KEY[newRoleClass])
	else
		ApplyPlayerClass(targetPly, newRoleClass, CLASS_TO_ROLE_KEY[newRoleClass])
	end
end)

concommand.Add("gz_set_admin", function(ply, cmd, args)
        -- Allow execution only from Server Console or SuperAdmins
        if IsValid(ply) and not ply:IsSuperAdmin() then
            ply:ChatPrint("[GooberZ] Only SuperAdmins or the Server Console can use this command.")
            return
        end

        local targetName = args[1]
        local group = string.lower(args[2] or "admin") -- Default to "admin" if omitted

        if not targetName then
            local msg = "[GooberZ] Usage: gz_setadmin <player_name_or_steamid> [admin/superadmin/user]"
            if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
            return
        end

        -- Find the target player by Name or SteamID
        local target = nil
        for _, p in ipairs(player.GetAll()) do
            if string.find(string.lower(p:Nick()), string.lower(targetName), 1, true) or p:SteamID() == targetName then
                target = p
                break
            end
        end

        if not IsValid(target) then
            local msg = "[GooberZ] Could not find player matching: " .. targetName
            if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
            return
        end

        -- 1. Apply Vanilla GMod Usergroup
        target:SetUserGroup(group)

        -- 2. Hook into popular admin addons if installed on your Homigrad server
        if sam and sam.player and sam.player.set_rank then
            -- SAM Admin System
            sam.player.set_rank(target, group)
        elseif ULib and ULib.ucl then
            -- ULX / ULib System
            ULib.ucl.addUser(target:SteamID(), {}, {}, group)
        elseif xAdmin then
            -- xAdmin System
            xAdmin.SetGroup(target:SteamID(), group)
        end

        local response = string.format("[GooberZ] Set %s (%s) rank to '%s'", target:Nick(), target:SteamID(), group)
        print(response)
        if IsValid(ply) then ply:ChatPrint(response) end
        target:ChatPrint("[GooberZ] Your admin status has been updated to: " .. group)
    end)

-- hook for new spawn points if there is any looll
hook.Add("InitPostEntity", "FindGooberSpawnPoints", function()
    GOOBER_SPAWNPOINTS = ents.FindByClass("gooberSpawnPoint")
    print("[GooberZ] Found", #GOOBER_SPAWNPOINTS, "Goober spawn points on map.")
end)
