AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)

	self:SetPos(self.max - self.min)
	self:SetCollisionBounds(self:WorldToLocal(self.min), self:WorldToLocal(self.max))
end

function ENT:Load(config)
	self.min = config.min
	self.max = config.max
	self.dir = config.tDir
end

function ENT:Touch(entity)
	SWU:OnTeleporterTouch(entity, self.dir)
end
