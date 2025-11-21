# Fast Travel Map Overlay (OpenMW 0.50)

Adds a toggleable "Travel" button to the map screen. When toggled on, a transparent overlay is drawn on top of the world map so you can see fast‑travel routes. A placeholder transparent texture is included; replace it with your own route diagram to match the infographic in the screenshot.

## Installing
- Copy this folder somewhere in your OpenMW `data=` paths (or add it as a new data directory in the launcher).
- Add `content=fast_travel_overlay.omwscripts` to your load order (OpenMW Launcher → Content or directly in `openmw.cfg`).
- Drop your overlay image (PNG/DDS) at `textures/fast_travel_overlay.png`, keeping the same aspect ratio and scale you want for the world map. The bundled file is a 1×1 transparent placeholder so you can safely overwrite it.

## Using
- Open the in-game map. A `Travel` button appears just above the `Local/World` toggle area (within the overlay bounds). Click to show/hide the overlay. The on/off state is remembered per save.
- The overlay is drawn on a non-interactive layer so the map and custom markers stay clickable underneath.

## Tweaking alignment
Edit `scripts/fast_travel_overlay/config.lua` to line the overlay up with your map window:
- `overlayBounds.origin` – top-left corner relative to the screen (0–1). Default matches the vanilla map window placement.
- `overlayBounds.size` – width/height relative to the screen. Match this to your map window size.
- `overlayBounds.pixelOffset` – small pixel nudge after the relative origin.
- `button.*` – size, anchor, and offset for the Travel button inside the overlay bounds.

After changing values, reload a save or use `reload lua scripts` in the console to reapply. If you use a custom UI layout or different resolution/aspect ratio, adjust `origin`/`size` until the overlay edges line up with the map.

## File list
- `fast_travel_overlay.omwscripts` – registers the player script.
- `scripts/fast_travel_overlay/player.lua` – builds the overlay layers and Travel button, saves toggle state.
- `scripts/fast_travel_overlay/config.lua` – alignment and style settings.
- `textures/fast_travel_overlay.png` – replace with your fast-travel network image.
- `mygui/openmw_map_window.layout` – overrides the map layout to draw the overlay inside the map so it zooms/pans with it. The `FastTravelRoutes` widget uses `position_real="0 0 1 0.9"` (90% height). If the overlay seems vertically stretched/squashed, tweak the 3rd/4th numbers (width/height) and, if needed, add a small y offset in the 2nd number (e.g., `0.02`) to align top/bottom.
