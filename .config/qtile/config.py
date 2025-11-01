import os
import subprocess
import socket

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import (
    Click,
    Drag,
    DropDown,
    Group,
    Key,
    Match,
    ScratchPad,
    Screen,
    KeyChord,
)
from libqtile.lazy import lazy
from libqtile.backend.wayland.inputs import InputConfig

from functions import (
    smart_swap,
    float_all_windows,
    tile_all_windows,
    toggle_floating_all,
    update_visible_groups,
    refresh_groups,
)

import subprocess
import re


def is_external_monitor_connected():
    try:
        output = subprocess.check_output(["way-displays", "-g"], text=True)
        displays = re.findall(r"^([A-Za-z0-9\-]+):", output, flags=re.MULTILINE)

        external_connected = False
        laptop_connected = False

        for display in displays:
            pattern = rf"^{display}:\n((?:  .*\n?)*)"
            match = re.search(pattern, output, flags=re.MULTILINE)
            if not match:
                continue

            block = match.group(1)

            # Check if this display is disabled
            disabled = "(disabled)" in block

            if not disabled:
                if "eDP" in display or "LVDS" in display:
                    laptop_connected = True
                else:
                    external_connected = True

        return external_connected

    except subprocess.CalledProcessError as e:
        print("Error running way-displays:", e)
    except Exception as e:
        print("Failed to check displays:", e)

    return False


IS_EXTERNAL = is_external_monitor_connected()

FONT_SIZE = 11 if IS_EXTERNAL else 14
BAR_HEIGHT = 30 if IS_EXTERNAL else 38
FEDORA_LOGO = 17 if IS_EXTERNAL else 20
BLUETOOTH = 14 if IS_EXTERNAL else 16
WIFI = 12 if IS_EXTERNAL else 14
STATUS_ICON = 14 if IS_EXTERNAL else 15

# --- Environment ---
IS_WAYLAND = qtile.core.name == "wayland"
hostname = socket.gethostname()

# --- Mod Keys ---
mod = "mod4"
mod1 = "control"

# --- Key Bindings ---
keys = [
    Key([mod], "Return", lazy.spawn("wezterm"), desc="Launch terminal"),
    Key(
        [mod], "space", lazy.spawn("rofi -show drun"), desc="Launch app launcher (rofi)"
    ),
    Key(
        [mod],
        "b",
        lazy.spawn("floorp --ozone-platform=wayland --ozone-platform-hint=wayland"),
        desc="Launch web browser",
    ),
    Key(
        [mod],
        "a",
        lazy.spawn(
            "brave-browser --new-window --ozone-platform=wayland --ozone-platform-hint=wayland --app=http://sernix:3000/"
        ),
        desc="launch",
    ),
    Key([mod], "s", lazy.spawn("steam"), desc="Launch Steam"),
    Key([mod], "n", lazy.spawn("wezterm -e yazi"), desc="Launch yazi"),
    Key(
        [mod],
        "m",
        lazy.spawn("wezterm -e jellyfin-tui"),
        desc="Launch rmpc",
    ),
    Key(
        [mod],
        "y",
        lazy.spawn(
            "brave-browser --new-window --ozone-platform=wayland --ozone-platform-hint=wayland --app=https://music.youtube.com/"
        ),
        desc="launch",
    ),
    Key(
        [mod],
        "d",
        lazy.spawn("vesktop --ozone-platform=wayland --ozone-platform-hint=wayland"),
        desc="Launch Discord",
    ),
    Key([mod], "l", lazy.spawn("emacsclient -c -a 'emacs'"), desc="Launch Doom Emacs"),
    Key([mod, "shift"], "t", lazy.spawn("wezterm -e tmux"), desc="Launch tmux"),
    Key([mod], "v", lazy.spawn("protonvpn-app"), desc="Launch ProtonVPN"),
    Key(
        [mod],
        "j",
        lazy.spawn(
            "sh -c '_JAVA_AWT_WM_NONREPARENTING=1 _JAVA_AWT_USE_WAYLAND=1 flatpak run com.jagexlauncher.JagexLauncher'"
        ),
        desc="Jagex Launcher",
    ),
    Key(
        [],
        "Print",
        lazy.spawn("bash -c '/home/$USER/.config/qtile/scripts/screenshot.sh'"),
        desc="Take full screenshot",
    ),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn("bash -c '/home/$USER/.config/qtile/scripts/power.sh'"),
        desc="Power Menu",
    ),
    Key(
        [mod],
        "p",
        lazy.spawn("bash -c '/home/$USER/.config/qtile/scripts/powerprofile.sh'"),
        desc="Power Menu",
    ),
    Key(
        [mod],
        "c",
        lazy.spawn("bash -c '/home/$USER/.config/qtile/scripts/colorpicker.sh'"),
        desc="ColorPicker",
    ),
    Key(
        [mod],
        "u",
        lazy.spawn("wezterm -e '/home/$USER/.config/qtile/scripts/source.sh'"),
        desc="ColorPicker",
    ),
    Key(
        [mod],
        "k",
        lazy.spawn("bash -c /home/$USER/.config/qtile/scripts/clipboard.sh"),
        desc="Clipboard Manager",
    ),
    # --- Qtile Specific ---
    Key([mod], "o", lazy.hide_show_bar(), desc="Hide the bar"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "Tab", lazy.function(smart_swap), desc="Smart swap with master"),
    Key([mod], "Down", lazy.layout.down(), desc="Focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Focus up"),
    Key([mod], "Left", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod], "Right", lazy.layout.grow(), desc="Grow window"),
    Key([mod], "r", lazy.layout.reset(), desc="Reset layout"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "period", lazy.next_layout(), desc="Next layout"),
    Key([mod], "comma", lazy.prev_layout(), desc="Previous layout"),
    Key([mod, "shift"], "Space", toggle_floating_all(), desc="Toggle float/tile all"),
    Key([mod], "f", float_all_windows(), desc="Float all windows"),
    Key([mod], "t", tile_all_windows(), desc="Tile all windows"),
    KeyChord([mod], "i", [Key([mod], "i", lazy.ungrab_all_chords())], name="VM Mode"),
    # --- Volume / Brightness ---
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%"),
        desc="Volume up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%"),
        desc="Volume down",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Toggle mute",
    ),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl set 150+%"),
        desc="Brightness up",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl set 5-%"),
        desc="Brightness down",
    ),
]

