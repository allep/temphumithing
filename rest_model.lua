-- file : rest_model.lua
-- Implements the REST logic to process incoming requests and to provide
-- the corresponding replies.
local module = {}

-------------------------------------------------------------------------------
-- Thing resource
local function ManageThing(request)
    -- in this case I just need to provide the properties response

    local thingReply = [[HTTP/1.0 200 OK
Content-Type: application/json

{
    "@context": "https://iot.mozilla.org/schemas/",
    "@type": ["TemperatureSensor"],
    "name": "TempHumi",
    "description": "A WoT temperature sensor",
    "properties": {
        "temperature": {
            "@type": "TemperatureProperty",
            "title": "Temperature",
            "type": "number",
            "unit": "degree celsius",
            "readOnly": true,
            "description": "An ambient temperature sensor",
            "links": [{ "href": "/things/temphumi/properties/temperature" }]
        },
        "humidity": {
            "title": "Humidity",
            "type": "number",
            "unit": "percent",
            "readOnly": true,
            "links": [{ "href": "/things/temphumi/properties/humidity"}]
        }
    },
    "links": [
        {
            "rel": "properties",
            "href": "/things/temphumi/properties"
        },
        {
            "rel": "alternate",
            "mediaType": "text/html",
            "href": "/things/temphumi"
        }
    ]
}
]]

    return thingReply
end

-------------------------------------------------------------------------------
-- Properties resources
local function ManageTemperature(request)
    -- only GET method can be used
    local reply = ""
    if request:match("GET") then
        local temperature = string.format("%d.%03d",
            math.floor(app.temp),
            app.temp_dec)

        reply = [[HTTP/1.0 200 OK
Content-Type: application/json

{
    "temperature": ]] .. temperature .. [[

}
]]
    else
        -- other methods are not allowed
        reply = "HTTP/1.0 405 Method Not Allowed\r\n"
    end
    return reply
end

local function ManageHumidity(request)
    -- only GET method can be used
    local reply = ""
    if request:match("GET") then
        local humidity = string.format("%d.%03d",
            math.floor(app.humi),
            app.humi_dec)

        reply = [[HTTP/1.0 200 OK
Content-Type: application/json

{
    "humidity": ]] .. humidity .. [[

}
]]
    else
        -- other methods are not allowed
        reply = "HTTP/1.0 405 Method Not Allowed\r\n"
    end
    return reply
end

local function ManagePropertiesAll(request)
    -- only GET method can be used
    local reply = ""
    if request:match("GET") then
        local temperature = string.format("%d.%03d",
            math.floor(app.temp),
            app.temp_dec)

        local humidity = string.format("%d.%03d",
            math.floor(app.humi),
            app.humi_dec)

        reply = [[HTTP/1.0 200 OK
Content-Type: application/json

{
    "temperature": ]] .. temperature .. [[,
    "humidity": ]] .. humidity .. [[

}
]]
    else
        -- other methods are not allowed
        reply = "HTTP/1.0 405 Method Not Allowed\r\n"
    end
    return reply
end

local function ManageProperties(request)
    -- here we need to manage both all properties and single ones.
    -- parse request to understand what to do
    local reply = ""
    if request:match("temperature") then
        reply = ManageTemperature(request)
    elseif request:match("humidity") then
        reply = ManageHumidity(request)
    else
        reply = ManagePropertiesAll(request)
    end

    return reply
end

-------------------------------------------------------------------------------
local function ManageActions(request)
    return "Getting actions"
    -- no actions for now!
end

-------------------------------------------------------------------------------
local function ManageEvents(request)
    return "Getting events"
    -- no events for now!
end

-------------------------------------------------------------------------------
-- get reply based on REST request
function module.ManageRequest(request)
    local reply = ''
    if request:match("properties") then
        reply = ManageProperties(request)
    elseif request:match("actions") then
        reply = ManageActions(request)
    elseif request:match("events") then
        reply = ManageEvents(request)
    else
        reply = ManageThing(request)
    end

    return reply
end

-------------------------------------------------------------------------------
function module.start()
    print("Rest model started.")
end

return module
