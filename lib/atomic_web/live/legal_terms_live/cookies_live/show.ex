defmodule AtomicWeb.CookiesLive.Show do
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
     |> assign(:current_page, :cookies)
     |> assign(:page_title, gettext("Cookie Policy"))
     |> assign(
       :page_description,
       gettext(
         "Learn how we use cookies to enhance your experience, improve functionality, and ensure a secure browsing environment."
       )
     )}
  end
end
