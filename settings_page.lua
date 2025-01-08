local api = require("api")
local helpers = require('LoseControl/helpers')

local settings, settingsWindow
local settingsControls = {}

local function settingsWindowClose()
    settingsWindow:Show(false)
    helpers.setSettingsPageOpened(false)
end

local function saveSettings()
    settings.IconSize = tonumber(settingsControls.IconSize:GetText())
    settings.IconX = tonumber(settingsControls.IconX:GetText())
    settings.IconY = tonumber(settingsControls.IconY:GetText())

    settings.ShowLabel = settingsControls.ShowLabel:GetChecked()
    settings.LabelFontSize = tonumber(settingsControls.LabelFontSize:GetText())
    settings.LabelX = tonumber(settingsControls.LabelX:GetText())
    settings.LabelY = tonumber(settingsControls.LabelY:GetText())

    settings.ShowTimer = settingsControls.ShowTimer:GetChecked()
    settings.TimerFontSize = tonumber(settingsControls.TimerFontSize:GetText())
    settings.TimerX = tonumber(settingsControls.TimerX:GetText())
    settings.TimerY = tonumber(settingsControls.TimerY:GetText())

    helpers.updateSettings()
end

local function initSettingsPage()
    settings = api.GetSettings("LoseControl")
    settingsWindow = api.Interface:CreateWindow("LoseControlSettings",
                                                'Lose Control Settings', 600,
                                                375)
    settingsWindow:AddAnchor("CENTER", 'UIParent', 0, 0)
    settingsWindow:SetHandler("OnCloseByEsc", settingsWindowClose)
    function settingsWindow:OnClose() settingsWindowClose() end
    local wW, wH = settingsWindow:GetExtent()

    -- UI
    -- ICON
    local iconGroupLabel = helpers.createLabel('iconGroupLabel', settingsWindow,
                                               'Icon', 15, 70, 25)
    local iconSizeLabel = helpers.createLabel('iconSizeLabel', iconGroupLabel,
                                              'Icon Size:', 0, 25, 15)
    local iconSize = helpers.createEdit('iconSize', iconSizeLabel,
                                        tonumber(settings.IconSize), 70, 0)
    iconSize:SetMaxTextLength(4)
    settingsControls.IconSize = iconSize

    local iconXLabel = helpers.createLabel('iconXLabel', iconSize, 'offset X:',
                                           110, 0, 15)
    local iconX = helpers.createEdit('iconX', iconXLabel,
                                     tonumber(settings.IconX), 65, 0)
    iconX:SetMaxTextLength(5)
    settingsControls.IconX = iconX

    local iconYLabel = helpers.createLabel('iconYLabel', iconX, 'offset Y:',
                                           110, 0, 15)
    local iconY = helpers.createEdit('iconY', iconYLabel,
                                     tonumber(settings.IconY), 65, 0)
    iconX:SetMaxTextLength(5)
    settingsControls.IconY = iconY

    -- LABEL
    local labelGroupLabel = helpers.createLabel('labelGroupLabel',
                                                iconGroupLabel, 'Label', 0, 70,
                                                25)
    local showLabel = helpers.createCheckbox('showLabel', labelGroupLabel,
                                             "Show label (effect name)", 0, 25)
    showLabel:SetChecked(settings.ShowLabel)
    settingsControls.ShowLabel = showLabel

    local labelFontSizeLabel = helpers.createLabel('labelFontSizeLabel',
                                                   labelGroupLabel,
                                                   'Font Size:', 0, 45, 15)
    local labelFontSize = helpers.createEdit('labelFontSize',
                                             labelFontSizeLabel,
                                             tonumber(settings.LabelFontSize),
                                             70, 0)
    labelFontSize:SetMaxTextLength(4)
    settingsControls.LabelFontSize = labelFontSize

    local labelXLabel = helpers.createLabel('labelXLabel', labelFontSize,
                                            'offset X:', 115, 0, 15)
    local labelX = helpers.createEdit('labelX', labelXLabel,
                                      tonumber(settings.LabelX), 65, 0)
    labelX:SetMaxTextLength(5)
    settingsControls.LabelX = labelX

    local labelYLabel = helpers.createLabel('labelYLabel', labelX, 'offset Y:',
                                            110, 0, 15)
    local labelY = helpers.createEdit('labelY', labelYLabel,
                                      tonumber(settings.LabelY), 65, 0)
    iconX:SetMaxTextLength(5)
    settingsControls.LabelY = labelY

    -- TIMER
    local timerGroupLabel = helpers.createLabel('timerGroupLabel',
                                                labelGroupLabel, 'Timer', 0, 90,
                                                25)
    local showTimer = helpers.createCheckbox('showTimer', timerGroupLabel,
                                             "Show timer", 0, 25)
    showTimer:SetChecked(settings.ShowTimer)
    settingsControls.ShowTimer = showTimer

    local timerFontSizeLabel = helpers.createLabel('timerFontSizeLabel',
                                                   timerGroupLabel,
                                                   'Font Size:', 0, 45, 15)
    local timerFontSize = helpers.createEdit('timerFontSize',
                                             timerFontSizeLabel,
                                             tonumber(settings.TimerFontSize),
                                             70, 0)
    timerFontSize:SetMaxTextLength(4)
    settingsControls.TimerFontSize = timerFontSize

    local timerXLabel = helpers.createLabel('timerXLabel', timerFontSize,
                                            'offset X:', 115, 0, 15)
    local timerX = helpers.createEdit('timerX', timerXLabel,
                                      tonumber(settings.TimerX), 65, 0)
    timerX:SetMaxTextLength(5)
    settingsControls.TimerX = timerX

    local timerYLabel = helpers.createLabel('timerYLabel', timerX, 'offset Y:',
                                            110, 0, 15)
    local timerY = helpers.createEdit('timerY', timerYLabel,
                                      tonumber(settings.TimerY), 65, 0)
    timerY:SetMaxTextLength(5)
    settingsControls.TimerY = timerY

    -- save button
    local saveButton = helpers.createButton('saveButton', settingsWindow,
                                            'Save', 0, 0)
    saveButton:AddAnchor("TOPLEFT", settingsWindow, "BOTTOMLEFT", 15, -45)

    -- controls are done, now events
    saveButton:SetHandler("OnClick", saveSettings)

end

local function Unload()
    if settingsWindow ~= nil then
        settingsWindow:Show(false)
        settingsWindow = nil
    end
end

local function openSettingsWindow()
    settingsWindow:Show(true)
    helpers.setSettingsPageOpened(true)
end

local settings_page = {
    Load = initSettingsPage,
    Unload = Unload,
    openSettingsWindow = openSettingsWindow
}
return settings_page
