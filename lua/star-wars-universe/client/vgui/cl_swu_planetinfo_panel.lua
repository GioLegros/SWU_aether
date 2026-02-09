local PANEL = {}

local swuIconMaterial = Material("the-coding-ducks/swu/icons/swu-icon.png", "smooth")

function PANEL:Init()
    self:SetBackgroundColor(Color(50,50,50,100))

    local p = self:GetWide() * 0.2
    self:DockPadding(p,p,p,p)

    self.GotoButton = self:Add("swu_button")
    self.GotoButton:SetText("GOTO")
    self.GotoButton:SetCentered(true)
    self.GotoButton:Dock(BOTTOM)
    self.GotoButton:SetSize(0, ScrH() * 0.03)
    self.GotoButton.OnClick = function ()
        if (not istable(self.Planet)) then return end

        net.Start("swu_setShipPos")
        net.WriteVector(self.Planet.pos - Vector(1,0,0))
        net.WriteAngle(Angle())
        net.SendToServer()
    end

    self.logo = self:Add("DPanel")
    self.logo:Dock(TOP)
    function self.logo:Paint(w,h)
        if not self.ratioSet then
            self:SetSize(w,w)
            self.ratioSet = true
        end

        surface.SetDrawColor(Color(255,255,255))
        surface.SetMaterial(swuIconMaterial)
        surface.DrawTexturedRect(w * 0.1,w * 0.1,w * 0.8,w * 0.8)
    end

    self.topExtraBar = self:CreateLine()

    self.planetName = self:Add("DLabel")
    self.planetName:Dock(TOP)
    self.planetName:SetContentAlignment(5)
    self.planetName:SetFont("SwuHeader")
    self.planetName:SetText("No Planet Selected")
    self.planetName:SetColor(SWU.Colors.Default.accent)
    self.planetName:DockMargin(0,self:GetTall() * 0.5,0,self:GetTall() * 0.5)

    self.bottomExtraBar = self:CreateLine()


    self.planetPositionContainer = self:Add("DPanel")
    self.planetPositionContainer:Dock(TOP)
    self.planetPositionContainer.Paint = function () end

    self.planetPositionTitle = self.planetPositionContainer:Add("DLabel")
    self.planetPositionTitle:Dock(LEFT)
    self.planetPositionTitle:SetContentAlignment(4)
    self.planetPositionTitle:SetFont("SwuRowText")
    self.planetPositionTitle:SetText("Position")
    self.planetPositionTitle:SetColor(SWU.Colors.Default.accent)

    self.planetPosition = self.planetPositionContainer:Add("DLabel")
    self.planetPosition:Dock(RIGHT)
    self.planetPosition:SetContentAlignment(6)
    self.planetPosition:SetFont("SwuRowText")
    self.planetPosition:SetText("[0 : 0]")
    self.planetPosition:SetColor(SWU.Colors.Default.passive)

    self.planetPosition:SizeToContents()
    self.planetPositionTitle:SizeToContents()

    self.planetPositionContainer:SizeToContents()
    self.planetPositionContainer:DockMargin(0,self:GetTall() * 0.5,0,self:GetTall() * 0.5)

end

function PANEL:LoadPlanet(p)
    self.Planet = p
    self.planetName:SetText(p.name)
    self.planetPosition:SetText("[" .. math.Round(p.pos.x, 2) .. " : " .. math.Round(p.pos.y, 2) .. "]")


    self.planetPosition:SizeToContents()
    self.planetPositionTitle:SizeToContents()
    self.planetPositionContainer:SizeToContents()
end

function PANEL:CreateLine()
    local line = self:Add("DPanel")
    line:Dock(TOP)
    line:SetSize(0, ScrH() * 0.004)
    function line:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
    end
end


vgui.Register("swu_planetinfo_panel", PANEL, "swu_basepanel")
