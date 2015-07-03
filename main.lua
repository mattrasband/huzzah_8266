tmp102 = dofile("tmp102.lua")
tmp102.begin(0, 6, 7) -- id, sda, scl
print("Temperature Reading from TMP102: "..tmp102.celcius())
