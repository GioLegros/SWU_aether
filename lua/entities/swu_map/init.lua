AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

SWU = SWU or {}

function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate2x3.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)

    table.insert(SWU.Terminals, self)
end