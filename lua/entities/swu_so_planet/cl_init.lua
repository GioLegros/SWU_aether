include("shared.lua")

function ENT:SetupRenderVars()
	self.renderVarsSetup = true

	self.terrainMat = Material(self:GetTerrainMaterial())
	self.cloudMat = Material(self:GetCloudMaterial())

	self.atmosphereColor = self:GetAtmosphereColor():ToColor()
end

local centerOrigin = Vector()
local white = Color(255,255,255)
function ENT:Draw()
	if (SWU.Controller:GetHyperspace() == SWU.Hyperspace.IN) then return end

	if (not self.renderVarsSetup) then
		self:SetupRenderVars()
	end

	self:DrawModel()

	if (self:GetAnimated()) then return end

	local terrainModelMatrix = cam.GetModelMatrix()
	terrainModelMatrix:SetTranslation(self:GetPos())
	terrainModelMatrix:Rotate(Angle(0,CurTime() % 360,0))

	local terrainRadius = self.PlanetRadius
	local cloudRadius = self.PlanetRadius * 1.005
	local atmosphereRadius = self.PlanetRadius * 1.01

	cam.PushModelMatrix(terrainModelMatrix)
	render.SetMaterial(self.terrainMat)
	render.DrawSphere(centerOrigin, terrainRadius, 50, 50, white)
	cam.PopModelMatrix()

	if (self:GetWeather()) then
		if (self.cloudMat ~= nil and not self.cloudMat:IsError()) then
			local cloudModelMatrix = cam.GetModelMatrix()
			cloudModelMatrix:SetTranslation(self:GetPos())
			cloudModelMatrix:Rotate(Angle(0,CurTime() % 360 * 3,0))

			cam.PushModelMatrix(cloudModelMatrix)
			render.SetMaterial(self.cloudMat)
			render.DrawSphere(centerOrigin, cloudRadius, 50, 50, white)
			cam.PopModelMatrix()
		end

		render.SetColorMaterial()
		render.DrawSphere(self.worldPos, atmosphereRadius, 50, 50, self.atmosphereColor)
	end
end