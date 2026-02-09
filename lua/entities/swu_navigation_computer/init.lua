AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/lordtrilobite/starwars/isd/imp_console_large01.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:GetPhysicsObject():EnableMotion(false)
    self:SetSubMaterial(3, "the-coding-ducks/swu/screens/planetlist")
    self:SetSubMaterial(1, "the-coding-ducks/swu/screens/planetlist")
    self:SetSubMaterial(2, "the-coding-ducks/swu/screens/planetlist")

    self:SharedInitialize()

    self:LoadPlanets()

    self.PlanetsPerPage = 5
    self:SetCurPage(1)
    self:SetPages(math.ceil(#self.Planets / self.PlanetsPerPage))
    self:UpdatePageValue()

    self.Lever = ents.Create("swu_lever_hyperspace")
    self.Lever:SetParent(self)
    self.Lever:SetLocalPos(self.StartLever)
    self.Lever:SetModelScale(0.5)
    self.Lever:SetAngles(self:GetAngles())
    self.Lever:Spawn()

    table.insert(SWU.Terminals, self)

    hook.Add("SWU_RecalculateFlightTime", "SWU_NavigationComputerRecalculateFlightTime" .. self:GetCreationID(), function (oldAcceleration, newAcceleration)
        local dist = SWU.Controller:GetShipPos():Distance(self:GetTargetVector())

        if (self:GetJumpStartTime() > 0) then
            self:SetJumpStartTime(CurTime())
        end
        self:SetProgress(-1)
        self:SetEstimatedJumpTime(dist / newAcceleration.x)
    end)
end

function ENT:LoadPlanets()
    self.Planets = {}

    for _, chunk in pairs(SWU.Universe) do
        for _, planet in ipairs(chunk) do
            table.insert(self.Planets, {
                name = planet.name,
                pos = planet.pos
            })
        end
    end

    table.SortByMember(self.Planets, "name", true)

    self.allPlanets = self.Planets
end

-- Action 1 == SwitchPage
-- Action 2 == SelectPlanet
-- Action 3 == UpdatePageValue
function ENT:ReceiveNetAction()
    if (not IsValid(SWU.Controller)) then return end

    local action = net.ReadUInt(3)
    if (action == 1) then
        self:SwitchPage(net.ReadInt(3))
    elseif (action == 2) then
        if (SWU.Controller:GetHyperspace() ~= SWU.Hyperspace.OUT or self:GetLoading()) then return end
        self:SelectPlanet(net.ReadString())
    elseif (action == 3) then
        self:SetSearchTerm(net.ReadString())
        self:FilterPlanets()
    end
end

function ENT:SwitchPage(direction)
    local curPage = self:GetCurPage()
    if (direction < 0) then
        if (curPage == 1) then return end
        self:SetCurPage(curPage - 1)
    else
        if (curPage == self:GetPages()) then return end
        self:SetCurPage(curPage + 1)
    end

    self:UpdatePageValue()
end

function ENT:SelectPlanet(planetName)
    local planet
    for _, v in ipairs(self:GetCurrentPlanets()) do
        if (v.name == planetName) then
            planet = v
            break
        end
    end

    if (not istable(planet)) then
        return
    end

    self:SetSubMaterial(2, "the-coding-ducks/swu/screens/planetlist")
    self.TargetPlanet = planet
    local targetAngle = Angle(0,360,0) - (planet.pos - SWU.Controller:GetShipPos()):Angle()
    local dist = SWU.Controller:GetShipPos():Distance(planet.pos)

    self:SetEstimatedJumpTime(dist / SWU.GlobalConfig.hyperspaceAcceleration.x)
    self:SetJumpStartTime(0)

    self:SetProgress(-1)
    self:SetLoading(true)
    self:SetTargetPlanet(planetName)
    timer.Simple(self.ProgressCalculationDuration, function ()
        if (IsValid(self)) then
            self:SetSubMaterial(2, "the-coding-ducks/swu/screens/jump-screen")
        end
    end)
    self:SetTargetAngle(targetAngle)
    self:SetTargetVector(planet.pos)
end

function ENT:GetCurrentPlanets()
    local planets = {}

    for i = 1, self.PlanetsPerPage do
        table.insert(planets, self.Planets[self.PlanetsPerPage * (self:GetCurPage() - 1) + i])
    end

    return planets
end

function ENT:UpdatePageValue()
    local planetNames = {}

    for _, v in ipairs(self:GetCurrentPlanets()) do
        table.insert(planetNames, v.name)
    end

    self:SetPlanets(table.concat(planetNames, "[=]"))
end

function ENT:FilterPlanets()
    self.Planets = {}

    for _, v in ipairs(self.allPlanets) do
        if (string.find(string.lower(v.name), string.lower(self:GetSearchTerm()))) then
            table.insert(self.Planets, v)
        end
    end

    self:SetCurPage(1)
    self:SetPages(math.ceil(#self.Planets / self.PlanetsPerPage))
    self:UpdatePageValue()
end

function ENT:CanJump()
    return not self:GetLoading() and istable(self.TargetPlanet) and isangle(self:GetTargetAngle()) and self:GetEstimatedJumpTime() > 0 and self:GetJumpStartTime() <= 0 and SWU.Controller:GetCanJumpIntoHyperspace()
end

function ENT:OnHyperspaceJump()
    self:SetJumpStartTime(CurTime())
end

function ENT:OnHyperspaceExit()
    self.TargetPlanet = nil
    self:SetJumpStartTime(0)
    self:SetEstimatedJumpTime(0)
    self:SetSubMaterial(2, "the-coding-ducks/swu/screens/planetlist")
end

function ENT:OnRemove()
    hook.Remove("SWU_RecalculateFlightTime", "SWU_NavigationComputerRecalculateFlightTime" .. self:GetCreationID())
end