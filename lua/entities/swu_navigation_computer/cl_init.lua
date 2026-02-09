include("shared.lua")
local adraw = include("libs/advanceddraw.lua")

local shipMat = Material("the-coding-ducks/swu/ship-icon.png")
local planetMat = Material("the-coding-ducks/swu/planet-icon.png")
local searchMat = Material("the-coding-ducks/swu/icons/search-icon.png")

SWU = SWU or {}

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self.Width = 11.1
    self.Height = 7.8

    self.Scale = 200

    self:SetPredictable(true)
    self:SharedInitialize()
end

local DIRECTION = {
    BACK = -1,
    FORWARD = 1,
}

function ENT:s(n)
    return self.Scale * n
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:GetDisplayPage()
    return self:GetCurPage() .. "/" .. self:GetPages()
end

function ENT:OpenSearchBar()
    if (IsValid(self.SearchFrame)) then
        self.SearchFrame:Remove()
    end

    self.SearchFrame = vgui.Create("swu_searchframe")
    self.SearchFrame:SetEntity(self)
end

function ENT:GetEntries()
    local entries = string.Split(self:GetPlanets(), "[=]")

    if (#entries < 0 or entries[1] == "" or entries[1] == nil) then return {} end

    return entries
end

function ENT:DrawSearchBar()
    local searchTerm = "Search..."
    local searchTextColor = SWU.Colors.Default.con
    if (string.len(self:GetSearchTerm()) >= 1) then
        searchTerm = self:GetSearchTerm()
        searchTextColor = SWU.Colors.Default.passive
    end

    local x, y, w, h = 0, 275, self:s(self.Width), 120
    local isHovered = adraw.IsHovering(x, y, w, h)
    local isPressed = adraw.IsPressing() and isHovered

    local font = adraw.xFont("!Saira", math.floor(h))
    draw.SimpleText(searchTerm, font, x, y + h * 0.5, searchTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local buttonColor = isHovered and SWU.Colors.Default.primary or SWU.Colors.Default.passive
    buttonColor = isPressed and SWU.Colors.Default.accent or buttonColor
    adraw.DrawBox(x + w - h,y,h,h,4,buttonColor)
    surface.SetMaterial(searchMat)
    local margin = h * 0.2
    surface.DrawTexturedRect(x + w - h + margin * 0.5,y + margin * 0.5,h - margin,h - margin)

    if (isPressed) then
        self:OpenSearchBar()
    end
end

function ENT:DrawTranslucent()
    if adraw.Entity3D2D(self, Vector(2.3, -36, 45.3), Angle(0, 90, 61), 1 / self.Scale) then
        self:DrawSearchBar()

        local offsetTop = self:s(2.3)
        local width = self:s(self.Width)
        local buttonHeight = self:s(self.Height * 0.1)
        local buttonPadding = buttonHeight * 0.2
        for i, v in pairs(self:GetEntries()) do
            local xOffset = (buttonHeight + buttonPadding)
            if (adraw.xTextButton(v, SWU.Fonts.PlainText, 0, offsetTop + xOffset * (i - 1), width, buttonHeight, 4, SWU.Colors.Default.passiv, SWU.Colors.Default.primary, SWU.Colors.Default.accent)) then
                self:SelectPlanet(v)
            end
        end

        if (#self:GetEntries() <= 0) then
            draw.SimpleText("No entries found", SWU.Fonts.PlainText, width * 0.5, offsetTop, SWU.Colors.Default.passiv, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end

        draw.SimpleText(self:GetDisplayPage(), SWU.Fonts.AurabeshNavComputer, self:s(self.Width * 0.5), self:s(self.Height), SWU.Colors.Default.passiv, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

        local pageButtonHeight = self:s(0.6)
        local pageButtonWidth = pageButtonHeight * 2

        -- Page Back
        if (adraw.xConButton(0, self:s(self.Height) - pageButtonHeight, pageButtonWidth, pageButtonHeight, 4, SWU.Colors.Default.passive, SWU.Colors.Default.primary, SWU.Colors.Default.accent, SWU.Colors.Default.none, self:GetCurPage() == 1) and self:GetCurPage() ~= 1) then
            self:TurnPage(DIRECTION.BACK)
        end

        draw.NoTexture()
        surface.DrawPoly({
            {
                x = pageButtonWidth * 0.65,
                y = pageButtonHeight * 12.75
            },
            {
                x = pageButtonWidth * 0.35,
                y = pageButtonHeight * 12.5
            },
            {
                x = pageButtonWidth * 0.65,
                y = pageButtonHeight * 12.2
            }
        })
        -- Page Forward
        if (adraw.xConButton(self:s(self.Width) - pageButtonWidth, self:s(self.Height) - pageButtonHeight, pageButtonWidth, pageButtonHeight, 4, SWU.Colors.Default.passiv, SWU.Colors.Default.primary, SWU.Colors.Default.accent, SWU.Colors.Default.none, self:GetCurPage() == self:GetPages()) and self:GetCurPage() ~= self:GetPages()) then
            self:TurnPage(DIRECTION.FORWARD)
        end

        draw.NoTexture()
        surface.DrawPoly({
            {
                x = pageButtonWidth * 8.95,
                y = pageButtonHeight * 12.5
            },
            {
                x = pageButtonWidth * 8.65,
                y = pageButtonHeight * 12.75
            },
            {
                x = pageButtonWidth * 8.65,
                y = pageButtonHeight * 12.2
            }
        })

        adraw.End3D2D()
    end

    if adraw.Entity3D2D(self, Vector(2.3, 26.8, 45.3), Angle(0, 90, 61), 1 / self.Scale) then
        local w, h = 11 * self.Scale, 9.75 * self.Scale

        if (self:GetProgress() > 0 and self:GetProgress() < 1 or self:GetLoading()) then
            local pW, pH = w * 0.8, h * 0.1
            local borderWidth = pH * 0.1

            surface.SetDrawColor(ColorAlpha(SWU.Colors.Default.con, 200):Unpack())
            surface.DrawOutlinedRect((w - pW) * 0.5, (h - pH) * 0.5, pW, pH, borderWidth)

            surface.SetDrawColor(SWU.Colors.Default.passive:Unpack())
            surface.DrawRect((w - pW + borderWidth * 2) * 0.5, (h - pH + borderWidth * 2) * 0.5, (pW - borderWidth * 2) * self:GetProgress(), pH - borderWidth * 2, borderWidth)
        end
        if (self:CanJumpHyperspace()) then
            surface.SetDrawColor(Color(110, 219, 0))
            surface.SetMaterial(planetMat)
            surface.DrawTexturedRectRotated(2040, 435, self.Scale, self.Scale, 0)
            surface.SetDrawColor(Color(255,255,255))
            surface.SetMaterial(shipMat)
            surface.DrawTexturedRectRotated(150 + (2040 - 150) * self:GetTravelPercentage(), 435, self.Scale, self.Scale, -90)
            draw.SimpleText(self:GetTargetPlanet() or "", SWU.Fonts.PlainText, (2040 + 150) * 0.5, 150, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        end
        adraw.End3D2D()
    end

    if adraw.Entity3D2D(self, Vector(2, 10, 45.3), Angle(0, 90, 61), 1 / self.Scale) then
        local targetAngle = self:GetTargetAngle()
        if (targetAngle) then
            if (not self:CanJumpHyperspace()) then
                goto skipAngleDraw
            end
            local color = Color(255, 255, 255)
            local textWidth = draw.SimpleText(math.Round(targetAngle.y, 3), SWU.Fonts.AurabeshNavComputer2, 575, 480, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("°", SWU.Fonts.PlainNavComputer, 575 + textWidth * 0.5 + 50, 465, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        ::skipAngleDraw::
        adraw.End3D2D()
    end
    if adraw.Entity3D2D(self, Vector(2, 17, 45.3), Angle(0, 90, 61), 1 / self.Scale) then
        if (self:CanJumpHyperspace()) then
            draw.SimpleText(self:GetTimer(), SWU.Fonts.AurabeshNavComputer2, 575, 480, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        adraw.End3D2D()
    end
end

function ENT:CanJumpHyperspace()
    return not self:GetLoading() and self:GetEstimatedJumpTime() > 0
end

function ENT:GetTravelPercentage()
    if (self:GetJumpStartTime() <= 0) then return 0 end

    return (CurTime() - self:GetJumpStartTime()) / self:GetEstimatedJumpTime()
end

function ENT:GetTimer()
    if (self:GetEstimatedJumpTime() <= 0 or self:GetLoading()) then return "" end

    local offset = 0
    if (self:GetJumpStartTime() > 0) then
        offset = CurTime() - self:GetJumpStartTime()
    end
    return string.FormattedTime(self:GetEstimatedJumpTime() - offset, "%02i:%02i:%02i" )
end

function ENT:SelectPlanet(name)
    self:StartNetAction()
    net.WriteUInt(2, 3) -- Action Select Planet
    net.WriteString(name)
    net.SendToServer()
end

function ENT:TurnPage(direction)
    self:StartNetAction()
    net.WriteUInt(1, 3) -- Action Turn Page
    net.WriteInt(direction, 3)
    net.SendToServer()
end

function ENT:UpdatePlanetList(searchTerm)
    self:StartNetAction()
    net.WriteUInt(3, 3) -- Action Update Planet List
    net.WriteString(searchTerm)
    net.SendToServer()
end