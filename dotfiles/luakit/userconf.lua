local modes = require "modes"
local settings = require "settings"
local downloads = require "downloads"
local window = require "window"

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
    end },
  {"<Control-c>", "Copy selected text.",
    function ()
      luakit.selection.clipboard = luakit.selection.primary
    end }
})

modes.add_cmds({
  { 
    ":pwindow", "Defaults to private browsing", 
    function(w)
      window.methods.new_tab = new_tab_private
    end
  }
})

function new_tab_private(w, arg, opts)
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

-- Settings

-- application.enable_pdfjs
-- application.prefer_dark_mode
settings.completion.history.order = "last_visit"
--
-- A string indicating how history items should be sorted in completion. Possible values are:
-- visits: most visited websites first
-- last_visit: most recent websites first
-- title: sort by title, alphabetically
-- uri: sort by website address, alphabetically
--
-- 
settings.completion.max_items = 25 -- Number of completion items for history and bookmarks.
settings.session.always_save = false -- Whether the current browsing session should always be saved just before luakit is exited.
-- session.recovery_save_interval -- The minimum time to wait in seconds after a browsing action before saving the recovery session. Must be non-negative.
-- tablist.always_visible -- Whether the tab list should be visible with only a single tab open. This is deprecated in favour of tablist.visibility and may be removed in the future.
-- tablist.visibility  -- When should the tab list be visible?
-- undoclose.max_saved_tabs  -- The maximum number of closed tabs that should be saved, or -1 for no limit.
--                           --When the number of closed tabs reaches this limit, the oldest closed tabs are discarded.
-- 
-- webview.allow_file_access_from_file_urls -- Whether file:// URIs are allowed to access other local files via JavaScript.
-- webview.allow_modal_dialogs -- Whether JavaScript will be able to create and run modal dialogs with window.showModalDialog.
-- webview.allow_universal_access_from_file_urls -- Whether file:// URIs are allowed to access content from any origin via JavaScript.
-- webview.auto_load_images -- Whether images should be automatically loaded. Disabling this is useful for reducing data transfer.
-- webview.cursive_font_family -- The font family used for content using the cursive font.
-- webview.default_charset -- The default text character set used when content does not explicitly specify a character set.
-- settings.webview.default_font_family = "Inconsolata" -- The font family used for content that does not specify a font.
settings.webview.default_font_size = 16 -- The default font size (in pixels) to use for web content that does not specify a main font size.
settings.webview.default_monospace_font_size = 16 -- The default font size (in pixels) to use for monospace web content when no main font size is specified.
-- webview.draw_compositing_indicators -- Whether compositing indicators should be shown. These, indicators show composited regions on the page as well as a repaint, counter for each; this is mostly useful for debugging.
-- webview.enable_accelerated_2d_canvas -- Whether 2d canvas rendering should use hardware acceleration. This setting requires WebKit support that may not be available.
-- webview.enable_caret_browsing -- Whether keyboard navigation should be enabled.
settings.webview.enable_developer_extras = true -- Whether developer tools should be enabled.
settings.webview.enable_dns_prefetching = true -- Whether domain names should be resolved speculatively. If enabled, DNS prefetching attempts to resolve domain names before any links are clicked, making web browsing faster.
-- webview.enable_frame_flattening -- Whether frame flattening should be enabled. If enabled, the content of all subframes is shown directly in the main page.
-- webview.enable_fullscreen -- Whether web pages should be allowed to request fullscreen display, via the JavaScript Fullscreen API.
-- webview.enable_html5_database -- Whether web pages should be allowed access to a client-side SQL databse. This provides structured data storage.
--                               -- Web pages from one site cannot access data stored in the database by pages from other sites.
-- 
-- webview.enable_html5_local_storage  -- Whether web pages should be allowed to access HTML5 local storage support. This provides a simple synchronous database.
--                                     -- Web pages from one site cannot access data stored in the database by pages from other sites.
-- 
-- webview.enable_hyperlink_auditing -- Whether hyperlink auditing is enabled. See https://html.spec.whatwg.org/multipage/links.html#hyperlink-auditing for more information.
-- webview.enable_java -- Whether the Java plugin is enabled.
-- webview.enable_javascript -- Whether JavaScript content is executed.
-- webview.enable_media_stream -- Whether to allow web pages to access audio and video devices for capture.
-- webview.enable_mediasource -- Whether MediaSource content is enabled.
-- webview.enable_page_cache -- Whether the page cache should be enabled. This speeds up forward/backward navigation considerably. Disabling this setting is only useful to conserve memory.
settings.webview.enable_plugins = true -- Whether plugins are enabled.
-- webview.enable_resizable_text_areas -- Whether text areas in web pages can be resized.
-- webview.enable_site_specific_quirks -- Whether WebKit should use site-specific quirks to work around websites with known compatibility issues.
settings.webview.enable_smooth_scrolling = true -- Whether smooth scrolling should be used.
-- webview.enable_spatial_navigation -- Whether spatial navigation should be enabled.

