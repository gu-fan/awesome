.. README.rst                                 
.. Create: 2012-05-25
.. Update: 2012-05-30


INTRO
=====

config file for awesome wm

* rc.lua
    some keybindings

        - Mod4+Page_Up / Page_Down : Volumne control (with pamixer)
        - Mod4+Home / End  : mpc  prev / next
        - Mod4+inset / delete : mpc  toggle /  volumne toggle
        - Mod4+Shift+Left(P) /Right(N) : move client to next/prev tag.
        - Mod4+`   : Minimize
        - Mod4+Ctrl+`   : UnMinimize
        - Mod4+Space: Maxmize
        - Mod4+Ctrl+Space :FullScreen
        - Mod4+f :Float client
        - Mod4+F1~F12: lauch apps

    some widgets (vicious)

        - Volume
           add volume control
        - Mpd 
           add mpd control and lyric showing (with mpdlyrics)
        - CPU
        - Uptime

    some autostart programs.

    some app in menu
    
    add shutdown/rebooot/suspend/hibernate in menu
    (need dbus and exec ck-lauch-session in .xinitrc)

* theme.lua
    changed some color setting and border width.

* gtk-app themes and icons 
    see http://awesome.naquadah.org/wiki/Customizing_GTK_Apps

* and more
    see https://wiki.archlinux.org/index.php/Awesome

    for usb automounting , install udiskie package
