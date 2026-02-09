SWU = SWU or {}
local OVersion = 0

hook.Add("PlayerInitialSpawn", "SWU_VersionChecker", function(ply)
    if (OVersion == 0) then
        http.Fetch("https://raw.githubusercontent.com/The-Coding-Ducks/general-info/master/sw-universe-version.json", function(body)
            if body then
                OVersion = tonumber(util.JSONToTable(body).version)
            end
        end, function ()
            print("[SWU] Couldn't fetch the newest version")
        end)
    end

    if ply:IsSuperAdmin() and OVersion > SWU.Version then
        ply:ChatPrint("[SWU] You are using an outdated version of SWU. Please update to the latest version.")
    end
end)