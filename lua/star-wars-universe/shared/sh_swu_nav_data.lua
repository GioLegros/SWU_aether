SWU.MapData = SWU.MapData or {}
SWU.NavConfig = {
    PricePerParsec = 1.5, -- Prix par unité de distance
    MapScale = 4.0,       -- Zoom par défaut de la map
    JSONPath = "swu/planets.json" -- Assure-toi que ton fichier est bien ici dans garrysmod/data/
}

-- Fonction pour charger les données (Compatible Client et Serveur)
function SWU:LoadMapData(jsonContent)
    if not jsonContent then return end
    
    local rawData = util.JSONToTable(jsonContent)
    if not rawData then return end

    SWU.MapData = {}

    -- On transforme la grille complexe en une liste simple de planètes
    for gridKey, planets in pairs(rawData) do
        for _, planet in ipairs(planets) do
            if planet.type == "planet" or planet.type == "moon" then
                SWU.MapData[planet.name] = {
                    id = planet.id,
                    name = planet.name,
                    pos = Vector(tonumber(planet.pos.x), tonumber(planet.pos.y), tonumber(planet.pos.z or 0)),
                    terrain = planet.terrain,
                    weather = planet.weather,
                    grid = gridKey
                }
            end
        end
    end
    
    local count = table.Count(SWU.MapData)
    print("[SWU Navigation] Carte chargée : " .. count .. " destinations indexées.")
end

-- Calcul de prix (Distance directe uniquement)
function SWU:CalculateTravel(startPosName, targetPosName)
    -- Si on ne trouve pas les planètes par nom, on renvoie 0
    local startNode = SWU.MapData[startPosName]
    local targetNode = SWU.MapData[targetPosName]

    if not startNode or not targetNode then return 0, 0 end

    -- Calcul de distance simple (A vol d'oiseau)
    local dist = startNode.pos:Distance(targetNode.pos)
    local price = math.Round(dist * SWU.NavConfig.PricePerParsec)

    return price, dist
end