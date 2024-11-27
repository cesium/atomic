defmodule AtomicWeb.SasumLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Sasum

  def mount(_params, _session, socket) do
    has_sasum_linked? =  Sasum.user_has_sasum_linked?(socket.assigns.current_user.id)
    if has_sasum_linked? do
      {:ok, socket}
    else
      {:ok, socket |> push_navigate(to: ~p"/sasum/link")}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket
      |>assign(:current_page, :sasum)}
  end

  def fetch_qr_code(user) do
    case Sasum.fetch_user_sasum_qr_code(user.id) do
      {:ok, qr_code} ->
        qr_code
      {:error, _} ->
        nil
    end
  end
end
