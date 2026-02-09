ENT.Type = "anim"
ENT.PrintName = "[SWU] Controller"
ENT.Author = "The Coding Ducks"
ENT.Information = ""
ENT.Category = "[SWU] Universe"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = false

function ENT:Initialize()
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)

    if (SERVER) then
        self:SetModel(SWU.config.hyperspace.stars)
    end

    if (IsValid(SWU.Controller)) then
        self:SetPos(SWU.Controller:GetPos())
    end
    self:SetNoDraw(true)
end

function ENT:Load(config)
    self:SetPos(config.controllerPos)
end

function ENT:Think()
    self:NextThink(CurTime())
    return true
end

function ENT:Jump()
    if (SWU.Controller:GetHyperspace() ~= SWU.Hyperspace.OUT) then return end

    self:SetModel(SWU.config.hyperspace.stars)
    self:SetNoDraw(false)

    local id, duration = self:LookupSequence("in")
    self:ResetSequence(id)
    SWU.Controller:SetHyperspace(SWU.Hyperspace.TRANSITIONING)

    timer.Simple(duration - 0.1, function ()
        if (not IsValid(self)) then return end
        SWU.Controller:SetHyperspace(SWU.Hyperspace.IN)
        self:SetModel(SWU.config.hyperspace.tunnel)
        self:SetSkin(1)

        timer.Simple(0.2, function ()
            if (not IsValid(self)) then return end
            self:SetSkin(0)
        end)
    end)
end

function ENT:Exit(onExit)
    if (SWU.Controller:GetHyperspace() ~= SWU.Hyperspace.IN) then return end

    self:SetNoDraw(false)
    self:SetModel(SWU.config.hyperspace.tunnel)
    self:SetSkin(1)
    SWU.Controller:SetHyperspace(SWU.Hyperspace.TRANSITIONING)

    timer.Simple(0.2, function ()
        if (not IsValid(self)) then return end
        self:SetModel(SWU.config.hyperspace.stars)
        local id, duration = self:LookupSequence("out")
        self:ResetSequence(id)

        timer.Simple(duration - 0.1, function ()
            if (not IsValid(self)) then return end

            SWU.Controller:SetHyperspace(SWU.Hyperspace.OUT)

            if (isfunction(onExit)) then
                onExit()
            end
            self:SetNoDraw(true)
        end)
    end)
end
