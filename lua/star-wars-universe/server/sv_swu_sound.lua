local EXIT = "swu/hyperspace_exit.wav"
local LOOP = "swu/hyperspace_loop.wav"
local ENTER = "swu/hyperspace_enter.wav"

local sound_cache = {}

local maxPitch, hyperspaceMaxPitch, minPitch = 90, 130, 50
local function ModifyCruisingSound(speed)
    if not sound_cache[LOOP] then
        local filter = RecipientFilter()
        filter:AddAllPlayers()
        sound_cache[LOOP] = CreateSound(SWU.Controller, LOOP, filter)
        sound_cache[LOOP]:SetSoundLevel(0)
    end

    local sound = sound_cache[LOOP]

    local max = SWU.Controller:GetHyperspace() ~= SWU.Hyperspace.OUT and hyperspaceMaxPitch or maxPitch
    local pitch = minPitch + (max - minPitch) * (speed / 100)
    sound:ChangePitch(pitch, math.floor(SWU.Controller.TotalAccelerationTime))

    return sound
end

hook.Add("SWU.OnShipTargetAccelerationChange", "SWU_SublightSoundManagement", function (old, new)
    local hyperspaceStatus = SWU.Controller:GetHyperspace()

    if hyperspaceStatus ~= SWU.Hyperspace.OUT then return end

    local sound = ModifyCruisingSound(new)

    if new > 0 and hyperspaceStatus == SWU.Hyperspace.OUT and not sound:IsPlaying() then
        sound:Play()
        ModifyCruisingSound(new)
    end

    if new == 0 then
        sound:FadeOut(SWU.Controller.TotalAccelerationTime)
    end
end)

hook.Add("SWU.OnHyperspaceStateChange", "SWU_HyperspaceSoundManagement", function (old, new)
    local sound
    if old == SWU.Hyperspace.IN and new == SWU.Hyperspace.TRANSITIONING then
        sound = EXIT
    elseif old == SWU.Hyperspace.TRANSITIONING and new == SWU.Hyperspace.IN then
        sound = LOOP
    elseif old == SWU.Hyperspace.OUT and new == SWU.Hyperspace.TRANSITIONING then
        sound = ENTER
    end

    if not sound then return end

    if not sound_cache[sound] then
        local filter = RecipientFilter()
        filter:AddAllPlayers()
        sound_cache[sound] = CreateSound(SWU.Controller, sound, filter)
        sound_cache[sound]:SetSoundLevel(0)
    end

    if sound ~= LOOP then
        sound_cache[sound]:Stop()
    end
    sound_cache[sound]:Play()
    ModifyCruisingSound(SWU.Controller:GetTargetShipAcceleration())
end)
