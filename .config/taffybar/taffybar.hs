import           System.Taffybar

import           System.Taffybar.FreedesktopNotifications
import           System.Taffybar.MPRIS
import           System.Taffybar.SimpleClock
import           System.Taffybar.Systray
import           System.Taffybar.TaffyPager
import           System.Taffybar.Weather

import           System.Information.CPU
import           System.Information.Memory
import           System.Taffybar.Widgets.PollingBar
import           System.Taffybar.Widgets.PollingGraph

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                  , graphLabel = Just "mem"
                                  }

      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  , graphLabel = Just "cpu"
                                  }

  let clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      pager = taffyPagerNew defaultPagerConfig
      note  = notifyAreaNew defaultNotificationConfig
      mem   = pollingGraphNew memCfg 1 memCallback
      cpu   = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray  = systrayNew

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                                         -- reverse order
                                        , endWidgets   = [ tray, clock, mem, cpu ]
                                        }
