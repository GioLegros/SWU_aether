include("shared.lua")
local adraw = include("libs/advanceddraw.lua")

SWU = SWU or {}

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.Scale = 200
	self.BlockWidth = 0.2
	self.BlockHeight = 0.4
	self.BlockMarginVertical = 0.2
	self.BlockMarginHorizontal = 0.1

	self:SharedInitialize()
	self:SetupUsedKeys()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	if adraw.Entity3D2D(self, Vector(3, 6, 44), Angle(0, 90, 61), 1 / self.Scale) then
		local count = 1
		for i = 1, 5 do
			local isLimited = i*20 > SWU.Controller:GetTargetShipAccelerationLimit()

			local clr = SWU.Colors.Default.passive
			if self:GetCurrentSpeed() / 20 >= i then
				clr = SWU.Colors.Default.accent
			elseif isLimited then
				clr = SWU.Colors.Default.error
			end
			surface.SetFont(SWU.Fonts.TechAurabeshSpeed)
			local tW, tH = surface.GetTextSize(tostring(i))
			draw.SimpleText(i - 1, SWU.Fonts.TechAurabeshSpeed, -0.3 * self.Scale, (i - 0.8) * tH, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


			for j = 1, 20 do
				local color = Color(94, 94, 94)
				local highlighted = 0
				if count <= self:GetCurrentSpeed() then
					color = Color(255,255,255)
					highlighted = 0.05
				elseif isLimited then
					color = SWU.Colors.Default.error
				end
				draw.RoundedBox(0, (j - 1) * (self.BlockMarginHorizontal + self.BlockWidth) * self.Scale, (i - 1) * (self.BlockMarginVertical + self.BlockHeight) * self.Scale, (self.BlockWidth + highlighted) * self.Scale, (self.BlockHeight + highlighted) * self.Scale, color)
				count = count + 1
			end
		end
		adraw.End3D2D()
	end
end

function ENT:GetCurrentSpeed()
	if (not IsValid(SWU.Controller)) then return 0 end
	return SWU.Controller:GetCurrentShipAcceleration()
end
