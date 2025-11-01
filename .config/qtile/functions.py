#!/usr/bin/env python3

from __future__ import annotations

import datetime
import socket

from libqtile import bar, hook, layout, qtile, widget
from libqtile.lazy import lazy


def is_external_monitor_connected():
    try:
        output = subprocess.check_output(["way-displays", "--json"], text=True)
        data = json.loads(output)

        active_displays = [
            display
            for display in data.get("connectors", [])
            if display.get("connected") and display.get("enabled")
        ]

        laptop_displays = [
            d for d in active_displays if "eDP" in d["name"] or "LVDS" in d["name"]
        ]
        external_displays = [d for d in active_displays if d not in laptop_displays]

        return len(external_displays) > 0
    except Exception as e:
        print("Failed to check displays:", e)
        return False


IS_EXTERNAL = is_external_monitor_connected()

FONT_SIZE = 14 if IS_EXTERNAL else 11
BAR_HEIGHT = 38 if IS_EXTERNAL else 30
FEDORA_LOGO = 20 if IS_EXTERNAL else 17
BLUETOOTH = 16 if IS_EXTERNAL else 14
WIFI = 14 if IS_EXTERNAL else 12
STATUS_ICON = 15 if IS_EXTERNAL else 12


# --- Hostname & Keyboard Layout ---
hostname = socket.gethostname()

GB_LAYOUT = "gb"
US_LAYOUT = "us"


def get_keyboard() -> str:
    """Return keyboard layout based on hostname."""
    if hostname == "xpsnix":
        return GB_LAYOUT
    return US_LAYOUT


# --- Layout / Window Management ---
def smart_swap(qtile):
    """
    Swap the focused window with main or right depending on its index.
    """
    layout = qtile.current_layout
    window = qtile.current_window
    if hasattr(layout, "clients") and window in layout.clients:
        index = layout.clients.index(window)
        if index == 0:
            layout.swap_right()
        else:
            layout.swap_main()


@lazy.function
def float_all_windows(qtile):
    """
    Set all windows in the current group to floating mode.
    """
    for win in qtile.current_group.windows:
        win.floating = True
        win.bring_to_front()


@lazy.function
def tile_all_windows(qtile):
    """
    Set all windows in the current group to tiled mode.
    """
    for win in qtile.current_group.windows:
        win.floating = False


@lazy.function
def toggle_floating_all(qtile):
    """
    Toggle all windows in the current group between floating and tiled.
    """
    floating = any(win.floating for win in qtile.current_group.windows)
    if floating:
        tile_all_windows(qtile)
    else:
        float_all_windows(qtile)


@lazy.window.function
def resize_floating_window(window, width: int = 0, height: int = 0) -> None:
    """
    Resize a floating window by the given width/height increments.
    """
    window.cmd_set_size_floating(window.width + width, window.height + height)


# --- Group Management ---
def update_visible_groups(qtile) -> None:
    """
    Update widgets to reflect visible groups.
    A group is considered visible if:
      - Its name is 1–5
      - It is the current group
      - It contains windows
    """
    visible_groups = [
        group.name
        for group in qtile.groups
        if group.name in [str(i) for i in range(1, 6)]
        or (group == qtile.current_group or group.windows)
    ]

    for w in qtile.widgets_map.values():
        if hasattr(w, "visible_groups"):
            w.visible_groups = visible_groups
            if hasattr(w, "bar") and w.bar:
                w.bar.draw()


# --- Hooks ---
@hook.subscribe.client_managed
@hook.subscribe.client_killed
@hook.subscribe.setgroup
def refresh_groups(*_) -> None:
    """Refresh group widgets when clients are managed, killed, or group changes."""
    update_visible_groups(qtile)
