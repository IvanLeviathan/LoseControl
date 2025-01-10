local api = require("api")
local helpers = require('LoseControl/helpers')
local F_ETC = require('LoseControl/util/etc')
local CreateColorPickButtons = require('LoseControl/util/color_picker')

local settings, settingsWindow, palletWindow
local settingsControls = {}

local function settingsWindowClose()
    settingsWindow:Show(false)
    F_ETC.HidePallet()
    helpers.setSettingsPageOpened(false)
end

local function saveSettings()
    settings.IconSize = tonumber(settingsControls.IconSize:GetText())
    settings.IconX = tonumber(settingsControls.IconX:GetText())
    settings.IconY = tonumber(settingsControls.IconY:GetText())

    settings.ShowLabel = settingsControls.ShowLabel:GetChecked()
    settings.LabelFontSize = tonumber(settingsControls.LabelFontSize:GetText())
    settings.LabelTextColor = settingsControls.LabelTextColor.colorBG:GetColor()
    settings.LabelX = tonumber(settingsControls.LabelX:GetText())
    settings.LabelY = tonumber(settingsControls.LabelY:GetText())

    settings.ShowTimer = settingsControls.ShowTimer:GetChecked()
    settings.TimerFontSize = tonumber(settingsControls.TimerFontSize:GetText())
    settings.TimerTextColor = settingsControls.TimerTextColor.colorBG:GetColor()
    settings.TimerX = tonumber(settingsControls.TimerX:GetText())
    settings.TimerY = tonumber(settingsControls.TimerY:GetText())

    helpers.updateSettings()
end

local function initSettingsPage()
    settings = api.GetSettings("LoseControl")
    settingsWindow = api.Interface:CreateWindow("LoseControlSettings",
                                                'Lose Control Settings', 600,
                                                400)
    settingsWindow:AddAnchor("CENTER", 'UIParent', 0, 0)
    settingsWindow:SetHandler("OnCloseByEsc", settingsWindowClose)
    function settingsWindow:OnClose() settingsWindowClose() end

    -- UI
    -- ICON
    local iconGroupLabel = helpers.createLabel('iconGroupLabel', settingsWindow,
                                               'Icon', 15, 70, 25)
    helpers.createLabel('iconDescriptionLabel', iconGroupLabel,
                        "Drag'n'Drop icon to change position", 70, 2, 12)
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
    iconX:SetMaxTextLength(6)
    settingsControls.IconX = iconX

    local iconYLabel = helpers.createLabel('iconYLabel', iconX, 'offset Y:',
                                           110, 0, 15)
    local iconY = helpers.createEdit('iconY', iconYLabel,
                                     tonumber(settings.IconY), 65, 0)
    iconY:SetMaxTextLength(6)
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

    local labelTextColorLabel = helpers.createLabel('labelTextColorLabel',
                                                    labelFontSizeLabel,
                                                    'Color:', 0, 25, 15)

    local labelTextColor = CreateColorPickButtons("labelTextColor",
                                                  labelTextColorLabel)
    labelTextColor:SetExtent(23, 15)
    labelTextColor:AddAnchor("LEFT", labelTextColorLabel, "CENTER", -58, 0)
    labelTextColor.colorBG:SetColor(settings.LabelTextColor.r,
                                    settings.LabelTextColor.g,
                                    settings.LabelTextColor.b, 1)

    function labelTextColor:SelectedProcedure(r, g, b, a)
        self.colorBG:SetColor(r, g, b, a)
    end
    function labelTextColor:OnClick()
        F_ETC.HidePallet()
        palletWindow = F_ETC.ShowPallet(self)
        function palletWindow:OnHide() F_ETC.HidePallet() end
        palletWindow:SetHandler("OnHide", palletWindow.OnHide)
    end
    labelTextColor:SetHandler("OnClick", labelTextColor.OnClick)
    settingsControls.LabelTextColor = labelTextColor

    local labelXLabel = helpers.createLabel('labelXLabel', labelFontSize,
                                            'offset X:', 115, 0, 15)
    local labelX = helpers.createEdit('labelX', labelXLabel,
                                      tonumber(settings.LabelX), 65, 0)
    labelX:SetMaxTextLength(6)
    settingsControls.LabelX = labelX

    local labelYLabel = helpers.createLabel('labelYLabel', labelX, 'offset Y:',
                                            110, 0, 15)
    local labelY = helpers.createEdit('labelY', labelYLabel,
                                      tonumber(settings.LabelY), 65, 0)
    labelY:SetMaxTextLength(6)
    settingsControls.LabelY = labelY

    -- TIMER
    local timerGroupLabel = helpers.createLabel('timerGroupLabel',
                                                labelGroupLabel, 'Timer', 0,
                                                100, 25)
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

    local timerTextColorLabel = helpers.createLabel('timerTextColorLabel',
                                                    timerFontSizeLabel,
                                                    'Color:', 0, 25, 15)

    local timerTextColor = CreateColorPickButtons("timerTextColor",
                                                  timerTextColorLabel)
    timerTextColor:SetExtent(23, 15)
    timerTextColor:AddAnchor("LEFT", timerTextColorLabel, "CENTER", -58, 0)
    timerTextColor.colorBG:SetColor(settings.TimerTextColor.r,
                                    settings.TimerTextColor.g,
                                    settings.TimerTextColor.b, 1)

    function timerTextColor:SelectedProcedure(r, g, b, a)
        self.colorBG:SetColor(r, g, b, a)
    end
    function timerTextColor:OnClick()
        F_ETC.HidePallet()
        palletWindow = F_ETC.ShowPallet(self)
        function palletWindow:OnHide() F_ETC.HidePallet() end
        palletWindow:SetHandler("OnHide", palletWindow.OnHide)
    end
    timerTextColor:SetHandler("OnClick", timerTextColor.OnClick)
    settingsControls.TimerTextColor = timerTextColor

    local timerXLabel = helpers.createLabel('timerXLabel', timerFontSize,
                                            'offset X:', 115, 0, 15)
    local timerX = helpers.createEdit('timerX', timerXLabel,
                                      tonumber(settings.TimerX), 65, 0)
    timerX:SetMaxTextLength(6)
    settingsControls.TimerX = timerX

    local timerYLabel = helpers.createLabel('timerYLabel', timerX, 'offset Y:',
                                            110, 0, 15)
    local timerY = helpers.createEdit('timerY', timerYLabel,
                                      tonumber(settings.TimerY), 65, 0)
    timerY:SetMaxTextLength(6)
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
    F_ETC.HidePallet()
end

local function openSettingsWindow()
    settingsWindow:Show(true)
    helpers.setSettingsPageOpened(true)
end

local function updateIconCoords(x, y, iconSize, canvasOffset)
    settingsControls.IconX:SetText(tostring(
                                       x + (iconSize / 2) + (canvasOffset / 2)))
    settingsControls.IconY:SetText(tostring(
                                       y + (iconSize / 2) + (canvasOffset / 2)))
end

local settings_page = {
    Load = initSettingsPage,
    Unload = Unload,
    openSettingsWindow = openSettingsWindow,
    updateIconCoords = updateIconCoords
}
return settings_page
