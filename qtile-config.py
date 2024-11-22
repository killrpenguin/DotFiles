from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
import os
import random


mod = "mod4"
terminal = 'kitty'

color_list = [['#18BAEB', '#18BAEB'], # My Color
              ['#000000', '#000000'], # Black
              ['#FFFFFF', '#FFFFFF'], # White
              ['#FF0000', '#FF0000'], # Red
]

# ['#18BAEB', '#18BAEB'], # My Color
keys = [
    # General Keybindings
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal."),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window."),
    Key([mod], "r", lazy.reload_config(), desc="Reload the qtile config and randomly set"),
    Key([mod], "l", lazy.layout.grow(), desc="Make focused window larger"),
    Key([mod], "h", lazy.layout.shrink(),desc="Make focused window smaller"),

    Key(["shift", "control"], "c", lazy.spawn("copyq copy"), desc="Use copyq to copy text to clipboard"),
    Key(["shift", "control"], "v", lazy.spawn("copyq paste"), desc="Use copyq to paste text from buffer"),
    Key([mod, "control"], "x", lazy.shutdown(), desc="Shutdown Qtile"),

    # Switch between windows
    Key([mod, "control"], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod, "control"], "j", lazy.layout.right(), desc="Move focus to right"),
    Key([mod, "control"], "l", lazy.layout.down(), desc="Move focus down"),
    Key([mod, "control"], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Program Keychords:
    KeyChord([mod], "p", [
        Key([], "e", lazy.spawn("emacsclient -a '' -c"), desc="Launch Emacsclient if no server is running and with debug init mode."),
        Key([], "g", lazy.spawn("google-chrome-stable"), desc="Launch Google Chrome."),
        Key([], "n", lazy.spawn("nvim -o 1"), desc="Launch Neovim"),
        Key([], "p", lazy.spawn("pycharm-community"), desc="Launch Pycharm IDE."),
        Key([], "q", lazy.spawn("copyq show"), desc="Display clipboard manager"),
        Key([], "s", lazy.spawn("steam"), desc="Launch Steam Games."),
        Key([], "t", lazy.spawn("thunar"), desc="Launch Thunar File Manager."),
        Key([], "m", lazy.spawn("vlc"), desc="Launch Vlc media player."),
        Key([], "v", lazy.spawn("vscode"), desc="Launch M$ VsCode."),],
             name="Programs",
             ),
    # System Keychords:
    KeyChord([mod], "s", [
        Key([], "p", lazy.spawn("poweroff"), desc="Turn pc off."),
        Key([], "r", lazy.spawn("reboot"), desc="Turn pc off."),

        Key([], "t", lazy.spawn("bash /home/david/bin/touchscreen_toggle.sh"), desc="Toggle touchscreen."),
        Key([], "m", lazy.spawn("bash /home/david/bin/toggle_touchpad.sh"), desc="Toggle touchpad."),
        
        KeyChord([], "v", [
            Key([], "k", lazy.spawn("amixer -c Generic_1 -q set Master 2dB+"), desc="Volume up"),
            Key([], "j", lazy.spawn("amixer -c Generic_1 -q set Master 2dB-"), desc="Volume down"),
            ],
                 mode=True,
                 name="Volume",),
    
        KeyChord([], "d", [
            Key([], "z", lazy.spawn("emacsclient -c -e \'(org-open-file \"/home/david/.zshrc\")\'"), desc="Edit zshrc"),
            Key([], "q", lazy.spawn("emacsclient -c -e \'(org-open-file \"/home/david/.config/qtile/config.py\")\'"), desc="use alias for editing qtile config with emacs"),
            
        ],
                 name="Dot Files",),
        KeyChord([], "b", [
            Key([], "k", lazy.spawn("brightnessctl -q -d amdgpu_bl0 s +40"), desc="Brightness up"),
            Key([], "j", lazy.spawn("brightnessctl -q -d amdgpu_bl0 s 40-"), desc="Brightness down"),
        ],
                 mode=True,
                 name="Brightness",),
    ],
             name="System",
             ),
        
        # Window Keychords:
    KeyChord([mod], "w", [
        Key([], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
        Key([], "r", lazy.layout.reset(), desc="Reset all window sizes"),
        Key([], "f", lazy.window.toggle_fullscreen(), desc="Full Screen a window"),
        
        Key([], "h", lazy.layout.shuffle_left(), desc="Move focused window to the left"),
        Key([], "j", lazy.layout.shuffle_right(), desc="Move focused window to the right"),
        Key([], "l", lazy.layout.shuffle_down(), desc="Move focused window down"),
        Key([], "k", lazy.layout.shuffle_up(), desc="Move focused window up"),
    ],
             mode=True,
             name="Windows",
             ),
    ]
        
groups = [Group(i) for i in "123456789"]
        
for i in groups:
    keys.extend([
        # mod1 + group number = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name),),
        # mod1 + shift + group number = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc="Switch to & move focused window to group {}".format(i.name),),
        
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + group number = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
        ])
        
layouts = [
    layout.MonadTall(ratio=.60,
    border_focus=color_list[0],
    border_normal=color_list[1]),
    layout.Max(),
]
        
widget_defaults = dict(
     font="sans", fontsize=13, padding=3,)
        
extension_defaults = widget_defaults.copy()
        
def rand_background() -> str:
    home = os.path.expanduser("~/Pictures/wallpapers")
    return f'{home}/{random.choice(os.listdir(home))}'
        
screens = [
    Screen(
    top=bar.Bar([
        widget.GroupBox(),
        widget.Prompt(),
        widget.WindowName(),
        widget.Chord(
            fontsize="15",
            foreground=color_list[3],
            name_transform=lambda name: name,
            ),
        
        widget.Systray(),
	widget.Net(fontsize=14, padding=10),
	widget.TextBox("CPU -> ", foreground="#18BAEB", fontsize=14),
	widget.CPUGraph(),
	widget.TextBox("RAM -> ", foreground="#18BAEB", fontsize=14),
	widget.MemoryGraph(),
	widget.Clock(format="%m-%d-%y", padding=10, fontsize=14),
        widget.BatteryIcon(),
	widget.Clock(format="%I:%M %p", padding=10, fontsize=14),
        ],
                24, opacity=1.0, # bar settings
                ),
        wallpaper=rand_background(),
        wallpaper_mode="fill",
        ),
    ]
        
        # Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
    ]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[        
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="thunar"), # file manager
        Match(title="Terminator Preferences"), # Terminator options
        Match(title="DevTools"),
        Match(title="World of Warcraft"),        
        Match(title="copyq"),
        ]
        )
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
        
# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
     
# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None
       
# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
            
