SWEP.Base = "weapon_glock17"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Glock 18C (Electric)"
SWEP.Author = "Glock GmbH / Humanity Forces Custom Division"
SWEP.Instructions = "Modified 18C full-auto pistol re-engineered for 9x19 mm Energy rounds.\n\n[LORE] [LORE] This gun was engineered to accept and handle the power of the Energy Round and round takes builds up electrical shock on a target before it bursts into a ragdoll."
SWEP.Category = "GooberZ"
SWEP.Slot = 2
SWEP.SlotPos = 10

-------------------------------------------------------------------
-- AMMO CONFIGURATION
-------------------------------------------------------------------
SWEP.Primary.Ammo = "9x19 mm Energy"
-------------------------------------------------------------------

SWEP.FakeBodyGroups = "00030"
SWEP.FakeBodyGroupsPresets = {
	"00030",
	"10030",
	"00030",
	"10030",
	"00030",
	"10030",
	"00030",
	"10030",
	"00030",
	"10030",
	"00030",
	"10030",
}

function SWEP:InitializePost()
	local Skin = math.random(0,2)
	if math.random(0,100) > 99 then
		Skin = 3
	end
	self:SetGlockSkin(Skin)
	self:SetRandomBodygroups(self.FakeBodyGroupsPresets[math.random(#self.FakeBodyGroupsPresets)] or "00030")
end

SWEP.WepSelectIcon2 = Material("vgui/hud/tfa_ins2_glock_p80.png")
SWEP.IconOverride = "entities/weapon_pwb_glock17.png"

SWEP.Primary.Automatic = true
SWEP.Primary.Wait = 0.05
SWEP.AnimShootHandMul = 0.01

SWEP.punchmul = 0.5
SWEP.punchspeed = 3

SWEP.podkid = 0.5