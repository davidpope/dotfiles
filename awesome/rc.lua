-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

require("obvious.popup_run_prompt")

require("vain")
vain.widgets.terminal = "gnome-terminal"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

local function notify_shortcuts()
    naughty.notify({ preset = naughty.config.presets.normal,
                     title = "AwesomeWM Keyboard Shortcuts",
                     text = root.keys() })
end

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init( awful.util.getdir("config") .. "/themes/solarized-dark/theme.lua" )
beautiful.init( awful.util.getdir("config") .. "/themes/custom/theme.lua" )

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
browser = "x-www-browser"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    vain.layout.termfair,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    vain.layout.browse,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names =   {  "1-Code",   "2-Code",   "3-Shells", "4-Browse", "5-Fullscreen", "6-Fullscreen", "7-Other",  "8-Other",  "9-IM" },
    layouts = {  layouts[1], layouts[1], layouts[1], layouts[5], layouts[4],     layouts[4],     layouts[2], layouts[2], layouts[2] },
    nmasters = { 3,          3,          3,          1,          1,              1,              1,          1,          1 },
    nminrows = { 1,          1,          2,          2,          1,              1,              1,          1,          1 },
    mwfacts =  { nil,        nil,        nil,        0.75,       nil,            nil,            nil,        nil,        nil }
}
for s = 1, screen.count() do
    local screen_width = screen[s].workarea.width
    -- Each screen has its own tag table.
    -- tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    local scr_tags = awful.tag(tags.names, s, tags.layouts)
    for t = 1, #scr_tags do
        -- this is clumsy but no time for learning LUA right now
        local nmasters = tags.nmasters[t]
        if nmasters > 1 and screen_width < 2000 then
            nmasters = nmasters - 1
        end
        awful.tag.setnmaster(nmasters, scr_tags[t])
        awful.tag.setncol(tags.nminrows[t], scr_tags[t])
        if not tags.mwfacts[t] == nil then
            awful.tag.setmwfact(tags.mwfacts[t], scr_tags[t])
        end
    end
    tags[s] = scr_tags
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mystatusbar = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width = 250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

    -- make space for conky to draw to root
    -- mooched from http://awesome.naquadah.org/wiki/Conky_bar
    mystatusbar[s] = awful.wibox({
        position = "bottom",
        screen = s,
        ontop = false,
        width = 1,
        height = 16
    })
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

keyhelp = {}
keyhelp.config = {
    viewer = browser or "x-www-browser",
    chromeless_prefix = ""  -- set to "--app=" if you use Chrome
}

-- Hand-rolled tempfile so we can reference the filename;
-- this also lets us put it in the .cache directory
function keyhelp_open_temp_file(template)
    local handle
    local fname
    assert(string.match(template, "@@@"), 
        "ERROR open_temp_file: template must contain \"@@@\".")
    while true do
        nocollide = tostring(math.random(10000000,99999999))
        fname = string.gsub(template, "@@@", nocollide)
        handle = io.open(fname, "r")
        -- minor race condition, shrug
        if not handle then
            handle = assert(io.open(fname, "w"))
            break
        end
        io.close(handle)
    end
    return handle, fname
end

-- ... but Lua doesn't clean up our hand-rolled temp files for us
awesome.add_signal("exit", function ()
    to_delete = awful.util.getdir("cache") .. "/helpkeys*.html"
    os.execute("/usr/bin/env $SHELL -c \"rm " .. to_delete .. "\"")
end)


-- TODO: move this
keyhelp.config.chromeless_prefix = "--app="

keyhelp.launch = function ()
    local f, filename
    local fname_templ = awful.util.getdir("cache") .. "/helpkeys@@@.html"
    f, filename = keyhelp_open_temp_file(fname_templ)
    print("f, fn: " .. tostring(f) .. ", " .. filename)
    keyhelp.gen_key_markup(f, keyhelp.keys_src)
    f:flush()
    f:close()
    local chrome_switch = ""
    local launch_str = keyhelp.config.viewer .. " " ..
                       keyhelp.config.chromeless_prefix ..
                       "\"file://" .. filename .. "\""
    awful.util.spawn(launch_str)
