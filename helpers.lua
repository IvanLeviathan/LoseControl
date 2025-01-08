local api = require("api")
local defaultSettings = require('LoseControl/util/default_settings')
local checkButton = require('LoseControl/util/check_button')
local helpers = {}
local CANVAS

local settingsOpened = false

local labelHeight = 20
local editWidth = 100
local padding = 15

function helpers.hasValue(tab, val)
    for index, value in ipairs(tab) do
        if string.lower(value) == string.lower(val) then return true end
    end

    return false
end

function helpers.getSettings(cnv)
    if cnv ~= nil then CANVAS = cnv end
    local settings = api.GetSettings("LoseControl")
    -- loop for set default settings if not exists
    for k, v in pairs(defaultSettings) do
        if settings[k] == nil then settings[k] = v end
    end
    return settings
end

-- Controls
function helpers.createLabel(id, parent, text, offsetX, offsetY, fontSize)
    local label = api.Interface:CreateWidget('label', id, parent)
    label:AddAnchor("TOPLEFT", offsetX, offsetY)
    label:SetExtent(255, labelHeight)
    label:SetText(text)
    label.style:SetColor(FONT_COLOR.TITLE[1], FONT_COLOR.TITLE[2],
                         FONT_COLOR.TITLE[3], 1)
    label.style:SetAlign(ALIGN.LEFT)
    label.style:SetFontSize(fontSize or 18)

    return label
end

function helpers.createEdit(id, parent, text, offsetX, offsetY)
    local field = W_CTRL.CreateEdit(id, parent)
    field:SetExtent(editWidth, labelHeight)
    field:AddAnchor("TOPLEFT", offsetX, offsetY)
    field:SetText(tostring(text))
    field.style:SetColor(0, 0, 0, 1)
    field.style:SetAlign(ALIGN.LEFT)
    -- field:SetDigit(true)
    field:SetInitVal(text)
    -- field:SetMaxTextLength(4)
    return field
end

function helpers.createButton(id, parent, text, x, y)
    local button = api.Interface:CreateWidget('button', id, parent)
    button:AddAnchor("TOPLEFT", x, y)
    button:SetExtent(55, 26)
    button:SetText(text)
    api.Interface:ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
    return button
end

function helpers.createCheckbox(id, parent, text, offsetX, offsetY)
    local checkBox = checkButton.CreateCheckButton(id, parent, text)
    checkBox:AddAnchor("TOPLEFT", offsetX, offsetY)
    checkBox:SetButtonStyle("default")
    return checkBox
end

function helpers.setSettingsPageOpened(state) settingsOpened = state end

function helpers.getSettingsPageOpened() return settingsOpened end

function helpers.updateSettings()
    api.SaveSettings()
    api.Log:Info('Lose Control settings saved')
    local settings = helpers.getSettings()
    CANVAS.OnSettingsSaved()
    return settings
end

return helpers
