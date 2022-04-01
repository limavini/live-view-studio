defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    socket = assign(socket, boats: Boats.list_boats(), type: "", prices: [])
    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def handle_event("filter", %{"prices" => prices, "type" => type}, socket) do
    params = [prices: prices, type: type]
    boats = Boats.list_boats(params)
    socket = assign(socket, params ++ [boats: boats])
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>
    <div id="filter">
      <form phx-change="filter">
        <div class="filters">
          <select name="type">
            <%= options_for_select(type_options(), @type) %>
          </select>
          <div class="prices">
            <input type="hidden" name="prices[]" value="" />
            <%= for price <- ["$", "$$", "$$$"]  do %>
              <%= price_checkbox(price: price, checked: price in @prices) %>
            <% end %>
          </div>
        </div>
      </form>

      <div class="boats">
        <%= for boat <- @boats do %>
          <div class="card">
            <img src={boat.image}>
            <div class="content">
              <div class="model">
                <%= boat.model %>
              </div>
              <div class="details">
                <span class="price">
                  <%= boat.price %>
                </span>
                <span class="type">
                  <%= boat.type %>
                </span>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp price_checkbox(assigns) do
    assigns = Enum.into(assigns, %{})
    ~H(
      <input type="checkbox" name="prices[]" value={@price}
             id={@price} checked={@checked} />
      <label for={@price}><%= @price %></label>
    )
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
