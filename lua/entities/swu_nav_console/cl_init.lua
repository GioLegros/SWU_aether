include("shared.lua")
include("star-wars-universe/shared/sh_swu_nav_data.lua")
include("star-wars-universe/client/cl_swu_nav_interface.lua")

function ENT:Draw()
    self:DrawModel()
end

-- Réception des données
net.Receive("SWU_SendMapJSON", function()
    local len = net.ReadUInt(32)
    local data = net.ReadData(len)
    local json = util.Decompress(data)
    
    if json then
        SWU:LoadMapData(json)
    end
end)

-- Ouverture Menu
net.Receive("SWU_OpenNavInterface", function()
    SWU:OpenNavConsole()
end)