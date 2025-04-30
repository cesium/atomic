defmodule AtomicWeb.TermsLive.Show do
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
     |> assign(:page_title, gettext("Terms of Service"))
     |> assign_page_metadata(:terms)
     |> assign(:current_page, :terms)}
  end
end
