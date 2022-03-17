defmodule VEML6030.Config do
  defstruct [
    gain: :gain_1_4th,
    int_time: :it_100_ms,
    shutdown: false,
    interrupt: false
  ]

  def new, do: struct[__MODULE__]
  def new(opts), do: struct[__MODULE__, opts]

  def to_integer(config) do
    reserved = 0
    persistence_protect = 0

    <<integer::16>> = <<
      reserve::3,
      gain(config.gain)::2,
      reserved::1,
      int_time(config.int_time)::4,
      persistence_protect::2,
      reserved::2
      interrupt(config.interrupt)::1,
      shutdown(config.shutdown)::disk_log_1>>

    integer
  end
end
