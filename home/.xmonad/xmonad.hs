import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86


-- launch XMonad with a status bar and overridden configuration
main = xmonad =<< statusBar myBar myPP myToggleStrutsKey  myConfig


-- general configuration with keyboard customisation
myConfig = def
  { modMask         = myModMask
  , terminal        = myTerminal
  , startupHook     = ewmhDesktopsStartup <+> myStartupHook
  , layoutHook      = myLayout
  , handleEventHook = ewmhDesktopsEventHook <+> fullscreenEventHook
  , logHook         = ewmhDesktopsLogHook
  , manageHook      = myManageHook
  } `additionalKeys`

  -- launch dmenu
  [ ((myModMask,                xK_p     ), spawn ("dmenu_run " ++ myDmenuArgs ++ " >/dev/null 2>&1"))
  -- launch j4-dmenu-desktop
  , ((myModMask .|. shiftMask,  xK_p     ), spawn ("j4-dmenu-desktop --dmenu=\"dmenu -i " ++ myDmenuArgs ++ "\" --term=\"" ++ myTerminal ++ "\"" ++ " >/dev/null 2>&1"))

  -- launch browser
  , ((myModMask .|. shiftMask,  xK_o     ), spawn (myBrowser ++ " >/dev/null 2>&1"))

  -- volume control
  , ((noModMask,                xF86XK_AudioMute        ), spawn "xmobarPulseVolume.sh mute")
  , ((noModMask,                xF86XK_AudioLowerVolume ), spawn "xmobarPulseVolume.sh down")
  , ((noModMask,                xF86XK_AudioRaiseVolume ), spawn "xmobarPulseVolume.sh up")
  , ((noModMask,                xF86XK_AudioMicMute     ), spawn "xmobarPulseVolume.sh mute-input")

  -- brightness controls
  , ((noModMask,                xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10%")
  , ((noModMask,                xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 10%")

  -- twiddle displays
  , ((noModMask,                xF86XK_Display          ), spawn myTwiddleDisplaysCmd)
  , ((myModMask .|. shiftMask,  xK_y                    ), spawn myTwiddleDisplaysCmd)

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
  , ppTitle     = xmobarColor "green" "" . shorten 140
  }
myToggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)


-- startup
myStartupHook = do

  -- write to the named pipe for xmobar volume
  spawn "xmobarPulseVolume.sh"


-- application specific overrides; use xprop to investigate a running window
myManageHook = composeAll
   [ className =? "net-sourceforge-jnlp-runtime-Boot"   --> doFloat     -- iced tea javaws
   , className =? "Xmessage"                            --> doFloat ]


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


-- update monitor outputs and restart xmonad
myTwiddleDisplaysCmd = "xlayoutdisplay && xmonad --restart"

-- common dmenu args
myDmenuArgs = "-b -nf 'white' -sf 'yellow' -nb 'gray20' -sb 'gray30' -fn 'Monospace-10:bold'"

-- mod key of choice - super
myModMask = mod4Mask -- Super_L

-- terminal of choice
myTerminal = "alacritty"

-- browser of choice
myBrowser = "chromium"
