defmodule AtomicWeb.PrivacyLive.Show do
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
     |> assign(:current_page, :privacy)
     |> assign(:page_title, gettext("Privacy Policy"))}
    |> assign(
      :page_description,
      gettext(
        "Read our Privacy Policy to understand how we collect, use, and protect your personal information while ensuring data security and transparency"
      )
    )
  end
end
