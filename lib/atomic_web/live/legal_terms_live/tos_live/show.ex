defmodule AtomicWeb.TermsLive.Show do
  use AtomicWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :terms)
     |> assign(:page_title, gettext("Terms of Service"))}
  end
end
