defmodule SensorHub.Application do
  use Application

  @impl true
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: SensorHub.Supervisor]

    children = [] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  def children(:host) do
    []
  end

  def children(_target) do
    [
      {SGP30, []},
      {BMP280, [i2c_address: 0x77, name: BMP280]},
      {VEML6030, %{}},
      {Finch, name: WeatherTrackerClient},
      {
        Publisher,
        %{
          sensors: sensors(),
          weather_tracker_url: weather_tracker_url()
        }
      }
    ]
  end

  def target() do
    Application.get_env(:sensor_hub, :target)
  end
end
