ENT.Type = "anim"
ENT.PrintName = "[SWU] Controller"
ENT.Author = "The Coding Ducks"
ENT.Information = ""
ENT.Category = "[SWU] Universe"

ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Vector", 0, "ShipPos")
    self:NetworkVar("Float", 0, "InternalShipAngleY")
    self:NetworkVar("Float", 1, "InternalTargetShipAngleY")

    self:NetworkVar("Int", 0, "TargetShipAcceleration")
    self:NetworkVar("Int", 1, "CurrentShipAcceleration")
    self:NetworkVar("Int", 2, "Hyperspace")
    self:NetworkVar("Int", 3, "TargetShipAccelerationLimit")

    self:NetworkVar("Bool", 0, "CanJumpIntoHyperspace")

    self:NetworkVarNotify("Hyperspace", function (_,_,old,new)
        hook.Run("SWU.OnHyperspaceStateChange", old, new)
    end)
    self:NetworkVarNotify("TargetShipAcceleration", function (_,_,old,new)
        hook.Run("SWU.OnShipTargetAccelerationChange", old, new)
    end)

    if SERVER then
        self:SetTargetShipAccelerationLimit(100)
        self:SetCanJumpIntoHyperspace(true)
    end
end

function ENT:GetShipAngles()
    return Angle(0,self:GetInternalShipAngleY(),0)
end

function ENT:SetShipAngles(angle)
    self:SetInternalShipAngleY(angle.y)
end

function ENT:GetTargetShipAngles()
    return Angle(0,self:GetInternalTargetShipAngleY(),0)
end

function ENT:SetTargetShipAngles(angle)
    self:SetInternalTargetShipAngleY(angle.y)
end

function ENT:Initialize()
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)

    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")

    self.maxAcceleration = SWU.GlobalConfig.maxAcceleration

    if (SERVER) then
        local shipPos, shipAngle = SWU:ReadShipData()
        self:SetShipPos(shipPos or Vector(-1,0,0))
        self:SetShipAngles(shipAngle or Angle(0,80,0))
        self:SetTargetShipAngles(shipAngle or Angle(0,80,0))

        local controller = ents.FindByClass(self:GetClass())
        for i, v in ipairs(controller) do
            if (v ~= self) then
                v:Remove()
            end
        end

        SWU.Controller = self
    else
        self:SetPredictable(true)

        if (not IsValid(SWU.Controller)) then
            SWU.Controller = self
        end
    end

    self:SetHyperspace(SWU.Hyperspace.OUT)

    self.AccelerationPerPercent = 0.1
    self.LastAccelerationPerPercent = 0.1
    self.TurnSpeedPerDegree = 0.5

    self.TotalAccelerationTime = 0
    self.StartAcceleration = 0
    self.StartAccelerationTime = 0
    self.LastTargetAcceleration = 0

    self.LastTargetShipAngles = Angle()
    self.StartShipAngles = Angle()
    self.StartTurnTime = 0
    self.TotalTurnTime = 0

    if (SERVER) then
        self.Hyperspace = ents.Create("swu_hyperspace")
        self.Hyperspace:SetPos(self:GetPos())
        self.Hyperspace:SetAngles(SWU.config.hyperspace.offsetRotation or ((SWU.config.shipOffsetRotation or Angle(0,180,0)) * -1))
        self.Hyperspace:SetModelScale(SWU.config.hyperspace.scale or 1)
        self.Hyperspace:Spawn()


        net.Receive("swu_setShipPos", function (len, ply)
            if (not ply:IsAdmin() and not ply:IsSuperAdmin()) then return end

            local pos = net.ReadVector()
            local ang = net.ReadAngle()

            self:SetShipPos(pos)
            self:SetTargetShipAngles(ang)
            self:SetShipAngles(ang)
        end)
    end
end

function ENT:Load(config)
    self:SetPos(config.controllerPos)
end

function ENT:AccelerateShip(accelerationPerPercentOverride)
    local targetAcceleration = self:GetTargetShipAcceleration()
    local currentAcceleration = self:GetCurrentShipAcceleration()
    local _accelerationPerPercent = (accelerationPerPercentOverride or self.AccelerationPerPercent)

    if (currentAcceleration == targetAcceleration and _accelerationPerPercent == self.LastAccelerationPerPercent) then return end

    if (targetAcceleration ~= self.LastTargetAcceleration or _accelerationPerPercent ~= self.LastAccelerationPerPercent) then
        self.LastTargetAcceleration = targetAcceleration
        self.StartAcceleration = currentAcceleration
        self.StartAccelerationTime = CurTime()
        self.TotalAccelerationTime = math.abs(targetAcceleration - currentAcceleration) * _accelerationPerPercent
        self.LastAccelerationPerPercent = _accelerationPerPercent
    end

    local startAccelerationTime = self.StartAccelerationTime
    local startAcceleration = self.StartAcceleration

    local ratio = (CurTime() - startAccelerationTime) / self.TotalAccelerationTime
    -- Check if ratio is NaN or inf
    if (ratio ~= ratio) then
        ratio = 1
    end

    local newCurrentAcceleration = Lerp(ratio, startAcceleration, targetAcceleration)

    if (ratio >= 1) then
        newCurrentAcceleration = targetAcceleration
    end
    self:SetCurrentShipAcceleration(newCurrentAcceleration)
