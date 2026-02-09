include("shared.lua")
local adraw = include("libs/advanceddraw.lua")

SWU = SWU or {}

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:ClientInitialize()
    self.Scale = 100
    self.ButtonWidth = 367
    self.ButtonHeight = 137
    self.Pos = 0
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    local color
    local jumpHyperspace = SWU.Controller:IsInHyperspace()
    local parent = self:GetParent()
    if (not IsValid(parent) or not isfunction(parent.GetLoading)) then
        return
    end
    if (parent:GetLoading() or parent:GetEstimatedJumpTime() < 5) then
        color = Color(75, 75, 75)
    end
    if not SWU.Controller:GetCanJumpIntoHyperspace() then
        color = SWU.Colors.Default.error
    end
    if (SWU.Controller:GetHyperspace() == SWU.Hyperspace.TRANSITIONING) then
        if adraw.Entity3D2D(self, Vector(0.33, -1.84, 4.8), Angle(0, 90, 23), 1 / self.Scale) then
            adraw.xTextButton("", SWU.Fonts.PlainText, 0, 0, self.ButtonWidth, self.ButtonHeight, 4, color or Color(80,80,80), color or Color(255,255,255), color or Color(80,80,80))
            adraw.End3D2D()
        end
        return
    end
    if (not jumpHyperspace) then
        if adraw.Entity3D2D(self, Vector(0.33, -1.84, 4.8), Angle(0, 90, 23), 1 / self.Scale) then
            if adraw.xTextButton("JUMP", SWU.Fonts.PlainText, 0, 0, self.ButtonWidth, self.ButtonHeight, 4, color or Color(80,159,0), color or Color(255,255,255), color or Color(0,219,0)) then
                self:StartNetAction()
                net.WriteBool(not jumpHyperspace)
                net.SendToServer()
            end
            adraw.End3D2D()
        end
    else
        if adraw.Entity3D2D(self, Vector(0.33, -1.84, 4.8), Angle(0, 90, 23), 1 / self.Scale) then
            if adraw.xTextButton("ABORT", SWU.Fonts.PlainText, 0, 0, self.ButtonWidth, self.ButtonHeight, 4, color or Color(110,16,0), color or Color(255,255,255), color or Color(189,0,11)) then
                self:StartNetAction()
                net.WriteBool(not jumpHyperspace)
                net.SendToServer()
            end
            adraw.End3D2D()
        end
    end
end