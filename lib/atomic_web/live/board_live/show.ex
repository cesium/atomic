defmodule AtomicWeb.BoardLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"handle" => handle, "id" => id}, _, socket) do
    organization = Organizations.get_organization_by_handle(handle)
    user_organization = Organizations.get_user_organization!(id, [:user, :organization])

    if user_organization.organization_id == organization.id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:user_organization, user_organization)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:edit), do: "Edit Board"
end
