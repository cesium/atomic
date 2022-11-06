defmodule AtomicWeb.Hooks do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Atomic.Accounts

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :page_title, "Atomic")}
  end

  def on_mount(:current_user, _params, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)

    {:cont, assign(socket, current_user: current_user)}
  end

  def on_mount(:current_user, _params, _session, socket) do
    {:cont, socket}
  end
end