end

keyhelp.util = {
    filter = function (t, pred)
        local ret = {}
        local j = 1
        for _, v in ipairs(t) do
            if pred(v) then
                ret[j] = v
                j = j + 1
            end
        end
        return ret
    end,
    in_table = function(t, v)
        for _, value in ipairs(t) do
            if v == value then return true end
        end
        return false
    end,
}

keyhelp.init = function(keys_src)

    keyhelp.keys_src = keys_src

    local allkeys_src = {}
    for i, group in ipairs(keys_src) do
        allkeys_src = awful.util.table.join(allkeys_src, group.bindings)
    end

    local ck_src = keyhelp.util.filter(
                       allkeys_src,
                       function(k) return k["binding_type"] == "client" end)

    local clientkeys = {}
    for _, v in ipairs(ck_src) do
        clientkeys = awful.util.table.join(clientkeys,
                                           awful.key(v["modifiers"],
                                                     v["key"],
                                                     v["func"]))
    end

    local gk_src = keyhelp.util.filter(
                       allkeys_src,
                       function(k) return k["binding_type"] == "global" end)

    local globalkeys = {}
    for _, v in ipairs(gk_src) do
        globalkeys = awful.util.table.join(globalkeys,
                                           awful.key(v["modifiers"],
                                                     v["key"],
                                                     v["func"]))
    end

    return clientkeys, globalkeys
end

-- TODO: Lua probably has a template library I could use
keyhelp.gen_key_markup = function (fh, keys_src)
    css_file = "file://" .. awful.util.getdir("config") .. "/keyhelp/styles.css"
    fh:write("<html><head><title>Awesome Key Bindings</title><link rel=\"stylesheet\" type=\"text/css\" href=\"" .. css_file .."\">\n</head>\n")
    fh:write("<body>\n")
    fh:write("<h1>Awesome Key Bindings</h1>")
    for _, group in ipairs(keys_src) do
        fh:write("<div class='group'>\n")
        fh:write("<h2>" .. group.description .. "</h2>\n")
        fh:write("<div>")
        local i = 1
        for _, v in ipairs(group.bindings) do
            local line_class
            if i % 2 == 1 then
                line_class = "binding line"
            else
                line_class = "binding line-alt"
            end
            i = i + 1
            fh:write("<h3 class='" .. line_class .. "'>\n")
            fh:write("<div class='line-div'>")
            fh:write("<div class='descr'>" .. v.description .. "</div>")
            fh:write("<div class='mid'>&nbsp;</div>")
            fh:write("<div class='key'>")
            if v.binding_type == "special" then
                fh:write(v.display_text)
            else
                if keyhelp.util.in_table(v.modifiers, modkey) then fh:write("Super + ") end
                if keyhelp.util.in_table(v.modifiers, "Control") then fh:write("Control + ") end
                if keyhelp.util.in_table(v.modifiers, "Shift") then fh:write("Shift + ") end
                fh:write(string.upper(v.key))
            end
            fh:write("</div></div>\n</h3>\n")
        end
        fh:write("</div></div>\n")
    end
    fh:write("</body>\n</html>")
end

keys_src = {}

