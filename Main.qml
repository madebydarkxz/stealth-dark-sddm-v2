import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: config.background

    // ============================================
    //  BACKGROUND — subtle animated gradient
    // ============================================
    Rectangle {
        anchors.fill: parent
        color: "#000000"

        // Subtle moving glow
        Rectangle {
            id: glow
            width: 600
            height: 600
            radius: 300
            color: "#ffffff"
            opacity: 0.012
            x: root.width / 2 - 300
            y: root.height / 2 - 300

            SequentialAnimation on x {
                loops: Animation.Infinite
                NumberAnimation {
                    to: root.width / 2 - 200
                    duration: 12000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: root.width / 2 - 400
                    duration: 12000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on y {
                loops: Animation.Infinite
                NumberAnimation {
                    to: root.height / 2 - 350
                    duration: 15000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: root.height / 2 - 250
                    duration: 15000
                    easing.type: Easing.InOutSine
                }
            }
        }
    }

    // ============================================
    //  CLOCK (top right)
    // ============================================
    Text {
        id: clock
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 30
        color: "#1a1a1a"
        font.family: config.fontFamily
        font.pixelSize: 13
        font.weight: Font.Medium

        function updateTime() {
            var d = new Date()
            var h = d.getHours().toString().padStart(2, "0")
            var m = d.getMinutes().toString().padStart(2, "0")
            text = h + ":" + m
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.updateTime()
        }

        Component.onCompleted: updateTime()
    }

    // ============================================
    //  MAIN LOGIN BOX (center)
    // ============================================
    Column {
        id: loginBox
        anchors.centerIn: parent
        spacing: 0
        width: config.inputWidth

        // Avatar circle
        Rectangle {
            id: avatar
            width: 72
            height: 72
            radius: 36
            color: "#0a0a0a"
            border.width: 1
            border.color: "#1a1a1a"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: userModel.lastUser.charAt(0).toUpperCase()
                color: "#333333"
                font.family: config.fontFamily
                font.pixelSize: 28
                font.weight: Font.Bold
            }

            // Entrance animation
            scale: 0
            opacity: 0
            Component.onCompleted: {
                entranceAnim.start()
            }
        }

        Item { height: 20 }

        // Username label
        Text {
            text: userModel.lastUser || "username"
            color: "#ffffff"
            font.family: config.fontFamily
            font.pixelSize: config.titleFontSize
            font.weight: Font.Bold
            font.letterSpacing: 4
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter

            opacity: 0
            Component.onCompleted: {
                fadeUp.start()
            }
        }

        Item { height: 24 }

        // Password input
        Components.Input {
            id: passwordField
            isPassword: true
            placeholderText: "password"
            anchors.horizontalCenter: parent.horizontalCenter

            onAccepted: doLogin()

            opacity: 0
            Component.onCompleted: {
                fadeUp2.start()
            }
        }

        Item { height: 12 }

        // Error message
        Text {
            id: errorMsg
            text: ""
            color: "#ff3333"
            font.family: config.fontFamily
            font.pixelSize: 11
            font.weight: Font.Medium
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            opacity: 0

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }

        Item { height: 20 }

        // Login button
        Button {
            id: loginBtn
            width: config.inputWidth
            height: config.inputHeight
            anchors.horizontalCenter: parent.horizontalCenter

            contentItem: Text {
                text: "E N T E R"
                color: loginBtn.hovered ? "#000000" : "#ffffff"
                font.family: config.fontFamily
                font.pixelSize: 12
                font.weight: Font.Bold
                font.letterSpacing: 4
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            background: Rectangle {
                color: loginBtn.hovered ? "#ffffff" : "#0a0a0a"
                border.width: 1
                border.color: loginBtn.hovered ? "#ffffff" : "#1a1a1a"
                radius: 10

                Behavior on color {
                    ColorAnimation { duration: 250 }
                }
                Behavior on border.color {
                    ColorAnimation { duration: 250 }
                }
            }

            onClicked: doLogin()

            opacity: 0
            Component.onCompleted: {
                fadeUp3.start()
            }
        }
    }

    // ============================================
    //  BOTTOM BAR (session + power)
    // ============================================
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 24
        spacing: 16

        Components.SessionButton {}

        Rectangle {
            width: 1
            height: 20
            color: "#151515"
            anchors.verticalCenter: parent.verticalCenter
        }

        Components.PowerButton {
            iconText: "⏻"
            onClicked: sddm.powerOff()
        }

        Components.PowerButton {
            iconText: "↻"
            onClicked: sddm.reboot()
        }

        Components.PowerButton {
            iconText: "⏾"
            onClicked: sddm.suspend()
        }
    }

    // ============================================
    //  ANIMATIONS
    // ============================================
    ParallelAnimation {
        id: entranceAnim
        NumberAnimation {
            target: avatar
            property: "scale"
            to: 1
            duration: 600
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: avatar
            property: "opacity"
            to: 1
            duration: 500
        }
    }

    NumberAnimation {
        id: fadeUp
        target: loginBox.children[2]
        property: "opacity"
        to: 1
        duration: 500
        easing.type: Easing.OutCubic
    }

    NumberAnimation {
        id: fadeUp2
        target: passwordField
        property: "opacity"
        to: 1
        duration: 500
        easing.type: Easing.OutCubic
    }

    NumberAnimation {
        id: fadeUp3
        target: loginBtn
        property: "opacity"
        to: 1
        duration: 500
        easing.type: Easing.OutCubic
    }

    // ============================================
    //  LOGIN FUNCTION
    // ============================================
    function doLogin() {
        errorMsg.opacity = 0
        loginBtn.enabled = false
        loginBtn.contentItem.text = ". . ."

        sddm.login(userModel.lastUser, passwordField.text, sessionModel.lastIndex)
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            errorMsg.text = "wrong password"
            errorMsg.opacity = 1
            passwordField.text = ""
            passwordField.forceActiveFocus()
            loginBtn.enabled = true
            loginBtn.contentItem.text = "E N T E R"

            // Shake animation
            shakeAnim.start()
        }

        function onLoginSucceeded() {
            loginBtn.contentItem.text = "✓"
        }
    }

    // Shake on wrong password
    SequentialAnimation {
        id: shakeAnim
        NumberAnimation {
            target: loginBox
            property: "x"
            to: loginBox.x - 12
            duration: 60
        }
        NumberAnimation {
            target: loginBox
            property: "x"
            to: loginBox.x + 12
            duration: 60
        }
        NumberAnimation {
            target: loginBox
            property: "x"
            to: loginBox.x - 8
            duration: 60
        }
        NumberAnimation {
            target: loginBox
            property: "x"
            to: loginBox.x + 8
            duration: 60
        }
        NumberAnimation {
            target: loginBox
            property: "x"
            to: loginBox.x
            duration: 60
        }
    }

    // ============================================
    //  AUTO FOCUS
    // ============================================
    Component.onCompleted: {
        passwordField.forceActiveFocus()
    }
}
