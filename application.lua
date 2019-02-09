-- file : application.lua
local module = {}

module.temp            = 0
module.temp_dec        = 0
module.humi            = 0
module.humi_dec        = 0

local function dht_polling_loop()
    print("DHT polling loop.")
    status, module.temp, module.humi, module.temp_dec, module.humi_dec = dht.read(config.DHT.PIN)
    if status == dht.OK then
        print(string.format("DHT temperature: %d.%03d; humidity: %d.%03d\r\n",
                math.floor(module.temp),
                module.temp_dec,
                math.floor(module.humi),
                module.humi_dec
        ))
    else
        print("DHT: failed to read from sensor.")
    end
end

local function dht_polling_start()
    print("DHT polling loop start.")
    tmr.alarm(config.DHT.TIMER_INDEX, config.DHT.POLLING_INTERVAL_MS, tmr.ALARM_AUTO, dht_polling_loop)
    print("DHT polling loop started.")
end

local function http_server_start()
    print("HTTP Server start.")
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(conn, payload)
            print("Received payload: " .. payload)
            conn:send(string.format("<head><title>NodeMCU Supert Test</title><meta http-equiv=\"refresh\" content=\"30\"></head><body><h1>Temperature: %d.%01d; Humidity: %d.%01d </h1></body>",
                math.floor(module.temp),
                module.temp_dec,
                math.floor(module.humi),
                module.humi_dec
            ))
        end)
        conn:on("sent", function(conn)
            conn:close()
        end)
    end)
    print("HTTP Server configured.")
end

function module.start()
    http_server_start()
    dht_polling_start()
end

return module
