defmodule VEML6075.Config do
  defstruct uv_it: :it_100_ms,
            dynamic: false,
            uv_trig: false,
            uv_av: false,
            shutdown: false

  def new, do: struct(__MODULE__)
  def new(opts), do: struct(__MODULE__, opts)

  def to_integer(config) do
    reserved = 0

    <<integer::16>> = <<
      reserved::9,
      uv_it(config.uv_it):3,
      high_dynamic(config.dynamic):1,
      uv_trig(config,uv_trig):1,
      uv_av(config.uv_av):1,
      shutdown(config.shutdown)::1
    >>

    integer
  end

  defp uv_it(:it_50_ms), do: 0b000
  defp uv_it(:it_100_ms), do: 0b001
  defp uv_it(:it_200_ms), do: 0b010
  defp uv_it(:it_400_ms), do: 0b011
  defp uv_it(:it_800_ms), do: 0b100

  # Low dynamic: false, High dynamic: true
  defp high_dynamic(true), do: 1
  defp high_dynamic(_), do: 0

  # No active force mode trigger: false, Trigger one measurement: true
  # With true, the sensor conducts one measurement every time, the host writes uv_trig = true, returns to 0 automatically
  defp uv_trig(true), do: 1
  defp uv_trig(_), do: 0

  # Activive force mode disable (normal): false, active force mode enable: true
  defp uv_av(true), do: 1
  defp uv_av(_), do: 0

  defp shutdown(true), do: 1
  defp shutdown(_), do: 0

  calibration_alpha_vis = 1.0;
  calibration_beta_vis  = 1.0;
  calibration_gamma_ir  = 1.0;
  calibration_delta_ir  = 1.0;

  uva_vis_coef_a = 2.22
  uva_ir_coef_b  = 1.33
  uvb_vis_coef_c = 2.95
  uvb_ir_coef_d = 1.75
  uva_responsibility = 0.00110
  uvb_responsibility = 0.00125

  def convert(uva_raw, uvb_raw, visible_comp, ir_comp) do
    # Calculate the simple UVIA and UVIB. These are used to calculate the UVI signal.
    uvia = uva_raw - ((uva_vis_coef_a * calibration_alpha_vis * visible_comp) / calibration_gamma_ir)
                   - ((uva_ir_coef_b  * calibration_alpha_vis * ir_comp) /  calibration_delta_ir)
    uvib = uvb_raw - ((uvb_vis_coef_c * calibration_beta_vis * visible_comp) / calibration_gamma_ir)
                   - ((uvb_ir_coef_d  * calibration_beta_vis * ir_comp) /  calibration_delta_ir)

    # Convert raw UVIA and UVIB to values scaled by the sensor responsivity
    uvia_scaled = uvia * (1.0 / calibration_alpha_vis) * uva_responsibility
    uvib_scaled = uvib * (1.0 / calibration_beta_vis) * uvb_responsibility

    # Use UVIA and UVIB to calculate the average UVI:
    uvi = (uvia_scaled + uvib_scaled) / 2.0;

    {uvia, uvib, uvi}
  end
end
