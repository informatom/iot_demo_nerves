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

## Sensors

### VEML6075 UV-Sensor

* Sparkfun [Product Page](https://www.sparkfun.com/products/15089)
* 🔖 [Hookup Guide](https://learn.sparkfun.com/tutorials/qwiic-uv-sensor-veml6075-hookup-guide)

## Links

* 🔖 [Introduction to Qwiic](https://www.sparkfun.com/qwiic)
* Official Nerves docs: <https://hexdocs.pm/nerves/getting-started.html>
* Official website: <https://nerves-project.org/>
* Forum: <https://elixirforum.com/c/nerves-forum>
* Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
* Source code: <https://github.com/nerves-project/nerves>
