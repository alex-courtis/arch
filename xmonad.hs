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
  [ ((myModMask,                xK_p     ), spawn "dmenu_run                           -b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-18:bold'")
  -- launch j4-dmenu-desktop
  , ((myModMask .|. shiftMask,  xK_p     ), spawn "j4-dmenu-desktop --dmenu=\"dmenu -i -b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-18:bold'\"")

  -- volume control
  , ((noModMask,                xF86XK_AudioMute        ), spawn "pulseaudio-ctl mute")
  , ((noModMask,                xF86XK_AudioLowerVolume ), spawn "pulseaudio-ctl down")
  , ((noModMask,                xF86XK_AudioRaiseVolume ), spawn "pulseaudio-ctl up")
  , ((noModMask,                xF86XK_AudioMicMute     ), spawn "pulseaudio-ctl mute-input")

  -- brightness controls
  , ((noModMask,                xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10%")
  , ((noModMask,                xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 10%")

  -- twiddle displays
  , ((noModMask,                xF86XK_Display          ), spawn "autoDetectDisplays.sh > /tmp/autoDetectDisplays.log")
  , ((myModMask .|. shiftMask,  xK_y                    ), spawn "autoDetectDisplays.sh > /tmp/autoDetectDisplays.log")

  -- switch Xft DPI setttings
  , ((myModMask .|. shiftMask,  xK_u     ), spawn "echo 'Xft.dpi: 96'  | xrdb -merge; xmonad --restart")
  , ((myModMask .|. shiftMask,  xK_i     ), spawn "echo 'Xft.dpi: 144' | xrdb -merge; xmonad --restart")
  , ((myModMask .|. shiftMask,  xK_o     ), spawn "echo 'Xft.dpi: 168' | xrdb -merge; xmonad --restart")

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

  -- reasonable X pointer and, more importantly, a background refresh
  spawn "which xsetroot > /dev/null 2>&1 && xsetroot -cursor_name left_ptr -solid Black"

  -- trayer in top left, over xmobar (launch after it), but not too intrusive on the layout (partial strut false)
  spawn "which trayer > /dev/null 2>&1 && (pkill trayer; sleep 1; trayer --edge top --align left --widthtype request --heighttype request --expand true --SetDockType true --SetPartialStrut false --transparent true --alpha 0 --tint 0x222222 &)"
  
  -- lock the screen after 5 mins, using slock as the "locker"
  spawn "which xautolock > /dev/null 2>&1 && (pkill xautolock ; xautolock -locker slock -time 5 &)"

  -- applets/system tray apps
  spawn "pkill nm-applet; nm-applet &"
  spawn "which pasystray > /dev/null 2>&1 && (pkill pasystray ; pasystray &)"


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
