include("shared.lua")
local adraw = include("libs/advanceddraw.lua")

SWU = SWU or {}

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self.Scale = 100
end

function ENT:Draw()
    --self:DrawModel()
end

local shipIcon = Material("the-coding-ducks/swu/ship-icon.png")
local planetIcon = Material("the-coding-ducks/swu/planet-icon.png")
local background = Material("the-coding-ducks/swu/map-background.png", "noclamp smooth")

function ENT:DrawShip(centerX, centerY, shipWidth, shipHeight)
    surface.SetDrawColor(255,255,255,255)
    surface.SetMaterial(shipIcon)
    local curShipAngle = SWU.Controller:GetShipAngles().y + 90
    adraw.DrawTexturedRectRotatedPoint(centerX, centerY, shipWidth, shipHeight, curShipAngle * -1, 0,0)
    if (adraw.IsHovering(centerX - (shipWidth * 0.5), centerY - (shipHeight * 0.35), shipWidth - 10, shipHeight - 130)) then
        return {{x = centerX + shipWidth * 0.3, y = centerY, name = "[" .. math.Round(SWU.Controller:GetShipPos().x, 3) .. ":" .. math.Round(SWU.Controller:GetShipPos().y, 3) .. "]"}}
    end
end

function ENT:DrawPlanets(centerX, centerY, planetW, planetH, shipPos, sw, sh)
    local toBeDrawnNames = {}

    for i, planet in ipairs(SWU.Map) do
        local scaleX, scaleY = 250 * self:GetModelScale(), 250 * self:GetModelScale()

        local pos = (planet:GetUniversePos() - shipPos)

        local canvasPosX, canvasPosY = centerX + pos.x * scaleX - planetW * 0.5, centerY + pos.y * -1 * scaleY - planetH * 0.5
        if (canvasPosX < 0 or canvasPosX > sw - planetW
                or canvasPosY < 0 or canvasPosY > sh - planetH) then
            goto con
        end

        local color = SWU.Colors.Default.primary
        if (adraw.IsHovering(canvasPosX, canvasPosY, planetW, planetH)) then
            color = Color(110, 219, 0)
            table.insert(toBeDrawnNames, {x = canvasPosX +  planetW * 0.5, y = canvasPosY + planetH * 0.5, name = planet:GetId()})
        end

        surface.SetMaterial(planetIcon)
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(canvasPosX, canvasPosY, planetW, planetH)

        ::con::
    end

    return toBeDrawnNames
end

function ENT:DrawNames(toBeDrawnNames, planetW)
    for i, v in ipairs(toBeDrawnNames) do
        draw.SimpleTextOutlined(v.name:upper(), SWU.Fonts.PlainMapPlanet, v.x + planetW * 0.6, v.y, SWU.Colors.Default.passive, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 10, Color(24,24,24,255))
    end
end

function ENT:DrawTranslucent()
    if not IsValid(SWU.Controller) then return end

    local min, max = self:GetModelRenderBounds()
    min, max = min * self:GetModelScale(), max * self:GetModelScale()
    local h, w, z = max.x - min.x, max.y - min.y, max.z - min.z
    local startPoint = Vector(-h * 0.5, -w * 0.5, z * 0.5)


    if adraw.Entity3D2D(self, startPoint, Angle(0, 90, 0), 1 / self.Scale) then
        local sw, sh = w * self.Scale, h * self.Scale
        local centerX, centerY = sw * 0.5, sh * 0.5
        local shipPos = SWU.Controller:GetShipPos()

        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(background)
        local scaleX, scaleY = 250 * self:GetModelScale(), 250 * self:GetModelScale()
        local tileSizeX, tileSizeY = sw / (w / 11), sh / (h / 11)
        local gridOffsetX, gridOffsetY = (shipPos.x % tileSizeX) / tileSizeX * scaleX, (shipPos.y % tileSizeY) / tileSizeY * scaleY
        surface.DrawTexturedRectUV(0,0,sw, sh, 0 + gridOffsetX, 0 - gridOffsetY, w / 11 + gridOffsetX, h / 11 - gridOffsetY)

        local shipWidth, shipHeight = shipIcon:Width() * 1.5, shipIcon:Height() * 1.5
        local planetW, planetH = shipWidth * 0.5, shipHeight * 0.5
        local toBeDrawnNames = self:DrawPlanets(centerX, centerY, planetW, planetH, shipPos, sw, sh)

        toBeDrawnNames = table.Add(toBeDrawnNames, self:DrawShip(centerX, centerY, shipWidth, shipHeight))

        self:DrawNames(toBeDrawnNames, planetW)

        adraw.End3D2D()
    end
end