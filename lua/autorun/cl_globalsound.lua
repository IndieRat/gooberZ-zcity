if SERVER then return end

net.Receive("PlayGlobalSound", function()
    local soundPath = net.ReadString()
    if soundPath and soundPath ~= "" then
        surface.PlaySound(soundPath)
    end
end)