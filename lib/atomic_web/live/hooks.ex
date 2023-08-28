defmodule AtomicWeb.Hooks do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Atomic.Accounts

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :page_title, "Atomic")}
  end

  def on_mount(:current_user_state, _params, session, socket) do
    current_user = maybe_get_current_user(session)
    socket = socket |> assign(:timezone, get_timezone(socket))

    {:cont,
     socket
     |> assign(:current_user, current_user)
     |> assign(:current_organization, maybe_get_current_organization(session))
     |> assign(:is_authenticated?, !is_nil(current_user))}
  end

  defp maybe_get_current_user(session) do
    case session["user_token"] do
      nil ->
        nil

      user_token ->
        Accounts.get_user_by_session_token(user_token)
    end
  end

  defp maybe_get_current_organization(session) do
    case maybe_get_current_user(session) do
      nil ->
        nil

      current_user ->
        current_user.current_organization
    end
  end

  defp get_timezone(socket) do
    timezone = Application.get_env(:atomic, :timezone)
    get_connect_params(socket)["timezone"] || timezone
  end
end
