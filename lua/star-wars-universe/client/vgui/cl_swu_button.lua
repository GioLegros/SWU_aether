local adraw = include("libs/advanceddraw.lua")
local PANEL = {}

function PANEL:Init()
    self.Text = ""
    self:SetCursor("hand")
end

function PANEL:SetText(t)
    self.Text = t
end

function PANEL:SetCentered(c)
    self.Centered = c
end

function PANEL:Paint(w,h)
    if (self:IsHovered()) then
        draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200))
    end

    local ah = TEXT_ALIGN_LEFT
    local leftMargin = self:GetWide() * 0.02

    if (self.Centered) then
        ah = TEXT_ALIGN_CENTER
        leftMargin = self:GetWide() * 0.5
    end

    draw.SimpleText(self.Text, "SwuRowText", leftMargin, self:GetTall() * 0.5, Color(255,255,255), ah, TEXT_ALIGN_CENTER)
end

function PANEL:OnMouseReleased(keyCode)
    if (keyCode ~= MOUSE_LEFT) then return end

    self:OnClick()
end

function PANEL:OnClick() end

vgui.Register("swu_button", PANEL, "DPanel")
