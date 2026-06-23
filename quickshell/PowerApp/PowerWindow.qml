import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland 
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme

PanelWindow {
    id: root
    
    // --- 1. OVERLAY & WAYLAND FIXES ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore 
    
    // NEU: Dem Wayland Compositor sagen, dass dieses Fenster den Tastaturfokus will, wenn es geöffnet ist
    WlrLayershell.keyboardFocus: isOpen ? WlrLayershell.KeyboardFocus.Exclusive : WlrLayershell.KeyboardFocus.None
    
    implicitWidth: panelBg.width
    implicitHeight: panelBg.height
    color: "transparent"

    anchors {
        right: true
    }

    // --- CLICK OUTSIDE TO CLOSE (Native Hyprland) ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- HANDLE ESCAPE SHORTCUT ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- 2. ANIMATION LOGIC (FIXED) ---
    property bool isOpen: false
    
    visible: isOpen || slideAnim.running
    
    margins {
        right: root.currentMargin
    }

    property real currentMargin: isOpen ? 20 : -150 

    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint 
        }
    }

    // NEU: Sobald das Fenster fertig aufgeslidet ist, den Fokus auf den ersten Button setzen
    onIsOpenChanged: {
        if (isOpen) {
            // Eine winzige Verzögerung sorgt dafür, dass Qt den Fokus sauber übergibt
            Qt.callLater(() => buttonLayout.children[0].forceActiveFocus())
        }
    }

    IpcHandler {
        target: "power"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   
        function close(): void { root.isOpen = false } 
    }

    Process {
        id: powerProcess
        running: false
    }

    // ==========================================
    // MAIN PANEL BACKGROUND (The Pill Shape)
    // ==========================================
    Item {
        id: panelBg
        implicitWidth: 80 
        implicitHeight: buttonLayout.implicitHeight + 40 

        Rectangle {
            anchors.fill: parent
            color: Theme.background
            border.color: Theme.primary
            border.width: 2
            radius: 40
            opacity: 0.9 
        }

        // ==========================================
        // BUTTON LAYOUT
        // ==========================================
        ColumnLayout {
            id: buttonLayout
            anchors.centerIn: parent
            spacing: 20 

            component PowerButton: Rectangle {
                id: btn
                property string iconTxt: ""
                property string cmd: ""
                
                implicitWidth: 50
                implicitHeight: 50
                radius: 25 
                
                // NEU: Ermöglicht die Navigation via Tab / Pfeiltasten
                activeFocusOnTab: true

                // NEU: Zustand definieren, ob Maus drüber ist ODER Tastatur-Fokus drauf liegt
                property bool isSelected: mouseArea.containsMouse || btn.activeFocus
                
                // Aktualisiert auf das neue 'isSelected'
                color: isSelected ? Theme.primary : "transparent"
                border.color: Theme.primary
                border.width: isSelected ? 2 : 1 // Leicht dickerer Rand bei Fokus für bessere Sichtbarkeit

                Text {
                    anchors.centerIn: parent
                    text: btn.iconTxt
                    font.family: "monospace" 
                    font.pixelSize: 20
                    color: btn.isSelected ? Theme.background : Theme.primary
                }

                // NEU: Enter/Return-Taste auf dem fokussierten Button abfangen
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        executeCommand();
                        event.accepted = true;
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: executeCommand()
                }

                // In eine wiederverwendbare Funktion ausgelagert
                function executeCommand() {
                    powerProcess.command = ["bash", "-c", btn.cmd]
                    powerProcess.running = true
                    root.isOpen = false 
                }
            }

            // Deine Buttons (Reihenfolge bleibt, Pfeiltaste Runter springt von oben nach unten)
            PowerButton { iconTxt: ""; cmd: "pidof hyprlock || hyprlock" }
            PowerButton { iconTxt: ""; cmd: "systemctl suspend" }
            PowerButton { iconTxt: ""; cmd: "hyprctl dispatch exit" }
            PowerButton { iconTxt: ""; cmd: "systemctl reboot" }
            PowerButton { iconTxt: ""; cmd: "systemctl poweroff" }
        }
    }
}
