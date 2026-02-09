local PANEL = {}

function PANEL:Init()
    self.GeneralConfig = self:Add("swu_header")
    local generalConfig = self.GeneralConfig
    generalConfig:SetText("General Config")

    local toggleChangelogRow = self:Add("swu_row")
    toggleChangelogRow:SetText("Enable Changelog")

    local toggleChangelogSwitch = toggleChangelogRow:AddContent("swu_switch")
    toggleChangelogSwitch:SetSize(self:GetWide() * 0.08, toggleChangelogRow:GetTall())
    toggleChangelogSwitch:SetHeightMultiplier(0.8)
    toggleChangelogSwitch:SetConVar("swu_enable_changelog")
    toggleChangelogSwitch.OnChange = function (_, newValue)
        LocalPlayer():ConCommand("swu_enable_changelog " .. (newValue and "1" or "0"))
    end

    local toggleInteractableRow = self:Add("swu_row")
    toggleInteractableRow:SetText("Enable Keyboard Interaction")

    local toggleInteractableSwitch = toggleInteractableRow:AddContent("swu_switch")
    toggleInteractableSwitch:SetSize(self:GetWide() * 0.08, toggleInteractableRow:GetTall())
    toggleInteractableSwitch:SetHeightMultiplier(0.8)
    toggleInteractableSwitch:SetConVar("swu_enable_interaction")
    toggleInteractableSwitch.OnChange = function (_, newValue)
        LocalPlayer():ConCommand("swu_enable_interaction " .. (newValue and "1" or "0"))

        net.Start("swu_sendInteractionConfiguration")
        net.WriteBool(newValue)
        net.SendToServer()
    end

end

vgui.Register("swu_clientconfig", PANEL, "swu_basetab")
