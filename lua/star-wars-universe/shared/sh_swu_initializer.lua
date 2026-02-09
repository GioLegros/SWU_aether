SWU = SWU or {}
SWU.Terminals = SWU.Terminals or {}

SWU.Version = 2.2
SWU.Changelog = {
    title = "Version 2.2",
    changes = {
        { type = "+", text = "Direct Keyboard Input for Controllers" },
        { type = "+", text = "Keypad Input for Rotation Controller" },
        { type = "+", text = "Arrow Input for Speed Controller" },
        { type = "+", text = "Arrow Input for Navigation Computer" },
        { type = "#", text = "New Console Instructions on Workshop page" },
        { type = "#", text = "Minor UX adjustments" },
    }
}
SWU.Hyperspace = { OUT = 0, TRANSITIONING = 1, IN = 2 }

SWU.GlobalConfig = {
    chunkSize = 25,
    chunkRange = 1,
    maxAcceleration = Vector(0.03,0.03,0.03),
    baseHyperspaceAcceleration = Vector(2,2,2),
    hyperspaceAcceleration = Vector(2,2,2)
}

-- CONFIGURATION PAR DÉFAUT (Pour les maps supportées de base) --
local ISD_TeleporterConfiguration = {
    { min = Vector(15744, 15744, 9792), max = Vector(15744 - 500, -15692, -15616), tDir = 0 },
    { min = Vector(-15744, 15744, 9792), max = Vector(-15744 + 500, -15692, -15616), tDir = 180 },
    { min = Vector(15744, -15692, 9792), max = Vector(-15744, -15692 + 500, -15616), tDir = 90 },
    { min = Vector(15744, 15692, 9792), max = Vector(-15744, 15692 - 500, -15616), tDir = 270 }
}

local ISD_Desert = { pos = Vector(-5344, 5880, 14124), angle = Angle() }
local ISD_Snow = { pos = Vector(-5031, 12830, 14124), angle = Angle() }
local ISD_SpaceStation = { pos = Vector(-14800, 3295, 13960), angle = Angle() }
local ISD_DeathStar = { pos = Vector(-15003, 10611, 14156), angle = Angle() }

local ISD_TeleportLocationConfiguration = {
    ["the-coding-ducks/swu/planets/city/"] = ISD_Desert,
    ["the-coding-ducks/swu/planets/clouds/"] = ISD_Snow,
    ["the-coding-ducks/swu/planets/desert/"] = ISD_Desert,
    ["the-coding-ducks/swu/planets/forest/"] = ISD_Desert,
    ["the-coding-ducks/swu/planets/fungal/"] = ISD_Snow,
    ["the-coding-ducks/swu/planets/gas/"] = ISD_Snow,
    ["the-coding-ducks/swu/planets/ice/"] = ISD_Snow,
    ["the-coding-ducks/swu/planets/magma/"] = ISD_Desert,
    ["the-coding-ducks/swu/planets/moon/"] = ISD_Desert,
    ["the-coding-ducks/swu/planets/water/"] = ISD_Snow,
    ["deathstar"] = ISD_DeathStar,
    ["spacestation"] = ISD_SpaceStation,
}

local LordTrilobites_ISD = {
    skyboxReference = Vector(1833, -6591, 13789),
    controllerPos = Vector(1833, -6591, 13789),
    disableFog = true,
    disableSun = true,
    scale = 500,
    collisionRange = 115,
    hyperspace = {
        tunnel = "models/kingpommes/venator/hypertunnel.mdl",
        stars = "models/kingpommes/venator/lightspeed_stars.mdl"
    },
    skyboxBoundaries = { min = Vector(), max = Vector(), center = Vector() },
    controls = {
        { ent = "swu_navigation_computer", pos = Vector(-8612, -391, 720), ang = Angle(0, -90, 0) },
        { ent = "swu_rotation_controller", pos = Vector(-8106, 187, 640), ang = Angle(0, -180, 0) },
        { ent = "swu_speed_controller", pos = Vector(-8106, -187, 640), ang = Angle(0, 90, 0) },
        { ent = "swu_map", pos = Vector(-9057.2, -374, 808), ang = Angle(90, 0, 0), scale = 0.8 }
    },
    teleports = ISD_TeleporterConfiguration,
    teleportLocations = ISD_TeleportLocationConfiguration,
    blockPos = { Vector(-8751, -386, 737), Vector(-8739, -356, 782) }
}

