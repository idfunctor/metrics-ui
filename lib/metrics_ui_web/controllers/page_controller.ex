defmodule MetricsUiWeb.PageController do
  use MetricsUiWeb, :controller

  def index(conn, params) do
    greeting = params["greeting"] || "hey"
    name = params["name"] || "Aviral"
    render(conn, "index.html", name: name, greeting: greeting)
  end
end
