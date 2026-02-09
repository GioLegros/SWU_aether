include("shared.lua")
local adraw = include("libs/advanceddraw.lua")

SWU = SWU or {}

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self.Scale = 100
    self.ButtonWidth = 120
    self.ButtonHeight = 120
    self.ButtonMarginVertical = 20
    self.ButtonMarginHorizontal = 15

    self:SetupUsedKeys()
end

function ENT:Draw()
    self:DrawModel()
end

local mat = Material("the-coding-ducks/swu/ship-icon.png")

function ENT:DrawTranslucent()
    if not IsValid(SWU.Controller) then return end
    local curShipAngle = SWU.Controller:GetShipAngles().y
    if adraw.Entity3D2D(self, Vector(2.5, 3, 45.5), Angle(0, 90, 61), 1 / self.Scale) then
        local w, h = 12 * self.Scale, 10 * self.Scale

        local isLocked = SWU.Controller:GetTargetShipAccelerationLimit() == 0
        local color = isLocked and SWU.Colors.Default.error or Color(255, 255, 255, 255)

        draw.SimpleText(self:GetCurrentRotation(), SWU.Fonts.AurabeshRotation, w * 0.49, h * 0.7, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(math.Round(curShipAngle % 360, 3), SWU.Fonts.AurabeshRotation, w * 0.1, h * 0.1, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(math.Round(SWU.Controller:GetTargetShipAngles().y % 360, 3), SWU.Fonts.AurabeshRotation, w * 0.9, h * 0.1, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        surface.SetMaterial(mat)
        surface.SetDrawColor(color)
        adraw.DrawTexturedRectRotatedPoint(w * 0.5 - 10, h * 0.5, 200, 200, curShipAngle * -1 - 90, 0,0)

        adraw.End3D2D()
    end

    if adraw.Entity3D2D(self, Vector(11.5, 8.15, 33.3), Angle(0, 90, 15), 1 / self.Scale) then
        local w, h = self.ButtonWidth, self.ButtonHeight
        local x, y = 0, 0

        for i = 0, 2 do
            for j = 1, 3 do
                local number = math.abs(i - 2) * 3 + j
                if adraw.xTextButton(number, SWU.Fonts.AurabeshRotation, x, y, w, h, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent) then
                    self:StartNetAction()
                    net.WriteUInt(number, 4)
                    net.SendToServer()
                end
                x = x + w + self.ButtonMarginHorizontal
            end
            x = 0
            y = y + h + self.ButtonMarginVertical
        end

        if adraw.xTextButton("+/-", SWU.Fonts.AurabeshRotation, w * .01, 3 * 140, self.ButtonWidth, self.ButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent) then
            self:StartNetAction()
            net.WriteUInt(12, 4)
            net.SendToServer()
        end
        if adraw.xTextButton(0, SWU.Fonts.AurabeshRotation, w + self.ButtonMarginHorizontal, 3 * 140, self.ButtonWidth, self.ButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent) then
            self:StartNetAction()
            net.WriteUInt(0, 4)
            net.SendToServer()
        end
        if adraw.xTextButton(".", SWU.Fonts.AurabeshRotation, w + self.ButtonMarginHorizontal * 10, 3 * 140, self.ButtonWidth, self.ButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent) then
            self:StartNetAction()
            net.WriteUInt(13, 4)
            net.SendToServer()
        end
        if adraw.xTextButton("DEL", SWU.Fonts.PlainRotation, w * .01, 4 * 140, self.ButtonWidth * 1.5, self.ButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent) then
            self:StartNetAction()
            net.WriteUInt(14, 4)
            net.SendToServer()
        end

        local isLocked = SWU.Controller:GetTargetShipAccelerationLimit() == 0
        local color = isLocked and SWU.Colors.Default.error or SWU.Colors.Default.passive
        local hover = isLocked and SWU.Colors.Default.dark or SWU.Colors.Default.primary

        if adraw.xTextButton("Lock In", SWU.Fonts.PlainRotation, w + self.ButtonMarginHorizontal * 6, 4 * 140, self.ButtonWidth * 1.5, self.ButtonHeight, 4, color, hover, SWU.Colors.Default.accent) then
            self:StartNetAction()
            net.WriteUInt(15, 4)
            net.SendToServer()
        end
        adraw.End3D2D()
    end
end
