-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

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
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "/themes/default/theme.lua")
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "xresources")
beautiful.init(theme_path)
beautiful.useless_gap = 25

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
-- The ones I don't care for are commented out but saved for future reference
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.corner.nw,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.spiral,
    --awful.layout.suit.floating,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar

-- Mocp widget
mocpwidget = awful.widget.watch({ "bash", "-c", "mocp -i | grep Title | sed -n 1p | cut -f 2- -d ' '" }, 1)

-- CPU widget
cpuwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.cpu)
vicious.register(cpuwidget, vicious.widgets.cpu, " $1%  CPU   |  ", 10)

-- Memory widget
memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget,vicious.widgets.mem, " $1%  RAM   |  ", 1)

-- Network usage widget
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, " ${enp2s0 up_kb} kb ↑  ${enp2s0 down_kb} kb ↓   |  ", 1)

---- Internal IP widget
ipwidget = awful.widget.watch({ "bash", "-c", "ifconfig | grep enp2s0 -A 1 | sed -n 2p | awk '{print $2}'" }, 10)

-- Disk space widget
diskwidget = wibox.widget.textbox()
vicious.register(diskwidget, vicious.widgets.fs, " ${/ used_gb} gb / ${/ size_gb} gb   |  ")

-- Date widget
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, " %A  -  %Y-%m-%d  -  %H:%M:%S  (%Z)  ", 1)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    -- Uncomment if you want such a thing
--    s.mytasklist = awful.widget.tasklist {
--        screen  = s,
--        filter  = awful.widget.tasklist.filter.currenttags,
--        buttons = tasklist_buttons
--    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
	    wibox.widget.textbox('   |   '),
            mocpwidget,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout,
            --wibox.widget.systray(),
	    cpuwidget,
	    memwidget,
	    ipwidget,
	    wibox.widget.textbox('   |   '),
	    netwidget,
	    diskwidget,
	    datewidget,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
-- The only mouse binding that is conceivable useful and not annoying; the others were purged without regret
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

	-- Keybinds to launch various applications, and two to run useful commands. 
	-- References the script titled launcher in the repo, can be easily modified, 
	-- or new applications can be easily added
    awful.key({ modkey, "Control" }, "w", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --firefox", false) 
    	end, { description = "Launch Firefox", group = "launcher" }),
    awful.key({ modkey, "Shift", "Control" }, "w", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --tor", false) 
    	end, { description = "Launch Tor", group = "launcher" }),
    awful.key({ modkey, "Control" }, "s", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --signal", false) 
    	end, { description = "Launch Signal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "d", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --discord", false) 
    	end, { description = "Launch Discord", group = "launcher" }),
    awful.key({ modkey, "Control" }, "e", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --mirage", false) 
    	end, { description = "Launch Mirage (Matrix)", group = "launcher" }),
    awful.key({ modkey, "Control" }, "v", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --jitsi", false) 
    	end, { description = "Launch Jitsi", group = "launcher" }),
    awful.key({ modkey, "Control" }, "a", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --keepass", false) 
    	end, { description = "Launch KeePassXC", group = "launcher" }),
    awful.key({ modkey, "Control" }, "p", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --python", false) 
    	end, { description = "Launch Python", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --r", false) 
    	end, { description = "Launch R", group = "launcher" }),
    awful.key({ modkey }, "\\", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --stop", false) 
    	end, { description = "Enter self-destruct mode", group = "System" }),
    awful.key({ modkey, "Shift", "Control" }, "Delete", 
    	function () 
	    awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --poweroff", false) 
    	end, { description = "Power off computer", group = "System" }),

	-- Control mocp (music player)
    awful.key({ modkey, "Shift", "Control" }, "m", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --search", false)
        end, { description = "Search for music in ranger", group = "Music" }),
    awful.key({ modkey }, "space", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --pause", false)
        end, { description = "Toggle pause on mocp", group = "Music" }),
    awful.key({ modkey }, "p", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --play", false)
        end, { description = "Begin playlist on mocp", group = "Music" }),
    awful.key({ modkey }, "n", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --next", false)
        end, { description = "Move to next track on mocp", group = "Music" }),
    awful.key({ modkey, "Shift" }, "n", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --previous", false)
        end, { description = "Move to previous track on mocp", group = "Music" }),
    awful.key({ modkey }, "Right", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --seek+", false)
        end, { description = "Seek forward on current track", group = "Music" }),
    awful.key({ modkey }, "Left", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/mocp.sh --seek-", false)
        end, { description = "Seek backwards on current track", group = "Music" }),

	-- Keybinds to record screen/webcam
    awful.key({ modkey, "Control" }, "Print", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/launcher.sh --record", false)
        end, { description = "Record screen/webcam", group = "Recording" }),

	-- Keybinds to take screenshots. 
	-- References the screenshot script in the repo. 
    awful.key({ }, "Print", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/screenshot.sh", false)
        end, { description = "Make screenshot of fullscreen", group = "Screenshot" }),
    awful.key({ "Shift" }, "Print", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/screenshot.sh --select", false)
        end, { description = "Make screenshot of selected area", group = "Screenshot" }),
    awful.key({ modkey }, "Print", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/screenshot.sh --active", false)
        end, { description = "Make screenshot of active window", group = "Screenshot" }),

	-- Random background
    awful.key({ modkey, "Control" }, "b", nil,
        function()
            awful.util.spawn(gears.filesystem.get_configuration_dir() .. "scripts/fehbg", false)
        end, { description = "Change to random wallpaper", group = "Wallpaper" }),

	--Because minimalism
    awful.key({ modkey }, "b",
              function ()
                  myscreen = awful.screen.focused()
                  myscreen.mywibox.visible = not myscreen.mywibox.visible
              end,
              {description = "toggle statusbar"}
    ),

    -- Various default stuff
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control" }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, "Control" }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Moving between clients on a given screen
    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Moving clients around
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    -- Switching screens (monitors)
    awful.key({ modkey, "Control" }, "l", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "h", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    -- Other movements
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard stuff
    awful.key({ modkey, "Control" }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control", "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "Delete", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Resizing clients
    awful.key({ modkey }, "l",     function () awful.tag.incmwfact( 0.01)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey }, "h",     function () awful.tag.incmwfact(-0.01)          end,
              {description = "decrease master width factor", group = "layout"}),

    -- Modifying stack
    awful.key({ modkey, "Shift"   }, ".",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, ",",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    -- Moving clients across screens (monitors)
    awful.key({ modkey, "Control" }, ".",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, ",",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    -- Switch layouts
    awful.key({ modkey, "Control", "Shift" }, "h", function () awful.layout.set(awful.layout.suit.tile)                end,
              {description = "move master to left", group = "layout"}),
    awful.key({ modkey, "Control", "Shift" }, "l", function () awful.layout.set(awful.layout.suit.tile.left)                end,
              {description = "move master to right", group = "layout"}),
    awful.key({ modkey, "Control", "Shift" }, "j", function () awful.layout.set(awful.layout.suit.tile.top)               end,
              {description = "move master to top", group = "layout"}),
    awful.key({ modkey, "Control", "Shift" }, "k", function () awful.layout.set(awful.layout.suit.tile.bottom)                end,
              {description = "move master to bottom", group = "layout"}),
    awful.key({ modkey, "Control", "Shift" }, "i", function () awful.layout.set(awful.layout.suit.corner.nw)                end,
              {description = "move master to corner", group = "layout"}),

    -- Pull up minimized clients on the tag
    awful.key({ modkey, "Shift" }, "Up",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Call the run prompt
    awful.key({ modkey, "Shift" }, "space", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    -- Call the menubar (much like an application manager but minimalist)
    awful.key({ modkey, "Control" }, "space", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

-- Full screen
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    -- Close client
    awful.key({ "Control"   }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),

    -- If you want floating for some reason
    awful.key({ modkey, "Control", "Shift" }, "f",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    -- Swap focused client with master
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    -- Move client to another screen (monitor)
    -- If your screens are more intelligently numbered than mine, you will probably want to swap these
    awful.key({ modkey, "Shift" }, "l",      function (c) c:move_to_screen(2) end,
              {description = "move to screen 1 (right)", group = "client"}),
    awful.key({ modkey, "Shift" }, "h",      function (c) c:move_to_screen(1) end,
              {description = "move to screen 2 (left)", group = "client"}),
    --awful.key({ modkey }, "o",      function (c) c:move_to_screen() end,
    --          {description = "move to other screen", group = "client"}),

    -- For when you really need to see something
    awful.key({ modkey }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),

    -- Minimize focused client
    awful.key({ modkey, "Shift"   }, "Down",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    -- Creative client maximization
    awful.key({ modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,

    	-- Volume controls
  	awful.key(
  	  {},
  	  'XF86AudioRaiseVolume',
  	  --volume_widget.raise
	  function () awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +0.1%") end
  	),
  	awful.key(
  	  {},
  	  'XF86AudioLowerVolume',
  	  --volume_widget.lower
	  function () awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -0.1%") end
  	),
  	awful.key(
  	  {},
  	  'XF86AudioMute',
  	  --volume_widget.toggle
	  function () awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end

  	),

        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Keypress + mouseclick stuff
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = 0.5,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- For those clients that MUST float
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "veromix",
	  "XTerm",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true, x = 700, y = 300 } },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- VLC always opens on screen 1 (right), tag 1
    { rule = { class = "vlc" },
    	properties = { screen = 2, tag = "1" } },

    { rule = { class = "wine" },
    	properties = { screen = 1, tag = "1", maximized = true } },

    { rule = { class = "Firefox" },
	properties = { maximized = false, floating = false } },

    { rule = { name = "music && ranger" },
	properties = { x = 500, y = 100, width = 800, height = 800 } },

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- If you want your clients to have titlebars, uncomment this block

-- Add a titlebar if titlebars_enabled is set to true in the rules.
--client.connect_signal("request::titlebars", function(c)
--    -- buttons for the titlebar
--    local buttons = gears.table.join(
--        awful.button({ }, 1, function()
--            c:emit_signal("request::activate", "titlebar", {raise = true})
--            awful.mouse.client.move(c)
--        end),
--        awful.button({ }, 3, function()
--            c:emit_signal("request::activate", "titlebar", {raise = true})
--            awful.mouse.client.resize(c)
--        end)
--    )
--
--    awful.titlebar(c) : setup {
--        { -- Left
--            awful.titlebar.widget.iconwidget(c),
--            buttons = buttons,
--            layout  = wibox.layout.fixed.horizontal
--        },
--        { -- Middle
--            { -- Title
--                align  = "center",
--                widget = awful.titlebar.widget.titlewidget(c)
--            },
--            buttons = buttons,
--            layout  = wibox.layout.flex.horizontal
--        },
--        { -- Right
--            awful.titlebar.widget.floatingbutton (c),
--            awful.titlebar.widget.maximizedbutton(c),
--            awful.titlebar.widget.stickybutton   (c),
--            awful.titlebar.widget.ontopbutton    (c),
--            awful.titlebar.widget.closebutton    (c),
--            layout = wibox.layout.fixed.horizontal()
--        },
--        layout = wibox.layout.align.horizontal
--    }
--end)

-- This is super annoying but maybe someone has a use for it

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    c:emit_signal("request::activate", "mouse_enter", {raise = false})
--end)
}

-- {{ Transparency (the stuff in the comments of the conditional aren't quite working out yet)
client.connect_signal("focus", function(c)
                        c.border_color = beautiful.border_focus
			if c.class ~= "vlc" 
				and c.class ~="Wine"
				--and c.maximized 
				--and c.fullscreen 
				then c.opacity = 0.95
			end
end)
client.connect_signal("unfocus", function(c)
                        c.border_color = beautiful.border_normal
			if c.class ~= "vlc"
				and c.class ~="Wine"
			 	then c.opacity = 0.85
			end
end)
-- }}

-- {{ Autorun programs
autorun = true
autorunApps = 
{
	"fehbg",
	"xcompmgr",
	"mocp -S",
	"pkill mailsync && mailsync",
	"unclutter -idle 1 -jitter 50"
}

if autorun then
	for app = 1, #autorunApps do
		awful.util.spawn(autorunApps[app])
	end
end
--}}

