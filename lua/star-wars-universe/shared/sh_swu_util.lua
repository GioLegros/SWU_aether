SWU = SWU or {}
SWU.Util = SWU.Util or {}

local function VectorFromTable(tbl)
    return Vector(tbl[1], tbl[2], tbl[3])
end

local function VectorCenter(min, max)
    return Vector((min.x + max.x) * 0.5, (min.y + max.y) * 0.5, (min.z + max.z) * 0.5)
end

function SWU.Util:MeasureSkybox(pos)
    local lineLength = 10240

    local min, max = {}, {}
    for i = 1, 3 do
        for j = 1, 2 do
            local modifier = 1
            if (j == 1) then
                modifier = -1
            end

            local endpos = pos:ToTable()
            endpos[i] = endpos[i] + lineLength * modifier
            local trace = {
                start = pos,
                endpos = VectorFromTable(endpos),
                filter = function (ent) return false end
            }
            trace = util.TraceLine(trace)

            if (j == 1) then
                min[i] = trace.HitPos:ToTable()[i]
            else
                max[i] = trace.HitPos:ToTable()[i]
            end
        end
    end

    min, max = VectorFromTable(min), VectorFromTable(max)
    return min, max, VectorCenter(min, max)
end

local function disableFog()
    render.FogMode(MATERIAL_FOG_LINEAR)
    render.FogMaxDensity(0)
    return true
end

function SWU.Util:DisableFog()
    hook.Add("SetupWorldFog", "SWU_DisableWorldFog", disableFog)
    hook.Add("SetupSkyboxFog", "SWU_DisableSkyboxFog", disableFog)
end

function SWU.Util:DisableSun()
    local list = ents.FindByClass("env_sun")
    if (#list > 0) then
        local sun = list[1]
        sun:SetKeyValue("size", 0)
        sun:SetKeyValue("overlaysize", 0)
    end
end

local function chunkFloor(n)
    local f = (n - (n % SWU.GlobalConfig.chunkSize)) / SWU.GlobalConfig.chunkSize
    if (f == -0) then
        f = 0
    end
    return f
end

function SWU.Util:ChunkToVector(chunk)
    local s = string.Split(chunk, ":")
    return Vector(s[1] * SWU.GlobalConfig.chunkSize, s[2] * SWU.GlobalConfig.chunkSize, 0)
end

function SWU.Util:VectorToChunk(vector)
    return chunkFloor(vector.x) .. ":" .. chunkFloor(vector.y)
end

function SWU:CalculateWorldPos(universePos)
    local shipWorldPos = self.Controller:GetPos()
    local shipPos = self.Controller:GetShipPos()
    local shipAngles = self.Controller:GetInternalShipAngles()
    local scale = self.config.scale or 1

    local worldPos = (universePos - shipPos) * scale
    worldPos:Rotate(shipAngles)
    worldPos = shipWorldPos + worldPos

    local absoluteWorldPos = Vector(worldPos)
    absoluteWorldPos:Rotate(-shipAngles)
    return worldPos, absoluteWorldPos
end

function SWU:CalculateMovement(currentPos, currentAngle, currentPercentAcceleration, maxAcceleration)
    return currentPos + (maxAcceleration * FrameTime() * currentPercentAcceleration * currentAngle:Forward() * Vector(1,-1,0))
end