# --- Mouse Bindings ---
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# --- Groups ---
groups = [Group(str(i)) for i in range(1, 10)]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc=f"Move window to group {i.name}",
            ),
        ]
    )

# --- ScratchPad ---
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                "wezterm",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.1,
                opacity=1.0,
                on_focus_lost_hide=True,
            ),
            DropDown(
                "wifi",
                "wezterm -e impala",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.1,
                opacity=1.0,
                on_focus_lost_hide=False,
            ),
        ],
    )
)

# --- ScratchPad Keybinds ---
keys.extend(
    [
        Key([mod, "shift"], "Return", lazy.group["scratchpad"].dropdown_toggle("term")),
        Key([mod], "e", lazy.group["scratchpad"].hide_all()),
    ]
)  # --- Layouts ---
layout_conf = {
    "border_focus": "#91ACD1",
    "border_normal": "#13141C",
    "border_width": 2,
    "margin": 4,
}

layouts = [
    layout.MonadTall(**layout_conf),
    layout.MonadWide(**layout_conf),
    layout.MonadThreeCol(**layout_conf),
    layout.Bsp(**layout_conf),
    layout.RatioTile(**layout_conf),
    layout.Spiral(**layout_conf),
]

# --- Widgets & Bar ---
widget_defaults = dict(
    font="Ubuntu Nerd Font Bold",
    fontsize=FONT_SIZE,
    padding=2,
    background="#13141C",
    foreground="#D2D4DE",
)
extension_defaults = widget_defaults.copy()


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=12),
                widget.TextBox(
                    fmt="",
                    fontsize=FEDORA_LOGO,
                ),
                widget.TextBox(
                    text="  ︱ ", font="Ubuntu Mono", padding=2, fontsize=10
                ),
                widget.GroupBox(
                    font="Ubuntu Nerd Font Bold",
                    fontsize=FONT_SIZE,
                    padding=4,
                    margin_x=2,
                    margin_y=-10,
                    disable_drag=True,
                    active="#D2D4DE",
                    inactive="#D2D4DE",
                    highlight_method="text",
                    highlight_color="#13141C",
                    this_current_screen_border="#91ACD1",
                    visible_groups=[
                        g.name
                        for g in groups
                        if g.name in [str(i) for i in range(1, 6)]
                    ],
                ),
                widget.Spacer(),
                widget.Clock(format="%A %H:%M"),
                widget.Spacer(),
                widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
                widget.CheckUpdates(
                    distro="Fedora",
                    display_format="   {updates}",
                    no_update_string="   0",
                    colour_no_updates="#D2D4DE",
                    colour_have_updates="#D2D4DE",
                    update_interval=10,
                    execute="wezterm -e sudo dnf update --refresh",
                ),
                widget.TextBox(text=" ︱ ", font="Ubuntu Mono", padding=2, fontsize=10),
                widget.TextBox(fmt="◨", font="JetBrainsMonoNF", fontsize=16),
                widget.CurrentLayout(fontsize=FONT_SIZE),
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
            ],
            BAR_HEIGHT,
            background="#161821",
            opacity=1.0,
            margin=[0, -2, 0, -2],
        ),
    ),
]

floating_layout = layout.Floating(
    border_width=2,
    border_focus="#91ACD1",
    border_normal="#91ACD1",
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="feh"),
        Match(wm_class="net-runelite-client-RuneLite"),
        Match(wm_class="protonvpn-app"),
        Match(wm_class="VirtViewer"),
    ],
)

# --- Wayland Input Configs ---
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_layout="gb" if hostname in ("fedor", "thinknix") else "us"
    ),
    "type:touchpad": InputConfig(
        tap=True,
        natural_scroll=False,
        dwt=True,
        accel_profile="adaptive",
        pointer_accel=0.2,
    ),
}


# --- Autostart ---
@hook.subscribe.startup_once
def autostart():
    autostart_script = os.path.expanduser("~/.config/qtile/scripts/wayland.sh")
    if os.path.isfile(autostart_script):
        subprocess.Popen(["bash", autostart_script])


@hook.subscribe.startup_once
def autoscale():
    autoscale_script = os.path.expanduser("~/.config/qtile/scripts/scale.sh")
    if os.path.isfile(autoscale_script):
        subprocess.Popen(["bash", autoscale_script])


# --- Other Settings ---
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = True
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
auto_minimize = True
wl_xcursor_theme = "Breeze-light"
wl_xcursor_size = 24
wmname = "QTILE"
