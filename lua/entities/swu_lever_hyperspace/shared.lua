ENT.Type = "anim"
ENT.PrintName = "[SWU] Lever"
ENT.Author = "The Coding Ducks"
ENT.Information = ""
ENT.Category = "[SWU] Universe"

ENT.Spawnable = false

SWU = SWU or {}

function ENT:Initialize()
    self:SetModel("models/props_wasteland/panel_leverhandle001a.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)

    self.LeverLevelSpeed = 1.8

    self.StartLeverTime = 0
    self.StartLeverRatio = 0
    self.TargetLeverRatio = 0
    self.LastTargetLeverRatio = 0
    self.CurrentLeverRatio = 0
    self.TotalLeverSpeed = 0

    if (CLIENT) then
        self:ClientInitialize()
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "LeverPos")
end

function ENT:Think()
    self.TargetLeverRatio = self:GetLeverPos()

    if (self.TargetLeverRatio ~= self.LastTargetLeverRatio) then
        self.LastTargetLeverRatio = self.TargetLeverRatio
        self.StartLeverTime = CurTime()
        self.StartLeverRatio = self.CurrentLeverRatio

        self.TotalLeverSpeed = self.LeverLevelSpeed
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