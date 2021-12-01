
-- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS (nextScreen, prevScreen)
import qualified XMonad.Actions.Search as S

-- Data
import Data.Monoid
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

-- Layout
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.ToggleLayouts as T

-- Util
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig


myBorderWidth :: Dimension
myBorderWidth = 1

myModMask :: KeyMask
myModMask = mod4Mask

myNormalBorderColor :: String
myNormalBorderColor = "#555555"

myFocusedBorderColor :: String
myFocusedBorderColor = "#eeeeee"

-- myPrograms
myTerminal :: String
myTerminal = "alacritty"

myEditor :: String
myEditor = myTerminal ++ " -e vim"

myBrowser :: String
myBrowser = "firefox"

-- myWorkspaces
myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- START_KEYS
myKeys :: [(String, X ())]
myKeys = 
  -- KB_GROUP XMonad
  [ ("M-C-r", spawn "xmonad --recompile")   -- Recompile XMonad
  , ("M-S-r", spawn "xmonad --restart")     -- Restart XMonad
  , ("M-S-C-r", io exitSuccess)             -- Quit XMonad
  , ("M-<Esc>", spawn "dm-tool lock")       -- Lock Session 

  -- KB_GROUP Help
  , ("M-S-/", spawn "~/.xmonad/xmonad_keys.sh")  -- Get list of keybindings

  -- KB_GROUP Launcher
  , ("M-<Return>", spawn myTerminal)                                          -- Launch the default terminal
  , ("M-b", spawn myBrowser)                                                  -- Launch the default webbrowser
  , ("M-<Space>", spawn "rofi -combi-modi drun,run -show combi -show-icons")  -- Launch the application launcher (rofi)
  , ("M-S-p", spawn "dmenu_run")                                              -- Launch the application launcher (dmenu)

  -- KB_GROUP Kill
  , ("M-q", kill)       -- Kill the focussed window
  , ("M-S-q", killAll)  -- Kill all windows in the current workspace

  -- KB_GROUP Workspaces
  , ("M-<Left>", prevScreen)
  , ("M-<Right>", nextScreen)

  -- KB_GROUP Window navigation
  , ("M-m", windows W.focusMaster)    -- Focus the master window
  , ("M-j", windows W.focusDown)      -- Focus the next window
  , ("M-k", windows W.focusUp)        -- Focus the previous window
  , ("M-S-m", windows W.swapMaster)   -- Swap the focussed window with the master window
  , ("M-S-j", windows W.swapDown)     -- Swap the focussed window with the next window
  , ("M-S-k", windows W.swapUp)       -- Swap the focussed window with the previous window

  -- KB_GROUP Floating Windows
  , ("M-f", sendMessage (T.Toggle "floats"))  -- Make focussed window floating
  , ("M-t", withFocused $ windows . W.sink)   -- Push floating window back to tiling
  , ("M-S-t", sinkAll)                        -- Push all windows back to tiling

  -- KB_GROUP Window Resizing
  , ("M-h", sendMessage Expand)   -- Expand the window height
  , ("M-l", sendMessage Shrink)   -- Shrink the window height
  , ("M-M1-h", sendMessage MirrorExpand)   -- Expand the window width
  , ("M-M1-l", sendMessage MirrorShrink)   -- Shrink the window width
  ]

-- END_KEYS

-- Mouse bindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    ]

-- Layouts
myLayout = avoidStruts $ (tiled ||| Mirror tiled ||| Full ||| Grid)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

-- Window Rules
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]

-- Event handling
myEventHook = mempty

-- Status bars and logging
myLogHook = return ()  

-- Startup hook
myStartupHook = do
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom &"

-- Main
main = do
  xmproc <- spawnPipe "xmobar -x 0 /home/tijmen/.xmobarrc"
  xmonad $ docks $ def {
    terminal            = myTerminal,
    borderWidth         = myBorderWidth,
    modMask             = myModMask,
    workspaces          = myWorkspaces,
    normalBorderColor   = myNormalBorderColor,
    focusedBorderColor  = myFocusedBorderColor,
    mouseBindings       = myMouseBindings,
    layoutHook          = spacingWithEdge 2 myLayout,
    manageHook          = myManageHook,
    handleEventHook     = myEventHook,
    logHook = myLogHook <+> dynamicLogWithPP xmobarPP {               -- XMobar settings
        ppOutput          = hPutStrLn xmproc                          -- XMobar on monitor 1
      , ppCurrent         = xmobarColor "#b48ead" "" . wrap "[" "]"   -- Current workspace
      , ppVisible         = xmobarColor "#88c0d0" ""                  -- Visible but not current workspace
      , ppHidden          = xmobarColor "#5e81ac" ""                  -- Hidden workspaces
      , ppHiddenNoWindows = xmobarColor "#5e81ac" ""                  -- Hidden workspaces (no windows)
      , ppTitle           = xmobarColor "#a3be8c" ""                  -- Title of active window
      , ppSep             = "<fc=#eeeeee> <fn=1>|</fn> </fc>"         -- Separator character
      , ppUrgent          = xmobarColor "#bf616a" "" . wrap "!" "!"   -- Urgent workspace
      , ppOrder           = \(ws:l:t:ex) -> [ws]++ex++[t]             -- Order of things in xmobar
      },
    startupHook = myStartupHook
  } `additionalKeysP` myKeys