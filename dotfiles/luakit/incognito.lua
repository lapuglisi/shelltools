local modes = require "modes"
local settings = require "settings"
local downloads = require "downloads"
local window = require "window"
local engines = settings.window.search_engines

-- Settings
engines.google = "https://google.com/search?q=%s"
engines.ddg = "https://duckduckgo.com/?q=%s"
engines.aur = "https://aur.archlinux.org/packages?K=%s"
engines.default = engines.google

settings.webview.user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Krome/88.0.4896.127 Serominers/209.25"

downloads.default_dir = os.getenv("HOME") .. "/Downloads"

modes.add_binds("normal", {

  {"O", "Open URL in a new tab.",
    function (w)
      w:enter_cmd(":tabopen ")
    end },
  {"I", "Opens a URL in a private tab",
    function(w)
      w:enter_cmd(":priv-tabopen ")
    end },
  {"{", "Open history",
    function(w)
      w:new_tab("luakit://history")
    end }
})

window.methods.new_tab = function (w, arg, opts)
  assert(arg == nil or type(arg) == "string" or type(arg) == "table"
                   or (type(arg) == "widget" and arg.type == "webview"))
  opts = opts or {}  
  assert(type(opts) == "table")  
  local switch, order = opts.switch, opts.order

  opts.private = true

  -- Bit of a hack
  local webview = require("webview")
  local view

  if type(arg) == "widget" and arg.type == "webview" then
    view = arg
    local ww = webview.window(view)
    ww:detach_tab(view)
    w:attach_tab(view, switch, order)
  end

  if not view and settings.get_setting("window.reuse_new_tab_pages") then
    for _, tab in ipairs(w.tabs.children) do
      if tab.uri == settings.get_setting("window.new_tab_page") then
        msg.verbose("new_tab: using existing blank tab, %s", tab.uri)
        view = tab
        break
      end
    end
  end

  if not view then
    -- Make new webview widget
      view = webview.new({ private = opts.private })
      if not arg and not opts.no_initial_url then
        view.uri = settings.get_setting("window.new_tab_page")
      end
      w:attach_tab(view, switch, order)
  end

  if switch ~= false then w.tabs:switch(w.tabs:indexof(view)) end

  if arg and not (type(arg) == "widget" and arg.type == "webview") then
    w:search_open_navigate(view, arg)
  end

  view:reload()
  return view
end