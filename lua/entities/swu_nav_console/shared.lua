ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Console de Navigation SWU"
ENT.Author = "Custom"
ENT.Category = "[SWU] Universe"
ENT.Spawnable = true

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_lab/reciever01b.mdl") -- Modèle temporaire, change le
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end
end