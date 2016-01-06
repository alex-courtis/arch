import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
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
  [ ((myModMask,                xK_p     ), spawn "dmenu_run                           -b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-11:bold'")
  -- launch j4-dmenu-desktop
  , ((myModMask .|. shiftMask,  xK_p     ), spawn "j4-dmenu-desktop --dmenu=\"dmenu -i -b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-11:bold'\"")

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
  , ((myModMask .|. shiftMask,  xK_l                    ), spawn "xautolock -locknow")

  -- take screenshots
  , ((noModMask,                xK_Print                ), spawn "sleep 0.2; cd /tmp && scrot -s -e 'xdg-open $f &'")
  , ((myModMask,                xK_Print                ), spawn "           cd /tmp && scrot    -e 'xdg-open $f &'")
  ]


-- status bar
myBar = "xmobar"
myPP = xmobarPP -- http://code.haskell.org/XMonadContrib/
  { ppSep       = "   "
  , ppTitle     = xmobarColor "green" "" . shorten 100
  }
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)


-- startup
myStartupHook = do

  -- ensure that we have a background set
  spawn "xsetroot -solid gray20"

  -- ensure that we use a reasonable pointer with Xcursor.size set
  spawn "xsetroot -cursor_name left_ptr"

  -- bad old java apps need this
  setWMName "LG3D"
  

-- layouts
myLayout = smartBorders $ Full ||| tall ||| wide
  where
     tall    = Tall nmaster delta ratio
     wide    = renamed [ Replace "Wide" ] $ Mirror tall

     -- number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100


-- misc
myModMask   = mod4Mask -- Super_L
myTerminal  = "gnome-terminal"

-- missing from Graphics.X11.ExtraTypes.XF86
xF86XK_AudioMicMute     :: KeySym
xF86XK_AudioMicMute     = 0x1008ffb2
