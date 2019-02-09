-- file : config.lua
local module = {}

module.STATION_CFG = {}

-- used to configure different possible Access Points
module.STATION_CFG["nameofyourssid"] = {}
module.STATION_CFG["nameofyourssid"].ssid  = "nameofyourssid"
module.STATION_CFG["nameofyourssid"].pwd   = "passwordofyourssid"
module.STATION_CFG["nameofyourssid"].save  = false

module.WIFI_ON_CONNECT_TIMER_INDEX = 1
module.WIFI_ON_CONNECT_INTERVAL_MS = 2500

module.ID = node.chipid()

-- dht22 configuration
module.DHT = {}
module.DHT.PIN = 1
module.DHT.POLLING_INTERVAL_MS = 20000
module.DHT.TIMER_INDEX = 2

return module
