local async = require('openmw.async')
local storage = require('openmw.storage')
local ui = require('openmw.ui')
local util = require('openmw.util')
local I = require('openmw.interfaces')
local auxUi = require('openmw_aux.ui')

local config = require('scripts.fast_travel_overlay.config')

local data = storage.playerSection('FastTravelRoutes')
local MAP_WINDOW = (I.UI and I.UI.WINDOW and I.UI.WINDOW.Map) or 'Map'

local LAYERS = {
    overlay = 'FastTravelRoutes',
    controls = 'FastTravelRoutesControls',
}

local state = {
    enabled = false,
    mapVisible = false,
    overlayElement = nil,
    controlsElement = nil,
}

local syncVisibility

local function insertLayer(name, after, interactive)
    if not ui.layers.indexOf(name) then
        ui.layers.insertAfter(after, name, { interactive = interactive })
    end
end

local function ensureLayers()
    insertLayer(LAYERS.overlay, 'Windows', false)
    insertLayer(LAYERS.controls, LAYERS.overlay, true)
end

local function overlayLayout()
    local bounds = config.overlayBounds
    return {
        type = ui.TYPE.Image,
        layer = LAYERS.overlay,
        props = {
            position = bounds.pixelOffset,
            relativePosition = bounds.origin,
            relativeSize = bounds.size,
            anchor = bounds.anchor,
            color = util.color.rgba(1, 1, 1, config.overlayAlpha or 0.8),
            inheritAlpha = true,
            propagateEvents = false,
            resource = ui.texture { path = config.overlayTexture },
            visible = state.enabled and state.mapVisible,
        },
    }
end

local function buttonLayout()
    local b = config.button
    return {
        name = 'button',
        template = I.MWUI.templates.boxSolid,
        props = {
            anchor = b.anchor,
            position = b.pixelOffset,
            relativePosition = b.relativePosition,
            size = b.size,
            propagateEvents = true,
            inheritAlpha = true,
        },
        events = {
            mouseClick = async:callback(function()
                state.enabled = not state.enabled
                data:set('enabled', state.enabled)
                syncVisibility()
            end),
        },
        content = ui.content {
            {
                name = 'label',
                type = ui.TYPE.Text,
                props = {
                    relativeSize = util.vector2(1, 1),
                    text = b.label,
                    textSize = b.textSize,
                    textAlignH = ui.ALIGNMENT.Center,
                    textAlignV = ui.ALIGNMENT.Center,
                    textColor = util.color.rgb(1, 1, 1),
                    autoSize = false,
                },
            },
        },
    }
end

local function controlsLayout()
    local bounds = config.overlayBounds
    return {
        type = ui.TYPE.Container,
        layer = LAYERS.controls,
        props = {
            position = bounds.pixelOffset,
            relativePosition = bounds.origin,
            relativeSize = bounds.size,
            anchor = bounds.anchor,
            visible = state.mapVisible,
            propagateEvents = false,
            inheritAlpha = true,
        },
        content = ui.content {
            buttonLayout(),
        },
    }
end

local function ensureElements()
    ensureLayers()
    if not state.overlayElement then
        state.overlayElement = ui.create(overlayLayout())
    end
    if not state.controlsElement then
        state.controlsElement = ui.create(controlsLayout())
    end
end

local function updateButtonVisuals()
    if not (state.controlsElement and state.controlsElement.layout and state.controlsElement.layout.content.button) then
        return
    end
    local label = state.controlsElement.layout.content.button.content.label.props
    label.text = state.enabled and (config.button.label .. ' (on)') or config.button.label
    label.textColor = state.enabled and config.button.activeColor or config.button.inactiveColor
    auxUi.deepUpdate(state.controlsElement)
end

local function syncVisibility()
    ensureElements()
    state.overlayElement.layout.props.visible = state.enabled and state.mapVisible
    state.controlsElement.layout.props.visible = state.mapVisible
    state.overlayElement:update()
    state.controlsElement:update()
    updateButtonVisuals()
end

local function isMapVisible()
    return I.UI and I.UI.isWindowVisible and I.UI.isWindowVisible(MAP_WINDOW) or false
end

local function refreshMapVisibility()
    local open = isMapVisible()
    if open ~= state.mapVisible then
        state.mapVisible = open
        syncVisibility()
    end
end

local function onLoad()
    state.enabled = data:get('enabled') or false
    ensureElements()
    state.mapVisible = isMapVisible()
    syncVisibility()
end

return {
    engineHandlers = {
        onLoad = onLoad,
        onUpdate = refreshMapVisibility,
    },
    eventHandlers = {
        UiModeChanged = refreshMapVisibility,
    },
}
