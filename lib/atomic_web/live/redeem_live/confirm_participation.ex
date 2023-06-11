defmodule AtomicWeb.RedeemLive.ConfirmParticipation do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"activity_id" => activity_id, "user_id" => user_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:title, "Confirm participation in activity")
     |> assign(:activity, Activities.get_activity!(activity_id))
     |> assign(:user, Accounts.get_user!(user_id))
     |> assign(:enrollment, Activities.get_enrollment!(activity_id, user_id))
     |> assign(:return_to, Routes.scanner_index_path(socket, :index))
     |> assign(:participation, Activities.is_participating?(activity_id, user_id))}
  end
end
