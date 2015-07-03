-- Network Constants
SSID = "<my_ssid>"
PASS = "<my_ssid_pass>"

-- Command Constants
CMD = "main.lua" -- Set to whatever script you want to run
CMD_TIMER = 1000 -- How frequently to run the CMD, in millis.  If 0, it's only run once
MAX_WIFI_TRY = 200 -- Total number of tries before giving up on connecting.

--[[
  Run a lua script (file) on a timer (or once if no timer_millis provided or 0)
--]]
function doScript(script, timer_millis)
  timer_millis = timer_millis or 0
  if timer_millis > 0 then
    tmr.alarm(0, timer_millis, 1, function() dofile(script) end)
  else
    dofile(script)
  end
end

--[[
  Connect to a given WiFi network
--]]
function connectToWiFi(ssid, pass)
  wifi.setmode(wifi.STATION)
  wifi.sta.config(ssid, pass)
end

--[[
  Wait on a connection to the WiFi network, after this has been
  established, run the onConnect() callback.
  Connections will be retried every 2500ms and eventually give up
  if the connection is not established.
--]]
function checkWiFi(onConnect, max_retries, try_count)
  max_retries = max_retries or MAX_WIFI_TRY
  try_count = try_count or 0

  if (try_count > max_retries) then
    print("Unable to connect to the network.")
  else
    ip = wifi.sta.getip()
    if ((ip ~= nil) and (ip ~= "0.0.0.0")) then
      -- Connection was established, run the callback asap
      tmr.alarm(1, 500, 0, onConnect)
    else
      -- Need to retry.
      tmr.alarm(0, 2500, 0, function() checkWiFi(onConnect, max_retries, try_count + 1) end)
    end
  end
end

function main()
  print("Connecting to the WiFi network '"..SSID.."'")
  connectToWiFi(SSID, PASS)
  print("Waiting on negotation...")
  checkWiFi(function()
    print("Connected to "..SSID)
    print("IP: "..wifi.sta.getip())
    doScript(CMD, CMD_TIMER)
  end)
end

-- Do it.
main()
