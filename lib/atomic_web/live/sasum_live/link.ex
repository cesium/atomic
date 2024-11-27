defmodule AtomicWeb.SasumLive.Link do
  use AtomicWeb, :live_view

  alias Atomic.Sasum
  import AtomicWeb.Components.Forms

  def mount(_params, _session, socket) do
    has_sasum_linked? = Sasum.user_has_sasum_linked?(socket.assigns.current_user.id)

    if not has_sasum_linked? do
      form = to_form(%{}, as: "auth")
      {:ok, socket |> assign(form: form)}
    else
      {:ok, socket |> push_navigate(to: ~p"/sasum")}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :sasum)}
  end

  def handle_event("link", auth_params, socket) do
    case Sasum.link_sasum(socket.assigns.current_user.id, auth_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:success, "Successfully connected SASUM to account.")
         |> push_navigate(to: ~p"/sasum")}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Invalid credentials.")}
    end
  end
end