wm_keys_group = {}
wm_keys_group.description = "Window manager control"
wm_keys_group.bindings = {
    {
        description = "Restart awesome",
        modifiers = { modkey, "Control" },
        key = "r",
        func = awesome.restart,
        binding_type = "global",
    },
    {
        description = "Quit awesome",
        modifiers = { modkey, "Shift" },
        key = "q",
        func = awesome.quit, 
        binding_type = "global",
    },
    {
        description = "Run Lua code prompt",
        modifiers = { modkey },
        key = "x",
        func = function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end,
        binding_type = "global",
    },
    {
        description = "Run prompt",
        modifiers = { modkey },
        key = "r",
        func = function ()
            obvious.popup_run_prompt.run_prompt()
        end,
        --bindings = awful.key({ modkey }, "r",
        --    function ()
        --        mypromptbox[mouse.screen]:run()
        --    end
        --),
        binding_type = "global",
    },
    {
        description = "Spawn terminal emulator",
        modifiers = { modkey },
        key = "Return",
        func = function ()
            awful.util.spawn(terminal)
        end,
        binding_type = "global",
    },
    {
        description = "Open main menu",
        modifiers = { modkey },
        key = "w",
        func = function ()
            mymainmenu:show({keygrabber = true})
        end,
        binding_type = "global",
    },
}

clients_keys_group = {}
clients_keys_group.description = "Clients"
clients_keys_group.bindings = {
    {
        description = "Redraw the focused window",
        modifiers = { modkey, "Shift" },
        key = "r",
        func = function (c)
            c:redraw()
        end,
        binding_type = "client",
    },
    {
        description = "Maximize client",
        modifiers = { modkey },
        key = "m",
        func = function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end,
        binding_type = "client",
    },
    {
        description = "Minimize client",
        modifiers = { modkey },
        key = "n",
        func = function (c)
           -- The client currently has the input focus, so it cannot be
           -- minimized, since minimized clients can't have the focus.
           c.minimized = true
        end,
        binding_type = "client",
    },
    {
        description = "Restore client",
        modifiers = { modkey, "Control" },
        key = "n",
        func = awful.client.restore,
        binding_type = "global",
    },
    {
        description = "Set client fullscreen",
        modifiers = { modkey },
        key = "f",
        func = function (c)
            c.fullscreen = not c.fullscreen
        end,
        binding_type = "client",
    },
    {
        description = "Kill focused client",
        modifiers = { modkey, "Shift" },
        key = "c",
        func = function (c)
            c:kill()
        end,
        binding_type = "client",
    },
    {
        description = "Set client on-top",
        modifiers = { modkey },
        key = "t",
        func = function (c)
            c.ontop = not c.ontop
        end,
        binding_type = "client",
    },
}

nav_keys_group = {}
nav_keys_group.description = "Navigation"
nav_keys_group.bindings = {
    {
        description = "Focus next client",
        modifiers = { modkey },
        key = "j",
        func = function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end,
        binding_type = "global",
    },
    {
        description = "Focus previous client",
        modifiers = { modkey },
        key = "k",
        func = function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end,
        binding_type = "global",
    },
    {
        description = "Focus first urgent client",
        modifiers = { modkey },
        key = "u",
        func = awful.client.urgent.jumpto, 
        binding_type = "global",
    },
    {
        description = "View previous tag",
        modifiers = { modkey },
        key = "Left",
        func = awful.tag.viewprev,
        binding_type = "global",
    },
    {
        description = "View next tag",
        modifiers = { modkey },
        key = "Right",
        func = awful.tag.viewnext,
        binding_type = "global",
    },
    {
        description = "Switch to tag 1-9",
        display_text = "Super + 1-9",
        binding_type = "special",
    },
    {
        description = "Focus next screen",
        modifiers = { modkey, "Control" },
        key = "j",
        func = function ()
            awful.screen.focus_relative(1)
        end,
        binding_type = "global",
    },
    {
        description = "Focus previous screen",
        modifiers = { modkey, "Control" },
        key = "k",
        func = function ()
            awful.screen.focus_relative(-1)
        end,
        binding_type = "global",
    },
    {
        description = "Focus previously selected tag set",
        modifiers = { modkey },
        key = "Escape",
        func = awful.tag.history.restore,
        binding_type = "global",
    },
}

