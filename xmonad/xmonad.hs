import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W

import XMonad.Layout.Reflect

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/davep/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        -- , layoutHook = avoidStruts $ layoutHook defaultConfig
        , layoutHook = myLayout
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
        , modMask = mod4Mask    -- Rebind Mod to the Windows key
        , borderWidth = 5
        } `additionalKeys` myKeys

myKeys =
    [
    ]
    -- adjust physical display ordering in xmobar
    ++
    [((m .|. mod4Mask, key), screenWorkspace sc >>= flip whenJust (windows . f)) -- Replace 'mod1Mask' with your mod key of choice.
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2] -- was [0..] *** change to match your screen order ***
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

myLayout = avoidStruts
           $ tiled ||| wideTiled ||| reflectHoriz tiled ||| reflectHoriz wideTiled ||| Full
            where
                tiled = Tall nmaster delta ratio
                wideTiled = Tall nmaster delta wideRatio
                nmaster = 1
                delta = 3/100
                ratio = 1/2
                wideRatio = 2/3
