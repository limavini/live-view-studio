defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.QuoteComponent
  alias LiveViewStudioWeb.SandboxCalculatorComponent

  def mount(_params, _session, socket) do
    {:ok, assign(socket, weight: nil, price: nil)}
  end

  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>

    <div id="sandbox">
      <%= live_component SandboxCalculatorComponent,
                         id: 1,
                         coupon: 10.0 %>

      <%= if @weight do %>
        <%= live_component QuoteComponent,
                          material: "sand",
                          weight: @weight,
                          price: @price %>
      <% end %>
    </div>
    """
  end

  def handle_info({:totals, weight, price}, socket) do
    socket = assign(socket, weight: weight, price: price)
    {:noreply, socket}
  end
end