-- TODO : make a tuto for add a map 

local GioLegros_Venator = {
    skyboxReference = Vector(0, 0, 14593),
    controllerPos = Vector(0, 0, 14593),
    disableFog = true,
    disableSun = true,
    scale = 500,
    collisionRange = 115,
    shipOffsetRotation = Angle(0, -90, 0),
    hyperspace = {
        tunnel = "models/kingpommes/starwars/venator/hypertunnel.mdl",
        stars = "models/kingpommes/starwars/venator/lightspeed_stars.mdl"
    },
    skyboxBoundaries = { min = Vector(), max = Vector(), center = Vector() },
    controls = {
        { ent = "swu_navigation_computer", --final pos and rotation
        pos = Vector(923, 4638, 3229), 
        ang = Angle(0, 180, 0) },

        { ent = "swu_rotation_controller", --final pos and rotation
        pos = Vector(860, 3682, 3156), 
        ang = Angle(0, 180, 0) },

        { ent = "swu_speed_controller", --final pos and rotation
        pos = Vector(457, 3682, 3156), 
        ang = Angle(0, 0, 0) }, 

        { ent = "swu_map", 
        pos = Vector(787, 4621, 3300), --final pos and rotation
        ang = Angle(90, 180, 0), scale = 1 }
    },

    teleports = {}, 
    teleportLocations = {},
    blockPos = {Vector(-658, 4619, 3267)} --map de con desac
}

SWU.MapConfig = {
    ["rp_venator_extensive_v1_4"] = {
        skyboxReference = Vector(0, 0, 15500),
        controllerPos = Vector(-48, -0, 15500),
        disableFog = true,
        disableSun = true,
        shipOffsetRotation = Angle(0,90,0),
        scale = 500,
        collisionRange = 101,
        hyperspace = {
            tunnel = "models/kingpommes/starwars/venator/hypertunnel.mdl",
            stars = "models/kingpommes/starwars/venator/lightspeed_stars.mdl"
        },
        skyboxBoundaries = { min = Vector(), max = Vector(), center = Vector() },
        controls = {
            { ent = "swu_navigation_computer", pos = Vector(-7272, -4552, 1088), ang = Angle() },
            { ent = "swu_rotation_controller", pos = Vector(-7176, -3725, 1016), ang = Angle(0, -20, 0) },
            { ent = "swu_speed_controller", pos = Vector(-6711, -3725, 1016), ang = Angle(0, -160, 0) },
            { ent = "swu_map", pos = Vector(-7120, -4552, 1160), ang = Angle(90, 0, 0), scale = 1 }
        },
        blockPos = { Vector(-5565, -4544, 1113), Vector(-5315, -3456, 1099) }
    },
    ["rp_stardestroyer_v2_7"] = LordTrilobites_ISD,
    ["rp_stardestroyer_v2_7_inf"] = LordTrilobites_ISD,
    ["rp_venator_notorious"] = GioLegros_Venator  -- TA MAP EST ICI
}

SWU.config = SWU.config or SWU.MapConfig[game.GetMap()] or {
    skyboxBoundaries = { min = Vector(), max = Vector(), center = Vector() },
    skyboxReference = Vector(),
    controllerPos = Vector(),
    disableFog = true,
    disableSun = true,
    shipOffsetRotation = Angle(),
    scale = 1,
    collisionRange = 1,
    hyperspace = {},
    controls = {},
    blockPos = {}
}

