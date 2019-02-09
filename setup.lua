-- file: setup.lua
local module = {}

local function wifi_wait_ip()
  if wifi.sta.getip() == nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(config.WIFI_ON_CONNECT_TIMER_INDEX)
    print("\n======================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is:  " .. wifi.ap.getmac())
    print("IP is:           " .. wifi.sta.getip())
    print("RSSI is:         " .. wifi.sta.getrssi())
    print("======================================")
    app.start()
  end
end

local function wifi_start(list_aps)
    if list_aps then
        print("Got list")
        for key,value in pairs(list_aps) do
            if config.STATION_CFG and config.STATION_CFG[key] then
                wifi.setmode(wifi.STATION);
                wifi.sta.config(config.STATION_CFG[key])
                print("Connecting to " .. key .. " ...")
                tmr.alarm(config.WIFI_ON_CONNECT_TIMER_INDEX, config.WIFI_ON_CONNECT_INTERVAL_MS, tmr.ALARM_AUTO, wifi_wait_ip)
            end
        end
    else
        print("Error getting AP list")
    end
end

function module.start()
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi.sta.getap(wifi_start)
end

return module
