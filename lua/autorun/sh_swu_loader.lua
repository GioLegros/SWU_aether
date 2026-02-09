SWU = SWU or {}

local function LoadFile(file, dir)
    local filePath = dir .. "/" .. file
    if (file:StartWith("sh_")) then
        if (SERVER) then
            AddCSLuaFile(filePath)
        end
        include(filePath)
    elseif (file:StartWith("cl_")) then
        if (SERVER) then
            AddCSLuaFile(filePath)
        else
            include(filePath)
        end
    elseif (file:StartWith("sv_")) then
        if (SERVER) then
            include(filePath)
        end
    end
end

local function LoadFolder(dir)
    local f, d = file.Find(dir .. "/*", "LUA")

    for i, v in pairs(f) do
        LoadFile(v, dir)
    end

    for i, v in pairs(d) do
        LoadFolder(dir .. "/" .. v)
    end
end

LoadFolder("star-wars-universe")

hook.Run("SWU.Loaded")