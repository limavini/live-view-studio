defmodule LiveViewStudioWeb.SearchLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Stores

  def mount(_params, _session, socket) do
    socket = assign(socket, stores: [], loading: false, zip: "")

    {:ok, socket}
  end

  def handle_info({:search_zip, zip}, socket) do
    socket =
      Stores.search_by_zip(zip)
      |> case do
        [] ->
          socket
          |> put_flash(:info, "No stores available for \"#{zip}\" zip code")
          |> assign(loading: false, stores: [])

        stores ->
          socket
          |> assign(loading: false, stores: stores)
      end

    {:noreply, socket}
  end

  def handle_event("search-zip", %{"zip" => zip}, socket) do
    send(self(), {:search_zip, zip})
    socket = assign(socket, loading: true, stores: [])

    {:noreply, socket}
  end

  def render(assigns) do
    ~H(
      <h1>Find a Store</h1>
<div id="search">

<form phx-submit="search-zip">
    <input type="text" name="zip" value={@zip} readonly={@loading} placeholder="Zip Code" autofocus autocomplete="off"/>
    <button type="submit">
      <img src="images/search.svg">
    </button>
</form>

<%= if @loading do %>
  <div class="loader">Loading...</div>
<% end %>
  <div class="stores">
    <ul>
      <%= for store <- @stores do %>
        <li>
          <div class="first-line">
            <div class="name">
              <%= store.name %>
            </div>
            <div class="status">
              <%= if store.open do %>
                <span class="open">Open</span>
              <% else %>
                <span class="closed">Closed</span>
              <% end %>
            </div>
          </div>
          <div class="second-line">
            <div class="street">
              <img src="images/location.svg">
              <%= store.street %>
            </div>
            <div class="phone_number">
              <img src="images/phone.svg">
              <%= store.phone_number %>
            </div>
          </div>
        </li>
      <% end %>
    </ul>
  </div>
</div>)
  end
end