settings.webview.enable_tabs_to_links = true -- Whether pressing the Tab key on the web page should cycle through link elements.
-- webview.enable_webaudio -- Whether support for WebAudio should be enabled.
-- webview.enable_webgl -- Whether support for WebGL should be enabled.
-- webview.enable_write_console_messages_to_stdout -- Whether console messages from JavaScript should be written to standard output.
-- webview.enable_xss_auditor -- Whether XSS auditing should be enabled. This helps protect against some attacks on vulnerable websites.
-- webview.fantasy_font_family -- The font family used for content using the fantasy font.
-- webview.hardware_acceleration_policy -- The policy used to determine when hardware acceleration should be used to render web content.
-- webview.javascript_can_access_clipboard -- Whether JavaScript should be able to access the clipboard.
-- webview.javascript_can_open_windows_automatically -- Whether JavaScript can open windows without user intervention.
-- webview.media_playback_allows_inline -- Whether media playback is allowed in an inline window; the alternative is fullscreen playback.
-- webview.media_playback_requires_gesture -- Whether a user gesture is required before media playback/loading can start.
-- webview.minimum_font_size -- The minimum font size (in pixels) at which text should be rendered.
settings.webview.monospace_font_family = "Inconsolata" -- The font family used for content using a monospace font.
-- webview.pictograph_font_family  -- The font family used for content using the pictograph font.
-- webview.print_backgrounds -- Whether background images should be shown when printing a web page.

settings.webview.sans_serif_font_family = "DejaVu Sans" -- The font family used for content using a sans-serif font.
settings.webview.serif_font_family = "DejaVu Sans" -- The font family used for content using a serif font.

-- The user agent used when making HTTP requests. If left blank, the default WebKit user agent is used.
settings.webview.user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Krome/88.0.4896.127 Serominers/209.25" 

-- webview.zoom_level -- The default zoom level, as a percentage, at which to draw content.

-- window.act_on_synthetic_keys -- Whether synthetic key events should activate key bindings. Synthetic key events have been generated by a program rather than a physical key press, such as those sent by keysym.send().
-- window.check_filepath -- Whether opening a URI should check for local files.
settings.window.close_with_last_tab = true -- Luakit windows should close after all of their tabs are closed.
-- window.default_search_engine -- The default search engine alias. Must be a key of window.search_engines.
-- window.home_page -- The URI of the home page.
-- window.load_etc_hosts -- Whether /etc/hosts should be used when parsing URIs.
-- window.max_title_len -- The maximum length of the window title.
-- window.new_tab_page -- The URI to open when opening a new tab.
-- window.new_window_size -- The size (in pixels) of newly-opened windows. Must be in the form WxY, where W and H are the width and height respectively.
-- window.reuse_new_tab_pages -- Let w:new_tab use an existing view that is on window.new_tab_page. Avoids unnecessarily creating new tabs, possibly multiple instances of window.new_tab_page.
-- window.scroll_step -- The size (in pixels) of the scroll step.
settings.window.search_engines = {
  ["aur"] = "https://aur.archlinux.org/packages?K=%s",
  ["google"] = "https://google.com/search?q=%s",
  ["wp"] = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
  ["ddg"] = "https://duckduckgo.com/?q=%s",
  ["default"] = "google",
}
settings.window.default_search_engine = "google"

-- The set of search engine shortcuts.
-- 
-- Key	Value
-- aur	https://aur.archlinux.org/packages?K=%s
-- ddg	https://duckduckgo.com/?q=%s
-- default	https://google.com/search?q=%s
-- duckduckgo	https://duckduckgo.com/?q=%s
-- github	https://github.com/search?q=%s
-- google	https://google.com/search?q=%s
-- imdb	http://www.imdb.com/find?s=all&q=%s
-- wikipedia	https://en.wikipedia.org/wiki/Special:Search?search=%s
-- window.zoom_step -- The size of the zoom step, expressed as a multiplicative factor.