SWU.Colors = {}
SWU.Colors.Default = {
    primary = Color(252, 206, 109),
    passive = Color(255, 255, 255),
    accent = Color(255, 153, 0),
    con = Color(124, 124, 124),
    dark = Color(26, 26, 26),
    black = Color(0, 0, 0),
    none = Color(0, 0, 0, 0),
    error = Color(255, 62, 36),
}

if (SERVER) then
    AddCSLuaFile("libs/advanceddraw.lua")
    AddCSLuaFile("libs/netdata.lua")
    include("libs/netdata.lua")
end

if (CLIENT) then
    SWU.Map = SWU.Map or {}
    SWU.Fonts = SWU.Fonts or {}

    SWU.Fonts.TechAurabeshSpeed = "SwuSpeedFont"
    SWU.Fonts.AurabeshRotation = "SwuRotationFont"
    SWU.Fonts.PlainRotation = "SwuRotationText"
    SWU.Fonts.AurabeshNavComputer = "SwuNavigationFont"
    SWU.Fonts.PlainText = "SwuBaseText"
    SWU.Fonts.PlainMapPlanet = "SwuMapPlanetText"
    SWU.Fonts.AurabeshNavComputer2 = "SwuNavFont"
    SWU.Fonts.PlainNavComputer = "SwuNavText"

    local function CreateSWUFont(name, fontName, size, weight)
        surface.CreateFont(name, {
            font = fontName,
            size = size,
            weight = weight,
            antialias = true,
            shadow = false
        })
    end

    CreateSWUFont(SWU.Fonts.TechAurabeshSpeed, "Aurebesh AF", 120, 200)
    CreateSWUFont(SWU.Fonts.AurabeshRotation, "Aurebesh", 60, 200)
    CreateSWUFont(SWU.Fonts.PlainRotation, "Saira", 84, 200)
    CreateSWUFont(SWU.Fonts.AurabeshNavComputer, "Aurebesh", 100, 200)
    CreateSWUFont(SWU.Fonts.PlainText, "Saira", 168, 200)
    CreateSWUFont(SWU.Fonts.PlainMapPlanet, "Saira", 224, 800)
    CreateSWUFont(SWU.Fonts.AurabeshNavComputer2, "Aurebesh", 170, 200)
    CreateSWUFont(SWU.Fonts.PlainNavComputer, "Saira", 238, 200)

    include("libs/netdata.lua")
end

-- HOOKS POUR OPTIONS SUPPLÉMENTAIRES --
hook.Add("SWU_LoadCustomMapConfig", "SWU_AddOptionalDeathStarToMap", function ()
    if (CLIENT or not SWU.Configuration:GetConVar("swu_enable_deathstar"):GetBool()) then return end
    local deathStarPos = Vector(646.96, -678.297, 0)
    local deathStarChunk = SWU.Util:VectorToChunk(deathStarPos)
    SWU.Universe[deathStarChunk] = SWU.Universe[deathStarChunk] or {}
    table.insert(SWU.Universe[deathStarChunk], {
        id = "6465617", name = "Death Star", pos = deathStarPos, terrain = "deathstar",
        type = "model_object", baseScale = 0.08, model = "models/lordtrilobite/starwars/props/deathstar128.mdl"
    })
end)

hook.Add("SWU_LoadCustomMapConfig", "SWU_AddISDSpaceStation", function (mapName)
    if (CLIENT or (mapName ~= "rp_stardestroyer_v2_7" and mapName ~= "rp_stardestroyer_v2_7_inf")) then return end
    local destroyedISDPos = Vector(-784.41, 674.58, 0)
    local destroyedISDChunk = SWU.Util:VectorToChunk(destroyedISDPos)
    SWU.Universe[destroyedISDChunk] = SWU.Universe[destroyedISDChunk] or {}
    table.insert(SWU.Universe[destroyedISDChunk], {
        id = "974548184557525", name = "Destroyed ISD", pos = destroyedISDPos, terrain = "destroyed_isd",
        type = "model_object", baseScale = 1, model = "models/lordtrilobite/starwars/isd/isd_wreck2_128.mdl"
    })
end)

