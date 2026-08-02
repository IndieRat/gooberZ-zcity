hook.Add("InitPostEntity", "GooberZ_Notice_Chat", function()
    if CLIENT then
		-- Small delay to make sure chat HUD is fully loaded
		timer.Simple(12, function()
			chat.AddText(
				Color(0, 180, 255), "[GooberZ] ",
				Color(255, 255, 255), "Dante: Thank you for my friends for the support, the mod is getting updated and patched so quickly ",
				Color(0, 255, 100), "'GooberZ'",
				Color(255, 255, 255), " category in weapons and entities for speicals, the Ammo is now in",
				Color(255, 100, 0), " 'ZCity - Ammo!'"
			)
		end)
	end
end)