-- core
import System.Exit
import XMonad
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Data.Monoid

-- nix home manager
import Control.Monad (when)
import Text.Printf (printf)
import System.Posix.Process (executeFile)
import System.Info (arch,os)
import System.Environment (getArgs)
import System.FilePath ((</>))

-- hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ServerMode
import XMonad.Hooks.InsertPosition

-- actions
import XMonad.Actions.Navigation2D

-- layouts
import XMonad.Layout.ResizableTile

-- restart xmonad
compiledConfig = printf "xmonad-%s-%s" arch os
compileRestart resume =
  whenX (recompile True) $
    when resume writeStateToFile
      *> catchIO
        ( do
            dir <- getXMonadDataDir
            args <- getArgs
            executeFile (dir </> compiledConfig) False args Nothing
        )

-- function
-- hasWindowInStackArea = 

-- xmonad server mode
serverModeCommands :: [(String, X ())]
serverModeCommands = [ ("quit", io (exitWith ExitSuccess))
                     , ("restart", restart "xmonad" True)
                     , ("kill-window", kill)
                     , ("tile-window", withFocused $ windows . W.sink)
                     , ("focus-window-left", windowGo L False)
                     , ("focus-window-down", windowGo D False)
                     , ("focus-window-up", windowGo U False)
                     , ("focus-window-right", windowGo R False)
                     , ("swap-window-left", windowSwap L False)
                     , ("swap-window-down", windowSwap D False)
                     , ("swap-window-up", windowSwap U False)
                     , ("swap-window-right", windowSwap R False)
                     , ("inc-master-windows", sendMessage (IncMasterN 1))
                     , ("dec-master-windows", sendMessage (IncMasterN (-1)))
                     , ("h-expand", sendMessage Expand)
                     , ("h-shrink", sendMessage Shrink)
                     , ("v-expand", sendMessage MirrorExpand)
                     , ("v-shrink", sendMessage MirrorShrink) ]

serverModeCommands' = serverModeCommands ++ workspaceCommands ++ screenCommands
    where
        workspaceCommands = [((m ++ s), windows $f s) | s <- myWorkspaces
               , (f, m) <- [(W.view, "focus-workspace-"), (W.shift, "send-to-workspace-")]]

        screenCommands = [((m ++ show sc), screenWorkspace (fromIntegral sc) >>= flip whenJust (windows . f))
               | sc <- [0..myMaxScreenCount], (f, m) <- [(W.view, "focus-screen-"), (W.shift, "send-to-screen-")]]

-- hooks
myServerModeEventHook = serverModeEventHookCmd' $ return serverModeCommands'
insertPositionHook = insertPosition End Newer

-- bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ []
-- removed shiftMaster from mouse bindings
myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
    , ((modMask, button2), windows . W.focusWindow)
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w) ]



layout = avoidStruts $ ResizableTall 1 (3/100) (1/2) []
myMaxScreenCount = 3
myWorkspaces = map show [1 .. 9 :: Int]

main = launch $ ewmh $ docks $ withNavigation2DConfig def $ def {
  handleEventHook = handleEventHook def <> fullscreenEventHook <> myServerModeEventHook
  , manageHook =  insertPositionHook
  , modMask = mod4Mask
  , mouseBindings = myMouseBindings
  , keys = myKeys
  , layoutHook = layout
  , workspaces = myWorkspaces }
