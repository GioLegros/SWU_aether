local adraw = include("libs/advanceddraw.lua")
local PANEL = {}

function PANEL:Paint()
    if (self:GetPaintBackground()) then
        adraw.Derma_DrawPanelBlur(self, self:GetBackgroundColor())
    end
end

vgui.Register("swu_basepanel", PANEL, "DPanel")