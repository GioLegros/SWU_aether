SWU.Configuration = SWU.Configuration or {}

SWU.Configuration.ConVars = {
    ["swu_enable_planet_collision"] = CreateConVar("swu_enable_planet_collision", 1, FCVAR_ARCHIVE, "Enables or disables that a planet can get destroyed by flying into it", 0, 1),
    ["swu_hyperspace_speed_modifier"] = CreateConVar("swu_hyperspace_speed_modifier", 1, FCVAR_ARCHIVE, "The number the hyperspace speed should be multiplied with", 0, 10),
    ["swu_enable_deathstar"] = CreateConVar("swu_enable_deathstar", 0, FCVAR_ARCHIVE, "Should there be the death star in the galaxy", 0, 1),
    ["swu_enable_changelog"] = CreateClientConVar("swu_enable_changelog", 1, true, false, "Should the changelog be shown to you", 0, 1),
    ["swu_enable_interaction"] = CreateClientConVar("swu_enable_interaction", 1, true, false, "Should keyboard interaction with console be activated", 0, 1),
    ["swu_external_hyperspace_speed_modifier"] = CreateConVar("swu_external_hyperspace_speed_modifier", 1, FCVAR_ARCHIVE, "The number the hyperspace speed should be multiplied with, used by external addons", 0, 10),
}

if (CLIENT) then
    SWU.Configuration.Tabs = {}

    function SWU.Configuration:RegisterTab(priority, tab)
        if (not isnumber(priority)) then return end
        self.Tabs[priority] = tab
    end

    function SWU.Configuration:GetTabs()
        local tabs = {}

        for i, v in pairs(self.Tabs) do
            if (not isfunction(v.shouldShow) or v.shouldShow()) then
                table.insert(tabs, v)
            end
        end

        return tabs
    end

    function SWU.Configuration:Open()
        if (IsValid(self.Frame)) then
            self.Frame:Remove()
        end

        self.Frame = vgui.Create("swu_configruationframe")
    end

    concommand.Add("swu_open_configuration", function ()
        SWU.Configuration:Open()
    end)

    list.Set("DesktopWindows", "SwuConfigurations", {
        title = "[SWU] Config",
        icon = "the-coding-ducks/swu/icons/swu-icon.png",
        init = function(icon, window)
            SWU.Configuration:Open()
        end
    })

    SWU.Configuration:RegisterTab(1, {
        title = "Server Config",
        shouldShow = function ()
            return LocalPlayer():IsSuperAdmin()
        end,
        open = function (content)
            content:Add("swu_serverconfig")
        end
    })

    SWU.Configuration:RegisterTab(2, {
        title = "Ship Position",
        shouldShow = function ()
            return LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()
        end,
        open = function (content)
            content:Add("swu_position")
        end
    })

    SWU.Configuration:RegisterTab(3, {
        title = "Client Config",
        open = function (content)
            content:Add("swu_clientconfig")
        end
    })

    SWU.Configuration:RegisterTab(100, {
        title = "Credits",
        open = function (content)
            content:Add("swu_credits")
        end
    })
else
    util.AddNetworkString("swu_modify_server_settings")

    net.Receive("swu_modify_server_settings", function (len, ply)
        if (not ply:IsSuperAdmin()) then return end

        local conVarName = net.ReadString()
        local value = net.ReadString()

        local conVar = SWU.Configuration:GetConVar(conVarName)
        if (not conVar) then return end

        local oldValue = conVar:GetString()
        conVar:SetString(value)

        hook.Run("SWU_OnConfigurationChange", conVarName, oldValue, value)
    end)
end

function SWU.Configuration:GetConVar(cvar)
    return SWU.Configuration.ConVars[cvar] or false
end
