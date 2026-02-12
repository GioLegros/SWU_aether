local ConsoleConfig = {
    Pos = Vector(929, 4596, 3261), 
    Ang = Angle(0, 180, 0), 
    Model = "models/lordtrilobite/starwars/isd/imp_console_medium03.mdl" -- Le modèle de la console
}

hook.Add("InitPostEntity", "SWU_SpawnNavConsole", function()
    for _, ent in ipairs(ents.FindByClass("swu_nav_console")) do
        ent:Remove()
    end

    local ent = ents.Create("swu_nav_console")
    if not IsValid(ent) then return end

    ent:SetPos(ConsoleConfig.Pos)
    ent:SetAngles(ConsoleConfig.Ang)
    ent:SetModel(ConsoleConfig.Model)
    ent:Spawn()
    ent:Activate()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    print("[SWU] Console de navigation placée en : " .. tostring(ConsoleConfig.Pos))
end)