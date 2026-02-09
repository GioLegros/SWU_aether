local PANEL = {}

function PANEL:Init()
    self.GeneralConfig = self:Add("swu_header")
    local generalConfig = self.GeneralConfig
    generalConfig:SetText("General Config")

    local togglePlanetCollisionRow = self:Add("swu_row")
    togglePlanetCollisionRow:SetText("Enable planet destruction")

    local planetCollisionSwitch = togglePlanetCollisionRow:AddContent("swu_switch")
    planetCollisionSwitch:SetSize(self:GetWide() * 0.08, togglePlanetCollisionRow:GetTall())
    planetCollisionSwitch:SetHeightMultiplier(0.8)
    planetCollisionSwitch:SetConVar("swu_enable_planet_collision")
    planetCollisionSwitch.OnChange = function (_, newValue)
        net.Start("swu_modify_server_settings")
        net.WriteString("swu_enable_planet_collision")
        net.WriteString(newValue and "1" or "0")
        net.SendToServer()
    end


    local hyperspaceSpeedModifierRow = self:Add("swu_row")
    hyperspaceSpeedModifierRow:SetText("Hyperspace speed")

    local hyperspaceSpeedModifier = hyperspaceSpeedModifierRow:AddContent("swu_multiselector")
    hyperspaceSpeedModifier:SetOptions({
        {
            value = 0.25,
            text = "0.25x"
        },
        {
            value = 0.5,
            text = "0.5"
        },
        {
            value = 1,
            text = "1x"
        },
        {
            value = 2,
            text = "2x"
        },
        {
            value = 4,
            text = "4x"
        },
    })
    hyperspaceSpeedModifier:SetConVar("swu_hyperspace_speed_modifier")
    hyperspaceSpeedModifier.OnChange = function (_, newValue)
        net.Start("swu_modify_server_settings")
        net.WriteString("swu_hyperspace_speed_modifier")
        net.WriteString(tostring(newValue))
        net.SendToServer()
    end

    local toggleDeathStar = self:Add("swu_row")
    toggleDeathStar:SetText("Let the Death Star spawn on the Map (requires admin cleanup/restart)")

    local toggleDeathStarSwitch = toggleDeathStar:AddContent("swu_switch")
    toggleDeathStarSwitch:SetSize(self:GetWide() * 0.08, toggleDeathStar:GetTall())
    toggleDeathStarSwitch:SetHeightMultiplier(0.8)
    toggleDeathStarSwitch:SetConVar("swu_enable_deathstar")
    toggleDeathStarSwitch.OnChange = function (_, newValue)
        net.Start("swu_modify_server_settings")
        net.WriteString("swu_enable_deathstar")
        net.WriteString(newValue and "1" or "0")
        net.SendToServer()
    end

end

vgui.Register("swu_serverconfig", PANEL, "swu_basetab")
