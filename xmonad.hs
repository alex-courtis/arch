import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import System.Exit
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


-- launch XMonad default with a status bar
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaultConfig
  { modMask         = myModMask
  , terminal        = myTerminal
  , startupHook     = myStartupHook
  , layoutHook      = myLayout
  , keys            = myKeys
  }


-- status bar
myBar = "xmobar"
myPP = xmobarPP -- http://code.haskell.org/XMonadContrib/
  { ppCurrent   = xmobarColor "green" "" . wrap "<" ">"
  , ppVisible   = xmobarColor "yellow" "" . wrap "(" ")"
  , ppSep       = " | "
  , ppTitle     = xmobarColor "green" "" . shorten 75
  }
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b) -- need to get rid of this....


-- startup
myStartupHook = do

  -- bad old java apps need this
  setWMName "LG3D"

  -- reasonable X pointer and, more importantly, a background refresh
  spawn "xsetroot -cursor_name left_ptr -solid Black"

  -- trayer in top left, over xmobar (launch after it), but not too intrusive on the layout (partial strut false)
  spawn "pkill trayer; sleep 1; trayer --edge top --align left --widthtype request --heighttype request --expand true --SetDockType true --SetPartialStrut false --transparent true --alpha 255 &"
  
  -- lock the screen after 5 mins, using slock as the "locker"
  spawn "pkill xautolock; xautolock -locker slock -time 5 &"

  -- always launch network manager
  spawn "pkill nm-applet; nm-applet &"


-- layouts
myLayout = Tall nmaster delta ratio ||| Full
  where
     -- number of windows in the master pane
     nmaster = 1

     -- proportion of screen occupied by master pane
     ratio   = 3/5 -- default 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run -fn 'Source Code Pro-10:bold'")
    -- launch j4-dmenu-desktop
    , ((modm .|. shiftMask, xK_p     ), spawn "j4-dmenu-desktop --dmenu=\"dmenu -i -fn 'Source Code Pro-10:bold'\"")

    -- switch Xft DPI setttings
    , ((modm .|. shiftMask, xK_u     ), spawn "echo 'Xft.dpi: 96' | xrdb -merge; xmonad --restart")
    , ((modm .|. shiftMask, xK_i     ), spawn "echo 'Xft.dpi: 144' | xrdb -merge; xmonad --restart")
    , ((modm .|. shiftMask, xK_o     ), spawn "echo 'Xft.dpi: 192' | xrdb -merge; xmonad --restart")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- lock the screen
    , ((modm .|. shiftMask, xK_l     ), spawn "xautolock -locknow")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    --, ((modMask .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]



-- misc
myModMask   = mod4Mask -- Super_L
myTerminal  = "gnome-terminal"
