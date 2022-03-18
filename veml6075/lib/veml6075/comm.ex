defmodule VEML6075.Comm do
  alias Circuits.I2C
  alias VEML6075.Config

  @light_register_uva <<7>>
  @light_register_uvb <<9>>
  @visible_compensation <<a>>
  @ir_compensation <<b>>

  def discover(possible_addresses \\ [0x10, 0x48]) do
    I2C.discover_one!(possible_addresses)
  end

  def open(bus_name) do
    {:ok, i2c} = I2C.open(bus_name)
    i2c
  end

  def write_config(configuration, i2c, sensor) do
    command = Config.to_integer(configuration)
    I2C.write(i2c, sensor, <<0, command::little-16>>)
  end

  def read(i2c, sensor, configuration) do
    <<uva_raw::little-16>> = I2C.write_read!(i2c, sensor, @uva_register, 2)
    <<uvb_raw::little-16>> = I2C.write_read!(i2c, sensor, @uvb_register, 2)
    <<visible_compensation::little-16>> = I2C.write_read!(i2c, sensor, @uvb_register, 2)
    <<ir_compensation::little-16>> = I2C.write_read!(i2c, sensor, @uvb_register, 2)

    Config.convert(configuration, uva_raw, uvb_raw, visible_compensation, ir_compensation)
  end
end
