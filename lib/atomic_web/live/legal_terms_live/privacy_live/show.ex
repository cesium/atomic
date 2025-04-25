defmodule AtomicWeb.PrivacyLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.LegalTermsLive.Components.{Header, MainTitle, BlackBar}
  import AtomicWeb.LiveHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign_page_metadata(:privacy)
     |> assign(:current_page, :privacy)}
  end
end
