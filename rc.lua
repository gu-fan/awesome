-- Standard awesome library
-- /usr/share/awesome/
require("awful")
require("awful.autofocus")
require("awful.rules")
require("awful.tag")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require('vicious')

-- {{{ Functions

local sexec = awful.util.spawn_with_shell
local exec = awful.util.spawn
function rel_movetag(n) --{{{
    local screen = screen
    local scr = mouse.screen
    local query_tag  = awful.tag.selected()
    for i, t in ipairs(screen[query_tag.screen]:tags()) do
        if t == query_tag then
            if tags[scr][i+n] then
                awful.client.movetotag(tags[scr][i+n])
                awful.tag.viewidx(n)
            end
            break
        end
    end
end --}}}
function dbg(vars)
    local text = ""
    for i=1, #vars do text = text .. vars[i] .. " | " end
    naughty.notify({ text = text, timeout = 0 })
end
function icon (name,category)
    local category = category or "apps"
    return "/usr/share/icons/Faenza/".. category .."/32/"..name..".png"
end
background_timers = {}                                                             
                                                                                  
function run_background(cmd,funtocall)                                             
   local r = io.popen("mktemp")                                                   
   local logfile = r:read("*line")                                                
   r:close()                                                                      
                                                                                  
   cmdstr = cmd .. " &> " .. logfile .. " & "                                     
   local cmdf = io.popen(cmdstr)                                                  
   cmdf:close()                                                                   
   background_timers[cmd] = {                                                     
       file  = logfile,                                                           
       timer = timer{timeout=1}                                                   
   }                                                                              
   background_timers[cmd].timer:add_signal("timeout",function()                   
       local cmdf = io.popen("pgrep -f '" .. cmd .. "'")                          
       local s = cmdf:read("*all")                                                
       cmdf:close()                                                               
       if (s=="") then                                                            
           background_timers[cmd].timer:stop()                                    
           local lf = io.open(background_timers[cmd].file)                        
           funtocall(lf:read("*all"))                                             
           lf:close()
           io.popen("rm " .. background_timers[cmd].file)                                                            
       end                                                                        
   end)                                                                           
   background_timers[cmd].timer:start()                                           
end
-- }}}

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

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")
--beautiful.init("~/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
--editor = os.getenv("EDITOR") or "nano"
--editor_cmd = terminal .. " -e " .. editor
editor = "gvim"
editor_cmd = "gvim"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[8])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "&manual", editor_cmd .. " '+Man awesome'" },
   { "&edit config", editor_cmd .. " " .. awesome.conffile },
   { "&restart", awesome.restart },
   { "&quit", awesome.quit },
   { "---------", " " },
   { "sus&pend", 'dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend' },
   { "re&boot", 'dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart' ,  icon("system-log-out","actions")},
   --{ "sh&utdown", "gksudo halt" },
   { "sh&utdown", 'dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop' ,  icon("system-shutdown","actions")},
   --hibernate
   { "hibernate", 'dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate' },
   --dbus-send --system --print-reply --dest="org.freedesktop.DeviceKit.Power" /org/freedesktop/DeviceKit/Power org.freedesktop.DeviceKit.Power.Hibernate
   -- suspend
}
myappmenu = {
    { "&chrome"      , "google-chrome", icon("google-chrome")},
    { "&deluge"      , "deluge"      },
    { "&easystroke"  , "easystroke"  },
    { "&firefox"     , "firefox"      ,  icon("firefox")},
    { "&gvim"        ,  editor_cmd    ,  icon("gvim")},
    { "goldendict"   , "goldendict"  },
    { "&libreoffice" , "libreoffice"  ,  icon("libreoffice-base")},
    { "&nautilus"    , "nautilus"     ,  icon("nautilus")},
    { "osdlyrics"    , "osdlyrics"   },
    { "&shutter"     , "shutter"      ,  icon("shutter")},
    { "&terminal"    ,  terminal      ,  icon("terminal")},
    { "&virtualbox"  , "virtualbox"  },
    { "&xchat"       , "xchat"       },
    { "subl"         , "subl"        },
    { "gimp"         , "gimp"        },
    { "mypaint"      , "mypaint"     },
}
mymainmenu = awful.menu({ items = { { "&system", myawesomemenu, beautiful.awesome_icon },
                                    { "----------", " "},
                                    { "&apps", myappmenu},
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
function span(text,color) --{{{
    color = color or  "Gold"
    return "<span foreground='".. color .."'> " .. text .. " </span>"
end --}}}
-- {{{ separator
local spacer = widget({ type = "textbox", name = "spacer" })
local separator = widget({ type = "textbox", name = "separator" })
spacer.text = "  "
separator.text = span("•","Gray")
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" },span("∡") .. " %H:%M ")
local calendar = nil
local offset = 0

function remove_calendar()
    if calendar ~= nil then
        naughty.destroy(calendar)
        calendar = nil
        offset = 0
    end
end

function add_calendar(inc_offset)
    local save_offset = offset
    remove_calendar()
    offset = save_offset + inc_offset
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + offset
    datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
    local cal = awful.util.pread("cal -m " .. datespec)
    cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
    calendar = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', "monospace", os.date("%a, %d %B %Y") .. "\n" .. cal),
        timeout = 0, hover_timeout = 0.5,
        width = 180,
    })
end
-- change clockbox for your clock widget (e.g. mytextclock)
mytextclock:add_signal("mouse::enter", function()
    add_calendar(0)
end)
mytextclock:add_signal("mouse::leave", remove_calendar)
--}}}
-- {{{ CPU load
local cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, 
function (widget ,args)
    return string.format(span("❖") .. "%02d-%02d-%02d-%02d",args[2],args[3],args[4],args[5])
end)
-- }}}
-- {{{ CPU temperature
--local thermalwidget = widget({ type = "textbox" })
--vicious.register(thermalwidget, vicious.widgets.thermal,  span("T:")  .. " $1°C", 20, "thermal_zone0")
-- }}}
-- {{{ Volume widget
local volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, span("♪")   ..  "$1%", 1,"Master")
volwidget:buttons(awful.util.table.join(
    awful.button({ }, 4, function()
        sexec("pamixer --increase 4")
    end),
    awful.button({ }, 5, function()
        sexec("pamixer --decrease 4")
    end)
))
-- }}}
-- {{{ Uptime
uptimewidget = widget({ type = "textbox" })
vicious.register(uptimewidget, vicious.widgets.uptime,
        function (widget, args)
            return string.format(span("⟳").." %02d:%02d ", args[2], args[3])
        end, 61)
--}}}
-- {{{ mpd
-- Initialize widget
local mpdwidget = widget({ type = "textbox" })
-- Register widget
-- FIXME: it could not catch the pause state
vicious.register(mpdwidget, vicious.widgets.mpd,
        function (widget, args)
            if args["{state}"] == "Stop"  then 
                return span("■") 
            else 
                return span("▸")   .. args["{Artist}"]..' - '.. args["{Title}"]
            end
        end ,10)
local lyric = nil
 
function remove_lyric()
    if lyric ~= nil then
        naughty.destroy(lyric)
        lyric = nil
    end
end

function add_lyric()
    remove_lyric()
    run_background("mpdlyrics -n",function(txt)                              
   lyric = naughty.notify({text=txt,
        timeout = 0, hover_timeout = nil,
        width = 300,height=1000,font="Verdana 12"})
end)
end
mpdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, add_lyric),
    awful.button({ }, 3, function()
        sexec("mpc toggle")
    end),
    awful.button({ }, 4, function()
        sexec("mpc prev")
    end),
    awful.button({ }, 5, function()
        sexec("mpc next")
    end)
))
--}}}
-- {{{ net
local netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net,
    function (widget, args)
        return span("▾")  .. string.format("%05.1f",args["{eth0 down_kb}"]) .. span("▴")  .. string.format("%05.1f",args["{eth0 up_kb}"])
    end )
--}}}
-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
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
                                                  instance = awful.menu.clients({ width=250 })
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
    ---- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        s == 1 and mysystray or nil,
        uptimewidget,
        mytextclock,
        volwidget,
        cpuwidget,
        netwidget,
        mpdwidget,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

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
globalkeys = awful.util.table.join(
    awful.key({ }, "Print", function () exec("shutter -f") end),
    awful.key({"Mod1" }, "Print", function () exec("shutter -w") end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "p",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "n",   awful.tag.viewnext       ),
    awful.key({ modkey, "Shift"   }, "p",       function () rel_movetag(-1) end),
    awful.key({ modkey, "Shift"   }, "n",       function () rel_movetag(1)  end),
    awful.key({ modkey, "Shift"   }, "Left",    function () rel_movetag(-1) end),
    awful.key({ modkey, "Shift"   }, "Right",   function () rel_movetag(1)  end),
    awful.key({ modkey,           }, "Escape",  awful.tag.history.restore),
    awful.key({ modkey,           }, "Page_Up",   function() sexec("pamixer --increase 4") end),   
    awful.key({ modkey,           }, "Page_Down", function() sexec("pamixer --decrease 4") end),
    awful.key({ modkey,           }, "Home",   function() sexec("mpc prev")   end),   
    awful.key({ modkey,           }, "End",    function() sexec("mpc next")   end),
    awful.key({ modkey,           }, "Insert", function() sexec("mpc toggle")   end),   
    awful.key({ modkey,           }, "Delete", function() sexec("pamixer --toggle-mute") end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ "Mod1","Shift"           }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "F1", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "F2", function () exec("gvim") end),
    awful.key({ modkey,           }, "F3", function () exec("firefox") end),
    awful.key({ modkey,           }, "F4", add_lyric ),
    awful.key({ modkey, "Shift"   }, "F4", remove_lyric ),
    awful.key({ modkey,           }, "F8", function () exec("nautilus") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "Down",  function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey,           }, "Up",    function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "`", awful.client.restore)

    -- Prompt
    --awful.key({ modkey, "Shift"   }, "r",     function () mypromptbox[mouse.screen]:run() end)

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "f",      awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "KP_Enter", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "`",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey, "Control" }, "space",  function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "space",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

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
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "goldendict" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
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

-- {{{ autosart
do
    local cmds = 
    { 
        "goldendict",
        "mpd",
        "easystroke",
        "dropboxd",
        "fcitx -r",
        "synapse",
        -- for automount usb disk
        "udiskie"
    }

    for _,prg in pairs(cmds) do
        awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
        --awful.util.spawn(i)
    end
end
-- }}}
