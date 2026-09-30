# TaxiCheck — Omarchy Plugin

A bar widget for Omarchy Quattro that launches the TaxiCheck TUI.

## Install

`make install` copies this plugin to
`~/.config/omarchy/plugins/jp.taxiprijs`, adds `{ "id": "jp.taxiprijs" }`
to the bar layout in `~/.config/omarchy/shell.json`, and rescans plugins.
No manual steps needed.

If you installed the binary manually instead, install the plugin with:

```sh
omarchy plugin add https://github.com/ramackersjp/taxiCheck.git --path extras/omarchy-plugin
```

Or manually:

```sh
PLUGIN_DIR="$HOME/.config/omarchy/plugins/jp.taxiprijs"
mkdir -p "$PLUGIN_DIR"
cp extras/omarchy-plugin/* "$PLUGIN_DIR/"
omarchy-shell shell rescanPlugins
```

Then add to your bar layout in `~/.config/omarchy/shell.json`:

```json
{ "id": "jp.taxiprijs" }
```

## Development

Iterating on the widget? `reload-plugin.sh` copies your local changes to the
live plugin dir and restarts the shell:

```sh
./extras/omarchy-plugin/reload-plugin.sh        # copy + restart shell
./extras/omarchy-plugin/reload-plugin.sh install # copy only
./extras/omarchy-plugin/reload-plugin.sh restart # restart shell only
```

> **Note:** Layout/registration changes (`shell.json`) hot-reload, but QML
> *content* changes require a shell restart on this system, because the Arch
> `quickshell` package does not expose `Qt.clearComponentCache`. See
> https://github.com/basecamp/omarchy/issues/8555.

## Remove

```sh
omarchy plugin remove jp.taxiprijs
```
