AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

SWU = SWU or {}

-- TODO: Add efficient way to change the pos of the button
function ENT:ReceiveNetAction(ply, len, jump)
    if (not IsValid(SWU.Controller) or self:GetParent():GetEstimatedJumpTime() < 5) then return end

    if (jump == nil) then
        jump = net.ReadBool()
    end

    if (jump) then
        self:InitiateJump()
    else
        self:AbortJump()
    end
end

function ENT:InitiateJump()
    if (not self:GetParent():CanJump() or not SWU.Controller:JumpIntoHyperspace()) then return end

    self:SetLeverPos(1)
    self:GetParent():OnHyperspaceJump()
end

function ENT:AbortJump()
    if (not SWU.Controller:ExitHyperspace()) then return end

    self:SetLeverPos(0)
    self:GetParent():OnHyperspaceExit()
    SWU:PersistShipData()
end