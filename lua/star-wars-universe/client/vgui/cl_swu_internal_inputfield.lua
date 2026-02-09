local adraw = include("libs/advanceddraw.lua")
local PANEL = {}

function PANEL:Init()
    self:SetPaintBackground(false)
    self:SetTextColor(SWU.Colors.Default.passive)
    self:SetCursorColor(SWU.Colors.Default.passive)
    self:SetDrawLanguageID(false)
end

function PANEL:UpdateFont(h)
    self:SetFont(adraw.xFont("!Saira", math.floor(h * 0.9)))
end

function PANEL:OnSizeChanged(w,h)
    self:UpdateFont(h)
end

function PANEL:Paint(w,h)
    derma.SkinHook("Paint", "TextEntry", self, w, h)
    return false
end


vgui.Register("swu_internal_inputfield", PANEL, "DTextEntry")