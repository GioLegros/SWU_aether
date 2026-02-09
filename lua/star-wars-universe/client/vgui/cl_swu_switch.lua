local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor(Color(10,10,10,200))

    self:SetCursor("hand")

    self.Color = {
        Deactivated = Color(200,20,20),
        Activated = Color(122, 201, 67)
    }
end

function PANEL:SetMaterial(mat)
    self.mat = isstring(mat) and Material(mat, "smooth") or mat
end

function PANEL:GetMaterial()
    return self.mat
end

function PANEL:SetHeightMultiplier(multiplier)
    self.HeightMultiplier = multiplier
end
function PANEL:GetHeightMultiplier()
    return self.HeightMultiplier or 1
end

function PANEL:OnChange(newValue)
end

function PANEL:GetValue()
    return self.Value
end

function PANEL:SetValue(value)
    self.Value = value
end

function PANEL:GetConVar()
    return self.ConVar
end

function PANEL:SetConVar(conVarName)
    if (not ConVarExists(conVarName)) then return end

    self.ConVar = conVarName

    self:SetValue(SWU.Configuration:GetConVar(self.ConVar):GetBool())
end

function PANEL:Paint(w,h)
    local oHeight = h
    h = h * self:GetHeightMultiplier()
    local y = (oHeight - h) * 0.5

    local circleX = self:GetValue() and w - h or 0

    draw.RoundedBox(h * 0.5,0,y,w,h, self:GetBackgroundColor())

    draw.RoundedBox(h * 0.5,circleX,y,h,h, self:GetValue() and self.Color.Activated or self.Color.Deactivated)
end

function PANEL:OnMouseReleased(keyCode)
    if (keyCode ~= MOUSE_LEFT) then return end

    self:SetValue(not self:GetValue())
    self:OnChange(self:GetValue())
end

vgui.Register("swu_switch", PANEL, "swu_basepanel")
