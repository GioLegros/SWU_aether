-- lua/star-wars-universe/client/cl_swu_nav_interface.lua

local COL_BG = Color(20, 20, 30, 250)
local COL_TAB_ACTIVE = Color(0, 150, 255)
local COL_PLANET = Color(200, 200, 200, 150)
local COL_PLANET_HOVER = Color(255, 200, 0, 255)
local COL_SELECTED = Color(50, 255, 50, 255)

function SWU:OpenNavConsole()
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.85, ScrH() * 0.85)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Système de Navigation Galactique")
    frame:ShowCloseButton(true)
    frame.Paint = function(s,w,h) 
        draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0,240)) 
        surface.SetDrawColor(COL_TAB_ACTIVE)
        surface.DrawOutlinedRect(0,0,w,h)
    end

    -- Gestion des onglets
    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)
    sheet:DockMargin(5,5,5,5)

    -- === ONGLET 1 : NAVIGATION ===
    local navPanel = vgui.Create("DPanel", sheet)
    navPanel.Paint = function(s,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,15)) end
    
    self:BuildMapInterface(navPanel) -- Appel de la fonction de construction de map
    sheet:AddSheet("Carte Stellaire", navPanel, "icon16/world.png")

    -- === ONGLET 2 : DIAGNOSTIC (Exemple) ===
    local diagPanel = vgui.Create("DPanel", sheet)
    diagPanel.Paint = function(s,w,h) 
        draw.SimpleText("Systèmes nominaux.", "DermaLarge", w/2, h/2, color_white, 1, 1) 
    end
    sheet:AddSheet("Diagnostic Vaisseau", diagPanel, "icon16/wrench.png")
end

function SWU:BuildMapInterface(parent)
    local zoom = SWU.NavConfig.MapScale
    local panX, panY = parent:GetWide()/2, parent:GetTall()/2
    local dragging = false
    local lastMouseX, lastMouseY = 0, 0
    local selectedPlanet = nil
    
    -- Récupération de la position actuelle
    -- Ici, on suppose que le controlleur a une variable "ShipPos" ou on prend une valeur par défaut
    local currentPosName = "Coruscant" 
    
    -- Essayer de trouver la position réelle si le controlleur existe
    if IsValid(SWU.Controller) and SWU.Controller.GetShipPos then
        -- Logique simplifiée : trouver la planète la plus proche des coordonnées actuelles du controlleur
        local shipVec = SWU.Controller:GetShipPos()
        local bestDist = 9999999
        for name, data in pairs(SWU.MapData) do
            local d = data.pos:Distance(shipVec)
            if d < bestDist then
                bestDist = d
                currentPosName = name
            end
        end
    end

    -- Panneau d'informations (Gauche)
    local pLeft = vgui.Create("DPanel", parent)
    pLeft:Dock(LEFT)
    pLeft:SetWide(300)
    pLeft.Paint = function(s,w,h) surface.SetDrawColor(30,30,35) surface.DrawRect(0,0,w,h) end

    local infoLabel = vgui.Create("DLabel", pLeft)
    infoLabel:Dock(TOP)
    infoLabel:SetTall(200)
    infoLabel:SetContentAlignment(7)
    infoLabel:DockMargin(10,10,10,10)
    infoLabel:SetFont("DermaDefaultBold")
    infoLabel:SetText("Position actuelle : " .. currentPosName .. "\n\nSélectionnez une destination sur la carte...")
    infoLabel:SetWrap(true)

    -- Panneau Carte (Droite)
    local map = vgui.Create("DPanel", parent)
    map:Dock(FILL)
    
    local function ToScreen(vecPos)
        -- Inversion Y pour correspondre aux repères habituels des maps 2D
        return panX + (vecPos.x * zoom), panY + (vecPos.y * -1 * zoom)
    end

    map.OnMousePressed = function(s, code)
        if code == MOUSE_LEFT then
            local mx, my = s:LocalCursorPos()
            local clicked = false
            
            for name, data in pairs(SWU.MapData) do
                local sx, sy = ToScreen(data.pos)
                if math.abs(mx-sx) < 10 and math.abs(my-sy) < 10 then
                    selectedPlanet = name
                    clicked = true
                    
                    local price, dist = SWU:CalculateTravel(currentPosName, name)
                    
                    infoLabel:SetText(
                        "DÉPART : " .. currentPosName .. "\n" ..
                        "ARRIVÉE : " .. data.name .. "\n" ..
                        "SECTEUR : " .. (data.grid or "Inconnu") .. "\n" ..
                        "TYPE : " .. (string.Split(data.terrain, "/")[3] or "Inconnu") .. "\n\n" ..
                        "DISTANCE : " .. math.Round(dist, 1) .. " Parsecs\n" ..
                        "COÛT : " .. price .. " Crédits"
                    )
                    break
                end
            end
            
            if not clicked then dragging = true; s:MouseCapture(true); lastMouseX, lastMouseY = input.GetCursorPos() end
        else
            dragging = true; s:MouseCapture(true); lastMouseX, lastMouseY = input.GetCursorPos()
        end
    end

    map.OnMouseReleased = function(s) dragging = false; s:MouseCapture(false) end
    map.OnCursorMoved = function(s)
        if dragging then
            local cx, cy = input.GetCursorPos()
            panX = panX + (cx - lastMouseX)
            panY = panY + (cy - lastMouseY)
            lastMouseX, lastMouseY = cx, cy
        end
    end
    map.OnMouseWheeled = function(s, d) zoom = math.Clamp(zoom + (d * 0.5), 1, 30) end

    map.Paint = function(s, w, h)
        draw.RoundedBox(0,0,0,w,h, Color(5, 5, 10))
        
        -- Grille
        surface.SetDrawColor(255, 255, 255, 5)
        local gs = 50 * zoom
        local ox, oy = panX % gs, panY % gs
        for i = 0, w / gs + 1 do surface.DrawLine(ox + i * gs, 0, ox + i * gs, h) end
        for i = 0, h / gs + 1 do surface.DrawLine(0, oy + i * gs, w, oy + i * gs) end

        -- Ligne de trajet
        if selectedPlanet and SWU.MapData[currentPosName] and SWU.MapData[selectedPlanet] then
            local p1x, p1y = ToScreen(SWU.MapData[currentPosName].pos)
            local p2x, p2y = ToScreen(SWU.MapData[selectedPlanet].pos)
            surface.SetDrawColor(COL_SELECTED)
            surface.DrawLine(p1x, p1y, p2x, p2y)
        end

        -- Planètes
        for name, data in pairs(SWU.MapData) do
            local sx, sy = ToScreen(data.pos)
            -- Culling simple
            if sx < -50 or sx > w + 50 or sy < -50 or sy > h + 50 then goto skip end

            local size = 6 + (zoom * 0.2)
            local col = (name == selectedPlanet) and COL_SELECTED or COL_PLANET
            if name == currentPosName then col = Color(0,255,255) end

            draw.RoundedBox(size, sx - size/2, sy - size/2, size, size, col)
            
            if zoom > 3 or name == selectedPlanet or name == currentPosName then
                draw.SimpleText(data.name, "DermaDefault", sx + size, sy - size, Color(255,255,255,150))
            end
            ::skip::
        end
    end
end