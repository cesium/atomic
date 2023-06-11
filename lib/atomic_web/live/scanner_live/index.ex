defmodule AtomicWeb.ScannerLive.Index do
  @moduledoc false

  use AtomicWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :scanner)
     |> assign(:title, "Scanner")}
  end

  @impl true
  def handle_event("scan", pathname, socket) do
    {:noreply, push_redirect(socket, to: "/#{pathname}")}
  end
end
