local PANEL = {}

function PANEL:Init()
    local parent = self:GetParent()
    self:SetSize(parent:GetWide(), parent:GetTall())
    self:SetBackgroundColor(Color(50,50,50,100))

    local padding = self:GetWide() * 0.02
    self:DockPadding(padding, padding * 0.25, padding, padding * 0.25)
end

vgui.Register("swu_basetab", PANEL, "swu_basepanel")