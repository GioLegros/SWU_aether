local PANEL = {}
local adraw = include("libs/advanceddraw.lua")


surface.CreateFont("SwuNavigationEntry", {
    font = "Saira",
    size = 40,
    weight = 100,
    antialias = true,
    shadow = false
})

function PANEL:Init()
    self:SetSize(self:GetParent():GetWide(), ScrH() * 0.05)

    self:SetPaintBackground(false)
    self:SetCursor("hand")
end

function PANEL:SetOnClick(onClick)
    self.onClick = onClick
end

function PANEL:OnMouseReleased(keyCode)
    if (keyCode ~= MOUSE_LEFT or not isfunction(self.onClick)) then return end

    self.onClick()
end

function PANEL:SetText(text)
    self.Text = text
end

function PANEL:GetText()
    return self.Text or ""
end

function PANEL:SetActive(active)
    self.Active = active
    self:SetPaintBackground(active)
end

function PANEL:IsActive()
    return self.Active
end

function PANEL:SetId(id)
    self.id = id
end

function PANEL:GetId()
    return self.id
end

function PANEL:PaintOver()
    local color = self:IsActive() and SWU.Colors.Default.accent or (self:IsHovered() and SWU.Colors.Default.primary or SWU.Colors.Default.passive)
    draw.SimpleText(self:GetText(), "SwuNavigationEntry", self:GetWide() * 0.05, self:GetTall() * 0.5, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("swu_navigationentry", PANEL, "swu_basepanel")
