# SensorHub

SensorHub is an **IOT-Demo Project Weather Station**

## Targets

* Raspberry PI 3 as target:
  `export MIX_TARGET = rpi3`
* If MIX_TARGET is unset, host project is buildt for testing.
* Documenation on [Targets](https://hexdocs.pm/nerves/targets.html#content)

## Build

* Install dependencies with `mix deps.get`
* Create firmware with `mix firmware`
* Burn to an SD card with `mix firmware.burn`
  The SD-Card Reader is properly detected.
* Upload to the device with `mix upload`

for Sensors and Links see the corresponding Wiki pages.
