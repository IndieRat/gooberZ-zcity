if CLIENT then return end

-- Register the network string
util.AddNetworkString("PlayGlobalSound")

-- Global function you can call anywhere on the server
function PlayGlobalSound(soundPath)
    net.Start("PlayGlobalSound")
    net.WriteString(soundPath)
    net.Broadcast()
end

concommand.Add("gz_play_global", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then return end

    local soundPath = args[1]
    if not soundPath then return end

    PlayGlobalSound(soundPath)
end)

