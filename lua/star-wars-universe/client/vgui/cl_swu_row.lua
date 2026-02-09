local PANEL = {}

surface.CreateFont("SwuRowText", {
    font = "Saira",
    size = 30,
    weight = 250,
    antialias = true,
    shadow = false
})

function PANEL:Init()
    self:Dock(TOP)

    self:SetSize(self:GetParent():GetWide(), 40)
end

function PANEL:SetText(text)
    self.Text = text
end

function PANEL:GetText()
    return self.Text
end

function PANEL:Paint(w,h)
    draw.SimpleText(self.Text, "SwuRowText", 0, h * 0.5, nil, nil, TEXT_ALIGN_CENTER)
end

function PANEL:AddContent(panelClass)
    if (IsValid(self.Content)) then
        self.Content:Remove()
    end

    self.Content = self:Add(panelClass)
    self.Content:Dock(RIGHT)

    return self.Content
end

vgui.Register("swu_row", PANEL, "swu_basepanel")