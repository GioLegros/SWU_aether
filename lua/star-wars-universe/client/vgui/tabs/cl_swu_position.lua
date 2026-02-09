local PANEL = {}

function PANEL:Init()
    self:SetPaintBackground(false)
    self:DockMargin(0,0,0,0)
    self:DockPadding(0,0,0,0)

    self.search = self:Add("swu_planetsearch_panel")
    self.search:Dock(LEFT)
    self.search:SetSize(self:GetWide() * 0.65 - self:GetParent():GetParent().PanelDist, 0)

    self.info = self:Add("swu_planetinfo_panel")
    self.info:Dock(RIGHT)
    self.info:SetSize(self:GetWide() * 0.35, 0)
end

vgui.Register("swu_position", PANEL, "swu_basetab")