layout_keys_group = {}
layout_keys_group.description = "Layout modifications"
layout_keys_group.bindings = {
    {
        description = "Switch client with next client",
        modifiers = { modkey, "Shift" },
        key = "j",
        func = function ()
            awful.client.swap.byidx(1)
        end,
        binding_type = "global",
    },
    {
        description = "Switch client with previous client",
        modifiers = { modkey, "Shift" },
        key = "k",
        func = function ()
            awful.client.swap.byidx(-1)
        end,
        binding_type = "global",
    },
    {
        description = "Send client to next screen",
        modifiers = { modkey },
        key = "o",
        func = awful.client.movetoscreen,
        binding_type = "client",
    },
    {
        description = "Decrease master width factor by 5%",
        modifiers = { modkey },
        key = "l",
        func = function ()
            awful.tag.incmwfact( 0.05)
        end,
        binding_type = "global",
    },
    {
        description = "Increase master width factor by 5%",
        modifiers = { modkey },
        key = "h",
        func = function ()
            awful.tag.incmwfact(-0.05)
        end,
        binding_type = "global",
    },
    {
        description = "Increase number of master windows by 1",
        modifiers = { modkey, "Shift" },
        key = "h",
        func = function ()
            awful.tag.incnmaster(1)
        end,
        binding_type = "global",
    },
    {
        description = "Decrease number of master windows by 1",
        modifiers = { modkey, "Shift" },
        key = "l",
        func = function ()
            awful.tag.incnmaster(-1)
        end,
        binding_type = "global",
    },
    {
        description = "Increase number of columns for non-master windows by 1",
        modifiers = { modkey, "Control" },
        key = "h",
        func = function ()
            awful.tag.incncol(1)
        end,
        binding_type = "global",
    },
    {
        description = "Decrease number of columns for non-master windows by 1",
        modifiers = { modkey, "Control" },
        key = "l",
        func = function ()
            awful.tag.incncol(-1)
        end,
        binding_type = "global",
    },
    {
        description = "Switch to next layout",
        modifiers = { modkey },
        key = "space",
        func = function ()
            awful.layout.inc(layouts, 1)
        end,
        binding_type = "global",
    },
    {
        description = "Switch to previous layout",
        modifiers = { modkey, "Shift" },
        key = "space",
        func = function ()
            awful.layout.inc(layouts, -1)
        end,
        binding_type = "global",
    },
    {
        description = "Toggle client floating status",
        modifiers = { modkey, "Control" },
        key = "space",
        func = awful.client.floating.toggle,
        binding_type = "client",
    },
    {
        description = "Swap focused client with master",
        modifiers = { modkey, "Control" },
        key = "Return",
        func = function (c)
            c:swap(awful.client.getmaster())
        end,
        binding_type = "client",
    },
    {
        description = "Toggle tag view",
        display_text = "Super + Control + 1-9",
        binding_type = "special",
    },
    {
        description = "Tag client with tag",
        display_text = "Super + Shift + 1-9",
        binding_type = "special",
    },
    {
        description = "Toggle tag on client",
        display_text = "Super + Shift + Control + 1-9",
        binding_type = "special",
    },
    {
        description = "Tag marked clients with tag",
        display_text = "Super + Shift + F1-9",
        binding_type = "special",
    },
}

custom_keys_group = {}
custom_keys_group.description = "Custom"
custom_keys_group.bindings = {
    {
        description = "Show this help",
        modifiers = { modkey, "Shift" },
        key = "/",
        func = function()
            keyhelp.launch()
        end,
        binding_type = "global",
    },
    {
        description = "Launch browser",
        modifiers = { modkey },
        key = "i",
        func = function()
            awful.util.spawn(browser)
        end,
        binding_type = "global",
    },
}



my_keys = {}
my_keys[1] = wm_keys_group
my_keys[2] = clients_keys_group
my_keys[3] = nav_keys_group
my_keys[4] = layout_keys_group
my_keys[5] = custom_keys_group

clientkeys, globalkeys = keyhelp.init(my_keys)


-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "X-www-browser" },
      properties = { floating = false } },
    { rule = { class = "Hipchat" },
      callback = function(c)
                     awful.client.movetotag(tags[mouse.screen][9], c)
                 end }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
