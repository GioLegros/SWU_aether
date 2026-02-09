ENT.Type        = "anim"
ENT.PrintName   = "[SWU] Navigation Computer"
ENT.Author      = "The Coding Ducks"
ENT.Information = ""
ENT.Category    = "[SWU] Universe"

ENT.Spawnable	= false

ENT.SWU_Interactable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Pages")
    self:NetworkVar("Int", 1, "CurPage")

    self:NetworkVar("Float", 0, "Progress")
    self:NetworkVar("Float", 1, "JumpStartTime")
    self:NetworkVar("Float", 2, "EstimatedJumpTime")
    self:NetworkVar("Bool", 0, "Loading")

    self:NetworkVar("String", 0, "Planets")
    self:NetworkVar("String", 1, "TargetPlanet")
    self:NetworkVar("String", 2, "SearchTerm")

    self:NetworkVar("Angle", 0, "TargetAngle")
    self:NetworkVar("Vector", 0, "TargetVector")
end

function ENT:SetupUsedKeys()
    self.SWU_UsedKeys = {
        [KEY_PAD_ENTER] = SWU.Util:InteractableClient(self.OpenSearchBar),
        [KEY_ENTER] = SWU.Util:InteractableClient(self.OpenSearchBar),
        [KEY_LEFT] = SWU.Util:InteractableServer(self.SwitchPage, -1),
        [KEY_RIGHT] = SWU.Util:InteractableServer(self.SwitchPage, 1),
    }
end

function ENT:SharedInitialize()
    self.ProgressCalculationDuration = 5
    self.ProgressStart = 0

    self.StartLever = Vector(22, -3.6, 28)
    self.StopLever = Vector(13, -3.6, 30)

    SWU.NavigationComputer = self

    self:SetupUsedKeys()
end

function ENT:Think()
    if (self:GetLoading()) then
        if (self:GetProgress() == -1) then
            self.ProgressStart = CurTime()
        end

        local progress = math.min((CurTime() - self.ProgressStart) / self.ProgressCalculationDuration, 1)
        self:SetProgress(progress)
        if (progress >= 1) then
            self:SetLoading(false)
        end
    end

    if (CLIENT) then
        self:NextThink(CurTime())
        return true
    end
end
