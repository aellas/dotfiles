from libqtile import qtile
from qtile_extras import widget

from functions import (
    FONT_SIZE,
    FEDORA_LOGO,
    BLUETOOTH,
    WIFI,
    STATUS_ICON,
    is_edp_active,
)


def create_widget_list() -> list:
    from config import HOST

    widgets = [
        widget.Spacer(length=12),
        widget.TextBox(fmt="", fontsize=FEDORA_LOGO),
        widget.TextBox(text="  ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
        widget.GroupBox(
            font="Ubuntu Nerd Font Bold",
            fontsize=FONT_SIZE,
            padding_x=3,
            padding_y=2,
            margin_y=4,
            disable_drag=True,
            active="#D2D4DE",
            inactive="#D2D4DE",
            rounded=True,
            highlight_method="line",
            highlight_color="#13141C",
            this_current_screen_border="#91ACD1",
            this_screen_border="#91ACD1",
            other_screen_border="#91ACD1",
            other_current_screen_border="#91ACD1",
        ),
        widget.Spacer(),
        widget.Clock(format="%A %H:%M"),
        widget.Spacer(),
        widget.StatusNotifier(icon_size=STATUS_ICON, padding=6),
        widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
        widget.CheckUpdates(
            distro="Fedora",
            display_format="   {updates}",
            no_update_string="   0",
            colour_no_updates="#D2D4DE",
            colour_have_updates="#D2D4DE",
            update_interval=10,
            execute="wezterm -e sudo dnf update",
        ),
    ]

    # --- Show widgets depending on which display is active ---
    if is_edp_active():
        # Laptop (eDP-1) is active → show Battery + Backlight
        widgets.extend(
            [
                widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
                widget.Battery(
                    format="{char} {percent:2.0%}",
                    low_percentage=0.2,
                    show_short_text=False,
                    notify_below=30,
                    update_interval=1,
                    charge_char=" 󰂄",
                    discharge_char=" 󰁿",
                    empty_char=" 󰂎",
                    not_charging_char=" 󰂊",
                ),
                widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
                widget.Backlight(
                    brightness_file="/sys/class/backlight/intel_backlight/actual_brightness",
                    max_brightness_file="/sys/class/backlight/intel_backlight/max_brightness",
                    fmt="󰃟 {}",
                ),
            ]
        )
    else:
        # External-only setup → show layout widgets instead
        widgets.extend(
            [
                widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
                widget.TextBox(fmt="◨", font="JetBrainsMonoNF", fontsize=14),
                widget.CurrentLayout(fontsize=11),
            ]
        )

    # --- Common widgets at the end ---
    widgets.extend(
        [
            widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
            widget.Volume(fmt=" {}"),
            widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
            widget.TextBox(
                text="󰂯",
                fontsize=BLUETOOTH,
                font="Ubuntu Nerd Font Bold",
                mouse_callbacks={
                    "Button1": lambda: qtile.cmd_spawn("wezterm -e bluetuith")
                },
            ),
            widget.Spacer(length=1),
            widget.TextBox(
                text="󰖩",
                font="Ubuntu Nerd Font Bold",
                fontsize=WIFI,
                mouse_callbacks={
                    "Button1": lambda: qtile.cmd_spawn("wezterm -e impala")
                },
            ),
            widget.Spacer(length=12),
        ]
    )

    return widgets
