local adraw = include("libs/advanceddraw.lua")

SWU = SWU or {}

surface.CreateFont("SwuChangelogHeader", {
    font = "Saira",
    size = 65,
    weight = 1000,
    antialias = true,
    shadow = false
})
surface.CreateFont("SwuChangelogTitle1", {
    font = "Saira",
    size = 50,
    weight = 1000,
    antialias = true,
    shadow = false
})
surface.CreateFont("SwuChangelogTitle2", {
    font = "Saira",
    size = 37,
    weight = 150,
    underline = true,
    antialias = true,
    shadow = false
})
surface.CreateFont("SwuChangelogText", {
    font = "Saira",
    size = 31,
    weight = 100,
    antialias = true,
    shadow = false
})
surface.CreateFont("SwuChangelogUnderline", {
    font = "Saira",
    size = 25,
    weight = 100,
    antialias = true,
    shadow = false
})

local icons = {
    ["+"] = Material("the-coding-ducks/swu/icons/added.png"),
    ["-"] = Material("the-coding-ducks/swu/icons/removed.png"),
    ["#"] = Material("the-coding-ducks/swu/icons/modified.png"),
}

local discordIcon = Material("the-coding-ducks/swu/icons/discord-icon.png", "smooth")
local steamIcon = Material("the-coding-ducks/swu/icons/steam-icon.png", "smooth")

local function ShouldShowChangelog()
    local updateTable = {
        ["lastSeenVersion"] = 0,
        ["ignore"] = false
    }

    if not file.Exists("star-wars-universe", "DATA") then
        file.CreateDir("star-wars-universe")
    end

    if file.Exists("star-wars-universe/config.json", "DATA") then
        updateTable = util.JSONToTable(file.Read("star-wars-universe/config.json", "DATA"))
    end

    if updateTable["lastSeenVersion"] >= SWU.Version or not istable(SWU.Changelog) or not istable(SWU.Changelog.changes) then
        return false
    end
    return SWU.Configuration:GetConVar("swu_enable_changelog"):GetBool()
end

local function UpdateChangelogConfig(ignore)
    ignore = ignore or false

    file.Write("star-wars-universe/config.json", util.TableToJSON({
        ["lastSeenVersion"] = SWU.Version,
        ["ignore"] = ignore
    }))
end

local COLORS = {
    primary = Color(10,10,10,200),
    background = Color(10,10,10,100),
    success = Color(122, 201, 67),
    dark = Color(26, 26, 26), -- in SWU.Colors.Default.dark
    light = Color(240, 240, 240),
    accent = Color(255, 153, 0) -- in SWU.Colors.Default.accent
}

