--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "14px Terminus"
theme.fg   = "#fff"
theme.bg   = "#000"

-- General colours
theme.success_fg = "#5ae7b1"
theme.loaded_fg  = "#67c3eb"
theme.error_fg = "#FFF"
theme.error_bg = "#f35c5c"

-- Warning colours
theme.warning_fg = "#000000"
theme.warning_bg = "#f6f86b"

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg                   = "#fdb8ff"
theme.menu_bg                   = "#2d0057"
theme.menu_selected_fg          = "#2d0057"
theme.menu_selected_bg          = "#fdb8ff"
theme.menu_title_bg             = "#39006e"
theme.menu_primary_title_fg     = "#ffd890"
theme.menu_secondary_title_fg   = "#f8acac"

theme.menu_disabled_fg = "#999"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#060"
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = "#fff"
theme.sbar_bg         = "#24005e"

-- Downloadbar specific
theme.dbar_fg         = "#002344"
theme.dbar_bg         = "#00c3dd"
theme.dbar_error_fg   = "#ff5151"

-- Input bar specific
theme.ibar_fg           = "#ffffff"
theme.ibar_bg           = "#1b003f"

-- Tab label
theme.tab_fg            = "#450057"
theme.tab_bg            = "#9a8acc"
theme.tab_hover_bg      = "#292929"
theme.tab_ntheme        = "#ddd"
theme.selected_fg       = "#fff"
theme.selected_bg       = "#000"
theme.selected_ntheme   = "#ddd"
theme.loading_fg        = "#33AADD"
theme.loading_bg        = "#000"

theme.selected_private_tab_bg = "#4e2788"
theme.private_tab_bg    = "#4c2c97"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#0F0"
theme.notrust_fg        = "#F00"

-- Follow mode hints
theme.hint_font = "12px Terminus, courier, sans-serif"
theme.hint_fg = "#fff"
theme.hint_bg = "#000088"
theme.hint_border = "1px dashed #000"
theme.hint_opacity = "0.3"
theme.hint_overlay_bg = "rgba(255,255,153,0.3)"
theme.hint_overlay_border = "1px dotted #000"
theme.hint_overlay_selected_bg = "rgba(0,255,0,0.3)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok = { fg = "#000", bg = "#FFF" }
theme.warn = { fg = "#F00", bg = "#FFF" }
theme.error = { fg = "#FFF", bg = "#F00" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "#E8E8E8", fg = "#17181C", link = "#03678D" }
theme.gopher_dark  = { bg = "#17181C", fg = "#E8E8E8", link = "#f90" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
