.. README.rst                                 
.. Create: 2012-05-25
.. Update: 2012-05-30


INTRO
=====

config file for awesome wm

* rc.lua
    basic setting

        - terminal : urxvt
        - editor   : gvim
        - wallpaper: ignored. set it in your .xinitrc
        - ModKey   : "Mod4"(Win Key)
    
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
        - Mod4+r :redraw client
        - Mod4+q :close client
        - Alt+F4 :close client
        - Mod4+F1~F12: lauch apps

    some widgets (need vicious) showing tooltips.

        - Volume
            add volume control: scroll-down/up(vol decrease/increase)
        - Mpd 
            add mpd control and lyric showing (with mpdlyrics)
                scroll-down/up(next/prev)
                left-click(lyric)
                right-click(toggle)
        - CPU
            show CPU details in tooltip
        - Mem
            show Mem details in tooltip
        - Uptime

    some autostart programs.

    some app in menu. (using Faenza icon set)

    
    add shutdown/rebooot/suspend/hibernate in menu
    (need dbus and exec ck-lauch-session in .xinitrc)

* theme.lua
    changed some color setting and border width.


USE IT
======

* install::

   git clone git://github.com/Rykka/awesome.git ~/.config/awesome
   cd ~/.config/awesome
   git submodule init
   git submodule update


* more settings
    see https://wiki.archlinux.org/index.php/Awesome

    - gtk-app themes and icons 
        see http://awesome.naquadah.org/wiki/Customizing_GTK_Apps

    - usb automounting , install ``udiskie`` package and add to startup.
