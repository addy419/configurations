-- core
import XMonad
import Data.Monoid
import qualified Data.Map as M
import qualified XMonad.StackSet as W

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

-- functions
showArray = (>>= return.show)

-- xmonad server mode
serverModeCommands :: [(String, X ())]
serverModeCommands = [("restart", restart "xmonad" True)]

serverModeCommands' = serverModeCommands ++ workspaceCommands ++ screenCommands
    where
        workspaceCommands = [((m ++ s), windows $f s) | s <- myWorkspaces
               , (f, m) <- [(W.view, "focus-workspace-"), (W.shift, "send-to-workspace-")]]

        screenCommands = [((m ++ show sc), screenWorkspace (fromIntegral sc) >>= flip whenJust (windows . f))
               | sc <- [0..myMaxScreenCount], (f, m) <- [(W.view, "focus-screen-"), (W.shift, "send-to-screen-")]]

--
myServerModeEventHook = serverModeEventHookCmd' $ return serverModeCommands'
insertPositionEventHook = insertPosition End Newer


layout = avoidStruts $ Tall 1 (3/100) (1/2)
myMaxScreenCount = 3
myWorkspaces = showArray [1..9]

main = launch $ ewmh $ docks def {
  handleEventHook = handleEventHook def <> fullscreenEventHook <> myServerModeEventHook
  , manageHook = insertPositionEventHook
  , layoutHook = layout
  , workspaces = myWorkspaces }
