import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "quattro.analogclock"
  ipcTarget: "quattro.analogclock"
  manageIpc: false

  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property color accent: Color.accent
  readonly property color dim: Qt.darker(foreground, 1.55)
  readonly property color track: Style.selectedFillFor(foreground, accent)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  readonly property bool showSeconds: root.setting("showSeconds", true) === true
  readonly property bool smoothSeconds: root.setting("smoothSeconds", true) === true

  property date currentTime: new Date()

  implicitWidth: barIconButton.implicitWidth
  implicitHeight: barIconButton.implicitHeight

  function alpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }

  function p2(n) {
    n = String(n)
    return n.length < 2 ? "0" + n : n
  }

  function formatTime(d) {
    var h = d.getHours()
    var m = p2(d.getMinutes())
    var s = p2(d.getSeconds())
    var ampm = h >= 12 ? "PM" : "AM"
    h = h % 12
    if (h === 0) h = 12
    return h + ":" + m + ":" + s + " " + ampm
  }

  function formatTimeShort(d) {
    var h = d.getHours()
    var m = p2(d.getMinutes())
    var ampm = h >= 12 ? "pm" : "am"
    h = h % 12
    if (h === 0) h = 12
    return h + ":" + m + " " + ampm
  }

  function formatDate(d) {
    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var months = ["January", "February", "March", "April", "May", "June",
                  "July", "August", "September", "October", "November", "December"]
    return days[d.getDay()] + ", " + months[d.getMonth()] + " " + d.getDate()
  }

  Timer {
    id: clockTimer
    interval: smoothSeconds ? 1000 / 30 : 1000
    running: true
    repeat: true
    onTriggered: root.currentTime = new Date()
  }

  BarIconButton {
    id: barIconButton
    anchors.fill: parent
    bar: root.bar
    onPressed: function(buttonCode) {
      root.toggle()
    }

    ClockFace {
      anchors.centerIn: parent
      size: Math.min(parent.width, parent.height) - Style.space(4)
      currentTime: root.currentTime
      showSeconds: root.showSeconds
      foreground: root.foreground
      accent: root.accent
      fontFamily: root.fontFamily
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: barIconButton
    owner: root
    bar: root.bar
    open: root.opened
    contentWidth: panel.fittedContentWidth(Style.space(280))
    contentHeight: panel.fittedContentHeight(contentColumn.implicitHeight, Style.space(340))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      visible: true

      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      onTextKey: function(t) {
        if (t === "q" || t === "Q") root.close()
      }

      Column {
        id: contentColumn
        width: parent.width
        spacing: Style.space(16)

        PanelHero {
          width: parent.width
          title: root.formatTimeShort(root.currentTime)
          meta: root.formatDate(root.currentTime)
          foreground: root.foreground
          fontFamily: root.fontFamily

          iconComponent: Component {
            Item {
              width: Style.font.display
              height: Style.font.display
              ClockFace {
                anchors.centerIn: parent
                size: Style.font.display - Style.space(8)
                currentTime: root.currentTime
                showSeconds: true
                foreground: root.foreground
                accent: root.accent
                fontFamily: root.fontFamily
              }
            }
          }
        }

        PanelSeparator { foreground: root.foreground }

        Item {
          width: parent.width
          implicitHeight: largeClock.implicitHeight

          ClockFace {
            id: largeClock
            anchors.horizontalCenter: parent.horizontalCenter
            size: Math.min(parent.width - Style.space(32), Style.space(200))
            currentTime: root.currentTime
            showSeconds: root.showSeconds
            foreground: root.foreground
            accent: root.accent
            fontFamily: root.fontFamily
          }
        }

        Text {
          width: parent.width
          text: root.formatTime(root.currentTime)
          color: root.foreground
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
          font.bold: true
          horizontalAlignment: Text.AlignHCenter
        }

        Text {
          width: parent.width
          text: root.formatDate(root.currentTime)
          color: root.dim
          font.family: root.fontFamily
          font.pixelSize: Style.font.caption
          horizontalAlignment: Text.AlignHCenter
        }

        Text {
          width: parent.width
          text: "Click to close · q/Esc close"
          color: root.dim
          font.family: root.fontFamily
          font.pixelSize: Style.font.caption
          horizontalAlignment: Text.AlignHCenter
          topPadding: Style.space(8)
        }
      }
    }
  }

  // ── Clock Face Component ──────────────────────────────────────────
  component ClockFace: Item {
    id: clock
    property real size: 48
    property date currentTime: new Date()
    property bool showSeconds: true
    property color foreground: root.foreground
    property color accent: root.accent
    property string fontFamily: root.fontFamily

    width: size
    height: size

    Canvas {
      id: canvas
      anchors.fill: parent
      onPaint: paintClock()

      Connections {
        target: clock
        function onCurrentTimeChanged() { canvas.requestPaint() }
      }

      function paintClock() {
        var ctx = getContext("2d")
        var w = canvas.width
        var h = canvas.height
        var cx = w / 2
        var cy = h / 2
        var r = Math.min(cx, cy) - Style.space(1)

        ctx.clearRect(0, 0, w, h)

        // Clock face background
        ctx.beginPath()
        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
        ctx.fillStyle = Qt.rgba(clock.foreground.r, clock.foreground.g, clock.foreground.b, 0.08)
        ctx.fill()
        ctx.strokeStyle = Qt.rgba(clock.foreground.r, clock.foreground.g, clock.foreground.b, 0.2)
        ctx.lineWidth = Style.space(1)
        ctx.stroke()

        // Hour markers
        for (var i = 0; i < 12; i++) {
          var angle = (i * 30 - 90) * Math.PI / 180
          var outerR = r - Style.space(2)
          var innerR = i % 3 === 0 ? r - Style.space(8) : r - Style.space(6)
          var lineW = i % 3 === 0 ? Style.space(2) : Style.space(1)

          ctx.beginPath()
          ctx.moveTo(cx + innerR * Math.cos(angle), cy + innerR * Math.sin(angle))
          ctx.lineTo(cx + outerR * Math.cos(angle), cy + outerR * Math.sin(angle))
          ctx.strokeStyle = clock.foreground
          ctx.lineWidth = lineW
          ctx.lineCap = "round"
          ctx.stroke()
        }

        // Minute markers (small dots between hours)
        for (var j = 0; j < 60; j++) {
          if (j % 5 === 0) continue
          var mAngle = (j * 6 - 90) * Math.PI / 180
          var mR = r - Style.space(4)
          ctx.beginPath()
          ctx.arc(cx + mR * Math.cos(mAngle), cy + mR * Math.sin(mAngle), Style.space(1), 0, 2 * Math.PI)
          ctx.fillStyle = Qt.rgba(clock.foreground.r, clock.foreground.g, clock.foreground.b, 0.25)
          ctx.fill()
        }

        var hours = clock.currentTime.getHours() % 12
        var minutes = clock.currentTime.getMinutes()
        var seconds = clock.currentTime.getSeconds()
        var millis = clock.currentTime.getMilliseconds()

        // Hour hand
        var hourAngle = ((hours + minutes / 60) * 30 - 90) * Math.PI / 180
        var hourLen = r * 0.5
        ctx.beginPath()
        ctx.moveTo(cx, cy)
        ctx.lineTo(cx + hourLen * Math.cos(hourAngle), cy + hourLen * Math.sin(hourAngle))
        ctx.strokeStyle = clock.foreground
        ctx.lineWidth = Style.space(3)
        ctx.lineCap = "round"
        ctx.stroke()

        // Minute hand
        var minAngle = ((minutes + seconds / 60) * 6 - 90) * Math.PI / 180
        var minLen = r * 0.7
        ctx.beginPath()
        ctx.moveTo(cx, cy)
        ctx.lineTo(cx + minLen * Math.cos(minAngle), cy + minLen * Math.sin(minAngle))
        ctx.strokeStyle = clock.foreground
        ctx.lineWidth = Style.space(2)
        ctx.lineCap = "round"
        ctx.stroke()

        // Second hand
        if (clock.showSeconds) {
          var secAngle
          if (clock.smoothSeconds) {
            secAngle = ((seconds + millis / 1000) * 6 - 90) * Math.PI / 180
          } else {
            secAngle = (seconds * 6 - 90) * Math.PI / 180
          }
          var secLen = r * 0.8
          ctx.beginPath()
          ctx.moveTo(cx, cy)
          ctx.lineTo(cx + secLen * Math.cos(secAngle), cy + secLen * Math.sin(secAngle))
          ctx.strokeStyle = clock.accent
          ctx.lineWidth = Style.space(1)
          ctx.lineCap = "round"
          ctx.stroke()
        }

        // Center dot
        ctx.beginPath()
        ctx.arc(cx, cy, Style.space(2.5), 0, 2 * Math.PI)
        ctx.fillStyle = clock.foreground
        ctx.fill()

        if (clock.showSeconds) {
          ctx.beginPath()
          ctx.arc(cx, cy, Style.space(1.5), 0, 2 * Math.PI)
          ctx.fillStyle = clock.accent
          ctx.fill()
        }
      }
    }
  }

  IpcHandler {
    target: root.ipcTarget
    function open(): void { root.open() }
    function close(): void { root.close() }
    function show(): void { root.open() }
    function hide(): void { root.close() }
    function toggle(): void { root.toggle() }
  }
}
