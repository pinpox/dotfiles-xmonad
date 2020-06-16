--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import           Data.Monoid
import           System.Exit
import           XMonad
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce

-- Used to show workspaces in xmobar
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.UrgencyHook
import           XMonad.Util.NamedWindows

-- For fullscreen video
import XMonad.Hooks.EwmhDesktops

-- Let pointer follow focus
import           XMonad.Actions.UpdatePointer

import           XMonad.Hooks.DynamicBars

import           XMonad.Layout.ImageButtonDecoration
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.Tabbed

import qualified Data.Map                            as M
import qualified XMonad.StackSet                     as W

-- Colors (base16-onedark)
myColorBase00  = "#282c34" -- black, background
myColorBase01  = "#353b45" -- grey 1
myColorBase02  = "#3e4451" -- grey 2
myColorBase03  = "#545862" -- grey 3
myColorBase04  = "#565c64" -- grey 4
myColorBase05  = "#abb2bf" -- white, foreground
myColorBase06  = "#b6bdca" -- grey 5
myColorBase07  = "#c8ccd4" -- grey 6
myColorBase08  = "#e06c75" -- red
myColorBase09  = "#d19a66" -- orange
myColorBase0A  = "#e5c07b" -- yellow
myColorBase0B  = "#98c379" -- green
myColorBase0C  = "#56b6c2" -- teal
myColorBase0D  = "#61afef" -- blue
myColorBase0E  = "#c678dd" -- purple
myColorBase0F  = "#be5046" -- darkred

-- Font
myFontName = "xft:Roboto Mono:size=7:antialias=true:hinting=true"

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--

------------------------------------------------------------------------
	-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

	-- launch a terminal
	[ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

	-- launch rofi
 , ((modm,               xK_p     ), spawn "rofi -show run -lines 7 -eh 1 -bw 0  -fullscreen -padding 200")

    -- launch rofi-pass
 , ((modm .|. shiftMask, xK_p     ), spawn "rofi-pass -show combi -lines 7 -eh 3 -bw 0 -matching fuzzy")

	-- close focused window
 , ((modm .|. shiftMask, xK_q     ), kill)

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
 , ((modm,               xK_m     ), windows W.focusMaster)

	-- Swap the focused window and the master window
    --, ((modm,               xK_Return), windows W.swapMaster)

	-- Swap the focused window with the next window
 , ((modm .|. shiftMask, xK_j     ), windows W.swapDown)

	-- Swap the focused window with the previous window
 , ((modm .|. shiftMask, xK_k     ), windows W.swapUp )

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
	-- , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

	-- Restart xmonad
 , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

 ]
	++
	-- mod-[1..9], Switch to workspace N
	-- mod-shift-[1..9], Move client to workspace N
	[((m .|. modm, k), windows $ f i)
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
   , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
	++
	-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
	-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
	[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
   | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
   , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
	-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

	-- mod-button1, Set the window to floating mode and move by dragging
	[
	((modm, button1), (\w -> focus w >> mouseMoveWindow w
									   >> windows W.shiftMaster))

	-- mod-button2, Raise the window to the top of the stack
 , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

	-- mod-button3, Set the window to floating mode and resize by dragging
 , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
									   >> windows W.shiftMaster))

	-- you may also bind events to the mouse scroll wheel (button4 and button5)
 ]

------------------------------------------------------------------------
	-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myTabConfig = def {
    -- Border
    activeBorderColor = myColorBase0D
  , inactiveBorderColor = myColorBase03
  , urgentBorderColor = myColorBase0F

  -- Background
  , activeColor = myColorBase0D
  , inactiveColor = myColorBase00
  , urgentColor = myColorBase08

  -- Foreground
  , activeTextColor = myColorBase00
  , inactiveTextColor = myColorBase0D
  , urgentTextColor = myColorBase00

  , fontName = myFontName
  }

