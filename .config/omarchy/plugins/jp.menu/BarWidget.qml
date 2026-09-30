import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "jp.menu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "\uf303"
    fontFamily: "JetBrainsMono Nerd Font"
    onPressed: function(button) {
      if (!root.bar) return
      if (button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
      else root.bar.run("omarchy-shell shell toggle jp.menu '{\"menu\":\"root\"}'")
    }
  }
}
