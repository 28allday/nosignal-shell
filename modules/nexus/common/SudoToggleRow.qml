// SudoToggleRow.qml (NoSignal) — Settings -> Services toggle for time-boxed
// passwordless sudo. Reflects live state by polling `nosignal-sudo-toggle
// status` (no root needed); enabling opens a floating terminal for the ONE
// password prompt, disabling runs passwordless inside the active window.
//
// Untracked file under modules/nexus/common — auto-discovered as the type
// `SudoToggleRow` via `import qs.modules.nexus.common`. Survives caelestia
// upgrades; only the one-line insert in ServicesPage.qml is re-applied by hook.
import QtQuick
import Quickshell.Io
import qs.modules.nexus.common

ToggleRow {
    id: root

    property bool active: false
    property int remaining: 0

    text: qsTr("Passwordless sudo (15 min)")
    subtext: active
        ? qsTr("On — %1 min left. Auto-reverts; a reboot also clears it.").arg(remaining)
        : qsTr("Run sudo without a password for 15 minutes, then it reverts")

    onToggled: {
        if (checked) {
            enableProc.running = true;   // needs a password -> floating terminal
            focusTimer.ticks = 0;
            focusTimer.restart();        // then pull keyboard focus to the prompt
        } else {
            disableProc.running = true;  // no password inside the active window
        }
        reconcile.restart();
    }

    // --- live state -----------------------------------------------------------
    Process {
        id: statusProc
        command: ["nosignal-sudo-toggle", "status"]
        stdout: StdioCollector {
            onStreamFinished: {
                const p = text.trim().split(/\s+/);
                root.active = p[0] === "active";
                root.remaining = parseInt(p[1] || "0") || 0;
                root.checked = root.active;   // drive switch from real state
            }
        }
    }

    // --- actions --------------------------------------------------------------
    Process {
        id: enableProc
        // Dedicated window class (nosignal-sudo) so the shipped hypr windowrules
        // (float/center/pin/stayfocused) force this prompt to GRAB keyboard focus.
        // With the shared TUI.float class and no focus rule the prompt did not get
        // keystrokes -> three blank tries tripped pam_faillock and the switch just
        // snapped back with no feedback (hardware bug 2026-06-20). `enable-tui`
        // runs the sudo prompt as the user and keeps the terminal open on failure
        // so the reason is visible instead of vanishing.
        command: ["kitty", "--class", "nosignal-sudo", "-e", "nosignal-sudo-toggle", "enable-tui"]
    }
    Process {
        id: disableProc
        command: ["sudo", "-n", "nosignal-sudo-toggle", "disable"]
    }
    // Force keyboard focus onto the password prompt once it has mapped. Hyprland
    // 0.55's match: windowrule grammar has no working `stayfocused`, so we
    // "activate it" from here instead (the prompt uses the dedicated nosignal-sudo
    // class). Two nudges cover slow terminal startup.
    Process {
        id: focusProc
        command: ["hyprctl", "dispatch", "focuswindow", "class:^(nosignal-sudo)$"]
    }
    Timer {
        id: focusTimer
        interval: 400
        repeat: true
        triggeredOnStart: false
        property int ticks: 0
        onTriggered: {
            focusProc.running = true;
            ticks += 1;
            if (ticks >= 3) {
                ticks = 0;
                stop();
            }
        }
    }

    // --- polling --------------------------------------------------------------
    Timer {
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: statusProc.running = true
    }
    Timer {
        id: reconcile
        interval: 2000
        onTriggered: statusProc.running = true
    }
}
