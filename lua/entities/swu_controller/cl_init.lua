include("shared.lua")

function ENT:Draw()
    if (GetConVar("developer"):GetBool()) then
        render.SetColorMaterialIgnoreZ()
        render.DrawSphere(self:GetPos(), SWU.config.collisionRange, 50, 50, Color(240,230,150,150))
    end
end