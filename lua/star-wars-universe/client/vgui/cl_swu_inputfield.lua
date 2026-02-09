local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor(Color(10,10,10,200))

    self.barHeight = self:GetTall() * 0.04

    self.inputField = self:Add("swu_internal_inputfield")
end

function PANEL:OnSizeChanged(w,h)
    self.barHeight = h * 0.04

    self:UpdateIconRightSize()

    local inputFieldWidth = self:GetWide() - self.barHeight * 4

    if (IsValid(self:GetIconRight())) then
        inputFieldWidth = inputFieldWidth - self:GetIconRight():GetWide()
    end

    self.inputField:SetSize(inputFieldWidth, self:GetTall() - self.barHeight * 2)
    self.inputField:SetPos(self.barHeight * 2, self.barHeight)
end

function PANEL:SetIconRight(mat, backgroundColor, onClick, hoverColor, clickColor)
    self.iconRight = self:Add("swu_icon")
    if (IsColor(backgroundColor)) then
        self.iconRight:SetBackgroundColor(backgroundColor)
    else
        self.iconRight:SetPaintBackground(false)
    end
    self.iconRight:SetMaterial(mat)
    self.iconRight:SetOnClick(onClick, hoverColor, clickColor)

    self:UpdateIconRightSize()
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function PANEL:UpdateIconRightSize()
    if (not IsValid(self:GetIconRight())) then return end

    self:GetIconRight():SetSize(self:GetTall(), self:GetTall())
    self:GetIconRight():SetPos(self:GetWide() - self:GetTall(), 0)
    self:GetIconRight():SetPadding(self:GetTall() * 0.2)
end

function PANEL:GetIconRight()
    return self.iconRight
end

function PANEL:PaintOver(w,h)
    local barColor = self.inputField:IsEditing() and SWU.Colors.Default.accent or SWU.Colors.Default.passive

    draw.RoundedBox(0,0,h - self.barHeight,w, self.barHeight, barColor)
end

function PANEL:GetValue()
    return self.inputField:GetValue()
end

function PANEL:SetOnEnter(onEnter)
    self.inputField.OnEnter = function ()
        if (isfunction(onEnter)) then
            onEnter()
        end
    end
end

function PANEL:RequestFocus()
    self.inputField:RequestFocus()
end

vgui.Register("swu_inputfield", PANEL, "swu_basepanel")