function SWU:ShowChangelog()
    if (not ShouldShowChangelog()) then return end

    if (IsValid(self.ChangelogFrame)) then
        self.ChangelogFrame:Remove()
    end

    self.ChangelogFrame = vgui.Create("DFrame")
    local frame = self.ChangelogFrame
    frame:SetSize(ScrW() * 0.3, ScrH() * 0.8)
    frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:DockPadding(0,0,0,0)

    frame.Paint = function () end

    local padding = frame:GetWide() * 0.025

    local header = frame:Add("DPanel")
    header:Dock(TOP)
    header:DockPadding(padding, padding, padding, padding)
    header:SetSize(frame:GetWide(), frame:GetTall() * 0.12)
    header.Paint = function()
        adraw.Derma_DrawPanelBlur(header, COLORS.primary)
    end

    local title = header:Add("DLabel")
    title:SetFont("SwuChangelogHeader")
    title:Dock(FILL)
    title:SetText("STAR WARS UNIVERSE")
    title:SetContentAlignment(5)
    title:SetMouseInputEnabled(true)
    title:SizeToContents()
    title:SetColor(COLORS.light)

    local content = frame:Add("DPanel")
    content:Dock(TOP)
    content:DockPadding(padding, padding, padding, padding)
    content:DockMargin(0, frame:GetTall() * 0.0125, 0, frame:GetTall() * 0.0125)
    content:SetSize(frame:GetWide(), frame:GetTall() * 0.735)
    content.Paint = function()
        adraw.Derma_DrawPanelBlur(content, COLORS.background)
    end

    local changelog = content:Add("DLabel")
    changelog:SetFont("SwuChangelogTitle1")
    changelog:SetText("CHANGELOG")
    changelog:SetColor(COLORS.accent)
    changelog:SetContentAlignment(4)
    changelog:Dock(TOP)
    changelog:SizeToContents()

    local version = content:Add("DLabel")
    version:DockMargin(0, frame:GetTall() * 0.0125, 0, frame:GetTall() * 0.0125)
    version:SetFont("SwuChangelogTitle2")
    version:SetText(SWU.Changelog.title)
    version:SetColor(COLORS.light)
    version:SetContentAlignment(4)
    version:Dock(TOP)
    version:SizeToContents()

    for _, change in ipairs(SWU.Changelog.changes) do
        local entry = content:Add("DPanel")
        entry.Paint = function () end
        entry:Dock(TOP)

        local icon = entry:Add("DPanel")
        icon:Dock(LEFT)
        icon:SetSize(icon:GetTall(), icon:GetTall())
        icon:DockMargin(0,0,icon:GetWide() * 0.2,0)
        icon.Paint = function (s, w, h)
            surface.SetDrawColor(COLORS.light)
            surface.SetMaterial(icons[change.type])
            surface.DrawTexturedRect(0,0,h,h)
        end

        local text = entry:Add("DLabel")
        text:SetText(change.text)
        text:Dock(LEFT)
        text:SetColor(COLORS.light)
        text:SetFont("SwuChangelogText")
        text:SizeToContents()
        text:SetWrap(true)
    end

    local links = content:Add("DPanel")
    links:Dock(BOTTOM)
    links:DockPadding(padding * 0.5, padding * 0.5, padding * 0.5, padding * 0.5)
    links:SetSize(frame:GetWide(), frame:GetTall() * 0.05)
    links.Paint = function()
        adraw.Derma_DrawPanelBlur(links, COLORS.background)
    end

    local discord = links:Add("DPanel")
    discord:Dock(RIGHT)
    discord:SetCursor("hand")
    discord:SetSize(frame:GetTall() * 0.05 - padding, frame:GetTall() * 0.05 - padding)
    discord:DockMargin(padding * 0.5,0,0,0)
    discord.Paint = function (s, w, h)
        surface.SetMaterial(discordIcon)
        surface.SetDrawColor(255,255,255)
        if (s:IsHovered()) then
            surface.SetDrawColor(88,101,242)
        end
        surface.DrawTexturedRect(0,0,math.floor(w),math.floor(h))
    end
    discord.OnMousePressed = function ()
        gui.OpenURL("https://discord.gg/TfDnmVB99X")
    end

    local steam = links:Add("DPanel")
    steam:Dock(RIGHT)
    steam:SetCursor("hand")
    steam:SetSize(frame:GetTall() * 0.05 - padding, frame:GetTall() * 0.05 - padding)
    steam.Paint = function (s, w, h)
        surface.SetMaterial(steamIcon)
        surface.SetDrawColor(255,255,255)
        if (s:IsHovered()) then
            surface.SetDrawColor(24,32,53)
        end
        surface.DrawTexturedRect(0,0,math.floor(w),math.floor(h))
    end
    steam.OnMousePressed = function ()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2735358488")
    end

    local footer = frame:Add("DPanel")
    footer:Dock(TOP)
    footer:DockPadding(padding, padding, padding, padding)
    footer:SetSize(frame:GetWide(), frame:GetTall() * 0.12)
    footer.Paint = function()
        adraw.Derma_DrawPanelBlur(footer, COLORS.primary)
    end

    local dontShowAgain = footer:Add("DLabel")
    dontShowAgain:SetFont("SwuChangelogUnderline")
    dontShowAgain:Dock(BOTTOM)
    dontShowAgain:SetText("Never show me the changelog again")
    dontShowAgain:SetContentAlignment(5)
    dontShowAgain:SetMouseInputEnabled(true)
    dontShowAgain:SetCursor("hand")
    dontShowAgain:SizeToContents()
    dontShowAgain.DoClick = function (self)
        LocalPlayer():ConCommand("swu_enable_changelog 0")
        frame:Close()
    end

    local bottomPadding = dontShowAgain:GetTall() * 0.3
    local closeBtn = footer:Add("DButton")
    closeBtn:Dock(BOTTOM)
    closeBtn:SetCursor("hand")
    closeBtn:SetSize(frame:GetWide(), frame:GetTall() * 0.12 - padding * 2 - dontShowAgain:GetTall() - bottomPadding)
    closeBtn:DockMargin(0,0,0,bottomPadding)
    closeBtn:SetText("")
    closeBtn.Paint = function (self, w, h)
        local x, y = 0, 0

        if (closeBtn:IsDown()) then
            local f = 0.002
            x, y = w * f, w * f
            w, h = w * (1 - f * 2), h - w * f * 2
        end

        draw.RoundedBox(0,math.Round(x),math.Round(y),w,h,COLORS.success)

        draw.SimpleText("CONTINUE", "SwuChangelogHeader", w * 0.5, h * 0.5, COLORS.dark, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn.DoClick = function (self)
        UpdateChangelogConfig()
        frame:Close()
    end

end

hook.Add("Think", "SWU_OpenChangelog", function ()
    SWU:ShowChangelog()
    hook.Remove("Think", "SWU_OpenChangelog")
end)
