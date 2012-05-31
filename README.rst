.. README.rst                                 
.. Create: 2012-05-25
.. Update: 2012-06-01


INTRO
=====

This is config files for awesome wm (on ArchLinux)

* rc.lua
    basic setting

        - Terminal : ``urxvt``
        - Editor   : gvim
        - ModKey   : "Mod4"(Win Key)
        - Music Player : mpd  (need ``mpc``)
        - icon_path = "/usr/share/icons/Faenza/"

    some keybindings

        - Mod4 + Page_Up/Page_Down : Volume control (need ``pamixer``)
        - Mod4 + Home/End  : mpc  prev / next
        - Mod4 + inset/delete : mpc  toggle /  volumne toggle
        - Mod4 + Shift + Left(P)/Right(N) : move client to next/prev tag.
        - Mod4 + `   : Minimize
        - Mod4 + Ctrl+`   : UnMinimize
        - Mod4 + Space: Maxmize Toggle
        - Mod4 + Ctrl+Space :FullScreen Toggle
        - Mod4 + f :Floating client Toggle
        - Mod4 + r :redraw client
        - Mod4 + q :close client
        - Mod4 + F1~F12: lauch apps
        - Removed maps:
            * Mod4 + x
            * Mod4 + m

    some widgets (need the awesome submodule ``vicious``) showing tooltips.

        - Volume:add volume control 
            - scroll-down/up(vol decrease/increase)
        - CPU:show CPU details in tooltip
        - Mem:show Mem details in tooltip
        - Uptime

    bottom panel

        - Mpd: add mpd control 
            - scroll-down/up(next/prev)
            - left-click(toggle)
            - right-click(stop)
        - Lrc: showing current lyrics (need ``lrcdis``)
            - left-click(show full lyric) (need ``mpdlyrics``)

    some autostart programs. (last part of ``rc.lua``)

    some app in menu. (with icon_path)

    add shutdown/rebooot/suspend/hibernate in menu
    (need ``dbus`` and ``consolekit``, also ``exec ck-launch-session``  in .xinitrc)

* theme.lua
    - changed some color settings.
    - ignored Wallpaper: set it in your .xinitrc 

USE IT
======

* install ::

   git clone git://github.com/Rykka/awesome.git ~/.config/awesome
   cd ~/.config/awesome
   git submodule init
   git submodule update


* more settings
    see https://wiki.archlinux.org/index.php/Awesome

    - gtk-app themes and icons 
        see http://awesome.naquadah.org/wiki/Customizing_GTK_Apps

    - usb automounting 
        install ``udiskie`` package and add to startup.
