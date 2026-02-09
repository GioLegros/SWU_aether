util.AddNetworkString("swu_search_getPlanetPage")

net.Receive("swu_search_getPlanetPage", function (len, ply)
    local page = net.ReadInt(11)
    local planetsPerPage = net.ReadInt(6)
    local optionalFilter = net.ReadString()

    local planetsOnPage, maxPages = SWU:GetPlanetPage(page, planetsPerPage, optionalFilter)
    net.Start("swu_search_getPlanetPage")
    net.WriteTable(planetsOnPage)
    net.WriteInt(maxPages, 11)
    net.Send(ply)
end)

function SWU:IndexPlanets()
    self.IndexedPlanets = {}

    for _, chunk in pairs(SWU.Universe) do
        for _, planet in ipairs(chunk) do
            table.insert(self.IndexedPlanets, {
                name = planet.name,
                pos = planet.pos
            })
        end
    end

    table.SortByMember(self.IndexedPlanets, "name", true)
end

function SWU:SearchPlanets(keyword)
    local filteredPlanets = {}

    for _, v in ipairs(self.IndexedPlanets) do
        if (string.find(string.lower(v.name), string.lower(keyword))) then
            table.insert(filteredPlanets, v)
        end
    end

    return filteredPlanets
end

function SWU:GetPlanetPage(page, planetsPerPage, filter)
    local planets = {}
    local indexedPlanets = self.IndexedPlanets

    filter = string.Trim(filter)

    if (filter and filter ~= "") then
        indexedPlanets = self:SearchPlanets(filter)
    end

    for i = 1, planetsPerPage do
        table.insert(planets, indexedPlanets[planetsPerPage * (page - 1) + i])
    end

    return planets, math.floor(#indexedPlanets / planetsPerPage + 0.5)
end
