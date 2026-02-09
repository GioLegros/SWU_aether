SWU = SWU or {}
SWU.ActiveTeleports = SWU.ActiveTeleports or {}

function SWU:SpawnTeleports()
    if (not istable(self.config.teleports) or CLIENT) then return end

    for i, v in ipairs(self.ActiveTeleports) do
        if (IsValid(v)) then
            v:Remove()
        end
    end

    self.ActiveTeleports = {}
    for i, v in ipairs(self.config.teleports) do
        local teleport = ents.Create("swu_teleporter")
        teleport:Load(v)
        teleport:Spawn()

        table.insert(self.ActiveTeleports, teleport)
    end
end

function SWU:OnTeleporterTouch(entity, tDir)
    if (not IsValid(entity)) then return end

    if (entity:IsPlayer() and entity:InVehicle()) then return end

    local shipPos = SWU.Controller:GetShipPos()
    local shipAngles = SWU.Controller:GetInternalShipAngles().y % 360
    for _, chunk in pairs(SWU.ActiveChunks) do
        for _, planet in ipairs(chunk) do
            local _pDir = math.AngleDifference((planet.pos - shipPos):Angle().y, shipAngles)
            if (math.abs(math.AngleDifference(_pDir, tDir)) <= 60 and shipPos:DistToSqr(planet.pos) < 5) then
                SWU:TeleportEntityToPlanet(entity, planet)
                return
            end
        end
    end
end

function SWU:TeleportEntityToPlanet(entity, planet)
    if (not istable(SWU.config.teleportLocations)) then return end

    local trimmedTerrain = string.gsub(planet.terrain, "terrain_%d*$", "")

    local teleportLocation = SWU.config.teleportLocations[trimmedTerrain]

    if (not istable(teleportLocation)) then return end

    entity:SetPos(teleportLocation.pos)
    entity:SetAngles(teleportLocation.angle)

    if (entity:IsPlayer()) then
        entity:SetEyeAngles(teleportLocation.angle)
    end

    if (entity.LFS and IsValid(entity:GetDriver())) then
        entity:GetDriver():SetEyeAngles(teleportLocation.angle)
    end
end
