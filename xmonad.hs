import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86


-- launch XMonad with a status bar and overridden configuration
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig


-- general configuration with keyboard customisation
myConfig = defaultConfig
  { modMask         = myModMask
  , terminal        = myTerminal
  , startupHook     = myStartupHook
  , layoutHook      = myLayout
  } `additionalKeys`

  -- launch dmenu
  [ ((myModMask,                xK_p     ), spawn "dmenu_run                           -b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-16:bold'")
  -- launch j4-dmenu-desktop
  , ((myModMask .|. shiftMask,  xK_p     ), spawn "j4-dmenu-desktop --dmenu=\"dmenu -i -b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-16:bold'\"")

  -- volume control
  , ((noModMask,                xF86XK_AudioMute        ), spawn "pulseaudio-ctl mute")
  , ((noModMask,                xF86XK_AudioLowerVolume ), spawn "pulseaudio-ctl down")
  , ((noModMask,                xF86XK_AudioRaiseVolume ), spawn "pulseaudio-ctl up")
  , ((noModMask,                xF86XK_AudioMicMute     ), spawn "pulseaudio-ctl mute-input")

  -- brightness controls
  , ((noModMask,                xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10%")
  , ((noModMask,                xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 10%")

  -- twiddle displays
  , ((noModMask,                xF86XK_Display          ), spawn "~/bin/autoDetectDisplays.sh && /etc/X11/xinit/xinitrc.d/z-laptop-dpi.sh && xmonad --restart")
  , ((myModMask .|. shiftMask,  xK_y                    ), spawn "~/bin/autoDetectDisplays.sh && /etc/X11/xinit/xinitrc.d/z-laptop-dpi.sh && xmonad --restart")

  -- lock the screen
  , ((myModMask .|. shiftMask,  xK_l     ), spawn "xautolock -locknow")

  -- take screenshots
  , ((noModMask,                xK_Print ), spawn "sleep 0.2; cd /tmp && scrot -s -e 'xdg-open $f >/dev/null 2>&1 &'")
  , ((myModMask,                xK_Print ), spawn "           cd /tmp && scrot    -e 'xdg-open $f >/dev/null 2>&1 &'")
  ]


-- status bar
myBar = "xmobar"
myPP = xmobarPP -- http://code.haskell.org/XMonadContrib/
  { ppCurrent   = xmobarColor "green" "" . wrap "<" ">"
  , ppVisible   = xmobarColor "yellow" "" . wrap "(" ")"
  , ppSep       = "   "
  , ppTitle     = xmobarColor "green" ""
  }
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b) -- need to get rid of this....


-- startup
myStartupHook = do

  -- bad old java apps need this
  setWMName "LG3D"

  -- stalonetray in top right, not a strut
  spawn "which stalonetray > /dev/null 2>&1 && (pkill stalonetray ; stalonetray &)"
  
  -- lock the screen after 5 mins, using slock as the "locker"
  spawn "which xautolock > /dev/null 2>&1 && (pkill xautolock ; xautolock -locker slock -time 5 &)"

  -- applets/system tray apps
  spawn "which pasystray > /dev/null 2>&1 && (pkill pasystray ; pasystray &)"
  spawn "which nm-applet > /dev/null 2>&1 && (pkill nm-applet ; nm-applet &)"


-- layouts
myLayout = Tall nmaster delta ratio ||| Full
  where
     -- number of windows in the master pane
     nmaster = 1

     -- proportion of screen occupied by master pane
     ratio   = 3/5 -- default 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100


-- misc
myModMask   = mod4Mask -- Super_L
myTerminal  = "gnome-terminal"

-- missing from Graphics.X11.ExtraTypes.XF86
xF86XK_AudioMicMute     :: KeySym
xF86XK_AudioMicMute     = 0x1008ffb2
