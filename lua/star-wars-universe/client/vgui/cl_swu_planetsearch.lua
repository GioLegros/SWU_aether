local PANEL = {}

function PANEL:Init()
    self.Page = 1
    self.maxPages = 1

    self:SetBackgroundColor(Color(50,50,50,100))
    local padding = self:GetParent():GetWide() * 0.02
    self:DockPadding(padding, padding * 0.5, padding, padding * 0.5)

    self.searchField = self:Add("swu_inputfield")
    self.searchField:Dock(TOP)
    self.searchField:SetIconRight("the-coding-ducks/swu/icons/search-icon.png", nil, function ()
        self:Search()
    end, SWU.Colors.Default.primary, SWU.Colors.Default.accent)
    self.searchField:SetOnEnter(function () self:Search() end)
    self.searchField:SetSize(0, self:GetParent():GetTall() * 0.1)

    self.planetList = self:Add("swu_basepanel")
    self.planetList:Dock(FILL)
    self.planetList:SetPaintBackground(false)
    self.planetList:DockMargin(0,padding * 0.5,0,padding * 0.5)

    self.pageBar = self:Add("swu_basepanel")
    self.pageBar:SetPaintBackground(false)
    self.pageBar:Dock(BOTTOM)

    local left = self.pageBar:Add("swu_button")
    left:Dock(LEFT)
    left:SetText("<")
    left:SetCentered(true)
    left.OnClick = function ()
        if (self.Page <= 1) then return end

        self:GetPlanetPage(self.Page - 1, self.searchField:GetValue())
    end

    self.pageDisplay = self.pageBar:Add("DLabel")
    self.pageDisplay:SetFont("SwuRowText")
    self.pageDisplay:SetText("Page 0 of 0")
    self.pageDisplay:SetContentAlignment(5)
    self.pageDisplay:Dock(FILL)
    self.pageDisplay:SetColor(Color(255,255,255))

    local right = self.pageBar:Add("swu_button")
    right:Dock(RIGHT)
    right:SetText(">")
    right:SetCentered(true)
    right.OnClick = function ()
        if (self.Page >= self.maxPages) then return end

        self:GetPlanetPage(self.Page + 1, self.searchField:GetValue())
    end

    net.Receive("swu_search_getPlanetPage", function ()
        local planets = net.ReadTable()
        self.maxPages = net.ReadInt(11)
        self:SetPlanets(planets)
        self.pageDisplay:SetText("Page " .. self.Page .. " of " .. self.maxPages)
    end)

    self:GetPlanetPage(1)
end

function PANEL:GetPlanetPage(page, filter)
    self.Page = page

    if (filter == "") then
        filter = nil
    end

    net.Start("swu_search_getPlanetPage")
    net.WriteInt(page, 11)
    net.WriteInt(10, 6)
    if (filter) then
        net.WriteString(filter)
    end
    net.SendToServer()
end

function PANEL:SetPlanets(planets)
    self.planetList:Clear()

    for i, v in ipairs(planets) do
        local button = self.planetList:Add("swu_button")
        button.Planet = v
        button:SetText(v.name)
        button:Dock(TOP)
        button:SetSize(0, self:GetParent():GetTall() / 12)
        function button:OnClick()
            self:GetParent():GetParent():GetParent().info:LoadPlanet(self.Planet)
        end
    end
end

function PANEL:Search()
    self:GetPlanetPage(1, self.searchField:GetValue())
end

vgui.Register("swu_planetsearch_panel", PANEL, "swu_basepanel")
