--[[
    Custom Anti-Infected Armor System for ZCity
]]

local function RegisterAntiInfectedArmor()
    if not hg or not hg.armor then return end

    -------------------------------------------------------------------
    -- 1. TORSO ARMOR: Anti-Infected Ballistic Vest
    -------------------------------------------------------------------
    hg.armor.torso["anti_infected_vest"] = {
        "torso",
        "models/combataegis/body/ballisticvest_d.mdl",
        Vector(19, 3, 0),
        Angle(0, 90, 90),
        protection = 16, -- Class III+ protection
        bone = "ValveBiped.Bip01_Spine2",
        model = "models/combataegis/body/ballisticvest.mdl",
        femPos = Vector(-4, 0, 1),
        femscale = 0.92,
        effect = "Impact",
        surfaceprop = 67,
        mass = 9,
        ScrappersSlot = "Armor",
        nobonemerge = true,
        
        -- Custom Anti-Infected Attributes
        isAntiInfected = true,
        assimilationReduction = 0.50 -- 50% resistance to assimilation/infection speed
    }

    -------------------------------------------------------------------
    -- 2. HEAD ARMOR: Anti-Infected Tactical Helmet
    -------------------------------------------------------------------
    hg.armor.head["anti_infected_helmet"] = {
        "head",
        "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
        Vector(2.2, -1, 0),
        Angle(180, 100, 90),
        protection = 8,
        bone = "ValveBiped.Bip01_Head1",
        model = "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
        femPos = Vector(-1, 0, 0.1),
        norender = true,
        effect = "Impact",
        surfaceprop = 67,
        scale = 0.9,
        mass = 1.5,
        ScrappersSlot = "Armor",
        
        -- Custom Anti-Infected Attributes
        isAntiInfected = true,
        assimilationReduction = 0.25 -- 25% resistance to assimilation/infection speed
    }

    -------------------------------------------------------------------
    -- 3. FACE ARMOR: Anti-Infected Gas Mask
    -------------------------------------------------------------------
    hg.armor.face["anti_infected_mask"] = {
        "face",
        "models/gasmasksfix/m40_drop.mdl",
        Vector(3, -2, -0.5),
        Angle(-90, 90, 0),
        protection = 2,
        bone = "ValveBiped.Bip01_Head1",
        model = "models/gasmasksfix/m40_fix.mdl",
        femPos = Vector(-1, 0, 0),
        norender = true,
        scale = 1,
        femscale = 1,
        viewmaterial = Material("overlays/ba_gasmask"),
        effect = "Impact",
        surfaceprop = 67,
        loopsound = "breath_normal",
        mass = 0.5,
        ScrappersSlot = "Armor",
        voice_change = true,

        -- Custom Anti-Infected Attributes
        isAntiInfected = true,
        assimilationReduction = 0.25 -- 25% resistance to assimilation/infection speed
    }

    -------------------------------------------------------------------
    -- 4. DISPLAY NAMES AND ICONS
    -------------------------------------------------------------------
    hg.armorNames["anti_infected_vest"] = "Humanity Forces Anti-Infected Vest"
    hg.armorNames["anti_infected_helmet"] = "Humanity Forces Anti-Infected Helmet"
    hg.armorNames["anti_infected_mask"] = "Humanity Forces Anti-Infected Gas Mask"

    hg.armorIcons["anti_infected_vest"] = "scrappers/armor1.png"
    hg.armorIcons["anti_infected_helmet"] = "vgui/icons/helmet.png"
    hg.armorIcons["anti_infected_mask"] = "vgui/icons/gasmask"

    -- Register language phrases for client
    if CLIENT then
        language.Add("anti_infected_vest", hg.armorNames["anti_infected_vest"])
        language.Add("anti_infected_helmet", hg.armorNames["anti_infected_helmet"])
        language.Add("anti_infected_mask", hg.armorNames["anti_infected_mask"])
    end

    -------------------------------------------------------------------
    -- 5. REGISTER SCRIPTED ENTITIES FOR SPAWNING
    -------------------------------------------------------------------
    local vestEnt = {
        Base = "armor_base",
        PrintName = "Humanity Forces Anti-Infected Vest",
        name = "anti_infected_vest",
        Category = "GooberZ",
        Spawnable = true,
        Model = "models/combataegis/body/ballisticvest_d.mdl",
        WorldModel = "models/combataegis/body/ballisticvest_d.mdl",
        armor = hg.armor.torso["anti_infected_vest"],
        placement = "torso",
        IconOverride = hg.armorIcons["anti_infected_vest"]
    }
    scripted_ents.Register(vestEnt, "ent_armor_anti_infected_vest")

    local helmetEnt = {
        Base = "armor_base",
        PrintName = "Humanity Forces Anti-Infected Helmet",
        name = "anti_infected_helmet",
        Category = "GooberZ",
        Spawnable = true,
        Model = "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
        WorldModel = "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
        armor = hg.armor.head["anti_infected_helmet"],
        placement = "head",
        IconOverride = hg.armorIcons["anti_infected_helmet"]
    }
    scripted_ents.Register(helmetEnt, "ent_armor_anti_infected_helmet")

    local maskEnt = {
        Base = "armor_base",
        PrintName = "Humanity Forces Anti-Infected Gas Mask",
        name = "anti_infected_mask",
        Category = "GooberZ",
        Spawnable = true,
        Model = "models/gasmasksfix/m40_drop.mdl",
        WorldModel = "models/gasmasksfix/m40_drop.mdl",
        armor = hg.armor.face["anti_infected_mask"],
        placement = "face",
        IconOverride = hg.armorIcons["anti_infected_mask"]
    }
    scripted_ents.Register(maskEnt, "ent_armor_anti_infected_mask")
end

hook.Add("Initialize", "init_anti_infected_armor", RegisterAntiInfectedArmor)
if hg and hg.armor then RegisterAntiInfectedArmor() end