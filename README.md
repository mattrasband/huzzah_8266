# Huzzah 8266

This repository is a collection of libraries, modules, and scripts for working with the [Adafruit Huzzah 8266](https://www.adafruit.com/product/2471) running the NodeMCU firmware.

There are a lot of differences when thinking in the NodeMCU firmware mindset verses the common Arduino way.

## Use

* [luatool](https://github.com/4refr0nt/luatool): Used to load lua scripts to the device

The NodeMCU firmware is somewhat event based and cannot be written like a typical C program, meaning you do not want to do indefinite `while loops`, instead you need to schedule what you want to happen (similar to JavaScript's `setTimeout` function).  To ease this, I reworked some other's sscripts to have a slightly better interface and flow.
