defmodule MetricsUi.Repo do
  use Ecto.Repo,
    otp_app: :metrics_ui,
    adapter: Ecto.Adapters.Postgres
end
