defmodule AtomicWeb.PrivacyLive.Show do
  use AtomicWeb, :live_view

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :privacy)
     |> assign(:page_title, gettext("Privacy Policy"))}
  end
end
