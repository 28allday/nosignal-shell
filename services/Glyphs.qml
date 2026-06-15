pragma Singleton
pragma ComponentBehavior: Bound

// NoSignal icon remap: Material Symbol name -> Nerd Font (JetBrainsMono NF)
// codepoint (Font Awesome + MDI ranges), via String.fromCodePoint so the source
// stays pure ASCII. Used by components/NsIcon. Covers bar/panel icons + the dynamic
// Icons.getX() returns. get() falls back to a question glyph so anything
// unmapped is visible (easy to spot + add a mapping).

import QtQuick
import Quickshell

Singleton {
    id: root

    function cp(code: int): string {
        // fromCodePoint (not fromCharCode) so astral-plane glyphs (Nerd Font
        // MDI range, > 0xFFFF) emit correct surrogate pairs, not truncated.
        return String.fromCodePoint(code);
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
        "deployed_code_alert": root.cp(0xf071),
        // caelestia core — static names
        "add": root.cp(0xf067),
        "arrow_forward": root.cp(0xf061),
        "bolt": root.cp(0xf0e7),
        "check": root.cp(0xf00c),
        "clock_arrow_up": root.cp(0xf017),
        "close": root.cp(0xf00d),
        "coffee": root.cp(0xf0f4),
        "delete": root.cp(0xf1f8),
        "drive_folder_upload": root.cp(0xf093),
        "expand_less": root.cp(0xf077),
        "favorite": root.cp(0xf004),
        "function": root.cp(0xf120),
        "handyman": root.cp(0xf0ad),
        "hard_drive": root.cp(0xf0a0),
        "hide_image": root.cp(0xf070),
        "history": root.cp(0xf1da),
        "home": root.cp(0xf015),
        "image": root.cp(0xf03e),
        "keyboard_arrow_down": root.cp(0xf078),
        "keyboard_arrow_up": root.cp(0xf077),
        "keyboard_capslock_badge": root.cp(0xf11c),
        "list": root.cp(0xf03a),
        "looks_one": root.cp(0xf2db),
        "lyrics": root.cp(0xf001),
        "map": root.cp(0xf279),
        "memory_alt": root.cp(0xf2db),
        "more_vert": root.cp(0xf142),
        "open_in_new": root.cp(0xf08e),
        "person_add": root.cp(0xf234),
        "person_edit": root.cp(0xf007),
        "queue_music": root.cp(0xf001),
        "scan_delete": root.cp(0xf1f8),
        "screen_record": root.cp(0xf03d),
        "search": root.cp(0xf002),
        "select_window": root.cp(0xf2d0),
        "sentiment_sad": root.cp(0xf119),
        "sentiment_stressed": root.cp(0xf119),
        "swap_vert": root.cp(0xf0ec),
        "upload": root.cp(0xf093),
        "warning": root.cp(0xf071),
        "web_asset_off": root.cp(0xf2d0),
        "wifi_find": root.cp(0xf1eb),
        // weather (Icons.getWeatherIcon)
        "clear_day": root.cp(0xf185),
        "clear_night": root.cp(0xf186),
        "partly_cloudy_day": root.cp(0xf6c4),
        "cloudy": root.cp(0xf0c2),
        "cloud": root.cp(0xf0c2),
        "rainy": root.cp(0xf73d),
        "cloudy_snowing": root.cp(0xf2dc),
        "foggy": root.cp(0xf75f),
        "air": root.cp(0xf72e),
        // apps / devices (Icons.get*)
        "code": root.cp(0xf121),
        "forum": root.cp(0xf086),
        "communication": root.cp(0xf075),
        "folder": root.cp(0xf07b),
        "files": root.cp(0xf07b),
        "build": root.cp(0xf0ad),
        "construction": root.cp(0xf0ad),
        "edit_note": root.cp(0xf044),
        "content_paste": root.cp(0xf0ea),
        "checklist": root.cp(0xf46d),
        "archive": root.cp(0xf187),
        "host": root.cp(0xf233),
        "monitor_heart": root.cp(0xf108),
        "release_alert": root.cp(0xf071),
        "music_cast": root.cp(0xf001),
        "music_video": root.cp(0xf001),
        "photo_library": root.cp(0xf03e),
        "print": root.cp(0xf02f),
        "phone": root.cp(0xf095),
        "recording": root.cp(0xf03d),
        "screenshot": root.cp(0xf030),
        "screenshot_monitor": root.cp(0xf030),
        "security": root.cp(0xf132),
        "settings": root.cp(0xf013),
        // nexus nav / page icons
        "apps": root.cp(0xf00a),
        "arrow_back": root.cp(0xf060),
        "dashboard": root.cp(0xf0e4),
        "devices_other": root.cp(0xf109),
        "dock_to_bottom": root.cp(0xf2d1),
        "dock_to_right": root.cp(0xf0db),
        "extension": root.cp(0xf12e),
        "globe": root.cp(0xf0ac),
        "info": root.cp(0xf05a),
        "monitor": root.cp(0xf108),
        "palette": root.cp(0xf53f),
        "refresh": root.cp(0xf021),
        "shuffle": root.cp(0xf074),
        "signal_cellular_alt": root.cp(0xf012),
        "system_update_alt": root.cp(0xf019),
        "update": root.cp(0xf021),
        "wallpaper": root.cp(0xf03e),
        "workspaces": root.cp(0xf009),
        "dock": root.cp(0xf2d1),
        // lock screen
        "login": root.cp(0xf090),
        "key": root.cp(0xf084),
        // dashboard / utilities / launcher leftovers
        "account_tree": root.cp(0xf0e8),
        "android": root.cp(0xf17b),
        "category": root.cp(0xf02c),
        "clear_all": root.cp(0xf2ed),
        "compare": root.cp(0xf362),
        "compare_arrows": root.cp(0xf362),
        "contrast": root.cp(0xf042),
        "delete_forever": root.cp(0xf1f8),
        "filter_b_and_w": root.cp(0xf0b0),
        "fullscreen": root.cp(0xf065),
        "gamepad": root.cp(0xf11b),
        "gradient": root.cp(0xf043),
        "hard_disk": root.cp(0xf0a0),
        "keep": root.cp(0xf08d),
        "location_on": root.cp(0xf041),
        "location_searching": root.cp(0xf05b),
        "looks": root.cp(0xf53f),
        "memory": root.cp(0xf2db),
        "notifications_off": root.cp(0xf1f6),
        "nutrition": root.cp(0xf787),
        "page_header": root.cp(0xf036),
        "picture_in_picture_center": root.cp(0xf2d0),
        "resize": root.cp(0xf065),
        "screenshot_region": root.cp(0xf247),
        "select_to_speak": root.cp(0xf028),
        "sentiment_calm": root.cp(0xf118),
        "sentiment_very_dissatisfied": root.cp(0xf119),
        "stop": root.cp(0xf04d),
        "thermostat": root.cp(0xf2c9),
        "water_drop": root.cp(0xf043),
        "wb_twilight": root.cp(0xf185),
        // additions-page icons (nexus Additional Software)
        "brush": root.cp(0xf1fc),          // fa-paintbrush
        "cloud_sync": root.cp(0xf063f),    // md-cloud_sync
        "data_object": root.cp(0xf0169),   // md-code_braces
        "deployed_code": root.cp(0xf1b2),  // fa-cube
        "movie_edit": root.cp(0xf008),     // fa-film
        "neurology": root.cp(0xee9c),      // fa-brain
        "psychology": root.cp(0xf133c),    // md-head_cog
        "robot_2": root.cp(0xee0d),        // fa-robot
        "smart_toy": root.cp(0xf06a9),     // md-robot
        "sports_esports": root.cp(0xf11b), // fa-gamepad
        "videocam": root.cp(0xf03d),       // fa-video_camera
        "vpn_lock": root.cp(0xf099d)       // md-shield_lock
    }

    function get(name: string): string {
        return root.map[name] ?? root.cp(0xf128);
    }
}
