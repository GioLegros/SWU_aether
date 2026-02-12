AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

-- On s'assure de charger la logique partagée
include("star-wars-universe/shared/sh_swu_nav_data.lua")

util.AddNetworkString("SWU_OpenNavInterface")
util.AddNetworkString("SWU_SendMapJSON")
util.AddNetworkString("SWU_RequestHyperjump")

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    -- Chargement initial des données serveur
    local json = file.Read(SWU.NavConfig.JSONPath, "DATA")
    if json then
        SWU:LoadMapData(json)
    else
        print("[SWU Erreur] Fichier " .. SWU.NavConfig.JSONPath .. " introuvable !")
    end
end

function ENT:Use(ply)
    if not IsValid(ply) then return end

    if not SWU.RawUniverseJSON then 
        print("[SWU Erreur] Données de l'univers non chargées !")
        return 
    end

    local compressed = util.Compress(SWU.RawUniverseJSON)
    
    net.Start("SWU_SendMapJSON")
    net.WriteUInt(#compressed, 32)
    net.WriteData(compressed, #compressed)
    net.Send(ply)

    net.Start("SWU_OpenNavInterface")
    net.Send(ply)
end

-- Réception de la demande de saut du client
net.Receive("SWU_RequestHyperjump", function(len, ply)
    local targetPlanet = net.ReadString()
    local targetData = SWU.MapData[targetPlanet]

    if targetData and IsValid(SWU.Controller) then
        -- ICI : On connecte avec ton controller existant !
        -- On définit la destination sur le controller principal
        
        -- On doit convertir le vector de la map en vector utilisable par le controller
        -- Assure-toi que SWU.Controller a bien les méthodes SetShipPos ou similaire
        -- Ceci est un exemple générique basé sur ton shared.lua précédent :
        
        -- On simule le changement de destination
        -- Tu devras peut-être adapter cette partie selon comment ton swu_controller gère la cible
        
        print("Saut demandé vers : " .. targetPlanet)
        
        -- Exemple d'action : Définir la cible pour l'ordinateur de navigation s'il existe
        if IsValid(SWU.NavigationComputer) then
             -- SWU.NavigationComputer:SetTargetPlanet(targetPlanet) -- Si cette fonction existe
        end
        
        -- Ou bouger directement le controller (mode debug)
        -- SWU.Controller:SetShipPos(targetData.pos) 
        
        ply:ChatPrint("Coordonnées reçues. Calcul de l'hypersaut vers " .. targetPlanet .. "...")
    end
end)