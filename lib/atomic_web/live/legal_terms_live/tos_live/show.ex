defmodule AtomicWeb.TermsLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.LegalTermsLive.Components.{Header, MainTitle, BlackBar}

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
    |> assign(
      :page_description,
      gettext(
        "Review our Terms of Service to understand the rules, responsibilities, and conditions for using our platform"
      )
    )
  end
end
