defmodule SensorHub.MixProject do
  use Mix.Project

  @app :sensor_hub
  @version "0.1.0"
  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :osd32mp1, :x86_64]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.13",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SensorHub.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.7.4", runtime: false},
      {:shoehorn, "~> 0.8.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},
      {:circuits_i2c, "~> 1.0"},

      # Dependencies for all targets except :host
      {:publisher, path: "../publisher", targets: @all_targets},
      {:veml6075, path: "../veml6075", targets: @all_targets},
      {:sgp30, "~> 0.2.2", targets: @all_targets},
      {:bmp280, "~> 0.2.11", targets: @all_targets},
      {:nerves_runtime, "~> 0.11.3", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi3, "~> 1.17", runtime: false, targets: :rpi3},
      {:nerves_system_rpi4, "~> 1.17", runtime: false, targets: :rpi4},
      {:nerves_system_osd32mp1, "~> 0.8", runtime: false, targets: :osd32mp1},
      {:nerves_system_x86_64, "~> 1.17", runtime: false, targets: :x86_64}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
