local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor(Color(10,10,10,200))
end

function PANEL:SetMaterial(mat)
    self.mat = isstring(mat) and Material(mat, "smooth") or mat
end

function PANEL:GetMaterial()
    return self.mat
end

function PANEL:SetColor(color)
    self.color = color
end

function PANEL:GetColor()
    return self.color or Color(255,255,255)
end

function PANEL:SetPadding(padding)
    self.padding = padding
end

function PANEL:GetPadding()
    return self.padding or 0
end

function PANEL:SetOnClick(onclick, hoverColor, clickColor)
    if (not isfunction(onclick)) then
        self:SetCursor("arrow")
        return
    end

    self:SetCursor("hand")
    self.onClick = onclick
    self.hoverColor = hoverColor or self:GetColor()
    self.clickColor = clickColor or self:GetColor()
end

function PANEL:OnMouseReleased(keyCode)
    if (keyCode ~= MOUSE_LEFT or not isfunction(self.onClick)) then return end

    self:onClick()
end

function PANEL:PaintOver(w,h)
    local color = self:GetColor()
    if (isfunction(self.onClick) and self:IsHovered()) then
        color = input.IsMouseDown(MOUSE_LEFT) and self.clickColor or self.hoverColor
    end

    surface.SetDrawColor(color)
    surface.SetMaterial(self.mat)
    surface.DrawTexturedRect(0 + self:GetPadding(),0 + self:GetPadding(),w - self:GetPadding() * 2,h - self:GetPadding() * 2)
end


vgui.Register("swu_icon", PANEL, "swu_basepanel")