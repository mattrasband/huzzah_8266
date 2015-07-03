--[[
  Simple Lua module to interface with the TMP102 sensor from SparkFun.
  This script assumes that the NodeMCU version in use supports floats.
  Adapted from https://github.com/acoulson2000/ESP8266-TMP102/blob/master/tmp102.lua
--]]
local tmp102

do
  local i2c_addr = 0x48
  local i2c_reg = 0x00
  local i2c_id = 0

  -- Read the raw sensor value.
  local read = function()
    -- Request that we can get a reading
    i2c.start(i2c_id)
    i2c.address(i2c_id, i2c_addr, i2c.TRANSMITTER)
    i2c.write(i2c_id, i2c_reg)
    i2c.stop(i2c_id)

    -- Read the bytes from the sensor
    i2c.start(i2c_id)
    i2c.address(i2c_id, i2c_addr, i2c.RECEIVER)
    local data = i2c.read(i2c_id, 2)
    i2c.stop(i2c_id)

    -- Magical bit shifting to put together the read
    local msb = data:byte(1)
    local lsb = data:byte(2)
    return bit.rshift(bit.bor(bit.lshift(msb, 8), lsb), 4)
  end

  tmp102 = {
    -- Initialize the tmp102 sensor
    begin = function(id, sda, scl)
      i2c_id = id
      i2c.setup(i2c_id, sda, scl, i2c.SLOW)
    end,
    -- Read the temperature in degrees C
    celcius = function()
      return read() * 0.0625
    end
  }
end

return tmp102
