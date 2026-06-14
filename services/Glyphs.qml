pragma Singleton
pragma ComponentBehavior: Bound

// NoSignal icon remap: Material Symbol name -> Nerd Font (JetBrainsMono NF)
// codepoint (Font Awesome range), via String.fromCharCode so the source stays
// pure ASCII. Used by components/NsIcon. Covers bar/panel icons + the dynamic
// Icons.getX() returns. get() falls back to a question glyph so anything
// unmapped is visible (easy to spot + add a mapping).

import QtQuick
import Quickshell

Singleton {
    id: root

    function cp(code: int): string {
        return String.fromCharCode(code);
    }

    readonly property var map: {
        // network (no per-strength glyphs in FA range -> all wifi)
        "wifi": root.cp(0xf1eb),
        "wifi_off": root.cp(0xf1eb),
        "network_wifi": root.cp(0xf1eb),
        "network_wifi_1_bar": root.cp(0xf1eb),
        "network_wifi_2_bar": root.cp(0xf1eb),
        "network_wifi_3_bar": root.cp(0xf1eb),
        "network_wifi_locked": root.cp(0xf023),
        "network_wifi_1_bar_locked": root.cp(0xf023),
        "network_wifi_2_bar_locked": root.cp(0xf023),
        "network_wifi_3_bar_locked": root.cp(0xf023),
        "signal_wifi_0_bar": root.cp(0xf1eb),
        "cable": root.cp(0xf0e8),
        // bluetooth
        "bluetooth": root.cp(0xf293),
        "bluetooth_connected": root.cp(0xf293),
        "bluetooth_disabled": root.cp(0xf294),
        // audio
        "volume_up": root.cp(0xf028),
        "volume_down": root.cp(0xf027),
        "volume_mute": root.cp(0xf6a9),
        "volume_off": root.cp(0xf026),
        "no_sound": root.cp(0xf026),
        "speaker": root.cp(0xf028),
        "mic": root.cp(0xf130),
        "mic_off": root.cp(0xf131),
        "graphic_eq": root.cp(0xf001),
        "headphones": root.cp(0xf025),
        "headset": root.cp(0xf025),
        "audio": root.cp(0xf025),
        "keyboard": root.cp(0xf11c),
        "mouse": root.cp(0xf109),
        "phone": root.cp(0xf095),
        "smartphone": root.cp(0xf10b),
        // battery
        "battery_full": root.cp(0xf240),
        "battery_charging_full": root.cp(0xf240),
        "battery": root.cp(0xf242),
        "tune": root.cp(0xf1de),
        // notifications / toggles
        "notifications": root.cp(0xf0f3),
        "notifications_none": root.cp(0xf0a2),
        "do_not_disturb_on": root.cp(0xf05e),
        "dark_mode": root.cp(0xf186),
        "nightlight": root.cp(0xf186),
        "bedtime": root.cp(0xf186),
        "airplanemode_active": root.cp(0xf072),
        "vpn_key": root.cp(0xf084),
        // media
        "music_note": root.cp(0xf001),
        "music": root.cp(0xf001),
        "pause": root.cp(0xf04c),
        "play_arrow": root.cp(0xf04b),
        "skip_next": root.cp(0xf051),
        "skip_previous": root.cp(0xf048),
        // power / session
        "power_settings_new": root.cp(0xf011),
        "power": root.cp(0xf011),
        "lock": root.cp(0xf023),
        "logout": root.cp(0xf08b),
        "restart_alt": root.cp(0xf021),
        "reboot": root.cp(0xf021),
        // chrome / nav
        "desktop_windows": root.cp(0xf108),
        "web_asset": root.cp(0xf2d0),
        "widgets": root.cp(0xf009),
        "settings": root.cp(0xf013),
        "expand_more": root.cp(0xf078),
        "chevron_left": root.cp(0xf053),
        "chevron_right": root.cp(0xf054),
        "calendar_month": root.cp(0xf073),
        "schedule": root.cp(0xf017),
        "brightness_6": root.cp(0xf185),
        // notif category icons
        "chat": root.cp(0xf075),
        "file": root.cp(0xf15b),
        "folder_copy": root.cp(0xf07b),
        "download": root.cp(0xf019),
        "person": root.cp(0xf007),
        "profile": root.cp(0xf007),
        "installed": root.cp(0xf058),
        "deployed_code_alert": root.cp(0xf071)
    }

    function get(name: string): string {
        return root.map[name] ?? root.cp(0xf128);
    }
}
