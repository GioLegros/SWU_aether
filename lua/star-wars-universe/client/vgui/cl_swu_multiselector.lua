local PANEL = {}

surface.CreateFont("SwuMultiSelectorText", {
    font = "Saira",
    size = 25,
    weight = 250,
    antialias = true,
    shadow = false
})

function PANEL:Init()
    self:SetPaintBackground(false)

    self:DockPadding(0,5,0,5)
end

function PANEL:SetOptions(options)
    self:Clear()

    local totalWidth = 0

    self.Buttons = {}
    for i, v in ipairs(options) do
        local btn = self:Add("swu_basepanel")
        btn:Dock(LEFT)
        btn:DockMargin(0,0,5,0)
        btn.IsActive = function (self) return self.Active end
        btn.SetActive = function (self, active)
            self.Active = active
            self:SetBackgroundColor(active and SWU.Colors.Default.accent or Color(10,10,10,200))
        end
        btn.PaintOver = function (self, w, h)
            local color = self:IsHovered() and SWU.Colors.Default.primary or Color(255,255,255)

            if (self:IsActive()) then
                color = SWU.Colors.Default.black
            end

            draw.SimpleText(v.text, "SwuMultiSelectorText", w * 0.5, h * 0.5, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        btn.OnMouseReleased = function (_, keyCode)
            if (keyCode ~= MOUSE_LEFT) then return end

            self:SetValue(v.value)
        end
        btn:SetCursor("hand")
        btn:SetSize(ScrW() * 0.025)
        btn:SetBackgroundColor(Color(10,10,10,200))
        totalWidth = totalWidth + btn:GetWide() + 5

        self.Buttons[tostring(v.value)] = btn
    end

    self:SetSize(totalWidth - 5, 0)
end

function PANEL:OnChange(newValue)
end

function PANEL:SetValue(value)
    for i, v in pairs(self.Buttons) do
        v:SetActive(i == tostring(value))
    end

    self.Value = value
    self:OnChange(value)
end

function PANEL:SetConVar(conVarName)
    if (not ConVarExists(conVarName)) then return end

    self.ConVar = conVarName

    self:SetValue(SWU.Configuration:GetConVar(self.ConVar):GetFloat())
end

vgui.Register("swu_multiselector", PANEL, "swu_basepanel")