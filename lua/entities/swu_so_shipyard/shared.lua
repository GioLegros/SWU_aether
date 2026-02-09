ENT.Type = "anim"
ENT.PrintName = "[SWU] Model Object"
ENT.Base = "swu_so_base"
ENT.AutomaticFrameAdvance = true

function ENT:PreInitialize()
    self.Model = self:GetObjectModel()
end

function ENT:PostLoad()
    if (CLIENT) then return end

    self:SetModel("models/lordtrilobite/starwars/isd/imp_shipyard_128.mdl")

    self.PartA = ents.Create("base_gmodentity")
    self.PartA:SetParent(self)
    self.PartA:SetModel("models/lordtrilobite/starwars/isd/imp_shipyard_128.mdl")
    self.PartA:SetPos(self:GetPos())
    self.PartA:SetLocalAngles(Angle(0,120,0))
    self.PartA:SetModelScale(self:GetBaseScale())
    self.PartA:Spawn()

    self.PartB = ents.Create("base_gmodentity")
    self.PartB:SetParent(self)
    self.PartB:SetModel("models/lordtrilobite/starwars/isd/imp_shipyard_128.mdl")
    self.PartB:SetPos(self:GetPos())
    self.PartB:SetLocalAngles(Angle(0,-120,0))
    self.PartB:SetModelScale(self:GetBaseScale())
    self.PartB:Spawn()
end

function ENT:OnRemove()
    if (SERVER) then
        self.PartA:Remove()
        self.PartB:Remove()
    end
end

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
    self:SetBaseScale(info.baseScale or 1)
    self:SetObjectModel(info.model)
    self.Model = info.model

    self:PostLoad()
end

function ENT:SetupExtraDataTables()
    self:NetworkVar("String", 1, "ObjectModel")
end

function ENT:Rescale(scale)
    scale = scale * self:GetBaseScale()

    self:SetModelScale(scale)
    for i, v in ipairs(self:GetChildren()) do
        v:SetModelScale(scale)
    end

    local renderBoundsMin, renderBoundsMax = self:GetModelRenderBounds()

    if (CLIENT) then
        self:SetRenderBounds(renderBoundsMin * 1.005 * scale, renderBoundsMax * 1.01 * scale)
    end
end

function ENT:Collide()
end

function ENT:OnRemove()
    if (CLIENT) then
        table.RemoveByValue(SWU.Map, self)
    end
end
