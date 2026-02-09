local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:DockPadding(0,0,0,0)

    self:MakePopup()

    self.SearchField = self:Add("swu_inputfield")
    local searchField = self.SearchField
    searchField:SetSize(ScrW() * 0.4, ScrH() * 0.1)
    searchField:SetIconRight("the-coding-ducks/swu/icons/search-icon.png", nil, function ()
        self:Search()
    end, SWU.Colors.Default.primary, SWU.Colors.Default.accent)
    searchField:SetOnEnter(function () self:Search() end)
    searchField:Center()
    searchField:RequestFocus()
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

function PANEL:Search()
    if (not IsValid(self:GetEntity())) then self:Remove() return end

    self:GetEntity():UpdatePlanetList(self.SearchField:GetValue())
    SWU.Util.IgnoreEnter = CurTime()
    self:Remove()
end

function PANEL:OnMouseReleased(keyCode)
    if (keyCode ~= MOUSE_LEFT) then return end

    -- Workaround that the frame doesn't open again, thanks IMGUI
    timer.Simple(0, function ()
        self:Remove()
    end)
end

function PANEL:Think()
    if (input.IsKeyDown(KEY_ESCAPE)) then
        self:Remove()
        gui.HideGameUI()
    end
end

function PANEL:Paint()

end

vgui.Register("swu_searchframe", PANEL, "DFrame")
