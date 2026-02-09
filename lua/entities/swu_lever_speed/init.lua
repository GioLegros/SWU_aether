AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:ReceiveNetAction()
    if (not IsValid(SWU.Controller) or SWU.Controller:GetHyperspace() ~= SWU.Hyperspace.OUT) then return end

    self:GetParent():ChangeSpeed(net.ReadBool())
end
