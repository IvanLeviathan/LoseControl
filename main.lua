local api = require("api")
local ccList = require('LoseControl/list')
local helpers = require('LoseControl/helpers')
local settingspage = require('LoseControl/settings_page')

local LoseControlAddon = {
    name = "Lose Control",
    author = "Misosoup",
    version = "0.1",
    desc = "Tracks CC debuffs on you."
}

local CANVAS
local lastUpdate = 0

DEBUFF = {
    path = TEXTURE_PATH.HUD,
    coords = {685, 130, 7, 8},
    inset = {3, 3, 3, 3},
    color = {1, 0, 0, 1}
}

local settings = {}

local function CheckIfDebuffIsCC(debuff)
    if debuff == nil then return false end

    -- check if debuff name is inside ccList
    local has = helpers.hasValue(ccList, debuff.name)

    if has then return true end

    return false
end

local function CollectAllDebuffs()
    local debuffs = {}

    if (helpers.getSettingsPageOpened()) then
        table.insert(debuffs, {
            info = {
                path = 'Game\\ui\\icon\\icon_skill_buff01.dds',
                timeLeft = 5432
            },
            tooltip = {name = "Tripped"}
        })
        return debuffs
    end

    -- Check debuffs
    local debuffsCount = api.Unit:UnitDeBuffCount("player") or 0
    for i = 1, debuffsCount do
        local buff = api.Unit:UnitDeBuff("player", i)
        local tooltip = api.Ability.GetBuffTooltip(buff.buff_id, buff.buff_id)
        local isCC = CheckIfDebuffIsCC(tooltip)

        if tooltip and isCC then
            table.insert(debuffs, {info = buff, tooltip = tooltip})
        end
    end

    return debuffs
end

-- Function to create buff icon and label
local function CreateDebuffIcon()
    local icon = CreateItemIconButton("playerCCIcon", CANVAS)
    icon:Clickable(false)
    icon:SetExtent(settings.IconSize, settings.IconSize)
    icon:Show(false)
    F_SLOT.ApplySlotSkin(icon, icon.back, DEBUFF)
    icon:AddAnchor("CENTER", CANVAS, "CENTER", settings.IconX, settings.IconY)

    local label
    label = CANVAS:CreateChildWidget("label", "playerCCLabel", 0, true)
    label:SetText("")
    label:AddAnchor("CENTER", icon, "CENTER", settings.LabelX, settings.LabelY)
    label.style:SetFontSize(settings.LabelFontSize)
    label.style:SetAlign(ALIGN_CENTER)
    label.style:SetShadow(true)
    label:Show(false)

    local timer
    timer = CANVAS:CreateChildWidget("label", "playerCCTimer", 0, true)
    timer:SetText("")
    timer:AddAnchor("CENTER", icon, "CENTER", settings.TimerX, settings.TimerY)
    timer.style:SetFontSize(settings.TimerFontSize)
    timer.style:SetAlign(ALIGN_CENTER)
    timer.style:SetShadow(true)
    timer.style:SetColor(1, 1, 1, 1)
    timer:Show(false)

    return icon, label, timer
end

local icon, label, timer

local function OnUpdate(dt)
    lastUpdate = lastUpdate + dt
    -- 20 is ok
    if lastUpdate < 20 then return end
    lastUpdate = dt

    -- Collect all debuffs
    local debuffs = CollectAllDebuffs()

    if #debuffs > 0 then
        CANVAS:Show(true)
        for i = 1, #debuffs do
            local info = debuffs[i].info
            local tooltip = debuffs[i].tooltip
            F_SLOT.SetIconBackGround(icon, info.path)
            icon:Show(true)
            if settings.ShowLabel then
                label:SetText(tooltip.name)
                label:Show(true)
            end
            if settings.ShowTimer then
                timer:SetText(string.format("%.1f", (info.timeLeft / 1000)))
                timer:Show(true)
            end
        end
    else
        CANVAS:Show(false)
    end

end

local function OnSettingsSaved()
    icon:Show(false)
    label:Show(false)
    timer:Show(false)
    icon = nil
    label = nil
    timer = nil
    settings = helpers.getSettings(CANVAS)
    icon, label, timer = CreateDebuffIcon()
end

local function Load()
    -- Init canvas
    CANVAS = api.Interface:CreateEmptyWindow("LoseControl")
    CANVAS:Show(true)
    CANVAS:Clickable(false)
    CANVAS.OnSettingsSaved = OnSettingsSaved

    settings = helpers.getSettings(CANVAS)

    icon, label, timer = CreateDebuffIcon()

    settingspage.Load()

    api.Log:Info("Loaded " .. LoseControlAddon.name .. " v" ..
                     LoseControlAddon.version .. " by " ..
                     LoseControlAddon.author)

    api.On("UPDATE", OnUpdate)
end

local function Unload()
    if CANVAS ~= nil then
        CANVAS:Show(false)
        CANVAS = nil
    end
    settingspage.Unload()
end

LoseControlAddon.OnLoad = Load
LoseControlAddon.OnUnload = Unload
LoseControlAddon.OnSettingToggle = settingspage.openSettingsWindow

return LoseControlAddon
