local PANEL = {}

surface.CreateFont("SwuSettingsHeader", {
    font = "Saira",
    size = 90,
    weight = 200,
    antialias = true,
    shadow = false
})

local closeIconMaterial = Material("the-coding-ducks/swu/icons/close-icon.png", "smooth")
local swuIconMaterial = Material("the-coding-ducks/swu/icons/swu-icon.png", "smooth")

function PANEL:Init()
    self:SetSize(ScrW() * 0.55, ScrH() * 0.7)
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(false)

    self:MakePopup()
    self:Center()

    self.PanelDist = ScrH() * 0.01

    self.Header = self:Add("swu_basepanel")
    local header = self.Header
    header:SetSize(self:GetWide(), self:GetTall() * 0.15)
    header:SetBackgroundColor(Color(10,10,10,200))
    local margin = header:GetTall() * 0.25

    header.SwuIcon = header:Add("swu_icon")
    local swuIcon = header.SwuIcon
    swuIcon:Dock(LEFT)
    swuIcon:SetPaintBackground(false)
    swuIcon:SetMaterial(swuIconMaterial)
    swuIcon:DockMargin(margin, margin * 0.5, 0, margin * 0.5)
    swuIcon:SetSize(header:GetTall() - margin, header:GetTall())

    header.Title = header:Add("DLabel")
    local title = header.Title
    title:SetText("Configuration")
    title:SetFont("SwuSettingsHeader")
    title:SetColor(Color(255,255,255))
    title:SizeToContents()
    title:SetContentAlignment(4)
    title:Dock(LEFT)
    title:DockMargin(margin,0,0,0)

    header.Close = header:Add("swu_icon")
    local close = header.Close
    close:Dock(RIGHT)
    close:SetPaintBackground(false)
    close:SetMaterial(closeIconMaterial)
    close:SetColor(Color(200,20,20))
    close:SetOnClick(function () self:Remove() end, Color(150,0,0), Color(100,0,0))
    close:DockMargin(margin, margin, margin, margin)
    close:SetSize(header:GetTall() - margin * 2, header:GetTall() - margin * 2)

    self.Navigation = self:Add("swu_basepanel")
    local nav = self.Navigation
    nav:SetSize(self:GetWide() * 0.25, self:GetTall() - header:GetTall() - self.PanelDist)
    nav:SetPos(0, header:GetTall() + self.PanelDist)
    nav:SetBackgroundColor(Color(50,50,50,100))

    self.Content = self:Add("swu_basepanel")
    local content = self.Content
    content:SetPaintBackground(false)
    content:SetPos(nav:GetWide() + self.PanelDist, header:GetTall() + self.PanelDist)
    content:SetSize(self:GetWide() - nav:GetWide() - self.PanelDist, self:GetTall() - header:GetTall() - self.PanelDist)

    for i, v in ipairs(SWU.Configuration:GetTabs()) do
        local entry = nav:Add("swu_navigationentry")
        entry:SetText(v.title)
        entry:Dock(TOP)
        entry:SetOnClick(function ()
            self:LoadContent(i)
        end)
        entry:SetId(i)

        if (self.ActiveContentId == nil) then
            self:LoadContent(i)
        end
    end
end

function PANEL:Paint()
end

function PANEL:ClearContent()
    self.Content:Clear()
end

function PANEL:LoadContent(id)
    local newTab = SWU.Configuration:GetTabs()[id]

    if (not istable(newTab)) then return end

    self:ClearContent()

    self.ActiveContentId = id
    newTab.open(self.Content)
    self:UpdateNavigationButtons()
end

function PANEL:UpdateNavigationButtons()
    for i, v in ipairs(self.Navigation:GetChildren()) do
        if (v:GetId() == self.ActiveContentId) then
            v:SetActive(true)
        else
            v:SetActive(false)
        end
    end
end

vgui.Register("swu_configruationframe", PANEL, "DFrame")