-- FONCTIONS DE CHARGEMENT --
function SWU:LoadMap(mapName)
    if (SERVER) then self:LoadUniverse() end
    self.ActiveChunks = {}
    hook.Run("SWU_LoadCustomMapConfig", mapName, self.MapConfig)
    
    local config = self.MapConfig[mapName]
    if (not istable(config)) then return end

    local hyperspaceSpeedModifier = (SWU.Configuration:GetConVar("swu_hyperspace_speed_modifier"):GetFloat() or 1)
    local externalHyperspaceSpeedModifier = (SWU.Configuration:GetConVar("swu_external_hyperspace_speed_modifier"):GetFloat() or 1)

    SWU.GlobalConfig.hyperspaceAcceleration = SWU.GlobalConfig.baseHyperspaceAcceleration * hyperspaceSpeedModifier * externalHyperspaceSpeedModifier
    for i, v in ipairs(self.Terminals) do if (IsValid(v)) then v:Remove() end end
    self.Terminals = {}

    local min, max, center = self.Util:MeasureSkybox(config.skyboxReference)
    config.skyboxBoundaries = { min = min, max = max, center = center }
    self.config = config

    if (config.disableFog) then self.Util:DisableFog() end
    if (config.disableSun) then self.Util:DisableSun() end

    if (SERVER) then
        self:InitializeController(config)
        self:SpawnControls()
        self:BlockMapHyperspace()
        self:ReadShipData()
        self:SpawnTeleports()
        self:IndexPlanets()
    end
    if (CLIENT) then self:SetupRenderers() end
    hook.Run("SWU.MapLoaded")
end

function SWU:InitializeController(config)
    SWU.Controller = ents.Create("swu_controller")
    SWU.Controller:Load(config)
    SWU.Controller:Spawn()
end

if (SERVER) then
    util.AddNetworkString("SWU_ChangeHyperspaceAcceleration")
    hook.Add("InitPostEntity", "SWU_InitializeStarWarsUniverse", function () SWU:LoadMap(game.GetMap()) end)
    hook.Add("SWU_OnConfigurationChange", "SWU_UpdateHyperspaceAcceleration", function (conVarName, oldValue, newValue)
        if (conVarName ~= "swu_hyperspace_speed_modifier") then return end
        local oldAcceleration = SWU.GlobalConfig.hyperspaceAcceleration
        SWU.GlobalConfig.hyperspaceAcceleration = SWU.GlobalConfig.hyperspaceAcceleration / oldValue * newValue
        net.Start("SWU_ChangeHyperspaceAcceleration")
        net.WriteVector(SWU.GlobalConfig.hyperspaceAcceleration)
        net.Broadcast()
        hook.Run("SWU_RecalculateFlightTime", oldAcceleration, SWU.GlobalConfig.hyperspaceAcceleration)
    end)
else
    net.Receive("SWU_ChangeHyperspaceAcceleration", function () SWU.GlobalConfig.hyperspaceAcceleration = net.ReadVector() end)
    hook.Add("ClientSignOnStateChanged", "SWU_InitializeStarWarsUniverseClientSide", function (uid, oldState, newState)
        if (newState == SIGNONSTATE_FULL) then
            hook.Add("SetupMove", "SWU_CheckWhenPlayerIsHere", function (ply)
                hook.Remove("SetupMove", "SWU_CheckWhenPlayerIsHere")
                SWU:LoadMap(game.GetMap())
                net.Start("swu_sendInteractionConfiguration")
                net.WriteBool(SWU.Configuration:GetConVar("swu_enable_interaction"):GetBool())
                net.SendToServer()
            end)
        end
    end)
end

hook.Add("PostCleanupMap", "SWU_ReInitializeStarWarsUniverse", function () SWU:LoadMap(game.GetMap()) end)