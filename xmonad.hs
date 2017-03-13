import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86


-- launch XMonad with a status bar and overridden configuration
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig


-- general configuration with keyboard customisation
myConfig = def
  { modMask         = myModMask
  , terminal        = myTerminal
  , startupHook     = myStartupHook
  , layoutHook      = myLayout
  , handleEventHook = handleEventHook def <+> fullscreenEventHook
  } `additionalKeys`

  -- launch dmenu
  [ ((myModMask,                xK_p     ), spawn ("dmenu_run " ++ dmenuArgs))
  -- launch j4-dmenu-desktop
  , ((myModMask .|. shiftMask,  xK_p     ), spawn ("j4-dmenu-desktop --dmenu=\"dmenu -i " ++ dmenuArgs ++ "\" --term=\"urxvt\""))

  -- volume control
  , ((noModMask,                xF86XK_AudioMute        ), spawn "xmobarPulseVolume.sh mute")
  , ((noModMask,                xF86XK_AudioLowerVolume ), spawn "xmobarPulseVolume.sh down")
  , ((noModMask,                xF86XK_AudioRaiseVolume ), spawn "xmobarPulseVolume.sh up")
  , ((noModMask,                xF86XK_AudioMicMute     ), spawn "xmobarPulseVolume.sh mute-input")

  -- brightness controls
  , ((noModMask,                xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10%")
  , ((noModMask,                xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 10%")

  -- twiddle displays, restarting xmonad
  , ((noModMask,                xF86XK_Display          ), spawn twiddleDisplaysCmd)
  , ((myModMask .|. shiftMask,  xK_y                    ), spawn twiddleDisplaysCmd)

  -- lock the screen
  , ((myModMask .|. shiftMask,  xK_l                    ), spawn "xautolock -locknow")

  -- take screenshots
  , ((noModMask,                xK_Print                ), spawn "sleep 0.2; cd /tmp && scrot -s -e 'xdg-open $f &'")
  , ((myModMask,                xK_Print                ), spawn "           cd /tmp && scrot    -e 'xdg-open $f &'")
  ]


-- status bar xmobar on screen 0 (see ~/.xmobarrc) top left 95%
myBar = "xmobar -x 0"
myPP = xmobarPP -- http://code.haskell.org/XMonadContrib/
  { ppSep       = "   "
  , ppTitle     = xmobarColor "green" "" . shorten 100
  }
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)


-- startup
myStartupHook = do

  -- write to the named pipe for xmobar volume info consumption
  spawn "xmobarPulseVolume.sh"

  -- bad old java apps need this WM hint
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


-- update monitor outputs, reset trayer, then reset xmonad
twiddleDisplaysCmd = "autoDetectDisplays.sh && trayer.sh && xmonad --restart"

-- common dmenu args
dmenuArgs = "-b -nf '#000000' -nb '#aaaaaa' -fn 'Hack-11:bold'"

-- mod key of choice - super
myModMask = mod4Mask -- Super_L

-- terminal of choice
myTerminal = "urxvt"