myLayout = smartBorders $ avoidStruts $
		((spacing 5 $ tabbed shrinkText myTabConfig) ||| tiled ||| Mirror tiled ||| Full)
			where
				-- default tiling algorithm partitions the screen into two panes
	 tiled   = spacing 5 $ Tall nmaster delta ratio

	 -- The default number of windows in the master pane
	 nmaster = 1

	 -- Default proportion of screen occupied by master pane (aprox. golden ratio)
	 ratio   = 61/100

	 -- Percent of screen to increment by when resizing panes
	 delta   = 3/100

------------------------------------------------------------------------
	-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
	[ className =? "MPlayer"        --> doFloat
 , className =? "Gimp"           --> doFloat
 , resource  =? "desktop_window" --> doIgnore
 , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
	-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty
	<> dynStatusBarEventHook barCreator barDestroyer
	<+> fullscreenEventHook

------------------------------------------------------------------------
	-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = updatePointer (0.5, 0.5) (0, 0) >>  multiPP myPP myPP
                { ppCurrent = xmobarStrip . ppCurrent xmobarPP
                , ppExtras = map (fmap $ fmap xmobarStrip) $ ppExtras myPP
                }

------------------------------------------------------------------------
	-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
barCreator sid = let
	sid' = show $ fromEnum sid in
	spawnPipe ("xmobar --screen " ++ sid' ++ " ~/.xmonad/xmobarrc")
barDestroyer = return ()

myStartupHook = do
	spawnOnce "~/.xmonad/autostart.sh &"
	spawnOnce "nitrogen --restore &"
	spawnOnce "picom --config ~/.config/picom/picom.conf &"
	dynStatusBarStartup barCreator barDestroyer

------------------------------------------------------------------------
	-- Now run xmonad with all the defaults we set up.


myPP = xmobarPP
	{
	ppSep = "  "
	, ppExtras = [logWsMeta, logStack, logWindows]
	, ppOrder = \(ws:_:_:_:_:wins:_) -> [ws, wins]
	}

logWsMeta = do
	-- dir <- currentTopicDir myTopicConfig
	-- layout <- gets (W.layout . W.workspace . W.current . windowset)
	--liftIO $ putStrLn $ description layout
	-- let wd = if isPrefixOf "/" dir then "" else "~/"
	-- let lname = description layout
	return $ Just $ "[  ]"
logStack = do
	stack <- gets (W.stack . W.workspace . W.current . windowset)
	return . Just $ show (fmap W.up stack, fmap W.focus stack, fmap W.down stack)
logWindows = do
	stack <- gets (W.stack . W.workspace . W.current . windowset)
	names <- mapM (fmap show . getName ) $ W.integrate' stack
	urgs <- readUrgents
	let urgents = map (flip elem urgs) $ W.integrate' stack
	let focus = maybe 0 (length . W.up) stack
	return . Just . unwords . map (formatTitle focus) $ zip3 names urgents [0..]

formatTitle focus (n,u,wid) = (if u
		then urgent . xmobarStrip -- TODO just one formatting step
		else id)
	. (if focus == wid
		then wrap (white "[") (white "]") . green . unwords
		else unwords . (\t -> (grey . head) t : tail t))
	. fallback . words . shorten 50 . xmobarStrip $ n -- TODO fallback before words? need a window to reproduce this with though
	where
		fallback t = if null t then ["untitled"] else t
		green = xmobarColor "green" ""
		white = xmobarColor "white" ""
		grey = xmobarColor "grey" ""
		urgent = xmobarColor "red" "yellow"

-- Run xmonad with the settings you specify. No need to modify this.
main = do
	xmonad $ docks defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
	  -- simple stuff
		terminal           = myTerminal,
		focusFollowsMouse  = myFocusFollowsMouse,
		clickJustFocuses   = myClickJustFocuses,
		borderWidth        = myBorderWidth,
		modMask            = myModMask,
		workspaces         = myWorkspaces,
		normalBorderColor  = myColorBase04,
		focusedBorderColor = myColorBase0D,

	  -- key bindings
		keys               = myKeys,
		mouseBindings      = myMouseBindings,

	  -- hooks, layouts
		layoutHook         = myLayout,
		manageHook         = myManageHook,
		handleEventHook    = myEventHook,
		logHook            = myLogHook,
		startupHook        = myStartupHook
			   }

