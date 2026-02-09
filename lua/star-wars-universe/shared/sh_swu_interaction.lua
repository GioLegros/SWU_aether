SWU = SWU or {}
SWU.Util = SWU.Util or {}
SWU.Util.IgnoreEnter = SWU.Util.IgnoreEnter or 0

if SERVER then
    util.AddNetworkString("swu_sendInteractionConfiguration")

    net.Receive("swu_sendInteractionConfiguration", function (_, ply)
        ply.InteractionConfiguration = net.ReadBool()
    end)
end

local function InteractableRealm(realm, callable, ...)
    local args = {...}
    return function (self) if realm then callable(self, unpack(args)) end end
end

function SWU.Util:InteractableServer(callable, ...)
    return InteractableRealm(SERVER, callable, ...)
end
function SWU.Util:InteractableClient(callable, ...)
    return InteractableRealm(CLIENT, callable, ...)
end

local function canInput(ply, hitPos)
    return ply:EyePos():DistToSqr(hitPos) < 5000
end

local function hasInteractionEnabled(ply)
    if SERVER then return ply.InteractionConfiguration end

    return SWU.Configuration:GetConVar("swu_enable_interaction"):GetBool()
end

hook.Add("PlayerButtonDown", "RegisterSWUInteractableBinds", function (ply, code)
    if not hasInteractionEnabled(ply) then return end

    if CLIENT and not IsFirstTimePredicted() then return end

    if CLIENT and (code == KEY_PAD_ENTER or code == KEY_ENTER) and CurTime() - SWU.Util.IgnoreEnter < 2 then SWU.Util.IgnoreEnter = 0 return end -- Required for closing search field of naviation computer using Enter

    local trace = ply:GetEyeTrace()
    local ent = trace.Entity
    if not isentity(ent) or not ent.SWU_Interactable or not canInput(ply, trace.HitPos) then return end

    if isfunction(ent.SWU_UsedKeys[code]) then
        ent.SWU_UsedKeys[code](ent)
    end
end)


if SERVER then return end

hook.Add("PlayerBindPress", "BlockBindsOnSWUInteractable", function(ply, _, _, code)
    if not hasInteractionEnabled(ply) then return end

    local trace = ply:GetEyeTrace()
    local ent = trace.Entity
    if not isentity(ent) or not ent.SWU_Interactable or not canInput(ply, trace.HitPos) then return end

    return isfunction(ent.SWU_UsedKeys[code])
end)
