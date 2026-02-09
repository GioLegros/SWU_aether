local PANEL = {}

surface.CreateFont("SwuHeader", {
    font = "Saira",
    size = 40,
    weight = 500,
    antialias = true,
    shadow = false
})

function PANEL:Init()
    self:Dock(TOP)

    self:SetSize(self:GetParent():GetWide(), 40)
    self:DockMargin(0,0,0,10)
end

function PANEL:SetText(text)
    self.Text = text
end

function PANEL:GetText()
    return self.Text
end

function PANEL:Paint(w,h)
    local textW, textH = draw.SimpleText(self.Text, "SwuHeader", 0, 0)

    local lineHeight = h * 0.05
    draw.RoundedBox(0,textW + w * 0.01,(h - lineHeight) * 0.5,w,lineHeight, Color(255,255,255))
end

vgui.Register("swu_header", PANEL, "swu_basepanel")