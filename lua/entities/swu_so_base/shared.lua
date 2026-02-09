ENT.Type = "anim"
ENT.PrintName = "[SWU] Space Object"
ENT.Author = "The Coding Ducks"
ENT.Information = ""
ENT.Category = "[SWU] Universe"

ENT.CollisionRange = 1

ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Id")
    self:NetworkVar("Vector", 0, "UniversePos")
    self:NetworkVar("Angle", 0, "UniverseAngles")

    self:NetworkVar("Float", 0, "BaseScale")

    self:NetworkVar("Bool", 0, "Animated")

    self:SetupExtraDataTables()
end

function ENT:SetupExtraDataTables()
end

function ENT:PreInitialize()

end

function ENT:Initialize()
    self:PreInitialize()

    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)

    self:SetModel(self.Model or "models/hunter/blocks/cube025x025x025.mdl")
    self:SetModelScale(self:GetBaseScale())

    if (CLIENT) then
        self:SetPredictable(true)
    end

    self:InheritanceChildInitialize()
end

function ENT:InheritanceChildInitialize()
end

--{
--    id
--    pos
--    angle
--}
function ENT:Load(info)
    self:SetId(info.id)
    self:SetUniversePos(info.pos or Vector())
    self:SetUniverseAngles(info.angle or Angle())
    self:SetBaseScale(info.baseScale or 1)

    self:PostLoad()
end

function ENT:PostLoad()

end

-- TODO: Work with universe pos and don't calculate and change their positions if not visible
function ENT:UpdatePos(newPos, dist, maxDist)
    if (dist > maxDist) then
        self:SetNoDraw(true)
    elseif (newPos:WithinAABox(SWU.config.skyboxBoundaries.min, SWU.config.skyboxBoundaries.max)) then
        self:SetNoDraw(false)
        self:SetPos(newPos)
    end
end

local function f(x)
    return math.abs(x - 1)
end

function ENT:Think()
    if (not IsValid(SWU.Controller)) then return end

    local worldPosRotated, worldPos = SWU:CalculateWorldPos(self:GetUniversePos())
    local maxDist = 9 * 9
    local dist = SWU.Controller:GetShipPos():DistToSqr(self:GetUniversePos())

    self:UpdatePos(worldPosRotated, dist, maxDist)
    self.worldPos = worldPos

    if (self:GetNoDraw()) then return end

    local scale = math.min(1, dist / maxDist)
    self:Rescale(f(scale))
    self:SetAngles(self:GetUniverseAngles() + SWU.Controller:GetInternalShipAngles())

    if (self:GetAnimated()) then
        self:NextThink(CurTime())
        return true
    end
end

function ENT:Rescale(scale)
    self:SetModelScale(scale)
end

function ENT:GetCollisionRange()
    return self.CollisionRange
end

function ENT:Collide()
end
