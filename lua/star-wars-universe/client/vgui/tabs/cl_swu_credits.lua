local PANEL = {}

local steamIcon = Material("the-coding-ducks/swu/icons/steam-icon.png", "smooth")

local credits = {
    {
        title = "Programming",
        users = {
            {
                name = "DolUnity",
                steam = "https://steamcommunity.com/id/dolunity/"
            },
            {
                name = "Luiggi33",
                steam = "https://steamcommunity.com/id/Luiggi33/"
            },
        }
    },
    {
        title = "Modelling",
        users = {
            {
                name = "Mig",
                steam = "https://steamcommunity.com/id/mig4/"
            }
        }
    },
    {
        title = "Special Thanks",
        users = {
            {
                name = "Letha",
                steam = "https://steamcommunity.com/profiles/76561198874598078/"
            },
            {
                name = "Rufiinix",
                steam = "https://steamcommunity.com/profiles/76561198076909400"
            }
        }
    },
}

function PANEL:Init()
    for _, category in pairs(credits) do
        local header = self:Add("swu_header")
        header:SetText(category.title)

        for _, user in ipairs(category.users) do
            local row = self:Add("swu_row")
            row:SetText(user.name)

            local steamLink = row:AddContent("swu_icon")
            steamLink:SetPaintBackground(false)
            steamLink:SetMaterial(steamIcon)
            steamLink:SetColor(Color(255,255,255))
            steamLink:SetOnClick(function () gui.OpenURL(user.steam) end, Color(24,32,53), Color(46,62,102))
            steamLink:SetPadding(row:GetTall() * 0.1)
            steamLink:SetSize(row:GetTall(),row:GetTall() * 0.8)
        end
    end

end

vgui.Register("swu_credits", PANEL, "swu_basetab")
