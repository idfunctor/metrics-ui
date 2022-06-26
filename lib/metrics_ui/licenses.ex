defmodule MetricsUiWeb.Licenses do

  def get_plans() do
    [
      %{name: "basic", cost: 12.00},
      %{name: "pro", cost: 24.00},
      %{name: "advanced", cost: 40.00}
    ]
  end

  def get_plan_cost(plan_name) do
    get_plans()
    |> Enum.find(fn m ->
      m.name == plan_name
    end)
    |> (fn found_item ->
      found_item.cost
    end).()
  end

  @spec calculate_total_price(integer, number | float) :: float
  def calculate_total_price(seats, price_per_seat) do
    if seats <= 5 do
      seats * price_per_seat
    else
      100 + (seats - 5) * (price_per_seat - price_per_seat * 0.25)
    end
  end
end
