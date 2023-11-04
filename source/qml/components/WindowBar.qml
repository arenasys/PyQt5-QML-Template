import QtQuick 2.15
import QtQuick.Controls 2.15

import gui 1.0

import "../style"

SMenuBar {
    id: root

    SMenu {
        id: menu
        title: "File"
        clipShadow: true
        SMenuItem {
            text: "Quit"
            shortcut: "Ctrl+Q"
            global: true
            onPressed: {
                GUI.quit()
            }
        }
    }
    SMenu {
        title: "Edit"
        clipShadow: true
        SMenuItem {
            text: "None"
        }
    }
    SMenu {
        title: "View"
        clipShadow: true
        SMenuItem {
            text: "None"
        }
    }
    SMenu {
        title: "Help"
        clipShadow: true
        SMenuItem {
            text: "About"
            onPressed: {
                GUI.openLink("https://github.com/arenasys")
            }
        }
    }
}