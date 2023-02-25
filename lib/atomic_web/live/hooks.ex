defmodule AtomicWeb.Hooks do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Atomic.Accounts
  alias Atomic.Organizations

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :page_title, "Atomic")}
  end

  def on_mount(:current_user, _params, %{"user_token" => user_token}, socket) do
    owner = Application.get_env(:atomic, :owner)
    time_zone = get_connect_params(socket)["timezone"] || owner.time_zone
    current_user = Accounts.get_user_by_session_token(user_token)
    current_user_organizations = Organizations.list_organizations

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:current_user_organizations, current_user_organizations)
      |> assign(:time_zone, time_zone)

    {:cont, socket}
  end

  def on_mount(:current_user, _params, _session, socket) do
    {:cont, socket}
  end
end