end

local function f(t)
    return 1 / (1 * (1 + math.pow(t / (1 - t), -2)))
end

function ENT:TurnShip()
    local currentShipAngles = self:GetShipAngles()
    local targetShipAngles = self:GetTargetShipAngles()
    currentShipAngles:Normalize()
    targetShipAngles:Normalize()

    if (currentShipAngles == targetShipAngles) then return end

    if (targetShipAngles ~= self.LastTargetShipAngles) then
        self.LastTargetShipAngles = targetShipAngles
        self.StartShipAngles = currentShipAngles
        self.StartTurnTime = CurTime()
        local diff = targetShipAngles - currentShipAngles
        diff:Normalize()
        self.TotalTurnTime = math.abs(diff.y) * self.TurnSpeedPerDegree
    end

    local startTurnTime = self.StartTurnTime
    local startShipAngles = self.StartShipAngles

    local ratio = (CurTime() - startTurnTime) / self.TotalTurnTime

    local newCurrentAngles = LerpAngle(f(ratio), startShipAngles, targetShipAngles)

    if (ratio >= 1) then
        newCurrentAngles = targetShipAngles
    end
    self:SetShipAngles(newCurrentAngles)
end

function ENT:CheckCollide()
    if (not SWU.Configuration:GetConVar("swu_enable_planet_collision"):GetBool()) then return end

    for _, objects in pairs(SWU.ActiveChunks or {}) do
        for i, v in ipairs(objects) do
            if (IsValid(v.ent)) then
                v = v.ent
                if (v:GetPos():DistToSqr(self:GetPos()) <= math.pow(SWU.config.collisionRange + v:GetCollisionRange(), 2)) then
                    v:Collide()
                end
            end
        end
    end
end

function ENT:CheckTargetDestination()
    if (not SERVER or not IsValid(SWU.NavigationComputer) or SWU.NavigationComputer:GetTargetPlanet() == nil or SWU.NavigationComputer:GetTargetPlanet() == "") then return end

    local dist = self:GetShipPos():DistToSqr(SWU.NavigationComputer:GetTargetVector())
    local breakTime = 2.1 + 100 * (self.AccelerationPerPercent * 0.005)
    local hyperspaceSpeedModifier = SWU.Configuration:GetConVar("swu_hyperspace_speed_modifier"):GetFloat()
    local externalHyperspaceSpeedModifier = SWU.Configuration:GetConVar("swu_external_hyperspace_speed_modifier"):GetFloat()

    local breakDist = SWU.GlobalConfig.hyperspaceAcceleration.x * breakTime * (1 + (0.25 / hyperspaceSpeedModifier) / externalHyperspaceSpeedModifier)

    if (dist <= breakDist * breakDist) then
        SWU.NavigationComputer.Lever:ReceiveNetAction(nil, nil, false)
    end
end

function ENT:Think()
    local maxAcceleration = self.maxAcceleration
    local accelerationPerPercentOverride
    if (self:GetHyperspace() >= SWU.Hyperspace.TRANSITIONING) then
        maxAcceleration = SWU.GlobalConfig.hyperspaceAcceleration
        accelerationPerPercentOverride = self.AccelerationPerPercent * 0.005
    end

    if (self:GetHyperspace() == SWU.Hyperspace.IN) then
        accelerationPerPercentOverride = self.AccelerationPerPercent * 0.001
        self:CheckTargetDestination()
    end

    self:AccelerateShip(accelerationPerPercentOverride)
    if (self:GetHyperspace() == SWU.Hyperspace.OUT) then
        self:TurnShip()
    end

    if (self:GetHyperspace() ~= SWU.Hyperspace.IN) then
        self:CheckCollide()
    end

    local newPos = SWU:CalculateMovement(self:GetShipPos(), self:GetShipAngles(), self:GetCurrentShipAcceleration() * 0.01, maxAcceleration)
    self:SetShipPos(newPos)

    self:NextThink(CurTime())

    if (self.lastChunk ~= SWU.Util:VectorToChunk(self:GetShipPos())) then
        self:OnChunkChange()
    end

    return true
end

function ENT:GetInternalShipAngles()
    return self:GetShipAngles() + (SWU.config.shipOffsetRotation or Angle())
end

function ENT:OnChunkChange()
    self.lastChunk = SWU.Util:VectorToChunk(self:GetShipPos())

    if (SERVER) then
        SWU:LoadChunks(self:GetShipPos())
    end
end

function ENT:JumpIntoHyperspace()
    if (self:GetHyperspace() ~= SWU.Hyperspace.OUT) then return false end

    self:SetTargetShipAngles(self:GetShipAngles())
    if (SERVER) then
        self.Hyperspace:Jump()
    end
    self:SetTargetShipAcceleration(100)
    return true
end

function ENT:ExitHyperspace()
    if (self:GetHyperspace() ~= SWU.Hyperspace.IN) then return false end

    if (SERVER) then
        self.Hyperspace:Exit(function ()
            self:SetTargetShipAcceleration(0)
        end)
    end
    return true
end

function ENT:IsInHyperspace()
    return self:GetHyperspace() == SWU.Hyperspace.IN
end

function ENT:OnRemove()
    if (SERVER) then
        SWU:PersistShipData()
    end
end
