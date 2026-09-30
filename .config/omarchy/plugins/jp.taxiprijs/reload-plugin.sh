#!/usr/bin/env bash
set -euo pipefail

# Dev helper: deploy the local Omarchy plugin changes and force the shell to
# pick them up.
#
# Hot-reload of QML *content* does not work on this system (Arch quickshell
# does not expose Qt.clearComponentCache - see
# https://github.com/basecamp/omarchy/issues/8555), so each QML edit needs a
# full shell restart. This script makes that iteration loop one command:
#
#   edit extras/omarchy-plugin/BarWidget.qml
#   ./extras/omarchy-plugin/reload-plugin.sh
#
# For layout/registration changes (shell.json) no restart is needed; those
# hot-reload on their own.

PLUGIN_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ID="jp.taxiprijs"
PLUGIN_DST="${HOME}/.config/omarchy/plugins/${PLUGIN_ID}"

usage() {
  echo "Usage: $(basename "$0") [install|restart]"
  echo
  echo "  install   Copy plugin files from ${PLUGIN_SRC} to ${PLUGIN_DST}"
  echo "  restart   Restart the Omarchy shell (also re-scans plugins)"
  echo "  (default) Copy files, then restart the shell"
}

case "${1:-}" in
  install)  ACTION=install ;;
  restart)  ACTION=restart ;;
  -h|--help) usage; exit 0 ;;
  "")       ACTION=all ;;
  *)        echo "Unknown argument: $1"; usage; exit 1 ;;
esac

if [[ "$ACTION" == "all" || "$ACTION" == "install" ]]; then
  mkdir -p "$PLUGIN_DST"
  cp -v "$PLUGIN_SRC"/BarWidget.qml "$PLUGIN_SRC"/manifest.json "$PLUGIN_SRC"/README.md "$PLUGIN_DST/"
fi

if [[ "$ACTION" == "all" || "$ACTION" == "restart" ]]; then
  echo "Restarting Omarchy shell..."
  omarchy restart shell
fi
