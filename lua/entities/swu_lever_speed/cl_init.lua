include("shared.lua")
local adraw = include("libs/advanceddraw.lua")

SWU = SWU or {}

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:ClientInitialize()
    self.Scale = 100
    self.ButtonWidth = 175
    self.ButtonHeight = 137
    self.Pos = 0
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    if adraw.Entity3D2D(self, Vector(0.33, -1.84, 4.8), Angle(0, 90, 23), 1 / self.Scale) then
        local shouldAcceptInput, isHovering = adraw.xButton(0, 0, self.ButtonWidth, self.ButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent)

        if shouldAcceptInput then
            self:StartNetAction()
            net.WriteBool(true)
            net.SendToServer()
        end

        surface.SetAlphaMultiplier(1)
        draw.NoTexture()
        surface.SetDrawColor(SWU.Colors.Default.passive:Unpack())
        if isHovering then
            if (adraw.IsPressing()) then
                surface.SetDrawColor(SWU.Colors.Default.accent:Unpack())
            else
                surface.SetDrawColor(SWU.Colors.Default.primary:Unpack())
            end
        end

        surface.DrawPoly({
            {
                x = self.ButtonWidth * 0.5,
                y = self.ButtonHeight * 0.25
            },
            {
                x = self.ButtonWidth * 0.75,
                y = self.ButtonHeight * 0.75
            },
            {
                x = self.ButtonWidth * 0.25,
                y = self.ButtonHeight * 0.75
            }
        })

        shouldAcceptInput, isHovering, isClicked = adraw.xButton(192, 0, self.ButtonWidth, self.ButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent)
        if shouldAcceptInput then
            self:StartNetAction()
            net.WriteBool(false)
            net.SendToServer()
        end

        surface.SetAlphaMultiplier(1)
        draw.NoTexture()
        surface.SetDrawColor(SWU.Colors.Default.passive:Unpack())
        if isHovering then
            if (adraw.IsPressing()) then
                surface.SetDrawColor(SWU.Colors.Default.accent:Unpack())
            else
                surface.SetDrawColor(SWU.Colors.Default.primary:Unpack())
            end
        end

        surface.DrawPoly({
            {
                x = self.ButtonWidth * 1.6,
                y = self.ButtonHeight * 0.75
            },
            {
                x = self.ButtonWidth * 1.35,
                y = self.ButtonHeight * 0.25
            },
            {
                x = self.ButtonWidth * 1.85,
                y = self.ButtonHeight * 0.25
            }
        })
        adraw.End3D2D()
    end
end