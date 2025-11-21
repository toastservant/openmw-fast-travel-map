local util = require('openmw.util')
local color = util.color

-- Position values are relative to the Windows layer (0..1 across the screen)
-- and sized relative to the same layer. Adjust them if your map window size/position
-- differs from vanilla.
return {
    overlayTexture = 'textures/fast_travel_overlay.png',
    overlayAlpha = 0.75,
    overlayBounds = {
        -- Top-left corner of the overlay relative to the screen.
        origin = util.vector2(0.64, 0.04),
        -- Width/height relative to the screen. Vanilla map window is roughly 0.35 x 0.45.
        size = util.vector2(0.35, 0.46),
        -- Optional pixel nudge for fine alignment.
        pixelOffset = util.vector2(0, 0),
        anchor = util.vector2(0, 0),
    },
    button = {
        label = 'Travel',
        size = util.vector2(116, 28),
        -- Button is anchored to the bottom-right inside the overlay bounds.
        anchor = util.vector2(1, 1),
        relativePosition = util.vector2(1, 1),
        pixelOffset = util.vector2(-8, -8),
        textSize = 15,
        inactiveColor = color.rgb(0.88, 0.78, 0.60),
        activeColor = color.rgb(1.0, 0.95, 0.55),
    }
}
