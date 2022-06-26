defmodule MetricsUiWeb.PricingSliderLive do
  use MetricsUiWeb, :live_view
  require Logger
  alias MetricsUiWeb.Licenses
  import Number.Currency

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        seats: 1,
        plan_name: "basic"
      )

    {:ok, socket}
  end

  def render(assigns) do
    amount = Licenses.calculate_total_price(assigns.seats, Licenses.get_plan_cost(assigns.plan_name))

    ~L"""
      <div>
        <h1>Pricing</h1>

        <div style="display: flex; justify-content: center;">
        <%= for plan_obj <- Licenses.get_plans() do %>
          <button
            phx-click="planType"
            phx-value-plan-name="<%=plan_obj.name%>"
            class="f6 link dim br1 ph3 pv2 mr1 mb2 dib white bg-black"
          >
          <%= plan_obj.name %> ($<%= plan_obj.cost %>)
          </button>
        <% end %>
        </div>

        <p style="text-align: center;">
          Your plan is <b><%= String.upcase(@plan_name) %></b> license is currently for <b><%= @seats %></b> seats
        </p>
        <form phx-change="update">
          <input
            type="range"
            min="1"
            max="10"
            name="seats"
            value=<%= @seats %>
          />
        </form>
        <h1>Total: <%= number_to_currency(amount) %> / monthly</h1>
      </div>
    """
  end

  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)

    socket =
      assign(socket,
        seats: seats
      )

    {:noreply, socket}
  end

  def handle_event("planType", %{"plan-name" => plan_name}, socket) do
    Logger.info  "Logging this text!"
    Logger.debug "Var value: #{inspect(plan_name)}"

    socket = assign(socket, plan_name: plan_name)
    {:noreply, socket}
  end

end
