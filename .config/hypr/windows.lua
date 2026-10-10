-- GitHub Inbox: standalone app windows opened by the plugin (open.sh).
-- Chromium names every `--app=` window after the site, e.g.
-- brave-github.com__notifications-Default or
-- chrome-github.com__owner__repo__pull__12-Default, so matching that shape
-- picks up exactly the plugin's windows and leaves the browser window and
-- installed PWAs (crx_<id>) alone. Hyprland matches rule regexes against the
-- whole class, hence the anchors.
o.window("^.+\\-github\\.com__.+$", { float = true, center = true, size = { 1280, 900 } })