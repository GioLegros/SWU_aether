ENT.Type = "anim"
ENT.PrintName = "[SWU] Lever"
ENT.Author = "The Coding Ducks"
ENT.Information = ""
ENT.Category = "[SWU] Universe"

ENT.Spawnable = false

function ENT:Initialize()
    self:SetModel("models/props_wasteland/panel_leverhandle001a.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)

    self.LeverLevelSpeed = 0.3

    self.TotalLeverSpeed = 0
    self.CurrentLeverRatio = 0

    self.StartLeverTime = 0
    self.StartLeverRatio = 0
    self.TargetLeverRatio = 0
    self.LastTargetLeverRatio = 0

    if (CLIENT) then
        self:ClientInitialize()
    end
end

function ENT:Think()
    self.TargetLeverRatio = SWU.Controller:GetTargetShipAcceleration() / 20 / 5

    if (self.TargetLeverRatio ~= self.LastTargetLeverRatio) then
        self.LastTargetLeverRatio = self.TargetLeverRatio
        self.StartLeverTime = CurTime()
        self.StartLeverRatio = self.CurrentLeverRatio

        self.TotalLeverSpeed = math.abs(self.CurrentLeverRatio * 5 - self.TargetLeverRatio * 5) * self.LeverLevelSpeed
    end

    -- TODO: Only move if values have changed and ensure that the movement is still smooth
    local ratio = math.Clamp((CurTime() - self.StartLeverTime) / self.TotalLeverSpeed, 0, 1)
    self.CurrentLeverRatio = Lerp(ratio, self.StartLeverRatio, self.TargetLeverRatio)
    if (isvector(self:GetParent().StartLever) and isvector(self:GetParent().StopLever)) then
        self:SetLocalPos(LerpVector(self.CurrentLeverRatio,
                self:GetParent().StartLever,
                self:GetParent().StopLever))
    end
end
