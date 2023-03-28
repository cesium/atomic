defmodule AtomicWeb.UserLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :current_user, socket.assigns.current_user)}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Edit Account")
     |> assign(:user, socket.assigns.current_user)
     |> assign(:majors, Enum.map(Accounts.list_majors(), fn m -> [key: m.name, value: m.id] end))}
  end
end
