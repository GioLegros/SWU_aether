ENT.Type = "anim"
ENT.PrintName = "[SWU] Planet"
ENT.Base = "swu_so_base"
ENT.Model = "models/hunter/misc/sphere1x1.mdl"
ENT.AutomaticFrameAdvance = true

local function ColorToString(c)
    return c.r .. " " .. c.g .. " " .. c.b .. " " .. c.a
end

local clouds = {
    "the-coding-ducks/swu/planets/clouds/cloud_1",
    "the-coding-ducks/swu/planets/clouds/cloud_2",
    "the-coding-ducks/swu/planets/clouds/cloud_3",
}

function ENT:InheritanceChildInitialize()
    self:Rescale(1)

    if (CLIENT) then
        table.insert(SWU.Map, self)
    end
end

function ENT:Load(info)
    self:SetId(info.name)
    self:SetUniversePos(info.pos or Vector())
    self:SetUniverseAngles(info.angle or Angle())
    self:SetAtmosphereColor(ColorToString(info.atmosphereColor or Color(0,0,120,5)))
    self:SetTerrainMaterial(info.terrain)
    self:SetCloudMaterial(info.clouds or "")
    self:SetWeather(info.weather or false)
    self:SetBaseScale(info.baseScale or (SWU.config.planetBaseSize or 10))
    if (self:GetWeather() and info.clouds == nil) then
        self:SetCloudMaterial(clouds[math.random(1, #clouds + 1)] or "")
    end

    self:SetMaterial(info.terrain)
    self:PostLoad()
end

function ENT:SetupExtraDataTables()
    self:NetworkVar("String", 1, "TerrainMaterial")
    self:NetworkVar("String", 2, "CloudMaterial")
    self:NetworkVar("String", 3, "AtmosphereColor")
    self:NetworkVar("Bool", 1, "Weather")
end

function ENT:Rescale(scale)
    scale = scale * self:GetBaseScale()

    self:SetModelScale(scale)

    local renderBoundsMin, renderBoundsMax = self:GetModelRenderBounds()
    self.PlanetRadius = math.abs(renderBoundsMin.x * scale)

    if (CLIENT) then
        self:SetRenderBounds(renderBoundsMin * 1.005 * scale, renderBoundsMax * 1.01 * scale)
    end
    self.CollisionRange = self.PlanetRadius
end

function ENT:Collide()
    if (self:GetAnimated()) then return end

    util.ScreenShake(Vector(), 10, 5, 10, 50000)
    self:SetAnimated(true)
    self:SetModel("models/mig/planet.mdl")
    self:SetMaterial(self:GetTerrainMaterial())

    self:Think()
    self:ResetSequence("explode")
    self:SetPlaybackRate(0.05)
end

function ENT:OnRemove()
    if (CLIENT) then
        table.RemoveByValue(SWU.Map, self)
    end
end
