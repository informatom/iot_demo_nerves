defmodule VEML6075.Comm do
  alias Circuits.I2C
  alias VEML6075.Config

  @uva_register <<7>>
  @uvb_register <<9>>
  @visible_compensation <<10>>
  @ir_compensation <<11>>

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

  def read(i2c, sensor) do
    <<uva_raw::little-16>> = I2C.write_read!(i2c, sensor, @uva_register, 2)
    <<uvb_raw::little-16>> = I2C.write_read!(i2c, sensor, @uvb_register, 2)
    <<visible_compensation::little-16>> = I2C.write_read!(i2c, sensor, @visible_compensation, 2)
    <<ir_compensation::little-16>> = I2C.write_read!(i2c, sensor, @ir_compensation, 2)

    %{uvia: uvia, uvib: uvib, uvi: uvi} =
      Config.convert(uva_raw, uvb_raw, visible_compensation, ir_compensation)

    %{
      uva_raw: uva_raw,
      uvb_raw: uvb_raw,
      visible_compensation: visible_compensation,
      ir_compensation: ir_compensation,
      uvia: uvia,
      uvib: uvib,
      uvi: uvi
    }
  end
end
