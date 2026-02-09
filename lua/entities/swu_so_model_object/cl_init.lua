include("shared.lua")

function ENT:Draw()
	if (SWU.Controller:GetHyperspace() == SWU.Hyperspace.IN) then return end

	self:DrawModel()
end
