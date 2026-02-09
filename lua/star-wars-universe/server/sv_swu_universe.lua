SWU = SWU or {}
SWU.Universe = SWU.Universe or {}
SWU.ActiveChunks = SWU.ActiveChunks or {}
SWU.ActiveControls = SWU.ActiveControls or {}

util.AddNetworkString("swu_setShipPos")

function SWU:GetChunks(pos)
    local range = self.GlobalConfig.chunkRange
    local size = self.GlobalConfig.chunkSize

    local chunk = self.Util:ChunkToVector(SWU.Util:VectorToChunk(pos))
    local chunks = {}
    for i = -range, range do
        for j = -range, range do
            local newChunk = self.Util:VectorToChunk(chunk + Vector(size * i, size * j,0))
            chunks[newChunk] = self.Universe[newChunk]
        end
    end

    return chunks
end

function SWU:LoadChunks(pos)
    local newChunks = self:GetChunks(pos)
    local oldChunks = {}

    for k, v in pairs(self.ActiveChunks) do
        if (istable(newChunks[k])) then
            newChunks[k] = nil
        else
            oldChunks[k] = v
        end
    end

    for k, chunk in pairs(newChunks) do
        self:SpawnChunk(chunk)
        self.ActiveChunks[k] = chunk
    end
    for k, chunk in pairs(oldChunks) do
        self:RemoveChunk(chunk)
        self.ActiveChunks[k] = nil
    end
end

function SWU:SpawnChunk(chunk)
    for i, v in ipairs(chunk) do
        if (IsValid(v.ent)) then
            v.ent:Remove()
        end

        local ent = ents.Create("swu_so_" .. v.type)
        if (not IsValid(ent)) then
            goto con
        end

        ent:Spawn()
        ent:Load(v)

        v.ent = ent

        ::con::
    end
end

function SWU:RemoveChunk(chunk)
    for i, v in ipairs(chunk) do
        if (IsValid(v.ent)) then
            v.ent:Remove()
        end
    end
end

function SWU:LoadUniverse()
    self.Universe = {}

    local universe = util.JSONToTable(file.Read("star-wars-universe/server/data/universe.lua", "LUA") or "{}")

    self.Universe = table.DeSanitise(universe)
end

function SWU:SpawnControls()
    for i, v in ipairs(self.config.controls) do
        local control = ents.Create(v.ent)
        control:SetPos(v.pos)
        control:SetAngles(v.ang)
        control:SetModelScale(v.scale or 1)
        control:Spawn()

        table.insert(self.ActiveControls, control)
    end
end

function SWU:BlockMapHyperspace()
    if istable(self.config.blockPos) then
        for _, v in ipairs(self.config.blockPos) do
            for _, v in ipairs(ents.FindInSphere(v, 50)) do
                if (v:GetClass() == "prop_vehicle_prisoner_pod") then
                    v:Remove()
                elseif (v:GetClass() == "func_button") then
                    v:Remove()
                elseif (v:GetClass() == "momentary_rot_button") then
                    v:Remove()
                end
            end
        end
    else
        for _, v in ipairs(ents.FindInSphere(self.config.blockPos, 50)) do
            if (v:GetClass() == "prop_vehicle_prisoner_pod") then
                v:Remove()
            elseif (v:GetClass() == "func_button") then
                v:Remove()
            elseif (v:GetClass() == "momentary_rot_button") then
                v:Remove()
            end
        end
    end
end

function SWU:PersistShipData()
    if (not IsValid(self.Controller)) then return end

    if (not file.Exists("star-wars-universe", "DATA")) then
        file.CreateDir("star-wars-universe")
    end

    if (not file.Exists("star-wars-universe/persistence", "DATA")) then
        file.CreateDir("star-wars-universe/persistence")
    end

    file.Write("star-wars-universe/persistence/" .. game.GetMap() .. ".json", util.TableToJSON({
        ["shipPos"] = self.Controller:GetShipPos():ToTable(),
        ["shipAngle"] = self.Controller:GetShipAngles():ToTable()
    }))
end

function SWU:ReadShipData()
    if (not file.Exists("star-wars-universe", "DATA") or not file.Exists("star-wars-universe/persistence", "DATA")) then
        return
    end

    local persistedData = util.JSONToTable(file.Read("star-wars-universe/persistence/" .. game.GetMap() .. ".json", "DATA") or "{}")

    local shipPos = persistedData["shipPos"]

    if (istable(shipPos)) then
        shipPos = Vector(shipPos[1], shipPos[2], shipPos[3])
    else
        shipPos =  Vector(-1,0,0)
    end

    local shipAngle = persistedData["shipAngle"]

    if (istable(shipAngle)) then
        shipAngle = Angle(shipAngle[1], shipAngle[2], shipAngle[3])
    else
        shipAngle = Angle(0,80,0)
    end

    return shipPos, shipAngle
end

function SWU:ResetChunks()
    for _, chunk in pairs(SWU.ActiveChunks) do
        for _, planet in ipairs(chunk) do
            if (IsValid(planet.ent)) then
                planet.ent:Remove()
            end
        end
    end

    SWU.ActiveChunks = {}
end

hook.Add("ShutDown", "SWU_PersistShipData", function ()
    SWU:PersistShipData()
end)

hook.Add("PreCleanupMap", "SWU_PersistShipData", function ()
    SWU:PersistShipData()
end)

hook.Add("PlayerInitialSpawn", "SWU_FixPlayerNetworking", function (oPly)
    if (player.GetCount() > 1) then return end

    hook.Add("SetupMove", "SWU_CheckWhenPlayerIsHere", function (ply)
        if (oPly == ply) then
            hook.Remove("SetupMove", "SWU_CheckWhenPlayerIsHere")

            SWU:ResetChunks()
            SWU:LoadMap(game.GetMap())
        end
    end)
end)
