defmodule AtomicWeb.CookiesLive.Show do
  use AtomicWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :cookies)
     |> assign(:page_title, gettext("Cookie Policy"))}
  end
end
